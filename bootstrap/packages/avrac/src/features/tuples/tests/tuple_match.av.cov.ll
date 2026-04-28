; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/tuples/tests/tuple_match.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Result = type { i64, ptr }

@results = global i64 0
@dz_file = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/tuples/tests/tuple_match.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/tuples/tests/tuple_match.fg\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"div by zero\00", align 1
@.match_fn.3 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.4 = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/tuples/tests/tuple_match.fg\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.match_fn.7 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.8 = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/tuples/tests/tuple_match.fg\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"div by zero\00", align 1
@.match_fn.11 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.12 = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/tuples/tests/tuple_match.fg\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_divide = private global [17 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_divide = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -8275535420795798123, i64 6953431560506, i64 sub (i64 ptrtoint (ptr @__profc_divide to i64), i64 ptrtoint (ptr @__profd_divide to i64)), i64 0, ptr null, ptr null, i32 17, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [67 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 67, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [21 x i8] c"\0B\13x\DAK\C9,\CBLIe\CCM\CC\CC\03\00\19\15\04\1C", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_divide, ptr @__profd_main], section "llvm.metadata"
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

define ptr @divide(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_divide, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_divide, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 4), align 8
  %b1 = load i64, ptr %b, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 5), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 5), align 8
  %eq = icmp eq i64 %b1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %pgocount6 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 12), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 12), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 13), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 13), align 8
  %10 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Result, ptr %10, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result, ptr %10, i32 0, i32 1
  %11 = call ptr @forge_rc_alloc(i64 8)
  store ptr %11, ptr %pay_ptr4, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 14), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 14), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 15), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 15), align 8
  %a5 = load i64, ptr %a, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 16), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 16), align 8
  %b6 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b6, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @forge_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 133, i64 8)
  %div = sdiv i64 %a5, %b6
  %slot_base7 = ptrtoint ptr %11 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %div, ptr %slot9, align 8
  %cast10 = ptrtoint ptr %10 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast11, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %pgocount11 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 6), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 6), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 7), align 8
  %16 = add i64 %pgocount12, 1
  store i64 %16, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 7), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 8), align 8
  %17 = add i64 %pgocount13, 1
  store i64 %17, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 8), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 9), align 8
  %18 = add i64 %pgocount14, 1
  store i64 %18, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 9), align 8
  %19 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %19, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %19, i32 0, i32 1
  %20 = call ptr @forge_rc_alloc(i64 8)
  store ptr %20, ptr %pay_ptr, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 10), align 8
  %21 = add i64 %pgocount15, 1
  store i64 %21, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 10), align 8
  %slot_base = ptrtoint ptr %20 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 0, ptr %slot, align 8
  %cast = ptrtoint ptr %19 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  %pgocount16 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 11), align 8
  %22 = add i64 %pgocount16, 1
  store i64 %22, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 11), align 8
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast12 = inttoptr i64 %cast10 to ptr
  ret ptr %cast12
}

define i64 @main() {
entry:
  %v91 = alloca i64, align 8
  %match_stmt_discard81 = alloca i64, align 8
  %v69 = alloca i64, align 8
  %match_stmt_discard59 = alloca i64, align 8
  %r254 = alloca i64, align 8
  %r153 = alloca i64, align 8
  %v35 = alloca i64, align 8
  %match_stmt_discard25 = alloca i64, align 8
  %v8 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %pgocount = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %pgocount2 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %6 = call ptr @divide(i64 10, i64 2)
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast = ptrtoint ptr %6 to i64
  store i64 %cast, ptr %slot, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %10 = call ptr @divide(i64 10, i64 0)
  %slot_base1 = ptrtoint ptr %2 to i64
  %slot_addr2 = add i64 %slot_base1, 8
  %slot3 = inttoptr i64 %slot_addr2 to ptr
  %cast4 = ptrtoint ptr %10 to i64
  store i64 %cast4, ptr %slot3, align 8
  %cast5 = ptrtoint ptr %2 to i64
  store i64 %cast5, ptr @results, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %11 = add i64 %pgocount8, 1
  store i64 %11, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %12 = add i64 %pgocount9, 1
  store i64 %12, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %13 = add i64 %pgocount10, 1
  store i64 %13, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %results = load ptr, ptr @results, align 8
  %tup_val_slot_base = ptrtoint ptr %results to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  %cast6 = inttoptr i64 %tup_val to ptr
  %cast7 = inttoptr i64 %tup_val to ptr
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %cast7, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm11, %march_arm
  %pgocount11 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %14 = add i64 %pgocount11, 1
  store i64 %14, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %15 = add i64 %pgocount12, 1
  store i64 %15, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %16 = add i64 %pgocount13, 1
  store i64 %16, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %results15 = load ptr, ptr @results, align 8
  %tup_val_slot_base16 = ptrtoint ptr %results15 to i64
  %tup_val_slot_addr17 = add i64 %tup_val_slot_base16, 8
  %tup_val_slot18 = inttoptr i64 %tup_val_slot_addr17 to ptr
  %tup_val19 = load i64, ptr %tup_val_slot18, align 8
  %cast20 = inttoptr i64 %tup_val19 to ptr
  %cast21 = inttoptr i64 %tup_val19 to ptr
  %tag_ptr22 = getelementptr inbounds nuw %Result, ptr %cast21, i32 0, i32 0
  %tag23 = load i64, ptr %tag_ptr22, align 8
  %tag_eq28 = icmp eq i64 %tag23, 5862623
  br i1 %tag_eq28, label %march_arm26, label %march_next27

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %cast6, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v8, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %17 = add i64 %pgocount14, 1
  store i64 %17, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %18 = add i64 %pgocount15, 1
  store i64 %18, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %19 = add i64 %pgocount16, 1
  store i64 %19, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %20 = add i64 %pgocount17, 1
  store i64 %20, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %v9 = load i64, ptr %v8, align 8
  %21 = call ptr @forge_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt, i64 %v9)
  %widen = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen10 = sext i32 %23 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq13 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq13, label %march_arm11, label %march_next12

march_arm11:                                      ; preds = %march_next
  %pgocount18 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %24 = add i64 %pgocount18, 1
  store i64 %24, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %25 = add i64 %pgocount19, 1
  store i64 %25, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %26 = call i32 @puts(ptr @.str)
  %widen14 = sext i32 %26 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next12:                                     ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 14)
  unreachable

match_end24:                                      ; preds = %march_arm39, %march_arm26
  %pgocount20 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %27 = add i64 %pgocount20, 1
  store i64 %27, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %28 = add i64 %pgocount21, 1
  store i64 %28, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %29 = call ptr @forge_rc_alloc(i64 16)
  %pgocount22 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %30 = add i64 %pgocount22, 1
  store i64 %30, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %31 = add i64 %pgocount23, 1
  store i64 %31, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %32 = add i64 %pgocount24, 1
  store i64 %32, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %33 = call ptr @divide(i64 20, i64 4)
  %slot_base43 = ptrtoint ptr %29 to i64
  %slot_addr44 = add i64 %slot_base43, 0
  %slot45 = inttoptr i64 %slot_addr44 to ptr
  %cast46 = ptrtoint ptr %33 to i64
  store i64 %cast46, ptr %slot45, align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %34 = add i64 %pgocount25, 1
  store i64 %34, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %35 = add i64 %pgocount26, 1
  store i64 %35, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %36 = add i64 %pgocount27, 1
  store i64 %36, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %37 = call ptr @divide(i64 20, i64 0)
  %slot_base47 = ptrtoint ptr %29 to i64
  %slot_addr48 = add i64 %slot_base47, 8
  %slot49 = inttoptr i64 %slot_addr48 to ptr
  %cast50 = ptrtoint ptr %37 to i64
  store i64 %cast50, ptr %slot49, align 8
  %cast51 = ptrtoint ptr %29 to i64
  %cast52 = inttoptr i64 %cast51 to ptr
  %r1_slot_base = ptrtoint ptr %cast52 to i64
  %r1_slot_addr = add i64 %r1_slot_base, 0
  %r1_slot = inttoptr i64 %r1_slot_addr to ptr
  %r1 = load i64, ptr %r1_slot, align 8
  store i64 %r1, ptr %r153, align 8
  %r2_slot_base = ptrtoint ptr %cast52 to i64
  %r2_slot_addr = add i64 %r2_slot_base, 8
  %r2_slot = inttoptr i64 %r2_slot_addr to ptr
  %r2 = load i64, ptr %r2_slot, align 8
  store i64 %r2, ptr %r254, align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %38 = add i64 %pgocount28, 1
  store i64 %38, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %39 = add i64 %pgocount29, 1
  store i64 %39, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %r155 = load ptr, ptr %r153, align 8
  %tag_ptr56 = getelementptr inbounds nuw %Result, ptr %r155, i32 0, i32 0
  %tag57 = load i64, ptr %tag_ptr56, align 8
  %tag_eq62 = icmp eq i64 %tag57, 5862623
  br i1 %tag_eq62, label %march_arm60, label %march_next61

march_arm26:                                      ; preds = %match_end
  %pay_slot29 = getelementptr inbounds nuw %Result, ptr %cast20, i32 0, i32 1
  %payload30 = load ptr, ptr %pay_slot29, align 8
  %v_slot_base31 = ptrtoint ptr %payload30 to i64
  %v_slot_addr32 = add i64 %v_slot_base31, 0
  %v_slot33 = inttoptr i64 %v_slot_addr32 to ptr
  %v34 = load i64, ptr %v_slot33, align 8
  store i64 %v34, ptr %v35, align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %40 = add i64 %pgocount30, 1
  store i64 %40, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %41 = add i64 %pgocount31, 1
  store i64 %41, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %42 = add i64 %pgocount32, 1
  store i64 %42, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %43 = add i64 %pgocount33, 1
  store i64 %43, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %v36 = load i64, ptr %v35, align 8
  %44 = call ptr @forge_rc_alloc(i64 32)
  %45 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %44, i64 32, ptr @.i2s_fmt.1, i64 %v36)
  %widen37 = sext i32 %45 to i64
  %46 = call i32 @puts(ptr %44)
  %widen38 = sext i32 %46 to i64
  store i64 0, ptr %match_stmt_discard25, align 8
  br label %match_end24

march_next27:                                     ; preds = %match_end
  %tag_eq41 = icmp eq i64 %tag23, 193456014
  br i1 %tag_eq41, label %march_arm39, label %march_next40

march_arm39:                                      ; preds = %march_next27
  %pgocount34 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %47 = add i64 %pgocount34, 1
  store i64 %47, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %48 = add i64 %pgocount35, 1
  store i64 %48, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %49 = call i32 @puts(ptr @.str.2)
  %widen42 = sext i32 %49 to i64
  store i64 0, ptr %match_stmt_discard25, align 8
  br label %match_end24

march_next40:                                     ; preds = %march_next27
  call void @forge_match_unreachable(ptr @.match_fn.3, i64 %tag23, ptr @mu_file.4, i64 18)
  unreachable

match_end58:                                      ; preds = %march_arm73, %march_arm60
  %pgocount36 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %50 = add i64 %pgocount36, 1
  store i64 %50, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %51 = add i64 %pgocount37, 1
  store i64 %51, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %r277 = load ptr, ptr %r254, align 8
  %tag_ptr78 = getelementptr inbounds nuw %Result, ptr %r277, i32 0, i32 0
  %tag79 = load i64, ptr %tag_ptr78, align 8
  %tag_eq84 = icmp eq i64 %tag79, 5862623
  br i1 %tag_eq84, label %march_arm82, label %march_next83

march_arm60:                                      ; preds = %match_end24
  %pay_slot63 = getelementptr inbounds nuw %Result, ptr %r155, i32 0, i32 1
  %payload64 = load ptr, ptr %pay_slot63, align 8
  %v_slot_base65 = ptrtoint ptr %payload64 to i64
  %v_slot_addr66 = add i64 %v_slot_base65, 0
  %v_slot67 = inttoptr i64 %v_slot_addr66 to ptr
  %v68 = load i64, ptr %v_slot67, align 8
  store i64 %v68, ptr %v69, align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %52 = add i64 %pgocount38, 1
  store i64 %52, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %53 = add i64 %pgocount39, 1
  store i64 %53, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %54 = add i64 %pgocount40, 1
  store i64 %54, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %55 = add i64 %pgocount41, 1
  store i64 %55, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %v70 = load i64, ptr %v69, align 8
  %56 = call ptr @forge_rc_alloc(i64 32)
  %57 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %56, i64 32, ptr @.i2s_fmt.5, i64 %v70)
  %widen71 = sext i32 %57 to i64
  %58 = call i32 @puts(ptr %56)
  %widen72 = sext i32 %58 to i64
  store i64 0, ptr %match_stmt_discard59, align 8
  br label %match_end58

march_next61:                                     ; preds = %match_end24
  %tag_eq75 = icmp eq i64 %tag57, 193456014
  br i1 %tag_eq75, label %march_arm73, label %march_next74

march_arm73:                                      ; preds = %march_next61
  %pgocount42 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %59 = add i64 %pgocount42, 1
  store i64 %59, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %60 = add i64 %pgocount43, 1
  store i64 %60, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %61 = call i32 @puts(ptr @.str.6)
  %widen76 = sext i32 %61 to i64
  store i64 0, ptr %match_stmt_discard59, align 8
  br label %match_end58

march_next74:                                     ; preds = %march_next61
  call void @forge_match_unreachable(ptr @.match_fn.7, i64 %tag57, ptr @mu_file.8, i64 25)
  unreachable

match_end80:                                      ; preds = %march_arm95, %march_arm82
  %62 = call i32 @forge_test_summary()
  %widen99 = sext i32 %62 to i64
  call void @forge_rc_collect()
  ret i64 0

march_arm82:                                      ; preds = %match_end58
  %pay_slot85 = getelementptr inbounds nuw %Result, ptr %r277, i32 0, i32 1
  %payload86 = load ptr, ptr %pay_slot85, align 8
  %v_slot_base87 = ptrtoint ptr %payload86 to i64
  %v_slot_addr88 = add i64 %v_slot_base87, 0
  %v_slot89 = inttoptr i64 %v_slot_addr88 to ptr
  %v90 = load i64, ptr %v_slot89, align 8
  store i64 %v90, ptr %v91, align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %63 = add i64 %pgocount44, 1
  store i64 %63, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %64 = add i64 %pgocount45, 1
  store i64 %64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %65 = add i64 %pgocount46, 1
  store i64 %65, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %66 = add i64 %pgocount47, 1
  store i64 %66, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %v92 = load i64, ptr %v91, align 8
  %67 = call ptr @forge_rc_alloc(i64 32)
  %68 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %67, i64 32, ptr @.i2s_fmt.9, i64 %v92)
  %widen93 = sext i32 %68 to i64
  %69 = call i32 @puts(ptr %67)
  %widen94 = sext i32 %69 to i64
  store i64 0, ptr %match_stmt_discard81, align 8
  br label %match_end80

march_next83:                                     ; preds = %match_end58
  %tag_eq97 = icmp eq i64 %tag79, 193456014
  br i1 %tag_eq97, label %march_arm95, label %march_next96

march_arm95:                                      ; preds = %march_next83
  %pgocount48 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %70 = add i64 %pgocount48, 1
  store i64 %70, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %71 = add i64 %pgocount49, 1
  store i64 %71, ptr getelementptr inbounds ([67 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %72 = call i32 @puts(ptr @.str.10)
  %widen98 = sext i32 %72 to i64
  store i64 0, ptr %match_stmt_discard81, align 8
  br label %match_end80

march_next96:                                     ; preds = %march_next83
  call void @forge_match_unreachable(ptr @.match_fn.11, i64 %tag79, ptr @mu_file.12, i64 29)
  unreachable
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
