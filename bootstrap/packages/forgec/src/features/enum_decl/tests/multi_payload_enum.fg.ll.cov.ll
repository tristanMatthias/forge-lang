; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/multi_payload_enum.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Result = type { i64, ptr }
%Result__Err = type { i64, ptr }

@ok = global i64 0
@err = global i64 0
@.str = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/multi_payload_enum.fg\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.match_fn.5 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.6 = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/multi_payload_enum.fg\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [31 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 31, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
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
  %msg60 = alloca ptr, align 8
  %code53 = alloca i64, align 8
  %v40 = alloca i64, align 8
  %match_stmt_discard30 = alloca i64, align 8
  %msg22 = alloca ptr, align 8
  %code19 = alloca i64, align 8
  %v11 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr @ok, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Result, ptr %6, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Result, ptr %6, i32 0, i32 1
  %7 = call ptr @forge_rc_alloc(i64 16)
  store ptr %7, ptr %pay_ptr2, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %8 = add i64 %pgocount4, 1
  store i64 %8, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %slot_base3 = ptrtoint ptr %7 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 404, ptr %slot5, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %slot_base6 = ptrtoint ptr %7 to i64
  %slot_addr7 = add i64 %slot_base6, 8
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store ptr @.str, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %6 to i64
  store i64 %cast9, ptr @err, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %ok = load ptr, ptr @ok, align 8
  %tag_ptr10 = getelementptr inbounds nuw %Result, ptr %ok, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr10, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm14, %march_arm
  %pgocount8 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %err = load ptr, ptr @err, align 8
  %tag_ptr27 = getelementptr inbounds nuw %Result, ptr %err, i32 0, i32 0
  %tag28 = load i64, ptr %tag_ptr27, align 8
  %tag_eq33 = icmp eq i64 %tag28, 5862623
  br i1 %tag_eq33, label %march_arm31, label %march_next32

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %ok, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v11, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %16 = add i64 %pgocount12, 1
  store i64 %16, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %17 = add i64 %pgocount13, 1
  store i64 %17, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %v12 = load i64, ptr %v11, align 8
  %18 = call ptr @forge_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt, i64 %v12)
  %widen = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen13 = sext i32 %20 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq16 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq16, label %march_arm14, label %march_next15

march_arm14:                                      ; preds = %march_next
  %pay_slot17 = getelementptr inbounds nuw %Result, ptr %ok, i32 0, i32 1
  %payload18 = load ptr, ptr %pay_slot17, align 8
  %code_slot_base = ptrtoint ptr %payload18 to i64
  %code_slot_addr = add i64 %code_slot_base, 0
  %code_slot = inttoptr i64 %code_slot_addr to ptr
  %code = load i64, ptr %code_slot, align 8
  store i64 %code, ptr %code19, align 8
  %pay_slot20 = getelementptr inbounds nuw %Result, ptr %ok, i32 0, i32 1
  %payload21 = load ptr, ptr %pay_slot20, align 8
  %msg_slot_base = ptrtoint ptr %payload21 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 8
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @forge_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg22, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %21 = add i64 %pgocount14, 1
  store i64 %21, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %22 = add i64 %pgocount15, 1
  store i64 %22, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %23 = add i64 %pgocount16, 1
  store i64 %23, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %24 = add i64 %pgocount17, 1
  store i64 %24, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %25 = add i64 %pgocount18, 1
  store i64 %25, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %msg23 = load ptr, ptr %msg22, align 8
  %26 = call i64 @strlen(ptr @.str.1)
  %27 = call i64 @strlen(ptr %msg23)
  %concat_total = add i64 %26, %27
  %concat_size = add i64 %concat_total, 1
  %28 = call ptr @forge_rc_alloc(i64 %concat_size)
  %29 = call ptr @memcpy(ptr %28, ptr @.str.1, i64 %26)
  %cast24 = ptrtoint ptr %28 to i64
  %dst2_int = add i64 %cast24, %26
  %cast25 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %27, 1
  %30 = call ptr @memcpy(ptr %cast25, ptr %msg23, i64 %rhs_len_p1)
  %31 = call i32 @puts(ptr %28)
  %widen26 = sext i32 %31 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next15:                                     ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 10)
  unreachable

match_end29:                                      ; preds = %march_arm44, %march_arm31
  %32 = call i32 @forge_test_summary()
  %widen77 = sext i32 %32 to i64
  call void @forge_rc_collect()
  ret i64 0

march_arm31:                                      ; preds = %match_end
  %pay_slot34 = getelementptr inbounds nuw %Result, ptr %err, i32 0, i32 1
  %payload35 = load ptr, ptr %pay_slot34, align 8
  %v_slot_base36 = ptrtoint ptr %payload35 to i64
  %v_slot_addr37 = add i64 %v_slot_base36, 0
  %v_slot38 = inttoptr i64 %v_slot_addr37 to ptr
  %v39 = load i64, ptr %v_slot38, align 8
  store i64 %v39, ptr %v40, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %33 = add i64 %pgocount19, 1
  store i64 %33, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %34 = add i64 %pgocount20, 1
  store i64 %34, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %35 = add i64 %pgocount21, 1
  store i64 %35, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %36 = add i64 %pgocount22, 1
  store i64 %36, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %v41 = load i64, ptr %v40, align 8
  %37 = call ptr @forge_rc_alloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @.i2s_fmt.2, i64 %v41)
  %widen42 = sext i32 %38 to i64
  %39 = call i32 @puts(ptr %37)
  %widen43 = sext i32 %39 to i64
  store i64 0, ptr %match_stmt_discard30, align 8
  br label %match_end29

march_next32:                                     ; preds = %match_end
  %tag_eq46 = icmp eq i64 %tag28, 193456014
  br i1 %tag_eq46, label %march_arm44, label %march_next45

march_arm44:                                      ; preds = %march_next32
  %pay_slot47 = getelementptr inbounds nuw %Result, ptr %err, i32 0, i32 1
  %payload48 = load ptr, ptr %pay_slot47, align 8
  %code_slot_base49 = ptrtoint ptr %payload48 to i64
  %code_slot_addr50 = add i64 %code_slot_base49, 0
  %code_slot51 = inttoptr i64 %code_slot_addr50 to ptr
  %code52 = load i64, ptr %code_slot51, align 8
  store i64 %code52, ptr %code53, align 8
  %pay_slot54 = getelementptr inbounds nuw %Result, ptr %err, i32 0, i32 1
  %payload55 = load ptr, ptr %pay_slot54, align 8
  %msg_slot_base56 = ptrtoint ptr %payload55 to i64
  %msg_slot_addr57 = add i64 %msg_slot_base56, 8
  %msg_slot58 = inttoptr i64 %msg_slot_addr57 to ptr
  %msg59 = load ptr, ptr %msg_slot58, align 8
  call void @forge_rc_retain(ptr %msg59)
  store ptr %msg59, ptr %msg60, align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %40 = add i64 %pgocount23, 1
  store i64 %40, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %41 = add i64 %pgocount24, 1
  store i64 %41, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %42 = add i64 %pgocount25, 1
  store i64 %42, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %43 = add i64 %pgocount26, 1
  store i64 %43, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %44 = add i64 %pgocount27, 1
  store i64 %44, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %45 = add i64 %pgocount28, 1
  store i64 %45, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %code61 = load i64, ptr %code53, align 8
  %46 = call ptr @forge_rc_alloc(i64 32)
  %47 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %46, i64 32, ptr @.i2s_fmt.3, i64 %code61)
  %widen62 = sext i32 %47 to i64
  %pgocount29 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %48 = add i64 %pgocount29, 1
  store i64 %48, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %49 = call i64 @strlen(ptr %46)
  %50 = call i64 @strlen(ptr @.str.4)
  %concat_total63 = add i64 %49, %50
  %concat_size64 = add i64 %concat_total63, 1
  %51 = call ptr @forge_rc_alloc(i64 %concat_size64)
  %52 = call ptr @memcpy(ptr %51, ptr %46, i64 %49)
  %cast65 = ptrtoint ptr %51 to i64
  %dst2_int66 = add i64 %cast65, %49
  %cast67 = inttoptr i64 %dst2_int66 to ptr
  %rhs_len_p168 = add i64 %50, 1
  %53 = call ptr @memcpy(ptr %cast67, ptr @.str.4, i64 %rhs_len_p168)
  %pgocount30 = load i64, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %54 = add i64 %pgocount30, 1
  store i64 %54, ptr getelementptr inbounds ([31 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %msg69 = load ptr, ptr %msg60, align 8
  %55 = call i64 @strlen(ptr %51)
  %56 = call i64 @strlen(ptr %msg69)
  %concat_total70 = add i64 %55, %56
  %concat_size71 = add i64 %concat_total70, 1
  %57 = call ptr @forge_rc_alloc(i64 %concat_size71)
  %58 = call ptr @memcpy(ptr %57, ptr %51, i64 %55)
  %cast72 = ptrtoint ptr %57 to i64
  %dst2_int73 = add i64 %cast72, %55
  %cast74 = inttoptr i64 %dst2_int73 to ptr
  %rhs_len_p175 = add i64 %56, 1
  %59 = call ptr @memcpy(ptr %cast74, ptr %msg69, i64 %rhs_len_p175)
  %60 = call i32 @puts(ptr %57)
  %widen76 = sext i32 %60 to i64
  store i64 0, ptr %match_stmt_discard30, align 8
  br label %match_end29

march_next45:                                     ; preds = %march_next32
  call void @forge_match_unreachable(ptr @.match_fn.5, i64 %tag28, ptr @mu_file.6, i64 15)
  unreachable
}

define i64 @__release_Result(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %fields_done, %alive
  ret i64 0

fields_done:                                      ; preds = %vrel_msg_skip, %try_next_Err
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %Result__Err, ptr %payload, i32 0, i32 1
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_Err:                                     ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_Err
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_Err
  call void @forge_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
