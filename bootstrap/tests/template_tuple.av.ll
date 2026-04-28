; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@pair = global i64 0
@.str = private unnamed_addr constant [8 x i8] c"first: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c", second: \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c" + \00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c" = \00", align 1
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

define i64 @main() {
entry:
  %b34 = alloca i64, align 8
  %a33 = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %slot_base = ptrtoint ptr %0 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 10, ptr %slot, align 8
  %slot_base1 = ptrtoint ptr %0 to i64
  %slot_addr2 = add i64 %slot_base1, 8
  %slot3 = inttoptr i64 %slot_addr2 to ptr
  store i64 20, ptr %slot3, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @pair, align 8
  %pair = load ptr, ptr @pair, align 8
  %tup_val_slot_base = ptrtoint ptr %pair to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %tup_val)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast4 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast4, %3
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast5, ptr %1, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.1)
  %concat_total6 = add i64 %8, %9
  %concat_size7 = add i64 %concat_total6, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size7)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast8 = ptrtoint ptr %10 to i64
  %dst2_int9 = add i64 %cast8, %8
  %cast10 = inttoptr i64 %dst2_int9 to ptr
  %rhs_len_p111 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast10, ptr @.str.1, i64 %rhs_len_p111)
  %pair12 = load ptr, ptr @pair, align 8
  %tup_val_slot_base13 = ptrtoint ptr %pair12 to i64
  %tup_val_slot_addr14 = add i64 %tup_val_slot_base13, 8
  %tup_val_slot15 = inttoptr i64 %tup_val_slot_addr14 to ptr
  %tup_val16 = load i64, ptr %tup_val_slot15, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.2, i64 %tup_val16)
  %widen17 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr %10)
  %16 = call i64 @strlen(ptr %13)
  %concat_total18 = add i64 %15, %16
  %concat_size19 = add i64 %concat_total18, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size19)
  %18 = call ptr @memcpy(ptr %17, ptr %10, i64 %15)
  %cast20 = ptrtoint ptr %17 to i64
  %dst2_int21 = add i64 %cast20, %15
  %cast22 = inttoptr i64 %dst2_int21 to ptr
  %rhs_len_p123 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast22, ptr %13, i64 %rhs_len_p123)
  %20 = call i32 @puts(ptr %17)
  %widen24 = sext i32 %20 to i64
  %21 = call ptr @avra_rc_alloc(i64 16)
  %slot_base25 = ptrtoint ptr %21 to i64
  %slot_addr26 = add i64 %slot_base25, 0
  %slot27 = inttoptr i64 %slot_addr26 to ptr
  store i64 3, ptr %slot27, align 8
  %slot_base28 = ptrtoint ptr %21 to i64
  %slot_addr29 = add i64 %slot_base28, 8
  %slot30 = inttoptr i64 %slot_addr29 to ptr
  store i64 7, ptr %slot30, align 8
  %cast31 = ptrtoint ptr %21 to i64
  %cast32 = inttoptr i64 %cast31 to ptr
  %a_slot_base = ptrtoint ptr %cast32 to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load i64, ptr %a_slot, align 8
  store i64 %a, ptr %a33, align 8
  %b_slot_base = ptrtoint ptr %cast32 to i64
  %b_slot_addr = add i64 %b_slot_base, 8
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load i64, ptr %b_slot, align 8
  store i64 %b, ptr %b34, align 8
  %a35 = load i64, ptr %a33, align 8
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.3, i64 %a35)
  %widen36 = sext i32 %23 to i64
  %24 = call i64 @strlen(ptr %22)
  %25 = call i64 @strlen(ptr @.str.4)
  %concat_total37 = add i64 %24, %25
  %concat_size38 = add i64 %concat_total37, 1
  %26 = call ptr @avra_rc_alloc(i64 %concat_size38)
  %27 = call ptr @memcpy(ptr %26, ptr %22, i64 %24)
  %cast39 = ptrtoint ptr %26 to i64
  %dst2_int40 = add i64 %cast39, %24
  %cast41 = inttoptr i64 %dst2_int40 to ptr
  %rhs_len_p142 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast41, ptr @.str.4, i64 %rhs_len_p142)
  %b43 = load i64, ptr %b34, align 8
  %29 = call ptr @avra_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.5, i64 %b43)
  %widen44 = sext i32 %30 to i64
  %31 = call i64 @strlen(ptr %26)
  %32 = call i64 @strlen(ptr %29)
  %concat_total45 = add i64 %31, %32
  %concat_size46 = add i64 %concat_total45, 1
  %33 = call ptr @avra_rc_alloc(i64 %concat_size46)
  %34 = call ptr @memcpy(ptr %33, ptr %26, i64 %31)
  %cast47 = ptrtoint ptr %33 to i64
  %dst2_int48 = add i64 %cast47, %31
  %cast49 = inttoptr i64 %dst2_int48 to ptr
  %rhs_len_p150 = add i64 %32, 1
  %35 = call ptr @memcpy(ptr %cast49, ptr %29, i64 %rhs_len_p150)
  %36 = call i64 @strlen(ptr %33)
  %37 = call i64 @strlen(ptr @.str.6)
  %concat_total51 = add i64 %36, %37
  %concat_size52 = add i64 %concat_total51, 1
  %38 = call ptr @avra_rc_alloc(i64 %concat_size52)
  %39 = call ptr @memcpy(ptr %38, ptr %33, i64 %36)
  %cast53 = ptrtoint ptr %38 to i64
  %dst2_int54 = add i64 %cast53, %36
  %cast55 = inttoptr i64 %dst2_int54 to ptr
  %rhs_len_p156 = add i64 %37, 1
  %40 = call ptr @memcpy(ptr %cast55, ptr @.str.6, i64 %rhs_len_p156)
  %a57 = load i64, ptr %a33, align 8
  %b58 = load i64, ptr %b34, align 8
  %add = add i64 %a57, %b58
  %41 = call ptr @avra_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt.7, i64 %add)
  %widen59 = sext i32 %42 to i64
  %43 = call i64 @strlen(ptr %38)
  %44 = call i64 @strlen(ptr %41)
  %concat_total60 = add i64 %43, %44
  %concat_size61 = add i64 %concat_total60, 1
  %45 = call ptr @avra_rc_alloc(i64 %concat_size61)
  %46 = call ptr @memcpy(ptr %45, ptr %38, i64 %43)
  %cast62 = ptrtoint ptr %45 to i64
  %dst2_int63 = add i64 %cast62, %43
  %cast64 = inttoptr i64 %dst2_int63 to ptr
  %rhs_len_p165 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast64, ptr %41, i64 %rhs_len_p165)
  %48 = call i32 @puts(ptr %45)
  %widen66 = sext i32 %48 to i64
  %49 = call i32 @avra_test_summary()
  %widen67 = sext i32 %49 to i64
  call void @avra_rc_collect()
  ret i64 0
}
