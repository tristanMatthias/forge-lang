#[derive(Debug, Clone, PartialEq)]
pub enum Type {
    Int,
    Float,
    Bool,
    String,
    Void,
    Never,
    Ptr,

    Nullable(Box<Type>),
    List(Box<Type>),
    Map(Box<Type>, Box<Type>),
    Tuple(Vec<Type>),

    Struct {
        name: Option<String>,
        fields: Vec<(String, Type)>,
    },
    Enum {
        name: String,
        variants: Vec<EnumVariantType>,
    },
    Function {
        params: Vec<Type>,
        return_type: Box<Type>,
    },

    Result(Box<Type>, Box<Type>),
    Range(Box<Type>),
    Channel(Box<Type>),
    /// Dynamic trait object: stores trait name, dispatched via vtable
    DynTrait(String),

    TypeVar(u32),
    Unknown,
    Error,
}

#[derive(Debug, Clone, PartialEq)]
pub struct EnumVariantType {
    pub name: String,
    pub fields: Vec<(String, Type)>,
    /// Field indices that are heap-allocated (boxed) due to self-referencing.
    pub boxed_fields: Vec<usize>,
}

impl Type {
    pub fn is_numeric(&self) -> bool {
        matches!(self, Type::Int | Type::Float)
    }

    pub fn is_nullable(&self) -> bool {
        matches!(self, Type::Nullable(_))
    }

    pub fn inner_nullable(&self) -> Option<&Type> {
        match self {
            Type::Nullable(inner) => Some(inner),
            _ => None,
        }
    }
}

/// Simplified annotation representation for the type system side table.
/// Unlike AST Annotation (which uses Expr for args), this uses resolved values.
#[derive(Debug, Clone, PartialEq)]
pub struct FieldAnnotation {
    pub name: String,
    pub args: Vec<AnnotationArg>,
}

#[derive(Debug, Clone)]
pub enum AnnotationArg {
    Int(i64),
    Float(f64),
    String(String),
    Bool(bool),
    Ident(String),
    /// Preserved expression tree for @transform closures
    Expr(crate::parser::ast::Expr),
}

impl PartialEq for AnnotationArg {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Self::Int(a), Self::Int(b)) => a == b,
            (Self::Float(a), Self::Float(b)) => a == b,
            (Self::String(a), Self::String(b)) => a == b,
            (Self::Bool(a), Self::Bool(b)) => a == b,
            (Self::Ident(a), Self::Ident(b)) => a == b,
            (Self::Expr(_), Self::Expr(_)) => false, // Exprs are structurally unique
            _ => false,
        }
    }
}

impl std::fmt::Display for Type {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Type::Int => write!(f, "int"),
            Type::Float => write!(f, "float"),
            Type::Bool => write!(f, "bool"),
            Type::String => write!(f, "string"),
            Type::Void => write!(f, "void"),
            Type::Never => write!(f, "never"),
            Type::Ptr => write!(f, "ptr"),
            Type::Nullable(inner) => write!(f, "{}?", inner),
            Type::List(inner) => write!(f, "List<{}>", inner),
            Type::Map(k, v) => write!(f, "Map<{}, {}>", k, v),
            Type::Tuple(elems) => {
                write!(f, "(")?;
                for (i, e) in elems.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{}", e)?;
                }
                write!(f, ")")
            }
            Type::Struct { name, fields } => {
                if let Some(n) = name {
                    write!(f, "{}", n)
                } else {
                    write!(f, "{{ ")?;
                    for (i, (k, v)) in fields.iter().enumerate() {
                        if i > 0 {
                            write!(f, ", ")?;
                        }
                        write!(f, "{}: {}", k, v)?;
                    }
                    write!(f, " }}")
                }
            }
            Type::Enum { name, .. } => write!(f, "{}", name),
            Type::Function {
                params,
                return_type,
            } => {
                write!(f, "(")?;
                for (i, p) in params.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{}", p)?;
                }
                write!(f, ") -> {}", return_type)
            }
            Type::Result(ok, err) => write!(f, "Result<{}, {}>", ok, err),
            Type::Range(inner) => write!(f, "Range<{}>", inner),
            Type::Channel(inner) => write!(f, "channel<{}>", inner),
            Type::DynTrait(name) => write!(f, "dyn {}", name),
            Type::TypeVar(id) => write!(f, "T{}", id),
            Type::Unknown => write!(f, "unknown"),
            Type::Error => write!(f, "<error>"),
        }
    }
}
