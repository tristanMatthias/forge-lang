crate::forge_feature! {
    name: "Duration Literals",
    id: "durations",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Duration literal suffixes: 7d, 24h, 5m, 1s compile to millisecond integers",
    syntax: ["7d", "24h", "5m", "10s", "500ms"],
    short: "7d, 24h, 5m, 10s — duration literal suffixes",
    symbols: [],
    long_description: "\
Duration literals express time spans directly in code using intuitive suffixes: `7d` for seven \
days, `24h` for twenty-four hours, `5m` for five minutes, and `10s` for ten seconds. These \
compile to millisecond values, providing a type-safe and readable alternative to raw numbers.

Durations are commonly used with timers, timeouts, scheduling, and any API that accepts a time \
interval. Writing `timeout = 30s` is immediately clear, whereas `timeout = 30000` requires the \
reader to mentally convert milliseconds. Duration literals prevent unit confusion bugs entirely.

The supported suffixes are `d` (days), `h` (hours), `m` (minutes), and `s` (seconds). Each is \
converted to milliseconds at compile time, so `1h` equals `3600000`. Duration values can be \
used anywhere an integer is expected, since they are simply integers representing milliseconds.

Duration suffixes are inspired by Kotlin's duration API and Go's time.Duration, but as literal \
syntax they provide even less friction. No imports or method calls are needed; the suffix is \
part of the number literal itself.",
    category: "Special",
}
