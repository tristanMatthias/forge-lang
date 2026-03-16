// Pointer operations type checking.
//
// Handles:
// - ptr[index] → int (byte read)
// - ptr + int → ptr (offset)
// - ptr - ptr → int (distance)
// - ptr == ptr / ptr != ptr → bool
// - ptr == null / null == ptr → bool
// - string.from_ptr(ptr, int) → string
// - ptr.from_string(string) → ptr

use crate::typeck::TypeChecker;
use crate::typeck::types::Type;
use crate::parser::ast::{BinaryOp, Expr};

impl TypeChecker {
    /// Check if an index expression on ptr type is valid.
    /// ptr[index] where index is int → returns int (byte value)
    pub(crate) fn check_ptr_index(&mut self, index: &Expr) -> Type {
        let idx_type = self.check_expr(index);
        if idx_type != Type::Int && idx_type != Type::Unknown {
            // TODO: emit diagnostic — index must be int
        }
        Type::Int
    }

    /// Check ptr binary operations.
    /// Returns Some(result_type) if this is a ptr operation, None otherwise.
    pub(crate) fn check_ptr_binary(&self, left: &Type, op: &BinaryOp, right: &Type) -> Option<Type> {
        match (left, op, right) {
            // ptr + int → ptr
            (Type::Ptr, BinaryOp::Add, Type::Int) => Some(Type::Ptr),
            // ptr - ptr → int
            (Type::Ptr, BinaryOp::Sub, Type::Ptr) => Some(Type::Int),
            // ptr == ptr, ptr != ptr → bool
            (Type::Ptr, BinaryOp::Eq | BinaryOp::NotEq, Type::Ptr) => Some(Type::Bool),
            // ptr == null, ptr != null → bool
            (Type::Ptr, BinaryOp::Eq | BinaryOp::NotEq, Type::Nullable(_)) => Some(Type::Bool),
            (Type::Nullable(_), BinaryOp::Eq | BinaryOp::NotEq, Type::Ptr) => Some(Type::Bool),
            _ => None,
        }
    }

    /// Check calls to string.from_ptr(ptr, int) and ptr.from_string(string).
    /// Returns Some(result_type) if this is a bridge call, None otherwise.
    pub(crate) fn check_ptr_bridge_call(&mut self, object: &str, method: &str, args: &[Expr]) -> Option<Type> {
        match (object, method) {
            ("string", "from_ptr") => {
                if args.len() == 2 {
                    let _ptr_type = self.check_expr(&args[0]);
                    let _len_type = self.check_expr(&args[1]);
                    // TODO: validate types
                }
                Some(Type::String)
            }
            ("ptr", "from_string") => {
                if args.len() == 1 {
                    let _str_type = self.check_expr(&args[0]);
                }
                Some(Type::Ptr)
            }
            _ => None,
        }
    }
}
