crate::forge_feature! {
    name: "Annotations",
    id: "annotations",
    status: Stable,
    depends: ["components"],
    enables: [],
    tokens: [],
    ast_nodes: ["Annotation"],
    description: "Annotation system: @name and @name(args) on component fields, models, and routes",
    syntax: ["@name", "@name(args)"],
    short: "@name and @name(args) — metadata annotations on declarations",
    symbols: ["@"],
    long_description: "\
Annotations attach metadata to declarations using the `@name` or `@name(args)` syntax. They \
appear before functions, types, fields, and other declarations. For example, `@deprecated fn old() { }` \
marks a function as deprecated, and `@syntax(\"pattern\")` configures a component syntax pattern.

Annotations are the primary extensibility mechanism for Forge's compiler and provider system. \
Rather than adding keywords for every new concept, Forge uses annotations to layer behavior \
onto existing syntax. This keeps the core language small while allowing rich, domain-specific features.

The compiler processes annotations during different compilation phases. Some annotations affect \
parsing (`@syntax`), some affect type checking (`@deprecated`), and some affect code generation. \
Provider templates can define custom annotations that control template expansion behavior.

This design is similar to Java annotations, Python decorators, and C# attributes. The key \
difference is that Forge annotations integrate with the template system, so providers can define \
new annotations without compiler changes.",
    category: "Special",
}
