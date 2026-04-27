; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/let_stmt/tests/immut_aggressive.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Counter = type { i64 }
%Action = type { i64, ptr }
%Point = type { i64, i64 }

@global_counter = global i64 0
@total = global i64 0
@x = global i64 0
@c = global i64 0
@acc = global i64 0
@actions = global i64 0
@sum = global i64 0
@p = global i64 0
@p2 = global i64 0
@result = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/let_stmt/tests/immut_aggressive.fg\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/let_stmt/tests/immut_aggressive.fg\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.10 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.11 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.12 = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/let_stmt/tests/immut_aggressive.fg\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.14 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.15 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.16 = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/let_stmt/tests/immut_aggressive.fg\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_increment = private global [8 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_increment = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -8290058023728957812, i64 249892690941124490, i64 sub (i64 ptrtoint (ptr @__profc_increment to i64), i64 ptrtoint (ptr @__profd_increment to i64)), i64 0, ptr null, ptr null, i32 8, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_maybe = private global [13 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_maybe = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6851139422816860798, i64 210720436115, i64 sub (i64 ptrtoint (ptr @__profc_maybe to i64), i64 ptrtoint (ptr @__profd_maybe to i64)), i64 0, ptr null, ptr null, i32 13, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [51 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 51, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [6 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 6, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [39 x i8] c"\1F%x\DA\CB\CCK.J\CDM\CD+a\CCM\ACLJ\05\92\99y\8C\F1\F19\89\B9I)\89\F1\06\00\B8`\0B*", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [5 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_increment, ptr @__profd_maybe, ptr @__profd_main, ptr @__profd___lambda_0], section "llvm.metadata"
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

define i64 @increment() {
entry:
  %pgocount = load i64, ptr @__profc_increment, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_increment, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 4), align 8
  %global_counter = load i64, ptr @global_counter, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 5), align 8
  %add = add i64 %global_counter, 1
  store i64 %add, ptr @global_counter, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 6), align 8
  %6 = add i64 %pgocount6, 1
  store i64 %6, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 7), align 8
  %7 = add i64 %pgocount7, 1
  store i64 %7, ptr getelementptr inbounds ([8 x i64], ptr @__profc_increment, i32 0, i32 7), align 8
  %global_counter1 = load i64, ptr @global_counter, align 8
  ret i64 %global_counter1
}

define i64 @maybe(i64 %0) {
entry:
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_maybe, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_maybe, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 4), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 5), align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %pgocount6 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 11), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 11), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 12), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 12), align 8
  ret i64 0

if_then:                                          ; preds = %entry
  %pgocount8 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 6), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 6), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 7), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 7), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 8), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 8), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 9), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 9), align 8
  %x2 = load i64, ptr %x, align 8
  ret i64 %x2

if_else:                                          ; preds = %entry
  %pgocount12 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 10), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([13 x i64], ptr @__profc_maybe, i32 0, i32 10), align 8
  br label %ifcont
}

define i64 @main() {
entry:
  %nc_result104 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %n66 = alloca i64, align 8
  %n54 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %a = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %x16 = alloca i64, align 8
  %x = alloca i64, align 8
  %local = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %pgocount = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  store i64 0, ptr @global_counter, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %5 = call i64 @increment()
  %6 = call ptr @forge_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %5)
  %widen = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen1 = sext i32 %8 to i64
  %pgocount5 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %13 = call i64 @increment()
  %14 = call ptr @forge_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.1, i64 %13)
  %widen2 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen3 = sext i32 %16 to i64
  %pgocount9 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %17 = add i64 %pgocount9, 1
  store i64 %17, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %18 = add i64 %pgocount10, 1
  store i64 %18, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %19 = add i64 %pgocount11, 1
  store i64 %19, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %21 = call i64 @increment()
  %22 = call ptr @forge_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.2, i64 %21)
  %widen4 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen5 = sext i32 %24 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %25 = add i64 %pgocount13, 1
  store i64 %25, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  store i64 0, ptr @total, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %26 = add i64 %pgocount14, 1
  store i64 %26, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %27 = add i64 %pgocount15, 1
  store i64 %27, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %28 = add i64 %pgocount16, 1
  store i64 %28, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %29 = add i64 %pgocount17, 1
  store i64 %29, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  store i64 0, ptr %i, align 8
  store i64 10, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i6 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i6, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %pgocount18 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %30 = add i64 %pgocount18, 1
  store i64 %30, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %31 = add i64 %pgocount19, 1
  store i64 %31, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %32 = add i64 %pgocount20, 1
  store i64 %32, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %33 = add i64 %pgocount21, 1
  store i64 %33, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %i7 = load i64, ptr %i, align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %34 = add i64 %pgocount22, 1
  store i64 %34, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %i8 = load i64, ptr %i, align 8
  %mul = mul i64 %i7, %i8
  store i64 %mul, ptr %local, align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %35 = add i64 %pgocount23, 1
  store i64 %35, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %36 = add i64 %pgocount24, 1
  store i64 %36, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %37 = add i64 %pgocount25, 1
  store i64 %37, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %38 = add i64 %pgocount26, 1
  store i64 %38, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %local9 = load i64, ptr %local, align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %39 = add i64 %pgocount27, 1
  store i64 %39, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %add = add i64 %local9, 1
  store i64 %add, ptr %local, align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %40 = add i64 %pgocount28, 1
  store i64 %40, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %41 = add i64 %pgocount29, 1
  store i64 %41, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %42 = add i64 %pgocount30, 1
  store i64 %42, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %43 = add i64 %pgocount31, 1
  store i64 %43, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %total = load i64, ptr @total, align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %44 = add i64 %pgocount32, 1
  store i64 %44, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %local10 = load i64, ptr %local, align 8
  %add11 = add i64 %total, %local10
  store i64 %add11, ptr @total, align 8
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i12 = load i64, ptr %i, align 8
  %for_next = add i64 %i12, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %pgocount33 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %45 = add i64 %pgocount33, 1
  store i64 %45, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %46 = add i64 %pgocount34, 1
  store i64 %46, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %47 = add i64 %pgocount35, 1
  store i64 %47, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %48 = add i64 %pgocount36, 1
  store i64 %48, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %total13 = load i64, ptr @total, align 8
  %49 = call ptr @forge_rc_alloc(i64 32)
  %50 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %49, i64 32, ptr @.i2s_fmt.3, i64 %total13)
  %widen14 = sext i32 %50 to i64
  %51 = call i32 @puts(ptr %49)
  %widen15 = sext i32 %51 to i64
  %pgocount37 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %52 = add i64 %pgocount37, 1
  store i64 %52, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  store i64 100, ptr @x, align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %53 = add i64 %pgocount38, 1
  store i64 %53, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %54 = add i64 %pgocount39, 1
  store i64 %54, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %55 = add i64 %pgocount40, 1
  store i64 %55, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  store i64 200, ptr %x, align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %56 = add i64 %pgocount41, 1
  store i64 %56, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %57 = add i64 %pgocount42, 1
  store i64 %57, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %58 = add i64 %pgocount43, 1
  store i64 %58, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  store i64 300, ptr %x16, align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %59 = add i64 %pgocount44, 1
  store i64 %59, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %60 = add i64 %pgocount45, 1
  store i64 %60, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %61 = add i64 %pgocount46, 1
  store i64 %61, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %62 = add i64 %pgocount47, 1
  store i64 %62, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %x17 = load i64, ptr %x16, align 8
  %63 = call ptr @forge_rc_alloc(i64 32)
  %64 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %63, i64 32, ptr @.i2s_fmt.4, i64 %x17)
  %widen18 = sext i32 %64 to i64
  %65 = call i32 @puts(ptr %63)
  %widen19 = sext i32 %65 to i64
  %pgocount48 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %66 = add i64 %pgocount48, 1
  store i64 %66, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %67 = add i64 %pgocount49, 1
  store i64 %67, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %68 = add i64 %pgocount50, 1
  store i64 %68, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %69 = add i64 %pgocount51, 1
  store i64 %69, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %x20 = load i64, ptr %x, align 8
  %70 = call ptr @forge_rc_alloc(i64 32)
  %71 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %70, i64 32, ptr @.i2s_fmt.5, i64 %x20)
  %widen21 = sext i32 %71 to i64
  %72 = call i32 @puts(ptr %70)
  %widen22 = sext i32 %72 to i64
  %pgocount52 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %73 = add i64 %pgocount52, 1
  store i64 %73, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount53 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %74 = add i64 %pgocount53, 1
  store i64 %74, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %75 = add i64 %pgocount54, 1
  store i64 %75, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %76 = add i64 %pgocount55, 1
  store i64 %76, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %x23 = load i64, ptr @x, align 8
  %77 = call ptr @forge_rc_alloc(i64 32)
  %78 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %77, i64 32, ptr @.i2s_fmt.6, i64 %x23)
  %widen24 = sext i32 %78 to i64
  %79 = call i32 @puts(ptr %77)
  %widen25 = sext i32 %79 to i64
  %pgocount56 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %80 = add i64 %pgocount56, 1
  store i64 %80, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %81 = add i64 %pgocount57, 1
  store i64 %81, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %82 = call ptr @forge_rc_alloc(i64 8)
  %pgocount58 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %83 = add i64 %pgocount58, 1
  store i64 %83, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %fld_ptr = getelementptr inbounds nuw %Counter, ptr %82, i32 0, i32 0
  store i64 0, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %82 to i64
  store i64 %cast, ptr @c, align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %84 = add i64 %pgocount59, 1
  store i64 %84, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %85 = add i64 %pgocount60, 1
  store i64 %85, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %86 = add i64 %pgocount61, 1
  store i64 %86, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %c = load ptr, ptr @c, align 8
  %fa_fld = getelementptr inbounds nuw %Counter, ptr %c, i32 0, i32 0
  %pgocount62 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %87 = add i64 %pgocount62, 1
  store i64 %87, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  store i64 42, ptr %fa_fld, align 8
  %pgocount63 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %88 = add i64 %pgocount63, 1
  store i64 %88, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %89 = add i64 %pgocount64, 1
  store i64 %89, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %pgocount65 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %90 = add i64 %pgocount65, 1
  store i64 %90, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %91 = add i64 %pgocount66, 1
  store i64 %91, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %pgocount67 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %92 = add i64 %pgocount67, 1
  store i64 %92, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %c26 = load ptr, ptr @c, align 8
  %cast27 = ptrtoint ptr %c26 to i64
  %null_chk = icmp eq i64 %cast27, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 140, i64 38)
  %value_ptr = getelementptr inbounds nuw %Counter, ptr %c26, i32 0, i32 0
  %value = load i64, ptr %value_ptr, align 8
  %93 = call ptr @forge_rc_alloc(i64 32)
  %94 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %93, i64 32, ptr @.i2s_fmt.7, i64 %value)
  %widen28 = sext i32 %94 to i64
  %95 = call i32 @puts(ptr %93)
  %widen29 = sext i32 %95 to i64
  %pgocount68 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %96 = add i64 %pgocount68, 1
  store i64 %96, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount69 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %97 = add i64 %pgocount69, 1
  store i64 %97, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  store i64 50, ptr @acc, align 8
  %pgocount70 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %98 = add i64 %pgocount70, 1
  store i64 %98, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %99 = call ptr @forge_array_new()
  %pgocount71 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %100 = add i64 %pgocount71, 1
  store i64 %100, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %101 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Action, ptr %101, i32 0, i32 0
  store i64 193460223, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Action, ptr %101, i32 0, i32 1
  %102 = call ptr @forge_rc_alloc(i64 8)
  store ptr %102, ptr %pay_ptr, align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %103 = add i64 %pgocount72, 1
  store i64 %103, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %slot_base = ptrtoint ptr %102 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 10, ptr %slot, align 8
  %cast30 = ptrtoint ptr %101 to i64
  call void @forge_array_push(ptr %99, i64 %cast30)
  %pgocount73 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %104 = add i64 %pgocount73, 1
  store i64 %104, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %105 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr31 = getelementptr inbounds nuw %Action, ptr %105, i32 0, i32 0
  store i64 193454481, ptr %tag_ptr31, align 8
  %pay_ptr32 = getelementptr inbounds nuw %Action, ptr %105, i32 0, i32 1
  %106 = call ptr @forge_rc_alloc(i64 8)
  store ptr %106, ptr %pay_ptr32, align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %107 = add i64 %pgocount74, 1
  store i64 %107, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %slot_base33 = ptrtoint ptr %106 to i64
  %slot_addr34 = add i64 %slot_base33, 0
  %slot35 = inttoptr i64 %slot_addr34 to ptr
  store i64 3, ptr %slot35, align 8
  %cast36 = ptrtoint ptr %105 to i64
  call void @forge_array_push(ptr %99, i64 %cast36)
  %pgocount75 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %108 = add i64 %pgocount75, 1
  store i64 %108, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %109 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr37 = getelementptr inbounds nuw %Action, ptr %109, i32 0, i32 0
  store i64 193460223, ptr %tag_ptr37, align 8
  %pay_ptr38 = getelementptr inbounds nuw %Action, ptr %109, i32 0, i32 1
  %110 = call ptr @forge_rc_alloc(i64 8)
  store ptr %110, ptr %pay_ptr38, align 8
  %pgocount76 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %111 = add i64 %pgocount76, 1
  store i64 %111, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %slot_base39 = ptrtoint ptr %110 to i64
  %slot_addr40 = add i64 %slot_base39, 0
  %slot41 = inttoptr i64 %slot_addr40 to ptr
  store i64 7, ptr %slot41, align 8
  %cast42 = ptrtoint ptr %109 to i64
  call void @forge_array_push(ptr %99, i64 %cast42)
  %pgocount77 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %112 = add i64 %pgocount77, 1
  store i64 %112, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %113 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr43 = getelementptr inbounds nuw %Action, ptr %113, i32 0, i32 0
  store i64 210688553576, ptr %tag_ptr43, align 8
  %pay_ptr44 = getelementptr inbounds nuw %Action, ptr %113, i32 0, i32 1
  store ptr null, ptr %pay_ptr44, align 8
  %cast45 = ptrtoint ptr %113 to i64
  call void @forge_array_push(ptr %99, i64 %cast45)
  %pgocount78 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %114 = add i64 %pgocount78, 1
  store i64 %114, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %115 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr46 = getelementptr inbounds nuw %Action, ptr %115, i32 0, i32 0
  store i64 193460223, ptr %tag_ptr46, align 8
  %pay_ptr47 = getelementptr inbounds nuw %Action, ptr %115, i32 0, i32 1
  %116 = call ptr @forge_rc_alloc(i64 8)
  store ptr %116, ptr %pay_ptr47, align 8
  %pgocount79 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %117 = add i64 %pgocount79, 1
  store i64 %117, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %slot_base48 = ptrtoint ptr %116 to i64
  %slot_addr49 = add i64 %slot_base48, 0
  %slot50 = inttoptr i64 %slot_addr49 to ptr
  store i64 5, ptr %slot50, align 8
  %cast51 = ptrtoint ptr %115 to i64
  call void @forge_array_push(ptr %99, i64 %cast51)
  store ptr %99, ptr @actions, align 8
  %pgocount80 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %118 = add i64 %pgocount80, 1
  store i64 %118, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %pgocount81 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %119 = add i64 %pgocount81, 1
  store i64 %119, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %pgocount82 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %120 = add i64 %pgocount82, 1
  store i64 %120, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %actions = load ptr, ptr @actions, align 8
  %121 = call i64 @forge_array_len(ptr %actions)
  store i64 %121, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %for.exit
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %122 = call i64 @forge_array_get(ptr %actions, i64 %forin_i_val)
  store i64 %122, ptr %a, align 8
  %pgocount83 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %123 = add i64 %pgocount83, 1
  store i64 %123, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %pgocount84 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %124 = add i64 %pgocount84, 1
  store i64 %124, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %pgocount85 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %125 = add i64 %pgocount85, 1
  store i64 %125, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %a52 = load ptr, ptr %a, align 8
  %tag_ptr53 = getelementptr inbounds nuw %Action, ptr %a52, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr53, align 8
  %tag_eq = icmp eq i64 %tag, 193460223
  br i1 %tag_eq, label %march_arm, label %march_next

forin.incr:                                       ; preds = %match_end
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %pgocount86 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %126 = add i64 %pgocount86, 1
  store i64 %126, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %pgocount87 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %127 = add i64 %pgocount87, 1
  store i64 %127, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %pgocount88 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %128 = add i64 %pgocount88, 1
  store i64 %128, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %pgocount89 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %129 = add i64 %pgocount89, 1
  store i64 %129, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %acc72 = load i64, ptr @acc, align 8
  %130 = call ptr @forge_rc_alloc(i64 32)
  %131 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %130, i64 32, ptr @.i2s_fmt.8, i64 %acc72)
  %widen73 = sext i32 %131 to i64
  %132 = call i32 @puts(ptr %130)
  %widen74 = sext i32 %132 to i64
  %pgocount90 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %133 = add i64 %pgocount90, 1
  store i64 %133, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  store i64 0, ptr @sum, align 8
  %pgocount91 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %134 = add i64 %pgocount91, 1
  store i64 %134, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %pgocount92 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %135 = add i64 %pgocount92, 1
  store i64 %135, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %pgocount93 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %136 = add i64 %pgocount93, 1
  store i64 %136, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %137 = call ptr @forge_array_new()
  %pgocount94 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %138 = add i64 %pgocount94, 1
  store i64 %138, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  call void @forge_array_push(ptr %137, i64 1)
  %pgocount95 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %139 = add i64 %pgocount95, 1
  store i64 %139, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  call void @forge_array_push(ptr %137, i64 2)
  %pgocount96 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %140 = add i64 %pgocount96, 1
  store i64 %140, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  call void @forge_array_push(ptr %137, i64 3)
  %pgocount97 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %141 = add i64 %pgocount97, 1
  store i64 %141, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  call void @forge_array_push(ptr %137, i64 4)
  %pgocount98 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %142 = add i64 %pgocount98, 1
  store i64 %142, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  call void @forge_array_push(ptr %137, i64 5)
  %143 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %143, i64 -559038737)
  call void @forge_array_push(ptr %143, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast75 = ptrtoint ptr %143 to i64
  call void @forge_array_foreach(ptr %137, i64 %cast75)
  %pgocount99 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %144 = add i64 %pgocount99, 1
  store i64 %144, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount100 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %145 = add i64 %pgocount100, 1
  store i64 %145, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount101 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %146 = add i64 %pgocount101, 1
  store i64 %146, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount102 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %147 = add i64 %pgocount102, 1
  store i64 %147, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %sum = load i64, ptr @sum, align 8
  %148 = call ptr @forge_rc_alloc(i64 32)
  %149 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %148, i64 32, ptr @.i2s_fmt.9, i64 %sum)
  %widen76 = sext i32 %149 to i64
  %150 = call i32 @puts(ptr %148)
  %widen77 = sext i32 %150 to i64
  %pgocount103 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %151 = add i64 %pgocount103, 1
  store i64 %151, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount104 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %152 = add i64 %pgocount104, 1
  store i64 %152, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %153 = call ptr @forge_rc_alloc(i64 16)
  %pgocount105 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %154 = add i64 %pgocount105, 1
  store i64 %154, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %fld_ptr78 = getelementptr inbounds nuw %Point, ptr %153, i32 0, i32 0
  store i64 1, ptr %fld_ptr78, align 8
  %pgocount106 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %155 = add i64 %pgocount106, 1
  store i64 %155, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %fld_ptr79 = getelementptr inbounds nuw %Point, ptr %153, i32 0, i32 1
  store i64 2, ptr %fld_ptr79, align 8
  %cast80 = ptrtoint ptr %153 to i64
  store i64 %cast80, ptr @p, align 8
  %pgocount107 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %156 = add i64 %pgocount107, 1
  store i64 %156, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount108 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %157 = add i64 %pgocount108, 1
  store i64 %157, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %p = load ptr, ptr @p, align 8
  %158 = call ptr @forge_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Point, ptr %p, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Point, ptr %158, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src81 = getelementptr inbounds nuw %Point, ptr %p, i32 0, i32 1
  %with_cp_val82 = load i64, ptr %with_cp_src81, align 8
  %with_cp_dst83 = getelementptr inbounds nuw %Point, ptr %158, i32 0, i32 1
  store i64 %with_cp_val82, ptr %with_cp_dst83, align 8
  %pgocount109 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %159 = add i64 %pgocount109, 1
  store i64 %159, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %with_ovr = getelementptr inbounds nuw %Point, ptr %158, i32 0, i32 0
  store i64 99, ptr %with_ovr, align 8
  %cast84 = ptrtoint ptr %158 to i64
  store i64 %cast84, ptr @p2, align 8
  %pgocount110 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %160 = add i64 %pgocount110, 1
  store i64 %160, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount111 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %161 = add i64 %pgocount111, 1
  store i64 %161, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount112 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %162 = add i64 %pgocount112, 1
  store i64 %162, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount113 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %163 = add i64 %pgocount113, 1
  store i64 %163, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount114 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %164 = add i64 %pgocount114, 1
  store i64 %164, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %p85 = load ptr, ptr @p, align 8
  %cast86 = ptrtoint ptr %p85 to i64
  %null_chk87 = icmp eq i64 %cast86, 0
  %null_ext88 = zext i1 %null_chk87 to i64
  call void @forge_null_deref_trap(ptr @fld_name.10, i64 1, ptr @sty_name.11, i64 5, i64 %null_ext88, ptr @src_file.12, i64 140, i64 64)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p85, i32 0, i32 0
  %x89 = load i64, ptr %x_ptr, align 8
  %165 = call ptr @forge_rc_alloc(i64 32)
  %166 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %165, i64 32, ptr @.i2s_fmt.13, i64 %x89)
  %widen90 = sext i32 %166 to i64
  %167 = call i32 @puts(ptr %165)
  %widen91 = sext i32 %167 to i64
  %pgocount115 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %168 = add i64 %pgocount115, 1
  store i64 %168, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount116 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %169 = add i64 %pgocount116, 1
  store i64 %169, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount117 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %170 = add i64 %pgocount117, 1
  store i64 %170, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount118 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %171 = add i64 %pgocount118, 1
  store i64 %171, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount119 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %172 = add i64 %pgocount119, 1
  store i64 %172, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %p2 = load ptr, ptr @p2, align 8
  %cast92 = ptrtoint ptr %p2 to i64
  %null_chk93 = icmp eq i64 %cast92, 0
  %null_ext94 = zext i1 %null_chk93 to i64
  call void @forge_null_deref_trap(ptr @fld_name.14, i64 1, ptr @sty_name.15, i64 5, i64 %null_ext94, ptr @src_file.16, i64 140, i64 65)
  %x_ptr95 = getelementptr inbounds nuw %Point, ptr %p2, i32 0, i32 0
  %x96 = load i64, ptr %x_ptr95, align 8
  %173 = call ptr @forge_rc_alloc(i64 32)
  %174 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %173, i64 32, ptr @.i2s_fmt.17, i64 %x96)
  %widen97 = sext i32 %174 to i64
  %175 = call i32 @puts(ptr %173)
  %widen98 = sext i32 %175 to i64
  %pgocount120 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %176 = add i64 %pgocount120, 1
  store i64 %176, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  store i64 0, ptr @result, align 8
  %pgocount121 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %177 = add i64 %pgocount121, 1
  store i64 %177, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount122 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %178 = add i64 %pgocount122, 1
  store i64 %178, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount123 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %179 = add i64 %pgocount123, 1
  store i64 %179, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount124 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %180 = add i64 %pgocount124, 1
  store i64 %180, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount125 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %181 = add i64 %pgocount125, 1
  store i64 %181, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %182 = call i64 @maybe(i64 42)
  %nc_null = icmp eq i64 %182, 0
  store i64 %182, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

match_end:                                        ; preds = %march_arm69, %march_arm57, %march_arm
  br label %forin.incr

march_arm:                                        ; preds = %forin.body
  %pay_slot = getelementptr inbounds nuw %Action, ptr %a52, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n54, align 8
  %pgocount126 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %183 = add i64 %pgocount126, 1
  store i64 %183, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %pgocount127 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %184 = add i64 %pgocount127, 1
  store i64 %184, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %pgocount128 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %185 = add i64 %pgocount128, 1
  store i64 %185, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %pgocount129 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %186 = add i64 %pgocount129, 1
  store i64 %186, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %pgocount130 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %187 = add i64 %pgocount130, 1
  store i64 %187, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %acc = load i64, ptr @acc, align 8
  %pgocount131 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %188 = add i64 %pgocount131, 1
  store i64 %188, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %n55 = load i64, ptr %n54, align 8
  %add56 = add i64 %acc, %n55
  store i64 %add56, ptr @acc, align 8
  store i64 %add56, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %forin.body
  %tag_eq59 = icmp eq i64 %tag, 193454481
  br i1 %tag_eq59, label %march_arm57, label %march_next58

march_arm57:                                      ; preds = %march_next
  %pay_slot60 = getelementptr inbounds nuw %Action, ptr %a52, i32 0, i32 1
  %payload61 = load ptr, ptr %pay_slot60, align 8
  %n_slot_base62 = ptrtoint ptr %payload61 to i64
  %n_slot_addr63 = add i64 %n_slot_base62, 0
  %n_slot64 = inttoptr i64 %n_slot_addr63 to ptr
  %n65 = load i64, ptr %n_slot64, align 8
  store i64 %n65, ptr %n66, align 8
  %pgocount132 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %189 = add i64 %pgocount132, 1
  store i64 %189, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %pgocount133 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %190 = add i64 %pgocount133, 1
  store i64 %190, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %pgocount134 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %191 = add i64 %pgocount134, 1
  store i64 %191, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %pgocount135 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %192 = add i64 %pgocount135, 1
  store i64 %192, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %pgocount136 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %193 = add i64 %pgocount136, 1
  store i64 %193, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %acc67 = load i64, ptr @acc, align 8
  %pgocount137 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %194 = add i64 %pgocount137, 1
  store i64 %194, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %n68 = load i64, ptr %n66, align 8
  %sub = sub i64 %acc67, %n68
  store i64 %sub, ptr @acc, align 8
  store i64 %sub, ptr %match_stmt_discard, align 8
  br label %match_end

march_next58:                                     ; preds = %march_next
  %tag_eq71 = icmp eq i64 %tag, 210688553576
  br i1 %tag_eq71, label %march_arm69, label %march_next70

march_arm69:                                      ; preds = %march_next58
  %pgocount138 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %195 = add i64 %pgocount138, 1
  store i64 %195, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %pgocount139 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %196 = add i64 %pgocount139, 1
  store i64 %196, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %pgocount140 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %197 = add i64 %pgocount140, 1
  store i64 %197, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %pgocount141 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %198 = add i64 %pgocount141, 1
  store i64 %198, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  store i64 0, ptr @acc, align 8
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next70:                                     ; preds = %march_next58
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 45)
  unreachable

nc_rhs:                                           ; preds = %forin.exit
  %pgocount142 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %199 = add i64 %pgocount142, 1
  store i64 %199, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount143 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %200 = add i64 %pgocount143, 1
  store i64 %200, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %forin.exit
  %nc_val = load i64, ptr %nc_result, align 8
  store i64 %nc_val, ptr @result, align 8
  %pgocount144 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %201 = add i64 %pgocount144, 1
  store i64 %201, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %pgocount145 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %202 = add i64 %pgocount145, 1
  store i64 %202, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount146 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %203 = add i64 %pgocount146, 1
  store i64 %203, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount147 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %204 = add i64 %pgocount147, 1
  store i64 %204, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %result = load i64, ptr @result, align 8
  %205 = call ptr @forge_rc_alloc(i64 32)
  %206 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %205, i64 32, ptr @.i2s_fmt.18, i64 %result)
  %widen99 = sext i32 %206 to i64
  %207 = call i32 @puts(ptr %205)
  %widen100 = sext i32 %207 to i64
  %pgocount148 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %208 = add i64 %pgocount148, 1
  store i64 %208, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount149 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %209 = add i64 %pgocount149, 1
  store i64 %209, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount150 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %210 = add i64 %pgocount150, 1
  store i64 %210, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount151 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %211 = add i64 %pgocount151, 1
  store i64 %211, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount152 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %212 = add i64 %pgocount152, 1
  store i64 %212, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount153 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %213 = add i64 %pgocount153, 1
  store i64 %213, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %214 = call i64 @maybe(i64 -5)
  %nc_null101 = icmp eq i64 %214, 0
  store i64 %214, ptr %nc_result104, align 8
  br i1 %nc_null101, label %nc_rhs102, label %nc_end103

nc_rhs102:                                        ; preds = %nc_end
  %pgocount154 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %215 = add i64 %pgocount154, 1
  store i64 %215, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount155 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %216 = add i64 %pgocount155, 1
  store i64 %216, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  store i64 -1, ptr %nc_result104, align 8
  br label %nc_end103

nc_end103:                                        ; preds = %nc_rhs102, %nc_end
  %nc_val105 = load i64, ptr %nc_result104, align 8
  store i64 %nc_val105, ptr @result, align 8
  %pgocount156 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %217 = add i64 %pgocount156, 1
  store i64 %217, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount157 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %218 = add i64 %pgocount157, 1
  store i64 %218, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount158 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %219 = add i64 %pgocount158, 1
  store i64 %219, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount159 = load i64, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %220 = add i64 %pgocount159, 1
  store i64 %220, ptr getelementptr inbounds ([51 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %result106 = load i64, ptr @result, align 8
  %221 = call ptr @forge_rc_alloc(i64 32)
  %222 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %221, i64 32, ptr @.i2s_fmt.19, i64 %result106)
  %widen107 = sext i32 %222 to i64
  %223 = call i32 @puts(ptr %221)
  %widen108 = sext i32 %223 to i64
  %224 = call i32 @forge_test_summary()
  %widen109 = sext i32 %224 to i64
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
  %pgocount1 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 4), align 8
  %sum = load i64, ptr @sum, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([6 x i64], ptr @__profc___lambda_0, i32 0, i32 5), align 8
  %x1 = load i64, ptr %x, align 8
  %add = add i64 %sum, %x1
  store i64 %add, ptr @sum, align 8
  ret i64 %add
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
