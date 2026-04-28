; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/for_stmt/tests/forin_comprehensive.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@words = global i64 0
@scores = global i64 0
@total = global i64 0
@rows = global i64 0
@flat_sum = global i64 0
@found = global i64 0
@odd_sum = global i64 0
@count = global i64 0
@nums = global i64 0
@doubled = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"forge\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@dz_file = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/for_stmt/tests/forin_comprehensive.fg\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [12 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 12, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [25 x i8] c"\0F\17x\DA\CBM\CC\CCc\8C\8F\CFI\CCMJI\8C7\00\00+u\05U", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_main, ptr @__profd___lambda_0], section "llvm.metadata"
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
  %d = alloca i64, align 8
  %forin_i103 = alloca i64, align 8
  %forin_len102 = alloca i64, align 8
  %x87 = alloca i64, align 8
  %forin_i86 = alloca i64, align 8
  %forin_len85 = alloca i64, align 8
  %n = alloca i64, align 8
  %forin_i63 = alloca i64, align 8
  %forin_len62 = alloca i64, align 8
  %x = alloca i64, align 8
  %forin_i48 = alloca i64, align 8
  %forin_len47 = alloca i64, align 8
  %val = alloca i64, align 8
  %forin_i30 = alloca i64, align 8
  %forin_len29 = alloca i64, align 8
  %row = alloca i64, align 8
  %forin_i20 = alloca i64, align 8
  %forin_len19 = alloca i64, align 8
  %s = alloca i64, align 8
  %forin_i3 = alloca i64, align 8
  %forin_len2 = alloca i64, align 8
  %w = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %1 = call ptr @forge_array_new()
  %pgocount1 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @.str to i64))
  %pgocount2 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @.str.1 to i64))
  %pgocount3 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @.str.2 to i64))
  store ptr %1, ptr @words, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %words = load ptr, ptr @words, align 8
  %8 = call i64 @forge_array_len(ptr %words)
  store i64 %8, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %9 = call i64 @forge_array_get(ptr %words, i64 %forin_i_val)
  store i64 %9, ptr %w, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %10 = add i64 %pgocount7, 1
  store i64 %10, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %11 = add i64 %pgocount8, 1
  store i64 %11, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %12 = add i64 %pgocount9, 1
  store i64 %12, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %13 = add i64 %pgocount10, 1
  store i64 %13, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %w1 = load ptr, ptr %w, align 8
  %14 = call i32 @puts(ptr %w1)
  %widen = sext i32 %14 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %pgocount11 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %16 = call ptr @forge_array_new()
  %pgocount12 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %17 = add i64 %pgocount12, 1
  store i64 %17, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  call void @forge_array_push(ptr %16, i64 10)
  %pgocount13 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  call void @forge_array_push(ptr %16, i64 20)
  %pgocount14 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %19 = add i64 %pgocount14, 1
  store i64 %19, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  call void @forge_array_push(ptr %16, i64 30)
  %pgocount15 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %20 = add i64 %pgocount15, 1
  store i64 %20, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  call void @forge_array_push(ptr %16, i64 40)
  %pgocount16 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %21 = add i64 %pgocount16, 1
  store i64 %21, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  call void @forge_array_push(ptr %16, i64 50)
  store ptr %16, ptr @scores, align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %22 = add i64 %pgocount17, 1
  store i64 %22, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  store i64 0, ptr @total, align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %23 = add i64 %pgocount18, 1
  store i64 %23, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %24 = add i64 %pgocount19, 1
  store i64 %24, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %25 = add i64 %pgocount20, 1
  store i64 %25, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %scores = load ptr, ptr @scores, align 8
  %26 = call i64 @forge_array_len(ptr %scores)
  store i64 %26, ptr %forin_len2, align 8
  store i64 0, ptr %forin_i3, align 8
  br label %forin.cond4

forin.cond4:                                      ; preds = %forin.incr6, %forin.exit
  %forin_i_val8 = load i64, ptr %forin_i3, align 8
  %forin_len_val9 = load i64, ptr %forin_len2, align 8
  %forin_cmp10 = icmp slt i64 %forin_i_val8, %forin_len_val9
  br i1 %forin_cmp10, label %forin.body5, label %forin.exit7

forin.body5:                                      ; preds = %forin.cond4
  %27 = call i64 @forge_array_get(ptr %scores, i64 %forin_i_val8)
  store i64 %27, ptr %s, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %28 = add i64 %pgocount21, 1
  store i64 %28, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %29 = add i64 %pgocount22, 1
  store i64 %29, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %30 = add i64 %pgocount23, 1
  store i64 %30, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %31 = add i64 %pgocount24, 1
  store i64 %31, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %32 = add i64 %pgocount25, 1
  store i64 %32, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %total = load i64, ptr @total, align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %33 = add i64 %pgocount26, 1
  store i64 %33, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %s11 = load i64, ptr %s, align 8
  %add = add i64 %total, %s11
  store i64 %add, ptr @total, align 8
  br label %forin.incr6

forin.incr6:                                      ; preds = %forin.body5
  %forin_i_old12 = load i64, ptr %forin_i3, align 8
  %forin_next13 = add i64 %forin_i_old12, 1
  store i64 %forin_next13, ptr %forin_i3, align 8
  br label %forin.cond4

forin.exit7:                                      ; preds = %forin.cond4
  %pgocount27 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %34 = add i64 %pgocount27, 1
  store i64 %34, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %35 = add i64 %pgocount28, 1
  store i64 %35, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %36 = add i64 %pgocount29, 1
  store i64 %36, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %37 = add i64 %pgocount30, 1
  store i64 %37, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %total14 = load i64, ptr @total, align 8
  %38 = call ptr @forge_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt, i64 %total14)
  %widen15 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen16 = sext i32 %40 to i64
  %pgocount31 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %41 = add i64 %pgocount31, 1
  store i64 %41, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %42 = call ptr @forge_array_new()
  %pgocount32 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %43 = add i64 %pgocount32, 1
  store i64 %43, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %44 = call ptr @forge_array_new()
  %pgocount33 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %45 = add i64 %pgocount33, 1
  store i64 %45, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  call void @forge_array_push(ptr %44, i64 1)
  %pgocount34 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %46 = add i64 %pgocount34, 1
  store i64 %46, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  call void @forge_array_push(ptr %44, i64 2)
  %cast = ptrtoint ptr %44 to i64
  call void @forge_array_push(ptr %42, i64 %cast)
  %pgocount35 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %47 = add i64 %pgocount35, 1
  store i64 %47, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %48 = call ptr @forge_array_new()
  %pgocount36 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %49 = add i64 %pgocount36, 1
  store i64 %49, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  call void @forge_array_push(ptr %48, i64 3)
  %pgocount37 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %50 = add i64 %pgocount37, 1
  store i64 %50, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  call void @forge_array_push(ptr %48, i64 4)
  %cast17 = ptrtoint ptr %48 to i64
  call void @forge_array_push(ptr %42, i64 %cast17)
  %pgocount38 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %51 = add i64 %pgocount38, 1
  store i64 %51, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %52 = call ptr @forge_array_new()
  %pgocount39 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %53 = add i64 %pgocount39, 1
  store i64 %53, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  call void @forge_array_push(ptr %52, i64 5)
  %pgocount40 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %54 = add i64 %pgocount40, 1
  store i64 %54, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  call void @forge_array_push(ptr %52, i64 6)
  %cast18 = ptrtoint ptr %52 to i64
  call void @forge_array_push(ptr %42, i64 %cast18)
  store ptr %42, ptr @rows, align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %55 = add i64 %pgocount41, 1
  store i64 %55, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  store i64 0, ptr @flat_sum, align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %56 = add i64 %pgocount42, 1
  store i64 %56, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %57 = add i64 %pgocount43, 1
  store i64 %57, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %58 = add i64 %pgocount44, 1
  store i64 %58, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %rows = load ptr, ptr @rows, align 8
  %59 = call i64 @forge_array_len(ptr %rows)
  store i64 %59, ptr %forin_len19, align 8
  store i64 0, ptr %forin_i20, align 8
  br label %forin.cond21

forin.cond21:                                     ; preds = %forin.incr23, %forin.exit7
  %forin_i_val25 = load i64, ptr %forin_i20, align 8
  %forin_len_val26 = load i64, ptr %forin_len19, align 8
  %forin_cmp27 = icmp slt i64 %forin_i_val25, %forin_len_val26
  br i1 %forin_cmp27, label %forin.body22, label %forin.exit24

forin.body22:                                     ; preds = %forin.cond21
  %60 = call i64 @forge_array_get(ptr %rows, i64 %forin_i_val25)
  store i64 %60, ptr %row, align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %61 = add i64 %pgocount45, 1
  store i64 %61, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %62 = add i64 %pgocount46, 1
  store i64 %62, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %63 = add i64 %pgocount47, 1
  store i64 %63, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %64 = add i64 %pgocount48, 1
  store i64 %64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %row28 = load ptr, ptr %row, align 8
  %65 = call i64 @forge_array_len(ptr %row28)
  store i64 %65, ptr %forin_len29, align 8
  store i64 0, ptr %forin_i30, align 8
  br label %forin.cond31

forin.incr23:                                     ; preds = %forin.exit34
  %forin_i_old42 = load i64, ptr %forin_i20, align 8
  %forin_next43 = add i64 %forin_i_old42, 1
  store i64 %forin_next43, ptr %forin_i20, align 8
  br label %forin.cond21

forin.exit24:                                     ; preds = %forin.cond21
  %pgocount49 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %66 = add i64 %pgocount49, 1
  store i64 %66, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %67 = add i64 %pgocount50, 1
  store i64 %67, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %68 = add i64 %pgocount51, 1
  store i64 %68, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %69 = add i64 %pgocount52, 1
  store i64 %69, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %flat_sum44 = load i64, ptr @flat_sum, align 8
  %70 = call ptr @forge_rc_alloc(i64 32)
  %71 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %70, i64 32, ptr @.i2s_fmt.3, i64 %flat_sum44)
  %widen45 = sext i32 %71 to i64
  %72 = call i32 @puts(ptr %70)
  %widen46 = sext i32 %72 to i64
  %pgocount53 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %73 = add i64 %pgocount53, 1
  store i64 %73, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %74 = add i64 %pgocount54, 1
  store i64 %74, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  store i64 -1, ptr @found, align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %75 = add i64 %pgocount55, 1
  store i64 %75, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %76 = add i64 %pgocount56, 1
  store i64 %76, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %77 = add i64 %pgocount57, 1
  store i64 %77, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %78 = call ptr @forge_array_new()
  %pgocount58 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %79 = add i64 %pgocount58, 1
  store i64 %79, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  call void @forge_array_push(ptr %78, i64 10)
  %pgocount59 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %80 = add i64 %pgocount59, 1
  store i64 %80, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  call void @forge_array_push(ptr %78, i64 20)
  %pgocount60 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %81 = add i64 %pgocount60, 1
  store i64 %81, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  call void @forge_array_push(ptr %78, i64 30)
  %pgocount61 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %82 = add i64 %pgocount61, 1
  store i64 %82, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  call void @forge_array_push(ptr %78, i64 40)
  %83 = call i64 @forge_array_len(ptr %78)
  store i64 %83, ptr %forin_len47, align 8
  store i64 0, ptr %forin_i48, align 8
  br label %forin.cond49

forin.cond31:                                     ; preds = %forin.incr33, %forin.body22
  %forin_i_val35 = load i64, ptr %forin_i30, align 8
  %forin_len_val36 = load i64, ptr %forin_len29, align 8
  %forin_cmp37 = icmp slt i64 %forin_i_val35, %forin_len_val36
  br i1 %forin_cmp37, label %forin.body32, label %forin.exit34

forin.body32:                                     ; preds = %forin.cond31
  %84 = call i64 @forge_array_get(ptr %row28, i64 %forin_i_val35)
  store i64 %84, ptr %val, align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %85 = add i64 %pgocount62, 1
  store i64 %85, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount63 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %86 = add i64 %pgocount63, 1
  store i64 %86, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %87 = add i64 %pgocount64, 1
  store i64 %87, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount65 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %88 = add i64 %pgocount65, 1
  store i64 %88, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %89 = add i64 %pgocount66, 1
  store i64 %89, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %flat_sum = load i64, ptr @flat_sum, align 8
  %pgocount67 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %90 = add i64 %pgocount67, 1
  store i64 %90, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %val38 = load i64, ptr %val, align 8
  %add39 = add i64 %flat_sum, %val38
  store i64 %add39, ptr @flat_sum, align 8
  br label %forin.incr33

forin.incr33:                                     ; preds = %forin.body32
  %forin_i_old40 = load i64, ptr %forin_i30, align 8
  %forin_next41 = add i64 %forin_i_old40, 1
  store i64 %forin_next41, ptr %forin_i30, align 8
  br label %forin.cond31

forin.exit34:                                     ; preds = %forin.cond31
  br label %forin.incr23

forin.cond49:                                     ; preds = %forin.incr51, %forin.exit24
  %forin_i_val53 = load i64, ptr %forin_i48, align 8
  %forin_len_val54 = load i64, ptr %forin_len47, align 8
  %forin_cmp55 = icmp slt i64 %forin_i_val53, %forin_len_val54
  br i1 %forin_cmp55, label %forin.body50, label %forin.exit52

forin.body50:                                     ; preds = %forin.cond49
  %91 = call i64 @forge_array_get(ptr %78, i64 %forin_i_val53)
  store i64 %91, ptr %x, align 8
  %pgocount68 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %92 = add i64 %pgocount68, 1
  store i64 %92, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %pgocount69 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %93 = add i64 %pgocount69, 1
  store i64 %93, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %pgocount70 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %94 = add i64 %pgocount70, 1
  store i64 %94, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %pgocount71 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %95 = add i64 %pgocount71, 1
  store i64 %95, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %96 = add i64 %pgocount72, 1
  store i64 %96, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %x56 = load i64, ptr %x, align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %97 = add i64 %pgocount73, 1
  store i64 %97, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %eq = icmp eq i64 %x56, 30
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

forin.incr51:                                     ; preds = %ifcont
  %forin_i_old58 = load i64, ptr %forin_i48, align 8
  %forin_next59 = add i64 %forin_i_old58, 1
  store i64 %forin_next59, ptr %forin_i48, align 8
  br label %forin.cond49

forin.exit52:                                     ; preds = %if_then, %forin.cond49
  %pgocount74 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %98 = add i64 %pgocount74, 1
  store i64 %98, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount75 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %99 = add i64 %pgocount75, 1
  store i64 %99, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %pgocount76 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %100 = add i64 %pgocount76, 1
  store i64 %100, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %pgocount77 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %101 = add i64 %pgocount77, 1
  store i64 %101, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %found = load i64, ptr @found, align 8
  %102 = call ptr @forge_rc_alloc(i64 32)
  %103 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %102, i64 32, ptr @.i2s_fmt.4, i64 %found)
  %widen60 = sext i32 %103 to i64
  %104 = call i32 @puts(ptr %102)
  %widen61 = sext i32 %104 to i64
  %pgocount78 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %105 = add i64 %pgocount78, 1
  store i64 %105, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  store i64 0, ptr @odd_sum, align 8
  %pgocount79 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %106 = add i64 %pgocount79, 1
  store i64 %106, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %pgocount80 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %107 = add i64 %pgocount80, 1
  store i64 %107, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %pgocount81 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %108 = add i64 %pgocount81, 1
  store i64 %108, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %109 = call ptr @forge_array_new()
  %pgocount82 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %110 = add i64 %pgocount82, 1
  store i64 %110, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  call void @forge_array_push(ptr %109, i64 1)
  %pgocount83 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %111 = add i64 %pgocount83, 1
  store i64 %111, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  call void @forge_array_push(ptr %109, i64 2)
  %pgocount84 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %112 = add i64 %pgocount84, 1
  store i64 %112, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  call void @forge_array_push(ptr %109, i64 3)
  %pgocount85 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %113 = add i64 %pgocount85, 1
  store i64 %113, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  call void @forge_array_push(ptr %109, i64 4)
  %pgocount86 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %114 = add i64 %pgocount86, 1
  store i64 %114, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  call void @forge_array_push(ptr %109, i64 5)
  %pgocount87 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %115 = add i64 %pgocount87, 1
  store i64 %115, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  call void @forge_array_push(ptr %109, i64 6)
  %pgocount88 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %116 = add i64 %pgocount88, 1
  store i64 %116, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  call void @forge_array_push(ptr %109, i64 7)
  %117 = call i64 @forge_array_len(ptr %109)
  store i64 %117, ptr %forin_len62, align 8
  store i64 0, ptr %forin_i63, align 8
  br label %forin.cond64

ifcont:                                           ; preds = %if_else
  br label %forin.incr51

if_then:                                          ; preds = %forin.body50
  %pgocount89 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %118 = add i64 %pgocount89, 1
  store i64 %118, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %pgocount90 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %119 = add i64 %pgocount90, 1
  store i64 %119, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount91 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %120 = add i64 %pgocount91, 1
  store i64 %120, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %pgocount92 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %121 = add i64 %pgocount92, 1
  store i64 %121, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %pgocount93 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %122 = add i64 %pgocount93, 1
  store i64 %122, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %x57 = load i64, ptr %x, align 8
  store i64 %x57, ptr @found, align 8
  %pgocount94 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %123 = add i64 %pgocount94, 1
  store i64 %123, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  br label %forin.exit52

if_else:                                          ; preds = %forin.body50
  %pgocount95 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %124 = add i64 %pgocount95, 1
  store i64 %124, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  br label %ifcont

forin.cond64:                                     ; preds = %forin.incr66, %forin.exit52
  %forin_i_val68 = load i64, ptr %forin_i63, align 8
  %forin_len_val69 = load i64, ptr %forin_len62, align 8
  %forin_cmp70 = icmp slt i64 %forin_i_val68, %forin_len_val69
  br i1 %forin_cmp70, label %forin.body65, label %forin.exit67

forin.body65:                                     ; preds = %forin.cond64
  %125 = call i64 @forge_array_get(ptr %109, i64 %forin_i_val68)
  store i64 %125, ptr %n, align 8
  %pgocount96 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %126 = add i64 %pgocount96, 1
  store i64 %126, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %pgocount97 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %127 = add i64 %pgocount97, 1
  store i64 %127, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %pgocount98 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %128 = add i64 %pgocount98, 1
  store i64 %128, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %pgocount99 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %129 = add i64 %pgocount99, 1
  store i64 %129, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %pgocount100 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %130 = add i64 %pgocount100, 1
  store i64 %130, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %pgocount101 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %131 = add i64 %pgocount101, 1
  store i64 %131, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %n71 = load i64, ptr %n, align 8
  %pgocount102 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %132 = add i64 %pgocount102, 1
  store i64 %132, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  call void @forge_div_by_zero_trap(i64 0, ptr @dz_file, i64 143, i64 40)
  %mod = srem i64 %n71, 2
  %pgocount103 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %133 = add i64 %pgocount103, 1
  store i64 %133, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %eq72 = icmp eq i64 %mod, 0
  %eq_ext73 = zext i1 %eq72 to i64
  %if_cond75 = icmp ne i64 %eq_ext73, 0
  br i1 %if_cond75, label %if_then76, label %if_else77

forin.incr66:                                     ; preds = %if_then76, %ifcont74
  %forin_i_old80 = load i64, ptr %forin_i63, align 8
  %forin_next81 = add i64 %forin_i_old80, 1
  store i64 %forin_next81, ptr %forin_i63, align 8
  br label %forin.cond64

forin.exit67:                                     ; preds = %forin.cond64
  %pgocount104 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %134 = add i64 %pgocount104, 1
  store i64 %134, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %pgocount105 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %135 = add i64 %pgocount105, 1
  store i64 %135, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %pgocount106 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %136 = add i64 %pgocount106, 1
  store i64 %136, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %pgocount107 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %137 = add i64 %pgocount107, 1
  store i64 %137, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %odd_sum82 = load i64, ptr @odd_sum, align 8
  %138 = call ptr @forge_rc_alloc(i64 32)
  %139 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %138, i64 32, ptr @.i2s_fmt.5, i64 %odd_sum82)
  %widen83 = sext i32 %139 to i64
  %140 = call i32 @puts(ptr %138)
  %widen84 = sext i32 %140 to i64
  %pgocount108 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %141 = add i64 %pgocount108, 1
  store i64 %141, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  store i64 0, ptr @count, align 8
  %pgocount109 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %142 = add i64 %pgocount109, 1
  store i64 %142, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %pgocount110 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %143 = add i64 %pgocount110, 1
  store i64 %143, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %pgocount111 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %144 = add i64 %pgocount111, 1
  store i64 %144, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %145 = call ptr @forge_array_new()
  %146 = call i64 @forge_array_len(ptr %145)
  store i64 %146, ptr %forin_len85, align 8
  store i64 0, ptr %forin_i86, align 8
  br label %forin.cond88

ifcont74:                                         ; preds = %if_else77
  %pgocount112 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %147 = add i64 %pgocount112, 1
  store i64 %147, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %pgocount113 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %148 = add i64 %pgocount113, 1
  store i64 %148, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %pgocount114 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %149 = add i64 %pgocount114, 1
  store i64 %149, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %pgocount115 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %150 = add i64 %pgocount115, 1
  store i64 %150, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %odd_sum = load i64, ptr @odd_sum, align 8
  %pgocount116 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %151 = add i64 %pgocount116, 1
  store i64 %151, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %n78 = load i64, ptr %n, align 8
  %add79 = add i64 %odd_sum, %n78
  store i64 %add79, ptr @odd_sum, align 8
  br label %forin.incr66

if_then76:                                        ; preds = %forin.body65
  %pgocount117 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %152 = add i64 %pgocount117, 1
  store i64 %152, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %pgocount118 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %153 = add i64 %pgocount118, 1
  store i64 %153, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %pgocount119 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %154 = add i64 %pgocount119, 1
  store i64 %154, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  br label %forin.incr66

if_else77:                                        ; preds = %forin.body65
  %pgocount120 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %155 = add i64 %pgocount120, 1
  store i64 %155, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  br label %ifcont74

forin.cond88:                                     ; preds = %forin.incr90, %forin.exit67
  %forin_i_val92 = load i64, ptr %forin_i86, align 8
  %forin_len_val93 = load i64, ptr %forin_len85, align 8
  %forin_cmp94 = icmp slt i64 %forin_i_val92, %forin_len_val93
  br i1 %forin_cmp94, label %forin.body89, label %forin.exit91

forin.body89:                                     ; preds = %forin.cond88
  %156 = call i64 @forge_array_get(ptr %145, i64 %forin_i_val92)
  store i64 %156, ptr %x87, align 8
  %pgocount121 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %157 = add i64 %pgocount121, 1
  store i64 %157, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %pgocount122 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %158 = add i64 %pgocount122, 1
  store i64 %158, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %pgocount123 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %159 = add i64 %pgocount123, 1
  store i64 %159, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %pgocount124 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %160 = add i64 %pgocount124, 1
  store i64 %160, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %pgocount125 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %161 = add i64 %pgocount125, 1
  store i64 %161, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %count = load i64, ptr @count, align 8
  %pgocount126 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %162 = add i64 %pgocount126, 1
  store i64 %162, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %add95 = add i64 %count, 1
  store i64 %add95, ptr @count, align 8
  br label %forin.incr90

forin.incr90:                                     ; preds = %forin.body89
  %forin_i_old96 = load i64, ptr %forin_i86, align 8
  %forin_next97 = add i64 %forin_i_old96, 1
  store i64 %forin_next97, ptr %forin_i86, align 8
  br label %forin.cond88

forin.exit91:                                     ; preds = %forin.cond88
  %pgocount127 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %163 = add i64 %pgocount127, 1
  store i64 %163, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %pgocount128 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %164 = add i64 %pgocount128, 1
  store i64 %164, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %pgocount129 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %165 = add i64 %pgocount129, 1
  store i64 %165, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %pgocount130 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  %166 = add i64 %pgocount130, 1
  store i64 %166, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  %count98 = load i64, ptr @count, align 8
  %167 = call ptr @forge_rc_alloc(i64 32)
  %168 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %167, i64 32, ptr @.i2s_fmt.6, i64 %count98)
  %widen99 = sext i32 %168 to i64
  %169 = call i32 @puts(ptr %167)
  %widen100 = sext i32 %169 to i64
  %pgocount131 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %170 = add i64 %pgocount131, 1
  store i64 %170, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %171 = call ptr @forge_array_new()
  %pgocount132 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %172 = add i64 %pgocount132, 1
  store i64 %172, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  call void @forge_array_push(ptr %171, i64 1)
  %pgocount133 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  %173 = add i64 %pgocount133, 1
  store i64 %173, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  call void @forge_array_push(ptr %171, i64 2)
  %pgocount134 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  %174 = add i64 %pgocount134, 1
  store i64 %174, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  call void @forge_array_push(ptr %171, i64 3)
  %pgocount135 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  %175 = add i64 %pgocount135, 1
  store i64 %175, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  call void @forge_array_push(ptr %171, i64 4)
  %pgocount136 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %176 = add i64 %pgocount136, 1
  store i64 %176, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  call void @forge_array_push(ptr %171, i64 5)
  store ptr %171, ptr @nums, align 8
  %pgocount137 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %177 = add i64 %pgocount137, 1
  store i64 %177, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %pgocount138 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 138), align 8
  %178 = add i64 %pgocount138, 1
  store i64 %178, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 138), align 8
  %nums = load ptr, ptr @nums, align 8
  %179 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %179, i64 -559038737)
  call void @forge_array_push(ptr %179, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast101 = ptrtoint ptr %179 to i64
  %180 = call ptr @forge_array_map(ptr %nums, i64 %cast101)
  store ptr %180, ptr @doubled, align 8
  %pgocount139 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %181 = add i64 %pgocount139, 1
  store i64 %181, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount140 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %182 = add i64 %pgocount140, 1
  store i64 %182, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount141 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %183 = add i64 %pgocount141, 1
  store i64 %183, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %doubled = load ptr, ptr @doubled, align 8
  %184 = call i64 @forge_array_len(ptr %doubled)
  store i64 %184, ptr %forin_len102, align 8
  store i64 0, ptr %forin_i103, align 8
  br label %forin.cond104

forin.cond104:                                    ; preds = %forin.incr106, %forin.exit91
  %forin_i_val108 = load i64, ptr %forin_i103, align 8
  %forin_len_val109 = load i64, ptr %forin_len102, align 8
  %forin_cmp110 = icmp slt i64 %forin_i_val108, %forin_len_val109
  br i1 %forin_cmp110, label %forin.body105, label %forin.exit107

forin.body105:                                    ; preds = %forin.cond104
  %185 = call i64 @forge_array_get(ptr %doubled, i64 %forin_i_val108)
  store i64 %185, ptr %d, align 8
  %pgocount142 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %186 = add i64 %pgocount142, 1
  store i64 %186, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount143 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %187 = add i64 %pgocount143, 1
  store i64 %187, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount144 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %188 = add i64 %pgocount144, 1
  store i64 %188, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount145 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %189 = add i64 %pgocount145, 1
  store i64 %189, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount146 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %190 = add i64 %pgocount146, 1
  store i64 %190, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %d111 = load i64, ptr %d, align 8
  %191 = call ptr @forge_rc_alloc(i64 32)
  %192 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %191, i64 32, ptr @.i2s_fmt.7, i64 %d111)
  %widen112 = sext i32 %192 to i64
  %193 = call i32 @puts(ptr %191)
  %widen113 = sext i32 %193 to i64
  br label %forin.incr106

forin.incr106:                                    ; preds = %forin.body105
  %forin_i_old114 = load i64, ptr %forin_i103, align 8
  %forin_next115 = add i64 %forin_i_old114, 1
  store i64 %forin_next115, ptr %forin_i103, align 8
  br label %forin.cond104

forin.exit107:                                    ; preds = %forin.cond104
  %194 = call i32 @forge_test_summary()
  %widen116 = sext i32 %194 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
