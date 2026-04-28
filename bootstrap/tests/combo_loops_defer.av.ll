; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@found = global i64 0
@nums = global i64 0
@odd_sum = global i64 0
@result = global i64 0
@.str = private unnamed_addr constant [20 x i8] c"processing complete\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"search complete\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"search complete\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@dz_file = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_loops_defer.av\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @process_items() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %total = alloca i64, align 8
  store i64 0, ptr %total, align 8
  store i64 0, ptr %i, align 8
  store i64 5, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %total2 = load i64, ptr %total, align 8
  %i3 = load i64, ptr %i, align 8
  %i4 = load i64, ptr %i, align 8
  %mul = mul i64 %i3, %i4
  %add = add i64 %total2, %mul
  store i64 %add, ptr %total, align 8
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i5 = load i64, ptr %i, align 8
  %for_next = add i64 %i5, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %total6 = load i64, ptr %total, align 8
  %0 = call i32 @puts(ptr @.str)
  %widen = sext i32 %0 to i64
  ret i64 %total6
}

define i64 @find_first_above(i64 %0) {
entry:
  %i = alloca i64, align 8
  %threshold = alloca i64, align 8
  store i64 %0, ptr %threshold, align 8
  store i64 0, ptr %i, align 8
  br label %while.cond

while.cond:                                       ; preds = %ifcont, %entry
  %i1 = load i64, ptr %i, align 8
  %slt = icmp slt i64 %i1, 100
  %slt_ext = zext i1 %slt to i64
  %while_cond = icmp ne i64 %slt_ext, 0
  br i1 %while_cond, label %while.body, label %while.exit

while.body:                                       ; preds = %while.cond
  %i2 = load i64, ptr %i, align 8
  %i3 = load i64, ptr %i, align 8
  %mul = mul i64 %i2, %i3
  %threshold4 = load i64, ptr %threshold, align 8
  %sgt = icmp sgt i64 %mul, %threshold4
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

while.exit:                                       ; preds = %while.cond
  %1 = call i32 @puts(ptr @.str.2)
  %widen7 = sext i32 %1 to i64
  ret i64 -1

ifcont:                                           ; preds = %if_else
  %i6 = load i64, ptr %i, align 8
  %add = add i64 %i6, 1
  store i64 %add, ptr %i, align 8
  br label %while.cond

if_then:                                          ; preds = %while.body
  %i5 = load i64, ptr %i, align 8
  %2 = call i32 @puts(ptr @.str.1)
  %widen = sext i32 %2 to i64
  ret i64 %i5

if_else:                                          ; preds = %while.body
  br label %ifcont
}

define i64 @main() {
entry:
  %for_end25 = alloca i64, align 8
  %j = alloca i64, align 8
  %for_end17 = alloca i64, align 8
  %i16 = alloca i64, align 8
  %n = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  store i64 -1, ptr @found, align 8
  store i64 0, ptr %i, align 8
  store i64 100, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %i2 = load i64, ptr %i, align 8
  %i3 = load i64, ptr %i, align 8
  %mul = mul i64 %i2, %i3
  %sgt = icmp sgt i64 %mul, 50
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

for.incr:                                         ; preds = %ifcont
  %i5 = load i64, ptr %i, align 8
  %for_next = add i64 %i5, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %if_then, %for.cond
  %found = load i64, ptr @found, align 8
  %0 = call ptr @avra_rc_alloc(i64 32)
  %1 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %0, i64 32, ptr @.i2s_fmt, i64 %found)
  %widen = sext i32 %1 to i64
  %2 = call i32 @puts(ptr %0)
  %widen6 = sext i32 %2 to i64
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 1)
  call void @avra_array_push(ptr %3, i64 2)
  call void @avra_array_push(ptr %3, i64 3)
  call void @avra_array_push(ptr %3, i64 4)
  call void @avra_array_push(ptr %3, i64 5)
  call void @avra_array_push(ptr %3, i64 6)
  call void @avra_array_push(ptr %3, i64 7)
  call void @avra_array_push(ptr %3, i64 8)
  call void @avra_array_push(ptr %3, i64 9)
  call void @avra_array_push(ptr %3, i64 10)
  store ptr %3, ptr @nums, align 8
  store i64 0, ptr @odd_sum, align 8
  %nums = load ptr, ptr @nums, align 8
  %4 = call i64 @avra_array_len(ptr %nums)
  store i64 %4, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

ifcont:                                           ; preds = %if_else
  br label %for.incr

if_then:                                          ; preds = %for.body
  %i4 = load i64, ptr %i, align 8
  store i64 %i4, ptr @found, align 8
  br label %for.exit

if_else:                                          ; preds = %for.body
  br label %ifcont

forin.cond:                                       ; preds = %forin.incr, %for.exit
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %5 = call i64 @avra_array_get(ptr %nums, i64 %forin_i_val)
  store i64 %5, ptr %n, align 8
  %n7 = load i64, ptr %n, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 103, i64 15)
  %mod = srem i64 %n7, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond9 = icmp ne i64 %eq_ext, 0
  br i1 %if_cond9, label %if_then10, label %if_else11

forin.incr:                                       ; preds = %ifcont8, %if_then10
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %odd_sum13 = load i64, ptr @odd_sum, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.3, i64 %odd_sum13)
  %widen14 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen15 = sext i32 %8 to i64
  store i64 0, ptr @result, align 8
  store i64 0, ptr %i16, align 8
  store i64 10, ptr %for_end17, align 8
  br label %for.cond18

ifcont8:                                          ; preds = %if_else11
  %odd_sum = load i64, ptr @odd_sum, align 8
  %n12 = load i64, ptr %n, align 8
  %add = add i64 %odd_sum, %n12
  store i64 %add, ptr @odd_sum, align 8
  br label %forin.incr

if_then10:                                        ; preds = %forin.body
  br label %forin.incr

if_else11:                                        ; preds = %forin.body
  br label %ifcont8

for.cond18:                                       ; preds = %for.incr20, %forin.exit
  %i22 = load i64, ptr %i16, align 8
  %for_end_val23 = load i64, ptr %for_end17, align 8
  %for_cmp24 = icmp slt i64 %i22, %for_end_val23
  br i1 %for_cmp24, label %for.body19, label %for.exit21

for.body19:                                       ; preds = %for.cond18
  store i64 0, ptr %j, align 8
  store i64 10, ptr %for_end25, align 8
  br label %for.cond26

for.incr20:                                       ; preds = %for.exit29
  %i45 = load i64, ptr %i16, align 8
  %for_next46 = add i64 %i45, 1
  store i64 %for_next46, ptr %i16, align 8
  br label %for.cond18

for.exit21:                                       ; preds = %for.cond18
  %result47 = load i64, ptr @result, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.4, i64 %result47)
  %widen48 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen49 = sext i32 %11 to i64
  %12 = call i64 @process_items()
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.5, i64 %12)
  %widen50 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen51 = sext i32 %15 to i64
  %16 = call i64 @find_first_above(i64 200)
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.6, i64 %16)
  %widen52 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen53 = sext i32 %19 to i64
  %20 = call i32 @avra_test_summary()
  %widen54 = sext i32 %20 to i64
  call void @avra_rc_collect()
  ret i64 0

for.cond26:                                       ; preds = %for.incr28, %for.body19
  %j30 = load i64, ptr %j, align 8
  %for_end_val31 = load i64, ptr %for_end25, align 8
  %for_cmp32 = icmp slt i64 %j30, %for_end_val31
  br i1 %for_cmp32, label %for.body27, label %for.exit29

for.body27:                                       ; preds = %for.cond26
  %i33 = load i64, ptr %i16, align 8
  %j34 = load i64, ptr %j, align 8
  %add35 = add i64 %i33, %j34
  %sgt36 = icmp sgt i64 %add35, 12
  %sgt_ext37 = zext i1 %sgt36 to i64
  %if_cond39 = icmp ne i64 %sgt_ext37, 0
  br i1 %if_cond39, label %if_then40, label %if_else41

for.incr28:                                       ; preds = %ifcont38
  %j43 = load i64, ptr %j, align 8
  %for_next44 = add i64 %j43, 1
  store i64 %for_next44, ptr %j, align 8
  br label %for.cond26

for.exit29:                                       ; preds = %if_then40, %for.cond26
  br label %for.incr20

ifcont38:                                         ; preds = %if_else41
  %result = load i64, ptr @result, align 8
  %add42 = add i64 %result, 1
  store i64 %add42, ptr @result, align 8
  br label %for.incr28

if_then40:                                        ; preds = %for.body27
  br label %for.exit29

if_else41:                                        ; preds = %for.body27
  br label %ifcont38
}
