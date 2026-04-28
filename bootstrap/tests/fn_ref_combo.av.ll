; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Op = type { i64, ptr }
%Transform = type { ptr, ptr }

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [7 x i8] c"get_op\00", align 1
@mu_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/fn_ref_combo.av\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"double\00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [10 x i8] c"Transform\00", align 1
@src_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/fn_ref_combo.av\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @double(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, 2
  ret i64 %mul
}

define i64 @triple(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, 3
  ret i64 %mul
}

define i64 @negate(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sub = sub i64 0, %n1
  ret i64 %sub
}

define i64 @apply_all(ptr %0, i64 %1) {
entry:
  %f = alloca ptr, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %x = alloca i64, align 8
  %fns = alloca ptr, align 8
  store ptr %0, ptr %fns, align 8
  store i64 %1, ptr %x, align 8
  %fns1 = load ptr, ptr %fns, align 8
  %2 = call i64 @avra_array_len(ptr %fns1)
  store i64 0, ptr %i, align 8
  store i64 %2, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i2 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i2, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %fns3 = load ptr, ptr %fns, align 8
  %i4 = load i64, ptr %i, align 8
  %3 = call i64 @avra_array_get(ptr %fns3, i64 %i4)
  %cast = inttoptr i64 %3 to ptr
  store ptr %cast, ptr %f, align 8
  %f5 = load i64, ptr %f, align 8
  %x6 = load i64, ptr %x, align 8
  %4 = call i64 @avra_closure_call_1(i64 %f5, i64 %x6)
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %4)
  %widen = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen7 = sext i32 %7 to i64
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i8 = load i64, ptr %i, align 8
  %for_next = add i64 %i8, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  ret i64 0
}

define ptr @get_op(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %op = alloca ptr, align 8
  store ptr %0, ptr %op, align 8
  %op1 = load ptr, ptr %op, align 8
  %tag_ptr = getelementptr inbounds nuw %Op, ptr %op1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193451182
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast6 = inttoptr i64 %match_val to ptr
  ret ptr %cast6

march_arm:                                        ; preds = %entry
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @double to i64))
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 193464819
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @triple to i64))
  %cast5 = ptrtoint ptr %2 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 21)
  unreachable
}

define ptr @pick(i1 %0) {
entry:
  %sif_result = alloca i64, align 8
  %use_first = alloca i1, align 1
  store i1 %0, ptr %use_first, align 8
  %use_first1 = load i1, ptr %use_first, align 8
  store i64 0, ptr %sif_result, align 8
  br i1 %use_first1, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @double to i64))
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @triple to i64))
  %cast2 = ptrtoint ptr %2 to i64
  store i64 %cast2, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast3 = inttoptr i64 %sif_val to ptr
  ret ptr %cast3
}

define i64 @apply_fn(i64 %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store ptr %1, ptr %f, align 8
  %f1 = load i64, ptr %f, align 8
  %x2 = load i64, ptr %x, align 8
  %2 = call i64 @avra_closure_call_1(i64 %f1, i64 %x2)
  ret i64 %2
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %handler = alloca ptr, align 8
  %ife_result = alloca i64, align 8
  %op2 = alloca ptr, align 8
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  %op = alloca ptr, align 8
  %t = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @double to i64))
  %cast = ptrtoint ptr %2 to i64
  %fld_ptr = getelementptr inbounds nuw %Transform, ptr %1, i32 0, i32 0
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %fld_ptr, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Transform, ptr %1, i32 0, i32 1
  store ptr @.str, ptr %fld_ptr2, align 8
  %cast3 = ptrtoint ptr %1 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  store ptr %cast4, ptr %t, align 8
  %t5 = load ptr, ptr %t, align 8
  %cast6 = ptrtoint ptr %t5 to i64
  %null_chk = icmp eq i64 %cast6, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 9, i64 %null_ext, ptr @src_file, i64 98, i64 38)
  %name_ptr = getelementptr inbounds nuw %Transform, ptr %t5, i32 0, i32 1
  %name = load ptr, ptr %name_ptr, align 8
  %3 = call i64 @strlen(ptr %name)
  %4 = call i64 @strlen(ptr @.str.1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr %name, i64 %3)
  %cast7 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast7, %3
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast8, ptr @.str.1, i64 %rhs_len_p1)
  %t9 = load ptr, ptr %t, align 8
  %fn_field_ptr = getelementptr inbounds nuw %Transform, ptr %t9, i32 0, i32 0
  %fn_field_val = load i64, ptr %fn_field_ptr, align 8
  %8 = call i64 @avra_closure_call_1(i64 %fn_field_val, i64 7)
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.2, i64 %8)
  %widen = sext i32 %10 to i64
  %11 = call i64 @strlen(ptr %5)
  %12 = call i64 @strlen(ptr %9)
  %concat_total10 = add i64 %11, %12
  %concat_size11 = add i64 %concat_total10, 1
  %13 = call ptr @avra_rc_alloc(i64 %concat_size11)
  %14 = call ptr @memcpy(ptr %13, ptr %5, i64 %11)
  %cast12 = ptrtoint ptr %13 to i64
  %dst2_int13 = add i64 %cast12, %11
  %cast14 = inttoptr i64 %dst2_int13 to ptr
  %rhs_len_p115 = add i64 %12, 1
  %15 = call ptr @memcpy(ptr %cast14, ptr %9, i64 %rhs_len_p115)
  %16 = call i32 @puts(ptr %13)
  %widen16 = sext i32 %16 to i64
  %17 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Op, ptr %17, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Op, ptr %17, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast17 = ptrtoint ptr %17 to i64
  %cast18 = inttoptr i64 %cast17 to ptr
  %18 = call ptr @get_op(ptr %cast18)
  store ptr %18, ptr %op, align 8
  %op19 = load i64, ptr %op, align 8
  %19 = call i64 @avra_closure_call_1(i64 %op19, i64 5)
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.3, i64 %19)
  %widen20 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen21 = sext i32 %22 to i64
  %23 = call ptr @pick(i1 false)
  store ptr %23, ptr %f, align 8
  %f22 = load i64, ptr %f, align 8
  %24 = call i64 @avra_closure_call_1(i64 %f22, i64 4)
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.4, i64 %24)
  %widen23 = sext i32 %26 to i64
  %27 = call i32 @puts(ptr %25)
  %widen24 = sext i32 %27 to i64
  %28 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %28, i64 -559038737)
  call void @avra_array_push(ptr %28, i64 ptrtoint (ptr @double to i64))
  %cast25 = ptrtoint ptr %28 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  store ptr %cast26, ptr %g, align 8
  %g27 = load i64, ptr %g, align 8
  %cast28 = inttoptr i64 %g27 to ptr
  %29 = call i64 @avra_array_get(ptr %cast28, i64 1)
  %fn_ptr = inttoptr i64 %29 to ptr
  %closure_call = call i64 %fn_ptr(i64 3)
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.5, i64 %closure_call)
  %widen29 = sext i32 %31 to i64
  %32 = call i32 @puts(ptr %30)
  %widen30 = sext i32 %32 to i64
  %33 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %33, i64 -559038737)
  call void @avra_array_push(ptr %33, i64 ptrtoint (ptr @negate to i64))
  %cast31 = ptrtoint ptr %33 to i64
  %cast32 = inttoptr i64 %cast31 to ptr
  store ptr %cast32, ptr %g, align 8
  %g33 = load i64, ptr %g, align 8
  %cast34 = inttoptr i64 %g33 to ptr
  %34 = call i64 @avra_array_get(ptr %cast34, i64 1)
  %fn_ptr35 = inttoptr i64 %34 to ptr
  %closure_call36 = call i64 %fn_ptr35(i64 3)
  %35 = call ptr @avra_rc_alloc(i64 32)
  %36 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %35, i64 32, ptr @.i2s_fmt.6, i64 %closure_call36)
  %widen37 = sext i32 %36 to i64
  %37 = call i32 @puts(ptr %35)
  %widen38 = sext i32 %37 to i64
  %38 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %38, i64 -559038737)
  call void @avra_array_push(ptr %38, i64 ptrtoint (ptr @triple to i64))
  %cast39 = ptrtoint ptr %38 to i64
  %cast40 = inttoptr i64 %cast39 to ptr
  %39 = call i64 @apply_fn(i64 10, ptr %cast40)
  %40 = call ptr @avra_rc_alloc(i64 32)
  %41 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %40, i64 32, ptr @.i2s_fmt.7, i64 %39)
  %widen41 = sext i32 %41 to i64
  %42 = call i32 @puts(ptr %40)
  %widen42 = sext i32 %42 to i64
  %43 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr43 = getelementptr inbounds nuw %Op, ptr %43, i32 0, i32 0
  store i64 193464819, ptr %tag_ptr43, align 8
  %pay_ptr44 = getelementptr inbounds nuw %Op, ptr %43, i32 0, i32 1
  store ptr null, ptr %pay_ptr44, align 8
  %cast45 = ptrtoint ptr %43 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  store ptr %cast46, ptr %op2, align 8
  %op247 = load ptr, ptr %op2, align 8
  %tag_ptr48 = getelementptr inbounds nuw %Op, ptr %op247, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr48, align 8
  %is_eq = icmp eq i64 %tag, 193464819
  %is_eq_ext = zext i1 %is_eq to i64
  %ife_cond = icmp ne i64 %is_eq_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %cast51 = inttoptr i64 %ife_val to ptr
  store ptr %cast51, ptr %handler, align 8
  %handler52 = load i64, ptr %handler, align 8
  %cast53 = inttoptr i64 %handler52 to ptr
  %44 = call i64 @avra_array_get(ptr %cast53, i64 1)
  %fn_ptr54 = inttoptr i64 %44 to ptr
  %closure_call55 = call i64 %fn_ptr54(i64 6)
  %45 = call ptr @avra_rc_alloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @.i2s_fmt.8, i64 %closure_call55)
  %widen56 = sext i32 %46 to i64
  %47 = call i32 @puts(ptr %45)
  %widen57 = sext i32 %47 to i64
  %t_cleanup = load ptr, ptr %t, align 8
  %48 = call i64 @__release_Transform(ptr %t_cleanup)
  ret i64 0

ife_then:                                         ; preds = %entry
  %49 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %49, i64 -559038737)
  call void @avra_array_push(ptr %49, i64 ptrtoint (ptr @triple to i64))
  %cast49 = ptrtoint ptr %49 to i64
  store i64 %cast49, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %50 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %50, i64 -559038737)
  call void @avra_array_push(ptr %50, i64 ptrtoint (ptr @double to i64))
  %cast50 = ptrtoint ptr %50 to i64
  store i64 %cast50, ptr %ife_result, align 8
  br label %ife_end
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Transform(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_apply_ptr = getelementptr inbounds nuw %Transform, ptr %0, i32 0, i32 0
  %rel_apply = load ptr, ptr %rel_apply_ptr, align 8
  %is_null_apply = icmp eq ptr %rel_apply, null
  br i1 %is_null_apply, label %rel_apply_skip, label %rel_apply_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_apply_skip:                                   ; preds = %rel_apply_do, %do_free
  %rel_name_ptr = getelementptr inbounds nuw %Transform, ptr %0, i32 0, i32 1
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

rel_apply_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_apply)
  br label %rel_apply_skip

rel_name_skip:                                    ; preds = %rel_name_do, %rel_apply_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %rel_apply_skip
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}
