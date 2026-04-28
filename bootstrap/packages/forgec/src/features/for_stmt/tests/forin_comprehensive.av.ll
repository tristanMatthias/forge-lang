; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@words = global i64 0
@scores = global i64 0
@total = global i64 0
@rows = global i64 0
@flat_sum = global i64 0
@found = global i64 0
@odd_sum = global i64 0
@count = global i64 0
@nums = global i64 0
@doubled = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"forge\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@dz_file = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/for_stmt/tests/forin_comprehensive.av\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @main() {
entry:
  %d = alloca i64, align 8
  %forin_i103 = alloca i64, align 8
  %forin_len102 = alloca i64, align 8
  %x87 = alloca i64, align 8
  %forin_i86 = alloca i64, align 8
  %forin_len85 = alloca i64, align 8
  %n = alloca i64, align 8
  %forin_i63 = alloca i64, align 8
  %forin_len62 = alloca i64, align 8
  %x = alloca i64, align 8
  %forin_i48 = alloca i64, align 8
  %forin_len47 = alloca i64, align 8
  %val = alloca i64, align 8
  %forin_i30 = alloca i64, align 8
  %forin_len29 = alloca i64, align 8
  %row = alloca i64, align 8
  %forin_i20 = alloca i64, align 8
  %forin_len19 = alloca i64, align 8
  %s = alloca i64, align 8
  %forin_i3 = alloca i64, align 8
  %forin_len2 = alloca i64, align 8
  %w = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str to i64))
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str.1 to i64))
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str.2 to i64))
  store ptr %0, ptr @words, align 8
  %words = load ptr, ptr @words, align 8
  %1 = call i64 @avra_array_len(ptr %words)
  store i64 %1, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %2 = call i64 @avra_array_get(ptr %words, i64 %forin_i_val)
  store i64 %2, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %3 = call i32 @puts(ptr %w1)
  %widen = sext i32 %3 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 10)
  call void @avra_array_push(ptr %4, i64 20)
  call void @avra_array_push(ptr %4, i64 30)
  call void @avra_array_push(ptr %4, i64 40)
  call void @avra_array_push(ptr %4, i64 50)
  store ptr %4, ptr @scores, align 8
  store i64 0, ptr @total, align 8
  %scores = load ptr, ptr @scores, align 8
  %5 = call i64 @avra_array_len(ptr %scores)
  store i64 %5, ptr %forin_len2, align 8
  store i64 0, ptr %forin_i3, align 8
  br label %forin.cond4

forin.cond4:                                      ; preds = %forin.incr6, %forin.exit
  %forin_i_val8 = load i64, ptr %forin_i3, align 8
  %forin_len_val9 = load i64, ptr %forin_len2, align 8
  %forin_cmp10 = icmp slt i64 %forin_i_val8, %forin_len_val9
  br i1 %forin_cmp10, label %forin.body5, label %forin.exit7

forin.body5:                                      ; preds = %forin.cond4
  %6 = call i64 @avra_array_get(ptr %scores, i64 %forin_i_val8)
  store i64 %6, ptr %s, align 8
  %total = load i64, ptr @total, align 8
  %s11 = load i64, ptr %s, align 8
  %add = add i64 %total, %s11
  store i64 %add, ptr @total, align 8
  br label %forin.incr6

forin.incr6:                                      ; preds = %forin.body5
  %forin_i_old12 = load i64, ptr %forin_i3, align 8
  %forin_next13 = add i64 %forin_i_old12, 1
  store i64 %forin_next13, ptr %forin_i3, align 8
  br label %forin.cond4

forin.exit7:                                      ; preds = %forin.cond4
  %total14 = load i64, ptr @total, align 8
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt, i64 %total14)
  %widen15 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen16 = sext i32 %9 to i64
  %10 = call ptr @avra_array_new()
  %11 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %11, i64 1)
  call void @avra_array_push(ptr %11, i64 2)
  %cast = ptrtoint ptr %11 to i64
  call void @avra_array_push(ptr %10, i64 %cast)
  %12 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %12, i64 3)
  call void @avra_array_push(ptr %12, i64 4)
  %cast17 = ptrtoint ptr %12 to i64
  call void @avra_array_push(ptr %10, i64 %cast17)
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 5)
  call void @avra_array_push(ptr %13, i64 6)
  %cast18 = ptrtoint ptr %13 to i64
  call void @avra_array_push(ptr %10, i64 %cast18)
  store ptr %10, ptr @rows, align 8
  store i64 0, ptr @flat_sum, align 8
  %rows = load ptr, ptr @rows, align 8
  %14 = call i64 @avra_array_len(ptr %rows)
  store i64 %14, ptr %forin_len19, align 8
  store i64 0, ptr %forin_i20, align 8
  br label %forin.cond21

forin.cond21:                                     ; preds = %forin.incr23, %forin.exit7
  %forin_i_val25 = load i64, ptr %forin_i20, align 8
  %forin_len_val26 = load i64, ptr %forin_len19, align 8
  %forin_cmp27 = icmp slt i64 %forin_i_val25, %forin_len_val26
  br i1 %forin_cmp27, label %forin.body22, label %forin.exit24

forin.body22:                                     ; preds = %forin.cond21
  %15 = call i64 @avra_array_get(ptr %rows, i64 %forin_i_val25)
  store i64 %15, ptr %row, align 8
  %row28 = load ptr, ptr %row, align 8
  %16 = call i64 @avra_array_len(ptr %row28)
  store i64 %16, ptr %forin_len29, align 8
  store i64 0, ptr %forin_i30, align 8
  br label %forin.cond31

forin.incr23:                                     ; preds = %forin.exit34
  %forin_i_old42 = load i64, ptr %forin_i20, align 8
  %forin_next43 = add i64 %forin_i_old42, 1
  store i64 %forin_next43, ptr %forin_i20, align 8
  br label %forin.cond21

forin.exit24:                                     ; preds = %forin.cond21
  %flat_sum44 = load i64, ptr @flat_sum, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.3, i64 %flat_sum44)
  %widen45 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen46 = sext i32 %19 to i64
  store i64 -1, ptr @found, align 8
  %20 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %20, i64 10)
  call void @avra_array_push(ptr %20, i64 20)
  call void @avra_array_push(ptr %20, i64 30)
  call void @avra_array_push(ptr %20, i64 40)
  %21 = call i64 @avra_array_len(ptr %20)
  store i64 %21, ptr %forin_len47, align 8
  store i64 0, ptr %forin_i48, align 8
  br label %forin.cond49

forin.cond31:                                     ; preds = %forin.incr33, %forin.body22
  %forin_i_val35 = load i64, ptr %forin_i30, align 8
  %forin_len_val36 = load i64, ptr %forin_len29, align 8
  %forin_cmp37 = icmp slt i64 %forin_i_val35, %forin_len_val36
  br i1 %forin_cmp37, label %forin.body32, label %forin.exit34

forin.body32:                                     ; preds = %forin.cond31
  %22 = call i64 @avra_array_get(ptr %row28, i64 %forin_i_val35)
  store i64 %22, ptr %val, align 8
  %flat_sum = load i64, ptr @flat_sum, align 8
  %val38 = load i64, ptr %val, align 8
  %add39 = add i64 %flat_sum, %val38
  store i64 %add39, ptr @flat_sum, align 8
  br label %forin.incr33

forin.incr33:                                     ; preds = %forin.body32
  %forin_i_old40 = load i64, ptr %forin_i30, align 8
  %forin_next41 = add i64 %forin_i_old40, 1
  store i64 %forin_next41, ptr %forin_i30, align 8
  br label %forin.cond31

forin.exit34:                                     ; preds = %forin.cond31
  br label %forin.incr23

forin.cond49:                                     ; preds = %forin.incr51, %forin.exit24
  %forin_i_val53 = load i64, ptr %forin_i48, align 8
  %forin_len_val54 = load i64, ptr %forin_len47, align 8
  %forin_cmp55 = icmp slt i64 %forin_i_val53, %forin_len_val54
  br i1 %forin_cmp55, label %forin.body50, label %forin.exit52

forin.body50:                                     ; preds = %forin.cond49
  %23 = call i64 @avra_array_get(ptr %20, i64 %forin_i_val53)
  store i64 %23, ptr %x, align 8
  %x56 = load i64, ptr %x, align 8
  %eq = icmp eq i64 %x56, 30
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

forin.incr51:                                     ; preds = %ifcont
  %forin_i_old58 = load i64, ptr %forin_i48, align 8
  %forin_next59 = add i64 %forin_i_old58, 1
  store i64 %forin_next59, ptr %forin_i48, align 8
  br label %forin.cond49

forin.exit52:                                     ; preds = %if_then, %forin.cond49
  %found = load i64, ptr @found, align 8
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.4, i64 %found)
  %widen60 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen61 = sext i32 %26 to i64
  store i64 0, ptr @odd_sum, align 8
  %27 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %27, i64 1)
  call void @avra_array_push(ptr %27, i64 2)
  call void @avra_array_push(ptr %27, i64 3)
  call void @avra_array_push(ptr %27, i64 4)
  call void @avra_array_push(ptr %27, i64 5)
  call void @avra_array_push(ptr %27, i64 6)
  call void @avra_array_push(ptr %27, i64 7)
  %28 = call i64 @avra_array_len(ptr %27)
  store i64 %28, ptr %forin_len62, align 8
  store i64 0, ptr %forin_i63, align 8
  br label %forin.cond64

ifcont:                                           ; preds = %if_else
  br label %forin.incr51

if_then:                                          ; preds = %forin.body50
  %x57 = load i64, ptr %x, align 8
  store i64 %x57, ptr @found, align 8
  br label %forin.exit52

if_else:                                          ; preds = %forin.body50
  br label %ifcont

forin.cond64:                                     ; preds = %forin.incr66, %forin.exit52
  %forin_i_val68 = load i64, ptr %forin_i63, align 8
  %forin_len_val69 = load i64, ptr %forin_len62, align 8
  %forin_cmp70 = icmp slt i64 %forin_i_val68, %forin_len_val69
  br i1 %forin_cmp70, label %forin.body65, label %forin.exit67

forin.body65:                                     ; preds = %forin.cond64
  %29 = call i64 @avra_array_get(ptr %27, i64 %forin_i_val68)
  store i64 %29, ptr %n, align 8
  %n71 = load i64, ptr %n, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 143, i64 40)
  %mod = srem i64 %n71, 2
  %eq72 = icmp eq i64 %mod, 0
  %eq_ext73 = zext i1 %eq72 to i64
  %if_cond75 = icmp ne i64 %eq_ext73, 0
  br i1 %if_cond75, label %if_then76, label %if_else77

forin.incr66:                                     ; preds = %ifcont74, %if_then76
  %forin_i_old80 = load i64, ptr %forin_i63, align 8
  %forin_next81 = add i64 %forin_i_old80, 1
  store i64 %forin_next81, ptr %forin_i63, align 8
  br label %forin.cond64

forin.exit67:                                     ; preds = %forin.cond64
  %odd_sum82 = load i64, ptr @odd_sum, align 8
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.5, i64 %odd_sum82)
  %widen83 = sext i32 %31 to i64
  %32 = call i32 @puts(ptr %30)
  %widen84 = sext i32 %32 to i64
  store i64 0, ptr @count, align 8
  %33 = call ptr @avra_array_new()
  %34 = call i64 @avra_array_len(ptr %33)
  store i64 %34, ptr %forin_len85, align 8
  store i64 0, ptr %forin_i86, align 8
  br label %forin.cond88

ifcont74:                                         ; preds = %if_else77
  %odd_sum = load i64, ptr @odd_sum, align 8
  %n78 = load i64, ptr %n, align 8
  %add79 = add i64 %odd_sum, %n78
  store i64 %add79, ptr @odd_sum, align 8
  br label %forin.incr66

if_then76:                                        ; preds = %forin.body65
  br label %forin.incr66

if_else77:                                        ; preds = %forin.body65
  br label %ifcont74

forin.cond88:                                     ; preds = %forin.incr90, %forin.exit67
  %forin_i_val92 = load i64, ptr %forin_i86, align 8
  %forin_len_val93 = load i64, ptr %forin_len85, align 8
  %forin_cmp94 = icmp slt i64 %forin_i_val92, %forin_len_val93
  br i1 %forin_cmp94, label %forin.body89, label %forin.exit91

forin.body89:                                     ; preds = %forin.cond88
  %35 = call i64 @avra_array_get(ptr %33, i64 %forin_i_val92)
  store i64 %35, ptr %x87, align 8
  %count = load i64, ptr @count, align 8
  %add95 = add i64 %count, 1
  store i64 %add95, ptr @count, align 8
  br label %forin.incr90

forin.incr90:                                     ; preds = %forin.body89
  %forin_i_old96 = load i64, ptr %forin_i86, align 8
  %forin_next97 = add i64 %forin_i_old96, 1
  store i64 %forin_next97, ptr %forin_i86, align 8
  br label %forin.cond88

forin.exit91:                                     ; preds = %forin.cond88
  %count98 = load i64, ptr @count, align 8
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.6, i64 %count98)
  %widen99 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen100 = sext i32 %38 to i64
  %39 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %39, i64 1)
  call void @avra_array_push(ptr %39, i64 2)
  call void @avra_array_push(ptr %39, i64 3)
  call void @avra_array_push(ptr %39, i64 4)
  call void @avra_array_push(ptr %39, i64 5)
  store ptr %39, ptr @nums, align 8
  %nums = load ptr, ptr @nums, align 8
  %40 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %40, i64 -559038737)
  call void @avra_array_push(ptr %40, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast101 = ptrtoint ptr %40 to i64
  %41 = call ptr @avra_array_map(ptr %nums, i64 %cast101)
  store ptr %41, ptr @doubled, align 8
  %doubled = load ptr, ptr @doubled, align 8
  %42 = call i64 @avra_array_len(ptr %doubled)
  store i64 %42, ptr %forin_len102, align 8
  store i64 0, ptr %forin_i103, align 8
  br label %forin.cond104

forin.cond104:                                    ; preds = %forin.incr106, %forin.exit91
  %forin_i_val108 = load i64, ptr %forin_i103, align 8
  %forin_len_val109 = load i64, ptr %forin_len102, align 8
  %forin_cmp110 = icmp slt i64 %forin_i_val108, %forin_len_val109
  br i1 %forin_cmp110, label %forin.body105, label %forin.exit107

forin.body105:                                    ; preds = %forin.cond104
  %43 = call i64 @avra_array_get(ptr %doubled, i64 %forin_i_val108)
  store i64 %43, ptr %d, align 8
  %d111 = load i64, ptr %d, align 8
  %44 = call ptr @avra_rc_alloc(i64 32)
  %45 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %44, i64 32, ptr @.i2s_fmt.7, i64 %d111)
  %widen112 = sext i32 %45 to i64
  %46 = call i32 @puts(ptr %44)
  %widen113 = sext i32 %46 to i64
  br label %forin.incr106

forin.incr106:                                    ; preds = %forin.body105
  %forin_i_old114 = load i64, ptr %forin_i103, align 8
  %forin_next115 = add i64 %forin_i_old114, 1
  store i64 %forin_next115, ptr %forin_i103, align 8
  br label %forin.cond104

forin.exit107:                                    ; preds = %forin.cond104
  %47 = call i32 @avra_test_summary()
  %widen116 = sext i32 %47 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}
