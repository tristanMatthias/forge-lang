; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/for_stmt/tests/for_break_continue.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@sum = global i64 0
@found = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [85 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 85, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [14 x i8] c"\04\0Cx\DA\CBM\CC\CC\03\00\04\1B\01\A6", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [2 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_main], section "llvm.metadata"
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
  %for_end26 = alloca i64, align 8
  %j = alloca i64, align 8
  %for_end18 = alloca i64, align 8
  %i17 = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  store i64 0, ptr @sum, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  store i64 0, ptr %i, align 8
  store i64 10, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %pgocount5 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %6 = add i64 %pgocount6, 1
  store i64 %6, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %7 = add i64 %pgocount7, 1
  store i64 %7, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %8 = add i64 %pgocount8, 1
  store i64 %8, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %9 = add i64 %pgocount9, 1
  store i64 %9, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %i2 = load i64, ptr %i, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %10 = add i64 %pgocount10, 1
  store i64 %10, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %eq = icmp eq i64 %i2, 7
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

for.incr:                                         ; preds = %if_then11, %ifcont9
  %i14 = load i64, ptr %i, align 8
  %for_next = add i64 %i14, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %if_then, %for.cond
  %pgocount11 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %11 = add i64 %pgocount11, 1
  store i64 %11, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %12 = add i64 %pgocount12, 1
  store i64 %12, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %13 = add i64 %pgocount13, 1
  store i64 %13, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %14 = add i64 %pgocount14, 1
  store i64 %14, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %sum15 = load i64, ptr @sum, align 8
  %15 = call ptr @forge_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt, i64 %sum15)
  %widen = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen16 = sext i32 %17 to i64
  %pgocount15 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %18 = add i64 %pgocount15, 1
  store i64 %18, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  store i64 0, ptr @found, align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %19 = add i64 %pgocount16, 1
  store i64 %19, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %20 = add i64 %pgocount17, 1
  store i64 %20, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %21 = add i64 %pgocount18, 1
  store i64 %21, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %22 = add i64 %pgocount19, 1
  store i64 %22, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  store i64 0, ptr %i17, align 8
  store i64 5, ptr %for_end18, align 8
  br label %for.cond19

ifcont:                                           ; preds = %if_else
  %pgocount20 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %23 = add i64 %pgocount20, 1
  store i64 %23, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %24 = add i64 %pgocount21, 1
  store i64 %24, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %25 = add i64 %pgocount22, 1
  store i64 %25, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %26 = add i64 %pgocount23, 1
  store i64 %26, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %27 = add i64 %pgocount24, 1
  store i64 %27, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %i3 = load i64, ptr %i, align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %28 = add i64 %pgocount25, 1
  store i64 %28, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %eq4 = icmp eq i64 %i3, 3
  %eq_ext5 = zext i1 %eq4 to i64
  %l_bool = icmp ne i64 %eq_ext5, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

if_then:                                          ; preds = %for.body
  %pgocount26 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %29 = add i64 %pgocount26, 1
  store i64 %29, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %30 = add i64 %pgocount27, 1
  store i64 %30, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %31 = add i64 %pgocount28, 1
  store i64 %31, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  br label %for.exit

if_else:                                          ; preds = %for.body
  %pgocount29 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %32 = add i64 %pgocount29, 1
  store i64 %32, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  br label %ifcont

sc_rhs:                                           ; preds = %ifcont
  %pgocount30 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %33 = add i64 %pgocount30, 1
  store i64 %33, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %34 = add i64 %pgocount31, 1
  store i64 %34, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %35 = add i64 %pgocount32, 1
  store i64 %35, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %i6 = load i64, ptr %i, align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %36 = add i64 %pgocount33, 1
  store i64 %36, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %eq7 = icmp eq i64 %i6, 5
  %eq_ext8 = zext i1 %eq7 to i64
  %r_bool = icmp ne i64 %eq_ext8, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %ifcont
  %pgocount34 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %37 = add i64 %pgocount34, 1
  store i64 %37, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ true, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond10 = icmp ne i64 %sc_ext, 0
  br i1 %if_cond10, label %if_then11, label %if_else12

sc_r_true:                                        ; preds = %sc_rhs
  %pgocount35 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %38 = add i64 %pgocount35, 1
  store i64 %38, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  %pgocount36 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %39 = add i64 %pgocount36, 1
  store i64 %39, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont9:                                          ; preds = %if_else12
  %pgocount37 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %40 = add i64 %pgocount37, 1
  store i64 %40, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %41 = add i64 %pgocount38, 1
  store i64 %41, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %42 = add i64 %pgocount39, 1
  store i64 %42, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %43 = add i64 %pgocount40, 1
  store i64 %43, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %sum = load i64, ptr @sum, align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %44 = add i64 %pgocount41, 1
  store i64 %44, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %i13 = load i64, ptr %i, align 8
  %add = add i64 %sum, %i13
  store i64 %add, ptr @sum, align 8
  br label %for.incr

if_then11:                                        ; preds = %sc_merge
  %pgocount42 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %45 = add i64 %pgocount42, 1
  store i64 %45, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %46 = add i64 %pgocount43, 1
  store i64 %46, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %47 = add i64 %pgocount44, 1
  store i64 %47, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  br label %for.incr

if_else12:                                        ; preds = %sc_merge
  %pgocount45 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %48 = add i64 %pgocount45, 1
  store i64 %48, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  br label %ifcont9

for.cond19:                                       ; preds = %for.incr21, %for.exit
  %i23 = load i64, ptr %i17, align 8
  %for_end_val24 = load i64, ptr %for_end18, align 8
  %for_cmp25 = icmp slt i64 %i23, %for_end_val24
  br i1 %for_cmp25, label %for.body20, label %for.exit22

for.body20:                                       ; preds = %for.cond19
  %pgocount46 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %49 = add i64 %pgocount46, 1
  store i64 %49, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %50 = add i64 %pgocount47, 1
  store i64 %50, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %51 = add i64 %pgocount48, 1
  store i64 %51, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %52 = add i64 %pgocount49, 1
  store i64 %52, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %53 = add i64 %pgocount50, 1
  store i64 %53, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  store i64 0, ptr %j, align 8
  store i64 5, ptr %for_end26, align 8
  br label %for.cond27

for.incr21:                                       ; preds = %ifcont49
  %i53 = load i64, ptr %i17, align 8
  %for_next54 = add i64 %i53, 1
  store i64 %for_next54, ptr %i17, align 8
  br label %for.cond19

for.exit22:                                       ; preds = %if_then51, %for.cond19
  %pgocount51 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %54 = add i64 %pgocount51, 1
  store i64 %54, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %55 = add i64 %pgocount52, 1
  store i64 %55, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %pgocount53 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %56 = add i64 %pgocount53, 1
  store i64 %56, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %57 = add i64 %pgocount54, 1
  store i64 %57, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %found55 = load i64, ptr @found, align 8
  %58 = call ptr @forge_rc_alloc(i64 32)
  %59 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %58, i64 32, ptr @.i2s_fmt.1, i64 %found55)
  %widen56 = sext i32 %59 to i64
  %60 = call i32 @puts(ptr %58)
  %widen57 = sext i32 %60 to i64
  %61 = call i32 @forge_test_summary()
  %widen58 = sext i32 %61 to i64
  call void @forge_rc_collect()
  ret i64 0

for.cond27:                                       ; preds = %for.incr29, %for.body20
  %j31 = load i64, ptr %j, align 8
  %for_end_val32 = load i64, ptr %for_end26, align 8
  %for_cmp33 = icmp slt i64 %j31, %for_end_val32
  br i1 %for_cmp33, label %for.body28, label %for.exit30

for.body28:                                       ; preds = %for.cond27
  %pgocount55 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %62 = add i64 %pgocount55, 1
  store i64 %62, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %63 = add i64 %pgocount56, 1
  store i64 %63, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %64 = add i64 %pgocount57, 1
  store i64 %64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount58 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %65 = add i64 %pgocount58, 1
  store i64 %65, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %66 = add i64 %pgocount59, 1
  store i64 %66, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %67 = add i64 %pgocount60, 1
  store i64 %67, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %68 = add i64 %pgocount61, 1
  store i64 %68, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %i34 = load i64, ptr %i17, align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %69 = add i64 %pgocount62, 1
  store i64 %69, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %mul = mul i64 %i34, 5
  %pgocount63 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %70 = add i64 %pgocount63, 1
  store i64 %70, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %j35 = load i64, ptr %j, align 8
  %add36 = add i64 %mul, %j35
  %pgocount64 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %71 = add i64 %pgocount64, 1
  store i64 %71, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %eq37 = icmp eq i64 %add36, 13
  %eq_ext38 = zext i1 %eq37 to i64
  %if_cond40 = icmp ne i64 %eq_ext38, 0
  br i1 %if_cond40, label %if_then41, label %if_else42

for.incr29:                                       ; preds = %ifcont39
  %j47 = load i64, ptr %j, align 8
  %for_next48 = add i64 %j47, 1
  store i64 %for_next48, ptr %j, align 8
  br label %for.cond27

for.exit30:                                       ; preds = %if_then41, %for.cond27
  %pgocount65 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %72 = add i64 %pgocount65, 1
  store i64 %72, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %73 = add i64 %pgocount66, 1
  store i64 %73, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %pgocount67 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %74 = add i64 %pgocount67, 1
  store i64 %74, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %pgocount68 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %75 = add i64 %pgocount68, 1
  store i64 %75, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %found = load i64, ptr @found, align 8
  %pgocount69 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %76 = add i64 %pgocount69, 1
  store i64 %76, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %sgt = icmp sgt i64 %found, 0
  %sgt_ext = zext i1 %sgt to i64
  %if_cond50 = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond50, label %if_then51, label %if_else52

ifcont39:                                         ; preds = %if_else42
  br label %for.incr29

if_then41:                                        ; preds = %for.body28
  %pgocount70 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %77 = add i64 %pgocount70, 1
  store i64 %77, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount71 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %78 = add i64 %pgocount71, 1
  store i64 %78, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %79 = add i64 %pgocount72, 1
  store i64 %79, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %80 = add i64 %pgocount73, 1
  store i64 %80, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %81 = add i64 %pgocount74, 1
  store i64 %81, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount75 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %82 = add i64 %pgocount75, 1
  store i64 %82, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount76 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %83 = add i64 %pgocount76, 1
  store i64 %83, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %i43 = load i64, ptr %i17, align 8
  %pgocount77 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %84 = add i64 %pgocount77, 1
  store i64 %84, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %mul44 = mul i64 %i43, 5
  %pgocount78 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %85 = add i64 %pgocount78, 1
  store i64 %85, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %j45 = load i64, ptr %j, align 8
  %add46 = add i64 %mul44, %j45
  store i64 %add46, ptr @found, align 8
  %pgocount79 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %86 = add i64 %pgocount79, 1
  store i64 %86, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  br label %for.exit30

if_else42:                                        ; preds = %for.body28
  %pgocount80 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %87 = add i64 %pgocount80, 1
  store i64 %87, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  br label %ifcont39

ifcont49:                                         ; preds = %if_else52
  br label %for.incr21

if_then51:                                        ; preds = %for.exit30
  %pgocount81 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %88 = add i64 %pgocount81, 1
  store i64 %88, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %pgocount82 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %89 = add i64 %pgocount82, 1
  store i64 %89, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %pgocount83 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %90 = add i64 %pgocount83, 1
  store i64 %90, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  br label %for.exit22

if_else52:                                        ; preds = %for.exit30
  %pgocount84 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %91 = add i64 %pgocount84, 1
  store i64 %91, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  br label %ifcont49
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
