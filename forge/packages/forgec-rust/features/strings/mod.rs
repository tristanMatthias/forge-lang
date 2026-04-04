crate::forge_feature! {
    name: "Strings",
    id: "strings",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "String methods: length, upper, lower, trim, contains, split, starts_with, ends_with, replace, parse_int, repeat, char_at, byte_at, bytes, chars, char_code, index_of, last_index_of",
    syntax: ["\"hello\"", "s.length()", "s.split(sep)", "s.char_at(i)", "s.index_of(sub)", "char_code(s)"],
    short: "UTF-8 strings with built-in methods",
    symbols: [],
    long_description: "\
Strings in Forge are UTF-8 encoded, immutable sequences of characters. String literals use double \
quotes: `\"hello world\"`. Template literals with `${}` interpolation provide the primary way to \
build strings dynamically: `\"Hello, ${name}! You are ${age} years old.\"`.

Strings support a comprehensive set of methods: `length()`, `contains(sub)`, `starts_with(prefix)`, \
`ends_with(suffix)`, `to_upper()`, `to_lower()`, `trim()`, `split(separator)`, `replace(old, new)`, \
`substring(start, end)`, and more. These methods return new strings rather than mutating in place, \
consistent with Forge's immutability-first design.

String comparison uses `==` for value equality, not reference equality. Strings can be concatenated \
with `+`, though template literals are preferred for building complex strings since they are more \
readable and less error-prone than chained concatenation.

Multi-line strings are supported naturally. Forge does not have a separate character type; single \
characters are simply strings of length one.",
    category: "Strings",
    category_order: Primary,
}

crate::builtin_namespace_method! { namespace: "string", method: "from_ptr", feature: "strings", ret: String }
crate::builtin_fn! { name: "char_code", feature: "strings", params: [String], ret: Int, variadic: false }

// Runtime function declarations
crate::runtime_fn! { name: "forge_string_new", feature: "strings", params: [Ptr, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_concat", feature: "strings", params: [ForgeString, ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_int_to_string", feature: "strings", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_to_int", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_float_to_string", feature: "strings", params: [F64], ret: ForgeString }
crate::runtime_fn! { name: "forge_bool_to_string", feature: "strings", params: [I8], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_length", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_string_upper", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_lower", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_trim", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_contains", feature: "strings", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_string_starts_with", feature: "strings", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_string_ends_with", feature: "strings", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_string_replace", feature: "strings", params: [ForgeString, ForgeString, ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_parse_int", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_string_parse_float", feature: "strings", params: [ForgeString], ret: F64 }
crate::runtime_fn! { name: "forge_string_repeat", feature: "strings", params: [ForgeString, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_substring", feature: "strings", params: [ForgeString, I64, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_eq", feature: "strings", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_string_compare", feature: "strings", params: [ForgeString, ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_string_char_at", feature: "strings", params: [ForgeString, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_byte_at", feature: "strings", params: [ForgeString, I64], ret: I64 }
crate::runtime_fn! { name: "forge_string_bytes", feature: "strings", params: [ForgeString, Ptr], ret: I64 }
crate::runtime_fn! { name: "forge_string_chars", feature: "strings", params: [ForgeString, Ptr], ret: I64 }
crate::runtime_fn! { name: "forge_string_index_of", feature: "strings", params: [ForgeString, ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_string_last_index_of", feature: "strings", params: [ForgeString, ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_char_code", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "strlen", feature: "strings", params: [Ptr], ret: I64, conditional: true }

// Token accumulator for mini compiler (O(1) amortized push)
crate::runtime_fn! { name: "forge_tok_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_tok_push", feature: "strings", params: [I64, ForgeString, I64], ret: Void }
crate::runtime_fn! { name: "forge_tok_count", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_tok_to_list", feature: "strings", params: [], ret: ForgeString }

crate::runtime_fn! { name: "forge_write_lines_append", feature: "strings", params: [ForgeString, ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_ir_open", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_ir_line", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_ir_close", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_ir_hoist_begin", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_ir_hoist_end", feature: "strings", params: [], ret: I64 }

crate::runtime_fn! { name: "forge_alloc_stats", feature: "strings", params: [], ret: Void }

// Parser watchdog
crate::runtime_fn! { name: "forge_watchdog", feature: "strings", params: [I64, Ptr], ret: Void }
crate::runtime_fn! { name: "forge_watchdog_reset", feature: "strings", params: [], ret: Void }

// Param type registry
crate::runtime_fn! { name: "forge_param_type_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_param_type_add", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_param_type_get", feature: "strings", params: [I64], ret: ForgeString }

// Param name registry
crate::runtime_fn! { name: "forge_param_name_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_param_name_add", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_param_name_get", feature: "strings", params: [I64], ret: ForgeString }

// Debug
crate::runtime_fn! { name: "forge_debug_enum", feature: "strings", params: [I64, Ptr], ret: Void }

// Pending alloca name
crate::runtime_fn! { name: "forge_set_alloca_name", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_set_alloca_name_c", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_set_last_let_name", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_let_to_alloca_name", feature: "strings", params: [], ret: Void }

// C-side struct var type tracking
crate::runtime_fn! { name: "forge_struct_var_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_struct_var_add", feature: "strings", params: [ForgeString, ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_struct_var_get", feature: "strings", params: [ForgeString], ret: ForgeString }

// Self type tracking for method desugaring
crate::runtime_fn! { name: "forge_set_self_type", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_get_self_type", feature: "strings", params: [], ret: ForgeString }

// C-side variable name tracking (immune to Forge list corruption)
crate::runtime_fn! { name: "forge_var_name_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_var_name_push", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_var_name_exists", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_var_name_set_scope", feature: "strings", params: [I64], ret: Void }

// Function name/return-type registry (immune to Forge list corruption)
crate::runtime_fn! { name: "forge_fn_reg_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_fn_reg_add", feature: "strings", params: [ForgeString, ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_fn_reg_get_ret", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_fn_reg_count", feature: "strings", params: [], ret: I64 }

crate::runtime_fn! { name: "forge_scan_csv", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_scan_csv_set_cb", feature: "strings", params: [Ptr], ret: Void }
crate::runtime_fn! { name: "forge_save_csv", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_csv_byte_at", feature: "strings", params: [I64], ret: I64 }
crate::runtime_fn! { name: "forge_csv_length", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_csv_substr", feature: "strings", params: [I64, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_scan_csv_path", feature: "strings", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_csv_next", feature: "strings", params: [], ret: ForgeString }
crate::runtime_fn! { name: "forge_csv_scan_reset", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_csv_scan_idx", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_csv_has_next", feature: "strings", params: [], ret: I64 }

// Module CSV accumulator
crate::runtime_fn! { name: "forge_mod_csv_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_mod_csv_add", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_mod_csv_get", feature: "strings", params: [], ret: ForgeString }

// Alloca cache
crate::runtime_fn! { name: "forge_alloca_cache_set_fn", feature: "strings", params: [Ptr], ret: Void }
crate::runtime_fn! { name: "forge_alloca_cache_set", feature: "strings", params: [ForgeString, Ptr], ret: I64 }
crate::runtime_fn! { name: "forge_alloca_cache_clear", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_alloca_cache_has", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_alloca_cache_type_id", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_alloca_cache_set_var_type", feature: "strings", params: [ForgeString, ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_alloca_cache_get_var_type", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_alloca_cache_load", feature: "strings", params: [ForgeString, Ptr, Ptr], ret: I64 }
crate::runtime_fn! { name: "forge_alloca_cache_load_field", feature: "strings", params: [ForgeString, ForgeString, I64, Ptr], ret: I64 }
crate::runtime_fn! { name: "forge_emit_depth_push", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_emit_depth_pop", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_enum_type_register", feature: "strings", params: [ForgeString, I64], ret: Void }
crate::runtime_fn! { name: "forge_enum_type_max_fields", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_enum_type_exists", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_enum_variant_fields_set", feature: "strings", params: [ForgeString, ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_enum_variant_fields_get", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_struct_type_register", feature: "strings", params: [ForgeString, ForgeString, ForgeString, ForgeString, Ptr], ret: Void }
crate::runtime_fn! { name: "forge_struct_type_count", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_struct_type_get_fields", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_struct_type_get_field_is_str", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_struct_type_get_field_types", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_struct_field_index", feature: "strings", params: [ForgeString, ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_fn_nullable_set", feature: "strings", params: [I64, Ptr, Ptr], ret: Void }
crate::runtime_fn! { name: "forge_fn_nullable_get_flag", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_fn_nullable_get_inner", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_fn_nullable_get_ret", feature: "strings", params: [], ret: I64 }

// C-side function body store (immune to Forge list push corruption)
crate::runtime_fn! { name: "forge_fn_store_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_fn_store_add", feature: "strings", params: [ForgeString, ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_fn_store_get_body", feature: "strings", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_fn_store_count", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_fn_store_get_name", feature: "strings", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_fn_store_set_param_count", feature: "strings", params: [I64, I64], ret: Void }
crate::runtime_fn! { name: "forge_fn_store_get_param_count", feature: "strings", params: [I64], ret: I64 }
crate::runtime_fn! { name: "forge_alloca_cache_set_type", feature: "strings", params: [ForgeString, Ptr], ret: Void }
crate::runtime_fn! { name: "forge_alloca_cache_get", feature: "strings", params: [ForgeString], ret: Ptr }
crate::runtime_fn! { name: "forge_str_var_add", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_ptr_var_add", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_ptr_var_set_global", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_list_var_add", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_list_var_check", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_set_token_list", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_token_list_len", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_parser_is_at_end", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_parser_advance_pos", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_parser_set_pos", feature: "strings", params: [I64], ret: Void }
crate::runtime_fn! { name: "forge_parser_set_ptr", feature: "strings", params: [Ptr], ret: Void }
crate::runtime_fn! { name: "forge_parser_expect_id", feature: "strings", params: [I64], ret: I64 }
crate::runtime_fn! { name: "forge_parser_is_at_rparen", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_peek_kind_id", feature: "strings", params: [I64], ret: I64 }
crate::runtime_fn! { name: "forge_peek_text", feature: "strings", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_watchdog", feature: "strings", params: [I64, ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_kind_id_for_keyword", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_sh_indexof", feature: "strings", params: [ForgeString, ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_mod_csv_add", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_mod_csv_clear", feature: "strings", params: [], ret: Void }
crate::runtime_fn! { name: "forge_mod_csv_get", feature: "strings", params: [], ret: ForgeString }
crate::runtime_fn! { name: "forge_sh_byteat", feature: "strings", params: [ForgeString, I64], ret: I64 }
crate::runtime_fn! { name: "forge_parser_get_pos", feature: "strings", params: [], ret: I64 }
crate::runtime_fn! { name: "forge_extract_body_source", feature: "strings", params: [ForgeString, I64, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_param_name_add", feature: "strings", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_param_type_add", feature: "strings", params: [ForgeString], ret: Void }

// C-side functions used by self-hosted compiler (detected by check_undeclared.sh)
crate::runtime_fn! { name: "forge_c_index_of", feature: "strings", params: [ForgeString, ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_exit", feature: "strings", params: [I64], ret: Void }
crate::runtime_fn! { name: "forge_keyword_from_range", feature: "strings", params: [Ptr, I64, I64, I64], ret: I64 }
crate::runtime_fn! { name: "forge_map_get", feature: "strings", params: [Ptr, ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_map_has", feature: "strings", params: [Ptr, ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_map_new", feature: "strings", params: [], ret: Ptr }
crate::runtime_fn! { name: "forge_map_set", feature: "strings", params: [Ptr, ForgeString, I64], ret: Void }
crate::runtime_fn! { name: "forge_memcpy", feature: "strings", params: [Ptr, Ptr, I64], ret: Void }
crate::runtime_fn! { name: "forge_selfhost_get_arg", feature: "strings", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_sh_substr", feature: "strings", params: [ForgeString, I64, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_to_float", feature: "strings", params: [ForgeString], ret: F64 }
crate::runtime_fn! { name: "forge_var_type_get", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_var_type_set", feature: "strings", params: [ForgeString, ForgeString], ret: Void }

pub mod checker;
pub mod codegen;
