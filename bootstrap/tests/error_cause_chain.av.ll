; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%IoError = type { ptr }
%AppError = type { ptr, ptr }

@fld_name = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_cause_chain.av\00", align 1
@.str = private unnamed_addr constant [3 x i8] c"io\00", align 1
@.str.1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.2 = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name.3 = private unnamed_addr constant [9 x i8] c"AppError\00", align 1
@src_file.4 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_cause_chain.av\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"app\00", align 1
@fld_name.6 = private unnamed_addr constant [6 x i8] c"inner\00", align 1
@sty_name.7 = private unnamed_addr constant [9 x i8] c"AppError\00", align 1
@src_file.8 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_cause_chain.av\00", align 1
@fld_name.9 = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name.10 = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file.11 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_cause_chain.av\00", align 1
@.str.12 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.13 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.14 = private unnamed_addr constant [14 x i8] c"  caused by: \00", align 1
@.str.15 = private unnamed_addr constant [19 x i8] c"connection refused\00", align 1
@.str.16 = private unnamed_addr constant [20 x i8] c"service unavailable\00", align 1

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
  call void @avra_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 103, i64 15)
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

define ptr @IoError__cause_msg(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.1
}

define ptr @AppError__message(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 3, ptr @sty_name.3, i64 8, i64 %null_ext, ptr @src_file.4, i64 103, i64 21)
  %msg_ptr = getelementptr inbounds nuw %AppError, ptr %self1, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  ret ptr %msg
}

define ptr @AppError__kind(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.5
}

define ptr @AppError__cause_msg(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.6, i64 5, ptr @sty_name.7, i64 8, i64 %null_ext, ptr @src_file.8, i64 103, i64 23)
  %inner_ptr = getelementptr inbounds nuw %AppError, ptr %self1, i32 0, i32 1
  %inner = load ptr, ptr %inner_ptr, align 8
  %cast2 = ptrtoint ptr %inner to i64
  %null_chk3 = icmp eq i64 %cast2, 0
  %null_ext4 = zext i1 %null_chk3 to i64
  call void @avra_null_deref_trap(ptr @fld_name.9, i64 3, ptr @sty_name.10, i64 7, i64 %null_ext4, ptr @src_file.11, i64 103, i64 23)
  %msg_ptr = getelementptr inbounds nuw %IoError, ptr %inner, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  ret ptr %msg
}

define i64 @show(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %c = alloca ptr, align 8
  %e = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %1 = call i64 @avra_trait_object_value(ptr %e1)
  %2 = call ptr @avra_trait_object_vtable(ptr %e1)
  %3 = call i64 @avra_array_get(ptr %2, i64 1)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr %cast2)
  %6 = call i64 @strlen(ptr @.str.12)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr %cast2, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr @.str.12, i64 %rhs_len_p1)
  %e5 = load ptr, ptr %e, align 8
  %10 = call i64 @avra_trait_object_value(ptr %e5)
  %11 = call ptr @avra_trait_object_vtable(ptr %e5)
  %12 = call i64 @avra_array_get(ptr %11, i64 0)
  %13 = call i64 @avra_closure_call_1(i64 %12, i64 %10)
  %cast6 = inttoptr i64 %13 to ptr
  %14 = call i64 @strlen(ptr %7)
  %15 = call i64 @strlen(ptr %cast6)
  %concat_total7 = add i64 %14, %15
  %concat_size8 = add i64 %concat_total7, 1
  %16 = call ptr @avra_rc_alloc(i64 %concat_size8)
  %17 = call ptr @memcpy(ptr %16, ptr %7, i64 %14)
  %cast9 = ptrtoint ptr %16 to i64
  %dst2_int10 = add i64 %cast9, %14
  %cast11 = inttoptr i64 %dst2_int10 to ptr
  %rhs_len_p112 = add i64 %15, 1
  %18 = call ptr @memcpy(ptr %cast11, ptr %cast6, i64 %rhs_len_p112)
  %19 = call i32 @puts(ptr %16)
  %widen = sext i32 %19 to i64
  %e13 = load ptr, ptr %e, align 8
  %20 = call i64 @avra_trait_object_value(ptr %e13)
  %21 = call ptr @avra_trait_object_vtable(ptr %e13)
  %22 = call i64 @avra_array_get(ptr %21, i64 2)
  %23 = call i64 @avra_closure_call_1(i64 %22, i64 %20)
  %cast14 = inttoptr i64 %23 to ptr
  store ptr %cast14, ptr %c, align 8
  %c15 = load ptr, ptr %c, align 8
  %24 = call i32 @strcmp(ptr %c15, ptr @.str.13)
  %widen16 = sext i32 %24 to i64
  %streq_cmp = icmp ne i64 %widen16, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %c17 = load ptr, ptr %c, align 8
  %25 = call i64 @strlen(ptr @.str.14)
  %26 = call i64 @strlen(ptr %c17)
  %concat_total18 = add i64 %25, %26
  %concat_size19 = add i64 %concat_total18, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size19)
  %28 = call ptr @memcpy(ptr %27, ptr @.str.14, i64 %25)
  %cast20 = ptrtoint ptr %27 to i64
  %dst2_int21 = add i64 %cast20, %25
  %cast22 = inttoptr i64 %dst2_int21 to ptr
  %rhs_len_p123 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast22, ptr %c17, i64 %rhs_len_p123)
  %30 = call i32 @puts(ptr %27)
  %widen24 = sext i32 %30 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %outer = alloca ptr, align 8
  %inner = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %IoError, ptr %1, i32 0, i32 0
  store ptr @.str.15, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %inner, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr2 = getelementptr inbounds nuw %AppError, ptr %2, i32 0, i32 0
  store ptr @.str.16, ptr %fld_ptr2, align 8
  %inner3 = load ptr, ptr %inner, align 8
  %fld_ptr4 = getelementptr inbounds nuw %AppError, ptr %2, i32 0, i32 1
  store ptr %inner3, ptr %fld_ptr4, align 8
  %cast5 = ptrtoint ptr %2 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  store ptr %cast6, ptr %outer, align 8
  %outer7 = load ptr, ptr %outer, align 8
  %3 = call ptr @avra_array_new()
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 -559038737)
  call void @avra_array_push(ptr %4, i64 ptrtoint (ptr @AppError__message to i64))
  %cast8 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %3, i64 %cast8)
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 -559038737)
  call void @avra_array_push(ptr %5, i64 ptrtoint (ptr @AppError__kind to i64))
  %cast9 = ptrtoint ptr %5 to i64
  call void @avra_array_push(ptr %3, i64 %cast9)
  %6 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %6, i64 -559038737)
  call void @avra_array_push(ptr %6, i64 ptrtoint (ptr @AppError__cause_msg to i64))
  %cast10 = ptrtoint ptr %6 to i64
  call void @avra_array_push(ptr %3, i64 %cast10)
  %cast11 = ptrtoint ptr %3 to i64
  %7 = call i64 @avra_trait_object_new(ptr %outer7, i64 %cast11)
  %8 = call i64 @show(i64 %7)
  %inner12 = load ptr, ptr %inner, align 8
  %9 = call ptr @avra_array_new()
  %10 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %10, i64 -559038737)
  call void @avra_array_push(ptr %10, i64 ptrtoint (ptr @IoError__message to i64))
  %cast13 = ptrtoint ptr %10 to i64
  call void @avra_array_push(ptr %9, i64 %cast13)
  %11 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %11, i64 -559038737)
  call void @avra_array_push(ptr %11, i64 ptrtoint (ptr @IoError__kind to i64))
  %cast14 = ptrtoint ptr %11 to i64
  call void @avra_array_push(ptr %9, i64 %cast14)
  %12 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %12, i64 -559038737)
  call void @avra_array_push(ptr %12, i64 ptrtoint (ptr @IoError__cause_msg to i64))
  %cast15 = ptrtoint ptr %12 to i64
  call void @avra_array_push(ptr %9, i64 %cast15)
  %cast16 = ptrtoint ptr %9 to i64
  %13 = call i64 @avra_trait_object_new(ptr %inner12, i64 %cast16)
  %14 = call i64 @show(i64 %13)
  ret i64 %14
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_AppError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_msg_ptr = getelementptr inbounds nuw %AppError, ptr %0, i32 0, i32 0
  %rel_msg = load ptr, ptr %rel_msg_ptr, align 8
  %is_null_msg = icmp eq ptr %rel_msg, null
  br i1 %is_null_msg, label %rel_msg_skip, label %rel_msg_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_inner_skip
  ret i64 0

rel_msg_skip:                                     ; preds = %rel_msg_do, %do_free
  %rel_inner_ptr = getelementptr inbounds nuw %AppError, ptr %0, i32 0, i32 1
  %rel_inner = load ptr, ptr %rel_inner_ptr, align 8
  %is_null_inner = icmp eq ptr %rel_inner, null
  br i1 %is_null_inner, label %rel_inner_skip, label %rel_inner_do

rel_msg_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_msg)
  br label %rel_msg_skip

rel_inner_skip:                                   ; preds = %rel_inner_do, %rel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_inner_do:                                     ; preds = %rel_msg_skip
  %2 = call i64 @__release_IoError(ptr %rel_inner)
  br label %rel_inner_skip
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

done:                                             ; preds = %alive, %rel_msg_skip
  ret i64 0

rel_msg_skip:                                     ; preds = %rel_msg_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_msg_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_msg)
  br label %rel_msg_skip
}
