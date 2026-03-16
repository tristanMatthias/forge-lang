use crate::lexer::Span;
use crate::parser::ast::{Annotation, Expr, TypeParam};
use crate::typeck::types::{AnnotationArg, FieldAnnotation, Type};
use std::collections::{HashMap, HashSet};

#[derive(Debug, Clone)]
pub struct VarInfo {
    pub ty: Type,
    pub mutable: bool,
    pub used: bool,
    pub def_span: Option<Span>,
}

/// Info about an unused variable found when popping a scope
#[derive(Debug)]
pub struct UnusedVar {
    pub name: String,
    pub span: Span,
}

#[derive(Debug)]
pub struct TypeEnv {
    scopes: Vec<HashMap<String, VarInfo>>,
    pub type_aliases: HashMap<String, Type>,
    pub enum_types: HashMap<String, Type>,
    pub functions: HashMap<String, Type>,
    pub fn_spans: HashMap<String, Span>,
    /// Known namespace identifiers (e.g., "json", "fs", "process", "channel")
    /// used as static method targets: `json.stringify()`, `fs.read()`, etc.
    pub namespaces: HashSet<String>,
    /// Annotations on type fields, keyed by type name.
    /// Maps type_name -> vec of (field_name, annotations).
    /// Used by validate() and type operator inheritance.
    pub type_annotations: HashMap<String, Vec<(String, Vec<FieldAnnotation>)>>,
    /// Tracks which types are partial (all fields optional, only present fields validated)
    pub partial_types: HashSet<String>,
    /// Trait declarations: trait_name -> list of required method names (methods without default bodies)
    pub trait_methods: HashMap<String, Vec<String>>,
    /// All trait method names: trait_name -> list of all method names (required + default)
    pub trait_all_methods: HashMap<String, Vec<String>>,
    /// Methods declared via impl blocks: type_name -> list of (method_name, return_type)
    pub type_methods: HashMap<String, Vec<(String, Type)>>,
    /// Traits implemented by types: type_name -> list of trait_names
    pub type_traits: HashMap<String, Vec<String>>,
    /// Type parameters for generic functions: fn_name -> type params
    pub fn_type_params: HashMap<String, Vec<TypeParam>>,
    /// Parameter type names for generic functions: fn_name -> vec of optional type name per param
    pub fn_param_type_names: HashMap<String, Vec<Option<String>>>,
}

impl TypeEnv {
    pub fn new() -> Self {
        let mut env = Self {
            scopes: vec![HashMap::new()],
            type_aliases: HashMap::new(),
            enum_types: HashMap::new(),
            functions: HashMap::new(),
            fn_spans: HashMap::new(),
            namespaces: HashSet::new(),
            type_annotations: HashMap::new(),
            partial_types: HashSet::new(),
            trait_methods: HashMap::new(),
            trait_all_methods: HashMap::new(),
            type_methods: HashMap::new(),
            type_traits: HashMap::new(),
            fn_type_params: HashMap::new(),
            fn_param_type_names: HashMap::new(),
        };
        // Register all built-in functions from the feature registry
        crate::registry::BuiltinFnRegistry::register_all(&mut env);

        // channel() returns int (channel ID) — has Custom return type in registry
        env.functions.insert(
            "channel".to_string(),
            Type::Function {
                params: vec![],
                return_type: Box::new(Type::Int),
            },
        );

        // Runtime helpers used by component template expansion (ptr ↔ string conversion)
        env.functions.insert(
            "strlen".to_string(),
            Type::Function {
                params: vec![Type::Ptr],
                return_type: Box::new(Type::Int),
            },
        );
        env.functions.insert(
            "forge_string_new".to_string(),
            Type::Function {
                params: vec![Type::Ptr, Type::Int],
                return_type: Box::new(Type::String),
            },
        );

        // validate() has complex Result<T, ValidationError> return type
        use crate::features::validation::{field_error_type, validation_error_type, validation_result_type};
        env.functions.insert(
            "validate".to_string(),
            Type::Function {
                params: vec![Type::Unknown, Type::Unknown],
                return_type: Box::new(validation_result_type(&Type::Unknown)),
            },
        );

        // Register ValidationError and FieldError types
        env.type_aliases.insert("FieldError".to_string(), field_error_type());
        env.type_aliases.insert("ValidationError".to_string(), validation_error_type());

        env
    }

    pub fn push_scope(&mut self) {
        self.scopes.push(HashMap::new());
    }

    /// Pop the current scope and return any unused variables
    pub fn pop_scope(&mut self) -> Vec<UnusedVar> {
        let mut unused = Vec::new();
        if let Some(scope) = self.scopes.pop() {
            for (name, info) in &scope {
                if !info.used && !name.starts_with('_') && !name.starts_with("__") && info.def_span.is_some() {
                    unused.push(UnusedVar {
                        name: name.clone(),
                        span: info.def_span.unwrap(),
                    });
                }
            }
        }
        unused
    }

    /// Pop scope without tracking unused variables (for scopes where it doesn't apply)
    pub fn pop_scope_silent(&mut self) {
        self.scopes.pop();
    }

    pub fn define(&mut self, name: String, ty: Type, mutable: bool) {
        if let Some(scope) = self.scopes.last_mut() {
            scope.insert(name, VarInfo { ty, mutable, used: false, def_span: None });
        }
    }

    pub fn define_with_span(&mut self, name: String, ty: Type, mutable: bool, span: Span) {
        if let Some(scope) = self.scopes.last_mut() {
            scope.insert(name, VarInfo { ty, mutable, used: false, def_span: Some(span) });
        }
    }

    pub fn lookup(&self, name: &str) -> Option<&VarInfo> {
        for scope in self.scopes.iter().rev() {
            if let Some(info) = scope.get(name) {
                return Some(info);
            }
        }
        None
    }

    /// Look up a variable and mark it as used
    pub fn lookup_and_mark_used(&mut self, name: &str) -> Option<&VarInfo> {
        for scope in self.scopes.iter_mut().rev() {
            if let Some(info) = scope.get_mut(name) {
                info.used = true;
                return Some(info);
            }
        }
        None
    }

    /// Update the type of a variable in scope (used for closure type inference).
    pub fn update_var_type(&mut self, name: &str, ty: Type) {
        for scope in self.scopes.iter_mut().rev() {
            if let Some(info) = scope.get_mut(name) {
                info.ty = ty;
                return;
            }
        }
    }

    pub fn lookup_function(&self, name: &str) -> Option<&Type> {
        self.functions.get(name)
    }

    /// Return all variable and function names visible in the current scope
    pub fn all_names_in_scope(&self) -> Vec<String> {
        let mut names: Vec<String> = Vec::new();
        for scope in &self.scopes {
            for name in scope.keys() {
                if !names.contains(name) {
                    names.push(name.clone());
                }
            }
        }
        for name in self.functions.keys() {
            if !names.contains(name) {
                names.push(name.clone());
            }
        }
        names
    }

    /// Convert AST Annotation to resolved FieldAnnotation
    pub fn resolve_annotation(ann: &Annotation) -> FieldAnnotation {
        FieldAnnotation {
            name: ann.name.clone(),
            args: ann.args.iter().map(|expr| {
                match expr {
                    Expr::IntLit(v, _) => AnnotationArg::Int(*v),
                    Expr::FloatLit(v, _) => AnnotationArg::Float(*v),
                    Expr::StringLit(v, _) => AnnotationArg::String(v.clone()),
                    Expr::BoolLit(v, _) => AnnotationArg::Bool(*v),
                    Expr::Ident(v, _) => AnnotationArg::Ident(v.clone()),
                    _ => AnnotationArg::Expr(expr.clone()),
                }
            }).collect(),
        }
    }

    /// Convert a list of AST annotations to resolved FieldAnnotations
    pub fn resolve_annotations(anns: &[Annotation]) -> Vec<FieldAnnotation> {
        anns.iter().map(|a| Self::resolve_annotation(a)).collect()
    }

    pub fn resolve_type_name(&self, name: &str) -> Type {
        match name {
            "int" => Type::Int,
            "float" => Type::Float,
            "bool" => Type::Bool,
            "string" => Type::String,
            "void" => Type::Void,
            "ptr" => Type::Ptr,
            _ => {
                if let Some(ty) = self.type_aliases.get(name) {
                    ty.clone()
                } else if let Some(ty) = self.enum_types.get(name) {
                    ty.clone()
                } else {
                    Type::Error
                }
            }
        }
    }
}
