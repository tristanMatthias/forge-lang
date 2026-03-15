use std::collections::{HashMap, HashSet};
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::Mutex;

// ── Data types ──────────────────────────────────────────────────────

#[derive(Debug, Clone)]
struct Flag {
    name: String,
    short: String,
    description: String,
}

#[derive(Debug, Clone)]
struct Opt {
    name: String,
    short: String,
    description: String,
    default: String,
}

#[derive(Debug, Clone)]
struct Arg {
    name: String,
    description: String,
    required: bool,
}

#[derive(Debug, Clone)]
struct Command {
    name: String,
    description: String,
    commands: Vec<Command>,
    flags: Vec<Flag>,
    options: Vec<Opt>,
    args: Vec<Arg>,
}

impl Command {
    fn new(name: &str, description: &str) -> Self {
        Self {
            name: name.to_string(),
            description: description.to_string(),
            commands: Vec::new(),
            flags: Vec::new(),
            options: Vec::new(),
            args: Vec::new(),
        }
    }

    fn find_command(&self, name: &str) -> Option<&Command> {
        self.commands.iter().find(|c| c.name == name)
    }

    fn find_option(&self, name: &str) -> Option<&Opt> {
        let norm = normalize(name);
        self.options.iter().find(|o| normalize(&o.name) == norm || (!o.short.is_empty() && o.short == name))
    }
}

struct CliState {
    root: Command,
    version: String,
    /// Stack of indices for building the tree
    stack: Vec<usize>,
    /// Parsed result
    matched_path: Vec<String>,
    values: HashMap<String, String>,
    set_flags: HashSet<String>,
    /// Command handlers: dot-path → function pointer
    handlers: HashMap<String, extern "C" fn() -> i64>,
}

static STATE: Mutex<Option<CliState>> = Mutex::new(None);

// ── Helpers ─────────────────────────────────────────────────────────

fn cstr(ptr: *const c_char) -> String {
    if ptr.is_null() { return String::new(); }
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

fn normalize(name: &str) -> String {
    name.replace('-', "_")
}

fn display(name: &str) -> String {
    name.replace('_', "-")
}

fn current_command(state: &mut CliState) -> &mut Command {
    let mut cmd = &mut state.root;
    for &idx in &state.stack {
        cmd = &mut cmd.commands[idx];
    }
    cmd
}

// ── Registration API (called during startup) ────────────────────────

#[no_mangle]
pub extern "C" fn forge_cli_begin(name: *const c_char, description: *const c_char, version: *const c_char) {
    let mut guard = STATE.lock().unwrap();
    *guard = Some(CliState {
        root: Command::new(&cstr(name), &cstr(description)),
        version: cstr(version),
        stack: Vec::new(),
        matched_path: Vec::new(),
        values: HashMap::new(),
        set_flags: HashSet::new(),
        handlers: HashMap::new(),
    });
}

#[no_mangle]
pub extern "C" fn forge_cli_push_command(name: *const c_char, description: *const c_char) {
    let mut guard = STATE.lock().unwrap();
    let state = guard.as_mut().expect("forge_cli_begin not called");
    let cmd = Command::new(&cstr(name), &cstr(description));
    let parent = current_command(state);
    parent.commands.push(cmd);
    let idx = parent.commands.len() - 1;
    state.stack.push(idx);
}

#[no_mangle]
pub extern "C" fn forge_cli_add_flag(name: *const c_char, short: *const c_char, description: *const c_char) {
    let mut guard = STATE.lock().unwrap();
    let state = guard.as_mut().expect("forge_cli_begin not called");
    let cmd = current_command(state);
    cmd.flags.push(Flag {
        name: cstr(name),
        short: cstr(short),
        description: cstr(description),
    });
}

#[no_mangle]
pub extern "C" fn forge_cli_add_option(name: *const c_char, short: *const c_char, description: *const c_char, default: *const c_char) {
    let mut guard = STATE.lock().unwrap();
    let state = guard.as_mut().expect("forge_cli_begin not called");
    let cmd = current_command(state);
    cmd.options.push(Opt {
        name: cstr(name),
        short: cstr(short),
        description: cstr(description),
        default: cstr(default),
    });
}

#[no_mangle]
pub extern "C" fn forge_cli_add_arg(name: *const c_char, description: *const c_char, required: i64) {
    let mut guard = STATE.lock().unwrap();
    let state = guard.as_mut().expect("forge_cli_begin not called");
    let cmd = current_command(state);
    cmd.args.push(Arg {
        name: cstr(name),
        description: cstr(description),
        required: required != 0,
    });
}

#[no_mangle]
pub extern "C" fn forge_cli_pop() {
    let mut guard = STATE.lock().unwrap();
    let state = guard.as_mut().expect("forge_cli_begin not called");
    state.stack.pop();
}

// ── Parse & dispatch ────────────────────────────────────────────────

#[no_mangle]
pub extern "C" fn forge_cli_end() {
    let mut guard = STATE.lock().unwrap();
    let state = guard.as_mut().expect("forge_cli_begin not called");

    let argv: Vec<String> = std::env::args().collect();
    if argv.len() <= 1 {
        print_help(&state.root, &state.version, &[]);
        std::process::exit(0);
    }

    // Parse argv[1..]
    let mut cmd = &state.root as *const Command;
    let mut matched_path: Vec<String> = Vec::new();
    let mut values: HashMap<String, String> = HashMap::new();
    let mut set_flags: HashSet<String> = HashSet::new();
    let mut positional_idx = 0usize;
    let mut i = 1;

    // First, walk commands
    while i < argv.len() {
        let arg = &argv[i];

        if arg == "--help" || arg == "-h" {
            let cmd_ref = unsafe { &*cmd };
            print_help(cmd_ref, &state.version, &matched_path);
            std::process::exit(0);
        }

        if arg == "--version" || arg == "-V" {
            println!("{} {}", state.root.name, state.version);
            std::process::exit(0);
        }

        if arg.starts_with('-') {
            break; // Not a command, it's a flag/option
        }

        let cmd_ref = unsafe { &*cmd };
        if let Some(sub) = cmd_ref.find_command(arg) {
            matched_path.push(arg.clone());
            cmd = sub as *const Command;
            i += 1;
        } else {
            break; // Positional arg, not a command
        }
    }

    // Now parse flags/options/positional args against the matched command
    let active = unsafe { &*cmd };

    // Apply option defaults
    for opt in &active.options {
        if !opt.default.is_empty() {
            values.insert(normalize(&opt.name), opt.default.clone());
        }
    }

    while i < argv.len() {
        let arg = &argv[i];

        if arg == "--help" || arg == "-h" {
            print_help(active, &state.version, &matched_path);
            std::process::exit(0);
        }

        if arg == "--" {
            i += 1;
            break;
        }

        if arg.starts_with("--") {
            let tail = &arg[2..];

            if let Some(eq_pos) = tail.find('=') {
                // --key=value
                let key = normalize(&tail[..eq_pos]);
                let val = &tail[eq_pos + 1..];
                values.insert(key.clone(), val.to_string());
                set_flags.insert(key);
            } else if tail.starts_with("no-") || tail.starts_with("no_") {
                let key = normalize(&tail[3..]);
                values.insert(key.clone(), "false".to_string());
                // Don't set flag — it's explicitly disabled
            } else {
                let key = normalize(tail);

                if active.find_option(&key).is_some() {
                    // Option: consume next arg as value
                    if i + 1 < argv.len() {
                        i += 1;
                        values.insert(key.clone(), argv[i].clone());
                        set_flags.insert(key);
                    } else {
                        eprintln!("error: missing value for --{}", display(tail));
                        std::process::exit(1);
                    }
                } else {
                    // Flag
                    values.insert(key.clone(), "true".to_string());
                    set_flags.insert(key);
                }
            }
        } else if arg.starts_with('-') && arg.len() == 2 {
            let ch = &arg[1..2];

            // Check if it's a short flag or short option
            if let Some(opt) = active.options.iter().find(|o| o.short == ch) {
                if i + 1 < argv.len() {
                    i += 1;
                    let key = normalize(&opt.name);
                    values.insert(key.clone(), argv[i].clone());
                    set_flags.insert(key);
                }
            } else if let Some(flag) = active.flags.iter().find(|f| f.short == ch) {
                let key = normalize(&flag.name);
                values.insert(key.clone(), "true".to_string());
                set_flags.insert(key);
            } else {
                eprintln!("error: unknown flag -{}", ch);
                std::process::exit(1);
            }
        } else {
            // Positional argument
            if positional_idx < active.args.len() {
                let name = normalize(&active.args[positional_idx].name);
                values.insert(name.clone(), arg.clone());
                set_flags.insert(name);
                positional_idx += 1;
            }
            // Extra positional args are silently ignored
        }

    }

    state.matched_path = matched_path;
    state.values = values;
    state.set_flags = set_flags;
}

// ── Getters (called from user code) ─────────────────────────────────

#[no_mangle]
pub extern "C" fn forge_cli_matched_command() -> *mut c_char {
    let guard = STATE.lock().unwrap();
    let state = guard.as_ref().expect("forge_cli_end not called");
    to_c(&state.matched_path.join("."))
}

#[no_mangle]
pub extern "C" fn forge_cli_get(key: *const c_char) -> *mut c_char {
    let guard = STATE.lock().unwrap();
    let state = guard.as_ref().expect("forge_cli_end not called");
    let k = normalize(&cstr(key));
    to_c(state.values.get(&k).map(|s| s.as_str()).unwrap_or(""))
}

#[no_mangle]
pub extern "C" fn forge_cli_get_bool(key: *const c_char) -> i64 {
    let guard = STATE.lock().unwrap();
    let state = guard.as_ref().expect("forge_cli_end not called");
    let k = normalize(&cstr(key));
    match state.values.get(&k).map(|s| s.as_str()) {
        Some("true") | Some("1") => 1,
        _ => 0,
    }
}

#[no_mangle]
pub extern "C" fn forge_cli_has(key: *const c_char) -> i64 {
    let guard = STATE.lock().unwrap();
    let state = guard.as_ref().expect("forge_cli_end not called");
    let k = normalize(&cstr(key));
    if state.set_flags.contains(&k) { 1 } else { 0 }
}

// ── Handler registration & dispatch ─────────────────────────────────

/// Returns the dot-joined path of the current command stack (during registration).
#[no_mangle]
pub extern "C" fn forge_cli_current_path() -> *mut c_char {
    let guard = STATE.lock().unwrap();
    let state = guard.as_ref().expect("forge_cli_begin not called");
    let mut path = Vec::new();
    let mut cmd = &state.root;
    for &idx in &state.stack {
        cmd = &cmd.commands[idx];
        path.push(cmd.name.clone());
    }
    to_c(&path.join("."))
}

/// Register a handler function for a command path.
#[no_mangle]
pub extern "C" fn forge_cli_register_handler(path: *const c_char, handler: extern "C" fn() -> i64) {
    let mut guard = STATE.lock().unwrap();
    let state = guard.as_mut().expect("forge_cli_begin not called");
    state.handlers.insert(cstr(path), handler);
}

/// Dispatch to the matched command's handler. Returns the handler's exit code.
#[no_mangle]
pub extern "C" fn forge_cli_dispatch() -> i64 {
    let matched;
    let handler;
    {
        let guard = STATE.lock().unwrap();
        let state = guard.as_ref().expect("forge_cli_end not called");
        matched = state.matched_path.join(".");
        handler = state.handlers.get(&matched).copied();
    }
    // Lock released before calling handler (handler may call cli getters)
    match handler {
        Some(h) => h(),
        None => {
            if matched.is_empty() {
                0 // No command — help was already printed
            } else {
                eprintln!("error: no handler for command '{}'", matched);
                1
            }
        }
    }
}

// ── Help generation ─────────────────────────────────────────────────

fn print_help(cmd: &Command, version: &str, path: &[String]) {
    if path.is_empty() {
        // Root help
        println!("{} {}", cmd.name, version);
        if !cmd.description.is_empty() {
            println!("{}", cmd.description);
        }
        println!();
        println!("USAGE: {} <COMMAND> [OPTIONS]", cmd.name);
    } else {
        // Command-specific help
        if !cmd.description.is_empty() {
            println!("{}", cmd.description);
        }
        println!();
        print!("USAGE: {}", path.join(" "));

        // If root, prepend the app name — but we don't have it here
        // path already contains the command chain
        let usage_args = if !cmd.args.is_empty() {
            cmd.args.iter().map(|a| {
                if a.required { format!("<{}>", a.name.to_uppercase()) }
                else { format!("[{}]", a.name.to_uppercase()) }
            }).collect::<Vec<_>>().join(" ")
        } else { String::new() };

        if !usage_args.is_empty() {
            print!(" {}", usage_args);
        }
        if !cmd.flags.is_empty() || !cmd.options.is_empty() {
            print!(" [OPTIONS]");
        }
        println!();
    }

    // Commands
    if !cmd.commands.is_empty() {
        println!();
        println!("COMMANDS:");
        let max_name = cmd.commands.iter().map(|c| display(&c.name).len()).max().unwrap_or(0);
        for c in &cmd.commands {
            let dn = display(&c.name);
            println!("  {:<width$}  {}", dn, c.description, width = max_name.max(12));
        }
    }

    // Arguments
    if !cmd.args.is_empty() {
        println!();
        println!("ARGUMENTS:");
        let max_name = cmd.args.iter().map(|a| a.name.len()).max().unwrap_or(0);
        for a in &cmd.args {
            let suffix = if a.required { "" } else { " (optional)" };
            println!("  {:<width$}  {}{}", a.name, a.description, suffix, width = max_name.max(12));
        }
    }

    // Options (flags + options + help/version)
    {
        println!();
        println!("OPTIONS:");

        // Collect all entries for alignment
        struct Entry { left: String, desc: String }
        let mut entries: Vec<Entry> = Vec::new();

        for f in &cmd.flags {
            let left = if f.short.is_empty() {
                format!("    --{}", display(&f.name))
            } else {
                format!("-{}, --{}", f.short, display(&f.name))
            };
            entries.push(Entry { left, desc: f.description.clone() });
        }

        for o in &cmd.options {
            let left = if o.short.is_empty() {
                format!("    --{} <VALUE>", display(&o.name))
            } else {
                format!("-{}, --{} <VALUE>", o.short, display(&o.name))
            };
            let desc = if o.default.is_empty() {
                o.description.clone()
            } else {
                format!("{} [default: {}]", o.description, o.default)
            };
            entries.push(Entry { left, desc });
        }

        entries.push(Entry {
            left: "-h, --help".to_string(),
            desc: "Show help".to_string(),
        });

        if path.is_empty() {
            entries.push(Entry {
                left: "-V, --version".to_string(),
                desc: "Show version".to_string(),
            });
        }

        let max_left = entries.iter().map(|e| e.left.len()).max().unwrap_or(0);
        for e in &entries {
            println!("  {:<width$}  {}", e.left, e.desc, width = max_left.max(20));
        }
    }

    println!();
}
