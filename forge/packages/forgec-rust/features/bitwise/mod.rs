crate::forge_feature! {
    name: "Bitwise Operators",
    id: "bitwise",
    status: Testing,
    depends: ["operators"],
    enables: [],
    tokens: ["Caret", "Tilde", "ShiftLeft", "ShiftRight", "Bar"],
    ast_nodes: ["Binary(BitAnd, BitOr, BitXor, Shl, Shr)", "Unary(BitNot)"],
    description: "Bitwise operators for integer manipulation: AND, OR, XOR, shifts, NOT.",
    syntax: ["a & b", "a | b", "a ^ b", "a << n", "a >> n", "~a"],
    short: "bitwise — AND, OR, XOR, shift, NOT for integers",
    symbols: [],
    long_description: "\
Forge provides bitwise operators for low-level integer manipulation. These operate on \
the binary representation of `int` values.

**Binary operators** (operate on two `int` operands):
- `&` — bitwise AND: `5 & 3` is `1` (keeps bits set in both)
- `|` — bitwise OR: `5 | 3` is `7` (sets bits from either)
- `^` — bitwise XOR: `5 ^ 3` is `6` (sets bits different between operands)
- `<<` — left shift: `1 << 4` is `16` (multiply by 2^n)
- `>>` — right shift: `16 >> 2` is `4` (arithmetic shift, preserves sign)

**Unary operator**:
- `~` — bitwise NOT: `~0` is `-1` (flips all bits)

All bitwise operators require `int` operands. Using them on `float`, `string`, or other \
types produces a type error. The `|` operator is disambiguated from the pipe operator `|>` \
and table delimiters by context.

**Precedence** (low to high within bitwise): `|` < `^` < `&` < `<< >>`. \
Bitwise operators sit between comparison operators and arithmetic in the overall precedence \
hierarchy: `comparisons > | > ^ > & > shifts > +/- > */÷`.

Arithmetic right shift (`>>`) preserves the sign bit, so `-8 >> 1` is `-4`.",
    category: "Operators",
    category_order: Primary,
}
