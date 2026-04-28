; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Shape = type { i64, ptr }

@.match_fn = private unnamed_addr constant [5 x i8] c"area\00", align 1
@mu_file = private unnamed_addr constant [128 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/example.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
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

define i64 @area(ptr %0) {
entry:
  %side11 = alloca i64, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm15, %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %r3 = load i64, ptr %r2, align 8
  %r4 = load i64, ptr %r2, align 8
  %mul = mul i64 %r3, %r4
  %mul5 = mul i64 %mul, 3
  store i64 %mul5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6952775702006
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %side_slot_base = ptrtoint ptr %payload10 to i64
  %side_slot_addr = add i64 %side_slot_base, 0
  %side_slot = inttoptr i64 %side_slot_addr to ptr
  %side = load i64, ptr %side_slot, align 8
  store i64 %side, ptr %side11, align 8
  %side12 = load i64, ptr %side11, align 8
  %side13 = load i64, ptr %side11, align 8
  %mul14 = mul i64 %side12, %side13
  store i64 %mul14, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  %tag_eq17 = icmp eq i64 %tag, 229444052301365
  br i1 %tag_eq17, label %march_arm15, label %march_next16

march_arm15:                                      ; preds = %march_next7
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next16:                                     ; preds = %march_next7
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 11)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %3 = call i64 @area(ptr %cast1)
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %3)
  %widen = sext i32 %5 to i64
  %6 = call i32 @puts(ptr %4)
  %widen2 = sext i32 %6 to i64
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Shape, ptr %7, i32 0, i32 0
  store i64 6952775702006, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Shape, ptr %7, i32 0, i32 1
  %8 = call ptr @avra_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr4, align 8
  %slot_base5 = ptrtoint ptr %8 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  store i64 4, ptr %slot7, align 8
  %cast8 = ptrtoint ptr %7 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  %9 = call i64 @area(ptr %cast9)
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.1, i64 %9)
  %widen10 = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen11 = sext i32 %12 to i64
  %13 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr12 = getelementptr inbounds nuw %Shape, ptr %13, i32 0, i32 0
  store i64 229444052301365, ptr %tag_ptr12, align 8
  %pay_ptr13 = getelementptr inbounds nuw %Shape, ptr %13, i32 0, i32 1
  store ptr null, ptr %pay_ptr13, align 8
  %cast14 = ptrtoint ptr %13 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  %14 = call i64 @area(ptr %cast15)
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.2, i64 %14)
  %widen16 = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen17 = sext i32 %17 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
