use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn string_type(&self) -> StructType<'ctx> {
        self.context.struct_type(
            &[
                self.context.ptr_type(AddressSpace::default()).into(), // ptr
                self.context.i64_type().into(),                        // len
            ],
            false,
        )
    }

    pub(crate) fn to_i1(&self, val: BasicValueEnum<'ctx>) -> IntValue<'ctx> {
        if val.is_int_value() {
            let int_val = val.into_int_value();
            if int_val.get_type().get_bit_width() == 1 {
                return int_val;
            }
            self.builder
                .build_int_compare(
                    IntPredicate::NE,
                    int_val,
                    int_val.get_type().const_zero(),
                    "to_bool",
                )
                .unwrap()
        } else {
            self.context.bool_type().const_int(1, false)
        }
    }

    // ---- Type mapping ----

    /// Returns the number of i64 slots needed to store a value of the given type.
    pub(crate) fn type_i64_slots(&self, ty: &Type) -> usize {
        match ty {
            Type::Int | Type::Float | Type::Bool | Type::Void | Type::Never | Type::Ptr | Type::Unknown | Type::Error => 1,
            Type::String => 2, // {ptr, i64} = 16 bytes
            Type::Nullable(inner) => 1 + self.type_i64_slots(inner), // {i8, inner}
            Type::List(_) | Type::Map(_, _) => 2, // pointer + length or similar
            Type::Tuple(elems) => elems.iter().map(|e| self.type_i64_slots(e)).sum(),
            Type::Struct { fields, .. } => fields.iter().map(|(_, t)| self.type_i64_slots(t)).sum(),
            Type::Enum { .. } => 3, // tag + max variant payload (conservative)
            Type::Function { .. } => 1, // function pointer
            Type::Result(ok, err) => {
                let ok_s = self.type_i64_slots(ok);
                let err_s = self.type_i64_slots(err);
                1 + ok_s.max(err_s) // tag + payload
            }
            Type::Range(_) => 2, // start + end
            Type::TypeVar(_) => 1,
        }
    }

    pub(crate) fn type_to_llvm(&self, ty: &Type) -> BasicTypeEnum<'ctx> {
        self.type_to_llvm_basic(ty)
    }

    pub(crate) fn type_to_llvm_basic(&self, ty: &Type) -> BasicTypeEnum<'ctx> {
        match ty {
            Type::Int => self.context.i64_type().into(),
            Type::Float => self.context.f64_type().into(),
            Type::Bool => self.context.i8_type().into(),
            Type::String => self.string_type().into(),
            Type::Void => self.context.i8_type().into(), // represent void as i8 when needed
            Type::Ptr => self.context.ptr_type(AddressSpace::default()).into(),
            Type::Nullable(inner) => {
                let inner_ty = self.type_to_llvm_basic(inner);
                self.context
                    .struct_type(&[self.context.i8_type().into(), inner_ty.into()], false)
                    .into()
            }
            Type::Struct { fields, .. } => {
                let field_types: Vec<BasicTypeEnum<'ctx>> =
                    fields.iter().map(|(_, t)| self.type_to_llvm_basic(t)).collect();
                self.context
                    .struct_type(
                        &field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                        false,
                    )
                    .into()
            }
            Type::Tuple(elems) => {
                let elem_types: Vec<BasicTypeEnum<'ctx>> =
                    elems.iter().map(|t| self.type_to_llvm_basic(t)).collect();
                self.context
                    .struct_type(
                        &elem_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                        false,
                    )
                    .into()
            }
            Type::Function { .. } => {
                self.context.ptr_type(AddressSpace::default()).into()
            }
            Type::Result(ok, err) => {
                // Compute the number of i64 slots needed for the payload union
                let ok_slots = self.type_i64_slots(ok);
                let err_slots = self.type_i64_slots(err);
                let max_slots = ok_slots.max(err_slots).max(1);
                let mut fields: Vec<BasicTypeEnum<'ctx>> = vec![self.context.i8_type().into()];
                for _ in 0..max_slots {
                    fields.push(self.context.i64_type().into());
                }
                self.context.struct_type(&fields, false).into()
            }
            Type::Range(_) => {
                // Range isn't typically stored as a value; use i64 pair
                self.context
                    .struct_type(
                        &[self.context.i64_type().into(), self.context.i64_type().into()],
                        false,
                    )
                    .into()
            }
            Type::List(_) => {
                // Simplified: pointer + length
                self.context
                    .struct_type(
                        &[
                            self.context.ptr_type(AddressSpace::default()).into(),
                            self.context.i64_type().into(),
                        ],
                        false,
                    )
                    .into()
            }
            Type::Map(_, _) => {
                // Map: {keys_ptr, values_ptr, length}
                self.context
                    .struct_type(
                        &[
                            self.context.ptr_type(AddressSpace::default()).into(), // keys
                            self.context.ptr_type(AddressSpace::default()).into(), // values
                            self.context.i64_type().into(),                        // length
                        ],
                        false,
                    )
                    .into()
            }
            Type::Enum { variants, .. } => {
                // Tagged union: {i8 tag, field1_type, field2_type, ...}
                // Use the largest variant to determine size
                let max_fields = variants.iter().map(|v| v.fields.len()).max().unwrap_or(0);
                let mut field_types: Vec<BasicTypeEnum<'ctx>> = vec![self.context.i8_type().into()];
                // Use the first variant with max fields for layout, or pad with f64 (largest primitive)
                if max_fields > 0 {
                    // Find the variant with most fields
                    let biggest = variants.iter().max_by_key(|v| v.fields.len()).unwrap();
                    for (_, ty) in &biggest.fields {
                        field_types.push(self.type_to_llvm_basic(ty));
                    }
                }
                self.context
                    .struct_type(
                        &field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                        false,
                    )
                    .into()
            }
            _ => self.context.i64_type().into(),
        }
    }

    pub(crate) fn type_to_llvm_metadata(&self, ty: &Type) -> BasicMetadataTypeEnum<'ctx> {
        self.type_to_llvm_basic(ty).into()
    }

    pub(crate) fn default_value(&self, ty: &Type) -> BasicValueEnum<'ctx> {
        match ty {
            Type::Int => self.context.i64_type().const_zero().into(),
            Type::Float => self.context.f64_type().const_float(0.0).into(),
            Type::Bool => self.context.i8_type().const_zero().into(),
            _ => self.context.i64_type().const_zero().into(),
        }
    }

    /// Simple type inference for exported value expressions (typically literals)
    pub(crate) fn infer_type_from_expr(&self, expr: &Expr) -> Type {
        match expr {
            Expr::IntLit(_, _) => Type::Int,
            Expr::FloatLit(_, _) => Type::Float,
            Expr::StringLit(_, _) => Type::String,
            Expr::BoolLit(_, _) => Type::Bool,
            _ => Type::Unknown,
        }
    }

    pub(crate) fn infer_type(&self, expr: &Expr) -> Type {
        match expr {
            Expr::IntLit(_, _) => Type::Int,
            Expr::FloatLit(_, _) => Type::Float,
            Expr::StringLit(_, _) => Type::String,
            Expr::TemplateLit { .. } => Type::String,
            Expr::DollarExec { .. } => Type::String,
            Expr::BoolLit(_, _) | Expr::Is { .. } => Type::Bool,
            Expr::NullLit(_) => Type::Nullable(Box::new(Type::Unknown)),
            Expr::Ident(name, _) => {
                // Check codegen's own variable scope first
                if let Some((_, ty)) = self.lookup_var(name) {
                    ty
                } else if let Some(info) = self.type_checker.env.lookup(name) {
                    info.ty.clone()
                } else if let Some(ty) = self.type_checker.env.lookup_function(name) {
                    ty.clone()
                } else {
                    Type::Unknown
                }
            }
            Expr::Binary { left, op, right, .. } => {
                let lt = self.infer_type(left);
                let rt = self.infer_type(right);
                match op {
                    BinaryOp::Add | BinaryOp::Sub | BinaryOp::Mul | BinaryOp::Div | BinaryOp::Mod => {
                        if lt == Type::Float || rt == Type::Float {
                            Type::Float
                        } else if lt == Type::String {
                            Type::String
                        } else if let Some(type_name) = self.get_type_name(&lt) {
                            // Check for operator overloading
                            let trait_name = match op {
                                BinaryOp::Add => "Add",
                                BinaryOp::Sub => "Sub",
                                BinaryOp::Mul => "Mul",
                                BinaryOp::Div => "Div",
                                _ => "",
                            };
                            if !trait_name.is_empty() {
                                if self.find_operator_impl(&type_name, trait_name, "").is_some() {
                                    // Return the type itself (operator returns same type typically)
                                    return lt;
                                }
                            }
                            Type::Int
                        } else {
                            Type::Int
                        }
                    }
                    _ => Type::Bool,
                }
            }
            Expr::Unary { op, operand, .. } => match op {
                UnaryOp::Not => Type::Bool,
                UnaryOp::Neg => self.infer_type(operand),
            },
            Expr::Call { callee, args, .. } => {
                if let Expr::Ident(name, _) = callee.as_ref() {
                    match name.as_str() {
                        "println" | "print" => Type::Void,
                        "string" => Type::String,
                        "channel" => Type::Int,
                        _ => {
                            // Check for generic functions first
                            if let Some(generic_fn) = self.generic_fns.get(name.as_str()) {
                                // Infer return type by substituting type args
                                if let Some(type_args) = self.infer_type_args(name, args) {
                                    let type_map: HashMap<String, Type> = type_args.into_iter().collect();
                                    if let Some(ref rt) = generic_fn.return_type {
                                        let resolved = self.substitute_type_expr(rt, &type_map);
                                        return self.type_checker.resolve_type_expr(&resolved);
                                    }
                                }
                                return Type::Unknown;
                            }

                            if let Some(Type::Function { return_type, .. }) =
                                self.type_checker.env.lookup_function(name)
                            {
                                *return_type.clone()
                            } else if let Some(info) = self.type_checker.env.lookup(name) {
                                if let Type::Function { return_type, .. } = &info.ty {
                                    *return_type.clone()
                                } else {
                                    Type::Unknown
                                }
                            } else if let Some(ret_ty) = self.fn_return_types.get(name) {
                                ret_ty.clone()
                            } else {
                                Type::Unknown
                            }
                        }
                    }
                } else if let Expr::MemberAccess { object, field, .. } = callee.as_ref() {
                    // json.stringify/parse intrinsics
                    if let Expr::Ident(name, _) = object.as_ref() {
                        if name == "json" {
                            match field.as_str() {
                                "stringify" => return Type::String,
                                _ => {}
                            }
                        }
                        // channel.tick() returns int (channel ID)
                        if name == "channel" && field == "tick" {
                            return Type::Int;
                        }
                    }
                    // Check static_methods registry (for expanded component functions)
                    if let Expr::Ident(name, _) = object.as_ref() {
                        let key = (name.clone(), field.clone());
                        if let Some(fn_name) = self.static_methods.get(&key) {
                            if let Some(ret_ty) = self.fn_return_types.get(fn_name) {
                                return ret_ty.clone();
                            }
                        }
                    }
                    let obj_type = self.infer_type(object);
                    match &obj_type {
                        Type::String => match field.as_str() {
                            "upper" | "lower" | "trim" | "replace" => Type::String,
                            "contains" | "starts_with" => Type::Bool,
                            "length" => Type::Int,
                            "parse_int" => Type::Int,
                            "split" => Type::List(Box::new(Type::String)),
                            _ => Type::Unknown,
                        },
                        Type::List(inner) => match field.as_str() {
                            "filter" => Type::List(inner.clone()),
                            "map" => {
                                // Infer from closure
                                if let Some(first_arg) = args.first() {
                                    let out = self.infer_closure_return_type(first_arg, inner);
                                    Type::List(Box::new(out))
                                } else {
                                    Type::List(Box::new(Type::Unknown))
                                }
                            }
                            "sum" => Type::Int,
                            "find" => Type::Nullable(inner.clone()),
                            "any" | "all" => Type::Bool,
                            "enumerate" => Type::List(Box::new(Type::Tuple(vec![Type::Int, *inner.clone()]))),
                            "join" => Type::String,
                            "reduce" => {
                                if let Some(first_arg) = args.first() {
                                    self.infer_type(&first_arg.value)
                                } else {
                                    Type::Unknown
                                }
                            }
                            "push" => Type::Void,
                            "length" => Type::Int,
                            "sorted" => Type::List(inner.clone()),
                            "each" => Type::Void,
                            _ => Type::Unknown,
                        },
                        Type::Map(key_type, val_type) => match field.as_str() {
                            "has" => Type::Bool,
                            "get" => Type::Nullable(val_type.clone()),
                            "keys" => Type::List(key_type.clone()),
                            _ => Type::Unknown,
                        },
                        _ => {
                            // Check for enum constructor
                            if let Expr::Ident(name, _) = object.as_ref() {
                                if self.type_checker.env.enum_types.contains_key(name) {
                                    return self.type_checker.env.enum_types[name].clone();
                                }
                            }
                            // Check trait methods return type
                            if let Some(type_name) = self.get_type_name(&obj_type) {
                                // Look up trait impl return type
                                for impl_info in &self.impls {
                                    if impl_info.type_name == type_name {
                                        if let Some(method) = impl_info.methods.get(field.as_str()) {
                                            if let Some(ref rt) = method.return_type {
                                                let resolved = self.type_checker.resolve_type_expr(rt);
                                                // If it resolves to unnamed struct matching a named type, use the named version
                                                if let Type::Struct { name: None, fields } = &resolved {
                                                    // Check if this matches any named type
                                                    for (tn, t) in &self.named_types {
                                                        if let Type::Struct { fields: nf, .. } = t {
                                                            if nf == fields {
                                                                return Type::Struct { name: Some(tn.clone()), fields: fields.clone() };
                                                            }
                                                        }
                                                    }
                                                }
                                                return resolved;
                                            }
                                        }
                                    }
                                }
                            }
                            Type::Unknown
                        }
                    }
                } else {
                    Type::Unknown
                }
            }
            Expr::MemberAccess { object, field, .. } => {
                // Check for EnumName.variant
                if let Expr::Ident(name, _) = object.as_ref() {
                    if let Some(enum_ty) = self.type_checker.env.enum_types.get(name) {
                        return enum_ty.clone();
                    }
                }
                let obj_type = self.infer_type(object);
                match &obj_type {
                    Type::Struct { fields, .. } => {
                        fields
                            .iter()
                            .find(|(name, _)| name == field)
                            .map(|(_, ty)| ty.clone())
                            .unwrap_or(Type::Unknown)
                    }
                    Type::String => match field.as_str() {
                        "length" => Type::Int,
                        _ => Type::Unknown,
                    },
                    Type::List(_) => match field.as_str() {
                        "length" => Type::Int,
                        _ => Type::Unknown,
                    },
                    Type::Tuple(elems) => {
                        if let Ok(idx) = field.parse::<usize>() {
                            elems.get(idx).cloned().unwrap_or(Type::Unknown)
                        } else {
                            Type::Unknown
                        }
                    }
                    _ => Type::Unknown,
                }
            }
            Expr::If { then_branch, else_branch, .. } => {
                let then_type = if let Some(last) = then_branch.statements.last() {
                    match last {
                        Statement::Expr(e) => self.infer_type(e),
                        _ => Type::Void,
                    }
                } else {
                    Type::Void
                };
                let else_type = else_branch.as_ref().and_then(|eb| {
                    eb.statements.last().and_then(|s| match s {
                        Statement::Expr(e) => Some(self.infer_type(e)),
                        _ => None,
                    })
                }).unwrap_or(Type::Void);
                // If one branch is nullable (null) and the other is not, wrap in Nullable
                let then_is_null = matches!(then_type, Type::Nullable(_));
                let else_is_null = matches!(else_type, Type::Nullable(_));
                if then_is_null && !else_is_null && else_type != Type::Void {
                    Type::Nullable(Box::new(else_type))
                } else if else_is_null && !then_is_null && then_type != Type::Void {
                    Type::Nullable(Box::new(then_type))
                } else {
                    // Pick the more specific type when one branch is underspecified
                    // e.g. if cond { [] } else { list_of_strings } should be list<string>
                    self.unify_branch_types(&then_type, &else_type)
                }
            }
            Expr::Match { arms, .. } => {
                if let Some(first) = arms.first() {
                    self.infer_type(&first.body)
                } else {
                    Type::Unknown
                }
            }
            Expr::Block(block) => {
                if let Some(last) = block.statements.last() {
                    match last {
                        Statement::Expr(e) => self.infer_type(e),
                        _ => Type::Void,
                    }
                } else {
                    Type::Void
                }
            }
            Expr::NullCoalesce { right, .. } => self.infer_type(right),
            Expr::Range { start, .. } => Type::Range(Box::new(self.infer_type(start))),
            Expr::StructLit { name, fields, .. } => {
                // If named struct, resolve from named_types
                if let Some(ref type_name) = name {
                    if let Some(ty) = self.named_types.get(type_name) {
                        return ty.clone();
                    }
                    if let Some(ty) = self.type_checker.env.type_aliases.get(type_name) {
                        return match ty {
                            Type::Struct { fields: f, name: None } => Type::Struct {
                                name: Some(type_name.clone()),
                                fields: f.clone(),
                            },
                            other => other.clone(),
                        };
                    }
                }
                let field_types: Vec<(String, Type)> = fields
                    .iter()
                    .map(|(name, expr)| (name.clone(), self.infer_type(expr)))
                    .collect();
                Type::Struct {
                    name: name.clone(),
                    fields: field_types,
                }
            }
            Expr::TupleLit { elements, .. } => {
                Type::Tuple(elements.iter().map(|e| self.infer_type(e)).collect())
            }
            Expr::ListLit { elements, .. } => {
                let elem_type = if let Some(first) = elements.first() {
                    self.infer_type(first)
                } else {
                    Type::Unknown
                };
                Type::List(Box::new(elem_type))
            }
            Expr::MapLit { entries, .. } => {
                let (key_type, val_type) = if let Some((k, v)) = entries.first() {
                    (self.infer_type(k), self.infer_type(v))
                } else {
                    (Type::Unknown, Type::Unknown)
                };
                Type::Map(Box::new(key_type), Box::new(val_type))
            }
            Expr::OkExpr { value, .. } => {
                Type::Result(Box::new(self.infer_type(value)), Box::new(Type::String))
            }
            Expr::ErrExpr { value, .. } => {
                Type::Result(Box::new(Type::Unknown), Box::new(self.infer_type(value)))
            }
            Expr::Catch { expr, handler, .. } => {
                let et = self.infer_type(expr);
                match &et {
                    Type::Result(ok, _) => {
                        let ok_type = *ok.clone();
                        // If Ok type is Unknown (e.g., generic with no info),
                        // use the handler's last expression type instead
                        if matches!(ok_type, Type::Unknown) {
                            handler.statements.iter().rev().find_map(|s| {
                                if let Statement::Expr(e) = s { Some(self.infer_type(e)) } else { None }
                            }).unwrap_or(ok_type)
                        } else {
                            ok_type
                        }
                    }
                    _ => et,
                }
            }
            Expr::Closure { .. } => Type::Function {
                params: vec![],
                return_type: Box::new(Type::Unknown),
            },
            Expr::Pipe { left, right, .. } => self.infer_pipe_type(left, right),
            Expr::ErrorPropagate { operand, .. } => {
                let ot = self.infer_type(operand);
                match &ot {
                    Type::Result(ok, _) => *ok.clone(),
                    _ => ot,
                }
            }
            Expr::TableLit { columns, rows, .. } => {
                let fields: Vec<(String, Type)> = if let Some(first_row) = rows.first() {
                    columns.iter().zip(first_row.iter())
                        .map(|(name, expr)| (name.clone(), self.infer_type(expr)))
                        .collect()
                } else {
                    columns.iter().map(|n| (n.clone(), Type::Unknown)).collect()
                };
                Type::List(Box::new(Type::Struct { name: None, fields }))
            }
            Expr::Index { object, .. } => {
                let obj_type = self.infer_type(object);
                match &obj_type {
                    Type::List(inner) => *inner.clone(),
                    Type::String => Type::String,
                    _ => Type::Unknown,
                }
            }
            Expr::With { base, .. } => self.infer_type(base),
            Expr::NullPropagate { object, field, .. } => {
                let ot = self.infer_type(object);
                let inner = match &ot {
                    Type::Nullable(inner) => inner.as_ref(),
                    _ => &ot,
                };
                match inner {
                    Type::Struct { fields, .. } => {
                        fields.iter().find(|(n, _)| n == field)
                            .map(|(_, ty)| Type::Nullable(Box::new(ty.clone())))
                            .unwrap_or(Type::Unknown)
                    }
                    Type::String => match field.as_str() {
                        "length" | "parse_int" => Type::Nullable(Box::new(Type::Int)),
                        "upper" | "lower" | "trim" | "replace" => Type::Nullable(Box::new(Type::String)),
                        "contains" | "starts_with" => Type::Nullable(Box::new(Type::Bool)),
                        _ => Type::Unknown,
                    },
                    _ => Type::Unknown,
                }
            }
            _ => Type::Unknown,
        }
    }

    /// Infer the return type of a method call on a given type
    pub(crate) fn infer_method_return_type(&self, obj_type: &Type, method: &str, args: &[CallArg]) -> Type {
        match obj_type {
            Type::String => match method {
                "upper" | "lower" | "trim" | "replace" => Type::String,
                "contains" | "starts_with" => Type::Bool,
                "length" | "parse_int" => Type::Int,
                "split" => Type::List(Box::new(Type::String)),
                _ => Type::Unknown,
            },
            Type::List(inner) => match method {
                "filter" => Type::List(inner.clone()),
                "map" => {
                    if let Some(first_arg) = args.first() {
                        let out = self.infer_closure_return_type(first_arg, inner);
                        Type::List(Box::new(out))
                    } else {
                        Type::List(Box::new(Type::Unknown))
                    }
                }
                "sum" => Type::Int,
                "find" => Type::Nullable(inner.clone()),
                "any" | "all" => Type::Bool,
                "enumerate" => Type::List(Box::new(Type::Tuple(vec![Type::Int, *inner.clone()]))),
                "join" => Type::String,
                "reduce" => {
                    if let Some(first_arg) = args.first() {
                        self.infer_type(&first_arg.value)
                    } else {
                        Type::Unknown
                    }
                }
                "push" | "each" => Type::Void,
                "length" => Type::Int,
                "sorted" => Type::List(inner.clone()),
                _ => Type::Unknown,
            },
            _ => Type::Unknown,
        }
    }

    /// Unify two branch types, preferring the more specific one.
    /// For example, List(Unknown) unified with List(String) yields List(String).
    /// Unknown unified with any concrete type yields the concrete type.
    pub(crate) fn unify_branch_types(&self, a: &Type, b: &Type) -> Type {
        match (a, b) {
            // If one side is Unknown, prefer the other
            (Type::Unknown, other) | (other, Type::Unknown) => other.clone(),
            // Unify inner types for List
            (Type::List(inner_a), Type::List(inner_b)) => {
                Type::List(Box::new(self.unify_branch_types(inner_a, inner_b)))
            }
            // Unify inner types for Nullable
            (Type::Nullable(inner_a), Type::Nullable(inner_b)) => {
                Type::Nullable(Box::new(self.unify_branch_types(inner_a, inner_b)))
            }
            // Unify inner types for Map
            (Type::Map(ka, va), Type::Map(kb, vb)) => {
                Type::Map(
                    Box::new(self.unify_branch_types(ka, kb)),
                    Box::new(self.unify_branch_types(va, vb)),
                )
            }
            // Default: prefer the first (then) branch
            _ => a.clone(),
        }
    }
}
