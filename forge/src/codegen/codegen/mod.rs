use inkwell::builder::Builder;
use inkwell::context::Context;
use inkwell::module::Module;
use inkwell::targets::{
    CodeModel, FileType, InitializationConfig, RelocMode, Target, TargetMachine,
};
use inkwell::types::{BasicMetadataTypeEnum, BasicType, BasicTypeEnum, StructType};
use inkwell::values::{
    BasicMetadataValueEnum, BasicValue, BasicValueEnum, FunctionValue, IntValue, PointerValue,
};
use inkwell::AddressSpace;
use inkwell::IntPredicate;
use inkwell::OptimizationLevel;

use crate::driver::driver::{ExportedSymbol, ResolvedImport};
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;
use std::collections::{HashMap, HashSet};
use std::path::Path;

mod collections;
mod control_flow;
mod errors;
mod expressions;
mod extern_ffi;
mod linker;
mod literals;
mod nullability;
mod pattern_match;
mod providers;
mod runtime;
mod scope;
mod statements;
mod strings;
mod traits;
mod types;

/// Information about a model declaration for codegen
#[derive(Debug, Clone)]
pub(super) struct ModelInfo {
    pub(super) name: String,
    pub(super) fields: Vec<ModelField>,
    pub(super) create_fields: Vec<ModelField>,
    pub(super) sql_types: Vec<(String, String)>,
}

/// Information about a service declaration for codegen
#[derive(Debug, Clone)]
pub(super) struct ServiceInfo {
    pub(super) name: String,
    pub(super) for_model: String,
    pub(super) hooks: Vec<ServiceHook>,
    pub(super) methods: Vec<Statement>,
}

/// Information about a server block for codegen
#[derive(Debug, Clone)]
pub(super) struct ServerInfo {
    pub(super) port: i64,
    pub(super) children: Vec<ServerChild>,
}

/// Information about a trait declaration
#[derive(Debug, Clone)]
pub(super) struct TraitInfo {
    pub(super) methods: Vec<TraitMethod>,
}

/// Information about a single impl block method
#[derive(Debug, Clone)]
pub(super) struct ImplMethodInfo {
    pub(super) params: Vec<Param>,
    pub(super) return_type: Option<TypeExpr>,
    pub(super) body: Block,
}

/// Information about an impl block
#[derive(Debug, Clone)]
pub(super) struct ImplInfo {
    pub(super) trait_name: Option<String>,
    pub(super) type_name: String,
    pub(super) methods: HashMap<String, ImplMethodInfo>,
    pub(super) associated_types: Vec<(String, TypeExpr)>,
}

/// Information about a generic function declaration (not yet monomorphized)
#[derive(Debug, Clone)]
pub(super) struct GenericFnInfo {
    pub(super) type_params: Vec<TypeParam>,
    pub(super) params: Vec<Param>,
    pub(super) return_type: Option<TypeExpr>,
    pub(super) body: Block,
}

pub struct Codegen<'ctx> {
    pub context: &'ctx Context,
    pub module: Module<'ctx>,
    pub builder: Builder<'ctx>,
    pub(super) variables: Vec<HashMap<String, (PointerValue<'ctx>, Type)>>,
    pub(super) functions: HashMap<String, FunctionValue<'ctx>>,
    pub(super) type_checker: TypeChecker,
    pub(super) loop_exit_blocks: Vec<(inkwell::basic_block::BasicBlock<'ctx>, Option<PointerValue<'ctx>>)>,
    pub(super) current_fn_return_type: Option<Type>,
    pub(super) imported_globals: HashMap<String, (String, Type)>,
    pub(super) traits: HashMap<String, TraitInfo>,
    pub(super) impls: Vec<ImplInfo>,
    pub(super) generic_fns: HashMap<String, GenericFnInfo>,
    pub(super) monomorphized: HashSet<String>,
    pub(super) named_types: HashMap<String, Type>,
    pub(super) global_mutables: HashMap<String, Type>,
    pub(super) scope_vars: Vec<Vec<(String, Type)>>,
    pub(super) models: HashMap<String, ModelInfo>,
    pub(super) services: HashMap<String, ServiceInfo>,
    pub(super) servers: Vec<ServerInfo>,
    pub uses_model: bool,
    pub uses_http: bool,
}

impl<'ctx> Codegen<'ctx> {
    pub fn new(context: &'ctx Context, module_name: &str) -> Self {
        let module = context.create_module(module_name);
        let builder = context.create_builder();

        Self {
            context,
            module,
            builder,
            variables: vec![HashMap::new()],
            functions: HashMap::new(),
            type_checker: TypeChecker::new(),
            loop_exit_blocks: Vec::new(),
            current_fn_return_type: None,
            imported_globals: HashMap::new(),
            traits: HashMap::new(),
            impls: Vec::new(),
            generic_fns: HashMap::new(),
            monomorphized: HashSet::new(),
            named_types: HashMap::new(),
            global_mutables: HashMap::new(),
            scope_vars: Vec::new(),
            models: HashMap::new(),
            services: HashMap::new(),
            servers: Vec::new(),
            uses_model: false,
            uses_http: false,
        }
    }

    pub fn compile_program(&mut self, program: &Program) {
        self.type_checker.check_program(program);
        self.declare_runtime_functions();

        for stmt in &program.statements {
            match stmt {
                Statement::TypeDecl { name, value, .. } => {
                    let ty = self.type_checker.resolve_type_expr(value);
                    let named_ty = match ty {
                        Type::Struct { fields, .. } => Type::Struct {
                            name: Some(name.clone()),
                            fields,
                        },
                        other => other,
                    };
                    self.named_types.insert(name.clone(), named_ty);
                }
                Statement::TraitDecl { name, methods, .. } => {
                    self.traits.insert(name.clone(), TraitInfo {
                        methods: methods.clone(),
                    });
                }
                Statement::ImplBlock { trait_name, type_name, methods, associated_types, .. } => {
                    let mut method_map = HashMap::new();
                    for m in methods {
                        if let Statement::FnDecl { name, params, return_type, body, .. } = m {
                            method_map.insert(name.clone(), ImplMethodInfo {
                                params: params.clone(),
                                return_type: return_type.clone(),
                                body: body.clone(),
                            });
                        }
                    }
                    self.impls.push(ImplInfo {
                        trait_name: trait_name.clone(),
                        type_name: type_name.clone(),
                        methods: method_map,
                        associated_types: associated_types.clone(),
                    });
                }
                Statement::FnDecl { name, type_params, params, return_type, body, .. } => {
                    if !type_params.is_empty() {
                        self.generic_fns.insert(name.clone(), GenericFnInfo {
                            type_params: type_params.clone(),
                            params: params.clone(),
                            return_type: return_type.clone(),
                            body: body.clone(),
                        });
                    }
                }
                Statement::Mut { name, value, type_ann, .. } => {
                    let ty = type_ann
                        .as_ref()
                        .map(|t| self.type_checker.resolve_type_expr(t))
                        .unwrap_or_else(|| self.infer_type(value));
                    let llvm_ty = self.type_to_llvm_basic(&ty);
                    let global = self.module.add_global(llvm_ty, None, name);
                    global.set_initializer(&llvm_ty.const_zero());
                    self.global_mutables.insert(name.clone(), ty);
                }
                Statement::Use { path, .. } => {
                    if path.len() >= 2 && path[0] == "@std" {
                        if path[1] == "model" { self.uses_model = true; }
                        if path[1] == "http" { self.uses_http = true; }
                    }
                }
                Statement::ModelDecl { name, fields, .. } => {
                    self.register_model(name, fields);
                }
                Statement::ServiceDecl { name, for_model, hooks, methods, .. } => {
                    self.services.insert(name.clone(), ServiceInfo {
                        name: name.clone(),
                        for_model: for_model.clone(),
                        hooks: hooks.clone(),
                        methods: methods.clone(),
                    });
                }
                Statement::ServerBlock { port, children, .. } => {
                    self.uses_http = true;
                    self.servers.push(ServerInfo {
                        port: *port,
                        children: children.clone(),
                    });
                }
                Statement::ExternFn { name, params, return_type, .. } => {
                    self.compile_extern_fn(name, params, return_type.as_ref());
                }
                _ => {}
            }
        }

        self.compile_all_impl_methods();
        self.compile_provider_declarations();

        for stmt in &program.statements {
            if let Statement::FnDecl { name, type_params, params, return_type, .. } = stmt {
                if type_params.is_empty() {
                    self.declare_function(name, params, return_type.as_ref());
                }
            }
        }

        for stmt in &program.statements {
            self.compile_statement(stmt);
        }

        if self.module.get_function("main").is_none() && !self.servers.is_empty() {
            let i32_type = self.context.i32_type();
            let fn_type = i32_type.fn_type(&[], false);
            let function = self.module.add_function("main", fn_type, None);
            self.functions.insert("main".to_string(), function);
            let entry = self.context.append_basic_block(function, "entry");
            self.builder.position_at_end(entry);
            self.emit_provider_init();
            self.emit_server_start();
            self.builder.build_return(Some(&i32_type.const_zero())).unwrap();
        }
    }

    pub fn compile_module_program(&mut self, program: &Program, module_path: &str) {
        if self.module.get_function("forge_println_string").is_none() {
            self.declare_runtime_functions();
        }

        let prefix = module_path.replace('.', "_");
        self.type_checker.check_program(program);

        for stmt in &program.statements {
            if let Statement::FnDecl { name, params, return_type, .. } = stmt {
                let mangled = format!("{}_{}", prefix, name);
                self.declare_function(&mangled, params, return_type.as_ref());
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
                _ => {}
            }
        }
    }

    fn compile_exported_global(
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
                        (import.mangled_name.clone(), self.infer_type_from_expr(value)),
                    );
                }
            }
        }
    }

    pub fn emit_ir(&self) -> String {
        self.module.print_to_string().to_string()
    }
}
