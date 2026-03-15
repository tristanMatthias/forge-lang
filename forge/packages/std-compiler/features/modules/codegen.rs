use crate::codegen::codegen::Codegen;
use crate::parser::ast::{Expr, Statement, TypeExpr};

use super::types::{ExportedSymbol, ResolvedImport};

impl<'ctx> Codegen<'ctx> {
    /// Compile a module's functions with name-mangled prefixes.
    pub fn compile_module_program(&mut self, program: &crate::parser::ast::Program, module_path: &str) {
        if self.module.get_function("forge_println_string").is_none() {
            self.declare_runtime_functions();
        }

        let prefix = module_path.replace('.', "_");
        self.type_checker.check_program(program);

        for stmt in &program.statements {
            match stmt {
                Statement::FnDecl { name, params, return_type, .. } => {
                    let mangled = format!("{}_{}", prefix, name);
                    self.declare_function(&mangled, params, return_type.as_ref());
                }
                Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => {
                    self.declare_module_functions_feature(fe, &prefix);
                }
                _ => {}
            }
        }

        for stmt in &program.statements {
            match stmt {
                Statement::FnDecl { name, params, return_type, body, .. } => {
                    let mangled = format!("{}_{}", prefix, name);
                    self.compile_fn(&mangled, params, return_type.as_ref(), body);
                }
                Statement::Let { name, value, type_ann, exported: true, .. }
                | Statement::Const { name, value, type_ann, exported: true, .. } => {
                    let mangled = format!("{}_{}", prefix, name);
                    self.compile_exported_global(&mangled, value, type_ann.as_ref());
                }
                Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => {
                    self.compile_module_functions_feature(fe, &prefix);
                }
                Statement::Feature(fe) if fe.feature_id == "variables" => {
                    use crate::feature_data;
                    use crate::features::variables::types::VarDeclData;
                    if let Some(data) = feature_data!(fe, VarDeclData) {
                        if data.exported {
                            let mangled = format!("{}_{}", prefix, data.name);
                            self.compile_exported_global(&mangled, &data.value, data.type_ann.as_ref());
                        }
                    }
                }
                _ => {}
            }
        }
    }

    /// Inject resolved imports into the codegen function/global lookup tables.
    pub fn inject_imports(&mut self, imports: &[ResolvedImport]) {
        for import in imports {
            match &import.symbol {
                ExportedSymbol::Function { .. } => {
                    if let Some(func) = self.module.get_function(&import.mangled_name) {
                        self.functions.insert(import.local_name.clone(), func);
                    }
                }
                ExportedSymbol::Value { value, .. } => {
                    self.imported_globals.insert(
                        import.local_name.clone(),
                        (import.mangled_name.clone(), self.infer_type(value)),
                    );
                }
                ExportedSymbol::ComponentBlock { .. } => {
                    // Component blocks are injected into the AST by the driver,
                    // not handled by codegen import injection.
                }
            }
        }
    }

    /// Compile an exported global value (used by module compilation).
    pub(crate) fn compile_exported_global(
        &mut self,
        mangled_name: &str,
        value: &Expr,
        type_ann: Option<&TypeExpr>,
    ) {
        let ty = type_ann
            .map(|t| self.type_checker.resolve_type_expr(t))
            .unwrap_or_else(|| self.infer_type(value));

        match value {
            Expr::IntLit(n, _) => {
                let llvm_ty = self.context.i64_type();
                let global = self.module.add_global(llvm_ty, None, mangled_name);
                global.set_initializer(&llvm_ty.const_int(*n as u64, true));
                global.set_constant(true);
            }
            Expr::FloatLit(n, _) => {
                let llvm_ty = self.context.f64_type();
                let global = self.module.add_global(llvm_ty, None, mangled_name);
                global.set_initializer(&llvm_ty.const_float(*n));
                global.set_constant(true);
            }
            Expr::BoolLit(b, _) => {
                let llvm_ty = self.context.i8_type();
                let global = self.module.add_global(llvm_ty, None, mangled_name);
                global.set_initializer(&llvm_ty.const_int(if *b { 1 } else { 0 }, false));
                global.set_constant(true);
            }
            Expr::StringLit(s, _) => {
                let string_type = self.string_type();
                let global = self.module.add_global(string_type, None, mangled_name);
                global.set_initializer(&string_type.const_zero());

                let init_name = format!("{}_init", mangled_name);
                let fn_type = self.context.void_type().fn_type(&[], false);
                let init_fn = self.module.add_function(&init_name, fn_type, None);
                let entry = self.context.append_basic_block(init_fn, "entry");
                self.builder.position_at_end(entry);

                let str_val = self.build_string_literal(s);
                self.builder
                    .build_store(global.as_pointer_value(), str_val)
                    .unwrap();
                self.builder.build_return(None).unwrap();
            }
            _ => {
                let llvm_ty = self.type_to_llvm_basic(&ty);
                let global = self.module.add_global(llvm_ty, None, mangled_name);
                global.set_initializer(&llvm_ty.const_zero());
            }
        }
    }
}
