; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_edge_cases.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Pair__string__int = type { ptr, i64 }

@.str = private unnamed_addr constant [8 x i8] c"value: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"first\00", align 1
@sty_name = private unnamed_addr constant [18 x i8] c"Pair__string__int\00", align 1
@src_file = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_edge_cases.fg\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c" \00", align 1
@fld_name.5 = private unnamed_addr constant [7 x i8] c"second\00", align 1
@sty_name.6 = private unnamed_addr constant [18 x i8] c"Pair__string__int\00", align 1
@src_file.7 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_edge_cases.fg\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c"done\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_identity__ = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_identity__ = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -5406943435190100636, i64 8246444817624777485, i64 sub (i64 ptrtoint (ptr @__profc_identity__ to i64), i64 ptrtoint (ptr @__profd_identity__ to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_double_identity__int = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_double_identity__int = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -1629985724195312407, i64 -7039755372795448846, i64 sub (i64 ptrtoint (ptr @__profc_double_identity__int to i64), i64 ptrtoint (ptr @__profd_double_identity__int to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_inc__int = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_inc__int = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -550809548089597294, i64 7572505763342504, i64 sub (i64 ptrtoint (ptr @__profc_inc__int to i64), i64 ptrtoint (ptr @__profd_inc__int to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_apply__int = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_apply__int = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -1341486478629197545, i64 8246090869055963732, i64 sub (i64 ptrtoint (ptr @__profc_apply__int to i64), i64 ptrtoint (ptr @__profd_apply__int to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_show = private global [7 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_show = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 2701510904323956135, i64 6385690694, i64 sub (i64 ptrtoint (ptr @__profc_show to i64), i64 ptrtoint (ptr @__profd_show to i64)), i64 0, ptr null, ptr null, i32 7, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_print_all = private global [10 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_print_all = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -5058325614024230843, i64 249902713884771594, i64 sub (i64 ptrtoint (ptr @__profc_print_all to i64), i64 ptrtoint (ptr @__profd_print_all to i64)), i64 0, ptr null, ptr null, i32 10, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [22 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 22, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [23 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 23, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [79 x i8] c"aMx\DA=\C8A\0A\800\0C\05Qr#o\F4Im\C0@\9A\06\1B\15ooAq\F7f\B4\8A\A7\E6\0DP\EDG1\81\FEG=I}}\C1\11\F6\BD\B1\F5\8Bb\9F\04\9BQcu\02\CA@\F6\80\C9)6\D3\B8\95\CAX\1E\1E\90$\85", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [10 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_identity__, ptr @__profd_double_identity__int, ptr @__profd_inc__int, ptr @__profd_apply__int, ptr @__profd_show, ptr @__profd_print_all, ptr @__profd_main, ptr @__profd___bs_top_level, ptr @__profd___lambda_0], section "llvm.metadata"
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

define i64 @identity__(i64 %0) {
entry:
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_identity__, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_identity__, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_identity__, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc_identity__, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_identity__, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([3 x i64], ptr @__profc_identity__, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  ret i64 %x1
}

define i64 @double_identity__int(i64 %0) {
entry:
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_double_identity__int, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_double_identity__int, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_identity__int, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_identity__int, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_identity__int, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_identity__int, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_identity__int, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_identity__int, i32 0, i32 3), align 8
  %x1 = load i64, ptr %x, align 8
  %5 = call i64 @identity__(i64 %x1)
  ret i64 %5
}

define i64 @inc__int(i64 %0) {
entry:
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_inc__int, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_inc__int, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_inc__int, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc_inc__int, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_inc__int, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([3 x i64], ptr @__profc_inc__int, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  ret i64 %x1
}

define i64 @apply__int(i64 %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_apply__int, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_apply__int, align 8
  store i64 %0, ptr %x, align 8
  store ptr %1, ptr %f, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply__int, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply__int, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply__int, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply__int, i32 0, i32 2), align 8
  %f1 = load i64, ptr %f, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply__int, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply__int, i32 0, i32 3), align 8
  %x2 = load i64, ptr %x, align 8
  %6 = call i64 @forge_closure_call_1(i64 %f1, i64 %x2)
  ret i64 %6
}

define ptr @show(i64 %0) {
entry:
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_show, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_show, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([7 x i64], ptr @__profc_show, i32 0, i32 6), align 8
  %x1 = load i64, ptr %x, align 8
  %8 = call ptr @forge_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt, i64 %x1)
  %widen = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str)
  %11 = call i64 @strlen(ptr %8)
  %concat_total = add i64 %10, %11
  %concat_size = add i64 %concat_total, 1
  %12 = call ptr @forge_rc_alloc(i64 %concat_size)
  %13 = call ptr @memcpy(ptr %12, ptr @.str, i64 %10)
  %cast = ptrtoint ptr %12 to i64
  %dst2_int = add i64 %cast, %10
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast2, ptr %8, i64 %rhs_len_p1)
  ret ptr %12
}

define i64 @print_all(ptr %0) {
entry:
  %item = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %items = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_print_all, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_print_all, align 8
  store ptr %0, ptr %items, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 4), align 8
  %items1 = load ptr, ptr %items, align 8
  %6 = call i64 @forge_array_len(ptr %items1)
  store i64 %6, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %7 = call i64 @forge_array_get(ptr %items1, i64 %forin_i_val)
  store i64 %7, ptr %item, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 5), align 8
  %8 = add i64 %pgocount5, 1
  store i64 %8, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 6), align 8
  %9 = add i64 %pgocount6, 1
  store i64 %9, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 7), align 8
  %10 = add i64 %pgocount7, 1
  store i64 %10, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 8), align 8
  %11 = add i64 %pgocount8, 1
  store i64 %11, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 9), align 8
  %12 = add i64 %pgocount9, 1
  store i64 %12, ptr getelementptr inbounds ([10 x i64], ptr @__profc_print_all, i32 0, i32 9), align 8
  %item2 = load i64, ptr %item, align 8
  %13 = call ptr @forge_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.1, i64 %item2)
  %widen = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen3 = sext i32 %15 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  ret i64 0
}

define i64 @main() {
entry:
  %doubled = alloca i64, align 8
  %piped = alloca i64, align 8
  %p = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = call i64 @double_identity__int(i64 42)
  %7 = call ptr @forge_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.2, i64 %6)
  %widen = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen1 = sext i32 %9 to i64
  %pgocount6 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %12 = call ptr @forge_rc_alloc(i64 16)
  %pgocount8 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %13 = add i64 %pgocount8, 1
  store i64 %13, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %fld_ptr = getelementptr inbounds nuw %Pair__string__int, ptr %12, i32 0, i32 0
  store ptr @.str.3, ptr %fld_ptr, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %14 = add i64 %pgocount9, 1
  store i64 %14, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %fld_ptr2 = getelementptr inbounds nuw %Pair__string__int, ptr %12, i32 0, i32 1
  store i64 10, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %12 to i64
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %p, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %15 = add i64 %pgocount10, 1
  store i64 %15, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %16 = add i64 %pgocount11, 1
  store i64 %16, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %17 = add i64 %pgocount12, 1
  store i64 %17, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %19 = add i64 %pgocount14, 1
  store i64 %19, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %20 = add i64 %pgocount15, 1
  store i64 %20, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %21 = add i64 %pgocount16, 1
  store i64 %21, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %p4 = load ptr, ptr %p, align 8
  %cast5 = ptrtoint ptr %p4 to i64
  %null_chk = icmp eq i64 %cast5, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 17, i64 %null_ext, ptr @src_file, i64 142, i64 42)
  %first_ptr = getelementptr inbounds nuw %Pair__string__int, ptr %p4, i32 0, i32 0
  %first = load ptr, ptr %first_ptr, align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %22 = add i64 %pgocount17, 1
  store i64 %22, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %23 = call i64 @strlen(ptr %first)
  %24 = call i64 @strlen(ptr @.str.4)
  %concat_total = add i64 %23, %24
  %concat_size = add i64 %concat_total, 1
  %25 = call ptr @forge_rc_alloc(i64 %concat_size)
  %26 = call ptr @memcpy(ptr %25, ptr %first, i64 %23)
  %cast6 = ptrtoint ptr %25 to i64
  %dst2_int = add i64 %cast6, %23
  %cast7 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast7, ptr @.str.4, i64 %rhs_len_p1)
  %pgocount18 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %28 = add i64 %pgocount18, 1
  store i64 %28, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %29 = add i64 %pgocount19, 1
  store i64 %29, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %30 = add i64 %pgocount20, 1
  store i64 %30, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %31 = add i64 %pgocount21, 1
  store i64 %31, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %p8 = load ptr, ptr %p, align 8
  %cast9 = ptrtoint ptr %p8 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @forge_null_deref_trap(ptr @fld_name.5, i64 6, ptr @sty_name.6, i64 17, i64 %null_ext11, ptr @src_file.7, i64 142, i64 42)
  %second_ptr = getelementptr inbounds nuw %Pair__string__int, ptr %p8, i32 0, i32 1
  %second = load i64, ptr %second_ptr, align 8
  %32 = call ptr @forge_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.8, i64 %second)
  %widen12 = sext i32 %33 to i64
  %34 = call i64 @strlen(ptr %25)
  %35 = call i64 @strlen(ptr %32)
  %concat_total13 = add i64 %34, %35
  %concat_size14 = add i64 %concat_total13, 1
  %36 = call ptr @forge_rc_alloc(i64 %concat_size14)
  %37 = call ptr @memcpy(ptr %36, ptr %25, i64 %34)
  %cast15 = ptrtoint ptr %36 to i64
  %dst2_int16 = add i64 %cast15, %34
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %35, 1
  %38 = call ptr @memcpy(ptr %cast17, ptr %32, i64 %rhs_len_p118)
  %39 = call i32 @puts(ptr %36)
  %widen19 = sext i32 %39 to i64
  %pgocount22 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %40 = add i64 %pgocount22, 1
  store i64 %40, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %41 = add i64 %pgocount23, 1
  store i64 %41, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %42 = add i64 %pgocount24, 1
  store i64 %42, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %43 = call i64 @inc__int(i64 84)
  store i64 %43, ptr %piped, align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %44 = add i64 %pgocount25, 1
  store i64 %44, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %45 = add i64 %pgocount26, 1
  store i64 %45, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %46 = add i64 %pgocount27, 1
  store i64 %46, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %47 = add i64 %pgocount28, 1
  store i64 %47, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %piped20 = load i64, ptr %piped, align 8
  %48 = call ptr @forge_rc_alloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @.i2s_fmt.9, i64 %piped20)
  %widen21 = sext i32 %49 to i64
  %50 = call i32 @puts(ptr %48)
  %widen22 = sext i32 %50 to i64
  %pgocount29 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %51 = add i64 %pgocount29, 1
  store i64 %51, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %52 = add i64 %pgocount30, 1
  store i64 %52, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %53 = add i64 %pgocount31, 1
  store i64 %53, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %54 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %54, i64 -559038737)
  call void @forge_array_push(ptr %54, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast23 = ptrtoint ptr %54 to i64
  %cast24 = inttoptr i64 %cast23 to ptr
  %55 = call i64 @apply__int(i64 21, ptr %cast24)
  store i64 %55, ptr %doubled, align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %56 = add i64 %pgocount32, 1
  store i64 %56, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %57 = add i64 %pgocount33, 1
  store i64 %57, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %58 = add i64 %pgocount34, 1
  store i64 %58, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %59 = add i64 %pgocount35, 1
  store i64 %59, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %doubled25 = load i64, ptr %doubled, align 8
  %60 = call ptr @forge_rc_alloc(i64 32)
  %61 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %60, i64 32, ptr @.i2s_fmt.10, i64 %doubled25)
  %widen26 = sext i32 %61 to i64
  %62 = call i32 @puts(ptr %60)
  %widen27 = sext i32 %62 to i64
  %pgocount36 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %63 = add i64 %pgocount36, 1
  store i64 %63, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %64 = add i64 %pgocount37, 1
  store i64 %64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %65 = add i64 %pgocount38, 1
  store i64 %65, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %66 = add i64 %pgocount39, 1
  store i64 %66, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %67 = call ptr @show(i64 42)
  %68 = call i32 @puts(ptr %67)
  %widen28 = sext i32 %68 to i64
  %pgocount40 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %69 = add i64 %pgocount40, 1
  store i64 %69, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %70 = add i64 %pgocount41, 1
  store i64 %70, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %71 = add i64 %pgocount42, 1
  store i64 %71, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %72 = call ptr @forge_array_new()
  %pgocount43 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %73 = add i64 %pgocount43, 1
  store i64 %73, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  call void @forge_array_push(ptr %72, i64 1)
  %pgocount44 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %74 = add i64 %pgocount44, 1
  store i64 %74, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  call void @forge_array_push(ptr %72, i64 2)
  %pgocount45 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %75 = add i64 %pgocount45, 1
  store i64 %75, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  call void @forge_array_push(ptr %72, i64 3)
  %76 = call i64 @print_all(ptr %72)
  %pgocount46 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %77 = add i64 %pgocount46, 1
  store i64 %77, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %78 = add i64 %pgocount47, 1
  store i64 %78, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %79 = add i64 %pgocount48, 1
  store i64 %79, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %80 = add i64 %pgocount49, 1
  store i64 %80, ptr getelementptr inbounds ([22 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %81 = call i32 @puts(ptr @.str.11)
  %widen29 = sext i32 %81 to i64
  %p_cleanup = load ptr, ptr %p, align 8
  %82 = call i64 @__release_Pair__string__int(ptr %p_cleanup)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([23 x i64], ptr @__profc___bs_top_level, i32 0, i32 22), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([23 x i64], ptr @__profc___bs_top_level, i32 0, i32 22), align 8
  %1 = call i32 @forge_test_summary()
  %widen = sext i32 %1 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_Pair__string__int(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_first_ptr = getelementptr inbounds nuw %Pair__string__int, ptr %0, i32 0, i32 0
  %rel_first = load ptr, ptr %rel_first_ptr, align 8
  %is_null_first = icmp eq ptr %rel_first, null
  br i1 %is_null_first, label %rel_first_skip, label %rel_first_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %rel_first_skip, %alive
  ret i64 0

rel_first_skip:                                   ; preds = %rel_first_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_first_do:                                     ; preds = %do_free
  call void @forge_rc_release(ptr %rel_first)
  br label %rel_first_skip
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
