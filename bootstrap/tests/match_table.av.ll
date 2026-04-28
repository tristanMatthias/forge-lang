; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Status = type { i64, ptr }

@.str = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"active\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"pending\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"P\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"complete\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/match_table.av\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.15 = private unnamed_addr constant [7 x i8] c"active\00", align 1
@.str.16 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.17 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.19 = private unnamed_addr constant [8 x i8] c"pending\00", align 1
@.str.20 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"P\00", align 1
@.str.22 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.23 = private unnamed_addr constant [9 x i8] c"complete\00", align 1
@.str.24 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.25 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@.match_fn.26 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.27 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/match_table.av\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.29 = private unnamed_addr constant [5 x i8] c"code\00", align 1

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
  %0 = call i64 @__bs_top_level()
  %r2 = alloca ptr, align 8
  %match_result27 = alloca i64, align 8
  %s222 = alloca ptr, align 8
  %r = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Status, ptr %1, i32 0, i32 0
  store i64 6952054634945, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Status, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %s, align 8
  %s2 = load ptr, ptr %s, align 8
  %tag_ptr3 = getelementptr inbounds nuw %Status, ptr %s2, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr3, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952054634945
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm9, %march_arm5, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast13 = inttoptr i64 %match_val to ptr
  store ptr %cast13, ptr %r, align 8
  %r14 = load ptr, ptr %r, align 8
  %2 = call i64 @avra_map_get_cstr(ptr %r14, ptr @.str.12)
  %cast15 = inttoptr i64 %2 to ptr
  %3 = call i32 @puts(ptr %cast15)
  %widen = sext i32 %3 to i64
  %r16 = load ptr, ptr %r, align 8
  %4 = call i64 @avra_map_get_cstr(ptr %r16, ptr @.str.13)
  %cast17 = inttoptr i64 %4 to ptr
  %5 = call i32 @puts(ptr %cast17)
  %widen18 = sext i32 %5 to i64
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr19 = getelementptr inbounds nuw %Status, ptr %6, i32 0, i32 0
  store i64 6384009227, ptr %tag_ptr19, align 8
  %pay_ptr20 = getelementptr inbounds nuw %Status, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr20, align 8
  %cast21 = ptrtoint ptr %6 to i64
  %cast23 = inttoptr i64 %cast21 to ptr
  store ptr %cast23, ptr %s222, align 8
  %s224 = load ptr, ptr %s222, align 8
  %tag_ptr25 = getelementptr inbounds nuw %Status, ptr %s224, i32 0, i32 0
  %tag26 = load i64, ptr %tag_ptr25, align 8
  store i64 0, ptr %match_result27, align 8
  %tag_eq31 = icmp eq i64 %tag26, 6952054634945
  br i1 %tag_eq31, label %march_arm29, label %march_next30

march_arm:                                        ; preds = %entry
  %7 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %7, ptr @.str, i64 ptrtoint (ptr @.str.1 to i64))
  call void @avra_map_set_cstr(ptr %7, ptr @.str.2, i64 ptrtoint (ptr @.str.3 to i64))
  %cast4 = ptrtoint ptr %7 to i64
  store i64 %cast4, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq7 = icmp eq i64 %tag, 229437245934538
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next
  %8 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %8, ptr @.str.4, i64 ptrtoint (ptr @.str.5 to i64))
  call void @avra_map_set_cstr(ptr %8, ptr @.str.6, i64 ptrtoint (ptr @.str.7 to i64))
  %cast8 = ptrtoint ptr %8 to i64
  store i64 %cast8, ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next
  %tag_eq11 = icmp eq i64 %tag, 6384009227
  br i1 %tag_eq11, label %march_arm9, label %march_next10

march_arm9:                                       ; preds = %march_next6
  %9 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %9, ptr @.str.8, i64 ptrtoint (ptr @.str.9 to i64))
  call void @avra_map_set_cstr(ptr %9, ptr @.str.10, i64 ptrtoint (ptr @.str.11 to i64))
  %cast12 = ptrtoint ptr %9 to i64
  store i64 %cast12, ptr %match_result, align 8
  br label %match_end

march_next10:                                     ; preds = %march_next6
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable

match_end28:                                      ; preds = %march_arm37, %march_arm33, %march_arm29
  %match_val41 = load i64, ptr %match_result27, align 8
  %cast42 = inttoptr i64 %match_val41 to ptr
  store ptr %cast42, ptr %r2, align 8
  %r243 = load ptr, ptr %r2, align 8
  %10 = call i64 @avra_map_get_cstr(ptr %r243, ptr @.str.28)
  %cast44 = inttoptr i64 %10 to ptr
  %11 = call i32 @puts(ptr %cast44)
  %widen45 = sext i32 %11 to i64
  %r246 = load ptr, ptr %r2, align 8
  %12 = call i64 @avra_map_get_cstr(ptr %r246, ptr @.str.29)
  %cast47 = inttoptr i64 %12 to ptr
  %13 = call i32 @puts(ptr %cast47)
  %widen48 = sext i32 %13 to i64
  ret i64 0

march_arm29:                                      ; preds = %match_end
  %14 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %14, ptr @.str.14, i64 ptrtoint (ptr @.str.15 to i64))
  call void @avra_map_set_cstr(ptr %14, ptr @.str.16, i64 ptrtoint (ptr @.str.17 to i64))
  %cast32 = ptrtoint ptr %14 to i64
  store i64 %cast32, ptr %match_result27, align 8
  br label %match_end28

march_next30:                                     ; preds = %match_end
  %tag_eq35 = icmp eq i64 %tag26, 229437245934538
  br i1 %tag_eq35, label %march_arm33, label %march_next34

march_arm33:                                      ; preds = %march_next30
  %15 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %15, ptr @.str.18, i64 ptrtoint (ptr @.str.19 to i64))
  call void @avra_map_set_cstr(ptr %15, ptr @.str.20, i64 ptrtoint (ptr @.str.21 to i64))
  %cast36 = ptrtoint ptr %15 to i64
  store i64 %cast36, ptr %match_result27, align 8
  br label %match_end28

march_next34:                                     ; preds = %march_next30
  %tag_eq39 = icmp eq i64 %tag26, 6384009227
  br i1 %tag_eq39, label %march_arm37, label %march_next38

march_arm37:                                      ; preds = %march_next34
  %16 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %16, ptr @.str.22, i64 ptrtoint (ptr @.str.23 to i64))
  call void @avra_map_set_cstr(ptr %16, ptr @.str.24, i64 ptrtoint (ptr @.str.25 to i64))
  %cast40 = ptrtoint ptr %16 to i64
  store i64 %cast40, ptr %match_result27, align 8
  br label %match_end28

march_next38:                                     ; preds = %march_next34
  call void @avra_match_unreachable(ptr @.match_fn.26, i64 %tag26, ptr @mu_file.27, i64 18)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
