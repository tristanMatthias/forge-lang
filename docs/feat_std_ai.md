# @std/ai — AI Package Spec

Provider-agnostic AI integration. Works with Anthropic, OpenAI, local models, OpenRouter, or anything with a compatible API. Streaming, structured outputs, tool use, conversation history, and channels — all first-class.

---

## The Simple Case

```forge
use @std.ai

let response = ai.ask("What is the capital of France?") {
  model "claude-sonnet"
}

println(response)   // Paris is the capital of France.
```

One function call. No setup. The package is configured globally or inline.

---

## Provider Configuration

```forge
use @std.ai

// Global default
ai.configure {
  provider "anthropic"
  api_key env("ANTHROPIC_API_KEY")
  default_model "claude-sonnet"
}

// Or OpenAI
ai.configure {
  provider "openai"
  api_key env("OPENAI_API_KEY")
  default_model "gpt-4o"
}

// Or local
ai.configure {
  provider "ollama"
  base_url "http://localhost:11434"
  default_model "llama3"
}

// Or OpenRouter (access everything through one key)
ai.configure {
  provider "openrouter"
  api_key env("OPENROUTER_API_KEY")
  default_model "anthropic/claude-sonnet"
}
```

---

## Streaming into Channels

This is the Forge-native way. Responses are channels.

```forge
let stream = ai.stream("Write a poem about channels") {
  model "claude-sonnet"
}

// Print tokens as they arrive
for chunk in stream {
  term.print(chunk)    // no newline — tokens flow continuously
}

// Or pipe it
ai.stream("Summarize this document", context: doc)
  |> each(term.print(it))

// Or collect into a string
let full = ai.stream("Explain quantum computing")
  |> collect
println(full)
```

`ai.stream()` returns a `channel<string>`. Everything you can do with channels works — filter, map, batch, pipe, select.

```forge
// Stream to a file
let output = fs.create("response.md")
ai.stream("Write documentation for this API", context: api_spec)
  |> each(output.append(it))

// Stream to a websocket (via HTTP package)
ai.stream("Help the user", context: conversation)
  |> each(ws.send(client_id, it))
```

---

## Structured Outputs

Forge types ARE the schema. No JSON Schema, no Pydantic. Your types go in, typed data comes out.

```forge
type WeatherReport = {
  city: string,
  temperature: float,
  conditions: string,
  humidity: int,
}

let weather = ai.ask<WeatherReport>("What's the weather in Paris?") {
  model "claude-sonnet"
}

// weather is typed — compiler knows the fields
println(`${weather.city}: ${weather.temperature}°C, ${weather.conditions}`)
```

With enums:

```forge
enum Sentiment { positive, negative, neutral }

type Analysis = {
  sentiment: Sentiment,
  confidence: float,
  keywords: List<string>,
}

let result = ai.ask<Analysis>("Analyze: I love this product!") {
  model "claude-sonnet"
}

if result.sentiment is .positive && result.confidence > 0.9 {
  println("Very positive!")
}
```

Structured streaming — fields arrive as they're generated:

```forge
type Story = {
  title: string,
  chapters: List<{heading: string, content: string}>,
}

let stream = ai.stream<Story>("Write a three chapter story about a robot") {
  model "claude-sonnet"
}

// Fields arrive incrementally
for partial in stream {
  if partial.title is string(t) {
    println(term.bold(t))
  }
  for chapter in partial.chapters {
    println(`\n## ${chapter.heading}`)
    println(chapter.content)
  }
}
```

---

## Agent Component

The big one. An `agent` is a component with tools, a system prompt, memory, and a conversation loop.

```forge
use @std.ai
use @std.fs
use @std.process

agent coder {
  model "claude-sonnet"
  temperature 0.0
  max_tokens 4096

  system_prompt {
    You are a Forge developer. Write clean, idiomatic Forge code.
    Always write tests first. Use components, pipes, and channels.
  }

  tool read_file(path: string) -> string {
    "Read a file from disk"
    fs.read(path)?
  }

  tool write_file(path: string, content: string) -> string {
    "Write content to a file"
    fs.write(path, content)?
    "written"
  }

  tool run_command(cmd: string) -> string {
    "Execute a shell command"
    let result = $"${cmd}"
    `exit ${result.code}: ${result.stdout}`
  }

  tool list_dir(path: string) -> List<string> {
    "List files in a directory"
    fs.list(path)?
  }
}
```

Using the agent:

```forge
// Single question
let answer = coder.ask("How do I read a file in Forge?")?
println(answer)

// With tool use — the agent decides when to use tools
let answer = coder.ask("Read main.fg and add error handling")?
// Agent calls read_file, modifies code, calls write_file

// Streaming
coder.stream("Explain this codebase") |> each(term.print(it))

// Structured output from an agent
type CodeReview = {
  issues: List<{file: string, line: int, severity: string, message: string}>,
  summary: string,
  score: int,
}

let review = coder.ask<CodeReview>("Review the code in src/")?
review.issues.each(i -> {
  println(`${term.yellow(i.file)}:${i.line} [${i.severity}] ${i.message}`)
})
println(`Score: ${review.score}/100`)
```

---

## Conversations

Agents maintain history within a conversation scope:

```forge
let chat = coder.conversation()

chat.say("What files are in src/?")?
// Agent uses list_dir tool, responds with file list

chat.say("Read the main.fg file")?
// Agent knows context — uses read_file("src/main.fg")

chat.say("Add error handling to the main function")?
// Agent remembers the file content, modifies it

// Access full history
chat.history.each(msg -> {
  println(`${msg.role}: ${msg.content.truncate(80)}`)
})

// Branch a conversation
let branch = chat.fork()
branch.say("Actually, use a different approach")?
// Original chat is unaffected
```

---

## Tool Definitions with Types

Tools are type-checked. The compiler generates the JSON schema from Forge types automatically.

```forge
agent support {
  model "claude-sonnet"

  // The compiler sees the function signature and generates:
  // { name: "lookup_user", parameters: { id: "string" }, returns: "User?" }
  tool lookup_user(id: string) -> User? {
    "Find a user by ID"
    Users.get(int(id))
  }

  // Complex input types work too
  tool create_ticket(data: {
    title: string,
    priority: Severity,
    assigned_to: string?,
  }) -> Ticket {
    "Create a support ticket"
    Tickets.create(data)
  }

  // Tools can use other Forge features
  tool search_docs(query: string) -> List<{title: string, snippet: string}> {
    "Search the documentation"
    let results = fs.glob("docs/**/*.md")?
      .map(path -> {
        let content = fs.read(string(path))?
        { path: string(path), content: content }
      })
      .filter(it.content.contains(query))
      .map({ title: fs.filename(it.path), snippet: it.content.truncate(200) })
    results
  }
}
```

---

## Multi-Model Orchestration

Use different models for different tasks:

```forge
// Fast model for classification, smart model for generation
let category = ai.ask<Category>("Classify this email: ${email}") {
  model "claude-haiku"    // fast and cheap
}

let response = ai.ask("Draft a reply to this ${category} email: ${email}") {
  model "claude-opus"     // thorough
}

// Or within an agent
agent router {
  model "claude-haiku"    // default: fast for routing

  tool deep_analysis(question: string) -> string {
    "For complex questions, use a more capable model"
    ai.ask(question) { model "claude-opus" }
  }
}
```

---

## Agent-to-Agent Communication via Channels

Agents can talk to each other through channels:

```forge
let tasks = channel<string>(10)
let results = channel<CodeReview>(10)

agent planner {
  model "claude-opus"
  system_prompt { You break down projects into tasks. }

  tool submit_task(task: string) -> string {
    "Submit a coding task"
    tasks <- task
    "submitted"
  }
}

agent worker {
  model "claude-sonnet"
  system_prompt { You implement coding tasks. }

  tool read_file(path: string) -> string { fs.read(path)? }
  tool write_file(path: string, content: string) -> string { fs.write(path, content)?; "done" }
}

// Planner creates tasks, worker executes them
spawn {
  planner.ask("Break down: build a user authentication system")?
}

for task in tasks {
  let result = worker.ask(`Implement this task: ${task}`)?
  println(term.green("✓") + ` ${task}`)
}
```

---

## Middleware / Interceptors

Hook into every AI call for logging, caching, rate limiting:

```forge
ai.configure {
  provider "anthropic"
  api_key env("ANTHROPIC_API_KEY")

  on before_request(req) {
    println(term.dim(`→ ${req.model}: ${req.messages.last().content.truncate(50)}`))
  }

  on after_response(res) {
    println(term.dim(`← ${res.usage.input_tokens}in/${res.usage.output_tokens}out`))
  }

  on error(err) {
    if err.status == 429 {
      println(term.yellow("rate limited, retrying..."))
      sleep(err.retry_after ?? 1s)
      retry
    }
  }

  // Cache identical requests
  cache {
    enabled true
    ttl 1h
    backend "memory"    // or "redis", "disk"
  }
}
```

---

## Image and Multimodal

```forge
// Send an image
let description = ai.ask("Describe this image") {
  model "claude-sonnet"
  image fs.read_bytes("photo.jpg")?
}

// Multiple images
let diff = ai.ask("What changed between these two screenshots?") {
  model "claude-sonnet"
  images [
    fs.read_bytes("before.png")?,
    fs.read_bytes("after.png")?,
  ]
}

// Structured output from image
type Receipt = {
  vendor: string,
  total: float,
  items: List<{name: string, price: float}>,
}

let receipt = ai.ask<Receipt>("Extract the receipt data") {
  model "claude-sonnet"
  image fs.read_bytes("receipt.jpg")?
}
```

---

## The Builder Agent (Showcase App)

Everything together:

```forge
use @std.ai
use @std.fs
use @std.process
use @std.http
use @std.channel
use @std.term

ai.configure {
  provider "anthropic"
  api_key env("ANTHROPIC_API_KEY")
}

agent forge_builder {
  model "claude-sonnet"
  temperature 0.0

  system_prompt {
    You are a Forge developer. You build applications from specs.

    Workflow:
    1. Read the spec
    2. Plan the implementation
    3. Write tests first (spec blocks)
    4. Write implementation
    5. Build and test
    6. Fix errors until green

    Use forge features to understand what's available.
    Write idiomatic Forge — components, pipes, channels, tables.
  }

  tool read(path: string) -> string {
    "Read a file"
    fs.read(path)?
  }

  tool write(path: string, content: string) -> string {
    "Write a file"
    fs.write(path, content)?
    "written"
  }

  tool build(path: string) -> string {
    "Compile a Forge file and return errors"
    let r = $"forge build ${path} --error-format=json"
    if r.code == 0 { "success" } else { r.stderr }
  }

  tool test(path: string) -> string {
    "Run tests and return results"
    let r = $"forge test ${path} --error-format=json"
    if r.code == 0 { "all tests pass" } else { r.stdout + r.stderr }
  }

  tool explain(code: string) -> string {
    "Explain a Forge error code"
    $"forge explain ${code}"
  }

  tool features() -> string {
    "List available Forge features"
    $"forge features"
  }
}

// HTTP API for submitting specs
let specs = channel<{id: string, spec: string}>(100)
let results = channel<{id: string, status: string, files: List<string>}>(100)

server :8080 {
  POST /build -> (req) {
    let id = random_id()
    specs <- { id: id, spec: req.body }
    { id: id, status: "queued" }
  }

  GET /status/:id -> (req) {
    let result = results.drain().find(it.id == req.params.id)
    result ?? { status: "pending" }
  }
}

// Process specs
specs.each(job -> {
  let s = term.spinner(`Building: ${job.spec.truncate(40)}...`)

  let chat = forge_builder.conversation()

  // TDD loop
  chat.say(`
    Build this application:
    ${job.spec}

    Start by writing tests, then implement, then build and fix until green.
  `)?

  s.done(term.green("✓") + ` ${job.id} complete`)

  let files = fs.glob("**/*.fg")?.map(string(it))
  results <- { id: job.id, status: "complete", files: files }
})
```

---

## package.toml

```toml
[package]
name = "ai"
namespace = "std"
version = "0.1.0"
description = "Provider-agnostic AI: chat, streaming, tools, structured output, agents"

[native]
library = "forge_ai"

[components.agent]
kind = "block"
context = "top_level"
body = "mixed"
```

## What the Native Library Handles

The native Rust library (`forge_ai`) is an HTTP client that speaks multiple provider protocols:

- Anthropic Messages API (streaming, tools, structured outputs)
- OpenAI Chat Completions / Responses API (streaming, function calling, structured outputs)
- Ollama API (local models)
- OpenRouter (proxied access to any model)
- Any OpenAI-compatible API (vLLM, Together, Groq, etc)

The native lib handles: HTTP requests, SSE streaming, JSON schema generation from Forge types, tool call marshaling, conversation history management, retry/rate limiting, caching.

The Forge-side (`package.fg`) handles: the `agent` component definition, tool registration, channel integration, structured output typing, middleware hooks.
