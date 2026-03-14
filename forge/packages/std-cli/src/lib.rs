use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::Mutex;

use serde_json::{json, Map, Value};

static CLI_STATE: Mutex<Option<CliState>> = Mutex::new(None);

struct CliState {
    schema: Value,
    values: Map<String, Value>,
    command: Option<String>,
    sub_values: Option<Map<String, Value>>,
}

fn cstr(ptr: *const c_char) -> String {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

/// Transform annotation-based schema JSON from __tpl_schema_json into CLI schema format.
/// Input: [{"name":"file","type":"string","annotations":[{"name":"arg","args":["Input file"]}]}, ...]
/// Output: {"args":[...],"flags":[...],"options":[...]}
fn transform_schema(fields: &[Value]) -> (Vec<Value>, Vec<Value>, Vec<Value>) {
    let mut args = Vec::new();
    let mut flags = Vec::new();
    let mut options = Vec::new();

    for field in fields {
        let name = field.get("name").and_then(|v| v.as_str()).unwrap_or("").to_string();
        let field_type = field.get("type").and_then(|v| v.as_str()).unwrap_or("string").to_string();
        let annotations = field.get("annotations").and_then(|v| v.as_array()).cloned().unwrap_or_default();

        // Extract annotation metadata
        let mut is_arg = false;
        let mut is_flag = false;
        let mut is_option = false;
        let mut short: Option<String> = None;
        let mut description = String::new();
        let mut default_val: Option<Value> = None;
        let mut required = true;

        for ann in &annotations {
            let ann_name = ann.get("name").and_then(|v| v.as_str()).unwrap_or("");
            let ann_args = ann.get("args").and_then(|v| v.as_array()).cloned().unwrap_or_default();

            match ann_name {
                "arg" => is_arg = true,
                "flag" => is_flag = true,
                "option" => is_option = true,
                "short" => {
                    if let Some(s) = ann_args.first().and_then(|v| v.as_str()) {
                        short = Some(s.to_string());
                    }
                }
                "description" => {
                    if let Some(d) = ann_args.first().and_then(|v| v.as_str()) {
                        description = d.to_string();
                    }
                }
                "default" => {
                    if let Some(d) = ann_args.first() {
                        default_val = Some(d.clone());
                    }
                }
                "optional" => {
                    required = false;
                }
                _ => {}
            }
        }

        // If no category annotation, infer from type
        if !is_arg && !is_flag && !is_option {
            if field_type == "bool" {
                is_flag = true;
            } else {
                is_option = true;
            }
        }

        if is_arg {
            let mut entry = json!({
                "name": name,
                "type": field_type,
                "required": required,
            });
            if !description.is_empty() {
                entry["description"] = json!(description);
            }
            args.push(entry);
        } else if is_flag {
            let mut entry = json!({
                "name": name,
            });
            if let Some(s) = &short {
                entry["short"] = json!(s);
            }
            if !description.is_empty() {
                entry["description"] = json!(description);
            }
            flags.push(entry);
        } else if is_option {
            let mut entry = json!({
                "name": name,
                "type": field_type,
            });
            if let Some(s) = &short {
                entry["short"] = json!(s);
            }
            if !description.is_empty() {
                entry["description"] = json!(description);
            }
            if let Some(d) = &default_val {
                entry["default"] = d.clone();
            }
            options.push(entry);
        }
    }

    (args, flags, options)
}

/// Setup CLI: parse env args against the schema, handle --help/--version/errors.
/// Exits the process on --help, --version, or parse errors.
/// Stores parsed result in global state for later accessor calls.
#[no_mangle]
pub extern "C" fn forge_cli_setup(
    name: *const c_char,
    version: *const c_char,
    description: *const c_char,
    schema_json: *const c_char,
) {
    let name_str = cstr(name);
    let version_str = cstr(version);
    let description_str = cstr(description);
    let schema_str = cstr(schema_json);

    // Parse the annotation-based schema
    let fields: Vec<Value> = serde_json::from_str(&schema_str).unwrap_or_default();
    let (args_schema, flags_schema, options_schema) = transform_schema(&fields);

    // Build the full schema object
    let schema = json!({
        "name": name_str,
        "version": version_str,
        "description": description_str,
        "args": args_schema,
        "flags": flags_schema,
        "options": options_schema,
    });

    // Get process args (skip binary name)
    let env_args: Vec<String> = std::env::args().skip(1).collect();

    // Parse
    let result = parse_args(&schema, &env_args);

    // Check meta flags
    if let Some(meta) = result.get("__meta") {
        if meta.get("help").and_then(|v| v.as_bool()) == Some(true) {
            print_help(&schema, None);
            std::process::exit(0);
        }
        if meta.get("version").and_then(|v| v.as_bool()) == Some(true) {
            println!("{} {}", name_str, version_str);
            std::process::exit(0);
        }
        if let Some(err) = meta.get("error").and_then(|v| v.as_str()) {
            eprintln!("error: {}", err);
            eprintln!();
            eprintln!("For more information, try '--help'");
            std::process::exit(1);
        }
    }

    // Store in global state
    let values = result.get("values").and_then(|v| v.as_object()).cloned().unwrap_or_default();
    let command = result.get("__meta")
        .and_then(|m| m.get("command"))
        .and_then(|v| v.as_str())
        .map(|s| s.to_string());
    let sub_values = result.get("sub")
        .and_then(|v| v.as_object())
        .and_then(|o| o.get("values"))
        .and_then(|v| v.as_object())
        .cloned();

    let mut state = CLI_STATE.lock().unwrap();
    *state = Some(CliState {
        schema,
        values,
        command,
        sub_values,
    });
}

fn parse_args(schema: &Value, args: &[String]) -> Value {
    let flags_schema = schema.get("flags").and_then(|v| v.as_array()).cloned().unwrap_or_default();
    let options_schema = schema.get("options").and_then(|v| v.as_array()).cloned().unwrap_or_default();
    let args_schema = schema.get("args").and_then(|v| v.as_array()).cloned().unwrap_or_default();
    let commands_schema = schema.get("commands").and_then(|v| v.as_array()).cloned().unwrap_or_default();

    let mut values = Map::new();
    let mut meta = Map::new();
    meta.insert("help".into(), json!(false));
    meta.insert("version".into(), json!(false));
    meta.insert("error".into(), json!(null));
    meta.insert("command".into(), json!(null));

    // Set defaults for flags (all false)
    for f in &flags_schema {
        if let Some(name) = f.get("name").and_then(|v| v.as_str()) {
            values.insert(name.into(), json!(false));
        }
    }
    // Set defaults for options
    for o in &options_schema {
        if let Some(name) = o.get("name").and_then(|v| v.as_str()) {
            if let Some(default) = o.get("default") {
                values.insert(name.into(), default.clone());
            } else {
                values.insert(name.into(), json!(""));
            }
        }
    }

    let mut positional_idx = 0;
    let mut i = 0;
    let mut sub_result: Option<Value> = None;

    while i < args.len() {
        let arg = &args[i];

        if arg == "--help" || arg == "-h" {
            meta.insert("help".into(), json!(true));
            return json!({"__meta": meta, "values": values, "sub": null});
        }

        if arg == "--version" || arg == "-V" {
            meta.insert("version".into(), json!(true));
            return json!({"__meta": meta, "values": values, "sub": null});
        }

        // Check subcommand
        if !arg.starts_with('-') && positional_idx == 0 {
            let cmd_match = commands_schema.iter().find(|c| {
                c.get("name").and_then(|v| v.as_str()) == Some(arg.as_str())
            });
            if let Some(cmd) = cmd_match {
                meta.insert("command".into(), json!(arg));
                let sub_schema = cmd.get("schema").cloned().unwrap_or(json!({}));
                sub_result = Some(parse_args(&sub_schema, &args[i+1..]));
                break;
            }
        }

        if arg.starts_with("--") {
            let flag_name = &arg[2..];

            let (lookup_name, is_negated) = if flag_name.starts_with("no-") {
                (&flag_name[3..], true)
            } else {
                (flag_name, false)
            };

            // Check flags
            let is_flag = flags_schema.iter().any(|f| {
                f.get("name").and_then(|v| v.as_str()) == Some(lookup_name)
            });
            if is_flag {
                values.insert(lookup_name.into(), json!(!is_negated));
                i += 1;
                continue;
            }

            // Check options (--name=value or --name value)
            let (opt_name, opt_val) = if let Some(eq_pos) = flag_name.find('=') {
                (&flag_name[..eq_pos], Some(flag_name[eq_pos+1..].to_string()))
            } else {
                (flag_name, None)
            };

            let opt_match = options_schema.iter().find(|o| {
                o.get("name").and_then(|v| v.as_str()) == Some(opt_name)
            });
            if let Some(opt) = opt_match {
                let val = if let Some(v) = opt_val {
                    v
                } else if i + 1 < args.len() {
                    i += 1;
                    args[i].clone()
                } else {
                    meta.insert("error".into(), json!(format!("missing value for --{}", opt_name)));
                    return json!({"__meta": meta, "values": values, "sub": null});
                };

                let opt_type = opt.get("type").and_then(|v| v.as_str()).unwrap_or("string");
                let typed_val = match opt_type {
                    "int" => val.parse::<i64>().map(|v| json!(v)).unwrap_or(json!(val)),
                    "float" => val.parse::<f64>().map(|v| json!(v)).unwrap_or(json!(val)),
                    _ => json!(val),
                };
                values.insert(opt_name.into(), typed_val);
                i += 1;
                continue;
            }

            // Unknown -- find closest match
            let all_names: Vec<&str> = flags_schema.iter()
                .chain(options_schema.iter())
                .filter_map(|f| f.get("name").and_then(|v| v.as_str()))
                .collect();
            let suggestion = find_closest(opt_name, &all_names);
            let msg = if let Some(s) = suggestion {
                format!("unknown option: --{}. Did you mean --{}?", opt_name, s)
            } else {
                format!("unknown option: --{}", opt_name)
            };
            meta.insert("error".into(), json!(msg));
            return json!({"__meta": meta, "values": values, "sub": null});
        } else if arg.starts_with('-') && arg.len() > 1 {
            // Short flags: -v, -o value, or bundled -vrf
            let chars: Vec<char> = arg[1..].chars().collect();
            let mut j = 0;
            while j < chars.len() {
                let ch = chars[j];
                let ch_str = ch.to_string();

                let flag_match = flags_schema.iter().find(|f| {
                    f.get("short").and_then(|v| v.as_str()) == Some(&ch_str)
                });
                if let Some(flag) = flag_match {
                    let name = flag.get("name").and_then(|v| v.as_str()).unwrap_or("");
                    values.insert(name.into(), json!(true));
                    j += 1;
                    continue;
                }

                let opt_match = options_schema.iter().find(|o| {
                    o.get("short").and_then(|v| v.as_str()) == Some(&ch_str)
                });
                if let Some(opt) = opt_match {
                    let name = opt.get("name").and_then(|v| v.as_str()).unwrap_or("");
                    let val = if j + 1 < chars.len() {
                        chars[j+1..].iter().collect::<String>()
                    } else if i + 1 < args.len() {
                        i += 1;
                        args[i].clone()
                    } else {
                        meta.insert("error".into(), json!(format!("missing value for -{}", ch)));
                        return json!({"__meta": meta, "values": values, "sub": null});
                    };
                    let opt_type = opt.get("type").and_then(|v| v.as_str()).unwrap_or("string");
                    let typed_val = match opt_type {
                        "int" => val.parse::<i64>().map(|v| json!(v)).unwrap_or(json!(val)),
                        "float" => val.parse::<f64>().map(|v| json!(v)).unwrap_or(json!(val)),
                        _ => json!(val),
                    };
                    values.insert(name.into(), typed_val);
                    break;
                }

                meta.insert("error".into(), json!(format!("unknown flag: -{}", ch)));
                return json!({"__meta": meta, "values": values, "sub": null});
            }
            i += 1;
        } else {
            // Positional argument
            if positional_idx < args_schema.len() {
                let arg_def = &args_schema[positional_idx];
                let name = arg_def.get("name").and_then(|v| v.as_str()).unwrap_or("arg");
                let arg_type = arg_def.get("type").and_then(|v| v.as_str()).unwrap_or("string");
                let typed_val = match arg_type {
                    "int" => arg.parse::<i64>().map(|v| json!(v)).unwrap_or(json!(arg)),
                    "float" => arg.parse::<f64>().map(|v| json!(v)).unwrap_or(json!(arg)),
                    _ => json!(arg),
                };
                values.insert(name.into(), typed_val);
                positional_idx += 1;
            } else {
                meta.insert("error".into(), json!(format!("unexpected argument: {}", arg)));
                return json!({"__meta": meta, "values": values, "sub": null});
            }
            i += 1;
        }
    }

    // Check required args
    for (idx, arg_def) in args_schema.iter().enumerate() {
        let required = arg_def.get("required").and_then(|v| v.as_bool()).unwrap_or(true);
        let name = arg_def.get("name").and_then(|v| v.as_str()).unwrap_or("arg");
        if required && idx >= positional_idx && !values.contains_key(name) {
            if meta.get("command").and_then(|v| v.as_str()).is_none() {
                meta.insert("error".into(), json!(format!("missing required argument: <{}>", name)));
                return json!({"__meta": meta, "values": values, "sub": null});
            }
        }
    }

    json!({
        "__meta": meta,
        "values": values,
        "sub": sub_result.unwrap_or(json!(null))
    })
}

// ── Accessor functions (read from global state) ──

#[no_mangle]
pub extern "C" fn forge_cli_get_string(key: *const c_char) -> *mut c_char {
    let key_str = cstr(key);
    let state = CLI_STATE.lock().unwrap();
    let val = state.as_ref()
        .and_then(|s| s.values.get(&key_str))
        .and_then(|v| v.as_str())
        .unwrap_or("");
    to_c(val)
}

#[no_mangle]
pub extern "C" fn forge_cli_get_int(key: *const c_char) -> i64 {
    let key_str = cstr(key);
    let state = CLI_STATE.lock().unwrap();
    state.as_ref()
        .and_then(|s| s.values.get(&key_str))
        .and_then(|v| v.as_i64())
        .unwrap_or(0)
}

#[no_mangle]
pub extern "C" fn forge_cli_get_bool(key: *const c_char) -> i64 {
    let key_str = cstr(key);
    let state = CLI_STATE.lock().unwrap();
    match state.as_ref().and_then(|s| s.values.get(&key_str)) {
        Some(Value::Bool(b)) => if *b { 1 } else { 0 },
        Some(Value::Number(n)) => if n.as_i64().unwrap_or(0) != 0 { 1 } else { 0 },
        _ => 0,
    }
}

#[no_mangle]
pub extern "C" fn forge_cli_get_command() -> *mut c_char {
    let state = CLI_STATE.lock().unwrap();
    let cmd = state.as_ref()
        .and_then(|s| s.command.as_deref())
        .unwrap_or("");
    to_c(cmd)
}

// ── Help formatter ──

fn print_help(schema: &Value, parent_name: Option<&str>) {
    let name = schema.get("name").and_then(|v| v.as_str()).unwrap_or("app");
    let version = schema.get("version").and_then(|v| v.as_str()).unwrap_or("");
    let description = schema.get("description").and_then(|v| v.as_str()).unwrap_or("");

    let display_name = if let Some(parent) = parent_name {
        format!("{} {}", parent, name)
    } else {
        name.to_string()
    };

    if !version.is_empty() && parent_name.is_none() {
        println!("{} {}", display_name, version);
    }
    if !description.is_empty() {
        println!("{}", description);
    }
    println!();

    let args = schema.get("args").and_then(|v| v.as_array());
    let commands = schema.get("commands").and_then(|v| v.as_array());
    let flags = schema.get("flags").and_then(|v| v.as_array());
    let options = schema.get("options").and_then(|v| v.as_array());

    let has_commands = commands.map_or(false, |c| !c.is_empty());
    let has_options = flags.map_or(false, |f| !f.is_empty()) || options.map_or(false, |o| !o.is_empty());

    print!("USAGE: {}", display_name);
    if has_commands {
        print!(" <COMMAND>");
    }
    if has_options {
        print!(" [OPTIONS]");
    }
    if let Some(args_list) = args {
        for a in args_list {
            let arg_name = a.get("name").and_then(|v| v.as_str()).unwrap_or("arg");
            let required = a.get("required").and_then(|v| v.as_bool()).unwrap_or(true);
            if required {
                print!(" <{}>", arg_name.to_uppercase());
            } else {
                print!(" [{}]", arg_name.to_uppercase());
            }
        }
    }
    println!();
    println!();

    if let Some(args_list) = args {
        if !args_list.is_empty() {
            println!("ARGUMENTS:");
            for a in args_list {
                let arg_name = a.get("name").and_then(|v| v.as_str()).unwrap_or("arg");
                let desc = a.get("description").and_then(|v| v.as_str()).unwrap_or("");
                println!("  {:20} {}", format!("<{}>", arg_name.to_uppercase()), desc);
            }
            println!();
        }
    }

    if let Some(cmds) = commands {
        if !cmds.is_empty() {
            println!("COMMANDS:");
            for cmd in cmds {
                let cmd_name = cmd.get("name").and_then(|v| v.as_str()).unwrap_or("");
                let desc = cmd.get("description").and_then(|v| v.as_str()).unwrap_or("");
                println!("  {:20} {}", cmd_name, desc);
            }
            println!();
        }
    }

    if has_options {
        println!("OPTIONS:");
        if let Some(flags_list) = flags {
            for f in flags_list {
                let name = f.get("name").and_then(|v| v.as_str()).unwrap_or("");
                let short = f.get("short").and_then(|v| v.as_str());
                let desc = f.get("description").and_then(|v| v.as_str()).unwrap_or("");
                let flag_str = if let Some(s) = short {
                    format!("-{}, --{}", s, name)
                } else {
                    format!("    --{}", name)
                };
                println!("  {:20} {}", flag_str, desc);
            }
        }
        if let Some(opts_list) = options {
            for o in opts_list {
                let name = o.get("name").and_then(|v| v.as_str()).unwrap_or("");
                let short = o.get("short").and_then(|v| v.as_str());
                let desc = o.get("description").and_then(|v| v.as_str()).unwrap_or("");
                let default = o.get("default");
                let opt_str = if let Some(s) = short {
                    format!("-{}, --{} <{}>", s, name, name.to_uppercase())
                } else {
                    format!("    --{} <{}>", name, name.to_uppercase())
                };
                let full_desc = if let Some(d) = default {
                    format!("{} [default: {}]", desc, d)
                } else {
                    desc.to_string()
                };
                println!("  {:20} {}", opt_str, full_desc);
            }
        }
        println!("  {:20} {}", "-h, --help", "Show help");
        println!("  {:20} {}", "-V, --version", "Show version");
        println!();
    }
}

// ── Fuzzy matching ──

fn levenshtein(a: &str, b: &str) -> usize {
    let a_len = a.len();
    let b_len = b.len();
    if a_len == 0 { return b_len; }
    if b_len == 0 { return a_len; }

    let mut prev: Vec<usize> = (0..=b_len).collect();
    let mut curr = vec![0; b_len + 1];

    for (i, ca) in a.chars().enumerate() {
        curr[0] = i + 1;
        for (j, cb) in b.chars().enumerate() {
            let cost = if ca == cb { 0 } else { 1 };
            curr[j + 1] = (prev[j] + cost)
                .min(curr[j] + 1)
                .min(prev[j + 1] + 1);
        }
        std::mem::swap(&mut prev, &mut curr);
    }
    prev[b_len]
}

fn find_closest<'a>(target: &str, candidates: &[&'a str]) -> Option<&'a str> {
    let mut best: Option<(&str, usize)> = None;
    for &c in candidates {
        let dist = levenshtein(target, c);
        if dist <= 3 {
            if best.is_none() || dist < best.unwrap().1 {
                best = Some((c, dist));
            }
        }
    }
    best.map(|(s, _)| s)
}
