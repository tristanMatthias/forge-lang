; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%IoError = type { ptr, ptr }
%ParseError = type { ptr, i64 }

@fld_name = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_trait.av\00", align 1
@.str = private unnamed_addr constant [3 x i8] c"io\00", align 1
@fld_name.1 = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name.2 = private unnamed_addr constant [11 x i8] c"ParseError\00", align 1
@src_file.3 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_trait.av\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"parse\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"kind: \00", align 1
@.str.7 = private unnamed_addr constant [15 x i8] c"file not found\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"/tmp/x\00", align 1
@.str.9 = private unnamed_addr constant [14 x i8] c"invalid input\00", align 1

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

define ptr @IoError__message(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 97, i64 15)
  %msg_ptr = getelementptr inbounds nuw %IoError, ptr %self1, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  ret ptr %msg
}

define ptr @IoError__kind(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str
}

define ptr @ParseError__message(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 3, ptr @sty_name.2, i64 10, i64 %null_ext, ptr @src_file.3, i64 97, i64 20)
  %msg_ptr = getelementptr inbounds nuw %ParseError, ptr %self1, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  ret ptr %msg
}

define ptr @ParseError__kind(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.4
}

define i64 @describe_error(i64 %0) {
entry:
  %e = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %1 = call i64 @avra_trait_object_value(ptr %e1)
  %2 = call ptr @avra_trait_object_vtable(ptr %e1)
  %3 = call i64 @avra_array_get(ptr %2, i64 0)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr @.str.5)
  %6 = call i64 @strlen(ptr %cast2)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.5, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr %cast2, i64 %rhs_len_p1)
  %10 = call i32 @puts(ptr %7)
  %widen = sext i32 %10 to i64
  %e5 = load ptr, ptr %e, align 8
  %11 = call i64 @avra_trait_object_value(ptr %e5)
  %12 = call ptr @avra_trait_object_vtable(ptr %e5)
  %13 = call i64 @avra_array_get(ptr %12, i64 1)
  %14 = call i64 @avra_closure_call_1(i64 %13, i64 %11)
  %cast6 = inttoptr i64 %14 to ptr
  %15 = call i64 @strlen(ptr @.str.6)
  %16 = call i64 @strlen(ptr %cast6)
  %concat_total7 = add i64 %15, %16
  %concat_size8 = add i64 %concat_total7, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size8)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.6, i64 %15)
  %cast9 = ptrtoint ptr %17 to i64
  %dst2_int10 = add i64 %cast9, %15
  %cast11 = inttoptr i64 %dst2_int10 to ptr
  %rhs_len_p112 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast11, ptr %cast6, i64 %rhs_len_p112)
  %20 = call i32 @puts(ptr %17)
  %widen13 = sext i32 %20 to i64
  ret i64 0
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %IoError, ptr %1, i32 0, i32 0
  store ptr @.str.7, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %IoError, ptr %1, i32 0, i32 1
  store ptr @.str.8, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @avra_array_new()
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 -559038737)
  call void @avra_array_push(ptr %3, i64 ptrtoint (ptr @IoError__message to i64))
  %cast2 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %2, i64 %cast2)
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 -559038737)
  call void @avra_array_push(ptr %4, i64 ptrtoint (ptr @IoError__kind to i64))
  %cast3 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %2, i64 %cast3)
  %cast4 = inttoptr i64 %cast to ptr
  %cast5 = ptrtoint ptr %2 to i64
  %5 = call i64 @avra_trait_object_new(ptr %cast4, i64 %cast5)
  %6 = call i64 @describe_error(i64 %5)
  %7 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr6 = getelementptr inbounds nuw %ParseError, ptr %7, i32 0, i32 0
  store ptr @.str.9, ptr %fld_ptr6, align 8
  %fld_ptr7 = getelementptr inbounds nuw %ParseError, ptr %7, i32 0, i32 1
  store i64 42, ptr %fld_ptr7, align 8
  %cast8 = ptrtoint ptr %7 to i64
  %8 = call ptr @avra_array_new()
  %9 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %9, i64 -559038737)
  call void @avra_array_push(ptr %9, i64 ptrtoint (ptr @ParseError__message to i64))
  %cast9 = ptrtoint ptr %9 to i64
  call void @avra_array_push(ptr %8, i64 %cast9)
  %10 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %10, i64 -559038737)
  call void @avra_array_push(ptr %10, i64 ptrtoint (ptr @ParseError__kind to i64))
  %cast10 = ptrtoint ptr %10 to i64
  call void @avra_array_push(ptr %8, i64 %cast10)
  %cast11 = inttoptr i64 %cast8 to ptr
  %cast12 = ptrtoint ptr %8 to i64
  %11 = call i64 @avra_trait_object_new(ptr %cast11, i64 %cast12)
  %12 = call i64 @describe_error(i64 %11)
  ret i64 %12
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_ParseError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_msg_ptr = getelementptr inbounds nuw %ParseError, ptr %0, i32 0, i32 0
  %rel_msg = load ptr, ptr %rel_msg_ptr, align 8
  %is_null_msg = icmp eq ptr %rel_msg, null
  br i1 %is_null_msg, label %rel_msg_skip, label %rel_msg_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_msg_skip
  ret i64 0

rel_msg_skip:                                     ; preds = %rel_msg_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_msg_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_msg)
  br label %rel_msg_skip
}

define i64 @__release_IoError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_msg_ptr = getelementptr inbounds nuw %IoError, ptr %0, i32 0, i32 0
  %rel_msg = load ptr, ptr %rel_msg_ptr, align 8
  %is_null_msg = icmp eq ptr %rel_msg, null
  br i1 %is_null_msg, label %rel_msg_skip, label %rel_msg_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_path_skip
  ret i64 0

rel_msg_skip:                                     ; preds = %rel_msg_do, %do_free
  %rel_path_ptr = getelementptr inbounds nuw %IoError, ptr %0, i32 0, i32 1
  %rel_path = load ptr, ptr %rel_path_ptr, align 8
  %is_null_path = icmp eq ptr %rel_path, null
  br i1 %is_null_path, label %rel_path_skip, label %rel_path_do

rel_msg_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_msg)
  br label %rel_msg_skip

rel_path_skip:                                    ; preds = %rel_path_do, %rel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_path_do:                                      ; preds = %rel_msg_skip
  call void @avra_rc_release(ptr %rel_path)
  br label %rel_path_skip
}
