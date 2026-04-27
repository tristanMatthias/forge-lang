; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/fn_types.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Handler = type { ptr, ptr }

@negate = global ptr null
@add10 = global i64 0
@inc = global i64 0
@dbl = global i64 0
@h = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [3 x i8] c"sq\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_apply = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_apply = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 1068639213276341325, i64 210706734667, i64 sub (i64 ptrtoint (ptr @__profc_apply to i64), i64 ptrtoint (ptr @__profd_apply to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_make_adder = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_make_adder = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -8192261543971856000, i64 8246626487592048450, i64 sub (i64 ptrtoint (ptr @__profc_make_adder to i64), i64 ptrtoint (ptr @__profd_make_adder to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_compose = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_compose = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -6838486859405610221, i64 229462174431899, i64 sub (i64 ptrtoint (ptr @__profc_compose to i64), i64 ptrtoint (ptr @__profd_compose to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [10 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 10, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_1 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_1 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6925786121186820513, i64 8245973951994833620, i64 sub (i64 ptrtoint (ptr @__profc___lambda_1 to i64), i64 ptrtoint (ptr @__profd___lambda_1 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_2 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_2 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6511828798704078813, i64 8245973951994833621, i64 sub (i64 ptrtoint (ptr @__profc___lambda_2 to i64), i64 ptrtoint (ptr @__profd___lambda_2 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_3 = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_3 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 2645571496225459039, i64 8245973951994833622, i64 sub (i64 ptrtoint (ptr @__profc___lambda_3 to i64), i64 ptrtoint (ptr @__profd___lambda_3 to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_4 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_4 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 4544136157594864824, i64 8245973951994833623, i64 sub (i64 ptrtoint (ptr @__profc___lambda_4 to i64), i64 ptrtoint (ptr @__profd___lambda_4 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_5 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_5 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 7378821250420521822, i64 8245973951994833624, i64 sub (i64 ptrtoint (ptr @__profc___lambda_5 to i64), i64 ptrtoint (ptr @__profd___lambda_5 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_6 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_6 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3394955607586402558, i64 8245973951994833625, i64 sub (i64 ptrtoint (ptr @__profc___lambda_6 to i64), i64 ptrtoint (ptr @__profd___lambda_6 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [65 x i8] c"j?x\DAK,(\C8\A9d\CCM\CCN\8DOLII-bL\CE\CF-\C8/N\05\0Ae\E61\C6\C7\E7$\E6&\A5$\C6\1B \98\86\08\A6\11\82i\8C`\9A \98\A6\08\A6\19\00\C8J$\A0", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [12 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_apply, ptr @__profd_make_adder, ptr @__profd_compose, ptr @__profd_main, ptr @__profd___lambda_0, ptr @__profd___lambda_1, ptr @__profd___lambda_2, ptr @__profd___lambda_3, ptr @__profd___lambda_4, ptr @__profd___lambda_5, ptr @__profd___lambda_6], section "llvm.metadata"
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

define i64 @apply(ptr %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %f = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_apply, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_apply, align 8
  store ptr %0, ptr %f, align 8
  store i64 %1, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 2), align 8
  %f1 = load i64, ptr %f, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 3), align 8
  %x2 = load i64, ptr %x, align 8
  %6 = call i64 @forge_closure_call_1(i64 %f1, i64 %x2)
  ret i64 %6
}

define ptr @make_adder(i64 %0) {
entry:
  %n = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_make_adder, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_make_adder, align 8
  store i64 %0, ptr %n, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_make_adder, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc_make_adder, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_make_adder, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_make_adder, i32 0, i32 2), align 8
  %4 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %4, i64 -559038737)
  call void @forge_array_push(ptr %4, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %n, align 8
  call void @forge_array_push(ptr %4, i64 %cap_val)
  %cast = ptrtoint ptr %4 to i64
  %cast1 = inttoptr i64 %cast to ptr
  ret ptr %cast1
}

define ptr @compose(ptr %0, ptr %1) {
entry:
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_compose, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_compose, align 8
  store ptr %0, ptr %f, align 8
  store ptr %1, ptr %g, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_compose, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_compose, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_compose, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_compose, i32 0, i32 2), align 8
  %5 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %5, i64 -559038737)
  call void @forge_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %g, align 8
  call void @forge_array_push(ptr %5, i64 %cap_val)
  %cap_val1 = load i64, ptr %f, align 8
  call void @forge_array_push(ptr %5, i64 %cap_val1)
  %cast = ptrtoint ptr %5 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %4 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %4, i64 -559038737)
  call void @forge_array_push(ptr %4, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast = ptrtoint ptr %4 to i64
  %pgocount4 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %cast1 = inttoptr i64 %cast to ptr
  %6 = call i64 @apply(ptr %cast1, i64 7)
  %7 = call ptr @forge_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt, i64 %6)
  %widen = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen2 = sext i32 %9 to i64
  %pgocount5 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %10 = add i64 %pgocount5, 1
  store i64 %10, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %11 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %11, i64 -559038737)
  call void @forge_array_push(ptr %11, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast3 = ptrtoint ptr %11 to i64
  store i64 %cast3, ptr @negate, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %12 = add i64 %pgocount6, 1
  store i64 %12, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %13 = add i64 %pgocount7, 1
  store i64 %13, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %14 = add i64 %pgocount8, 1
  store i64 %14, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %15 = add i64 %pgocount9, 1
  store i64 %15, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %negate = load i64, ptr @negate, align 8
  %cast4 = inttoptr i64 %negate to ptr
  %16 = call i64 @forge_array_get(ptr %cast4, i64 1)
  %fn_ptr = inttoptr i64 %16 to ptr
  %pgocount10 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %17 = add i64 %pgocount10, 1
  store i64 %17, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %closure_call = call i64 %fn_ptr(i64 42)
  %18 = call ptr @forge_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.1, i64 %closure_call)
  %widen5 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen6 = sext i32 %20 to i64
  %pgocount11 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %21 = add i64 %pgocount11, 1
  store i64 %21, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %22 = add i64 %pgocount12, 1
  store i64 %22, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %23 = call ptr @make_adder(i64 10)
  store ptr %23, ptr @add10, align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %24 = add i64 %pgocount13, 1
  store i64 %24, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %25 = add i64 %pgocount14, 1
  store i64 %25, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %26 = add i64 %pgocount15, 1
  store i64 %26, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %27 = add i64 %pgocount16, 1
  store i64 %27, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %add10 = load i64, ptr @add10, align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %28 = add i64 %pgocount17, 1
  store i64 %28, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %29 = call i64 @forge_closure_call_1(i64 %add10, i64 5)
  %30 = call ptr @forge_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.2, i64 %29)
  %widen7 = sext i32 %31 to i64
  %32 = call i32 @puts(ptr %30)
  %widen8 = sext i32 %32 to i64
  %pgocount18 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %33 = add i64 %pgocount18, 1
  store i64 %33, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %34 = add i64 %pgocount19, 1
  store i64 %34, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %35 = add i64 %pgocount20, 1
  store i64 %35, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %36 = add i64 %pgocount21, 1
  store i64 %36, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %add109 = load i64, ptr @add10, align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %37 = add i64 %pgocount22, 1
  store i64 %37, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %38 = call i64 @forge_closure_call_1(i64 %add109, i64 20)
  %39 = call ptr @forge_rc_alloc(i64 32)
  %40 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %39, i64 32, ptr @.i2s_fmt.3, i64 %38)
  %widen10 = sext i32 %40 to i64
  %41 = call i32 @puts(ptr %39)
  %widen11 = sext i32 %41 to i64
  %pgocount23 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %42 = add i64 %pgocount23, 1
  store i64 %42, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %43 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %43, i64 -559038737)
  call void @forge_array_push(ptr %43, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast12 = ptrtoint ptr %43 to i64
  store i64 %cast12, ptr @inc, align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %44 = add i64 %pgocount24, 1
  store i64 %44, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %45 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %45, i64 -559038737)
  call void @forge_array_push(ptr %45, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast13 = ptrtoint ptr %45 to i64
  store i64 %cast13, ptr @dbl, align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %46 = add i64 %pgocount25, 1
  store i64 %46, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %47 = add i64 %pgocount26, 1
  store i64 %47, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %48 = add i64 %pgocount27, 1
  store i64 %48, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %49 = add i64 %pgocount28, 1
  store i64 %49, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %50 = add i64 %pgocount29, 1
  store i64 %50, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %51 = add i64 %pgocount30, 1
  store i64 %51, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %dbl = load ptr, ptr @dbl, align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %52 = add i64 %pgocount31, 1
  store i64 %52, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %inc = load ptr, ptr @inc, align 8
  %53 = call ptr @compose(ptr %dbl, ptr %inc)
  %pgocount32 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %54 = add i64 %pgocount32, 1
  store i64 %54, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %cast14 = ptrtoint ptr %53 to i64
  %55 = call i64 @forge_closure_call_1(i64 %cast14, i64 5)
  %56 = call ptr @forge_rc_alloc(i64 32)
  %57 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %56, i64 32, ptr @.i2s_fmt.4, i64 %55)
  %widen15 = sext i32 %57 to i64
  %58 = call i32 @puts(ptr %56)
  %widen16 = sext i32 %58 to i64
  %pgocount33 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %59 = add i64 %pgocount33, 1
  store i64 %59, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %60 = add i64 %pgocount34, 1
  store i64 %60, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %61 = call ptr @forge_rc_alloc(i64 16)
  %pgocount35 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %62 = add i64 %pgocount35, 1
  store i64 %62, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %fld_ptr = getelementptr inbounds nuw %Handler, ptr %61, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %63 = add i64 %pgocount36, 1
  store i64 %63, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %64 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %64, i64 -559038737)
  call void @forge_array_push(ptr %64, i64 ptrtoint (ptr @__lambda_6 to i64))
  %cast17 = ptrtoint ptr %64 to i64
  %fld_ptr18 = getelementptr inbounds nuw %Handler, ptr %61, i32 0, i32 1
  %cast19 = inttoptr i64 %cast17 to ptr
  store ptr %cast19, ptr %fld_ptr18, align 8
  %cast20 = ptrtoint ptr %61 to i64
  store i64 %cast20, ptr @h, align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %65 = add i64 %pgocount37, 1
  store i64 %65, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %66 = add i64 %pgocount38, 1
  store i64 %66, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %67 = add i64 %pgocount39, 1
  store i64 %67, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %68 = add i64 %pgocount40, 1
  store i64 %68, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %69 = add i64 %pgocount41, 1
  store i64 %69, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %h = load ptr, ptr @h, align 8
  %fn_field_ptr = getelementptr inbounds nuw %Handler, ptr %h, i32 0, i32 1
  %fn_field_val = load i64, ptr %fn_field_ptr, align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %70 = add i64 %pgocount42, 1
  store i64 %70, ptr getelementptr inbounds ([10 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %71 = call i64 @forge_closure_call_1(i64 %fn_field_val, i64 7)
  %72 = call ptr @forge_rc_alloc(i64 32)
  %73 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %72, i64 32, ptr @.i2s_fmt.5, i64 %71)
  %widen21 = sext i32 %73 to i64
  %74 = call i32 @puts(ptr %72)
  %widen22 = sext i32 %74 to i64
  %75 = call i32 @forge_test_summary()
  %widen23 = sext i32 %75 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_Handler(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Handler, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %rel_action_skip, %alive
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_action_ptr = getelementptr inbounds nuw %Handler, ptr %0, i32 0, i32 1
  %rel_action = load ptr, ptr %rel_action_ptr, align 8
  %is_null_action = icmp eq ptr %rel_action, null
  br i1 %is_null_action, label %rel_action_skip, label %rel_action_do

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_action_skip:                                  ; preds = %rel_action_do, %rel_name_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_action_do:                                    ; preds = %rel_name_skip
  call void @forge_rc_release(ptr %rel_action)
  br label %rel_action_skip
}

define i64 @__lambda_0(i64 %0, i64 %1) {
entry:
  %n = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %n, align 8
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %n2 = load i64, ptr %n, align 8
  %add = add i64 %x1, %n2
  ret i64 %add
}

define i64 @__lambda_1(i64 %0, i64 %1, i64 %2) {
entry:
  %f = alloca ptr, align 8
  %g = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %cast = inttoptr i64 %1 to ptr
  store ptr %cast, ptr %g, align 8
  %cast1 = inttoptr i64 %2 to ptr
  store ptr %cast1, ptr %f, align 8
  %pgocount = load i64, ptr @__profc___lambda_1, align 8
  %3 = add i64 %pgocount, 1
  store i64 %3, ptr @__profc___lambda_1, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %4 = add i64 %pgocount1, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %f2 = load i64, ptr %f, align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %5 = add i64 %pgocount2, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %g3 = load i64, ptr %g, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %6 = add i64 %pgocount3, 1
  store i64 %6, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %x4 = load i64, ptr %x, align 8
  %7 = call i64 @forge_closure_call_1(i64 %g3, i64 %x4)
  %8 = call i64 @forge_closure_call_1(i64 %f2, i64 %7)
  ret i64 %8
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_2, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_2, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 3), align 8
  %mul = mul i64 %x1, 3
  ret i64 %mul
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_3, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_3, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_3, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_3, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_3, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_3, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %neg = sub i64 0, %x1
  ret i64 %neg
}

define i64 @__lambda_4(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_4, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_4, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 3), align 8
  %add = add i64 %x1, 1
  ret i64 %add
}

define i64 @__lambda_5(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_5, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_5, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 3), align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_6(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_6, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_6, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_6, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_6, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_6, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_6, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_6, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_6, i32 0, i32 3), align 8
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, %x2
  ret i64 %mul
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
