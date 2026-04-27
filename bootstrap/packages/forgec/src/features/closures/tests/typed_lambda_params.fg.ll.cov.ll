; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/typed_lambda_params.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@csv = global i64 0
@values = global i64 0
@total = global i64 0
@upper_parts = global i64 0
@long_words = global i64 0
@.str = private unnamed_addr constant [15 x i8] c"10,20,30,40,50\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"hello,world\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"hi\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"hey\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"greetings\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [5 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 5, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_1 = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_1 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6925786121186820513, i64 8245973951994833620, i64 sub (i64 ptrtoint (ptr @__profc___lambda_1 to i64), i64 ptrtoint (ptr @__profd___lambda_1 to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_2 = private global [5 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_2 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6511828798704078813, i64 8245973951994833621, i64 sub (i64 ptrtoint (ptr @__profc___lambda_2 to i64), i64 ptrtoint (ptr @__profd___lambda_2 to i64)), i64 0, ptr null, ptr null, i32 5, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_3 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_3 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 2645571496225459039, i64 8245973951994833622, i64 sub (i64 ptrtoint (ptr @__profc___lambda_3 to i64), i64 ptrtoint (ptr @__profd___lambda_3 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [33 x i8] c"0\1Fx\DA\CBM\CC\CCc\8C\8F\CFI\CCMJI\8C7@0\0D\11L#\04\D3\18\00\94\E2\10h", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [6 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_main, ptr @__profd___lambda_0, ptr @__profd___lambda_1, ptr @__profd___lambda_2, ptr @__profd___lambda_3], section "llvm.metadata"
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

define i64 @main() {
entry:
  %w = alloca i64, align 8
  %forin_i7 = alloca i64, align 8
  %forin_len6 = alloca i64, align 8
  %p = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  store ptr @.str, ptr @csv, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %csv = load ptr, ptr @csv, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %4 = call ptr @forge_str_split(ptr %csv, ptr @.str.1)
  store ptr %4, ptr @values, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %values = load ptr, ptr @values, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %8 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %8, i64 -559038737)
  call void @forge_array_push(ptr %8, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %8 to i64
  %9 = call i64 @forge_array_reduce(ptr %values, i64 0, i64 %cast)
  store i64 %9, ptr @total, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %10 = add i64 %pgocount7, 1
  store i64 %10, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %11 = add i64 %pgocount8, 1
  store i64 %11, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %12 = add i64 %pgocount9, 1
  store i64 %12, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %13 = add i64 %pgocount10, 1
  store i64 %13, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %total = load i64, ptr @total, align 8
  %14 = call ptr @forge_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt, i64 %total)
  %widen = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen1 = sext i32 %16 to i64
  %pgocount11 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %17 = add i64 %pgocount11, 1
  store i64 %17, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %18 = add i64 %pgocount12, 1
  store i64 %18, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %19 = add i64 %pgocount13, 1
  store i64 %19, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %20 = add i64 %pgocount14, 1
  store i64 %20, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %21 = call ptr @forge_str_split(ptr @.str.2, ptr @.str.3)
  %22 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %22, i64 -559038737)
  call void @forge_array_push(ptr %22, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast2 = ptrtoint ptr %22 to i64
  %23 = call ptr @forge_array_map(ptr %21, i64 %cast2)
  store ptr %23, ptr @upper_parts, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %24 = add i64 %pgocount15, 1
  store i64 %24, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %25 = add i64 %pgocount16, 1
  store i64 %25, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %26 = add i64 %pgocount17, 1
  store i64 %26, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %upper_parts = load ptr, ptr @upper_parts, align 8
  %27 = call i64 @forge_array_len(ptr %upper_parts)
  store i64 %27, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %28 = call i64 @forge_array_get(ptr %upper_parts, i64 %forin_i_val)
  store i64 %28, ptr %p, align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %29 = add i64 %pgocount18, 1
  store i64 %29, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %30 = add i64 %pgocount19, 1
  store i64 %30, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %31 = add i64 %pgocount20, 1
  store i64 %31, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %32 = add i64 %pgocount21, 1
  store i64 %32, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %p3 = load ptr, ptr %p, align 8
  %33 = call i32 @puts(ptr %p3)
  %widen4 = sext i32 %33 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %pgocount22 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %34 = add i64 %pgocount22, 1
  store i64 %34, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %35 = add i64 %pgocount23, 1
  store i64 %35, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %36 = call ptr @forge_array_new()
  %pgocount24 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %37 = add i64 %pgocount24, 1
  store i64 %37, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  call void @forge_array_push(ptr %36, i64 ptrtoint (ptr @.str.4 to i64))
  %pgocount25 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %38 = add i64 %pgocount25, 1
  store i64 %38, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  call void @forge_array_push(ptr %36, i64 ptrtoint (ptr @.str.5 to i64))
  %pgocount26 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %39 = add i64 %pgocount26, 1
  store i64 %39, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  call void @forge_array_push(ptr %36, i64 ptrtoint (ptr @.str.6 to i64))
  %pgocount27 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %40 = add i64 %pgocount27, 1
  store i64 %40, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  call void @forge_array_push(ptr %36, i64 ptrtoint (ptr @.str.7 to i64))
  %41 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %41, i64 -559038737)
  call void @forge_array_push(ptr %41, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast5 = ptrtoint ptr %41 to i64
  %42 = call ptr @forge_array_filter(ptr %36, i64 %cast5)
  store ptr %42, ptr @long_words, align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %43 = add i64 %pgocount28, 1
  store i64 %43, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %44 = add i64 %pgocount29, 1
  store i64 %44, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %45 = add i64 %pgocount30, 1
  store i64 %45, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %long_words = load ptr, ptr @long_words, align 8
  %46 = call i64 @forge_array_len(ptr %long_words)
  store i64 %46, ptr %forin_len6, align 8
  store i64 0, ptr %forin_i7, align 8
  br label %forin.cond8

forin.cond8:                                      ; preds = %forin.incr10, %forin.exit
  %forin_i_val12 = load i64, ptr %forin_i7, align 8
  %forin_len_val13 = load i64, ptr %forin_len6, align 8
  %forin_cmp14 = icmp slt i64 %forin_i_val12, %forin_len_val13
  br i1 %forin_cmp14, label %forin.body9, label %forin.exit11

forin.body9:                                      ; preds = %forin.cond8
  %47 = call i64 @forge_array_get(ptr %long_words, i64 %forin_i_val12)
  store i64 %47, ptr %w, align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %48 = add i64 %pgocount31, 1
  store i64 %48, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %49 = add i64 %pgocount32, 1
  store i64 %49, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %50 = add i64 %pgocount33, 1
  store i64 %50, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %51 = add i64 %pgocount34, 1
  store i64 %51, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %w15 = load ptr, ptr %w, align 8
  %52 = call i32 @puts(ptr %w15)
  %widen16 = sext i32 %52 to i64
  br label %forin.incr10

forin.incr10:                                     ; preds = %forin.body9
  %forin_i_old17 = load i64, ptr %forin_i7, align 8
  %forin_next18 = add i64 %forin_i_old17, 1
  store i64 %forin_next18, ptr %forin_i7, align 8
  br label %forin.cond8

forin.exit11:                                     ; preds = %forin.cond8
  %pgocount35 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %53 = add i64 %pgocount35, 1
  store i64 %53, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %54 = add i64 %pgocount36, 1
  store i64 %54, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %55 = add i64 %pgocount37, 1
  store i64 %55, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %56 = call ptr @forge_array_new()
  %pgocount38 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %57 = add i64 %pgocount38, 1
  store i64 %57, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  call void @forge_array_push(ptr %56, i64 ptrtoint (ptr @.str.8 to i64))
  %pgocount39 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %58 = add i64 %pgocount39, 1
  store i64 %58, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  call void @forge_array_push(ptr %56, i64 ptrtoint (ptr @.str.9 to i64))
  %pgocount40 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %59 = add i64 %pgocount40, 1
  store i64 %59, ptr getelementptr inbounds ([4 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  call void @forge_array_push(ptr %56, i64 ptrtoint (ptr @.str.10 to i64))
  %60 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %60, i64 -559038737)
  call void @forge_array_push(ptr %60, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast19 = ptrtoint ptr %60 to i64
  call void @forge_array_foreach(ptr %56, i64 %cast19)
  %61 = call i32 @forge_test_summary()
  %widen20 = sext i32 %61 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store ptr %1, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %acc1 = load i64, ptr %acc, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_0, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_0, i32 0, i32 4), align 8
  %x2 = load ptr, ptr %x, align 8
  %7 = call i32 @atoi(ptr %x2)
  %widen = sext i32 %7 to i64
  %add = add i64 %acc1, %widen
  ret i64 %add
}

define i64 @__lambda_1(ptr %0) {
entry:
  %x = alloca ptr, align 8
  store ptr %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_1, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_1, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %x1 = load ptr, ptr %x, align 8
  %4 = call ptr @forge_str_to_upper(ptr %x1)
  %cast = ptrtoint ptr %4 to i64
  ret i64 %cast
}

define i64 @__lambda_2(ptr %0) {
entry:
  %w = alloca ptr, align 8
  store ptr %0, ptr %w, align 8
  %pgocount = load i64, ptr @__profc___lambda_2, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_2, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_2, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_2, i32 0, i32 3), align 8
  %w1 = load ptr, ptr %w, align 8
  %5 = call i64 @strlen(ptr %w1)
  %pgocount4 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_2, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_2, i32 0, i32 4), align 8
  %sgt = icmp sgt i64 %5, 3
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_3(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %pgocount = load i64, ptr @__profc___lambda_3, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_3, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 3), align 8
  %s1 = load ptr, ptr %s, align 8
  %5 = call ptr @forge_str_to_upper(ptr %s1)
  %6 = call i32 @puts(ptr %5)
  %widen = sext i32 %6 to i64
  ret i64 0
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
