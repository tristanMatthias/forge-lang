use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::io::{BufRead, BufReader};
use std::os::raw::c_char;
use std::sync::atomic::{AtomicI64, Ordering};
use std::sync::Mutex;

// ---------------------------------------------------------------------------
// Global state
// ---------------------------------------------------------------------------

static CONFIG: Mutex<Option<AiConfig>> = Mutex::new(None);
static AGENTS: Mutex<Option<HashMap<i64, Agent>>> = Mutex::new(None);
static CONVERSATIONS: Mutex<Option<HashMap<i64, Conversation>>> = Mutex::new(None);
static STREAMS: Mutex<Option<HashMap<i64, StreamState>>> = Mutex::new(None);

static NEXT_AGENT_ID: AtomicI64 = AtomicI64::new(1);
static NEXT_CONV_ID: AtomicI64 = AtomicI64::new(1);
static NEXT_STREAM_ID: AtomicI64 = AtomicI64::new(1);

fn ensure_maps() {
    let mut agents = AGENTS.lock().unwrap();
    if agents.is_none() {
        *agents = Some(HashMap::new());
    }
    drop(agents);
    let mut convs = CONVERSATIONS.lock().unwrap();
    if convs.is_none() {
        *convs = Some(HashMap::new());
    }
    drop(convs);
    let mut streams = STREAMS.lock().unwrap();
    if streams.is_none() {
        *streams = Some(HashMap::new());
    }
}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

#[derive(Debug, Clone)]
struct AiConfig {
    provider: ProviderKind,
    api_key: String,
    default_model: String,
    base_url: String,
}

#[derive(Debug, Clone, PartialEq)]
enum ProviderKind {
    Anthropic,
    OpenAI,
    Ollama,
    OpenRouter,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Message {
    role: String,
    content: String,
}

#[derive(Debug, Clone)]
struct Agent {
    name: String,
    model: String,
    system_prompt: String,
    tools: Vec<ToolDef>,
    temperature: Option<f64>,
    max_tokens: Option<i64>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct ToolDef {
    name: String,
    description: String,
    parameters: Value,
}

#[derive(Debug, Clone)]
struct Conversation {
    agent_id: i64,
    messages: Vec<Message>,
}

struct StreamState {
    lines: Vec<String>,
    position: usize,
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

fn c_str_to_string(ptr: *const c_char) -> String {
    if ptr.is_null() {
        return String::new();
    }
    unsafe { CStr::from_ptr(ptr) }
        .to_str()
        .unwrap_or("")
        .to_string()
}

fn string_to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

fn get_config() -> AiConfig {
    let cfg = CONFIG.lock().unwrap();
    cfg.clone().unwrap_or(AiConfig {
        provider: ProviderKind::Anthropic,
        api_key: String::new(),
        default_model: "claude-sonnet-4-20250514".to_string(),
        base_url: String::new(),
    })
}

fn resolve_model(model: &str, config: &AiConfig) -> String {
    if model.is_empty() {
        config.default_model.clone()
    } else {
        model.to_string()
    }
}

fn base_url(config: &AiConfig) -> String {
    if !config.base_url.is_empty() {
        return config.base_url.clone();
    }
    match config.provider {
        ProviderKind::Anthropic => "https://api.anthropic.com".to_string(),
        ProviderKind::OpenAI => "https://api.openai.com".to_string(),
        ProviderKind::Ollama => "http://localhost:11434".to_string(),
        ProviderKind::OpenRouter => "https://openrouter.ai/api".to_string(),
    }
}

// ---------------------------------------------------------------------------
// API call implementations
// ---------------------------------------------------------------------------

fn call_anthropic(
    config: &AiConfig,
    model: &str,
    messages: &[Message],
    system: &str,
    temperature: Option<f64>,
    max_tokens: Option<i64>,
    tools: &[ToolDef],
) -> Result<String, String> {
    let url = format!("{}/v1/messages", base_url(config));

    let mut body = json!({
        "model": model,
        "max_tokens": max_tokens.unwrap_or(4096),
        "messages": messages,
    });

    if !system.is_empty() {
        body["system"] = json!(system);
    }
    if let Some(t) = temperature {
        body["temperature"] = json!(t);
    }
    if !tools.is_empty() {
        let tool_defs: Vec<Value> = tools
            .iter()
            .map(|t| {
                json!({
                    "name": t.name,
                    "description": t.description,
                    "input_schema": t.parameters,
                })
            })
            .collect();
        body["tools"] = json!(tool_defs);
    }

    let resp = ureq::post(&url)
        .set("x-api-key", &config.api_key)
        .set("anthropic-version", "2023-06-01")
        .set("content-type", "application/json")
        .send_string(&body.to_string())
        .map_err(|e| format!("anthropic request failed: {}", e))?;

    let resp_body: Value = resp
        .into_json()
        .map_err(|e| format!("anthropic response parse failed: {}", e))?;

    // Check for tool use
    if let Some(content) = resp_body["content"].as_array() {
        let mut text_parts = Vec::new();
        let mut tool_calls = Vec::new();

        for block in content {
            match block["type"].as_str() {
                Some("text") => {
                    if let Some(t) = block["text"].as_str() {
                        text_parts.push(t.to_string());
                    }
                }
                Some("tool_use") => {
                    tool_calls.push(json!({
                        "id": block["id"],
                        "name": block["name"],
                        "input": block["input"],
                    }));
                }
                _ => {}
            }
        }

        if !tool_calls.is_empty() {
            // Return tool calls as JSON for the Forge runtime to handle
            return Ok(json!({
                "__tool_calls": tool_calls,
                "text": text_parts.join(""),
            })
            .to_string());
        }

        return Ok(text_parts.join(""));
    }

    // Fallback
    Ok(resp_body["content"][0]["text"]
        .as_str()
        .unwrap_or("")
        .to_string())
}

fn call_openai_compatible(
    config: &AiConfig,
    model: &str,
    messages: &[Message],
    system: &str,
    temperature: Option<f64>,
    max_tokens: Option<i64>,
    tools: &[ToolDef],
) -> Result<String, String> {
    let url = match config.provider {
        ProviderKind::Ollama => format!("{}/v1/chat/completions", base_url(config)),
        ProviderKind::OpenRouter => format!("{}/v1/chat/completions", base_url(config)),
        _ => format!("{}/v1/chat/completions", base_url(config)),
    };

    let mut all_messages = Vec::new();
    if !system.is_empty() {
        all_messages.push(json!({"role": "system", "content": system}));
    }
    for msg in messages {
        all_messages.push(json!({"role": msg.role, "content": msg.content}));
    }

    let mut body = json!({
        "model": model,
        "messages": all_messages,
    });

    if let Some(t) = temperature {
        body["temperature"] = json!(t);
    }
    if let Some(mt) = max_tokens {
        body["max_tokens"] = json!(mt);
    }
    if !tools.is_empty() {
        let tool_defs: Vec<Value> = tools
            .iter()
            .map(|t| {
                json!({
                    "type": "function",
                    "function": {
                        "name": t.name,
                        "description": t.description,
                        "parameters": t.parameters,
                    }
                })
            })
            .collect();
        body["tools"] = json!(tool_defs);
    }

    let mut req = ureq::post(&url).set("content-type", "application/json");

    if !config.api_key.is_empty() {
        req = req.set("Authorization", &format!("Bearer {}", config.api_key));
    }

    let resp = req
        .send_string(&body.to_string())
        .map_err(|e| format!("openai request failed: {}", e))?;

    let resp_body: Value = resp
        .into_json()
        .map_err(|e| format!("openai response parse failed: {}", e))?;

    // Check for tool calls
    if let Some(tool_calls) = resp_body["choices"][0]["message"]["tool_calls"].as_array() {
        if !tool_calls.is_empty() {
            let calls: Vec<Value> = tool_calls
                .iter()
                .map(|tc| {
                    json!({
                        "id": tc["id"],
                        "name": tc["function"]["name"],
                        "input": serde_json::from_str::<Value>(
                            tc["function"]["arguments"].as_str().unwrap_or("{}")
                        ).unwrap_or(json!({})),
                    })
                })
                .collect();

            let text = resp_body["choices"][0]["message"]["content"]
                .as_str()
                .unwrap_or("");

            return Ok(json!({
                "__tool_calls": calls,
                "text": text,
            })
            .to_string());
        }
    }

    Ok(resp_body["choices"][0]["message"]["content"]
        .as_str()
        .unwrap_or("")
        .to_string())
}

fn call_ai(
    config: &AiConfig,
    model: &str,
    messages: &[Message],
    system: &str,
    temperature: Option<f64>,
    max_tokens: Option<i64>,
    tools: &[ToolDef],
) -> Result<String, String> {
    match config.provider {
        ProviderKind::Anthropic => {
            call_anthropic(config, model, messages, system, temperature, max_tokens, tools)
        }
        _ => {
            call_openai_compatible(config, model, messages, system, temperature, max_tokens, tools)
        }
    }
}

// ---------------------------------------------------------------------------
// Streaming
// ---------------------------------------------------------------------------

fn stream_anthropic(
    config: &AiConfig,
    model: &str,
    messages: &[Message],
    system: &str,
) -> Result<Vec<String>, String> {
    let url = format!("{}/v1/messages", base_url(config));

    let mut body = json!({
        "model": model,
        "max_tokens": 4096,
        "messages": messages,
        "stream": true,
    });

    if !system.is_empty() {
        body["system"] = json!(system);
    }

    let resp = ureq::post(&url)
        .set("x-api-key", &config.api_key)
        .set("anthropic-version", "2023-06-01")
        .set("content-type", "application/json")
        .send_string(&body.to_string())
        .map_err(|e| format!("anthropic stream failed: {}", e))?;

    let reader = BufReader::new(resp.into_reader());
    let mut chunks = Vec::new();

    for line in reader.lines() {
        let line = line.map_err(|e| format!("stream read error: {}", e))?;
        if line.starts_with("data: ") {
            let data = &line[6..];
            if data == "[DONE]" {
                break;
            }
            if let Ok(parsed) = serde_json::from_str::<Value>(data) {
                if parsed["type"] == "content_block_delta" {
                    if let Some(text) = parsed["delta"]["text"].as_str() {
                        chunks.push(text.to_string());
                    }
                }
            }
        }
    }

    Ok(chunks)
}

fn stream_openai_compatible(
    config: &AiConfig,
    model: &str,
    messages: &[Message],
    system: &str,
) -> Result<Vec<String>, String> {
    let url = match config.provider {
        ProviderKind::Ollama => format!("{}/v1/chat/completions", base_url(config)),
        ProviderKind::OpenRouter => format!("{}/v1/chat/completions", base_url(config)),
        _ => format!("{}/v1/chat/completions", base_url(config)),
    };

    let mut all_messages = Vec::new();
    if !system.is_empty() {
        all_messages.push(json!({"role": "system", "content": system}));
    }
    for msg in messages {
        all_messages.push(json!({"role": msg.role, "content": msg.content}));
    }

    let body = json!({
        "model": model,
        "messages": all_messages,
        "stream": true,
    });

    let mut req = ureq::post(&url).set("content-type", "application/json");

    if !config.api_key.is_empty() {
        req = req.set("Authorization", &format!("Bearer {}", config.api_key));
    }

    let resp = req
        .send_string(&body.to_string())
        .map_err(|e| format!("openai stream failed: {}", e))?;

    let reader = BufReader::new(resp.into_reader());
    let mut chunks = Vec::new();

    for line in reader.lines() {
        let line = line.map_err(|e| format!("stream read error: {}", e))?;
        if line.starts_with("data: ") {
            let data = &line[6..];
            if data == "[DONE]" {
                break;
            }
            if let Ok(parsed) = serde_json::from_str::<Value>(data) {
                if let Some(text) = parsed["choices"][0]["delta"]["content"].as_str() {
                    chunks.push(text.to_string());
                }
            }
        }
    }

    Ok(chunks)
}

fn stream_ai(
    config: &AiConfig,
    model: &str,
    messages: &[Message],
    system: &str,
) -> Result<Vec<String>, String> {
    match config.provider {
        ProviderKind::Anthropic => stream_anthropic(config, model, messages, system),
        _ => stream_openai_compatible(config, model, messages, system),
    }
}

// ---------------------------------------------------------------------------
// Agent tool-use loop
// ---------------------------------------------------------------------------

fn agent_ask_with_tools(
    config: &AiConfig,
    agent: &Agent,
    prompt: &str,
    tool_results_json: &str,
) -> Result<String, String> {
    let mut messages = vec![Message {
        role: "user".to_string(),
        content: prompt.to_string(),
    }];

    // If tool results are provided, parse and include them
    if !tool_results_json.is_empty() && tool_results_json != "{}" {
        if let Ok(results) = serde_json::from_str::<Value>(tool_results_json) {
            if let Some(arr) = results.as_array() {
                for result in arr {
                    // Add assistant message with tool use
                    if let Some(call_id) = result["call_id"].as_str() {
                        if config.provider == ProviderKind::Anthropic {
                            messages.push(Message {
                                role: "user".to_string(),
                                content: json!([{
                                    "type": "tool_result",
                                    "tool_use_id": call_id,
                                    "content": result["result"].as_str().unwrap_or(""),
                                }])
                                .to_string(),
                            });
                        } else {
                            messages.push(Message {
                                role: "tool".to_string(),
                                content: json!({
                                    "tool_call_id": call_id,
                                    "content": result["result"].as_str().unwrap_or(""),
                                })
                                .to_string(),
                            });
                        }
                    }
                }
            }
        }
    }

    call_ai(
        config,
        &agent.model,
        &messages,
        &agent.system_prompt,
        agent.temperature,
        agent.max_tokens,
        &agent.tools,
    )
}

// ---------------------------------------------------------------------------
// C FFI exports
// ---------------------------------------------------------------------------

/// Configure the global AI provider
#[no_mangle]
pub extern "C" fn forge_ai_configure(
    provider: *const c_char,
    api_key: *const c_char,
    default_model: *const c_char,
    base_url_ptr: *const c_char,
) {
    ensure_maps();

    let provider_str = c_str_to_string(provider);
    let api_key_str = c_str_to_string(api_key);
    let default_model_str = c_str_to_string(default_model);
    let base_url_str = c_str_to_string(base_url_ptr);

    let kind = match provider_str.to_lowercase().as_str() {
        "anthropic" => ProviderKind::Anthropic,
        "openai" => ProviderKind::OpenAI,
        "ollama" => ProviderKind::Ollama,
        "openrouter" => ProviderKind::OpenRouter,
        _ => ProviderKind::OpenAI, // default to OpenAI-compatible
    };

    let mut cfg = CONFIG.lock().unwrap();
    *cfg = Some(AiConfig {
        provider: kind,
        api_key: api_key_str,
        default_model: if default_model_str.is_empty() {
            "claude-sonnet-4-20250514".to_string()
        } else {
            default_model_str
        },
        base_url: base_url_str,
    });
}

/// Simple ask - send a prompt and get a response
#[no_mangle]
pub extern "C" fn forge_ai_ask(
    prompt: *const c_char,
    model: *const c_char,
    system: *const c_char,
    temperature: *const c_char,
    max_tokens: *const c_char,
) -> *mut c_char {
    ensure_maps();

    let prompt_str = c_str_to_string(prompt);
    let model_str = c_str_to_string(model);
    let system_str = c_str_to_string(system);
    let temp_str = c_str_to_string(temperature);
    let max_str = c_str_to_string(max_tokens);

    let config = get_config();
    let resolved_model = resolve_model(&model_str, &config);

    let temp = temp_str.parse::<f64>().ok();
    let max_tok = max_str.parse::<i64>().ok();

    let messages = vec![Message {
        role: "user".to_string(),
        content: prompt_str,
    }];

    match call_ai(&config, &resolved_model, &messages, &system_str, temp, max_tok, &[]) {
        Ok(response) => string_to_c(&response),
        Err(e) => string_to_c(&format!("error: {}", e)),
    }
}

/// Ask with an image (multimodal) — base64 encoded image data
#[no_mangle]
pub extern "C" fn forge_ai_ask_with_image(
    prompt: *const c_char,
    model: *const c_char,
    system: *const c_char,
    image_base64: *const c_char,
    media_type: *const c_char,
    temperature: *const c_char,
    max_tokens: *const c_char,
) -> *mut c_char {
    ensure_maps();

    let prompt_str = c_str_to_string(prompt);
    let model_str = c_str_to_string(model);
    let system_str = c_str_to_string(system);
    let image_b64 = c_str_to_string(image_base64);
    let media = c_str_to_string(media_type);
    let temp_str = c_str_to_string(temperature);
    let max_str = c_str_to_string(max_tokens);

    let config = get_config();
    let resolved_model = resolve_model(&model_str, &config);
    let temp = temp_str.parse::<f64>().ok();
    let max_tok = max_str.parse::<i64>().ok();

    let media_type_str = if media.is_empty() { "image/png".to_string() } else { media };

    // Build multimodal message with image
    let messages = match config.provider {
        ProviderKind::Anthropic => {
            vec![Message {
                role: "user".to_string(),
                content: json!([
                    {
                        "type": "image",
                        "source": {
                            "type": "base64",
                            "media_type": media_type_str,
                            "data": image_b64,
                        }
                    },
                    {
                        "type": "text",
                        "text": prompt_str,
                    }
                ]).to_string(),
            }]
        }
        _ => {
            // OpenAI-compatible format
            vec![Message {
                role: "user".to_string(),
                content: json!([
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": format!("data:{};base64,{}", media_type_str, image_b64),
                        }
                    },
                    {
                        "type": "text",
                        "text": prompt_str,
                    }
                ]).to_string(),
            }]
        }
    };

    match call_ai(&config, &resolved_model, &messages, &system_str, temp, max_tok, &[]) {
        Ok(response) => string_to_c(&response),
        Err(e) => string_to_c(&format!("error: {}", e)),
    }
}

/// Start a streaming response, returns a stream ID
#[no_mangle]
pub extern "C" fn forge_ai_stream_start(
    prompt: *const c_char,
    model: *const c_char,
    system: *const c_char,
) -> i64 {
    ensure_maps();

    let prompt_str = c_str_to_string(prompt);
    let model_str = c_str_to_string(model);
    let system_str = c_str_to_string(system);

    let config = get_config();
    let resolved_model = resolve_model(&model_str, &config);

    let messages = vec![Message {
        role: "user".to_string(),
        content: prompt_str,
    }];

    let chunks = match stream_ai(&config, &resolved_model, &messages, &system_str) {
        Ok(c) => c,
        Err(e) => vec![format!("error: {}", e)],
    };

    let stream_id = NEXT_STREAM_ID.fetch_add(1, Ordering::SeqCst);
    let mut streams = STREAMS.lock().unwrap();
    let map = streams.as_mut().unwrap();
    map.insert(
        stream_id,
        StreamState {
            lines: chunks,
            position: 0,
        },
    );

    stream_id
}

/// Get next chunk from a stream. Returns empty string when done.
#[no_mangle]
pub extern "C" fn forge_ai_stream_next(stream_id: i64) -> *mut c_char {
    let mut streams = STREAMS.lock().unwrap();
    let map = streams.as_mut().unwrap();

    if let Some(state) = map.get_mut(&stream_id) {
        if state.position < state.lines.len() {
            let chunk = &state.lines[state.position];
            state.position += 1;
            return string_to_c(chunk);
        }
    }

    string_to_c("")
}

/// Close and clean up a stream
#[no_mangle]
pub extern "C" fn forge_ai_stream_close(stream_id: i64) {
    let mut streams = STREAMS.lock().unwrap();
    let map = streams.as_mut().unwrap();
    map.remove(&stream_id);
}

/// Create an agent with tools
#[no_mangle]
pub extern "C" fn forge_ai_agent_create(
    name: *const c_char,
    model: *const c_char,
    system_prompt: *const c_char,
    tools_json: *const c_char,
    temperature: *const c_char,
    max_tokens: *const c_char,
) -> i64 {
    ensure_maps();

    let name_str = c_str_to_string(name);
    let model_str = c_str_to_string(model);
    let system_str = c_str_to_string(system_prompt);
    let tools_str = c_str_to_string(tools_json);
    let temp_str = c_str_to_string(temperature);
    let max_str = c_str_to_string(max_tokens);

    let config = get_config();
    let resolved_model = resolve_model(&model_str, &config);

    let tools: Vec<ToolDef> = serde_json::from_str(&tools_str).unwrap_or_default();
    let temp = temp_str.parse::<f64>().ok();
    let max_tok = max_str.parse::<i64>().ok();

    let agent_id = NEXT_AGENT_ID.fetch_add(1, Ordering::SeqCst);
    let mut agents = AGENTS.lock().unwrap();
    let map = agents.as_mut().unwrap();
    map.insert(
        agent_id,
        Agent {
            name: name_str,
            model: resolved_model,
            system_prompt: system_str,
            tools,
            temperature: temp,
            max_tokens: max_tok,
        },
    );

    agent_id
}

/// Ask an agent (with tool calling support)
#[no_mangle]
pub extern "C" fn forge_ai_agent_ask(
    agent_id: i64,
    prompt: *const c_char,
    tool_results_json: *const c_char,
) -> *mut c_char {
    let prompt_str = c_str_to_string(prompt);
    let tool_results = c_str_to_string(tool_results_json);

    let config = get_config();

    let agents = AGENTS.lock().unwrap();
    let map = agents.as_ref().unwrap();
    let agent = match map.get(&agent_id) {
        Some(a) => a.clone(),
        None => return string_to_c(&format!("error: agent {} not found", agent_id)),
    };
    drop(agents);

    match agent_ask_with_tools(&config, &agent, &prompt_str, &tool_results) {
        Ok(response) => string_to_c(&response),
        Err(e) => string_to_c(&format!("error: {}", e)),
    }
}

/// Start streaming from an agent
#[no_mangle]
pub extern "C" fn forge_ai_agent_stream(agent_id: i64, prompt: *const c_char) -> i64 {
    let prompt_str = c_str_to_string(prompt);

    let config = get_config();

    let agents = AGENTS.lock().unwrap();
    let map = agents.as_ref().unwrap();
    let agent = match map.get(&agent_id) {
        Some(a) => a.clone(),
        None => return -1,
    };
    drop(agents);

    let messages = vec![Message {
        role: "user".to_string(),
        content: prompt_str,
    }];

    let chunks =
        match stream_ai(&config, &agent.model, &messages, &agent.system_prompt) {
            Ok(c) => c,
            Err(e) => vec![format!("error: {}", e)],
        };

    let stream_id = NEXT_STREAM_ID.fetch_add(1, Ordering::SeqCst);
    let mut streams = STREAMS.lock().unwrap();
    let map = streams.as_mut().unwrap();
    map.insert(
        stream_id,
        StreamState {
            lines: chunks,
            position: 0,
        },
    );

    stream_id
}

/// Create a new conversation for an agent
#[no_mangle]
pub extern "C" fn forge_ai_conversation_create(agent_id: i64) -> i64 {
    ensure_maps();

    let conv_id = NEXT_CONV_ID.fetch_add(1, Ordering::SeqCst);
    let mut convs = CONVERSATIONS.lock().unwrap();
    let map = convs.as_mut().unwrap();
    map.insert(
        conv_id,
        Conversation {
            agent_id,
            messages: Vec::new(),
        },
    );

    conv_id
}

/// Send a message in a conversation and get a response
#[no_mangle]
pub extern "C" fn forge_ai_conversation_say(
    conv_id: i64,
    message: *const c_char,
) -> *mut c_char {
    let msg_str = c_str_to_string(message);
    let config = get_config();

    // Get conversation and agent
    let (agent_id, mut messages) = {
        let convs = CONVERSATIONS.lock().unwrap();
        let map = convs.as_ref().unwrap();
        match map.get(&conv_id) {
            Some(conv) => (conv.agent_id, conv.messages.clone()),
            None => return string_to_c(&format!("error: conversation {} not found", conv_id)),
        }
    };

    let agent = {
        let agents = AGENTS.lock().unwrap();
        let map = agents.as_ref().unwrap();
        match map.get(&agent_id) {
            Some(a) => a.clone(),
            None => return string_to_c(&format!("error: agent {} not found", agent_id)),
        }
    };

    // Add user message
    messages.push(Message {
        role: "user".to_string(),
        content: msg_str,
    });

    // Call AI with full history
    let response = match call_ai(
        &config,
        &agent.model,
        &messages,
        &agent.system_prompt,
        agent.temperature,
        agent.max_tokens,
        &agent.tools,
    ) {
        Ok(r) => r,
        Err(e) => return string_to_c(&format!("error: {}", e)),
    };

    // Add assistant response to history
    messages.push(Message {
        role: "assistant".to_string(),
        content: response.clone(),
    });

    // Update conversation
    {
        let mut convs = CONVERSATIONS.lock().unwrap();
        let map = convs.as_mut().unwrap();
        if let Some(conv) = map.get_mut(&conv_id) {
            conv.messages = messages;
        }
    }

    string_to_c(&response)
}

/// Get conversation history as JSON
#[no_mangle]
pub extern "C" fn forge_ai_conversation_history(conv_id: i64) -> *mut c_char {
    let convs = CONVERSATIONS.lock().unwrap();
    let map = convs.as_ref().unwrap();
    match map.get(&conv_id) {
        Some(conv) => {
            let json = serde_json::to_string(&conv.messages).unwrap_or("[]".to_string());
            string_to_c(&json)
        }
        None => string_to_c("[]"),
    }
}

/// Fork a conversation (create a copy with the same history)
#[no_mangle]
pub extern "C" fn forge_ai_conversation_fork(conv_id: i64) -> i64 {
    ensure_maps();

    let (agent_id, messages) = {
        let convs = CONVERSATIONS.lock().unwrap();
        let map = convs.as_ref().unwrap();
        match map.get(&conv_id) {
            Some(conv) => (conv.agent_id, conv.messages.clone()),
            None => return -1,
        }
    };

    let new_id = NEXT_CONV_ID.fetch_add(1, Ordering::SeqCst);
    let mut convs = CONVERSATIONS.lock().unwrap();
    let map = convs.as_mut().unwrap();
    map.insert(
        new_id,
        Conversation {
            agent_id,
            messages,
        },
    );

    new_id
}

// ---------------------------------------------------------------------------
// Channel-based streaming (cross-provider linking with std-channel)
// ---------------------------------------------------------------------------

// Channel functions from std-channel — resolved dynamically to avoid
// mandatory link-time dependency.  The symbols are present in the final
// binary when the user also `use @std.channel`.

type ChannelCreateFn = unsafe extern "C" fn(i64) -> i64;
type ChannelSendFn   = unsafe extern "C" fn(i64, i64);
type ChannelCloseFn  = unsafe extern "C" fn(i64);

fn resolve_channel_fns() -> Option<(ChannelCreateFn, ChannelSendFn, ChannelCloseFn)> {
    unsafe {
        let create = libc::dlsym(libc::RTLD_DEFAULT, b"forge_channel_create\0".as_ptr() as *const _);
        let send   = libc::dlsym(libc::RTLD_DEFAULT, b"forge_channel_send\0".as_ptr() as *const _);
        let close  = libc::dlsym(libc::RTLD_DEFAULT, b"forge_channel_close\0".as_ptr() as *const _);
        if create.is_null() || send.is_null() || close.is_null() {
            return None;
        }
        Some((
            std::mem::transmute(create),
            std::mem::transmute(send),
            std::mem::transmute(close),
        ))
    }
}

/// Stream AI response to a channel. Each chunk is sent as a C-string pointer
/// cast to i64. Returns the channel ID. The channel is closed when streaming completes.
/// Requires `use @std.channel` in the Forge source.
#[no_mangle]
pub extern "C" fn forge_ai_stream_to_channel(
    prompt: *const c_char,
    model: *const c_char,
    system: *const c_char,
) -> i64 {
    ensure_maps();

    let (ch_create, ch_send, ch_close) = match resolve_channel_fns() {
        Some(fns) => fns,
        None => return -1, // channel provider not linked
    };

    let prompt_str = c_str_to_string(prompt);
    let model_str = c_str_to_string(model);
    let system_str = c_str_to_string(system);

    let config = get_config();
    let resolved_model = resolve_model(&model_str, &config);

    let channel_id = unsafe { ch_create(0) };
    let ch_id = channel_id;

    std::thread::spawn(move || {
        let messages = vec![Message {
            role: "user".to_string(),
            content: prompt_str,
        }];

        match stream_ai(&config, &resolved_model, &messages, &system_str) {
            Ok(chunks) => {
                for chunk in chunks {
                    let c_str = CString::new(chunk).unwrap_or_default();
                    let ptr = c_str.into_raw();
                    unsafe { ch_send(ch_id, ptr as i64) };
                }
            }
            Err(e) => {
                let c_str = CString::new(format!("error: {}", e)).unwrap_or_default();
                let ptr = c_str.into_raw();
                unsafe { ch_send(ch_id, ptr as i64) };
            }
        }
        unsafe { ch_close(ch_id) };
    });

    channel_id
}

/// Stream agent response to a channel. Returns the channel ID.
/// Requires `use @std.channel` in the Forge source.
#[no_mangle]
pub extern "C" fn forge_ai_agent_stream_to_channel(
    agent_id: i64,
    prompt: *const c_char,
) -> i64 {
    let (ch_create, ch_send, ch_close) = match resolve_channel_fns() {
        Some(fns) => fns,
        None => return -1,
    };

    let prompt_str = c_str_to_string(prompt);
    let config = get_config();

    let agent = {
        let agents = AGENTS.lock().unwrap();
        let map = agents.as_ref().unwrap();
        match map.get(&agent_id) {
            Some(a) => a.clone(),
            None => return -1,
        }
    };

    let channel_id = unsafe { ch_create(0) };
    let ch_id = channel_id;

    std::thread::spawn(move || {
        let messages = vec![Message {
            role: "user".to_string(),
            content: prompt_str,
        }];

        match stream_ai(&config, &agent.model, &messages, &agent.system_prompt) {
            Ok(chunks) => {
                for chunk in chunks {
                    let c_str = CString::new(chunk).unwrap_or_default();
                    let ptr = c_str.into_raw();
                    unsafe { ch_send(ch_id, ptr as i64) };
                }
            }
            Err(e) => {
                let c_str = CString::new(format!("error: {}", e)).unwrap_or_default();
                let ptr = c_str.into_raw();
                unsafe { ch_send(ch_id, ptr as i64) };
            }
        }
        unsafe { ch_close(ch_id) };
    });

    channel_id
}

/// Free a string returned by the library
#[no_mangle]
pub extern "C" fn forge_ai_free_string(ptr: *mut c_char) {
    if !ptr.is_null() {
        unsafe {
            let _ = CString::from_raw(ptr);
        }
    }
}
