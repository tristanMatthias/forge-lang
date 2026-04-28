; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Box = type { i64, ptr }

@.match_fn = private unnamed_addr constant [11 x i8] c"__lambda_0\00", align 1
@mu_file = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/capture_in_match.av\00", align 1
@.str = private unnamed_addr constant [7 x i8] c" world\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @test_match_capture() {
entry:
  %f = alloca ptr, align 8
  %factor = alloca i64, align 8
  store i64 3, ptr %factor, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 -559038737)
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %factor, align 8
  call void @avra_array_push(ptr %0, i64 %cap_val)
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %f, align 8
  %f2 = load i64, ptr %f, align 8
  %cast3 = inttoptr i64 %f2 to ptr
  %1 = call i64 @avra_array_get(ptr %cast3, i64 1)
  %fn_ptr = inttoptr i64 %1 to ptr
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Box, ptr %2, i32 0, i32 0
  store i64 193473960, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Box, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 10, ptr %slot, align 8
  %cast4 = ptrtoint ptr %2 to i64
  %4 = call i64 @avra_array_get(ptr %cast3, i64 2)
  %closure_call = call i64 %fn_ptr(i64 %cast4, i64 %4)
  ret i64 %closure_call
}

define i64 @test_if_else_capture() {
entry:
  %f = alloca ptr, align 8
  %default_val = alloca i64, align 8
  store i64 99, ptr %default_val, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 -559038737)
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %default_val, align 8
  call void @avra_array_push(ptr %0, i64 %cap_val)
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %f, align 8
  %f2 = load i64, ptr %f, align 8
  %cast3 = inttoptr i64 %f2 to ptr
  %1 = call i64 @avra_array_get(ptr %cast3, i64 1)
  %fn_ptr = inttoptr i64 %1 to ptr
  %2 = call i64 @avra_array_get(ptr %cast3, i64 2)
  %closure_call = call i64 %fn_ptr(i64 -1, i64 %2)
  ret i64 %closure_call
}

define ptr @test_enum_ctor_capture() {
entry:
  %f = alloca ptr, align 8
  %suffix = alloca ptr, align 8
  store ptr @.str, ptr %suffix, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 -559038737)
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cap_val = load i64, ptr %suffix, align 8
  call void @avra_array_push(ptr %0, i64 %cap_val)
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %f, align 8
  %f2 = load i64, ptr %f, align 8
  %cast3 = inttoptr i64 %f2 to ptr
  %1 = call i64 @avra_array_get(ptr %cast3, i64 1)
  %fn_ptr = inttoptr i64 %1 to ptr
  %2 = call i64 @avra_array_get(ptr %cast3, i64 2)
  %closure_call = call i64 %fn_ptr(ptr @.str.1, i64 %2)
  %cast4 = inttoptr i64 %closure_call to ptr
  ret ptr %cast4
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call i64 @test_match_capture()
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %1)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen1 = sext i32 %4 to i64
  %5 = call i64 @test_if_else_capture()
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.2, i64 %5)
  %widen2 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen3 = sext i32 %8 to i64
  %9 = call ptr @test_enum_ctor_capture()
  %10 = call i32 @puts(ptr %9)
  %widen4 = sext i32 %10 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(ptr %0, i64 %1) {
entry:
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %factor = alloca i64, align 8
  %b = alloca ptr, align 8
  store ptr %0, ptr %b, align 8
  store i64 %1, ptr %factor, align 8
  %b1 = load ptr, ptr %b, align 8
  %tag_ptr = getelementptr inbounds nuw %Box, ptr %b1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193473960
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm5, %march_arm
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
  %factor4 = load i64, ptr %factor, align 8
  %mul = mul i64 %n3, %factor4
  store i64 %mul, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq7 = icmp eq i64 %tag, 210673421332
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 12)
  unreachable
}

define i64 @__lambda_1(i64 %0, i64 %1) {
entry:
  %sif_result = alloca i64, align 8
  %default_val = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %default_val, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %sif_cond = icmp ne i64 %sgt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %x2 = load i64, ptr %x, align 8
  store i64 %x2, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %default_val3 = load i64, ptr %default_val, align 8
  store i64 %default_val3, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @__lambda_2(ptr %0, i64 %1) {
entry:
  %suffix = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %cast = inttoptr i64 %1 to ptr
  store ptr %cast, ptr %suffix, align 8
  %s1 = load ptr, ptr %s, align 8
  %suffix2 = load ptr, ptr %suffix, align 8
  %2 = call i64 @strlen(ptr %s1)
  %3 = call i64 @strlen(ptr %suffix2)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr %s1, i64 %2)
  %cast3 = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast3, %2
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast4, ptr %suffix2, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %4 to i64
  ret i64 %cast5
}
