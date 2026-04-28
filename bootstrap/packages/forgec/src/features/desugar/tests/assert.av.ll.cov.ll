; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/desugar/tests/assert.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@.str = private unnamed_addr constant [19 x i8] c"x must be positive\00", align 1
@.panic_prefix = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"assertion failed\00", align 1
@.panic_prefix.2 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"pass_basic\00", align 1
@.str.4 = private unnamed_addr constant [17 x i8] c"assertion failed\00", align 1
@.panic_prefix.5 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"pass_expr\00", align 1
@.str.7 = private unnamed_addr constant [32 x i8] c"ten should be greater than five\00", align 1
@.panic_prefix.8 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.9 = private unnamed_addr constant [13 x i8] c"pass_message\00", align 1
@.str.10 = private unnamed_addr constant [17 x i8] c"assertion failed\00", align 1
@.panic_prefix.11 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.12 = private unnamed_addr constant [14 x i8] c"pass_variable\00", align 1
@.str.13 = private unnamed_addr constant [17 x i8] c"pass_in_function\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_check = private global [15 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_check = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -7102839714003835893, i64 210708806723, i64 sub (i64 ptrtoint (ptr @__profc_check to i64), i64 ptrtoint (ptr @__profd_check to i64)), i64 0, ptr null, ptr null, i32 15, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [64 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 64, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [20 x i8] c"\0A\12x\DAK\CEHM\CEf\CCM\CC\CC\03\00\14\0B\03\A5", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_check, ptr @__profd_main], section "llvm.metadata"
@llvm.used = appending global [1 x ptr] [ptr @__llvm_prf_nm], section "llvm.metadata"

; Function Attrs: nounwind
declare void @llvm.instrprof.increment(ptr, i64, i32, i32) #0

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

define i1 @check(i64 %0) {
entry:
  %ife_result = alloca i64, align 8
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_check, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_check, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 6), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 7), align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %not_cmp = icmp eq i64 %sgt_ext, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %ife_cond = icmp ne i64 %not_cmp_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 13), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 13), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 14), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 14), align 8
  ret i1 true

ife_then:                                         ; preds = %entry
  %pgocount10 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 8), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 8), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 9), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 9), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 10), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 10), align 8
  %14 = call i64 @strlen(ptr @.panic_prefix)
  %15 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %14, %15
  %concat_size = add i64 %concat_total, 1
  %16 = call ptr @forge_rc_alloc(i64 %concat_size)
  %17 = call ptr @memcpy(ptr %16, ptr @.panic_prefix, i64 %14)
  %cast = ptrtoint ptr %16 to i64
  %dst2_int = add i64 %cast, %14
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %15, 1
  %18 = call ptr @memcpy(ptr %cast2, ptr @.str, i64 %rhs_len_p1)
  call void @forge_eprintln(ptr %16)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %pgocount13 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 11), align 8
  %19 = add i64 %pgocount13, 1
  store i64 %19, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 11), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 12), align 8
  %20 = add i64 %pgocount14, 1
  store i64 %20, ptr getelementptr inbounds ([15 x i64], ptr @__profc_check, i32 0, i32 12), align 8
  store i64 0, ptr %ife_result, align 8
  br label %ife_end
}

define i64 @main() {
entry:
  %ife_result27 = alloca i64, align 8
  %x = alloca i64, align 8
  %ife_result14 = alloca i64, align 8
  %ife_result2 = alloca i64, align 8
  %ife_result = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  br i1 false, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %6 = add i64 %pgocount6, 1
  store i64 %6, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %7 = add i64 %pgocount7, 1
  store i64 %7, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %8 = call i32 @puts(ptr @.str.3)
  %widen = sext i32 %8 to i64
  %pgocount8 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %14 = add i64 %pgocount13, 1
  store i64 %14, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %15 = add i64 %pgocount14, 1
  store i64 %15, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %16 = add i64 %pgocount15, 1
  store i64 %16, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %17 = add i64 %pgocount16, 1
  store i64 %17, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  br i1 false, label %ife_then4, label %ife_else5

ife_then:                                         ; preds = %entry
  %pgocount17 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %18 = add i64 %pgocount17, 1
  store i64 %18, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %19 = add i64 %pgocount18, 1
  store i64 %19, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %20 = add i64 %pgocount19, 1
  store i64 %20, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %21 = call i64 @strlen(ptr @.panic_prefix.2)
  %22 = call i64 @strlen(ptr @.str.1)
  %concat_total = add i64 %21, %22
  %concat_size = add i64 %concat_total, 1
  %23 = call ptr @forge_rc_alloc(i64 %concat_size)
  %24 = call ptr @memcpy(ptr %23, ptr @.panic_prefix.2, i64 %21)
  %cast = ptrtoint ptr %23 to i64
  %dst2_int = add i64 %cast, %21
  %cast1 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast1, ptr @.str.1, i64 %rhs_len_p1)
  call void @forge_eprintln(ptr %23)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %pgocount20 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %26 = add i64 %pgocount20, 1
  store i64 %26, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %27 = add i64 %pgocount21, 1
  store i64 %27, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  store i64 0, ptr %ife_result, align 8
  br label %ife_end

ife_end3:                                         ; preds = %ife_else5, %ife_then4
  %ife_val12 = load i64, ptr %ife_result2, align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %28 = add i64 %pgocount22, 1
  store i64 %28, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %29 = add i64 %pgocount23, 1
  store i64 %29, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %30 = call i32 @puts(ptr @.str.6)
  %widen13 = sext i32 %30 to i64
  %pgocount24 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %31 = add i64 %pgocount24, 1
  store i64 %31, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %32 = add i64 %pgocount25, 1
  store i64 %32, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %33 = add i64 %pgocount26, 1
  store i64 %33, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %34 = add i64 %pgocount27, 1
  store i64 %34, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %35 = add i64 %pgocount28, 1
  store i64 %35, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %36 = add i64 %pgocount29, 1
  store i64 %36, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %37 = add i64 %pgocount30, 1
  store i64 %37, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  br i1 false, label %ife_then16, label %ife_else17

ife_then4:                                        ; preds = %ife_end
  %pgocount31 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %38 = add i64 %pgocount31, 1
  store i64 %38, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %39 = add i64 %pgocount32, 1
  store i64 %39, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %40 = add i64 %pgocount33, 1
  store i64 %40, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %41 = call i64 @strlen(ptr @.panic_prefix.5)
  %42 = call i64 @strlen(ptr @.str.4)
  %concat_total6 = add i64 %41, %42
  %concat_size7 = add i64 %concat_total6, 1
  %43 = call ptr @forge_rc_alloc(i64 %concat_size7)
  %44 = call ptr @memcpy(ptr %43, ptr @.panic_prefix.5, i64 %41)
  %cast8 = ptrtoint ptr %43 to i64
  %dst2_int9 = add i64 %cast8, %41
  %cast10 = inttoptr i64 %dst2_int9 to ptr
  %rhs_len_p111 = add i64 %42, 1
  %45 = call ptr @memcpy(ptr %cast10, ptr @.str.4, i64 %rhs_len_p111)
  call void @forge_eprintln(ptr %43)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result2, align 8
  br label %ife_end3

ife_else5:                                        ; preds = %ife_end
  %pgocount34 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %46 = add i64 %pgocount34, 1
  store i64 %46, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %47 = add i64 %pgocount35, 1
  store i64 %47, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  store i64 0, ptr %ife_result2, align 8
  br label %ife_end3

ife_end15:                                        ; preds = %ife_else17, %ife_then16
  %ife_val24 = load i64, ptr %ife_result14, align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %48 = add i64 %pgocount36, 1
  store i64 %48, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %49 = add i64 %pgocount37, 1
  store i64 %49, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %50 = call i32 @puts(ptr @.str.9)
  %widen25 = sext i32 %50 to i64
  %pgocount38 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %51 = add i64 %pgocount38, 1
  store i64 %51, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %52 = add i64 %pgocount39, 1
  store i64 %52, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  store i64 42, ptr %x, align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %53 = add i64 %pgocount40, 1
  store i64 %53, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %54 = add i64 %pgocount41, 1
  store i64 %54, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %55 = add i64 %pgocount42, 1
  store i64 %55, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %56 = add i64 %pgocount43, 1
  store i64 %56, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %57 = add i64 %pgocount44, 1
  store i64 %57, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %58 = add i64 %pgocount45, 1
  store i64 %58, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %x26 = load i64, ptr %x, align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %59 = add i64 %pgocount46, 1
  store i64 %59, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %sgt = icmp sgt i64 %x26, 0
  %sgt_ext = zext i1 %sgt to i64
  %not_cmp = icmp eq i64 %sgt_ext, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %ife_cond = icmp ne i64 %not_cmp_ext, 0
  br i1 %ife_cond, label %ife_then29, label %ife_else30

ife_then16:                                       ; preds = %ife_end3
  %pgocount47 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %60 = add i64 %pgocount47, 1
  store i64 %60, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %61 = add i64 %pgocount48, 1
  store i64 %61, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %62 = add i64 %pgocount49, 1
  store i64 %62, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %63 = call i64 @strlen(ptr @.panic_prefix.8)
  %64 = call i64 @strlen(ptr @.str.7)
  %concat_total18 = add i64 %63, %64
  %concat_size19 = add i64 %concat_total18, 1
  %65 = call ptr @forge_rc_alloc(i64 %concat_size19)
  %66 = call ptr @memcpy(ptr %65, ptr @.panic_prefix.8, i64 %63)
  %cast20 = ptrtoint ptr %65 to i64
  %dst2_int21 = add i64 %cast20, %63
  %cast22 = inttoptr i64 %dst2_int21 to ptr
  %rhs_len_p123 = add i64 %64, 1
  %67 = call ptr @memcpy(ptr %cast22, ptr @.str.7, i64 %rhs_len_p123)
  call void @forge_eprintln(ptr %65)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result14, align 8
  br label %ife_end15

ife_else17:                                       ; preds = %ife_end3
  %pgocount50 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %68 = add i64 %pgocount50, 1
  store i64 %68, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %69 = add i64 %pgocount51, 1
  store i64 %69, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  store i64 0, ptr %ife_result14, align 8
  br label %ife_end15

ife_end28:                                        ; preds = %ife_else30, %ife_then29
  %ife_val37 = load i64, ptr %ife_result27, align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %70 = add i64 %pgocount52, 1
  store i64 %70, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %pgocount53 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %71 = add i64 %pgocount53, 1
  store i64 %71, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %72 = call i32 @puts(ptr @.str.12)
  %widen38 = sext i32 %72 to i64
  %pgocount54 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %73 = add i64 %pgocount54, 1
  store i64 %73, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %74 = add i64 %pgocount55, 1
  store i64 %74, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %75 = add i64 %pgocount56, 1
  store i64 %75, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %76 = call i1 @check(i64 10)
  %widen39 = zext i1 %76 to i64
  %pgocount57 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %77 = add i64 %pgocount57, 1
  store i64 %77, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount58 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %78 = add i64 %pgocount58, 1
  store i64 %78, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %79 = call i32 @puts(ptr @.str.13)
  %widen40 = sext i32 %79 to i64
  ret i64 0

ife_then29:                                       ; preds = %ife_end15
  %pgocount59 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %80 = add i64 %pgocount59, 1
  store i64 %80, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %81 = add i64 %pgocount60, 1
  store i64 %81, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %82 = add i64 %pgocount61, 1
  store i64 %82, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %83 = call i64 @strlen(ptr @.panic_prefix.11)
  %84 = call i64 @strlen(ptr @.str.10)
  %concat_total31 = add i64 %83, %84
  %concat_size32 = add i64 %concat_total31, 1
  %85 = call ptr @forge_rc_alloc(i64 %concat_size32)
  %86 = call ptr @memcpy(ptr %85, ptr @.panic_prefix.11, i64 %83)
  %cast33 = ptrtoint ptr %85 to i64
  %dst2_int34 = add i64 %cast33, %83
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %84, 1
  %87 = call ptr @memcpy(ptr %cast35, ptr @.str.10, i64 %rhs_len_p136)
  call void @forge_eprintln(ptr %85)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result27, align 8
  br label %ife_end28

ife_else30:                                       ; preds = %ife_end15
  %pgocount62 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %88 = add i64 %pgocount62, 1
  store i64 %88, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount63 = load i64, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %89 = add i64 %pgocount63, 1
  store i64 %89, ptr getelementptr inbounds ([64 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  store i64 0, ptr %ife_result27, align 8
  br label %ife_end28
}

define i64 @__bs_top_level() {
entry:
  %0 = call i32 @forge_test_summary()
  %widen = sext i32 %0 to i64
  call void @forge_rc_collect()
  ret i64 0
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
