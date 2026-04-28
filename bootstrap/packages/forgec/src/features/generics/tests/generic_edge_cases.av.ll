; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Pair__string__int = type { ptr, i64 }

@.str = private unnamed_addr constant [8 x i8] c"value: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"first\00", align 1
@sty_name = private unnamed_addr constant [18 x i8] c"Pair__string__int\00", align 1
@src_file = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_edge_cases.av\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c" \00", align 1
@fld_name.5 = private unnamed_addr constant [7 x i8] c"second\00", align 1
@sty_name.6 = private unnamed_addr constant [18 x i8] c"Pair__string__int\00", align 1
@src_file.7 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_edge_cases.av\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c"done\00", align 1

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

define i64 @identity__(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  ret i64 %x1
}

define i64 @double_identity__int(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call i64 @identity__(i64 %x1)
  ret i64 %1
}

define i64 @inc__int(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  ret i64 %x1
}

define i64 @apply__int(i64 %0, ptr %1) {
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

define ptr @show(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x1)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast2, ptr %1, i64 %rhs_len_p1)
  ret ptr %5
}

define i64 @print_all(ptr %0) {
entry:
  %item = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %items = alloca ptr, align 8
  store ptr %0, ptr %items, align 8
  %items1 = load ptr, ptr %items, align 8
  %1 = call i64 @avra_array_len(ptr %items1)
  store i64 %1, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %2 = call i64 @avra_array_get(ptr %items1, i64 %forin_i_val)
  store i64 %2, ptr %item, align 8
  %item2 = load i64, ptr %item, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.1, i64 %item2)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen3 = sext i32 %5 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  ret i64 0
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %doubled = alloca i64, align 8
  %piped = alloca i64, align 8
  %p = alloca ptr, align 8
  %1 = call i64 @double_identity__int(i64 42)
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt.2, i64 %1)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen1 = sext i32 %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Pair__string__int, ptr %5, i32 0, i32 0
  store ptr @.str.3, ptr %fld_ptr, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Pair__string__int, ptr %5, i32 0, i32 1
  store i64 10, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %5 to i64
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %p, align 8
  %p4 = load ptr, ptr %p, align 8
  %cast5 = ptrtoint ptr %p4 to i64
  %null_chk = icmp eq i64 %cast5, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 17, i64 %null_ext, ptr @src_file, i64 142, i64 42)
  %first_ptr = getelementptr inbounds nuw %Pair__string__int, ptr %p4, i32 0, i32 0
  %first = load ptr, ptr %first_ptr, align 8
  %6 = call i64 @strlen(ptr %first)
  %7 = call i64 @strlen(ptr @.str.4)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr %first, i64 %6)
  %cast6 = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast6, %6
  %cast7 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast7, ptr @.str.4, i64 %rhs_len_p1)
  %p8 = load ptr, ptr %p, align 8
  %cast9 = ptrtoint ptr %p8 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 6, ptr @sty_name.6, i64 17, i64 %null_ext11, ptr @src_file.7, i64 142, i64 42)
  %second_ptr = getelementptr inbounds nuw %Pair__string__int, ptr %p8, i32 0, i32 1
  %second = load i64, ptr %second_ptr, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.8, i64 %second)
  %widen12 = sext i32 %12 to i64
  %13 = call i64 @strlen(ptr %8)
  %14 = call i64 @strlen(ptr %11)
  %concat_total13 = add i64 %13, %14
  %concat_size14 = add i64 %concat_total13, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %16 = call ptr @memcpy(ptr %15, ptr %8, i64 %13)
  %cast15 = ptrtoint ptr %15 to i64
  %dst2_int16 = add i64 %cast15, %13
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast17, ptr %11, i64 %rhs_len_p118)
  %18 = call i32 @puts(ptr %15)
  %widen19 = sext i32 %18 to i64
  %19 = call i64 @inc__int(i64 84)
  store i64 %19, ptr %piped, align 8
  %piped20 = load i64, ptr %piped, align 8
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.9, i64 %piped20)
  %widen21 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen22 = sext i32 %22 to i64
  %23 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %23, i64 -559038737)
  call void @avra_array_push(ptr %23, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast23 = ptrtoint ptr %23 to i64
  %cast24 = inttoptr i64 %cast23 to ptr
  %24 = call i64 @apply__int(i64 21, ptr %cast24)
  store i64 %24, ptr %doubled, align 8
  %doubled25 = load i64, ptr %doubled, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.10, i64 %doubled25)
  %widen26 = sext i32 %26 to i64
  %27 = call i32 @puts(ptr %25)
  %widen27 = sext i32 %27 to i64
  %28 = call ptr @show(i64 42)
  %29 = call i32 @puts(ptr %28)
  %widen28 = sext i32 %29 to i64
  %30 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %30, i64 1)
  call void @avra_array_push(ptr %30, i64 2)
  call void @avra_array_push(ptr %30, i64 3)
  %31 = call i64 @print_all(ptr %30)
  %32 = call i32 @puts(ptr @.str.11)
  %widen29 = sext i32 %32 to i64
  %p_cleanup = load ptr, ptr %p, align 8
  %33 = call i64 @__release_Pair__string__int(ptr %p_cleanup)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Pair__string__int(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_first_ptr = getelementptr inbounds nuw %Pair__string__int, ptr %0, i32 0, i32 0
  %rel_first = load ptr, ptr %rel_first_ptr, align 8
  %is_null_first = icmp eq ptr %rel_first, null
  br i1 %is_null_first, label %rel_first_skip, label %rel_first_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_first_skip
  ret i64 0

rel_first_skip:                                   ; preds = %rel_first_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_first_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_first)
  br label %rel_first_skip
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}
