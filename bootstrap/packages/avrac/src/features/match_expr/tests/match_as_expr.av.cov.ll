; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_as_expr.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Dir = type { i64, ptr }

@d = global i64 0
@val = global i64 0
@label = global i64 0
@score = global i64 0
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_as_expr.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"north\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"south\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"east\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"west\00", align 1
@.match_fn.4 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.5 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_as_expr.fg\00", align 1
@.match_fn.6 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.7 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_as_expr.fg\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_double = private global [5 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_double = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 2767365732084600296, i64 6953438632736, i64 sub (i64 ptrtoint (ptr @__profc_double to i64), i64 ptrtoint (ptr @__profd_double to i64)), i64 0, ptr null, ptr null, i32 5, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [51 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 51, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [21 x i8] c"\0B\13x\DAK\C9/M\CAIe\CCM\CC\CC\03\00\19H\04\22", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_double, ptr @__profd_main], section "llvm.metadata"
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

define i64 @double(i64 %0) {
entry:
  %n = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_double, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_double, align 8
  store i64 %0, ptr %n, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_double, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([5 x i64], ptr @__profc_double, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_double, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([5 x i64], ptr @__profc_double, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_double, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([5 x i64], ptr @__profc_double, i32 0, i32 3), align 8
  %n1 = load i64, ptr %n, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_double, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([5 x i64], ptr @__profc_double, i32 0, i32 4), align 8
  %mul = mul i64 %n1, 2
  ret i64 %mul
}

define i64 @main() {
entry:
  %match_result34 = alloca i64, align 8
  %match_result15 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %pgocount = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Dir, ptr %2, i32 0, i32 0
  store i64 177642, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Dir, ptr %2, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr @d, align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %d = load ptr, ptr @d, align 8
  %tag_ptr1 = getelementptr inbounds nuw %Dir, ptr %d, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr1, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 177651
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm8, %march_arm5, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %6 = call i64 @double(i64 %match_val)
  store i64 %6, ptr @val, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %val = load i64, ptr @val, align 8
  %11 = call ptr @forge_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt, i64 %val)
  %widen = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen11 = sext i32 %13 to i64
  %pgocount9 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %14 = add i64 %pgocount9, 1
  store i64 %14, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %15 = add i64 %pgocount10, 1
  store i64 %15, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %d12 = load ptr, ptr @d, align 8
  %tag_ptr13 = getelementptr inbounds nuw %Dir, ptr %d12, i32 0, i32 0
  %tag14 = load i64, ptr %tag_ptr13, align 8
  store i64 0, ptr %match_result15, align 8
  %tag_eq19 = icmp eq i64 %tag14, 177651
  br i1 %tag_eq19, label %march_arm17, label %march_next18

march_arm:                                        ; preds = %entry
  %pgocount11 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %16 = add i64 %pgocount11, 1
  store i64 %16, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %17 = add i64 %pgocount12, 1
  store i64 %17, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  store i64 1, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 177656
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pgocount13 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %19 = add i64 %pgocount14, 1
  store i64 %19, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  store i64 2, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq7 = icmp eq i64 %tag, 177642
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next3
  %pgocount15 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %20 = add i64 %pgocount15, 1
  store i64 %20, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %21 = add i64 %pgocount16, 1
  store i64 %21, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  store i64 3, ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next3
  %tag_eq10 = icmp eq i64 %tag, 177660
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_arm8:                                       ; preds = %march_next6
  %pgocount17 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %22 = add i64 %pgocount17, 1
  store i64 %22, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %23 = add i64 %pgocount18, 1
  store i64 %23, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  store i64 4, ptr %match_result, align 8
  br label %match_end

march_next9:                                      ; preds = %march_next6
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 7)
  unreachable

match_end16:                                      ; preds = %march_arm26, %march_arm23, %march_arm20, %march_arm17
  %match_val29 = load i64, ptr %match_result15, align 8
  store i64 %match_val29, ptr @label, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %24 = add i64 %pgocount19, 1
  store i64 %24, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %25 = add i64 %pgocount20, 1
  store i64 %25, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %26 = add i64 %pgocount21, 1
  store i64 %26, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %label = load ptr, ptr @label, align 8
  %27 = call i32 @puts(ptr %label)
  %widen30 = sext i32 %27 to i64
  %pgocount22 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %28 = add i64 %pgocount22, 1
  store i64 %28, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %29 = add i64 %pgocount23, 1
  store i64 %29, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %30 = add i64 %pgocount24, 1
  store i64 %30, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %31 = add i64 %pgocount25, 1
  store i64 %31, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %d31 = load ptr, ptr @d, align 8
  %tag_ptr32 = getelementptr inbounds nuw %Dir, ptr %d31, i32 0, i32 0
  %tag33 = load i64, ptr %tag_ptr32, align 8
  store i64 0, ptr %match_result34, align 8
  %tag_eq38 = icmp eq i64 %tag33, 177651
  br i1 %tag_eq38, label %march_arm36, label %march_next37

march_arm17:                                      ; preds = %match_end
  %pgocount26 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %32 = add i64 %pgocount26, 1
  store i64 %32, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %33 = add i64 %pgocount27, 1
  store i64 %33, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result15, align 8
  br label %match_end16

march_next18:                                     ; preds = %match_end
  %tag_eq22 = icmp eq i64 %tag14, 177656
  br i1 %tag_eq22, label %march_arm20, label %march_next21

march_arm20:                                      ; preds = %march_next18
  %pgocount28 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %34 = add i64 %pgocount28, 1
  store i64 %34, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %35 = add i64 %pgocount29, 1
  store i64 %35, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result15, align 8
  br label %match_end16

march_next21:                                     ; preds = %march_next18
  %tag_eq25 = icmp eq i64 %tag14, 177642
  br i1 %tag_eq25, label %march_arm23, label %march_next24

march_arm23:                                      ; preds = %march_next21
  %pgocount30 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %36 = add i64 %pgocount30, 1
  store i64 %36, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %37 = add i64 %pgocount31, 1
  store i64 %37, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result15, align 8
  br label %match_end16

march_next24:                                     ; preds = %march_next21
  %tag_eq28 = icmp eq i64 %tag14, 177660
  br i1 %tag_eq28, label %march_arm26, label %march_next27

march_arm26:                                      ; preds = %march_next24
  %pgocount32 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %38 = add i64 %pgocount32, 1
  store i64 %38, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %39 = add i64 %pgocount33, 1
  store i64 %39, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result15, align 8
  br label %match_end16

march_next27:                                     ; preds = %march_next24
  call void @forge_match_unreachable(ptr @.match_fn.4, i64 %tag14, ptr @mu_file.5, i64 11)
  unreachable

match_end35:                                      ; preds = %march_arm45, %march_arm42, %march_arm39, %march_arm36
  %match_val48 = load i64, ptr %match_result34, align 8
  %add = add i64 100, %match_val48
  store i64 %add, ptr @score, align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %40 = add i64 %pgocount34, 1
  store i64 %40, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %41 = add i64 %pgocount35, 1
  store i64 %41, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %42 = add i64 %pgocount36, 1
  store i64 %42, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %43 = add i64 %pgocount37, 1
  store i64 %43, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %score = load i64, ptr @score, align 8
  %44 = call ptr @forge_rc_alloc(i64 32)
  %45 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %44, i64 32, ptr @.i2s_fmt.8, i64 %score)
  %widen49 = sext i32 %45 to i64
  %46 = call i32 @puts(ptr %44)
  %widen50 = sext i32 %46 to i64
  %47 = call i32 @forge_test_summary()
  %widen51 = sext i32 %47 to i64
  call void @forge_rc_collect()
  ret i64 0

march_arm36:                                      ; preds = %match_end16
  %pgocount38 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %48 = add i64 %pgocount38, 1
  store i64 %48, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %49 = add i64 %pgocount39, 1
  store i64 %49, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  store i64 1, ptr %match_result34, align 8
  br label %match_end35

march_next37:                                     ; preds = %match_end16
  %tag_eq41 = icmp eq i64 %tag33, 177656
  br i1 %tag_eq41, label %march_arm39, label %march_next40

march_arm39:                                      ; preds = %march_next37
  %pgocount40 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %50 = add i64 %pgocount40, 1
  store i64 %50, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %51 = add i64 %pgocount41, 1
  store i64 %51, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  store i64 2, ptr %match_result34, align 8
  br label %match_end35

march_next40:                                     ; preds = %march_next37
  %tag_eq44 = icmp eq i64 %tag33, 177642
  br i1 %tag_eq44, label %march_arm42, label %march_next43

march_arm42:                                      ; preds = %march_next40
  %pgocount42 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %52 = add i64 %pgocount42, 1
  store i64 %52, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %53 = add i64 %pgocount43, 1
  store i64 %53, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  store i64 3, ptr %match_result34, align 8
  br label %match_end35

march_next43:                                     ; preds = %march_next40
  %tag_eq47 = icmp eq i64 %tag33, 177660
  br i1 %tag_eq47, label %march_arm45, label %march_next46

march_arm45:                                      ; preds = %march_next43
  %pgocount44 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %54 = add i64 %pgocount44, 1
  store i64 %54, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %55 = add i64 %pgocount45, 1
  store i64 %55, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  store i64 4, ptr %match_result34, align 8
  br label %match_end35

march_next46:                                     ; preds = %march_next43
  call void @forge_match_unreachable(ptr @.match_fn.6, i64 %tag33, ptr @mu_file.7, i64 20)
  unreachable
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
