; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Color = type { i64, ptr }

@colors = global i64 0
@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"blue(\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_enum_in_list.av\00", align 1

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
  %s16 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %c = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Color, ptr %2, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Color, ptr %2, i32 0, i32 1
  store ptr null, ptr %pay_ptr2, align 8
  %cast3 = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %0, i64 %cast3)
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %Color, ptr %3, i32 0, i32 0
  store i64 6383934317, ptr %tag_ptr4, align 8
  %pay_ptr5 = getelementptr inbounds nuw %Color, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr5, align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast6 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %0, i64 %cast6)
  store ptr %0, ptr @colors, align 8
  %colors = load ptr, ptr @colors, align 8
  %5 = call i64 @avra_array_len(ptr %colors)
  store i64 %5, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %6 = call i64 @avra_array_get(ptr %colors, i64 %forin_i_val)
  store i64 %6, ptr %c, align 8
  %c7 = load ptr, ptr %c, align 8
  %tag_ptr8 = getelementptr inbounds nuw %Color, ptr %c7, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr8, align 8
  %tag_eq = icmp eq i64 %tag, 193469728
  br i1 %tag_eq, label %march_arm, label %march_next

forin.incr:                                       ; preds = %match_end
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %7 = call i32 @avra_test_summary()
  %widen28 = sext i32 %7 to i64
  call void @avra_rc_collect()
  ret i64 0

match_end:                                        ; preds = %march_arm13, %march_arm9, %march_arm
  br label %forin.incr

march_arm:                                        ; preds = %forin.body
  %8 = call i32 @puts(ptr @.str)
  %widen = sext i32 %8 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %forin.body
  %tag_eq11 = icmp eq i64 %tag, 210675960374
  br i1 %tag_eq11, label %march_arm9, label %march_next10

march_arm9:                                       ; preds = %march_next
  %9 = call i32 @puts(ptr @.str.1)
  %widen12 = sext i32 %9 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next10:                                     ; preds = %march_next
  %tag_eq15 = icmp eq i64 %tag, 6383934317
  br i1 %tag_eq15, label %march_arm13, label %march_next14

march_arm13:                                      ; preds = %march_next10
  %pay_slot = getelementptr inbounds nuw %Color, ptr %c7, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %s_slot_base = ptrtoint ptr %payload to i64
  %s_slot_addr = add i64 %s_slot_base, 0
  %s_slot = inttoptr i64 %s_slot_addr to ptr
  %s = load i64, ptr %s_slot, align 8
  store i64 %s, ptr %s16, align 8
  %s17 = load i64, ptr %s16, align 8
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt, i64 %s17)
  %widen18 = sext i32 %11 to i64
  %12 = call i64 @strlen(ptr @.str.2)
  %13 = call i64 @strlen(ptr %10)
  %concat_total = add i64 %12, %13
  %concat_size = add i64 %concat_total, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size)
  %15 = call ptr @memcpy(ptr %14, ptr @.str.2, i64 %12)
  %cast19 = ptrtoint ptr %14 to i64
  %dst2_int = add i64 %cast19, %12
  %cast20 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast20, ptr %10, i64 %rhs_len_p1)
  %17 = call i64 @strlen(ptr %14)
  %18 = call i64 @strlen(ptr @.str.3)
  %concat_total21 = add i64 %17, %18
  %concat_size22 = add i64 %concat_total21, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size22)
  %20 = call ptr @memcpy(ptr %19, ptr %14, i64 %17)
  %cast23 = ptrtoint ptr %19 to i64
  %dst2_int24 = add i64 %cast23, %17
  %cast25 = inttoptr i64 %dst2_int24 to ptr
  %rhs_len_p126 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast25, ptr @.str.3, i64 %rhs_len_p126)
  %22 = call i32 @puts(ptr %19)
  %widen27 = sext i32 %22 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next14:                                     ; preds = %march_next10
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 5)
  unreachable
}
