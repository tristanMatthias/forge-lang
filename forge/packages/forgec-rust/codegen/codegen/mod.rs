use inkwell::builder::Builder;
use inkwell::context::Context;
use inkwell::module::Module;
use inkwell::targets::{
    CodeModel, FileType, InitializationConfig, RelocMode, Target, TargetMachine,
};
use inkwell::types::{BasicMetadataTypeEnum, BasicType, BasicTypeEnum, StructType};
use inkwell::values::{
    BasicMetadataValueEnum, BasicValueEnum, FunctionValue, IntValue, PointerValue,
};
use inkwell::AddressSpace;
use inkwell::IntPredicate;
use inkwell::OptimizationLevel;

use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;
use std::collections::{HashMap, HashSet};
use std::path::Path;

mod control_flow;
mod dispatch;
mod expressions;
mod linker;
mod literals;
mod runtime;
mod scope;
mod statements;
mod tagged;
mod types;

/// Information about a service declaration (used by component_expand for mount resolution)
#[derive(Debug, Clone)]
pub struct ServiceInfo {
    pub name: String,
    pub for_model: String,
    pub hooks: Vec<ServiceHook>,
    pub methods: Vec<Statement>,
}

/// Information about a trait declaration
#[derive(Debug, Clone)]
pub(crate) struct TraitInfo {
    pub(crate) methods: Vec<TraitMethod>,
}

/// Information about a single impl block method
#[derive(Debug, Clone)]
pub(crate) struct ImplMethodInfo {
    pub(crate) params: Vec<Param>,
    pub(crate) return_type: Option<TypeExpr>,
    pub(crate) body: Block,
}

/// Information about an impl block
#[derive(Debug, Clone)]
pub(crate) struct ImplInfo {
    pub(crate) trait_name: Option<String>,
    pub(crate) type_name: String,
    pub(crate) methods: HashMap<String, ImplMethodInfo>,
    pub(crate) associated_types: Vec<(String, TypeExpr)>,
}

/// Information about a generic function declaration (not yet monomorphized)
#[derive(Debug, Clone)]
pub(crate) struct GenericFnInfo {
    pub(crate) type_params: Vec<TypeParam>,
    pub(crate) params: Vec<Param>,
    pub(crate) return_type: Option<TypeExpr>,
    pub(crate) body: Block,
}

pub struct Codegen<'ctx> {
    pub context: &'ctx Context,
    pub module: Module<'ctx>,
    pub builder: Builder<'ctx>,
    pub(crate) variables: Vec<HashMap<String, (PointerValue<'ctx>, Type)>>,
    pub(crate) functions: HashMap<String, FunctionValue<'ctx>>,
    pub(crate) type_checker: TypeChecker,
    pub(crate) loop_exit_blocks: Vec<(
        inkwell::basic_block::BasicBlock<'ctx>,
        Option<PointerValue<'ctx>>,
    )>,
    pub(crate) loop_continue_blocks: Vec<inkwell::basic_block::BasicBlock<'ctx>>,
    pub(crate) current_fn_return_type: Option<Type>,
    pub(crate) current_fn_name: Option<String>,
    pub(crate) imported_globals: HashMap<String, (String, Type)>,
    pub(crate) traits: HashMap<String, TraitInfo>,
    pub(crate) impls: Vec<ImplInfo>,
    pub(crate) generic_fns: HashMap<String, GenericFnInfo>,
    pub(crate) monomorphized: HashSet<String>,
    pub(crate) named_types: HashMap<String, Type>,
    pub(crate) global_mutables: HashMap<String, Type>,
    pub(crate) initialized_globals: HashSet<String>,
    pub(crate) scope_vars: Vec<Vec<(String, Type)>>,
    pub static_methods: HashMap<(String, String), String>,
    pub fn_return_types: HashMap<String, Type>,
    pub(crate) json_parse_hint: Option<Type>,
    pub(crate) struct_target_type: Option<Type>,
    pub(crate) deferred_stmts: Vec<Expr>,
    pub source_file: String,
    /// Type of the last value returned from a block expression, captured before scope pop.
    /// Used by `let` statements to correctly type variables assigned from blocks.
    pub(crate) last_block_result_type: Option<Type>,
    /// When true, compile_call skips auto-wrapping ptr→ForgeString for extern fns.
    /// Set when `let x: ptr = extern_fn(...)` — the caller wants the raw pointer.
    pub(crate) suppress_string_wrap: bool,
    /// Cache for LLVM struct types keyed by a type key string.
    /// Uses RefCell so type_to_llvm_basic can stay &self.
    pub(crate) llvm_type_cache:
        std::cell::RefCell<HashMap<String, inkwell::types::BasicTypeEnum<'ctx>>>,
}

// ─── Codegen step-by-step IR dump ────────────────────────────────
//
// Set FORGE_DEBUG_DUMP=<fn_name> to dump the current function's IR
// after every instrumented codegen step. Files land in
// /tmp/forge_dump/NNNN_label.ll, sequentially numbered. Diff between
// consecutive files shows exactly which step produced what change.
// This is the diagnostic that should have existed for the
// "%ec vs %enum_tmp" investigation in this session — without it
// you waste hours on eprintlns. With it, the bisect is one run.

static DBG_DUMP_SEQ: std::sync::atomic::AtomicU64 = std::sync::atomic::AtomicU64::new(0);

fn dbg_dump_target() -> Option<String> {
    std::env::var("FORGE_DEBUG_DUMP")
        .ok()
        .filter(|s| !s.is_empty())
}

impl<'ctx> Codegen<'ctx> {
    /// Dump the current function's IR to /tmp/forge_dump/NNNN_label.ll
    /// if FORGE_DEBUG_DUMP matches the current function or contains "*".
    /// No-op when env var unset (zero overhead).
    pub fn dbg_dump(&self, label: &str) {
        let target = match dbg_dump_target() {
            Some(t) => t,
            None => return,
        };
        let cur = match self.current_fn_name.as_ref() {
            Some(n) => n,
            None => return,
        };
        if target != "*" && cur != &target {
            return;
        }
        let func = match self.module.get_function(cur) {
            Some(f) => f,
            None => return,
        };
        let _ = std::fs::create_dir_all("/tmp/forge_dump");
        let seq = DBG_DUMP_SEQ.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        let safe_label: String = label
            .chars()
            .map(|c| {
                if c.is_alphanumeric() || c == '_' || c == '.' {
                    c
                } else {
                    '_'
                }
            })
            .collect();
        let path = format!("/tmp/forge_dump/{:04}_{}_{}.ll", seq, cur, safe_label);
        use inkwell::values::AnyValue;
        let ir = func.print_to_string().to_string();
        let _ = std::fs::write(&path, ir);
    }
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
            loop_continue_blocks: Vec::new(),
            current_fn_return_type: None,
            current_fn_name: None,
            imported_globals: HashMap::new(),
            traits: HashMap::new(),
            impls: Vec::new(),
            generic_fns: HashMap::new(),
            monomorphized: HashSet::new(),
            named_types: HashMap::new(),
            global_mutables: HashMap::new(),
            initialized_globals: HashSet::new(),
            scope_vars: Vec::new(),
            static_methods: HashMap::new(),
            fn_return_types: HashMap::new(),
            json_parse_hint: None,
            struct_target_type: None,
            llvm_type_cache: std::cell::RefCell::new(HashMap::new()),
            deferred_stmts: Vec::new(),
            source_file: String::new(),
            suppress_string_wrap: false,
            last_block_result_type: None,
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
                    self.traits.insert(
                        name.clone(),
                        TraitInfo {
                            methods: methods.clone(),
                        },
                    );
                }
                Statement::ImplBlock {
                    trait_name,
                    type_name,
                    methods,
                    associated_types,
                    ..
                } => {
                    let mut method_map = HashMap::new();
                    for m in methods {
                        if let Statement::FnDecl {
                            name,
                            params,
                            return_type,
                            body,
                            ..
                        } = m
                        {
                            method_map.insert(
                                name.clone(),
                                ImplMethodInfo {
                                    params: params.clone(),
                                    return_type: return_type.clone(),
                                    body: body.clone(),
                                },
                            );
                        }
                    }
                    self.impls.push(ImplInfo {
                        trait_name: trait_name.clone(),
                        type_name: type_name.clone(),
                        methods: method_map,
                        associated_types: associated_types.clone(),
                    });
                }
                Statement::FnDecl {
                    name,
                    type_params,
                    params,
                    return_type,
                    body,
                    ..
                } => {
                    if !type_params.is_empty() {
                        self.generic_fns.insert(
                            name.clone(),
                            GenericFnInfo {
                                type_params: type_params.clone(),
                                params: params.clone(),
                                return_type: return_type.clone(),
                                body: body.clone(),
                            },
                        );
                    }
                }
                Statement::Mut {
                    name,
                    value,
                    type_ann,
                    ..
                } => {
                    let ty = type_ann
                        .as_ref()
                        .map(|t| self.type_checker.resolve_type_expr(t))
                        .unwrap_or_else(|| self.infer_type(value));
                    let llvm_ty = self.type_to_llvm_basic(&ty);
                    let global = self.module.add_global(llvm_ty, None, name);
                    global.set_initializer(&llvm_ty.const_zero());
                    self.global_mutables.insert(name.clone(), ty);
                }
                Statement::ExternFn {
                    name,
                    params,
                    return_type,
                    ..
                } => {
                    self.compile_extern_fn(name, params, return_type.as_ref());
                }
                Statement::Feature(fe) => match fe.feature_id {
                    "structs" => self.compile_program_structs_feature(fe),
                    "traits" => self.compile_program_traits_feature(fe),
                    "functions" => self.compile_program_functions_feature(fe),
                    "variables" => self.compile_program_variables_feature(fe),
                    _ => {}
                },
                _ => {}
            }
        }

        // Pre-populate LLVM type cache for all known types.
        // Run twice: first pass creates named types (some with wrong bodies due to
        // forward references). Second pass updates bodies with correct field types
        // (now all named types exist).
        for _ in 0..2 {
            // Clear cache to force re-resolution on second pass
            self.llvm_type_cache.borrow_mut().clear();
            let type_aliases: Vec<_> = self
                .type_checker
                .env
                .type_aliases
                .clone()
                .into_iter()
                .collect();
            for (_, ty) in &type_aliases {
                self.type_to_llvm_basic(ty);
            }
            let enum_types: Vec<_> = self
                .type_checker
                .env
                .enum_types
                .clone()
                .into_iter()
                .collect();
            for (_, ty) in &enum_types {
                self.type_to_llvm_basic(ty);
            }
        }

        // Declare all named functions first (before impl method compilation)
        // This ensures impl methods can call any user-defined function.
        for stmt in &program.statements {
            match stmt {
                Statement::FnDecl {
                    name,
                    type_params,
                    params,
                    return_type,
                    ..
                } => {
                    if type_params.is_empty() {
                        self.declare_function(name, params, return_type.as_ref());
                    }
                }
                Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => {
                    self.declare_program_functions_feature(fe);
                }
                _ => {}
            }
        }

        self.compile_all_impl_methods();
        self.generate_vtables();

        // Declare helper functions (snprintf, route helpers, etc.)
        self.declare_package_functions();

        // Check if we need to auto-wrap top-level statements in main()
        let has_explicit_main = program.statements.iter().any(|s| match s {
            Statement::FnDecl { name, .. } => name == "main",
            Statement::Feature(fe) => Self::is_feature_main_fn(fe),
            _ => false,
        });
        let has_top_level_stmts = program.statements.iter().any(|s| match s {
            Statement::FnDecl { .. }
            | Statement::TypeDecl { .. }
            | Statement::TraitDecl { .. }
            | Statement::ImplBlock { .. }
            | Statement::ExternFn { .. }
            | Statement::Mut { .. }
            | Statement::ModDecl { .. } => false,
            Statement::Feature(fe) => !Self::is_feature_declaration_only(fe),
            _ => true,
        });

        if !has_explicit_main && has_top_level_stmts {
            // Auto-main: compile declarations first, then wrap top-level stmts in main()
            let mut top_level_stmts = Vec::new();
            for stmt in &program.statements {
                match stmt {
                    Statement::FnDecl { .. }
                    | Statement::TypeDecl { .. }
                    | Statement::TraitDecl { .. }
                    | Statement::ImplBlock { .. }
                    | Statement::ExternFn { .. }
                    | Statement::ModDecl { .. } => {
                        self.compile_statement(stmt);
                    }
                    Statement::Mut { .. } => {
                        // Compile in declaration pass (creates global) AND add to
                        // top-level stmts so the initializer runs inside auto-main.
                        self.compile_statement(stmt);
                        top_level_stmts.push(stmt.clone());
                    }
                    Statement::Feature(fe) if Self::is_feature_declaration_only(fe) => {
                        self.compile_statement(stmt);
                        // Mut feature stmts need to also run inside auto-main to
                        // initialize the global variable value (same as Statement::Mut).
                        if fe.feature_id == "variables" && fe.kind == "Mut" {
                            top_level_stmts.push(stmt.clone());
                        }
                    }
                    _ => {
                        top_level_stmts.push(stmt.clone());
                    }
                }
            }

            // Create main() wrapping top-level statements
            let i32_type = self.context.i32_type();
            let fn_type = i32_type.fn_type(&[], false);
            let function = self.module.add_function("main", fn_type, None);
            self.functions.insert("main".to_string(), function);
            let entry = self.context.append_basic_block(function, "entry");
            self.builder.position_at_end(entry);

            // Call __forge_startup if it exists
            if let Some(startup_fn) = self.module.get_function("__forge_startup") {
                self.builder.build_call(startup_fn, &[], "").unwrap();
            }

            for stmt in &top_level_stmts {
                self.compile_statement(stmt);
            }

            // Call __forge_main_end if it exists
            if let Some(main_end_fn) = self.module.get_function("__forge_main_end") {
                self.builder.build_call(main_end_fn, &[], "").unwrap();
            }

            // Return 0
            if self
                .builder
                .get_insert_block()
                .map_or(true, |b| b.get_terminator().is_none())
            {
                self.builder
                    .build_return(Some(&i32_type.const_zero()))
                    .unwrap();
            }
        } else {
            // Normal path: compile declarations first, then main() handles the rest.
            // Global mut inits must happen inside main() (not at file scope) because
            // Map {} initialization needs runtime allocation.
            let mut deferred_global_inits: Vec<Statement> = Vec::new();
            let mut deferred_expr_stmts: Vec<Statement> = Vec::new();
            let mut deferred_names: HashSet<String> = HashSet::new();
            for stmt in &program.statements {
                match stmt {
                    // Defer ALL global variable inits to main() startup
                    // Skip duplicates (module merge can produce both Statement::Mut and Feature)
                    Statement::Mut { name, .. } => {
                        if deferred_names.insert(name.clone()) {
                            deferred_global_inits.push(stmt.clone());
                        }
                    }
                    Statement::Let { name, .. } | Statement::Const { name, .. } => {
                        if deferred_names.insert(name.clone()) {
                            deferred_global_inits.push(stmt.clone());
                        }
                    }
                    Statement::Feature(fe) if fe.feature_id == "variables" => {
                        use crate::features::variables::types::VarDeclData;
                        let name = crate::feature_data!(fe, VarDeclData)
                            .map(|d| d.name.clone())
                            .unwrap_or_default();
                        if name.is_empty() || deferred_names.insert(name) {
                            deferred_global_inits.push(stmt.clone());
                        }
                    }
                    // ALL non-declaration stmts must run inside a function
                    _ => {
                        if Self::is_stmt_declaration_only(stmt) {
                            self.compile_statement(stmt);
                        } else {
                            deferred_expr_stmts.push(stmt.clone());
                        }
                    }
                }
            }
            // Compile deferred stmts in small batched functions to avoid
            // stack corruption from too many operations in one block.
            let all_deferred: Vec<Statement> = deferred_global_inits
                .iter()
                .chain(deferred_expr_stmts.iter())
                .cloned()
                .collect();
            if !all_deferred.is_empty() {
                let batch_size = 3; // Small batches to minimize stack pressure
                let mut batch_fns: Vec<inkwell::values::FunctionValue> = Vec::new();
                for (batch_idx, chunk) in all_deferred.chunks(batch_size).enumerate() {
                    let init_name = format!("__global_init_{}", batch_idx);
                    let void_type = self.context.void_type();
                    let fn_type = void_type.fn_type(&[], false);
                    let init_fn = self.module.add_function(&init_name, fn_type, None);
                    let entry = self.context.append_basic_block(init_fn, "entry");
                    self.builder.position_at_end(entry);
                    for stmt in chunk {
                        self.compile_statement(stmt);
                    }
                    self.builder.build_return(None).unwrap();
                    batch_fns.push(init_fn);
                }

                if let Some(main_fn) = self.module.get_function("main") {
                    let first_bb = main_fn.get_first_basic_block().unwrap();
                    let init_bb = self.context.prepend_basic_block(first_bb, "global_init");
                    self.builder.position_at_end(init_bb);
                    for init_fn in &batch_fns {
                        self.builder.build_call(*init_fn, &[], "").unwrap();
                    }
                    self.builder.build_unconditional_branch(first_bb).unwrap();
                }
            }

            if self.module.get_function("main").is_none() {
                let has_startup = self.module.get_function("__forge_startup").is_some();
                let has_main_end = self.module.get_function("__forge_main_end").is_some();
                if has_startup || has_main_end {
                    let i32_type = self.context.i32_type();
                    let fn_type = i32_type.fn_type(&[], false);
                    let function = self.module.add_function("main", fn_type, None);
                    self.functions.insert("main".to_string(), function);
                    let entry = self.context.append_basic_block(function, "entry");
                    self.builder.position_at_end(entry);
                    if let Some(startup_fn) = self.module.get_function("__forge_startup") {
                        self.builder.build_call(startup_fn, &[], "").unwrap();
                    }
                    if let Some(main_end_fn) = self.module.get_function("__forge_main_end") {
                        self.builder.build_call(main_end_fn, &[], "").unwrap();
                    }
                    self.builder
                        .build_return(Some(&i32_type.const_zero()))
                        .unwrap();
                }
            }
        }
    }

    pub fn emit_ir(&self) -> String {
        self.module.print_to_string().to_string()
    }
}
