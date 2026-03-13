use crate::lexer::Span;
use crate::typeck::types::Type;
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
        };
        // Register built-in functions
        env.functions.insert(
            "println".to_string(),
            Type::Function {
                params: vec![Type::String],
                return_type: Box::new(Type::Void),
            },
        );
        env.functions.insert(
            "print".to_string(),
            Type::Function {
                params: vec![Type::String],
                return_type: Box::new(Type::Void),
            },
        );
        env.functions.insert(
            "string".to_string(),
            Type::Function {
                params: vec![Type::Unknown],
                return_type: Box::new(Type::String),
            },
        );
        env.functions.insert(
            "assert".to_string(),
            Type::Function {
                params: vec![Type::Bool],
                return_type: Box::new(Type::Void),
            },
        );
        env.functions.insert(
            "sleep".to_string(),
            Type::Function {
                params: vec![Type::Int],
                return_type: Box::new(Type::Void),
            },
        );
        env.functions.insert(
            "channel".to_string(),
            Type::Function {
                params: vec![],
                return_type: Box::new(Type::Int),
            },
        );
        // Runtime helper functions used by component template expansion
        env.functions.insert(
            "forge_string_new".to_string(),
            Type::Function {
                params: vec![Type::Ptr, Type::Int],
                return_type: Box::new(Type::String),
            },
        );
        env.functions.insert(
            "strlen".to_string(),
            Type::Function {
                params: vec![Type::Ptr],
                return_type: Box::new(Type::Int),
            },
        );
        // Register built-in namespaces (static method targets handled by codegen)
        env.namespaces.insert("json".to_string());
        env.namespaces.insert("string".to_string());
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
