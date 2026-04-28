; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Expr = type { i64, ptr }
%Box = type { i64, ptr }
%Expr__Add = type { ptr, ptr }

@.match_fn = private unnamed_addr constant [9 x i8] c"map_expr\00", align 1
@mu_file = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.av\00", align 1
@.match_fn.1 = private unnamed_addr constant [5 x i8] c"eval\00", align 1
@mu_file.2 = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.av\00", align 1
@.match_fn.3 = private unnamed_addr constant [11 x i8] c"__lambda_0\00", align 1
@mu_file.4 = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.5 = private unnamed_addr constant [11 x i8] c"__lambda_1\00", align 1
@mu_file.6 = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.av\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @apply(ptr %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  %b = alloca ptr, align 8
  store ptr %0, ptr %b, align 8
  store ptr %1, ptr %f, align 8
  %f1 = load i64, ptr %f, align 8
  %b2 = load ptr, ptr %b, align 8
  %cast = ptrtoint ptr %b2 to i64
  %2 = call i64 @avra_closure_call_1(i64 %f1, i64 %cast)
  ret i64 %2
}

define ptr @map_expr(ptr %0, ptr %1) {
entry:
  %mapped = alloca ptr, align 8
  %r9 = alloca ptr, align 8
  %l6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %f = alloca ptr, align 8
  %expr = alloca ptr, align 8
  store ptr %0, ptr %expr, align 8
  store ptr %1, ptr %f, align 8
  %expr1 = load ptr, ptr %expr, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast19 = inttoptr i64 %match_val to ptr
  store ptr %cast19, ptr %mapped, align 8
  %f20 = load i64, ptr %f, align 8
  %mapped21 = load ptr, ptr %mapped, align 8
  %cast22 = ptrtoint ptr %mapped21 to i64
  %2 = call i64 @avra_closure_call_1(i64 %f20, i64 %cast22)
  %cast23 = inttoptr i64 %2 to ptr
  ret ptr %cast23

march_arm:                                        ; preds = %entry
  %expr2 = load ptr, ptr %expr, align 8
  %cast = ptrtoint ptr %expr2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %l_slot_base = ptrtoint ptr %payload to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @avra_rc_retain(ptr %l)
  store ptr %l, ptr %l6, align 8
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %r_slot_base = ptrtoint ptr %payload8 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @avra_rc_retain(ptr %r)
  store ptr %r, ptr %r9, align 8
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Expr, ptr %3, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr10, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 16)
  store ptr %4, ptr %pay_ptr, align 8
  %l11 = load ptr, ptr %l6, align 8
  %f12 = load ptr, ptr %f, align 8
  %5 = call ptr @map_expr(ptr %l11, ptr %f12)
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %5, ptr %slot, align 8
  %r13 = load ptr, ptr %r9, align 8
  %f14 = load ptr, ptr %f, align 8
  %6 = call ptr @map_expr(ptr %r13, ptr %f14)
  %slot_base15 = ptrtoint ptr %4 to i64
  %slot_addr16 = add i64 %slot_base15, 8
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  store ptr %6, ptr %slot17, align 8
  %cast18 = ptrtoint ptr %3 to i64
  store i64 %cast18, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 13)
  unreachable
}

define i64 @eval(ptr %0) {
entry:
  %r12 = alloca ptr, align 8
  %l9 = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %expr = alloca ptr, align 8
  store ptr %0, ptr %expr, align 8
  %expr1 = load ptr, ptr %expr, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %v3 = load i64, ptr %v2, align 8
  store i64 %v3, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %l_slot_base = ptrtoint ptr %payload8 to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @avra_rc_retain(ptr %l)
  store ptr %l, ptr %l9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %r_slot_base = ptrtoint ptr %payload11 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @avra_rc_retain(ptr %r)
  store ptr %r, ptr %r12, align 8
  %l13 = load ptr, ptr %l9, align 8
  %1 = call i64 @eval(ptr %l13)
  %r14 = load ptr, ptr %r12, align 8
  %2 = call i64 @eval(ptr %r14)
  %add = add i64 %1, %2
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.1, i64 %tag, ptr @mu_file.2, i64 21)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %scaled = alloca ptr, align 8
  %tree = alloca ptr, align 8
  %factor = alloca i64, align 8
  %r = alloca i64, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Box, ptr %1, i32 0, i32 0
  store i64 193473960, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Box, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 21, ptr %slot, align 8
  %cast = ptrtoint ptr %1 to i64
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 -559038737)
  call void @avra_array_push(ptr %3, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast1 = ptrtoint ptr %3 to i64
  %cast2 = inttoptr i64 %cast to ptr
  %cast3 = inttoptr i64 %cast1 to ptr
  %4 = call i64 @apply(ptr %cast2, ptr %cast3)
  store i64 %4, ptr %r, align 8
  %r4 = load i64, ptr %r, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %r4)
  %widen = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen5 = sext i32 %7 to i64
  store i64 3, ptr %factor, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %Expr, ptr %8, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %Expr, ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 16)
  store ptr %9, ptr %pay_ptr7, align 8
  %10 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr8 = getelementptr inbounds nuw %Expr, ptr %10, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr8, align 8
  %pay_ptr9 = getelementptr inbounds nuw %Expr, ptr %10, i32 0, i32 1
  %11 = call ptr @avra_rc_alloc(i64 8)
  store ptr %11, ptr %pay_ptr9, align 8
  %slot_base10 = ptrtoint ptr %11 to i64
  %slot_addr11 = add i64 %slot_base10, 0
  %slot12 = inttoptr i64 %slot_addr11 to ptr
  store i64 1, ptr %slot12, align 8
  %cast13 = ptrtoint ptr %10 to i64
  %slot_base14 = ptrtoint ptr %9 to i64
  %slot_addr15 = add i64 %slot_base14, 0
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  %cast17 = inttoptr i64 %cast13 to ptr
  store ptr %cast17, ptr %slot16, align 8
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %Expr, ptr %12, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %Expr, ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 16)
  store ptr %13, ptr %pay_ptr19, align 8
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr20 = getelementptr inbounds nuw %Expr, ptr %14, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr20, align 8
  %pay_ptr21 = getelementptr inbounds nuw %Expr, ptr %14, i32 0, i32 1
  %15 = call ptr @avra_rc_alloc(i64 8)
  store ptr %15, ptr %pay_ptr21, align 8
  %slot_base22 = ptrtoint ptr %15 to i64
  %slot_addr23 = add i64 %slot_base22, 0
  %slot24 = inttoptr i64 %slot_addr23 to ptr
  store i64 2, ptr %slot24, align 8
  %cast25 = ptrtoint ptr %14 to i64
  %slot_base26 = ptrtoint ptr %13 to i64
  %slot_addr27 = add i64 %slot_base26, 0
  %slot28 = inttoptr i64 %slot_addr27 to ptr
  %cast29 = inttoptr i64 %cast25 to ptr
  store ptr %cast29, ptr %slot28, align 8
  %16 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr30 = getelementptr inbounds nuw %Expr, ptr %16, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr30, align 8
  %pay_ptr31 = getelementptr inbounds nuw %Expr, ptr %16, i32 0, i32 1
  %17 = call ptr @avra_rc_alloc(i64 8)
  store ptr %17, ptr %pay_ptr31, align 8
  %slot_base32 = ptrtoint ptr %17 to i64
  %slot_addr33 = add i64 %slot_base32, 0
  %slot34 = inttoptr i64 %slot_addr33 to ptr
  store i64 3, ptr %slot34, align 8
  %cast35 = ptrtoint ptr %16 to i64
  %slot_base36 = ptrtoint ptr %13 to i64
  %slot_addr37 = add i64 %slot_base36, 8
  %slot38 = inttoptr i64 %slot_addr37 to ptr
  %cast39 = inttoptr i64 %cast35 to ptr
  store ptr %cast39, ptr %slot38, align 8
  %cast40 = ptrtoint ptr %12 to i64
  %slot_base41 = ptrtoint ptr %9 to i64
  %slot_addr42 = add i64 %slot_base41, 8
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  %cast44 = inttoptr i64 %cast40 to ptr
  store ptr %cast44, ptr %slot43, align 8
  %cast45 = ptrtoint ptr %8 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  store ptr %cast46, ptr %tree, align 8
  %tree47 = load ptr, ptr %tree, align 8
  %18 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %18, i64 -559038737)
  call void @avra_array_push(ptr %18, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %factor, align 8
  call void @avra_array_push(ptr %18, i64 %cap_val)
  %cast48 = ptrtoint ptr %18 to i64
  %cast49 = inttoptr i64 %cast48 to ptr
  %19 = call ptr @map_expr(ptr %tree47, ptr %cast49)
  store ptr %19, ptr %scaled, align 8
  %scaled50 = load ptr, ptr %scaled, align 8
  %20 = call i64 @eval(ptr %scaled50)
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.7, i64 %20)
  %widen51 = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen52 = sext i32 %23 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
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

fields_done:                                      ; preds = %try_next_Add, %vrel_right_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Add:                                          ; preds = %do_free
  %vrel_left_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 0
  %vrel_left = load ptr, ptr %vrel_left_ptr, align 8
  %vrel_null_left = icmp eq ptr %vrel_left, null
  br i1 %vrel_null_left, label %vrel_left_skip, label %vrel_left_do

try_next_Add:                                     ; preds = %do_free
  br label %fields_done

vrel_left_skip:                                   ; preds = %vrel_left_do, %rel_Add
  %vrel_right_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 1
  %vrel_right = load ptr, ptr %vrel_right_ptr, align 8
  %vrel_null_right = icmp eq ptr %vrel_right, null
  br i1 %vrel_null_right, label %vrel_right_skip, label %vrel_right_do

vrel_left_do:                                     ; preds = %rel_Add
  %2 = call i64 @__release_Expr(ptr %vrel_left)
  br label %vrel_left_skip

vrel_right_skip:                                  ; preds = %vrel_right_do, %vrel_left_skip
  br label %fields_done

vrel_right_do:                                    ; preds = %vrel_left_skip
  %3 = call i64 @__release_Expr(ptr %vrel_right)
  br label %vrel_right_skip
}

define i64 @__lambda_0(ptr %0) {
entry:
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %b = alloca ptr, align 8
  store ptr %0, ptr %b, align 8
  %b1 = load ptr, ptr %b, align 8
  %tag_ptr = getelementptr inbounds nuw %Box, ptr %b1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193473960
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Box, ptr %b1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %n3 = load i64, ptr %n2, align 8
  %mul = mul i64 %n3, 2
  store i64 %mul, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  br label %march_arm4

march_arm4:                                       ; preds = %march_next
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %tag, ptr @mu_file.4, i64 26)
  unreachable
}

define i64 @__lambda_1(ptr %0, i64 %1) {
entry:
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %factor = alloca i64, align 8
  %e = alloca ptr, align 8
  store ptr %0, ptr %e, align 8
  store i64 %1, ptr %factor, align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Expr, ptr %2, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr3, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %v4 = load i64, ptr %v2, align 8
  %factor5 = load i64, ptr %factor, align 8
  %mul = mul i64 %v4, %factor5
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %mul, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  br label %march_arm6

march_arm6:                                       ; preds = %march_next
  %e8 = load ptr, ptr %e, align 8
  %cast9 = ptrtoint ptr %e8 to i64
  store i64 %cast9, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 32)
  unreachable
}
