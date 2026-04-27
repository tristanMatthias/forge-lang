; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/example.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Shape = type { i64, ptr }

@.match_fn = private unnamed_addr constant [5 x i8] c"area\00", align 1
@mu_file = private unnamed_addr constant [128 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/example.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_area = private global [15 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_area = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2375626347278532021, i64 6385054366, i64 sub (i64 ptrtoint (ptr @__profc_area to i64), i64 ptrtoint (ptr @__profd_area to i64)), i64 0, ptr null, ptr null, i32 15, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [18 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 18, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [19 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 19, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [34 x i8] c"\18 x\DAK,JMd\CCM\CC\CCc\8C\8FO*\8E/\C9/\88\CFI-K\CD\01\00kX\08\FD", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [4 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_area, ptr @__profd_main, ptr @__profd___bs_top_level], section "llvm.metadata"
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

define i64 @area(ptr %0) {
entry:
  %side11 = alloca i64, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_area, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_area, align 8
  store ptr %0, ptr %s, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 2), align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm15, %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 6), align 8
  %r3 = load i64, ptr %r2, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 7), align 8
  %r4 = load i64, ptr %r2, align 8
  %mul = mul i64 %r3, %r4
  %pgocount8 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 8), align 8
  %mul5 = mul i64 %mul, 3
  store i64 %mul5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6952775702006
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %side_slot_base = ptrtoint ptr %payload10 to i64
  %side_slot_addr = add i64 %side_slot_base, 0
  %side_slot = inttoptr i64 %side_slot_addr to ptr
  %side = load i64, ptr %side_slot, align 8
  store i64 %side, ptr %side11, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 11), align 8
  %side12 = load i64, ptr %side11, align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 12), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 12), align 8
  %side13 = load i64, ptr %side11, align 8
  %mul14 = mul i64 %side12, %side13
  store i64 %mul14, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  %tag_eq17 = icmp eq i64 %tag, 229444052301365
  br i1 %tag_eq17, label %march_arm15, label %march_next16

march_arm15:                                      ; preds = %march_next7
  %pgocount13 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 13), align 8
  %14 = add i64 %pgocount13, 1
  store i64 %14, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 14), align 8
  %15 = add i64 %pgocount14, 1
  store i64 %15, ptr getelementptr inbounds ([15 x i64], ptr @__profc_area, i32 0, i32 14), align 8
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next16:                                     ; preds = %march_next7
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 11)
  unreachable
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %6, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %6, i32 0, i32 1
  %7 = call ptr @forge_rc_alloc(i64 8)
  store ptr %7, ptr %pay_ptr, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %slot_base = ptrtoint ptr %7 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %6 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %9 = call i64 @area(ptr %cast1)
  %10 = call ptr @forge_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt, i64 %9)
  %widen = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen2 = sext i32 %12 to i64
  %pgocount7 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %13 = add i64 %pgocount7, 1
  store i64 %13, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %14 = add i64 %pgocount8, 1
  store i64 %14, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %15 = add i64 %pgocount9, 1
  store i64 %15, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %16 = add i64 %pgocount10, 1
  store i64 %16, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %17 = add i64 %pgocount11, 1
  store i64 %17, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %18 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Shape, ptr %18, i32 0, i32 0
  store i64 6952775702006, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Shape, ptr %18, i32 0, i32 1
  %19 = call ptr @forge_rc_alloc(i64 8)
  store ptr %19, ptr %pay_ptr4, align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %slot_base5 = ptrtoint ptr %19 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  store i64 4, ptr %slot7, align 8
  %cast8 = ptrtoint ptr %18 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  %21 = call i64 @area(ptr %cast9)
  %22 = call ptr @forge_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.1, i64 %21)
  %widen10 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen11 = sext i32 %24 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %25 = add i64 %pgocount13, 1
  store i64 %25, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %26 = add i64 %pgocount14, 1
  store i64 %26, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %27 = add i64 %pgocount15, 1
  store i64 %27, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %28 = add i64 %pgocount16, 1
  store i64 %28, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %29 = add i64 %pgocount17, 1
  store i64 %29, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %30 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr12 = getelementptr inbounds nuw %Shape, ptr %30, i32 0, i32 0
  store i64 229444052301365, ptr %tag_ptr12, align 8
  %pay_ptr13 = getelementptr inbounds nuw %Shape, ptr %30, i32 0, i32 1
  store ptr null, ptr %pay_ptr13, align 8
  %cast14 = ptrtoint ptr %30 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  %31 = call i64 @area(ptr %cast15)
  %32 = call ptr @forge_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.2, i64 %31)
  %widen16 = sext i32 %33 to i64
  %34 = call i32 @puts(ptr %32)
  %widen17 = sext i32 %34 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([19 x i64], ptr @__profc___bs_top_level, i32 0, i32 18), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([19 x i64], ptr @__profc___bs_top_level, i32 0, i32 18), align 8
  %1 = call i32 @forge_test_summary()
  %widen = sext i32 %1 to i64
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
