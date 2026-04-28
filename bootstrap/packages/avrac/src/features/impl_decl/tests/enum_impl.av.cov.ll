; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/tests/enum_impl.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Color = type { i64, ptr }

@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"blue\00", align 1
@.match_fn = private unnamed_addr constant [12 x i8] c"Color__name\00", align 1
@mu_file = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/tests/enum_impl.fg\00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Color\00", align 1
@src_file = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/tests/enum_impl.fg\00", align 1
@fld_name.3 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.4 = private unnamed_addr constant [6 x i8] c"Color\00", align 1
@src_file.5 = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/tests/enum_impl.fg\00", align 1
@fld_name.6 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.7 = private unnamed_addr constant [6 x i8] c"Color\00", align 1
@src_file.8 = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/tests/enum_impl.fg\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_Color__name = private global [9 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_Color__name = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -6871858249044121657, i64 -4626161714658060925, i64 sub (i64 ptrtoint (ptr @__profc_Color__name to i64), i64 ptrtoint (ptr @__profd_Color__name to i64)), i64 0, ptr null, ptr null, i32 9, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [19 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 19, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [21 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 21, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [41 x i8] c"\1F'x\DAs\CE\CF\C9/\8A\8F\CFK\CCMe\CCM\CC\CCc\8C\8FO*\8E/\C9/\88\CFI-K\CD\01\00\B8\86\0B\C2", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [4 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_Color__name, ptr @__profd_main, ptr @__profd___bs_top_level], section "llvm.metadata"
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

define ptr @Color__name(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %self = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_Color__name, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_Color__name, align 8
  store ptr %0, ptr %self, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 2), align 8
  %self1 = load ptr, ptr %self, align 8
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %self1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193469728
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm5, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  %pgocount3 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 4), align 8
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 210675960374
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pgocount5 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 6), align 8
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq7 = icmp eq i64 %tag, 6383934317
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next3
  %pgocount7 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([9 x i64], ptr @__profc_Color__name, i32 0, i32 8), align 8
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next3
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 13)
  unreachable
}

define i64 @main() {
entry:
  %b = alloca ptr, align 8
  %g = alloca ptr, align 8
  %r = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %3 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %3, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %3, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %3 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %r, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Color, ptr %6, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Color, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr3, align 8
  %cast4 = ptrtoint ptr %6 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  store ptr %cast5, ptr %g, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %9 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %Color, ptr %9, i32 0, i32 0
  store i64 6383934317, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %Color, ptr %9, i32 0, i32 1
  store ptr null, ptr %pay_ptr7, align 8
  %cast8 = ptrtoint ptr %9 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  store ptr %cast9, ptr %b, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %10 = add i64 %pgocount7, 1
  store i64 %10, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %11 = add i64 %pgocount8, 1
  store i64 %11, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %12 = add i64 %pgocount9, 1
  store i64 %12, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %13 = add i64 %pgocount10, 1
  store i64 %13, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %r10 = load ptr, ptr %r, align 8
  %cast11 = ptrtoint ptr %r10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 134, i64 25)
  %14 = call ptr @Color__name(ptr %r10)
  %15 = call i32 @puts(ptr %14)
  %widen = sext i32 %15 to i64
  %pgocount11 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %16 = add i64 %pgocount11, 1
  store i64 %16, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %17 = add i64 %pgocount12, 1
  store i64 %17, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %19 = add i64 %pgocount14, 1
  store i64 %19, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %g12 = load ptr, ptr %g, align 8
  %cast13 = ptrtoint ptr %g12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @forge_null_deref_trap(ptr @fld_name.3, i64 4, ptr @sty_name.4, i64 5, i64 %null_ext15, ptr @src_file.5, i64 134, i64 26)
  %20 = call ptr @Color__name(ptr %g12)
  %21 = call i32 @puts(ptr %20)
  %widen16 = sext i32 %21 to i64
  %pgocount15 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %22 = add i64 %pgocount15, 1
  store i64 %22, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %23 = add i64 %pgocount16, 1
  store i64 %23, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %24 = add i64 %pgocount17, 1
  store i64 %24, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %25 = add i64 %pgocount18, 1
  store i64 %25, ptr getelementptr inbounds ([19 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %b17 = load ptr, ptr %b, align 8
  %cast18 = ptrtoint ptr %b17 to i64
  %null_chk19 = icmp eq i64 %cast18, 0
  %null_ext20 = zext i1 %null_chk19 to i64
  call void @forge_null_deref_trap(ptr @fld_name.6, i64 4, ptr @sty_name.7, i64 5, i64 %null_ext20, ptr @src_file.8, i64 134, i64 27)
  %26 = call ptr @Color__name(ptr %b17)
  %27 = call i32 @puts(ptr %26)
  %widen21 = sext i32 %27 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc___bs_top_level, i32 0, i32 19), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([21 x i64], ptr @__profc___bs_top_level, i32 0, i32 19), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc___bs_top_level, i32 0, i32 20), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([21 x i64], ptr @__profc___bs_top_level, i32 0, i32 20), align 8
  %2 = call i32 @forge_test_summary()
  %widen = sext i32 %2 to i64
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
