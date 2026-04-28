; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Expr = type { i64, ptr }
%Response = type { i64, ptr }
%Response__Error = type { i64, ptr }
%Expr__Add = type { ptr, ptr }

@scores = global i64 0
@grades = global i64 0
@.match_fn = private unnamed_addr constant [5 x i8] c"eval\00", align 1
@mu_file = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.av\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"small positive\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"large positive\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c"big sum\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.match_fn.6 = private unnamed_addr constant [14 x i8] c"classify_expr\00", align 1
@mu_file.7 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.av\00", align 1
@.match_fn.8 = private unnamed_addr constant [4 x i8] c"abs\00", align 1
@mu_file.9 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.av\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"empty\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.13 = private unnamed_addr constant [11 x i8] c"multi-word\00", align 1
@.str.14 = private unnamed_addr constant [12 x i8] c"single word\00", align 1
@.match_fn.15 = private unnamed_addr constant [11 x i8] c"categorize\00", align 1
@mu_file.16 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.av\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"OK\00", align 1
@.str.18 = private unnamed_addr constant [8 x i8] c"Created\00", align 1
@.str.19 = private unnamed_addr constant [9 x i8] c"Success \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.20 = private unnamed_addr constant [15 x i8] c"Server error: \00", align 1
@.str.21 = private unnamed_addr constant [10 x i8] c"Not found\00", align 1
@.str.22 = private unnamed_addr constant [7 x i8] c"Error \00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.match_fn.25 = private unnamed_addr constant [18 x i8] c"describe_response\00", align 1
@mu_file.26 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.av\00", align 1
@.i2s_fmt.27 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.28 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.29 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.30 = private unnamed_addr constant [3 x i8] c"hi\00", align 1
@.str.31 = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@.str.32 = private unnamed_addr constant [21 x i8] c"supercalifragilistic\00", align 1
@.str.33 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.34 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.35 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str.36 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@.str.37 = private unnamed_addr constant [2 x i8] c"F\00", align 1
@.match_fn.38 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.39 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.av\00", align 1
@.str.40 = private unnamed_addr constant [9 x i8] c"internal\00", align 1
@.str.41 = private unnamed_addr constant [8 x i8] c"missing\00", align 1
@.str.42 = private unnamed_addr constant [10 x i8] c"forbidden\00", align 1

declare i32 @puts(ptr)

declare void @avra_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @avra_rc_alloc(i64)

declare void @avra_rc_retain(ptr)

declare void @avra_rc_release(ptr)

declare i64 @avra_rc_should_free(ptr)

declare void @avra_rc_free(ptr)

declare void @avra_rc_suspect(ptr)

declare void @avra_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare i64 @avra_parse_int(ptr)

declare void @exit(i32)

declare void @avra_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @avra_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @avra_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @avra_array_new()

declare void @avra_array_push(ptr, i64)

declare i64 @avra_array_get(ptr, i64)

declare i64 @avra_array_len(ptr)

declare void @avra_array_set(ptr, i64, i64)

declare i64 @avra_array_pop(ptr)

declare ptr @avra_array_slice(ptr, i64, i64)

declare i64 @avra_closure_get_fn(i64)

declare i64 @avra_closure_num_captures(i64)

declare i64 @avra_closure_get_capture(ptr, i64)

declare i64 @avra_closure_call_0(i64)

declare i64 @avra_closure_call_1(i64, i64)

declare i64 @avra_closure_call_2(i64, i64, i64)

declare i64 @avra_closure_call_3(i64, i64, i64, i64)

declare i64 @avra_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @avra_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @avra_array_map(ptr, i64)

declare ptr @avra_array_filter(ptr, i64)

declare void @avra_array_foreach(ptr, i64)

declare i64 @avra_array_reduce(ptr, i64, i64)

declare i64 @avra_array_contains(ptr, i64)

declare i64 @avra_array_index_of(ptr, i64)

declare ptr @avra_array_reverse(ptr)

declare i64 @avra_str_contains(ptr, ptr)

declare i64 @avra_str_starts_with(ptr, ptr)

declare i64 @avra_str_ends_with(ptr, ptr)

declare i64 @avra_str_index_of(ptr, ptr)

declare ptr @avra_str_split(ptr, ptr)

declare ptr @avra_str_replace(ptr, ptr, ptr)

declare ptr @avra_str_trim(ptr)

declare ptr @avra_str_to_upper(ptr)

declare ptr @avra_str_to_lower(ptr)

declare ptr @avra_str_join(ptr, ptr)

declare ptr @avra_str_char_at(ptr, i64)

declare ptr @avra_str_substring(ptr, i64, i64)

declare ptr @avra_str_repeat(ptr, i64)

declare ptr @avra_str_reverse(ptr)

declare ptr @avra_map_new_cstr()

declare void @avra_map_set_cstr(ptr, ptr, i64)

declare i64 @avra_map_get_cstr(ptr, ptr)

declare i64 @avra_map_has_cstr(ptr, ptr)

declare i64 @avra_map_len_cstr(ptr)

declare ptr @avra_map_keys_cstr(ptr)

declare ptr @avra_map_values_cstr(ptr)

declare i64 @avra_map_remove_cstr(ptr, ptr)

declare ptr @avra_file_read(ptr)

declare i64 @avra_file_write(ptr, ptr)

declare i64 @avra_file_exists(ptr)

declare ptr @avra_intmap_new()

declare void @avra_intmap_set(ptr, i64, i64)

declare i64 @avra_intmap_get(ptr, i64)

declare i64 @avra_intmap_has(ptr, i64)

declare i64 @avra_float_parse(ptr)

declare i64 @avra_float_to_string(i64)

declare ptr @avra_format_float(i64, ptr)

declare ptr @avra_format_int(i64, ptr)

declare void @avra_ptr_store_byte(ptr, i64, i64)

declare i64 @avra_string_from_ptr(ptr, i64)

declare i64 @avra_trait_object_new(ptr, i64)

declare i64 @avra_trait_object_value(ptr)

declare ptr @avra_trait_object_vtable(ptr)

declare i64 @avra_datetime_now()

declare i64 @avra_datetime_format(ptr, i64)

declare i64 @avra_datetime_year(ptr)

declare i64 @avra_datetime_month(ptr)

declare i64 @avra_datetime_day(ptr)

declare i64 @avra_datetime_hour(ptr)

declare i64 @avra_datetime_minute(ptr)

declare i64 @avra_datetime_second(ptr)

declare ptr @avra_json_stringify_int(ptr)

declare ptr @avra_json_stringify_string(ptr)

declare ptr @avra_json_stringify_bool(ptr)

declare i64 @avra_json_get_int(ptr, i64)

declare i64 @avra_json_get_string(ptr, i64)

declare i64 @avra_json_get_bool(ptr, i64)

declare i64 @avra_semver_major(ptr)

declare i64 @avra_semver_minor(ptr)

declare i64 @avra_semver_patch(ptr)

declare i64 @avra_semver_compare(ptr, i64)

declare i64 @avra_validate_not_null(ptr, i64)

declare i64 @avra_validate_positive(ptr, i64)

declare i64 @avra_validate_not_empty(ptr, i64)

declare i64 @avra_toml_get_string(ptr, i64)

declare i64 @avra_toml_get_int(ptr, i64)

declare i64 @avra_toml_get_bool(ptr, i64)

declare i64 @avra_toml_get_section_string(ptr, i64, i64)

declare i64 @avra_toml_has_section(ptr, i64)

declare i64 @avra_spawn(ptr)

declare i64 @avra_task_await(ptr)

declare i32 @avra_thread_join(ptr)

declare void @avra_yield()

declare void @avra_scheduler_run()

declare ptr @avra_task_group_new()

declare void @avra_task_group_add(ptr, ptr)

declare void @avra_task_group_await_all(ptr)

declare ptr @avra_channel_new()

declare void @avra_channel_send(ptr, i64)

declare i64 @avra_channel_recv(ptr)

declare i32 @avra_channel_close(ptr)

declare i32 @avra_parallel_run(ptr)

declare i64 @avra_select(ptr, i64)

declare i64 @avra_select_index(ptr)

declare i64 @avra_select_value(ptr)

declare i32 @avra_test_start_spec(ptr)

declare i32 @avra_test_end_spec(ptr)

declare i32 @avra_test_start_given(ptr)

declare i32 @avra_test_end_given(ptr)

declare i64 @avra_test_run_then(ptr, i64)

declare i32 @avra_test_skip(ptr)

declare i32 @avra_test_todo(ptr)

declare i32 @avra_test_summary()

declare void @avra_test_flush()

declare ptr @avra_arena_new()

declare ptr @avra_arena_alloc(ptr, i64)

declare void @avra_arena_destroy(ptr)

declare void @avra_match_unreachable(ptr, i64, ptr, i64)

declare i32 @avra_llvm_is_ptr_value(ptr)

declare ptr @avra_llvm_typeof(ptr)

declare ptr @avra_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @avra_llvm_is_void_value(ptr)

declare void @avra_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @avra_llvm_verify_function(ptr)

declare i64 @avra_llvm_type_kind(ptr)

declare i64 @avra_llvm_int_type_width(ptr)

declare ptr @avra_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @avra_test_roughly(double, double, double)

define i64 @eval(ptr %0) {
entry:
  %b12 = alloca ptr, align 8
  %a9 = alloca ptr, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e = alloca ptr, align 8
  store ptr %0, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %n3 = load i64, ptr %n2, align 8
  store i64 %n3, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %a_slot_base = ptrtoint ptr %payload8 to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @avra_rc_retain(ptr %a)
  store ptr %a, ptr %a9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %b_slot_base = ptrtoint ptr %payload11 to i64
  %b_slot_addr = add i64 %b_slot_base, 8
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load ptr, ptr %b_slot, align 8
  call void @avra_rc_retain(ptr %b)
  store ptr %b, ptr %b12, align 8
  %a13 = load ptr, ptr %a9, align 8
  %1 = call i64 @eval(ptr %a13)
  %b14 = load ptr, ptr %b12, align 8
  %2 = call i64 @eval(ptr %b14)
  %add = add i64 %1, %2
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable
}

define ptr @classify_expr(ptr %0) {
entry:
  %b42 = alloca ptr, align 8
  %a39 = alloca ptr, align 8
  %n27 = alloca i64, align 8
  %n13 = alloca i64, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e = alloca ptr, align 8
  store ptr %0, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm49, %guard_pass48, %march_arm31, %guard_pass30, %guard_pass17, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %n3 = load i64, ptr %n2, align 8
  %eq = icmp eq i64 %n3, 0
  %eq_ext = zext i1 %eq to i64
  %guard = icmp ne i64 %eq_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq6 = icmp eq i64 %tag, 193465909
  br i1 %tag_eq6, label %march_arm4, label %march_next5

guard_pass:                                       ; preds = %march_arm
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %n_slot_base9 = ptrtoint ptr %payload8 to i64
  %n_slot_addr10 = add i64 %n_slot_base9, 0
  %n_slot11 = inttoptr i64 %n_slot_addr10 to ptr
  %n12 = load i64, ptr %n_slot11, align 8
  store i64 %n12, ptr %n13, align 8
  %n14 = load i64, ptr %n13, align 8
  %sgt = icmp sgt i64 %n14, 0
  %sgt_ext = zext i1 %sgt to i64
  %l_bool = icmp ne i64 %sgt_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

march_next5:                                      ; preds = %sc_merge, %march_next
  %tag_eq20 = icmp eq i64 %tag, 193465909
  br i1 %tag_eq20, label %march_arm18, label %march_next19

sc_rhs:                                           ; preds = %march_arm4
  %n15 = load i64, ptr %n13, align 8
  %slt = icmp slt i64 %n15, 10
  %slt_ext = zext i1 %slt to i64
  %r_bool = icmp ne i64 %slt_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %march_arm4
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %guard16 = icmp ne i64 %sc_ext, 0
  br i1 %guard16, label %guard_pass17, label %march_next5

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

guard_pass17:                                     ; preds = %sc_merge
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_arm18:                                      ; preds = %march_next5
  %pay_slot21 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload22 = load ptr, ptr %pay_slot21, align 8
  %n_slot_base23 = ptrtoint ptr %payload22 to i64
  %n_slot_addr24 = add i64 %n_slot_base23, 0
  %n_slot25 = inttoptr i64 %n_slot_addr24 to ptr
  %n26 = load i64, ptr %n_slot25, align 8
  store i64 %n26, ptr %n27, align 8
  %n28 = load i64, ptr %n27, align 8
  %sge = icmp sge i64 %n28, 10
  %sge_ext = zext i1 %sge to i64
  %guard29 = icmp ne i64 %sge_ext, 0
  br i1 %guard29, label %guard_pass30, label %march_next19

march_next19:                                     ; preds = %march_arm18, %march_next5
  %tag_eq33 = icmp eq i64 %tag, 193465909
  br i1 %tag_eq33, label %march_arm31, label %march_next32

guard_pass30:                                     ; preds = %march_arm18
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_arm31:                                      ; preds = %march_next19
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result, align 8
  br label %match_end

march_next32:                                     ; preds = %march_next19
  %tag_eq36 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq36, label %march_arm34, label %march_next35

march_arm34:                                      ; preds = %march_next32
  %pay_slot37 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload38 = load ptr, ptr %pay_slot37, align 8
  %a_slot_base = ptrtoint ptr %payload38 to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @avra_rc_retain(ptr %a)
  store ptr %a, ptr %a39, align 8
  %pay_slot40 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload41 = load ptr, ptr %pay_slot40, align 8
  %b_slot_base = ptrtoint ptr %payload41 to i64
  %b_slot_addr = add i64 %b_slot_base, 8
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load ptr, ptr %b_slot, align 8
  call void @avra_rc_retain(ptr %b)
  store ptr %b, ptr %b42, align 8
  %a43 = load ptr, ptr %a39, align 8
  %1 = call i64 @eval(ptr %a43)
  %b44 = load ptr, ptr %b42, align 8
  %2 = call i64 @eval(ptr %b44)
  %add = add i64 %1, %2
  %sgt45 = icmp sgt i64 %add, 100
  %sgt_ext46 = zext i1 %sgt45 to i64
  %guard47 = icmp ne i64 %sgt_ext46, 0
  br i1 %guard47, label %guard_pass48, label %march_next35

march_next35:                                     ; preds = %march_arm34, %march_next32
  %tag_eq51 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq51, label %march_arm49, label %march_next50

guard_pass48:                                     ; preds = %march_arm34
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %match_result, align 8
  br label %match_end

march_arm49:                                      ; preds = %march_next35
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %match_result, align 8
  br label %match_end

march_next50:                                     ; preds = %march_next35
  call void @avra_match_unreachable(ptr @.match_fn.6, i64 %tag, ptr @mu_file.7, i64 15)
  unreachable
}

define i64 @abs(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  store i64 0, ptr %pmatch_result, align 8
  %x2 = load i64, ptr %x, align 8
  %sge = icmp sge i64 %x2, 0
  %sge_ext = zext i1 %sge to i64
  %pguard = icmp ne i64 %sge_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body4, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  ret i64 %pmatch_val

parm_body:                                        ; preds = %entry
  %x3 = load i64, ptr %x, align 8
  store i64 %x3, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  br label %parm_body4

parm_body4:                                       ; preds = %parm_next
  %x6 = load i64, ptr %x, align 8
  %neg = sub i64 0, %x6
  store i64 %neg, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next5:                                       ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.8, i64 -1, ptr @mu_file.9, i64 34)
  unreachable
}

define ptr @categorize(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  store i64 0, ptr %pmatch_result, align 8
  %s2 = load ptr, ptr %s, align 8
  %1 = call i64 @strlen(ptr %s2)
  %eq = icmp eq i64 %1, 0
  %eq_ext = zext i1 %eq to i64
  %pguard = icmp ne i64 %eq_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body11, %parm_body7, %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %s5 = load ptr, ptr %s, align 8
  %2 = call i64 @strlen(ptr %s5)
  %slt = icmp slt i64 %2, 5
  %slt_ext = zext i1 %slt to i64
  %pguard6 = icmp ne i64 %slt_ext, 0
  br i1 %pguard6, label %parm_body3, label %parm_next4

parm_body3:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; preds = %parm_next
  %s9 = load ptr, ptr %s, align 8
  %3 = call i64 @avra_str_contains(ptr %s9, ptr @.str.12)
  %pguard10 = icmp ne i64 %3, 0
  br i1 %pguard10, label %parm_body7, label %parm_next8

parm_body7:                                       ; preds = %parm_next4
  store i64 ptrtoint (ptr @.str.13 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next8:                                       ; preds = %parm_next4
  br label %parm_body11

parm_body11:                                      ; preds = %parm_next8
  store i64 ptrtoint (ptr @.str.14 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next12:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.15, i64 -1, ptr @mu_file.16, i64 44)
  unreachable
}

define ptr @describe_response(ptr %0) {
entry:
  %msg94 = alloca ptr, align 8
  %code87 = alloca i64, align 8
  %msg72 = alloca ptr, align 8
  %code65 = alloca i64, align 8
  %msg44 = alloca ptr, align 8
  %code41 = alloca i64, align 8
  %code28 = alloca i64, align 8
  %code13 = alloca i64, align 8
  %code2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 229441733419486
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm78, %guard_pass77, %guard_pass47, %march_arm19, %guard_pass18, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast117 = inttoptr i64 %match_val to ptr
  ret ptr %cast117

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %code_slot_base = ptrtoint ptr %payload to i64
  %code_slot_addr = add i64 %code_slot_base, 0
  %code_slot = inttoptr i64 %code_slot_addr to ptr
  %code = load i64, ptr %code_slot, align 8
  store i64 %code, ptr %code2, align 8
  %code3 = load i64, ptr %code2, align 8
  %eq = icmp eq i64 %code3, 200
  %eq_ext = zext i1 %eq to i64
  %guard = icmp ne i64 %eq_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq6 = icmp eq i64 %tag, 229441733419486
  br i1 %tag_eq6, label %march_arm4, label %march_next5

guard_pass:                                       ; preds = %march_arm
  store i64 ptrtoint (ptr @.str.17 to i64), ptr %match_result, align 8
  br label %match_end

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %code_slot_base9 = ptrtoint ptr %payload8 to i64
  %code_slot_addr10 = add i64 %code_slot_base9, 0
  %code_slot11 = inttoptr i64 %code_slot_addr10 to ptr
  %code12 = load i64, ptr %code_slot11, align 8
  store i64 %code12, ptr %code13, align 8
  %code14 = load i64, ptr %code13, align 8
  %eq15 = icmp eq i64 %code14, 201
  %eq_ext16 = zext i1 %eq15 to i64
  %guard17 = icmp ne i64 %eq_ext16, 0
  br i1 %guard17, label %guard_pass18, label %march_next5

march_next5:                                      ; preds = %march_arm4, %march_next
  %tag_eq21 = icmp eq i64 %tag, 229441733419486
  br i1 %tag_eq21, label %march_arm19, label %march_next20

guard_pass18:                                     ; preds = %march_arm4
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %match_result, align 8
  br label %match_end

march_arm19:                                      ; preds = %march_next5
  %pay_slot22 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload23 = load ptr, ptr %pay_slot22, align 8
  %code_slot_base24 = ptrtoint ptr %payload23 to i64
  %code_slot_addr25 = add i64 %code_slot_base24, 0
  %code_slot26 = inttoptr i64 %code_slot_addr25 to ptr
  %code27 = load i64, ptr %code_slot26, align 8
  store i64 %code27, ptr %code28, align 8
  %code29 = load i64, ptr %code28, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %code29)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.19)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.19, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast30 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast30, ptr %1, i64 %rhs_len_p1)
  %cast31 = ptrtoint ptr %5 to i64
  store i64 %cast31, ptr %match_result, align 8
  br label %match_end

march_next20:                                     ; preds = %march_next5
  %tag_eq34 = icmp eq i64 %tag, 210673603023
  br i1 %tag_eq34, label %march_arm32, label %march_next33

march_arm32:                                      ; preds = %march_next20
  %pay_slot35 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload36 = load ptr, ptr %pay_slot35, align 8
  %code_slot_base37 = ptrtoint ptr %payload36 to i64
  %code_slot_addr38 = add i64 %code_slot_base37, 0
  %code_slot39 = inttoptr i64 %code_slot_addr38 to ptr
  %code40 = load i64, ptr %code_slot39, align 8
  store i64 %code40, ptr %code41, align 8
  %pay_slot42 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload43 = load ptr, ptr %pay_slot42, align 8
  %msg_slot_base = ptrtoint ptr %payload43 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 8
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @avra_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg44, align 8
  %code45 = load i64, ptr %code41, align 8
  %sge = icmp sge i64 %code45, 500
  %sge_ext = zext i1 %sge to i64
  %guard46 = icmp ne i64 %sge_ext, 0
  br i1 %guard46, label %guard_pass47, label %march_next33

march_next33:                                     ; preds = %march_arm32, %march_next20
  %tag_eq58 = icmp eq i64 %tag, 210673603023
  br i1 %tag_eq58, label %march_arm56, label %march_next57

guard_pass47:                                     ; preds = %march_arm32
  %msg48 = load ptr, ptr %msg44, align 8
  %8 = call i64 @strlen(ptr @.str.20)
  %9 = call i64 @strlen(ptr %msg48)
  %concat_total49 = add i64 %8, %9
  %concat_size50 = add i64 %concat_total49, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size50)
  %11 = call ptr @memcpy(ptr %10, ptr @.str.20, i64 %8)
  %cast51 = ptrtoint ptr %10 to i64
  %dst2_int52 = add i64 %cast51, %8
  %cast53 = inttoptr i64 %dst2_int52 to ptr
  %rhs_len_p154 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast53, ptr %msg48, i64 %rhs_len_p154)
  %cast55 = ptrtoint ptr %10 to i64
  store i64 %cast55, ptr %match_result, align 8
  br label %match_end

march_arm56:                                      ; preds = %march_next33
  %pay_slot59 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload60 = load ptr, ptr %pay_slot59, align 8
  %code_slot_base61 = ptrtoint ptr %payload60 to i64
  %code_slot_addr62 = add i64 %code_slot_base61, 0
  %code_slot63 = inttoptr i64 %code_slot_addr62 to ptr
  %code64 = load i64, ptr %code_slot63, align 8
  store i64 %code64, ptr %code65, align 8
  %pay_slot66 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload67 = load ptr, ptr %pay_slot66, align 8
  %msg_slot_base68 = ptrtoint ptr %payload67 to i64
  %msg_slot_addr69 = add i64 %msg_slot_base68, 8
  %msg_slot70 = inttoptr i64 %msg_slot_addr69 to ptr
  %msg71 = load ptr, ptr %msg_slot70, align 8
  call void @avra_rc_retain(ptr %msg71)
  store ptr %msg71, ptr %msg72, align 8
  %code73 = load i64, ptr %code65, align 8
  %eq74 = icmp eq i64 %code73, 404
  %eq_ext75 = zext i1 %eq74 to i64
  %guard76 = icmp ne i64 %eq_ext75, 0
  br i1 %guard76, label %guard_pass77, label %march_next57

march_next57:                                     ; preds = %march_arm56, %march_next33
  %tag_eq80 = icmp eq i64 %tag, 210673603023
  br i1 %tag_eq80, label %march_arm78, label %march_next79

guard_pass77:                                     ; preds = %march_arm56
  store i64 ptrtoint (ptr @.str.21 to i64), ptr %match_result, align 8
  br label %match_end

march_arm78:                                      ; preds = %march_next57
  %pay_slot81 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload82 = load ptr, ptr %pay_slot81, align 8
  %code_slot_base83 = ptrtoint ptr %payload82 to i64
  %code_slot_addr84 = add i64 %code_slot_base83, 0
  %code_slot85 = inttoptr i64 %code_slot_addr84 to ptr
  %code86 = load i64, ptr %code_slot85, align 8
  store i64 %code86, ptr %code87, align 8
  %pay_slot88 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload89 = load ptr, ptr %pay_slot88, align 8
  %msg_slot_base90 = ptrtoint ptr %payload89 to i64
  %msg_slot_addr91 = add i64 %msg_slot_base90, 8
  %msg_slot92 = inttoptr i64 %msg_slot_addr91 to ptr
  %msg93 = load ptr, ptr %msg_slot92, align 8
  call void @avra_rc_retain(ptr %msg93)
  store ptr %msg93, ptr %msg94, align 8
  %code95 = load i64, ptr %code87, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.23, i64 %code95)
  %widen96 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.22)
  %16 = call i64 @strlen(ptr %13)
  %concat_total97 = add i64 %15, %16
  %concat_size98 = add i64 %concat_total97, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size98)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.22, i64 %15)
  %cast99 = ptrtoint ptr %17 to i64
  %dst2_int100 = add i64 %cast99, %15
  %cast101 = inttoptr i64 %dst2_int100 to ptr
  %rhs_len_p1102 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast101, ptr %13, i64 %rhs_len_p1102)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.24)
  %concat_total103 = add i64 %20, %21
  %concat_size104 = add i64 %concat_total103, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size104)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast105 = ptrtoint ptr %22 to i64
  %dst2_int106 = add i64 %cast105, %20
  %cast107 = inttoptr i64 %dst2_int106 to ptr
  %rhs_len_p1108 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast107, ptr @.str.24, i64 %rhs_len_p1108)
  %msg109 = load ptr, ptr %msg94, align 8
  %25 = call i64 @strlen(ptr %22)
  %26 = call i64 @strlen(ptr %msg109)
  %concat_total110 = add i64 %25, %26
  %concat_size111 = add i64 %concat_total110, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size111)
  %28 = call ptr @memcpy(ptr %27, ptr %22, i64 %25)
  %cast112 = ptrtoint ptr %27 to i64
  %dst2_int113 = add i64 %cast112, %25
  %cast114 = inttoptr i64 %dst2_int113 to ptr
  %rhs_len_p1115 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast114, ptr %msg109, i64 %rhs_len_p1115)
  %cast116 = ptrtoint ptr %27 to i64
  store i64 %cast116, ptr %match_result, align 8
  br label %match_end

march_next79:                                     ; preds = %march_next57
  call void @avra_match_unreachable(ptr @.match_fn.25, i64 %tag, ptr @mu_file.26, i64 80)
  unreachable
}

define i64 @main() {
entry:
  %g = alloca i64, align 8
  %forin_i111 = alloca i64, align 8
  %forin_len110 = alloca i64, align 8
  %grade = alloca ptr, align 8
  %pmatch_result = alloca i64, align 8
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 8)
  store ptr %1, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 0, ptr %slot, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %2 = call ptr @classify_expr(ptr %cast1)
  %3 = call i32 @puts(ptr %2)
  %widen = sext i32 %3 to i64
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Expr, ptr %4, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Expr, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr3, align 8
  %slot_base4 = ptrtoint ptr %5 to i64
  %slot_addr5 = add i64 %slot_base4, 0
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store i64 5, ptr %slot6, align 8
  %cast7 = ptrtoint ptr %4 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %6 = call ptr @classify_expr(ptr %cast8)
  %7 = call i32 @puts(ptr %6)
  %widen9 = sext i32 %7 to i64
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Expr, ptr %8, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %Expr, ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 8)
  store ptr %9, ptr %pay_ptr11, align 8
  %slot_base12 = ptrtoint ptr %9 to i64
  %slot_addr13 = add i64 %slot_base12, 0
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  store i64 42, ptr %slot14, align 8
  %cast15 = ptrtoint ptr %8 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  %10 = call ptr @classify_expr(ptr %cast16)
  %11 = call i32 @puts(ptr %10)
  %widen17 = sext i32 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %Expr, ptr %12, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %Expr, ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 8)
  store ptr %13, ptr %pay_ptr19, align 8
  %slot_base20 = ptrtoint ptr %13 to i64
  %slot_addr21 = add i64 %slot_base20, 0
  %slot22 = inttoptr i64 %slot_addr21 to ptr
  store i64 -3, ptr %slot22, align 8
  %cast23 = ptrtoint ptr %12 to i64
  %cast24 = inttoptr i64 %cast23 to ptr
  %14 = call ptr @classify_expr(ptr %cast24)
  %15 = call i32 @puts(ptr %14)
  %widen25 = sext i32 %15 to i64
  %16 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %Expr, ptr %16, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %Expr, ptr %16, i32 0, i32 1
  %17 = call ptr @avra_rc_alloc(i64 16)
  store ptr %17, ptr %pay_ptr27, align 8
  %18 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr28 = getelementptr inbounds nuw %Expr, ptr %18, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr28, align 8
  %pay_ptr29 = getelementptr inbounds nuw %Expr, ptr %18, i32 0, i32 1
  %19 = call ptr @avra_rc_alloc(i64 8)
  store ptr %19, ptr %pay_ptr29, align 8
  %slot_base30 = ptrtoint ptr %19 to i64
  %slot_addr31 = add i64 %slot_base30, 0
  %slot32 = inttoptr i64 %slot_addr31 to ptr
  store i64 50, ptr %slot32, align 8
  %cast33 = ptrtoint ptr %18 to i64
  %slot_base34 = ptrtoint ptr %17 to i64
  %slot_addr35 = add i64 %slot_base34, 0
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  %cast37 = inttoptr i64 %cast33 to ptr
  store ptr %cast37, ptr %slot36, align 8
  %20 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %Expr, ptr %20, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %Expr, ptr %20, i32 0, i32 1
  %21 = call ptr @avra_rc_alloc(i64 8)
  store ptr %21, ptr %pay_ptr39, align 8
  %slot_base40 = ptrtoint ptr %21 to i64
  %slot_addr41 = add i64 %slot_base40, 0
  %slot42 = inttoptr i64 %slot_addr41 to ptr
  store i64 60, ptr %slot42, align 8
  %cast43 = ptrtoint ptr %20 to i64
  %slot_base44 = ptrtoint ptr %17 to i64
  %slot_addr45 = add i64 %slot_base44, 8
  %slot46 = inttoptr i64 %slot_addr45 to ptr
  %cast47 = inttoptr i64 %cast43 to ptr
  store ptr %cast47, ptr %slot46, align 8
  %cast48 = ptrtoint ptr %16 to i64
  %cast49 = inttoptr i64 %cast48 to ptr
  %22 = call ptr @classify_expr(ptr %cast49)
  %23 = call i32 @puts(ptr %22)
  %widen50 = sext i32 %23 to i64
  %24 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr51 = getelementptr inbounds nuw %Expr, ptr %24, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr51, align 8
  %pay_ptr52 = getelementptr inbounds nuw %Expr, ptr %24, i32 0, i32 1
  %25 = call ptr @avra_rc_alloc(i64 16)
  store ptr %25, ptr %pay_ptr52, align 8
  %26 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr53 = getelementptr inbounds nuw %Expr, ptr %26, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr53, align 8
  %pay_ptr54 = getelementptr inbounds nuw %Expr, ptr %26, i32 0, i32 1
  %27 = call ptr @avra_rc_alloc(i64 8)
  store ptr %27, ptr %pay_ptr54, align 8
  %slot_base55 = ptrtoint ptr %27 to i64
  %slot_addr56 = add i64 %slot_base55, 0
  %slot57 = inttoptr i64 %slot_addr56 to ptr
  store i64 1, ptr %slot57, align 8
  %cast58 = ptrtoint ptr %26 to i64
  %slot_base59 = ptrtoint ptr %25 to i64
  %slot_addr60 = add i64 %slot_base59, 0
  %slot61 = inttoptr i64 %slot_addr60 to ptr
  %cast62 = inttoptr i64 %cast58 to ptr
  store ptr %cast62, ptr %slot61, align 8
  %28 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr63 = getelementptr inbounds nuw %Expr, ptr %28, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr63, align 8
  %pay_ptr64 = getelementptr inbounds nuw %Expr, ptr %28, i32 0, i32 1
  %29 = call ptr @avra_rc_alloc(i64 8)
  store ptr %29, ptr %pay_ptr64, align 8
  %slot_base65 = ptrtoint ptr %29 to i64
  %slot_addr66 = add i64 %slot_base65, 0
  %slot67 = inttoptr i64 %slot_addr66 to ptr
  store i64 2, ptr %slot67, align 8
  %cast68 = ptrtoint ptr %28 to i64
  %slot_base69 = ptrtoint ptr %25 to i64
  %slot_addr70 = add i64 %slot_base69, 8
  %slot71 = inttoptr i64 %slot_addr70 to ptr
  %cast72 = inttoptr i64 %cast68 to ptr
  store ptr %cast72, ptr %slot71, align 8
  %cast73 = ptrtoint ptr %24 to i64
  %cast74 = inttoptr i64 %cast73 to ptr
  %30 = call ptr @classify_expr(ptr %cast74)
  %31 = call i32 @puts(ptr %30)
  %widen75 = sext i32 %31 to i64
  %32 = call i64 @abs(i64 42)
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.27, i64 %32)
  %widen76 = sext i32 %34 to i64
  %35 = call i32 @puts(ptr %33)
  %widen77 = sext i32 %35 to i64
  %36 = call i64 @abs(i64 -42)
  %37 = call ptr @avra_rc_alloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @.i2s_fmt.28, i64 %36)
  %widen78 = sext i32 %38 to i64
  %39 = call i32 @puts(ptr %37)
  %widen79 = sext i32 %39 to i64
  %40 = call ptr @categorize(ptr @.str.29)
  %41 = call i32 @puts(ptr %40)
  %widen80 = sext i32 %41 to i64
  %42 = call ptr @categorize(ptr @.str.30)
  %43 = call i32 @puts(ptr %42)
  %widen81 = sext i32 %43 to i64
  %44 = call ptr @categorize(ptr @.str.31)
  %45 = call i32 @puts(ptr %44)
  %widen82 = sext i32 %45 to i64
  %46 = call ptr @categorize(ptr @.str.32)
  %47 = call i32 @puts(ptr %46)
  %widen83 = sext i32 %47 to i64
  %48 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %48, i64 95)
  call void @avra_array_push(ptr %48, i64 82)
  call void @avra_array_push(ptr %48, i64 67)
  call void @avra_array_push(ptr %48, i64 91)
  call void @avra_array_push(ptr %48, i64 43)
  call void @avra_array_push(ptr %48, i64 78)
  store ptr %48, ptr @scores, align 8
  %49 = call ptr @avra_array_new()
  store ptr %49, ptr @grades, align 8
  %scores = load ptr, ptr @scores, align 8
  %50 = call i64 @avra_array_len(ptr %scores)
  store i64 %50, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %51 = call i64 @avra_array_get(ptr %scores, i64 %forin_i_val)
  store i64 %51, ptr %s, align 8
  %s84 = load i64, ptr %s, align 8
  store i64 0, ptr %pmatch_result, align 8
  %s85 = load i64, ptr %s, align 8
  %sge = icmp sge i64 %s85, 90
  %sge_ext = zext i1 %sge to i64
  %pguard = icmp ne i64 %sge_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

forin.incr:                                       ; preds = %pmatch_end
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %grades109 = load ptr, ptr @grades, align 8
  %52 = call i64 @avra_array_len(ptr %grades109)
  store i64 %52, ptr %forin_len110, align 8
  store i64 0, ptr %forin_i111, align 8
  br label %forin.cond112

pmatch_end:                                       ; preds = %parm_body104, %parm_body98, %parm_body92, %parm_body86, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast106 = inttoptr i64 %pmatch_val to ptr
  store ptr %cast106, ptr %grade, align 8
  %grades = load ptr, ptr @grades, align 8
  %grade107 = load ptr, ptr %grade, align 8
  %cast108 = ptrtoint ptr %grade107 to i64
  call void @avra_array_push(ptr %grades, i64 %cast108)
  br label %forin.incr

parm_body:                                        ; preds = %forin.body
  store i64 ptrtoint (ptr @.str.33 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %forin.body
  %s88 = load i64, ptr %s, align 8
  %sge89 = icmp sge i64 %s88, 80
  %sge_ext90 = zext i1 %sge89 to i64
  %pguard91 = icmp ne i64 %sge_ext90, 0
  br i1 %pguard91, label %parm_body86, label %parm_next87

parm_body86:                                      ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.34 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next87:                                      ; preds = %parm_next
  %s94 = load i64, ptr %s, align 8
  %sge95 = icmp sge i64 %s94, 70
  %sge_ext96 = zext i1 %sge95 to i64
  %pguard97 = icmp ne i64 %sge_ext96, 0
  br i1 %pguard97, label %parm_body92, label %parm_next93

parm_body92:                                      ; preds = %parm_next87
  store i64 ptrtoint (ptr @.str.35 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next93:                                      ; preds = %parm_next87
  %s100 = load i64, ptr %s, align 8
  %sge101 = icmp sge i64 %s100, 60
  %sge_ext102 = zext i1 %sge101 to i64
  %pguard103 = icmp ne i64 %sge_ext102, 0
  br i1 %pguard103, label %parm_body98, label %parm_next99

parm_body98:                                      ; preds = %parm_next93
  store i64 ptrtoint (ptr @.str.36 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next99:                                      ; preds = %parm_next93
  br label %parm_body104

parm_body104:                                     ; preds = %parm_next99
  store i64 ptrtoint (ptr @.str.37 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next105:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.38, i64 -1, ptr @mu_file.39, i64 60)
  unreachable

forin.cond112:                                    ; preds = %forin.incr114, %forin.exit
  %forin_i_val116 = load i64, ptr %forin_i111, align 8
  %forin_len_val117 = load i64, ptr %forin_len110, align 8
  %forin_cmp118 = icmp slt i64 %forin_i_val116, %forin_len_val117
  br i1 %forin_cmp118, label %forin.body113, label %forin.exit115

forin.body113:                                    ; preds = %forin.cond112
  %53 = call i64 @avra_array_get(ptr %grades109, i64 %forin_i_val116)
  store i64 %53, ptr %g, align 8
  %g119 = load i64, ptr %g, align 8
  %cast120 = inttoptr i64 %g119 to ptr
  %54 = call i32 @puts(ptr %cast120)
  %widen121 = sext i32 %54 to i64
  br label %forin.incr114

forin.incr114:                                    ; preds = %forin.body113
  %forin_i_old122 = load i64, ptr %forin_i111, align 8
  %forin_next123 = add i64 %forin_i_old122, 1
  store i64 %forin_next123, ptr %forin_i111, align 8
  br label %forin.cond112

forin.exit115:                                    ; preds = %forin.cond112
  %55 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr124 = getelementptr inbounds nuw %Response, ptr %55, i32 0, i32 0
  store i64 229441733419486, ptr %tag_ptr124, align 8
  %pay_ptr125 = getelementptr inbounds nuw %Response, ptr %55, i32 0, i32 1
  %56 = call ptr @avra_rc_alloc(i64 8)
  store ptr %56, ptr %pay_ptr125, align 8
  %slot_base126 = ptrtoint ptr %56 to i64
  %slot_addr127 = add i64 %slot_base126, 0
  %slot128 = inttoptr i64 %slot_addr127 to ptr
  store i64 200, ptr %slot128, align 8
  %cast129 = ptrtoint ptr %55 to i64
  %cast130 = inttoptr i64 %cast129 to ptr
  %57 = call ptr @describe_response(ptr %cast130)
  %58 = call i32 @puts(ptr %57)
  %widen131 = sext i32 %58 to i64
  %59 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr132 = getelementptr inbounds nuw %Response, ptr %59, i32 0, i32 0
  store i64 229441733419486, ptr %tag_ptr132, align 8
  %pay_ptr133 = getelementptr inbounds nuw %Response, ptr %59, i32 0, i32 1
  %60 = call ptr @avra_rc_alloc(i64 8)
  store ptr %60, ptr %pay_ptr133, align 8
  %slot_base134 = ptrtoint ptr %60 to i64
  %slot_addr135 = add i64 %slot_base134, 0
  %slot136 = inttoptr i64 %slot_addr135 to ptr
  store i64 201, ptr %slot136, align 8
  %cast137 = ptrtoint ptr %59 to i64
  %cast138 = inttoptr i64 %cast137 to ptr
  %61 = call ptr @describe_response(ptr %cast138)
  %62 = call i32 @puts(ptr %61)
  %widen139 = sext i32 %62 to i64
  %63 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr140 = getelementptr inbounds nuw %Response, ptr %63, i32 0, i32 0
  store i64 229441733419486, ptr %tag_ptr140, align 8
  %pay_ptr141 = getelementptr inbounds nuw %Response, ptr %63, i32 0, i32 1
  %64 = call ptr @avra_rc_alloc(i64 8)
  store ptr %64, ptr %pay_ptr141, align 8
  %slot_base142 = ptrtoint ptr %64 to i64
  %slot_addr143 = add i64 %slot_base142, 0
  %slot144 = inttoptr i64 %slot_addr143 to ptr
  store i64 302, ptr %slot144, align 8
  %cast145 = ptrtoint ptr %63 to i64
  %cast146 = inttoptr i64 %cast145 to ptr
  %65 = call ptr @describe_response(ptr %cast146)
  %66 = call i32 @puts(ptr %65)
  %widen147 = sext i32 %66 to i64
  %67 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr148 = getelementptr inbounds nuw %Response, ptr %67, i32 0, i32 0
  store i64 210673603023, ptr %tag_ptr148, align 8
  %pay_ptr149 = getelementptr inbounds nuw %Response, ptr %67, i32 0, i32 1
  %68 = call ptr @avra_rc_alloc(i64 16)
  store ptr %68, ptr %pay_ptr149, align 8
  %slot_base150 = ptrtoint ptr %68 to i64
  %slot_addr151 = add i64 %slot_base150, 0
  %slot152 = inttoptr i64 %slot_addr151 to ptr
  store i64 500, ptr %slot152, align 8
  %slot_base153 = ptrtoint ptr %68 to i64
  %slot_addr154 = add i64 %slot_base153, 8
  %slot155 = inttoptr i64 %slot_addr154 to ptr
  store ptr @.str.40, ptr %slot155, align 8
  %cast156 = ptrtoint ptr %67 to i64
  %cast157 = inttoptr i64 %cast156 to ptr
  %69 = call ptr @describe_response(ptr %cast157)
  %70 = call i32 @puts(ptr %69)
  %widen158 = sext i32 %70 to i64
  %71 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr159 = getelementptr inbounds nuw %Response, ptr %71, i32 0, i32 0
  store i64 210673603023, ptr %tag_ptr159, align 8
  %pay_ptr160 = getelementptr inbounds nuw %Response, ptr %71, i32 0, i32 1
  %72 = call ptr @avra_rc_alloc(i64 16)
  store ptr %72, ptr %pay_ptr160, align 8
  %slot_base161 = ptrtoint ptr %72 to i64
  %slot_addr162 = add i64 %slot_base161, 0
  %slot163 = inttoptr i64 %slot_addr162 to ptr
  store i64 404, ptr %slot163, align 8
  %slot_base164 = ptrtoint ptr %72 to i64
  %slot_addr165 = add i64 %slot_base164, 8
  %slot166 = inttoptr i64 %slot_addr165 to ptr
  store ptr @.str.41, ptr %slot166, align 8
  %cast167 = ptrtoint ptr %71 to i64
  %cast168 = inttoptr i64 %cast167 to ptr
  %73 = call ptr @describe_response(ptr %cast168)
  %74 = call i32 @puts(ptr %73)
  %widen169 = sext i32 %74 to i64
  %75 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr170 = getelementptr inbounds nuw %Response, ptr %75, i32 0, i32 0
  store i64 210673603023, ptr %tag_ptr170, align 8
  %pay_ptr171 = getelementptr inbounds nuw %Response, ptr %75, i32 0, i32 1
  %76 = call ptr @avra_rc_alloc(i64 16)
  store ptr %76, ptr %pay_ptr171, align 8
  %slot_base172 = ptrtoint ptr %76 to i64
  %slot_addr173 = add i64 %slot_base172, 0
  %slot174 = inttoptr i64 %slot_addr173 to ptr
  store i64 403, ptr %slot174, align 8
  %slot_base175 = ptrtoint ptr %76 to i64
  %slot_addr176 = add i64 %slot_base175, 8
  %slot177 = inttoptr i64 %slot_addr176 to ptr
  store ptr @.str.42, ptr %slot177, align 8
  %cast178 = ptrtoint ptr %75 to i64
  %cast179 = inttoptr i64 %cast178 to ptr
  %77 = call ptr @describe_response(ptr %cast179)
  %78 = call i32 @puts(ptr %77)
  %widen180 = sext i32 %78 to i64
  %79 = call i32 @avra_test_summary()
  %widen181 = sext i32 %79 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Response(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Response, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Response, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Error = icmp eq i64 %tag, 210673603023
  br i1 %is_Error, label %rel_Error, label %try_next_Error

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Error, %vrel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Error:                                        ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %Response__Error, ptr %payload, i32 0, i32 1
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_Error:                                   ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_Error
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_Error
  call void @avra_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}

define i64 @__release_Expr(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Add = icmp eq i64 %tag, 193451182
  br i1 %is_Add, label %rel_Add, label %try_next_Add

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Add, %vrel_b_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Add:                                          ; preds = %do_free
  %vrel_a_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 0
  %vrel_a = load ptr, ptr %vrel_a_ptr, align 8
  %vrel_null_a = icmp eq ptr %vrel_a, null
  br i1 %vrel_null_a, label %vrel_a_skip, label %vrel_a_do

try_next_Add:                                     ; preds = %do_free
  br label %fields_done

vrel_a_skip:                                      ; preds = %vrel_a_do, %rel_Add
  %vrel_b_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 1
  %vrel_b = load ptr, ptr %vrel_b_ptr, align 8
  %vrel_null_b = icmp eq ptr %vrel_b, null
  br i1 %vrel_null_b, label %vrel_b_skip, label %vrel_b_do

vrel_a_do:                                        ; preds = %rel_Add
  %2 = call i64 @__release_Expr(ptr %vrel_a)
  br label %vrel_a_skip

vrel_b_skip:                                      ; preds = %vrel_b_do, %vrel_a_skip
  br label %fields_done

vrel_b_do:                                        ; preds = %vrel_a_skip
  %3 = call i64 @__release_Expr(ptr %vrel_b)
  br label %vrel_b_skip
}
