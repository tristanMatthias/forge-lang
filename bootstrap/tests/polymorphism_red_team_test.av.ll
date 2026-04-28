; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%PrtDog = type { ptr }
%PrtCat = type { ptr }
%PrtPair = type { i64, ptr }

@.str = private unnamed_addr constant [5 x i8] c"woof\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"meow\00", align 1
@spec_str = private unnamed_addr constant [24 x i8] c"\22polymorphism red team\22\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"Rex\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"woof\00", align 1
@spec_str.4 = private unnamed_addr constant [16 x i8] c"\22dog says woof\22\00", align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"Whiskers\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"meow\00", align 1
@spec_str.7 = private unnamed_addr constant [16 x i8] c"\22cat says meow\22\00", align 1
@spec_str.8 = private unnamed_addr constant [18 x i8] c"\22list reduce sum\22\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"first\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"PrtPair\00", align 1
@src_file = private unnamed_addr constant [36 x i8] c"tests/polymorphism_red_team_test.fg\00", align 1
@spec_str.10 = private unnamed_addr constant [14 x i8] c"\22pair fields\22\00", align 1

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare void @forge_test_flush()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

define ptr @PrtDog__say(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str
}

define ptr @PrtCat__say(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.1
}

define i64 @main() {
entry:
  %p = alloca ptr, align 8
  %total = alloca i64, align 8
  %nums = alloca ptr, align 8
  %c = alloca ptr, align 8
  %d = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %PrtDog, ptr %1, i32 0, i32 0
  store ptr @.str.2, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @forge_array_new()
  %3 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %3, i64 -559038737)
  call void @forge_array_push(ptr %3, i64 ptrtoint (ptr @PrtDog__say to i64))
  %cast1 = ptrtoint ptr %3 to i64
  call void @forge_array_push(ptr %2, i64 %cast1)
  %cast2 = inttoptr i64 %cast to ptr
  %cast3 = ptrtoint ptr %2 to i64
  %4 = call i64 @forge_trait_object_new(ptr %cast2, i64 %cast3)
  %cast4 = inttoptr i64 %4 to ptr
  store ptr %cast4, ptr %d, align 8
  %d5 = load ptr, ptr %d, align 8
  %5 = call i64 @forge_trait_object_value(ptr %d5)
  %6 = call ptr @forge_trait_object_vtable(ptr %d5)
  %7 = call i64 @forge_array_get(ptr %6, i64 0)
  %8 = call i64 @forge_closure_call_1(i64 %7, i64 %5)
  %cast6 = inttoptr i64 %8 to ptr
  %9 = call i32 @strcmp(ptr %cast6, ptr @.str.3)
  %widen7 = sext i32 %9 to i64
  %streq_cmp = icmp eq i64 %widen7, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %10 = call i64 @forge_test_run_then(ptr @spec_str.4, i64 %streq_ext)
  %11 = call ptr @forge_rc_alloc(i64 8)
  %fld_ptr8 = getelementptr inbounds nuw %PrtCat, ptr %11, i32 0, i32 0
  store ptr @.str.5, ptr %fld_ptr8, align 8
  %cast9 = ptrtoint ptr %11 to i64
  %12 = call ptr @forge_array_new()
  %13 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %13, i64 -559038737)
  call void @forge_array_push(ptr %13, i64 ptrtoint (ptr @PrtCat__say to i64))
  %cast10 = ptrtoint ptr %13 to i64
  call void @forge_array_push(ptr %12, i64 %cast10)
  %cast11 = inttoptr i64 %cast9 to ptr
  %cast12 = ptrtoint ptr %12 to i64
  %14 = call i64 @forge_trait_object_new(ptr %cast11, i64 %cast12)
  %cast13 = inttoptr i64 %14 to ptr
  store ptr %cast13, ptr %c, align 8
  %c14 = load ptr, ptr %c, align 8
  %15 = call i64 @forge_trait_object_value(ptr %c14)
  %16 = call ptr @forge_trait_object_vtable(ptr %c14)
  %17 = call i64 @forge_array_get(ptr %16, i64 0)
  %18 = call i64 @forge_closure_call_1(i64 %17, i64 %15)
  %cast15 = inttoptr i64 %18 to ptr
  %19 = call i32 @strcmp(ptr %cast15, ptr @.str.6)
  %widen16 = sext i32 %19 to i64
  %streq_cmp17 = icmp eq i64 %widen16, 0
  %streq_ext18 = zext i1 %streq_cmp17 to i64
  %20 = call i64 @forge_test_run_then(ptr @spec_str.7, i64 %streq_ext18)
  %21 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %21, i64 1)
  call void @forge_array_push(ptr %21, i64 2)
  call void @forge_array_push(ptr %21, i64 3)
  store ptr %21, ptr %nums, align 8
  %nums19 = load ptr, ptr %nums, align 8
  %22 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %22, i64 -559038737)
  call void @forge_array_push(ptr %22, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast20 = ptrtoint ptr %22 to i64
  %23 = call i64 @forge_array_reduce(ptr %nums19, i64 0, i64 %cast20)
  store i64 %23, ptr %total, align 8
  %total21 = load i64, ptr %total, align 8
  %eq = icmp eq i64 %total21, 6
  %eq_ext = zext i1 %eq to i64
  %24 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %eq_ext)
  %25 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr22 = getelementptr inbounds nuw %PrtPair, ptr %25, i32 0, i32 0
  store i64 1, ptr %fld_ptr22, align 8
  %fld_ptr23 = getelementptr inbounds nuw %PrtPair, ptr %25, i32 0, i32 1
  store ptr @.str.9, ptr %fld_ptr23, align 8
  %cast24 = ptrtoint ptr %25 to i64
  %cast25 = inttoptr i64 %cast24 to ptr
  store ptr %cast25, ptr %p, align 8
  %p26 = load ptr, ptr %p, align 8
  %cast27 = ptrtoint ptr %p26 to i64
  %null_chk = icmp eq i64 %cast27, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 35, i64 27)
  %first_ptr = getelementptr inbounds nuw %PrtPair, ptr %p26, i32 0, i32 0
  %first = load i64, ptr %first_ptr, align 8
  %eq28 = icmp eq i64 %first, 1
  %eq_ext29 = zext i1 %eq28 to i64
  %26 = call i64 @forge_test_run_then(ptr @spec_str.10, i64 %eq_ext29)
  %27 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen30 = sext i32 %27 to i64
  %28 = call i32 @forge_test_summary()
  %widen31 = sext i32 %28 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_PrtPair(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_second_ptr = getelementptr inbounds nuw %PrtPair, ptr %0, i32 0, i32 1
  %rel_second = load ptr, ptr %rel_second_ptr, align 8
  %is_null_second = icmp eq ptr %rel_second, null
  br i1 %is_null_second, label %rel_second_skip, label %rel_second_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_second_skip
  ret i64 0

rel_second_skip:                                  ; preds = %rel_second_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_second_do:                                    ; preds = %do_free
  call void @forge_rc_release(ptr %rel_second)
  br label %rel_second_skip
}

define i64 @__release_PrtCat(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %PrtCat, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip
}

define i64 @__release_PrtDog(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %PrtDog, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip
}

define i64 @__lambda_0(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %acc1, %x2
  ret i64 %add
}
