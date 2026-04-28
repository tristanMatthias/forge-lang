; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.lit_str = private unnamed_addr constant [5 x i8] c"help\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"showing help\00", align 1
@.lit_str.1 = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str.2 = private unnamed_addr constant [23 x i8] c"running (verbose mode)\00", align 1
@.lit_str.3 = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c"running\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"unknown: \00", align 1
@.match_fn = private unnamed_addr constant [10 x i8] c"parse_cmd\00", align 1
@mu_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_mixed_match.av\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"\E2\9C\93\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"\E2\9C\97\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"?\00", align 1
@.match_fn.10 = private unnamed_addr constant [13 x i8] c"status_emoji\00", align 1
@mu_file.11 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_mixed_match.av\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"help\00", align 1
@.str.13 = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"xyz\00", align 1

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

define ptr @parse_cmd(ptr %0, i1 %1) {
entry:
  %pmatch_result = alloca i64, align 8
  %verbose = alloca i1, align 1
  %cmd = alloca ptr, align 8
  store ptr %0, ptr %cmd, align 8
  store i1 %1, ptr %verbose, align 8
  %cmd1 = load ptr, ptr %cmd, align 8
  store i64 0, ptr %pmatch_result, align 8
  %2 = call i32 @strcmp(ptr %cmd1, ptr @.lit_str)
  %widen = sext i32 %2 to i64
  %str_eq = icmp eq i64 %widen, 0
  br i1 %str_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body11, %parm_body7, %parm_body2, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast16 = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast16

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %3 = call i32 @strcmp(ptr %cmd1, ptr @.lit_str.1)
  %widen4 = sext i32 %3 to i64
  %str_eq5 = icmp eq i64 %widen4, 0
  br i1 %str_eq5, label %lit_guard, label %parm_next3

parm_body2:                                       ; preds = %lit_guard
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next3:                                       ; preds = %lit_guard, %parm_next
  %4 = call i32 @strcmp(ptr %cmd1, ptr @.lit_str.3)
  %widen9 = sext i32 %4 to i64
  %str_eq10 = icmp eq i64 %widen9, 0
  br i1 %str_eq10, label %parm_body7, label %parm_next8

lit_guard:                                        ; preds = %parm_next
  %verbose6 = load i1, ptr %verbose, align 8
  br i1 %verbose6, label %parm_body2, label %parm_next3

parm_body7:                                       ; preds = %parm_next3
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next8:                                       ; preds = %parm_next3
  br label %parm_body11

parm_body11:                                      ; preds = %parm_next8
  %cmd13 = load ptr, ptr %cmd, align 8
  %5 = call i64 @strlen(ptr @.str.5)
  %6 = call i64 @strlen(ptr %cmd13)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.5, i64 %5)
  %cast = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast, %5
  %cast14 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast14, ptr %cmd13, i64 %rhs_len_p1)
  %cast15 = ptrtoint ptr %7 to i64
  store i64 %cast15, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next12:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 3)
  unreachable
}

define ptr @status_emoji(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %code = alloca i64, align 8
  store i64 %0, ptr %code, align 8
  %code1 = load i64, ptr %code, align 8
  store i64 0, ptr %pmatch_result, align 8
  %lit_eq = icmp eq i64 %code1, 200
  br i1 %lit_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body8, %parm_body5, %parm_body2, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %lit_eq4 = icmp eq i64 %code1, 404
  br i1 %lit_eq4, label %parm_body2, label %parm_next3

parm_body2:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next3:                                       ; preds = %parm_next
  %lit_eq7 = icmp eq i64 %code1, 500
  br i1 %lit_eq7, label %parm_body5, label %parm_next6

parm_body5:                                       ; preds = %parm_next3
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next6:                                       ; preds = %parm_next3
  br label %parm_body8

parm_body8:                                       ; preds = %parm_next6
  store i64 ptrtoint (ptr @.str.9 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next9:                                       ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.10, i64 -1, ptr @mu_file.11, i64 17)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @parse_cmd(ptr @.str.12, i1 false)
  %1 = call i32 @puts(ptr %0)
  %widen = sext i32 %1 to i64
  %2 = call ptr @parse_cmd(ptr @.str.13, i1 true)
  %3 = call i32 @puts(ptr %2)
  %widen1 = sext i32 %3 to i64
  %4 = call ptr @parse_cmd(ptr @.str.14, i1 false)
  %5 = call i32 @puts(ptr %4)
  %widen2 = sext i32 %5 to i64
  %6 = call ptr @parse_cmd(ptr @.str.15, i1 false)
  %7 = call i32 @puts(ptr %6)
  %widen3 = sext i32 %7 to i64
  %8 = call ptr @status_emoji(i64 200)
  %9 = call i32 @puts(ptr %8)
  %widen4 = sext i32 %9 to i64
  %10 = call ptr @status_emoji(i64 404)
  %11 = call i32 @puts(ptr %10)
  %widen5 = sext i32 %11 to i64
  %12 = call ptr @status_emoji(i64 999)
  %13 = call i32 @puts(ptr %12)
  %widen6 = sext i32 %13 to i64
  %14 = call i32 @avra_test_summary()
  %widen7 = sext i32 %14 to i64
  call void @avra_rc_collect()
  ret i64 0
}
