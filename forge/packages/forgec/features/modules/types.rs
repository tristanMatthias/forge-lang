use crate::parser::ast::{ComponentBlockDecl, Expr, Param, Statement, TypeExpr};

/// Describes an exported symbol from a module
#[derive(Debug, Clone)]
pub enum ExportedSymbol {
    Function {
        name: String,
        params: Vec<Param>,
        return_type: Option<TypeExpr>,
    },
    Value {
        name: String,
        value: Expr,
        type_ann: Option<TypeExpr>,
    },
    ComponentBlock {
        name: String,
        decl: ComponentBlockDecl,
    },
    /// An exported type declaration (struct or type alias)
    TypeDecl {
        name: String,
        stmt: Statement,
    },
    /// An exported enum declaration
    EnumDecl {
        name: String,
        stmt: Statement,
    },
}

/// Information about an import that needs to be injected into codegen
#[derive(Debug, Clone)]
pub struct ResolvedImport {
    /// The local name to use in the importing module
    pub local_name: String,
    /// The mangled name in the LLVM module (module_path + "_" + export_name)
    pub mangled_name: String,
    /// The exported symbol info
    pub symbol: ExportedSymbol,
}
