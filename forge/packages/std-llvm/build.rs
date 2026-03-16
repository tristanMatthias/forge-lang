use std::process::Command;

fn main() {
    // Get LLVM 18 config
    let llvm_config = std::env::var("LLVM_CONFIG")
        .unwrap_or_else(|_| "/opt/homebrew/opt/llvm@18/bin/llvm-config".to_string());

    let ldflags = Command::new(&llvm_config)
        .arg("--ldflags")
        .output()
        .expect("failed to run llvm-config --ldflags");
    let ldflags = String::from_utf8(ldflags.stdout).unwrap();

    let libs = Command::new(&llvm_config)
        .args(["--libs", "core", "analysis"])
        .output()
        .expect("failed to run llvm-config --libs");
    let libs = String::from_utf8(libs.stdout).unwrap();

    // Link LLVM libraries
    for flag in ldflags.trim().split_whitespace() {
        if flag.starts_with("-L") {
            println!("cargo:rustc-link-search=native={}", &flag[2..]);
        }
    }

    for flag in libs.trim().split_whitespace() {
        if flag.starts_with("-l") {
            println!("cargo:rustc-link-lib={}", &flag[2..]);
        }
    }

    // Need C++ stdlib for LLVM
    println!("cargo:rustc-link-lib=c++");
}
