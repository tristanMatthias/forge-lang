; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/impl_enum.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Shape = type { i64, ptr }

@c = global i64 0
@r = global i64 0
@.match_fn = private unnamed_addr constant [12 x i8] c"Shape__area\00", align 1
@mu_file = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/impl_enum.fg\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"circle r=\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"rect \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.5 = private unnamed_addr constant [16 x i8] c"Shape__describe\00", align 1
@mu_file.6 = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/impl_enum.fg\00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"area\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/impl_enum.fg\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.8 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@sty_name.9 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.10 = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/impl_enum.fg\00", align 1
@fld_name.11 = private unnamed_addr constant [5 x i8] c"area\00", align 1
@sty_name.12 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.13 = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/impl_enum.fg\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.15 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@sty_name.16 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.17 = private unnamed_addr constant [135 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/impl_enum.fg\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_Shape__area = private global [13 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_Shape__area = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 1058036232716685618, i64 -4601996775950533619, i64 sub (i64 ptrtoint (ptr @__profc_Shape__area to i64), i64 ptrtoint (ptr @__profd_Shape__area to i64)), i64 0, ptr null, ptr null, i32 13, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_Shape__describe = private global [21 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_Shape__describe = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2408407330916183793, i64 -6257116434346796011, i64 sub (i64 ptrtoint (ptr @__profc_Shape__describe to i64), i64 ptrtoint (ptr @__profd_Shape__describe to i64)), i64 0, ptr null, ptr null, i32 21, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [46 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 46, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [37 x i8] c" #x\DA\0B\CEH,H\8D\8FO,JMd\0C\86\B0SR\8B\93\8B2\93R\19s\133\F3\00\C4\1E\0B\E0", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [4 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_Shape__area, ptr @__profd_Shape__describe, ptr @__profd_main], section "llvm.metadata"
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

define i64 @Shape__area(ptr %0) {
entry:
  %h14 = alloca i64, align 8
  %w11 = alloca i64, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %self = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_Shape__area, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_Shape__area, align 8
  store ptr %0, ptr %self, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 2), align 8
  %self1 = load ptr, ptr %self, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 6), align 8
  %r3 = load i64, ptr %r2, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 7), align 8
  %r4 = load i64, ptr %r2, align 8
  %mul = mul i64 %r3, %r4
  %pgocount8 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 8), align 8
  %mul5 = mul i64 %mul, 3
  store i64 %mul5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %w_slot_base = ptrtoint ptr %payload10 to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load i64, ptr %w_slot, align 8
  store i64 %w, ptr %w11, align 8
  %pay_slot12 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload13 = load ptr, ptr %pay_slot12, align 8
  %h_slot_base = ptrtoint ptr %payload13 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h14, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 11), align 8
  %w15 = load i64, ptr %w11, align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 12), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([13 x i64], ptr @__profc_Shape__area, i32 0, i32 12), align 8
  %h16 = load i64, ptr %h14, align 8
  %mul17 = mul i64 %w15, %h16
  store i64 %mul17, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define ptr @Shape__describe(ptr %0) {
entry:
  %h14 = alloca i64, align 8
  %w11 = alloca i64, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %self = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_Shape__describe, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_Shape__describe, align 8
  store ptr %0, ptr %self, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 2), align 8
  %self1 = load ptr, ptr %self, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast38 = inttoptr i64 %match_val to ptr
  ret ptr %cast38

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 8), align 8
  %r3 = load i64, ptr %r2, align 8
  %10 = call ptr @forge_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt, i64 %r3)
  %widen = sext i32 %11 to i64
  %12 = call i64 @strlen(ptr @.str)
  %13 = call i64 @strlen(ptr %10)
  %concat_total = add i64 %12, %13
  %concat_size = add i64 %concat_total, 1
  %14 = call ptr @forge_rc_alloc(i64 %concat_size)
  %15 = call ptr @memcpy(ptr %14, ptr @.str, i64 %12)
  %cast = ptrtoint ptr %14 to i64
  %dst2_int = add i64 %cast, %12
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast4, ptr %10, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %14 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %w_slot_base = ptrtoint ptr %payload10 to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load i64, ptr %w_slot, align 8
  store i64 %w, ptr %w11, align 8
  %pay_slot12 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload13 = load ptr, ptr %pay_slot12, align 8
  %h_slot_base = ptrtoint ptr %payload13 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h14, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 9), align 8
  %17 = add i64 %pgocount9, 1
  store i64 %17, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 10), align 8
  %18 = add i64 %pgocount10, 1
  store i64 %18, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 11), align 8
  %19 = add i64 %pgocount11, 1
  store i64 %19, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 12), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 13), align 8
  %21 = add i64 %pgocount13, 1
  store i64 %21, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 14), align 8
  %22 = add i64 %pgocount14, 1
  store i64 %22, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 15), align 8
  %23 = add i64 %pgocount15, 1
  store i64 %23, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 16), align 8
  %24 = add i64 %pgocount16, 1
  store i64 %24, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 16), align 8
  %w15 = load i64, ptr %w11, align 8
  %25 = call ptr @forge_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.2, i64 %w15)
  %widen16 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr @.str.1)
  %28 = call i64 @strlen(ptr %25)
  %concat_total17 = add i64 %27, %28
  %concat_size18 = add i64 %concat_total17, 1
  %29 = call ptr @forge_rc_alloc(i64 %concat_size18)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.1, i64 %27)
  %cast19 = ptrtoint ptr %29 to i64
  %dst2_int20 = add i64 %cast19, %27
  %cast21 = inttoptr i64 %dst2_int20 to ptr
  %rhs_len_p122 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast21, ptr %25, i64 %rhs_len_p122)
  %pgocount17 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 17), align 8
  %32 = add i64 %pgocount17, 1
  store i64 %32, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 17), align 8
  %33 = call i64 @strlen(ptr %29)
  %34 = call i64 @strlen(ptr @.str.3)
  %concat_total23 = add i64 %33, %34
  %concat_size24 = add i64 %concat_total23, 1
  %35 = call ptr @forge_rc_alloc(i64 %concat_size24)
  %36 = call ptr @memcpy(ptr %35, ptr %29, i64 %33)
  %cast25 = ptrtoint ptr %35 to i64
  %dst2_int26 = add i64 %cast25, %33
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %34, 1
  %37 = call ptr @memcpy(ptr %cast27, ptr @.str.3, i64 %rhs_len_p128)
  %pgocount18 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 18), align 8
  %38 = add i64 %pgocount18, 1
  store i64 %38, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 19), align 8
  %39 = add i64 %pgocount19, 1
  store i64 %39, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 20), align 8
  %40 = add i64 %pgocount20, 1
  store i64 %40, ptr getelementptr inbounds ([21 x i64], ptr @__profc_Shape__describe, i32 0, i32 20), align 8
  %h29 = load i64, ptr %h14, align 8
  %41 = call ptr @forge_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt.4, i64 %h29)
  %widen30 = sext i32 %42 to i64
  %43 = call i64 @strlen(ptr %35)
  %44 = call i64 @strlen(ptr %41)
  %concat_total31 = add i64 %43, %44
  %concat_size32 = add i64 %concat_total31, 1
  %45 = call ptr @forge_rc_alloc(i64 %concat_size32)
  %46 = call ptr @memcpy(ptr %45, ptr %35, i64 %43)
  %cast33 = ptrtoint ptr %45 to i64
  %dst2_int34 = add i64 %cast33, %43
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast35, ptr %41, i64 %rhs_len_p136)
  %cast37 = ptrtoint ptr %45 to i64
  store i64 %cast37, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 16)
  unreachable
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %3 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %3, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %3, i32 0, i32 1
  %4 = call ptr @forge_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %3 to i64
  store i64 %cast, ptr @c, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Shape, ptr %7, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Shape, ptr %7, i32 0, i32 1
  %8 = call ptr @forge_rc_alloc(i64 16)
  store ptr %8, ptr %pay_ptr2, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %slot_base3 = ptrtoint ptr %8 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 4, ptr %slot5, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %slot_base6 = ptrtoint ptr %8 to i64
  %slot_addr7 = add i64 %slot_base6, 8
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store i64 6, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %7 to i64
  store i64 %cast9, ptr @r, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %c = load ptr, ptr @c, align 8
  %cast10 = ptrtoint ptr %c to i64
  %null_chk = icmp eq i64 %cast10, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 134, i64 26)
  %16 = call i64 @Shape__area(ptr %c)
  %17 = call ptr @forge_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.7, i64 %16)
  %widen = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen11 = sext i32 %19 to i64
  %pgocount12 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %21 = add i64 %pgocount13, 1
  store i64 %21, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %22 = add i64 %pgocount14, 1
  store i64 %22, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %23 = add i64 %pgocount15, 1
  store i64 %23, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %c12 = load ptr, ptr @c, align 8
  %cast13 = ptrtoint ptr %c12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @forge_null_deref_trap(ptr @fld_name.8, i64 8, ptr @sty_name.9, i64 5, i64 %null_ext15, ptr @src_file.10, i64 134, i64 27)
  %24 = call ptr @Shape__describe(ptr %c12)
  %25 = call i32 @puts(ptr %24)
  %widen16 = sext i32 %25 to i64
  %pgocount16 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %26 = add i64 %pgocount16, 1
  store i64 %26, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %27 = add i64 %pgocount17, 1
  store i64 %27, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %28 = add i64 %pgocount18, 1
  store i64 %28, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %29 = add i64 %pgocount19, 1
  store i64 %29, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %30 = add i64 %pgocount20, 1
  store i64 %30, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %r = load ptr, ptr @r, align 8
  %cast17 = ptrtoint ptr %r to i64
  %null_chk18 = icmp eq i64 %cast17, 0
  %null_ext19 = zext i1 %null_chk18 to i64
  call void @forge_null_deref_trap(ptr @fld_name.11, i64 4, ptr @sty_name.12, i64 5, i64 %null_ext19, ptr @src_file.13, i64 134, i64 28)
  %31 = call i64 @Shape__area(ptr %r)
  %32 = call ptr @forge_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.14, i64 %31)
  %widen20 = sext i32 %33 to i64
  %34 = call i32 @puts(ptr %32)
  %widen21 = sext i32 %34 to i64
  %pgocount21 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %35 = add i64 %pgocount21, 1
  store i64 %35, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %36 = add i64 %pgocount22, 1
  store i64 %36, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %37 = add i64 %pgocount23, 1
  store i64 %37, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %38 = add i64 %pgocount24, 1
  store i64 %38, ptr getelementptr inbounds ([46 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %r22 = load ptr, ptr @r, align 8
  %cast23 = ptrtoint ptr %r22 to i64
  %null_chk24 = icmp eq i64 %cast23, 0
  %null_ext25 = zext i1 %null_chk24 to i64
  call void @forge_null_deref_trap(ptr @fld_name.15, i64 8, ptr @sty_name.16, i64 5, i64 %null_ext25, ptr @src_file.17, i64 134, i64 29)
  %39 = call ptr @Shape__describe(ptr %r22)
  %40 = call i32 @puts(ptr %39)
  %widen26 = sext i32 %40 to i64
  %41 = call i32 @forge_test_summary()
  %widen27 = sext i32 %41 to i64
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
