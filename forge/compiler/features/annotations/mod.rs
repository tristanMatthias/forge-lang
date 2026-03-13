crate::forge_feature! {
    name: "Annotations",
    id: "annotations",
    status: Stable,
    depends: ["components"],
    enables: [],
    tokens: [],
    ast_nodes: ["Annotation"],
    description: "Annotation system: @name and @name(args) on component fields, models, and routes",
}
