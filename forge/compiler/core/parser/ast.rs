use crate::feature::{FeatureExpr, FeatureNode, FeatureStmt};
use crate::lexer::Span;

/// Convenience constructor for `Expr::Feature(FeatureExpr { ... })`.
pub fn feature_expr(feature_id: &'static str, kind: &'static str, data: Box<dyn FeatureNode>, span: Span) -> Expr {
    Expr::Feature(FeatureExpr { feature_id, kind, data, span })
}

/// Convenience constructor for `Statement::Feature(FeatureStmt { ... })`.
pub fn feature_stmt(feature_id: &'static str, kind: &'static str, data: Box<dyn FeatureNode>, span: Span) -> Statement {
    Statement::Feature(FeatureStmt { feature_id, kind, data, span })
}

#[derive(Debug, Clone)]
pub struct Program {
    pub statements: Vec<Statement>,
}

#[derive(Debug, Clone)]
pub struct UseItem {
    pub name: String,
    pub alias: Option<String>,
}

#[derive(Debug, Clone)]
pub struct TypeParam {
    pub name: String,
    pub bounds: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct TraitMethod {
    pub name: String,
    pub params: Vec<Param>,
    pub return_type: Option<TypeExpr>,
    pub default_body: Option<Block>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum Statement {
    Let {
        name: String,
        type_ann: Option<TypeExpr>,
        type_ann_span: Option<Span>,
        value: Expr,
        exported: bool,
        span: Span,
    },
    Mut {
        name: String,
        type_ann: Option<TypeExpr>,
        type_ann_span: Option<Span>,
        value: Expr,
        exported: bool,
        span: Span,
    },
    Const {
        name: String,
        type_ann: Option<TypeExpr>,
        type_ann_span: Option<Span>,
        value: Expr,
        exported: bool,
        span: Span,
    },
    LetDestructure {
        pattern: Pattern,
        value: Expr,
        span: Span,
    },
    Assign {
        target: Expr,
        value: Expr,
        span: Span,
    },
    FnDecl {
        name: String,
        type_params: Vec<TypeParam>,
        params: Vec<Param>,
        return_type: Option<TypeExpr>,
        body: Block,
        exported: bool,
        span: Span,
    },
    EnumDecl {
        name: String,
        variants: Vec<EnumVariant>,
        exported: bool,
        span: Span,
    },
    TypeDecl {
        name: String,
        type_params: Vec<TypeParam>,
        value: TypeExpr,
        exported: bool,
        span: Span,
    },
    Use {
        path: Vec<String>,
        items: Vec<UseItem>,
        span: Span,
    },
    TraitDecl {
        name: String,
        type_params: Vec<TypeParam>,
        super_traits: Vec<String>,
        methods: Vec<TraitMethod>,
        exported: bool,
        span: Span,
    },
    ImplBlock {
        trait_name: Option<String>,
        type_name: String,
        type_params: Vec<TypeParam>,
        associated_types: Vec<(String, TypeExpr)>,
        methods: Vec<Statement>,
        span: Span,
    },
    Expr(Expr),
    Return {
        value: Option<Expr>,
        span: Span,
    },
    Defer {
        body: Expr,
        span: Span,
    },
    For {
        pattern: Pattern,
        iterable: Expr,
        body: Block,
        span: Span,
    },
    While {
        condition: Expr,
        body: Block,
        span: Span,
    },
    Loop {
        body: Block,
        label: Option<String>,
        span: Span,
    },
    Break {
        value: Option<Expr>,
        label: Option<String>,
        span: Span,
    },
    Continue {
        label: Option<String>,
        span: Span,
    },
    // Extern function declaration (C ABI)
    ExternFn {
        name: String,
        params: Vec<Param>,
        return_type: Option<TypeExpr>,
        span: Span,
    },
    // Generic component block (provider architecture)
    ComponentBlock(ComponentBlockDecl),
    // Component template definition from provider.fg
    ComponentTemplateDef(ComponentTemplateDef),
    // Select statement for channel multiplexing
    Select {
        arms: Vec<SelectArm>,
        span: Span,
    },
    // Test framework: spec block
    SpecBlock {
        name: String,
        body: Block,
        span: Span,
    },
    // Test framework: given block (inside spec or given)
    GivenBlock {
        name: String,
        body: Block,
        span: Span,
    },
    // Test framework: then assertion (inside spec or given)
    ThenBlock {
        name: String,
        body: Block,
        span: Span,
    },
    // Test framework: then should_fail (expects body to error)
    ThenShouldFail {
        name: String,
        body: Block,
        span: Span,
    },
    // Test framework: then should_fail_with "msg" (expects specific error)
    ThenShouldFailWith {
        name: String,
        expected: String,
        body: Block,
        span: Span,
    },
    // Test framework: then "name" where table { cols | ... } { body }
    ThenWhere {
        name: String,
        table: Expr,
        body: Block,
        span: Span,
    },
    // Test framework: skip block
    SkipBlock {
        name: String,
        span: Span,
    },
    // Test framework: todo placeholder
    TodoStmt {
        name: String,
        span: Span,
    },
    // Feature-owned statement (extension point for modular features)
    Feature(FeatureStmt),
}

#[derive(Debug, Clone)]
pub struct Param {
    pub name: String,
    pub type_ann: Option<TypeExpr>,
    pub default: Option<Expr>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct Block {
    pub statements: Vec<Statement>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct Annotation {
    pub name: String,
    pub args: Vec<Expr>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct ServiceHook {
    pub timing: HookTiming,
    pub operation: String,
    pub param: String,
    pub body: Block,
    pub span: Span,
}

#[derive(Debug, Clone, PartialEq)]
pub enum HookTiming {
    Before,
    After,
}

// Generic component block types (provider architecture)
#[derive(Debug, Clone)]
pub struct ComponentConfig {
    pub key: String,
    pub value: Expr,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct ComponentSchemaField {
    pub name: String,
    pub type_ann: TypeExpr,
    pub annotations: Vec<Annotation>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct ComponentBlockBody {
    pub annotations: Vec<Annotation>,
    pub config: Vec<ComponentConfig>,
    pub schema: Vec<ComponentSchemaField>,
    pub blocks: Vec<Statement>,
}

#[derive(Debug, Clone)]
pub enum ComponentArg {
    Named(String, Expr, Span),
    Ident(String, Span),
    ForRef(String, Span),
}

#[derive(Debug, Clone)]
pub struct ComponentBlockDecl {
    pub component: String,
    pub args: Vec<ComponentArg>,
    pub body: ComponentBlockBody,
    pub span: Span,
}

/// Syntax function definition from `@syntax("pattern") fn ...` in component templates
#[derive(Debug, Clone)]
pub struct SyntaxFnDef {
    pub pattern: String,
    pub fn_name: String,
    pub params: Vec<Param>,
    pub body: Block,
    pub span: Span,
}

/// Config schema entry in a component template definition
/// e.g., `cors: bool = false`
#[derive(Debug, Clone)]
pub struct ConfigSchemaEntry {
    pub key: String,
    pub type_ann: TypeExpr,
    pub default: Option<Expr>,
    pub span: Span,
}

/// Annotation declaration in a component template.
/// e.g., `annotation field primary()` or `annotation route auth(roles: List<Role>)`
#[derive(Debug, Clone)]
pub struct AnnotationDeclItem {
    /// Target: "field", "type", "route", "component", "function"
    pub target: String,
    /// Annotation name: "primary", "auth", etc.
    pub name: String,
    /// Parameters the annotation accepts
    pub params: Vec<Param>,
    pub span: Span,
}

/// Component template definition from provider.fg
/// e.g., `component model(__tpl_name, schema) { ... }`
#[derive(Debug, Clone)]
pub struct ComponentTemplateDef {
    pub component_name: String,
    pub has_schema: bool,
    pub has_model_ref: bool,
    pub config_schema: Vec<ConfigSchemaEntry>,
    pub syntax_fns: Vec<SyntaxFnDef>,
    pub annotation_decls: Vec<AnnotationDeclItem>,
    pub body: Vec<ComponentTemplateItem>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum ComponentTemplateItem {
    /// `type __tpl_name = __tpl_schema` — generate TypeDecl from user's schema
    /// If `visible_only` is true, fields with @hidden annotation are excluded
    TypeFromSchema { visible_only: bool },
    /// `on startup { ... }` — lifecycle statements (contain __tpl_* placeholders)
    OnStartup(Vec<Statement>),
    /// `on main_end { ... }` — lifecycle statements
    OnMainEnd(Vec<Statement>),
    /// Function template: `fn __tpl_name.method(...) { ... }`
    FnTemplate {
        method_name: String,
        decl: Statement,
    },
    /// Extern fn needed by the template
    ExternFn(Statement),
    /// Event declaration: `event name(params)` — declares a hookable slot
    EventDecl {
        name: String,
        params: Vec<Param>,
        span: Span,
    },
}

#[derive(Debug, Clone)]
pub enum Expr {
    IntLit(i64, Span),
    FloatLit(f64, Span),
    StringLit(String, Span),
    TemplateLit {
        parts: Vec<TemplatePart>,
        span: Span,
    },
    BoolLit(bool, Span),
    NullLit(Span),

    Ident(String, Span),

    ListLit {
        elements: Vec<Expr>,
        span: Span,
    },
    MapLit {
        entries: Vec<(Expr, Expr)>,
        span: Span,
    },
    StructLit {
        name: Option<String>,
        fields: Vec<(String, Expr)>,
        span: Span,
    },
    TupleLit {
        elements: Vec<Expr>,
        span: Span,
    },

    Binary {
        left: Box<Expr>,
        op: BinaryOp,
        right: Box<Expr>,
        span: Span,
    },
    Unary {
        op: UnaryOp,
        operand: Box<Expr>,
        span: Span,
    },
    Call {
        callee: Box<Expr>,
        args: Vec<CallArg>,
        type_args: Vec<TypeExpr>,
        span: Span,
    },
    MemberAccess {
        object: Box<Expr>,
        field: String,
        span: Span,
    },
    Index {
        object: Box<Expr>,
        index: Box<Expr>,
        span: Span,
    },
    Closure {
        params: Vec<Param>,
        body: Box<Expr>,
        span: Span,
    },

    If {
        condition: Box<Expr>,
        then_branch: Block,
        else_branch: Option<Block>,
        span: Span,
    },
    Match {
        subject: Box<Expr>,
        arms: Vec<MatchArm>,
        span: Span,
    },
    Block(Block),

    NullCoalesce {
        left: Box<Expr>,
        right: Box<Expr>,
        span: Span,
    },
    NullPropagate {
        object: Box<Expr>,
        field: String,
        span: Span,
    },
    ErrorPropagate {
        operand: Box<Expr>,
        span: Span,
    },

    // Result constructors
    OkExpr {
        value: Box<Expr>,
        span: Span,
    },
    ErrExpr {
        value: Box<Expr>,
        span: Span,
    },

    // Catch expression
    Catch {
        expr: Box<Expr>,
        binding: Option<String>,
        handler: Block,
        span: Span,
    },

    // Feature-owned expression (extension point for modular features)
    Feature(FeatureExpr),
}

impl Expr {
    pub fn span(&self) -> Span {
        match self {
            Expr::IntLit(_, s)
            | Expr::FloatLit(_, s)
            | Expr::StringLit(_, s)
            | Expr::BoolLit(_, s)
            | Expr::NullLit(s)
            | Expr::Ident(_, s) => *s,
            Expr::TemplateLit { span, .. }
            | Expr::ListLit { span, .. }
            | Expr::MapLit { span, .. }
            | Expr::StructLit { span, .. }
            | Expr::TupleLit { span, .. }
            | Expr::Binary { span, .. }
            | Expr::Unary { span, .. }
            | Expr::Call { span, .. }
            | Expr::MemberAccess { span, .. }
            | Expr::Index { span, .. }
            | Expr::Closure { span, .. }
            | Expr::If { span, .. }
            | Expr::Match { span, .. }
            | Expr::NullCoalesce { span, .. }
            | Expr::NullPropagate { span, .. }
            | Expr::ErrorPropagate { span, .. }
            | Expr::OkExpr { span, .. }
            | Expr::ErrExpr { span, .. }
            | Expr::Catch { span, .. } => *span,
            Expr::Feature(fe) => fe.span,
            Expr::Block(block) => block.span,
        }
    }
}

#[derive(Debug, Clone)]
pub struct CallArg {
    pub name: Option<String>,
    pub value: Expr,
}

#[derive(Debug, Clone)]
pub struct MatchArm {
    pub pattern: Pattern,
    pub guard: Option<Expr>,
    pub body: Expr,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct SelectArm {
    pub binding: Pattern,
    pub channel: Expr,
    pub guard: Option<Expr>,
    pub body: Block,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum Pattern {
    Wildcard(Span),
    Ident(String, Span),
    Literal(Box<Expr>),
    Struct {
        fields: Vec<(String, Pattern)>,
        rest: bool,
        span: Span,
    },
    Tuple(Vec<Pattern>, Span),
    List {
        elements: Vec<Pattern>,
        rest: Option<String>,
        span: Span,
    },
    Enum {
        variant: String,
        fields: Vec<Pattern>,
        span: Span,
    },
    Or(Vec<Pattern>, Span),
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum BinaryOp {
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Eq,
    NotEq,
    Lt,
    LtEq,
    Gt,
    GtEq,
    And,
    Or,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum UnaryOp {
    Neg,
    Not,
}

#[derive(Debug, Clone)]
pub enum TemplatePart {
    Literal(String),
    Expr(Box<Expr>),
}

#[derive(Debug, Clone)]
pub enum TypeExpr {
    Named(String),
    Generic {
        name: String,
        args: Vec<TypeExpr>,
    },
    Nullable(Box<TypeExpr>),
    Union(Vec<TypeExpr>),
    Tuple(Vec<TypeExpr>),
    Function {
        params: Vec<TypeExpr>,
        return_type: Box<TypeExpr>,
    },
    Struct {
        fields: Vec<(String, TypeExpr, Vec<Annotation>)>,
    },
    /// Type without fields: `User without {id, name}`
    Without {
        base: Box<TypeExpr>,
        fields: Vec<String>,
    },
    /// Type with additional fields: `User with { age: int @min(1) }`
    TypeWith {
        base: Box<TypeExpr>,
        fields: Vec<(String, TypeExpr, Vec<Annotation>)>,
    },
    /// Type with only specified fields: `User only {id, name}`
    Only {
        base: Box<TypeExpr>,
        fields: Vec<String>,
    },
    /// Make all fields optional: `User as partial`
    AsPartial(Box<TypeExpr>),
    /// Type intersection: `A & B` merges fields from both types
    Intersection(Box<TypeExpr>, Box<TypeExpr>),
}

#[derive(Debug, Clone)]
pub struct EnumVariant {
    pub name: String,
    pub fields: Vec<Param>,
    pub span: Span,
}
