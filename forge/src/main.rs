use clap::{Parser, Subcommand};
use std::path::PathBuf;
use std::process;

use forge::driver::{Driver, ErrorFormat, OptLevel};

#[derive(Parser)]
#[command(name = "forge", version = "0.1.0", about = "The Forge programming language compiler")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Compile a Forge source file or project
    Build {
        /// Input source file or project directory
        file: Option<PathBuf>,

        /// Debug build (O0, fast compile)
        #[arg(long)]
        dev: bool,

        /// Release build (O2, optimized)
        #[arg(long)]
        release: bool,

        /// Output LLVM IR instead of binary
        #[arg(long)]
        emit_ir: bool,

        /// Output parsed AST
        #[arg(long)]
        emit_ast: bool,

        /// Error format: "human" or "json"
        #[arg(long, default_value = "human")]
        error_format: String,

        /// Output binary path
        #[arg(short, long)]
        output: Option<PathBuf>,
    },

    /// Compile and run a Forge source file or project
    Run {
        /// Input source file or project directory
        file: Option<PathBuf>,

        /// Debug build
        #[arg(long)]
        dev: bool,

        /// Arguments passed to the compiled program
        #[arg(last = true)]
        args: Vec<String>,
    },

    /// Type-check without compiling
    Check {
        /// Input source file
        file: PathBuf,
    },

    /// Print version info
    Version,
}

/// Determine if a path refers to a project directory (has forge.toml)
fn is_project_dir(path: &PathBuf) -> bool {
    if path.is_dir() {
        path.join("forge.toml").exists()
    } else {
        false
    }
}

/// Resolve the target: returns (is_project, resolved_path)
fn resolve_target(file: Option<PathBuf>) -> (bool, PathBuf) {
    match file {
        Some(path) => {
            if path.is_dir() {
                (true, path)
            } else if path.extension().and_then(|e| e.to_str()) == Some("fg") {
                (false, path)
            } else {
                // Check if it's a directory path with forge.toml
                if path.join("forge.toml").exists() {
                    (true, path)
                } else {
                    (false, path)
                }
            }
        }
        None => {
            // No file given - check cwd for forge.toml
            let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
            if cwd.join("forge.toml").exists() {
                (true, cwd)
            } else {
                eprintln!("error: no source file or project directory specified");
                process::exit(1);
            }
        }
    }
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Commands::Build {
            file,
            dev,
            emit_ir,
            emit_ast,
            error_format,
            output,
            ..
        } => {
            let mut driver = Driver::new();
            driver.emit_ir = emit_ir;
            driver.emit_ast = emit_ast;
            driver.optimization = if dev { OptLevel::Dev } else { OptLevel::Release };
            driver.error_format = if error_format == "json" {
                ErrorFormat::Json
            } else {
                ErrorFormat::Human
            };
            driver.output = output;

            let (is_project, path) = resolve_target(file);

            let result = if is_project {
                driver.compile_project(&path)
            } else {
                driver.compile(&path)
            };

            match result {
                Ok(path) => {
                    if !emit_ir && !emit_ast {
                        eprintln!("compiled to {}", path.display());
                    }
                }
                Err(e) => {
                    eprintln!("error: {}", e);
                    process::exit(1);
                }
            }
        }

        Commands::Run { file, dev, args } => {
            let mut driver = Driver::new();
            driver.optimization = if dev { OptLevel::Dev } else { OptLevel::Release };

            // Compile to temp path
            let output = std::env::temp_dir().join("forge_run_output");
            driver.output = Some(output.clone());

            let (is_project, path) = resolve_target(file);

            let result = if is_project {
                driver.compile_project(&path)
            } else {
                driver.compile(&path)
            };

            match result {
                Ok(binary) => {
                    let status = std::process::Command::new(&binary)
                        .args(&args)
                        .status()
                        .unwrap_or_else(|e| {
                            eprintln!("failed to run {}: {}", binary.display(), e);
                            process::exit(1);
                        });

                    // Cleanup
                    std::fs::remove_file(&binary).ok();

                    process::exit(status.code().unwrap_or(1));
                }
                Err(e) => {
                    eprintln!("error: {}", e);
                    process::exit(1);
                }
            }
        }

        Commands::Check { file } => {
            let driver = Driver::new();
            if let Err(e) = driver.check(&file) {
                eprintln!("error: {}", e);
                process::exit(1);
            }
        }

        Commands::Version => {
            println!("forge 0.1.0");
        }
    }
}
