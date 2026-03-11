use crate::typeck::types::Type;
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct VarInfo {
    pub ty: Type,
    pub mutable: bool,
}

#[derive(Debug)]
pub struct TypeEnv {
    scopes: Vec<HashMap<String, VarInfo>>,
    pub type_aliases: HashMap<String, Type>,
    pub enum_types: HashMap<String, Type>,
    pub functions: HashMap<String, Type>,
}

impl TypeEnv {
    pub fn new() -> Self {
        let mut env = Self {
            scopes: vec![HashMap::new()],
            type_aliases: HashMap::new(),
            enum_types: HashMap::new(),
            functions: HashMap::new(),
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
        env
    }

    pub fn push_scope(&mut self) {
        self.scopes.push(HashMap::new());
    }

    pub fn pop_scope(&mut self) {
        self.scopes.pop();
    }

    pub fn define(&mut self, name: String, ty: Type, mutable: bool) {
        if let Some(scope) = self.scopes.last_mut() {
            scope.insert(name, VarInfo { ty, mutable });
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

    pub fn lookup_function(&self, name: &str) -> Option<&Type> {
        self.functions.get(name)
    }

    pub fn resolve_type_name(&self, name: &str) -> Type {
        match name {
            "int" => Type::Int,
            "float" => Type::Float,
            "bool" => Type::Bool,
            "string" => Type::String,
            "void" => Type::Void,
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
