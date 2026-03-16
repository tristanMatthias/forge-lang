crate::forge_feature! {
    name: "Numeric Literals",
    id: "numeric_literals",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Hex (0xFF), binary (0b1010), and octal (0o755) integer literals with underscore separators",
    syntax: ["0xFF", "0b1010", "0o755", "1_000_000", "0xFF_FF"],
    short: "0xFF, 0b1010, 0o755 — hex, binary, and octal integer literals",
    symbols: [],
    long_description: "\
Forge supports integer literals in four bases: decimal (default), hexadecimal (prefix `0x` or \
`0X`), binary (prefix `0b` or `0B`), and octal (prefix `0o` or `0O`). All bases produce the \
same `int` type; only the notation differs.

**Hexadecimal** literals use prefix `0x` followed by digits 0-9 and a-f (case-insensitive): \
`0xFF` is 255, `0xDEAD` is 57005. Hex is useful for bit masks, colors, and memory addresses.

**Binary** literals use prefix `0b` followed by digits 0 and 1: `0b1010` is 10, \
`0b11111111` is 255. Binary is useful for bit flags and low-level bit manipulation.

**Octal** literals use prefix `0o` followed by digits 0-7: `0o755` is 493, `0o777` is 511. \
Octal is useful for Unix file permissions and legacy protocols.

**Underscore separators** are allowed in any numeric literal (decimal, hex, binary, or octal) \
to improve readability. Underscores can appear between any digits and are ignored during \
parsing: `1_000_000` is one million, `0xFF_FF` is 65535, `0b1111_0000` is 240. Leading or \
trailing underscores relative to the prefix are not valid digits and will cause an error.

All numeric literals are signed 64-bit integers (i64). The maximum value is \
`0x7FFFFFFFFFFFFFFF` (9223372036854775807). Values exceeding this range produce a \
compile-time error.

Error handling: using `0x` with no digits, invalid digits for the base (e.g., `G` in hex, \
`2` in binary, `8` in octal), and overflow all produce clear error messages with error code \
F0006 and helpful suggestions.",
    category: "Syntax",
}
