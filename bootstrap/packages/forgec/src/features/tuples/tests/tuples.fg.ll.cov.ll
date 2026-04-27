; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/tuples/tests/tuples.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@pair = global i64 0
@triple = global i64 0
@mixed = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [52 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 52, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
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
  %y48 = alloca i64, align 8
  %x47 = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %1 = call ptr @forge_rc_alloc(i64 16)
  %pgocount1 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 10, ptr %slot, align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %slot_base1 = ptrtoint ptr %1 to i64
  %slot_addr2 = add i64 %slot_base1, 8
  %slot3 = inttoptr i64 %slot_addr2 to ptr
  store i64 20, ptr %slot3, align 8
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr @pair, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pair = load ptr, ptr @pair, align 8
  %tup_val_slot_base = ptrtoint ptr %pair to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  %9 = call ptr @forge_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt, i64 %tup_val)
  %widen = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen4 = sext i32 %11 to i64
  %pgocount8 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %16 = add i64 %pgocount12, 1
  store i64 %16, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pair5 = load ptr, ptr @pair, align 8
  %tup_val_slot_base6 = ptrtoint ptr %pair5 to i64
  %tup_val_slot_addr7 = add i64 %tup_val_slot_base6, 8
  %tup_val_slot8 = inttoptr i64 %tup_val_slot_addr7 to ptr
  %tup_val9 = load i64, ptr %tup_val_slot8, align 8
  %17 = call ptr @forge_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.1, i64 %tup_val9)
  %widen10 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen11 = sext i32 %19 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %20 = add i64 %pgocount13, 1
  store i64 %20, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %21 = call ptr @forge_rc_alloc(i64 24)
  %pgocount14 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %22 = add i64 %pgocount14, 1
  store i64 %22, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %slot_base12 = ptrtoint ptr %21 to i64
  %slot_addr13 = add i64 %slot_base12, 0
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  store i64 1, ptr %slot14, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %23 = add i64 %pgocount15, 1
  store i64 %23, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %slot_base15 = ptrtoint ptr %21 to i64
  %slot_addr16 = add i64 %slot_base15, 8
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  store i64 2, ptr %slot17, align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %24 = add i64 %pgocount16, 1
  store i64 %24, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %slot_base18 = ptrtoint ptr %21 to i64
  %slot_addr19 = add i64 %slot_base18, 16
  %slot20 = inttoptr i64 %slot_addr19 to ptr
  store i64 3, ptr %slot20, align 8
  %cast21 = ptrtoint ptr %21 to i64
  store i64 %cast21, ptr @triple, align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %25 = add i64 %pgocount17, 1
  store i64 %25, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %26 = add i64 %pgocount18, 1
  store i64 %26, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %27 = add i64 %pgocount19, 1
  store i64 %27, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %28 = add i64 %pgocount20, 1
  store i64 %28, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %29 = add i64 %pgocount21, 1
  store i64 %29, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %30 = add i64 %pgocount22, 1
  store i64 %30, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %31 = add i64 %pgocount23, 1
  store i64 %31, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %triple = load ptr, ptr @triple, align 8
  %tup_val_slot_base22 = ptrtoint ptr %triple to i64
  %tup_val_slot_addr23 = add i64 %tup_val_slot_base22, 0
  %tup_val_slot24 = inttoptr i64 %tup_val_slot_addr23 to ptr
  %tup_val25 = load i64, ptr %tup_val_slot24, align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %32 = add i64 %pgocount24, 1
  store i64 %32, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %33 = add i64 %pgocount25, 1
  store i64 %33, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %triple26 = load ptr, ptr @triple, align 8
  %tup_val_slot_base27 = ptrtoint ptr %triple26 to i64
  %tup_val_slot_addr28 = add i64 %tup_val_slot_base27, 8
  %tup_val_slot29 = inttoptr i64 %tup_val_slot_addr28 to ptr
  %tup_val30 = load i64, ptr %tup_val_slot29, align 8
  %add = add i64 %tup_val25, %tup_val30
  %pgocount26 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %34 = add i64 %pgocount26, 1
  store i64 %34, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %35 = add i64 %pgocount27, 1
  store i64 %35, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %triple31 = load ptr, ptr @triple, align 8
  %tup_val_slot_base32 = ptrtoint ptr %triple31 to i64
  %tup_val_slot_addr33 = add i64 %tup_val_slot_base32, 16
  %tup_val_slot34 = inttoptr i64 %tup_val_slot_addr33 to ptr
  %tup_val35 = load i64, ptr %tup_val_slot34, align 8
  %add36 = add i64 %add, %tup_val35
  %36 = call ptr @forge_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.2, i64 %add36)
  %widen37 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen38 = sext i32 %38 to i64
  %pgocount28 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %39 = add i64 %pgocount28, 1
  store i64 %39, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %40 = add i64 %pgocount29, 1
  store i64 %40, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %41 = call ptr @forge_rc_alloc(i64 16)
  %pgocount30 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %42 = add i64 %pgocount30, 1
  store i64 %42, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %slot_base39 = ptrtoint ptr %41 to i64
  %slot_addr40 = add i64 %slot_base39, 0
  %slot41 = inttoptr i64 %slot_addr40 to ptr
  store i64 100, ptr %slot41, align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %43 = add i64 %pgocount31, 1
  store i64 %43, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %slot_base42 = ptrtoint ptr %41 to i64
  %slot_addr43 = add i64 %slot_base42, 8
  %slot44 = inttoptr i64 %slot_addr43 to ptr
  store i64 200, ptr %slot44, align 8
  %cast45 = ptrtoint ptr %41 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  %x_slot_base = ptrtoint ptr %cast46 to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x47, align 8
  %y_slot_base = ptrtoint ptr %cast46 to i64
  %y_slot_addr = add i64 %y_slot_base, 8
  %y_slot = inttoptr i64 %y_slot_addr to ptr
  %y = load i64, ptr %y_slot, align 8
  store i64 %y, ptr %y48, align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %44 = add i64 %pgocount32, 1
  store i64 %44, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %45 = add i64 %pgocount33, 1
  store i64 %45, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %46 = add i64 %pgocount34, 1
  store i64 %46, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %47 = add i64 %pgocount35, 1
  store i64 %47, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %x49 = load i64, ptr %x47, align 8
  %48 = call ptr @forge_rc_alloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @.i2s_fmt.3, i64 %x49)
  %widen50 = sext i32 %49 to i64
  %50 = call i32 @puts(ptr %48)
  %widen51 = sext i32 %50 to i64
  %pgocount36 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %51 = add i64 %pgocount36, 1
  store i64 %51, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %52 = add i64 %pgocount37, 1
  store i64 %52, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %53 = add i64 %pgocount38, 1
  store i64 %53, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %54 = add i64 %pgocount39, 1
  store i64 %54, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %y52 = load i64, ptr %y48, align 8
  %55 = call ptr @forge_rc_alloc(i64 32)
  %56 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %55, i64 32, ptr @.i2s_fmt.4, i64 %y52)
  %widen53 = sext i32 %56 to i64
  %57 = call i32 @puts(ptr %55)
  %widen54 = sext i32 %57 to i64
  %pgocount40 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %58 = add i64 %pgocount40, 1
  store i64 %58, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %59 = call ptr @forge_rc_alloc(i64 16)
  %pgocount41 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %60 = add i64 %pgocount41, 1
  store i64 %60, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %slot_base55 = ptrtoint ptr %59 to i64
  %slot_addr56 = add i64 %slot_base55, 0
  %slot57 = inttoptr i64 %slot_addr56 to ptr
  store i64 42, ptr %slot57, align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %61 = add i64 %pgocount42, 1
  store i64 %61, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %slot_base58 = ptrtoint ptr %59 to i64
  %slot_addr59 = add i64 %slot_base58, 8
  %slot60 = inttoptr i64 %slot_addr59 to ptr
  store i64 ptrtoint (ptr @.str to i64), ptr %slot60, align 8
  %cast61 = ptrtoint ptr %59 to i64
  store i64 %cast61, ptr @mixed, align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %62 = add i64 %pgocount43, 1
  store i64 %62, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %63 = add i64 %pgocount44, 1
  store i64 %63, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %64 = add i64 %pgocount45, 1
  store i64 %64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %65 = add i64 %pgocount46, 1
  store i64 %65, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %66 = add i64 %pgocount47, 1
  store i64 %66, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %mixed = load ptr, ptr @mixed, align 8
  %tup_val_slot_base62 = ptrtoint ptr %mixed to i64
  %tup_val_slot_addr63 = add i64 %tup_val_slot_base62, 0
  %tup_val_slot64 = inttoptr i64 %tup_val_slot_addr63 to ptr
  %tup_val65 = load i64, ptr %tup_val_slot64, align 8
  %67 = call ptr @forge_rc_alloc(i64 32)
  %68 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %67, i64 32, ptr @.i2s_fmt.5, i64 %tup_val65)
  %widen66 = sext i32 %68 to i64
  %69 = call i32 @puts(ptr %67)
  %widen67 = sext i32 %69 to i64
  %pgocount48 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %70 = add i64 %pgocount48, 1
  store i64 %70, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %71 = add i64 %pgocount49, 1
  store i64 %71, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %72 = add i64 %pgocount50, 1
  store i64 %72, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %73 = add i64 %pgocount51, 1
  store i64 %73, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %mixed68 = load ptr, ptr @mixed, align 8
  %tup_val_slot_base69 = ptrtoint ptr %mixed68 to i64
  %tup_val_slot_addr70 = add i64 %tup_val_slot_base69, 8
  %tup_val_slot71 = inttoptr i64 %tup_val_slot_addr70 to ptr
  %tup_val72 = load i64, ptr %tup_val_slot71, align 8
  %cast73 = inttoptr i64 %tup_val72 to ptr
  %74 = call i32 @puts(ptr %cast73)
  %widen74 = sext i32 %74 to i64
  %75 = call i32 @forge_test_summary()
  %widen75 = sext i32 %75 to i64
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
