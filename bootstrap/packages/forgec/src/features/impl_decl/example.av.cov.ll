; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/example.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Counter = type { i64 }

@fld_name = private unnamed_addr constant [6 x i8] c"count\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/example.fg\00", align 1
@fld_name.1 = private unnamed_addr constant [6 x i8] c"count\00", align 1
@sty_name.2 = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file.3 = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/example.fg\00", align 1
@fld_name.4 = private unnamed_addr constant [10 x i8] c"increment\00", align 1
@sty_name.5 = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file.6 = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/example.fg\00", align 1
@fld_name.7 = private unnamed_addr constant [10 x i8] c"increment\00", align 1
@sty_name.8 = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file.9 = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/example.fg\00", align 1
@fld_name.10 = private unnamed_addr constant [10 x i8] c"increment\00", align 1
@sty_name.11 = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file.12 = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/example.fg\00", align 1
@fld_name.13 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.14 = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file.15 = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/impl_decl/example.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_Counter__increment = private global [8 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_Counter__increment = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2717599406562691213, i64 -7275352136826167448, i64 sub (i64 ptrtoint (ptr @__profc_Counter__increment to i64), i64 ptrtoint (ptr @__profd_Counter__increment to i64)), i64 0, ptr null, ptr null, i32 8, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_Counter__value = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_Counter__value = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 5804304477097601894, i64 -7862497964886730720, i64 sub (i64 ptrtoint (ptr @__profc_Counter__value to i64), i64 ptrtoint (ptr @__profd_Counter__value to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [18 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 18, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [20 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 20, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [57 x i8] c"57x\DAs\CE/\CD+I-\8A\8F\CF\CCK.J\CDM\CD+at\86\09\95%\E6\94\A62\E6&f\E61\C6\C7'\15\C7\97\E4\17\C4\E7\A4\96\A5\E6\00\00,c\14\83", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [5 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_Counter__increment, ptr @__profd_Counter__value, ptr @__profd_main, ptr @__profd___bs_top_level], section "llvm.metadata"
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

define i64 @Counter__increment(ptr %0) {
entry:
  %self = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_Counter__increment, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_Counter__increment, align 8
  store ptr %0, ptr %self, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 3), align 8
  %self1 = load ptr, ptr %self, align 8
  %fa_fld = getelementptr inbounds nuw %Counter, ptr %self1, i32 0, i32 0
  %pgocount4 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 6), align 8
  %self2 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self2 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 126, i64 9)
  %count_ptr = getelementptr inbounds nuw %Counter, ptr %self2, i32 0, i32 0
  %count = load i64, ptr %count_ptr, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([8 x i64], ptr @__profc_Counter__increment, i32 0, i32 7), align 8
  %add = add i64 %count, 1
  store i64 %add, ptr %fa_fld, align 8
  ret i64 %add
}

define i64 @Counter__value(ptr %0) {
entry:
  %self = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_Counter__value, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_Counter__value, align 8
  store ptr %0, ptr %self, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_Counter__value, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc_Counter__value, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_Counter__value, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_Counter__value, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_Counter__value, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_Counter__value, i32 0, i32 3), align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.1, i64 5, ptr @sty_name.2, i64 7, i64 %null_ext, ptr @src_file.3, i64 126, i64 13)
  %count_ptr = getelementptr inbounds nuw %Counter, ptr %self1, i32 0, i32 0
  %count = load i64, ptr %count_ptr, align 8
  ret i64 %count
}

define i64 @main() {
entry:
  %c = alloca ptr, align 8
  %c_copy = alloca %Counter, align 8
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
  %fld_ptr = getelementptr inbounds nuw %Counter, ptr %c_copy, i32 0, i32 0
  store i64 0, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %c_copy to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %c, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %6 = add i64 %pgocount6, 1
  store i64 %6, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %c2 = load ptr, ptr %c, align 8
  %cast3 = ptrtoint ptr %c2 to i64
  %null_chk = icmp eq i64 %cast3, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.4, i64 9, ptr @sty_name.5, i64 7, i64 %null_ext, ptr @src_file.6, i64 126, i64 19)
  %7 = call i64 @Counter__increment(ptr %c2)
  %pgocount7 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %c4 = load ptr, ptr %c, align 8
  %cast5 = ptrtoint ptr %c4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @forge_null_deref_trap(ptr @fld_name.7, i64 9, ptr @sty_name.8, i64 7, i64 %null_ext7, ptr @src_file.9, i64 126, i64 20)
  %11 = call i64 @Counter__increment(ptr %c4)
  %pgocount10 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %12 = add i64 %pgocount10, 1
  store i64 %12, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %13 = add i64 %pgocount11, 1
  store i64 %13, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %14 = add i64 %pgocount12, 1
  store i64 %14, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %c8 = load ptr, ptr %c, align 8
  %cast9 = ptrtoint ptr %c8 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @forge_null_deref_trap(ptr @fld_name.10, i64 9, ptr @sty_name.11, i64 7, i64 %null_ext11, ptr @src_file.12, i64 126, i64 21)
  %15 = call i64 @Counter__increment(ptr %c8)
  %pgocount13 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %16 = add i64 %pgocount13, 1
  store i64 %16, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %17 = add i64 %pgocount14, 1
  store i64 %17, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %18 = add i64 %pgocount15, 1
  store i64 %18, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %19 = add i64 %pgocount16, 1
  store i64 %19, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %20 = add i64 %pgocount17, 1
  store i64 %20, ptr getelementptr inbounds ([18 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %c12 = load ptr, ptr %c, align 8
  %cast13 = ptrtoint ptr %c12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @forge_null_deref_trap(ptr @fld_name.13, i64 5, ptr @sty_name.14, i64 7, i64 %null_ext15, ptr @src_file.15, i64 126, i64 22)
  %21 = call i64 @Counter__value(ptr %c12)
  %22 = call ptr @forge_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt, i64 %21)
  %widen = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen16 = sext i32 %24 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([20 x i64], ptr @__profc___bs_top_level, i32 0, i32 18), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([20 x i64], ptr @__profc___bs_top_level, i32 0, i32 18), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([20 x i64], ptr @__profc___bs_top_level, i32 0, i32 19), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([20 x i64], ptr @__profc___bs_top_level, i32 0, i32 19), align 8
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
