; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Shape = type { i64, ptr }
%Option = type { i64, ptr }
%Tagged = type { ptr, ptr }

@.str = private unnamed_addr constant [7 x i8] c"circle\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"triangle\00", align 1
@.str.3 = private unnamed_addr constant [20 x i8] c"confirmed circle r=\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [11 x i8] c"impossible\00", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"not circle\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/is_combo.av\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [13 x i8] c"both circles\00", align 1
@.str.11 = private unnamed_addr constant [13 x i8] c"not a circle\00", align 1
@.str.12 = private unnamed_addr constant [4 x i8] c"box\00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"form\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Tagged\00", align 1
@src_file = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/is_combo.av\00", align 1
@fld_name.13 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@sty_name.14 = private unnamed_addr constant [7 x i8] c"Tagged\00", align 1
@src_file.15 = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/is_combo.av\00", align 1

declare i32 @puts(ptr)

declare void @avra_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @avra_rc_alloc(i64)

declare void @avra_rc_retain(ptr)

declare void @avra_rc_release(ptr)

declare i64 @avra_rc_should_free(ptr)

declare void @avra_rc_free(ptr)

declare void @avra_rc_suspect(ptr)

declare void @avra_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare i64 @avra_parse_int(ptr)

declare void @exit(i32)

declare void @avra_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @avra_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @avra_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @avra_array_new()

declare void @avra_array_push(ptr, i64)

declare i64 @avra_array_get(ptr, i64)

declare i64 @avra_array_len(ptr)

declare void @avra_array_set(ptr, i64, i64)

declare i64 @avra_array_pop(ptr)

declare ptr @avra_array_slice(ptr, i64, i64)

declare i64 @avra_closure_get_fn(i64)

declare i64 @avra_closure_num_captures(i64)

declare i64 @avra_closure_get_capture(ptr, i64)

declare i64 @avra_closure_call_0(i64)

declare i64 @avra_closure_call_1(i64, i64)

declare i64 @avra_closure_call_2(i64, i64, i64)

declare i64 @avra_closure_call_3(i64, i64, i64, i64)

declare i64 @avra_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @avra_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @avra_array_map(ptr, i64)

declare ptr @avra_array_filter(ptr, i64)

declare void @avra_array_foreach(ptr, i64)

declare i64 @avra_array_reduce(ptr, i64, i64)

declare i64 @avra_array_contains(ptr, i64)

declare i64 @avra_array_index_of(ptr, i64)

declare ptr @avra_array_reverse(ptr)

declare i64 @avra_str_contains(ptr, ptr)

declare i64 @avra_str_starts_with(ptr, ptr)

declare i64 @avra_str_ends_with(ptr, ptr)

declare i64 @avra_str_index_of(ptr, ptr)

declare ptr @avra_str_split(ptr, ptr)

declare ptr @avra_str_replace(ptr, ptr, ptr)

declare ptr @avra_str_trim(ptr)

declare ptr @avra_str_to_upper(ptr)

declare ptr @avra_str_to_lower(ptr)

declare ptr @avra_str_join(ptr, ptr)

declare ptr @avra_str_char_at(ptr, i64)

declare ptr @avra_str_substring(ptr, i64, i64)

declare ptr @avra_str_repeat(ptr, i64)

declare ptr @avra_str_reverse(ptr)

declare ptr @avra_map_new_cstr()

declare void @avra_map_set_cstr(ptr, ptr, i64)

declare i64 @avra_map_get_cstr(ptr, ptr)

declare i64 @avra_map_has_cstr(ptr, ptr)

declare i64 @avra_map_len_cstr(ptr)

declare ptr @avra_map_keys_cstr(ptr)

declare ptr @avra_map_values_cstr(ptr)

declare i64 @avra_map_remove_cstr(ptr, ptr)

declare ptr @avra_file_read(ptr)

declare i64 @avra_file_write(ptr, ptr)

declare i64 @avra_file_exists(ptr)

declare ptr @avra_intmap_new()

declare void @avra_intmap_set(ptr, i64, i64)

declare i64 @avra_intmap_get(ptr, i64)

declare i64 @avra_intmap_has(ptr, i64)

declare i64 @avra_float_parse(ptr)

declare i64 @avra_float_to_string(i64)

declare ptr @avra_format_float(i64, ptr)

declare ptr @avra_format_int(i64, ptr)

declare void @avra_ptr_store_byte(ptr, i64, i64)

declare i64 @avra_string_from_ptr(ptr, i64)

declare i64 @avra_trait_object_new(ptr, i64)

declare i64 @avra_trait_object_value(ptr)

declare ptr @avra_trait_object_vtable(ptr)

declare i64 @avra_datetime_now()

declare i64 @avra_datetime_format(ptr, i64)

declare i64 @avra_datetime_year(ptr)

declare i64 @avra_datetime_month(ptr)

declare i64 @avra_datetime_day(ptr)

declare i64 @avra_datetime_hour(ptr)

declare i64 @avra_datetime_minute(ptr)

declare i64 @avra_datetime_second(ptr)

declare ptr @avra_json_stringify_int(ptr)

declare ptr @avra_json_stringify_string(ptr)

declare ptr @avra_json_stringify_bool(ptr)

declare i64 @avra_json_get_int(ptr, i64)

declare i64 @avra_json_get_string(ptr, i64)

declare i64 @avra_json_get_bool(ptr, i64)

declare i64 @avra_semver_major(ptr)

declare i64 @avra_semver_minor(ptr)

declare i64 @avra_semver_patch(ptr)

declare i64 @avra_semver_compare(ptr, i64)

declare i64 @avra_validate_not_null(ptr, i64)

declare i64 @avra_validate_positive(ptr, i64)

declare i64 @avra_validate_not_empty(ptr, i64)

declare i64 @avra_toml_get_string(ptr, i64)

declare i64 @avra_toml_get_int(ptr, i64)

declare i64 @avra_toml_get_bool(ptr, i64)

declare i64 @avra_toml_get_section_string(ptr, i64, i64)

declare i64 @avra_toml_has_section(ptr, i64)

declare i64 @avra_spawn(ptr)

declare i64 @avra_task_await(ptr)

declare i32 @avra_thread_join(ptr)

declare void @avra_yield()

declare void @avra_scheduler_run()

declare ptr @avra_task_group_new()

declare void @avra_task_group_add(ptr, ptr)

declare void @avra_task_group_await_all(ptr)

declare ptr @avra_channel_new()

declare void @avra_channel_send(ptr, i64)

declare i64 @avra_channel_recv(ptr)

declare i32 @avra_channel_close(ptr)

declare i32 @avra_parallel_run(ptr)

declare i64 @avra_select(ptr, i64)

declare i64 @avra_select_index(ptr)

declare i64 @avra_select_value(ptr)

declare i32 @avra_test_start_spec(ptr)

declare i32 @avra_test_end_spec(ptr)

declare i32 @avra_test_start_given(ptr)

declare i32 @avra_test_end_given(ptr)

declare i64 @avra_test_run_then(ptr, i64)

declare i32 @avra_test_skip(ptr)

declare i32 @avra_test_todo(ptr)

declare i32 @avra_test_summary()

declare void @avra_test_flush()

declare ptr @avra_arena_new()

declare ptr @avra_arena_alloc(ptr, i64)

declare void @avra_arena_destroy(ptr)

declare void @avra_match_unreachable(ptr, i64, ptr, i64)

declare i32 @avra_llvm_is_ptr_value(ptr)

declare ptr @avra_llvm_typeof(ptr)

declare ptr @avra_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @avra_llvm_is_void_value(ptr)

declare void @avra_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @avra_llvm_verify_function(ptr)

declare i64 @avra_llvm_type_kind(ptr)

declare i64 @avra_llvm_int_type_width(ptr)

declare ptr @avra_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @avra_test_roughly(double, double, double)

define ptr @describe(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 6952139942519
  %is_eq_ext = zext i1 %is_eq to i64
  %if_cond = icmp ne i64 %is_eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %s2 = load ptr, ptr %s, align 8
  %tag_ptr3 = getelementptr inbounds nuw %Shape, ptr %s2, i32 0, i32 0
  %tag4 = load i64, ptr %tag_ptr3, align 8
  %is_eq5 = icmp eq i64 %tag4, 6952775702006
  %is_eq_ext6 = zext i1 %is_eq5 to i64
  %if_cond8 = icmp ne i64 %is_eq_ext6, 0
  br i1 %if_cond8, label %if_then9, label %if_else10

if_then:                                          ; preds = %entry
  ret ptr @.str

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont7:                                          ; preds = %if_else10
  ret ptr @.str.2

if_then9:                                         ; preds = %ifcont
  ret ptr @.str.1

if_else10:                                        ; preds = %ifcont
  br label %ifcont7
}

define i1 @is_round_or_none(ptr %0, ptr %1) {
entry:
  %o = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store ptr %1, ptr %o, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 6952139942519
  %is_eq_ext = zext i1 %is_eq to i64
  %l_bool = icmp ne i64 %is_eq_ext, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

sc_rhs:                                           ; preds = %entry
  %o2 = load ptr, ptr %o, align 8
  %tag_ptr3 = getelementptr inbounds nuw %Option, ptr %o2, i32 0, i32 0
  %tag4 = load i64, ptr %tag_ptr3, align 8
  %is_eq5 = icmp eq i64 %tag4, 6384368597
  %is_eq_ext6 = zext i1 %is_eq5 to i64
  %r_bool = icmp ne i64 %is_eq_ext6, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ true, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %cast = trunc i64 %sc_ext to i1
  ret i1 %cast

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge
}

define i64 @count_somes(ptr %0) {
entry:
  %val = alloca ptr, align 8
  %i = alloca i64, align 8
  %count = alloca i64, align 8
  %items = alloca ptr, align 8
  store ptr %0, ptr %items, align 8
  store i64 0, ptr %count, align 8
  store i64 0, ptr %i, align 8
  br label %while.cond

while.cond:                                       ; preds = %ifcont, %entry
  %i1 = load i64, ptr %i, align 8
  %items2 = load ptr, ptr %items, align 8
  %1 = call i64 @avra_array_len(ptr %items2)
  %slt = icmp slt i64 %i1, %1
  %slt_ext = zext i1 %slt to i64
  %while_cond = icmp ne i64 %slt_ext, 0
  br i1 %while_cond, label %while.body, label %while.exit

while.body:                                       ; preds = %while.cond
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Option, ptr %2, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Option, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %items3 = load ptr, ptr %items, align 8
  %i4 = load i64, ptr %i, align 8
  %4 = call i64 @avra_array_get(ptr %items3, i64 %i4)
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %4, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast5 = inttoptr i64 %cast to ptr
  store ptr %cast5, ptr %val, align 8
  %val6 = load ptr, ptr %val, align 8
  %tag_ptr7 = getelementptr inbounds nuw %Option, ptr %val6, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr7, align 8
  %is_eq = icmp eq i64 %tag, 6384548249
  %is_eq_ext = zext i1 %is_eq to i64
  %if_cond = icmp ne i64 %is_eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

while.exit:                                       ; preds = %while.cond
  %count11 = load i64, ptr %count, align 8
  ret i64 %count11

ifcont:                                           ; preds = %if_else, %if_then
  %i9 = load i64, ptr %i, align 8
  %add10 = add i64 %i9, 1
  store i64 %add10, ptr %i, align 8
  br label %while.cond

if_then:                                          ; preds = %while.body
  %count8 = load i64, ptr %count, align 8
  %add = add i64 %count8, 1
  store i64 %add, ptr %count, align 8
  br label %ifcont

if_else:                                          ; preds = %while.body
  br label %ifcont
}

define ptr @classify(ptr %0) {
entry:
  %sif_result = alloca i64, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm9, %sif_end
  %match_val = load i64, ptr %match_result, align 8
  %cast11 = inttoptr i64 %match_val to ptr
  ret ptr %cast11

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %s3 = load ptr, ptr %s, align 8
  %tag_ptr4 = getelementptr inbounds nuw %Shape, ptr %s3, i32 0, i32 0
  %tag5 = load i64, ptr %tag_ptr4, align 8
  %is_eq = icmp eq i64 %tag5, 6952139942519
  %is_eq_ext = zext i1 %is_eq to i64
  %sif_cond = icmp ne i64 %is_eq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next:                                       ; preds = %entry
  br label %march_arm9

sif_then:                                         ; preds = %march_arm
  %r6 = load i64, ptr %r2, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %r6)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.3)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.3, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast7 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast7, ptr %1, i64 %rhs_len_p1)
  %cast8 = ptrtoint ptr %5 to i64
  store i64 %cast8, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end

march_arm9:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %match_result, align 8
  br label %match_end

march_next10:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 33)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %sif_result = alloca i64, align 8
  %tagged = alloca ptr, align 8
  %t = alloca ptr, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %items = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %3 = call ptr @describe(ptr %cast1)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Shape, ptr %5, i32 0, i32 0
  store i64 6952775702006, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Shape, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr3, align 8
  %slot_base4 = ptrtoint ptr %6 to i64
  %slot_addr5 = add i64 %slot_base4, 0
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store i64 3, ptr %slot6, align 8
  %cast7 = ptrtoint ptr %5 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %7 = call ptr @describe(ptr %cast8)
  %8 = call i32 @puts(ptr %7)
  %widen9 = sext i32 %8 to i64
  %9 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Shape, ptr %9, i32 0, i32 0
  store i64 7571616179632859, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %Shape, ptr %9, i32 0, i32 1
  store ptr null, ptr %pay_ptr11, align 8
  %cast12 = ptrtoint ptr %9 to i64
  %cast13 = inttoptr i64 %cast12 to ptr
  %10 = call ptr @describe(ptr %cast13)
  %11 = call i32 @puts(ptr %10)
  %widen14 = sext i32 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr15 = getelementptr inbounds nuw %Shape, ptr %12, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr15, align 8
  %pay_ptr16 = getelementptr inbounds nuw %Shape, ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 8)
  store ptr %13, ptr %pay_ptr16, align 8
  %slot_base17 = ptrtoint ptr %13 to i64
  %slot_addr18 = add i64 %slot_base17, 0
  %slot19 = inttoptr i64 %slot_addr18 to ptr
  store i64 1, ptr %slot19, align 8
  %cast20 = ptrtoint ptr %12 to i64
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr21 = getelementptr inbounds nuw %Option, ptr %14, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr21, align 8
  %pay_ptr22 = getelementptr inbounds nuw %Option, ptr %14, i32 0, i32 1
  store ptr null, ptr %pay_ptr22, align 8
  %cast23 = ptrtoint ptr %14 to i64
  %cast24 = inttoptr i64 %cast20 to ptr
  %cast25 = inttoptr i64 %cast23 to ptr
  %15 = call i1 @is_round_or_none(ptr %cast24, ptr %cast25)
  %widen26 = zext i1 %15 to i64
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.6, i64 %widen26)
  %widen27 = sext i32 %17 to i64
  %18 = call i32 @puts(ptr %16)
  %widen28 = sext i32 %18 to i64
  %19 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr29 = getelementptr inbounds nuw %Shape, ptr %19, i32 0, i32 0
  store i64 6952775702006, ptr %tag_ptr29, align 8
  %pay_ptr30 = getelementptr inbounds nuw %Shape, ptr %19, i32 0, i32 1
  %20 = call ptr @avra_rc_alloc(i64 8)
  store ptr %20, ptr %pay_ptr30, align 8
  %slot_base31 = ptrtoint ptr %20 to i64
  %slot_addr32 = add i64 %slot_base31, 0
  %slot33 = inttoptr i64 %slot_addr32 to ptr
  store i64 1, ptr %slot33, align 8
  %cast34 = ptrtoint ptr %19 to i64
  %21 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr35 = getelementptr inbounds nuw %Option, ptr %21, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr35, align 8
  %pay_ptr36 = getelementptr inbounds nuw %Option, ptr %21, i32 0, i32 1
  %22 = call ptr @avra_rc_alloc(i64 8)
  store ptr %22, ptr %pay_ptr36, align 8
  %slot_base37 = ptrtoint ptr %22 to i64
  %slot_addr38 = add i64 %slot_base37, 0
  %slot39 = inttoptr i64 %slot_addr38 to ptr
  store i64 1, ptr %slot39, align 8
  %cast40 = ptrtoint ptr %21 to i64
  %cast41 = inttoptr i64 %cast34 to ptr
  %cast42 = inttoptr i64 %cast40 to ptr
  %23 = call i1 @is_round_or_none(ptr %cast41, ptr %cast42)
  %widen43 = zext i1 %23 to i64
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.7, i64 %widen43)
  %widen44 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen45 = sext i32 %26 to i64
  %27 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr46 = getelementptr inbounds nuw %Shape, ptr %27, i32 0, i32 0
  store i64 6952775702006, ptr %tag_ptr46, align 8
  %pay_ptr47 = getelementptr inbounds nuw %Shape, ptr %27, i32 0, i32 1
  %28 = call ptr @avra_rc_alloc(i64 8)
  store ptr %28, ptr %pay_ptr47, align 8
  %slot_base48 = ptrtoint ptr %28 to i64
  %slot_addr49 = add i64 %slot_base48, 0
  %slot50 = inttoptr i64 %slot_addr49 to ptr
  store i64 1, ptr %slot50, align 8
  %cast51 = ptrtoint ptr %27 to i64
  %29 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr52 = getelementptr inbounds nuw %Option, ptr %29, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr52, align 8
  %pay_ptr53 = getelementptr inbounds nuw %Option, ptr %29, i32 0, i32 1
  store ptr null, ptr %pay_ptr53, align 8
  %cast54 = ptrtoint ptr %29 to i64
  %cast55 = inttoptr i64 %cast51 to ptr
  %cast56 = inttoptr i64 %cast54 to ptr
  %30 = call i1 @is_round_or_none(ptr %cast55, ptr %cast56)
  %widen57 = zext i1 %30 to i64
  %31 = call ptr @avra_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.8, i64 %widen57)
  %widen58 = sext i32 %32 to i64
  %33 = call i32 @puts(ptr %31)
  %widen59 = sext i32 %33 to i64
  %34 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %34, i64 1)
  call void @avra_array_push(ptr %34, i64 2)
  call void @avra_array_push(ptr %34, i64 3)
  call void @avra_array_push(ptr %34, i64 4)
  call void @avra_array_push(ptr %34, i64 5)
  store ptr %34, ptr %items, align 8
  %items60 = load ptr, ptr %items, align 8
  %35 = call i64 @count_somes(ptr %items60)
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.9, i64 %35)
  %widen61 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen62 = sext i32 %38 to i64
  %39 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr63 = getelementptr inbounds nuw %Shape, ptr %39, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr63, align 8
  %pay_ptr64 = getelementptr inbounds nuw %Shape, ptr %39, i32 0, i32 1
  %40 = call ptr @avra_rc_alloc(i64 8)
  store ptr %40, ptr %pay_ptr64, align 8
  %slot_base65 = ptrtoint ptr %40 to i64
  %slot_addr66 = add i64 %slot_base65, 0
  %slot67 = inttoptr i64 %slot_addr66 to ptr
  store i64 10, ptr %slot67, align 8
  %cast68 = ptrtoint ptr %39 to i64
  %cast69 = inttoptr i64 %cast68 to ptr
  %41 = call ptr @classify(ptr %cast69)
  %42 = call i32 @puts(ptr %41)
  %widen70 = sext i32 %42 to i64
  %43 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr71 = getelementptr inbounds nuw %Shape, ptr %43, i32 0, i32 0
  store i64 7571616179632859, ptr %tag_ptr71, align 8
  %pay_ptr72 = getelementptr inbounds nuw %Shape, ptr %43, i32 0, i32 1
  store ptr null, ptr %pay_ptr72, align 8
  %cast73 = ptrtoint ptr %43 to i64
  %cast74 = inttoptr i64 %cast73 to ptr
  %44 = call ptr @classify(ptr %cast74)
  %45 = call i32 @puts(ptr %44)
  %widen75 = sext i32 %45 to i64
  %46 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr76 = getelementptr inbounds nuw %Shape, ptr %46, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr76, align 8
  %pay_ptr77 = getelementptr inbounds nuw %Shape, ptr %46, i32 0, i32 1
  %47 = call ptr @avra_rc_alloc(i64 8)
  store ptr %47, ptr %pay_ptr77, align 8
  %slot_base78 = ptrtoint ptr %47 to i64
  %slot_addr79 = add i64 %slot_base78, 0
  %slot80 = inttoptr i64 %slot_addr79 to ptr
  store i64 1, ptr %slot80, align 8
  %cast81 = ptrtoint ptr %46 to i64
  %cast82 = inttoptr i64 %cast81 to ptr
  store ptr %cast82, ptr %a, align 8
  %48 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr83 = getelementptr inbounds nuw %Shape, ptr %48, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr83, align 8
  %pay_ptr84 = getelementptr inbounds nuw %Shape, ptr %48, i32 0, i32 1
  %49 = call ptr @avra_rc_alloc(i64 8)
  store ptr %49, ptr %pay_ptr84, align 8
  %slot_base85 = ptrtoint ptr %49 to i64
  %slot_addr86 = add i64 %slot_base85, 0
  %slot87 = inttoptr i64 %slot_addr86 to ptr
  store i64 2, ptr %slot87, align 8
  %cast88 = ptrtoint ptr %48 to i64
  %cast89 = inttoptr i64 %cast88 to ptr
  store ptr %cast89, ptr %b, align 8
  %a90 = load ptr, ptr %a, align 8
  %tag_ptr91 = getelementptr inbounds nuw %Shape, ptr %a90, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr91, align 8
  %is_eq = icmp eq i64 %tag, 6952139942519
  %is_eq_ext = zext i1 %is_eq to i64
  %l_bool = icmp ne i64 %is_eq_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

sc_rhs:                                           ; preds = %entry
  %b92 = load ptr, ptr %b, align 8
  %tag_ptr93 = getelementptr inbounds nuw %Shape, ptr %b92, i32 0, i32 0
  %tag94 = load i64, ptr %tag_ptr93, align 8
  %is_eq95 = icmp eq i64 %tag94, 6952139942519
  %is_eq_ext96 = zext i1 %is_eq95 to i64
  %r_bool = icmp ne i64 %is_eq_ext96, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond = icmp ne i64 %sc_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont:                                           ; preds = %if_else, %if_then
  %50 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr98 = getelementptr inbounds nuw %Shape, ptr %50, i32 0, i32 0
  store i64 7571616179632859, ptr %tag_ptr98, align 8
  %pay_ptr99 = getelementptr inbounds nuw %Shape, ptr %50, i32 0, i32 1
  store ptr null, ptr %pay_ptr99, align 8
  %cast100 = ptrtoint ptr %50 to i64
  %cast101 = inttoptr i64 %cast100 to ptr
  store ptr %cast101, ptr %t, align 8
  %t102 = load ptr, ptr %t, align 8
  %tag_ptr103 = getelementptr inbounds nuw %Shape, ptr %t102, i32 0, i32 0
  %tag104 = load i64, ptr %tag_ptr103, align 8
  %is_eq105 = icmp eq i64 %tag104, 6952139942519
  %is_eq_ext106 = zext i1 %is_eq105 to i64
  %not_cmp = icmp eq i64 %is_eq_ext106, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %if_cond108 = icmp ne i64 %not_cmp_ext, 0
  br i1 %if_cond108, label %if_then109, label %if_else110

if_then:                                          ; preds = %sc_merge
  %51 = call i32 @puts(ptr @.str.10)
  %widen97 = sext i32 %51 to i64
  br label %ifcont

if_else:                                          ; preds = %sc_merge
  br label %ifcont

ifcont107:                                        ; preds = %if_else110, %if_then109
  %52 = call ptr @avra_rc_alloc(i64 16)
  %53 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr112 = getelementptr inbounds nuw %Shape, ptr %53, i32 0, i32 0
  store i64 6952775702006, ptr %tag_ptr112, align 8
  %pay_ptr113 = getelementptr inbounds nuw %Shape, ptr %53, i32 0, i32 1
  %54 = call ptr @avra_rc_alloc(i64 8)
  store ptr %54, ptr %pay_ptr113, align 8
  %slot_base114 = ptrtoint ptr %54 to i64
  %slot_addr115 = add i64 %slot_base114, 0
  %slot116 = inttoptr i64 %slot_addr115 to ptr
  store i64 4, ptr %slot116, align 8
  %cast117 = ptrtoint ptr %53 to i64
  %fld_ptr = getelementptr inbounds nuw %Tagged, ptr %52, i32 0, i32 0
  %cast118 = inttoptr i64 %cast117 to ptr
  store ptr %cast118, ptr %fld_ptr, align 8
  %fld_ptr119 = getelementptr inbounds nuw %Tagged, ptr %52, i32 0, i32 1
  store ptr @.str.12, ptr %fld_ptr119, align 8
  %cast120 = ptrtoint ptr %52 to i64
  %cast121 = inttoptr i64 %cast120 to ptr
  store ptr %cast121, ptr %tagged, align 8
  %tagged122 = load ptr, ptr %tagged, align 8
  %cast123 = ptrtoint ptr %tagged122 to i64
  %null_chk = icmp eq i64 %cast123, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 94, i64 79)
  %form_ptr = getelementptr inbounds nuw %Tagged, ptr %tagged122, i32 0, i32 0
  %form = load ptr, ptr %form_ptr, align 8
  %tag_ptr124 = getelementptr inbounds nuw %Shape, ptr %form, i32 0, i32 0
  %tag125 = load i64, ptr %tag_ptr124, align 8
  %is_eq126 = icmp eq i64 %tag125, 6952775702006
  %is_eq_ext127 = zext i1 %is_eq126 to i64
  %sif_cond = icmp ne i64 %is_eq_ext127, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

if_then109:                                       ; preds = %ifcont
  %55 = call i32 @puts(ptr @.str.11)
  %widen111 = sext i32 %55 to i64
  br label %ifcont107

if_else110:                                       ; preds = %ifcont
  br label %ifcont107

sif_then:                                         ; preds = %ifcont107
  %tagged128 = load ptr, ptr %tagged, align 8
  %cast129 = ptrtoint ptr %tagged128 to i64
  %null_chk130 = icmp eq i64 %cast129, 0
  %null_ext131 = zext i1 %null_chk130 to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 5, ptr @sty_name.14, i64 6, i64 %null_ext131, ptr @src_file.15, i64 94, i64 80)
  %label_ptr = getelementptr inbounds nuw %Tagged, ptr %tagged128, i32 0, i32 1
  %label = load ptr, ptr %label_ptr, align 8
  %56 = call i32 @puts(ptr %label)
  %widen132 = sext i32 %56 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %ifcont107
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %tagged_cleanup = load ptr, ptr %tagged, align 8
  %57 = call i64 @__release_Tagged(ptr %tagged_cleanup)
  ret i64 %sif_val
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Tagged(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_form_ptr = getelementptr inbounds nuw %Tagged, ptr %0, i32 0, i32 0
  %rel_form = load ptr, ptr %rel_form_ptr, align 8
  %is_null_form = icmp eq ptr %rel_form, null
  br i1 %is_null_form, label %rel_form_skip, label %rel_form_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_label_skip
  ret i64 0

rel_form_skip:                                    ; preds = %rel_form_do, %do_free
  %rel_label_ptr = getelementptr inbounds nuw %Tagged, ptr %0, i32 0, i32 1
  %rel_label = load ptr, ptr %rel_label_ptr, align 8
  %is_null_label = icmp eq ptr %rel_label, null
  br i1 %is_null_label, label %rel_label_skip, label %rel_label_do

rel_form_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_form)
  br label %rel_form_skip

rel_label_skip:                                   ; preds = %rel_label_do, %rel_form_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_label_do:                                     ; preds = %rel_form_skip
  call void @avra_rc_release(ptr %rel_label)
  br label %rel_label_skip
}
