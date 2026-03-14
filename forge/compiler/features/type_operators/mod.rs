crate::forge_feature! {
    name: "Type Operators",
    id: "type_operators",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["without", "only", "partial"],
    ast_nodes: ["Without", "TypeWith", "Only", "AsPartial"],
    description: "Type-level operators: without, with, only, as partial for deriving types from existing types",
    syntax: ["Type without field", "Type only [fields]", "partial Type"],
    short: "without/only/partial — type-level field transformations",
    symbols: [],
    long_description: "\
Type operators are compile-time transformations that derive new types from existing ones. \
Forge provides `without`, `only`, `partial`, and `with` for manipulating struct types. \
For example, `type CreateUser = User without { id }` creates a type with all User fields \
except `id`.

The `only` operator selects a subset of fields: `type UserName = User only { name, email }`. \
The `partial` operator makes all fields optional: `type UserUpdate = User partial`. \
The `with` operator adds or overrides fields: `type AdminUser = User with { role: string }`.

These operators are essential for API design, where you often need variations of a base type \
for different operations (create, update, response). Instead of manually maintaining parallel \
type definitions that drift out of sync, type operators derive the variations and keep them \
consistent automatically.

Type operators compose: `type CreateUser = User without { id } with { password: string }` \
removes the `id` field and adds a `password` field in a single declaration. This is similar \
to TypeScript's `Omit`, `Pick`, and `Partial` utility types but with cleaner syntax.",
}
