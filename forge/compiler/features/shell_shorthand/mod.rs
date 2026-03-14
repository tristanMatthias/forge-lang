pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Shell Shorthand",
    id: "shell_shorthand",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["$\"", "$`"],
    ast_nodes: ["DollarExec"],
    description: "Shell command execution with $\"cmd\" and $`cmd ${arg}` returning stdout as string",
    syntax: ["$\"command ${arg}\"", "$`command`"],
    short: "$\"cmd\" — execute shell command, return stdout",
    symbols: ["$\"", "$`"],
    long_description: "\
Shell shorthands let you execute system commands directly from Forge code. The dollar-string \
syntax `$\"echo hello ${name}\"` runs the command and returns its stdout as a string. The \
backtick form `$\\`echo ${name}\\`` works identically. Both support template interpolation for \
dynamic command construction.

This feature bridges the gap between system scripting and application programming. Tasks that \
would normally require shelling out through a process API can be expressed as a single \
expression. The interpolated values are included in the command string, so `$\"ls ${dir}\"` \
lists the contents of whatever directory `dir` refers to.

Shell shorthands return the command's standard output as a trimmed string. If the command fails \
(non-zero exit code), an error is returned. This integrates with Forge's error propagation, so \
`$\"git status\"?` propagates the error if git is not available.

This is inspired by shell scripting languages and Perl's backtick operator. Unlike raw shell \
execution in most languages, Forge's version participates in the type system (the result is \
always a string) and supports template interpolation with compile-time type checking of the \
embedded expressions.",
    grammar: "<shell_expr>  ::= \"$\\\"\" <template> \"\\\"\" | \"$`\" <template> \"`\"",
}
