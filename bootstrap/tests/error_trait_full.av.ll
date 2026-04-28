; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Severity = type { i64, ptr }
%IoError = type { ptr, ptr, ptr }

@.str = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"info\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"warning\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"fatal\00", align 1
@.match_fn = private unnamed_addr constant [13 x i8] c"severity_str\00", align 1
@mu_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_trait_full.av\00", align 1
@fld_name = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_trait_full.av\00", align 1
@.str.5 = private unnamed_addr constant [13 x i8] c"io.not_found\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.str.7 = private unnamed_addr constant [11 x i8] c"severity: \00", align 1
@.str.8 = private unnamed_addr constant [16 x i8] c"transient: true\00", align 1
@.str.9 = private unnamed_addr constant [17 x i8] c"transient: false\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"file not found\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c"/tmp/x\00", align 1
@.str.12 = private unnamed_addr constant [13 x i8] c"disk failure\00", align 1
@.str.13 = private unnamed_addr constant [8 x i8] c"cause: \00", align 1
@fld_name.14 = private unnamed_addr constant [10 x i8] c"cause_msg\00", align 1
@sty_name.15 = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file.16 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_trait_full.av\00", align 1

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

define ptr @severity_str(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Severity, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210671932684
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm11, %march_arm8, %march_arm5, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384187569
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq7 = icmp eq i64 %tag, 229446134771803
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next3
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next3
  %tag_eq10 = icmp eq i64 %tag, 210673603023
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_arm8:                                       ; preds = %march_next6
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result, align 8
  br label %match_end

march_next9:                                      ; preds = %march_next6
  %tag_eq13 = icmp eq i64 %tag, 210674179725
  br i1 %tag_eq13, label %march_arm11, label %march_next12

march_arm11:                                      ; preds = %march_next9
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %match_result, align 8
  br label %match_end

march_next12:                                     ; preds = %march_next9
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define ptr @IoError__message(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 102, i64 28)
  %msg_ptr = getelementptr inbounds nuw %IoError, ptr %self1, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  ret ptr %msg
}

define ptr @IoError__kind(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.5
}

define ptr @IoError__severity(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Severity, ptr %1, i32 0, i32 0
  store i64 210673603023, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Severity, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  ret ptr %cast1
}

define i1 @IoError__is_transient(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret i1 false
}

define i64 @describe(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
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
  %6 = call i64 @strlen(ptr @.str.6)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr %cast2, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr @.str.6, i64 %rhs_len_p1)
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
  %24 = call ptr @severity_str(ptr %cast14)
  %25 = call i64 @strlen(ptr @.str.7)
  %26 = call i64 @strlen(ptr %24)
  %concat_total15 = add i64 %25, %26
  %concat_size16 = add i64 %concat_total15, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size16)
  %28 = call ptr @memcpy(ptr %27, ptr @.str.7, i64 %25)
  %cast17 = ptrtoint ptr %27 to i64
  %dst2_int18 = add i64 %cast17, %25
  %cast19 = inttoptr i64 %dst2_int18 to ptr
  %rhs_len_p120 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast19, ptr %24, i64 %rhs_len_p120)
  %30 = call i32 @puts(ptr %27)
  %widen21 = sext i32 %30 to i64
  %e22 = load ptr, ptr %e, align 8
  %31 = call i64 @avra_trait_object_value(ptr %e22)
  %32 = call ptr @avra_trait_object_vtable(ptr %e22)
  %33 = call i64 @avra_array_get(ptr %32, i64 3)
  %34 = call i64 @avra_closure_call_1(i64 %33, i64 %31)
  %cast23 = trunc i64 %34 to i1
  store i64 0, ptr %sif_result, align 8
  br i1 %cast23, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %35 = call i32 @puts(ptr @.str.8)
  %widen24 = sext i32 %35 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %36 = call i32 @puts(ptr @.str.9)
  %widen25 = sext i32 %36 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %err = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr = getelementptr inbounds nuw %IoError, ptr %1, i32 0, i32 0
  store ptr @.str.10, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %IoError, ptr %1, i32 0, i32 1
  store ptr @.str.11, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %IoError, ptr %1, i32 0, i32 2
  store ptr @.str.12, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %err, align 8
  %err4 = load ptr, ptr %err, align 8
  %2 = call ptr @avra_array_new()
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 -559038737)
  call void @avra_array_push(ptr %3, i64 ptrtoint (ptr @IoError__message to i64))
  %cast5 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %2, i64 %cast5)
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 -559038737)
  call void @avra_array_push(ptr %4, i64 ptrtoint (ptr @IoError__kind to i64))
  %cast6 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %2, i64 %cast6)
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 -559038737)
  call void @avra_array_push(ptr %5, i64 ptrtoint (ptr @IoError__severity to i64))
  %cast7 = ptrtoint ptr %5 to i64
  call void @avra_array_push(ptr %2, i64 %cast7)
  %6 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %6, i64 -559038737)
  call void @avra_array_push(ptr %6, i64 ptrtoint (ptr @IoError__is_transient to i64))
  %cast8 = ptrtoint ptr %6 to i64
  call void @avra_array_push(ptr %2, i64 %cast8)
  %cast9 = ptrtoint ptr %2 to i64
  %7 = call i64 @avra_trait_object_new(ptr %err4, i64 %cast9)
  %8 = call i64 @describe(i64 %7)
  %err10 = load ptr, ptr %err, align 8
  %cast11 = ptrtoint ptr %err10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.14, i64 9, ptr @sty_name.15, i64 7, i64 %null_ext, ptr @src_file.16, i64 102, i64 43)
  %cause_msg_ptr = getelementptr inbounds nuw %IoError, ptr %err10, i32 0, i32 2
  %cause_msg = load ptr, ptr %cause_msg_ptr, align 8
  %9 = call i64 @strlen(ptr @.str.13)
  %10 = call i64 @strlen(ptr %cause_msg)
  %concat_total = add i64 %9, %10
  %concat_size = add i64 %concat_total, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size)
  %12 = call ptr @memcpy(ptr %11, ptr @.str.13, i64 %9)
  %cast12 = ptrtoint ptr %11 to i64
  %dst2_int = add i64 %cast12, %9
  %cast13 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast13, ptr %cause_msg, i64 %rhs_len_p1)
  %14 = call i32 @puts(ptr %11)
  %widen = sext i32 %14 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
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

done:                                             ; preds = %alive, %rel_cause_msg_skip
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
  %rel_cause_msg_ptr = getelementptr inbounds nuw %IoError, ptr %0, i32 0, i32 2
  %rel_cause_msg = load ptr, ptr %rel_cause_msg_ptr, align 8
  %is_null_cause_msg = icmp eq ptr %rel_cause_msg, null
  br i1 %is_null_cause_msg, label %rel_cause_msg_skip, label %rel_cause_msg_do

rel_path_do:                                      ; preds = %rel_msg_skip
  call void @avra_rc_release(ptr %rel_path)
  br label %rel_path_skip

rel_cause_msg_skip:                               ; preds = %rel_cause_msg_do, %rel_path_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_cause_msg_do:                                 ; preds = %rel_path_skip
  call void @avra_rc_release(ptr %rel_cause_msg)
  br label %rel_cause_msg_skip
}
