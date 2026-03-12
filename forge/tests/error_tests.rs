use assert_cmd::Command;
use predicates::prelude::*;
use std::io::Write;

/// Helper to strip ANSI escape codes from output
fn strip_ansi(s: &str) -> String {
    let re = regex_lite::Regex::new(r"\x1b\[[0-9;]*m").unwrap();
    re.replace_all(s, "").to_string()
}

/// Run `forge check` on a test file, expect failure, and return stripped stderr
fn check_error(test_name: &str) -> String {
    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .arg("check")
        .arg(format!("tests/errors/{}.fg", test_name))
        .assert()
        .failure();

    let output = cmd.get_output();
    strip_ansi(&String::from_utf8_lossy(&output.stderr))
}

#[test]
fn test_undefined_var_error() {
    let stderr = check_error("undefined_var");
    assert!(stderr.contains("undefined variable 'x'"), "expected undefined variable error, got:\n{}", stderr);
    assert!(stderr.contains("F0020") || stderr.contains("E0010"), "expected error code F0020 or E0010, got:\n{}", stderr);
}

#[test]
fn test_immutable_assign_error() {
    let stderr = check_error("immutable_assign");
    assert!(stderr.contains("cannot assign to immutable variable 'x'"), "expected immutable assign error, got:\n{}", stderr);
    assert!(stderr.contains("F0013") || stderr.contains("E0013"), "expected error code F0013 or E0013, got:\n{}", stderr);
}

#[test]
fn test_missing_brace_error() {
    let stderr = check_error("missing_brace");
    assert!(stderr.contains("expected") && stderr.contains("RBrace"), "expected missing brace error, got:\n{}", stderr);
    assert!(stderr.contains("F0001") || stderr.contains("E0001"), "expected error code F0001 or E0001, got:\n{}", stderr);
}

#[test]
fn test_missing_paren_error() {
    let stderr = check_error("missing_paren");
    assert!(stderr.contains("F0001") || stderr.contains("E0001"), "expected error code F0001 or E0001, got:\n{}", stderr);
}

#[test]
fn test_json_error_output() {
    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["check", "--error-format", "json", "tests/errors/undefined_var.fg"])
        .assert()
        .failure();

    let output = cmd.get_output();
    let stderr = String::from_utf8_lossy(&output.stderr);

    // Find the JSON object in stderr (skip the "error: type check errors" line)
    let json_start = stderr.find('{').expect("should contain JSON");
    let json_end = stderr.rfind('}').expect("should contain closing brace");
    let json_str = &stderr[json_start..=json_end];

    let parsed: serde_json::Value = serde_json::from_str(json_str).expect("should be valid JSON");
    let diagnostics = parsed["diagnostics"].as_array().expect("should have diagnostics array");
    assert!(!diagnostics.is_empty(), "should have at least one diagnostic");
    assert_eq!(diagnostics[0]["code"], "F0020");
    assert_eq!(diagnostics[0]["severity"], "error");
    assert!(diagnostics[0]["message"].as_str().unwrap().contains("undefined variable"));
}

#[test]
fn test_explain_known_code() {
    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["explain", "F0020"])
        .assert()
        .success();

    let output = cmd.get_output();
    let stdout = String::from_utf8_lossy(&output.stdout);
    assert!(stdout.contains("F0020"), "should show error code");
    assert!(stdout.contains("Undefined variable"), "should show title");
    assert!(stdout.contains("Help:"), "should show help text");
}

#[test]
fn test_explain_unknown_code() {
    Command::cargo_bin("forge")
        .unwrap()
        .args(["explain", "F9998"])
        .assert()
        .failure()
        .stderr(predicates::str::contains("unknown error code"));
}

#[test]
fn test_explain_f9999() {
    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["explain", "F9999"])
        .assert()
        .success();

    let output = cmd.get_output();
    let stdout = String::from_utf8_lossy(&output.stdout);
    assert!(stdout.contains("Internal compiler error"));
}

#[test]
fn test_multi_error_reporting() {
    let stderr = check_error("multi_error");
    // Should contain multiple error codes
    assert!(stderr.contains("F0020"), "should contain undefined var error, got:\n{}", stderr);
    // Should contain summary line
    assert!(stderr.contains("Found"), "should contain summary line, got:\n{}", stderr);
    assert!(stderr.contains("error"), "summary should mention errors, got:\n{}", stderr);
}

#[test]
fn test_error_summary_line() {
    let stderr = check_error("undefined_var");
    // Single error should show "Found 1 error."
    assert!(stderr.contains("Found 1 error"), "should show error count, got:\n{}", stderr);
}

#[test]
fn test_did_you_mean_suggestion() {
    let stderr = check_error("did_you_mean");
    assert!(stderr.contains("F0020"), "should contain error code F0020, got:\n{}", stderr);
    assert!(stderr.contains("did you mean 'count'"), "should suggest 'count', got:\n{}", stderr);
}

#[test]
fn test_unused_variable_warning() {
    // This file has an unused var but no errors, so check should succeed
    // BUT: warnings don't cause failure with check command
    // We need to check stderr for the warning
    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["check", "tests/errors/unused_var.fg"])
        .assert()
        .success();

    let output = cmd.get_output();
    let stderr = strip_ansi(&String::from_utf8_lossy(&output.stderr));
    assert!(stderr.contains("F0801"), "should contain unused var warning F0801, got:\n{}", stderr);
    assert!(stderr.contains("unused variable 'unused_var'"), "should name the unused var, got:\n{}", stderr);
}

#[test]
fn test_unused_variable_underscore_suppressed() {
    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["check", "tests/errors/unused_var_suppressed.fg"])
        .assert()
        .success();

    let output = cmd.get_output();
    let stderr = strip_ansi(&String::from_utf8_lossy(&output.stderr));
    assert!(!stderr.contains("F0801"), "underscore prefix should suppress warning, got:\n{}", stderr);
}

#[test]
fn test_type_mismatch_suggestion() {
    let stderr = check_error("type_mismatch");
    assert!(stderr.contains("F0012"), "should contain error code F0012, got:\n{}", stderr);
    assert!(stderr.contains("type mismatch"), "should mention type mismatch, got:\n{}", stderr);
    assert!(stderr.contains("string(value)"), "should suggest string(value), got:\n{}", stderr);
}

// === Feature 1: Build Profiling ===

#[test]
fn test_build_profile_human() {
    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["build", "--profile", "tests/programs/hello.fg"])
        .assert()
        .success();

    let output = cmd.get_output();
    let stderr = strip_ansi(&String::from_utf8_lossy(&output.stderr));
    assert!(stderr.contains("Build Profile"), "should show profile header, got:\n{}", stderr);
    assert!(stderr.contains("lex"), "should show lex stage, got:\n{}", stderr);
    assert!(stderr.contains("parse"), "should show parse stage, got:\n{}", stderr);
    assert!(stderr.contains("codegen"), "should show codegen stage, got:\n{}", stderr);
    assert!(stderr.contains("Total:"), "should show total time, got:\n{}", stderr);
    assert!(stderr.contains("Functions:"), "should show function count, got:\n{}", stderr);
    // Cleanup generated binary
    std::fs::remove_file("hello").ok();
}

#[test]
fn test_build_profile_json() {
    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["build", "--profile", "--profile-format", "json", "tests/programs/hello.fg"])
        .assert()
        .success();

    let output = cmd.get_output();
    let stderr = String::from_utf8_lossy(&output.stderr);
    // Find JSON in stderr
    let json_start = stderr.find('{').expect("should contain JSON");
    let json_end = stderr.rfind('}').expect("should contain closing brace");
    let json_str = &stderr[json_start..=json_end];
    let parsed: serde_json::Value = serde_json::from_str(json_str).expect("should be valid JSON");
    assert!(parsed["stages"].is_array(), "should have stages array");
    assert!(parsed["total_ms"].is_number(), "should have total_ms");
    assert!(parsed["fn_count"].is_number(), "should have fn_count");
    // Cleanup generated binary
    std::fs::remove_file("hello").ok();
}

// === Feature 2: Error Diffing ===

#[test]
fn test_error_diff() {
    let before = r#"{"diagnostics": [
        {"code": "F0020", "severity": "error", "message": "undefined variable 'x'", "span": {"start": 10, "end": 11, "line": 2, "col": 5}},
        {"code": "F0012", "severity": "error", "message": "type mismatch", "span": {"start": 20, "end": 25, "line": 3, "col": 1}}
    ]}"#;
    let after = r#"{"diagnostics": [
        {"code": "F0012", "severity": "error", "message": "type mismatch", "span": {"start": 20, "end": 25, "line": 3, "col": 1}}
    ]}"#;

    let before_path = std::env::temp_dir().join("forge_test_before.json");
    let after_path = std::env::temp_dir().join("forge_test_after.json");
    std::fs::write(&before_path, before).unwrap();
    std::fs::write(&after_path, after).unwrap();

    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["errors", "diff", before_path.to_str().unwrap(), after_path.to_str().unwrap()])
        .assert()
        .success();

    let output = cmd.get_output();
    let stdout = String::from_utf8_lossy(&output.stdout);
    assert!(stdout.contains("Fixed"), "should show fixed errors, got:\n{}", stdout);
    assert!(stdout.contains("F0020"), "should mention fixed F0020, got:\n{}", stdout);
    assert!(stdout.contains("Remaining"), "should show remaining errors, got:\n{}", stdout);
    assert!(stdout.contains("50%"), "should show 50% progress, got:\n{}", stdout);

    std::fs::remove_file(&before_path).ok();
    std::fs::remove_file(&after_path).ok();
}

// === Feature 3: Autofix ===

#[test]
fn test_autofix_type_mismatch() {
    // Copy the test file to a temp location to avoid modifying the original
    let source = std::fs::read_to_string("tests/errors/autofix_type.fg").unwrap();
    let tmp_path = std::env::temp_dir().join("forge_test_autofix.fg");
    std::fs::write(&tmp_path, &source).unwrap();

    let cmd = Command::cargo_bin("forge")
        .unwrap()
        .args(["check", "--autofix", tmp_path.to_str().unwrap()])
        .assert();

    let output = cmd.get_output();
    let stderr = strip_ansi(&String::from_utf8_lossy(&output.stderr));
    // The autofix should report applying fixes
    assert!(stderr.contains("Applied") || stderr.contains("applied") || stderr.contains("fix"),
        "should report applied fix, got:\n{}", stderr);

    // The file should now have `int` instead of `string`
    let fixed = std::fs::read_to_string(&tmp_path).unwrap();
    assert!(fixed.contains("let port: int = 8080"), "should fix type annotation to int, got:\n{}", fixed);

    std::fs::remove_file(&tmp_path).ok();
}

// === Feature 5: Because Chains ===

#[test]
fn test_because_chain_type_mismatch() {
    let stderr = check_error("because_chain");
    assert!(stderr.contains("F0012"), "should contain F0012, got:\n{}", stderr);
    assert!(stderr.contains("type mismatch"), "should contain type mismatch, got:\n{}", stderr);
    // Should show the origin of the type
    assert!(stderr.contains("get_name") || stderr.contains("returns string"),
        "should mention where the type came from, got:\n{}", stderr);
}

// === Feature 6: Example Generation ===

#[test]
fn test_wrong_arg_count_error() {
    let stderr = check_error("wrong_arg_count");
    assert!(stderr.contains("F0014"), "should contain error code F0014, got:\n{}", stderr);
    assert!(stderr.contains("expected 2") || stderr.contains("2 argument"),
        "should mention expected arg count, got:\n{}", stderr);
    assert!(stderr.contains("add(") || stderr.contains("example"),
        "should show example or function signature, got:\n{}", stderr);
}

// === Feature 7: Build Profile (already tested above) ===

// === Feature 8: Runtime Errors with Source Locations ===

#[test]
fn test_runtime_assert_with_location() {
    // Build a program with an assert that will fail
    let source = "fn main() {\n    assert false, \"test failed\"\n}\n";
    let tmp_path = std::env::temp_dir().join("forge_test_runtime_assert.fg");
    std::fs::write(&tmp_path, source).unwrap();

    let build_result = Command::cargo_bin("forge")
        .unwrap()
        .args(["build", "-o", std::env::temp_dir().join("forge_test_runtime_assert").to_str().unwrap(), tmp_path.to_str().unwrap()])
        .assert()
        .success();

    // Run the compiled binary - it should fail with source location info
    let output = std::process::Command::new(std::env::temp_dir().join("forge_test_runtime_assert"))
        .output();

    if let Ok(output) = output {
        let stderr = String::from_utf8_lossy(&output.stderr);
        assert!(stderr.contains("assertion failed"), "should contain assertion failure, got:\n{}", stderr);
        // Should show file and line info
        assert!(stderr.contains("line 2") || stderr.contains(":2") || stderr.contains("forge_test_runtime_assert.fg"),
            "should show source location, got:\n{}", stderr);
    }

    std::fs::remove_file(&tmp_path).ok();
    std::fs::remove_file(std::env::temp_dir().join("forge_test_runtime_assert")).ok();
}
