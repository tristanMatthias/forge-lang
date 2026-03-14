crate::forge_feature! {
    name: "Datetime",
    id: "datetime",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Datetime helpers: datetime_now(), datetime_format(), datetime_parse() — epoch milliseconds",
    syntax: ["datetime_now()", "datetime_format(ts, fmt)", "datetime_parse(s, fmt)"],
    short: "datetime_now/format/parse — epoch millisecond timestamps",
    symbols: [],
    long_description: "\
Forge provides built-in datetime functions for working with timestamps: `datetime_now()` returns \
the current time as epoch milliseconds, `datetime_format(epoch, pattern)` converts an epoch \
timestamp to a formatted string, and `datetime_parse(str, pattern)` parses a date string back \
to epoch milliseconds.

Using epoch milliseconds as the internal representation keeps datetime values as plain integers, \
which means they can be compared with standard operators, stored in any collection, and \
serialized without special handling. The format and parse functions handle the conversion to \
and from human-readable strings.

Format patterns use standard date format specifiers. Common patterns include `\"YYYY-MM-DD\"` \
for dates and `\"YYYY-MM-DD HH:mm:ss\"` for timestamps. The pattern syntax is familiar to \
anyone who has used date formatting in JavaScript, Python, or Java.

Duration literals pair naturally with datetime functions. `datetime_now() + 7d` gives you a \
timestamp one week in the future. `datetime_now() - 24h` gives you yesterday. This makes \
date arithmetic readable and type-safe.",
}

pub mod codegen;
