; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Student = type { ptr, ptr }

@students = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@fld_name = private unnamed_addr constant [7 x i8] c"scores\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"Student\00", align 1
@src_file = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_nested_for_in.av\00", align 1
@fld_name.2 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.3 = private unnamed_addr constant [8 x i8] c"Student\00", align 1
@src_file.4 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_nested_for_in.av\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c": avg \00", align 1
@dz_file = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_nested_for_in.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %score = alloca i64, align 8
  %forin_i8 = alloca i64, align 8
  %forin_len7 = alloca i64, align 8
  %sum = alloca i64, align 8
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Student, ptr %1, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 90)
  call void @avra_array_push(ptr %2, i64 85)
  call void @avra_array_push(ptr %2, i64 92)
  %fld_ptr1 = getelementptr inbounds nuw %Student, ptr %1, i32 0, i32 1
  store ptr %2, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %3 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr2 = getelementptr inbounds nuw %Student, ptr %3, i32 0, i32 0
  store ptr @.str.1, ptr %fld_ptr2, align 8
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 78)
  call void @avra_array_push(ptr %4, i64 88)
  call void @avra_array_push(ptr %4, i64 95)
  %fld_ptr3 = getelementptr inbounds nuw %Student, ptr %3, i32 0, i32 1
  store ptr %4, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %0, i64 %cast4)
  store ptr %0, ptr @students, align 8
  %students = load ptr, ptr @students, align 8
  %5 = call i64 @avra_array_len(ptr %students)
  store i64 %5, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %6 = call i64 @avra_array_get(ptr %students, i64 %forin_i_val)
  store i64 %6, ptr %s, align 8
  store i64 0, ptr %sum, align 8
  %s5 = load ptr, ptr %s, align 8
  %cast6 = ptrtoint ptr %s5 to i64
  %null_chk = icmp eq i64 %cast6, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 6, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 104, i64 9)
  %scores_ptr = getelementptr inbounds nuw %Student, ptr %s5, i32 0, i32 1
  %scores = load ptr, ptr %scores_ptr, align 8
  %7 = call i64 @avra_array_len(ptr %scores)
  store i64 %7, ptr %forin_len7, align 8
  store i64 0, ptr %forin_i8, align 8
  br label %forin.cond9

forin.incr:                                       ; preds = %forin.exit12
  %forin_i_old32 = load i64, ptr %forin_i, align 8
  %forin_next33 = add i64 %forin_i_old32, 1
  store i64 %forin_next33, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %8 = call i32 @avra_test_summary()
  %widen34 = sext i32 %8 to i64
  call void @avra_rc_collect()
  ret i64 0

forin.cond9:                                      ; preds = %forin.incr11, %forin.body
  %forin_i_val13 = load i64, ptr %forin_i8, align 8
  %forin_len_val14 = load i64, ptr %forin_len7, align 8
  %forin_cmp15 = icmp slt i64 %forin_i_val13, %forin_len_val14
  br i1 %forin_cmp15, label %forin.body10, label %forin.exit12

forin.body10:                                     ; preds = %forin.cond9
  %9 = call i64 @avra_array_get(ptr %scores, i64 %forin_i_val13)
  store i64 %9, ptr %score, align 8
  %sum16 = load i64, ptr %sum, align 8
  %score17 = load i64, ptr %score, align 8
  %add = add i64 %sum16, %score17
  store i64 %add, ptr %sum, align 8
  br label %forin.incr11

forin.incr11:                                     ; preds = %forin.body10
  %forin_i_old = load i64, ptr %forin_i8, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i8, align 8
  br label %forin.cond9

forin.exit12:                                     ; preds = %forin.cond9
  %s18 = load ptr, ptr %s, align 8
  %cast19 = ptrtoint ptr %s18 to i64
  %null_chk20 = icmp eq i64 %cast19, 0
  %null_ext21 = zext i1 %null_chk20 to i64
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 4, ptr @sty_name.3, i64 7, i64 %null_ext21, ptr @src_file.4, i64 104, i64 12)
  %name_ptr = getelementptr inbounds nuw %Student, ptr %s18, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %10 = call i64 @strlen(ptr %name)
  %11 = call i64 @strlen(ptr @.str.5)
  %concat_total = add i64 %10, %11
  %concat_size = add i64 %concat_total, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size)
  %13 = call ptr @memcpy(ptr %12, ptr %name, i64 %10)
  %cast22 = ptrtoint ptr %12 to i64
  %dst2_int = add i64 %cast22, %10
  %cast23 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast23, ptr @.str.5, i64 %rhs_len_p1)
  %sum24 = load i64, ptr %sum, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 104, i64 12)
  %div = sdiv i64 %sum24, 3
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt, i64 %div)
  %widen = sext i32 %16 to i64
  %17 = call i64 @strlen(ptr %12)
  %18 = call i64 @strlen(ptr %15)
  %concat_total25 = add i64 %17, %18
  %concat_size26 = add i64 %concat_total25, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %20 = call ptr @memcpy(ptr %19, ptr %12, i64 %17)
  %cast27 = ptrtoint ptr %19 to i64
  %dst2_int28 = add i64 %cast27, %17
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast29, ptr %15, i64 %rhs_len_p130)
  %22 = call i32 @puts(ptr %19)
  %widen31 = sext i32 %22 to i64
  br label %forin.incr
}

define i64 @__release_Student(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Student, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_scores_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_scores_ptr = getelementptr inbounds nuw %Student, ptr %0, i32 0, i32 1
  %rel_scores = load ptr, ptr %rel_scores_ptr, align 8
  %is_null_scores = icmp eq ptr %rel_scores, null
  br i1 %is_null_scores, label %rel_scores_skip, label %rel_scores_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_scores_skip:                                  ; preds = %rel_scores_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_scores_do:                                    ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_scores)
  br label %rel_scores_skip
}
