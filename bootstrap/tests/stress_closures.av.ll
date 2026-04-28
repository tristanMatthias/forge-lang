; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@classify = global i64 0
@nums = global i64 0
@step1 = global i64 0
@step2 = global i64 0
@step3 = global i64 0
@product = global i64 0
@items = global i64 0
@double = global i64 0
@data = global i64 0
@even_squares = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@dz_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_closures.av\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %v = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 -559038737)
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @classify, align 8
  %classify = load i64, ptr @classify, align 8
  %cast1 = inttoptr i64 %classify to ptr
  %1 = call i64 @avra_array_get(ptr %cast1, i64 1)
  %fn_ptr = inttoptr i64 %1 to ptr
  %closure_call = call i64 %fn_ptr(i64 150)
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %closure_call)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen2 = sext i32 %4 to i64
  %classify3 = load i64, ptr @classify, align 8
  %cast4 = inttoptr i64 %classify3 to ptr
  %5 = call i64 @avra_array_get(ptr %cast4, i64 1)
  %fn_ptr5 = inttoptr i64 %5 to ptr
  %closure_call6 = call i64 %fn_ptr5(i64 75)
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.1, i64 %closure_call6)
  %widen7 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen8 = sext i32 %8 to i64
  %classify9 = load i64, ptr @classify, align 8
  %cast10 = inttoptr i64 %classify9 to ptr
  %9 = call i64 @avra_array_get(ptr %cast10, i64 1)
  %fn_ptr11 = inttoptr i64 %9 to ptr
  %closure_call12 = call i64 %fn_ptr11(i64 25)
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.2, i64 %closure_call12)
  %widen13 = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen14 = sext i32 %12 to i64
  %classify15 = load i64, ptr @classify, align 8
  %cast16 = inttoptr i64 %classify15 to ptr
  %13 = call i64 @avra_array_get(ptr %cast16, i64 1)
  %fn_ptr17 = inttoptr i64 %13 to ptr
  %closure_call18 = call i64 %fn_ptr17(i64 -5)
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.3, i64 %closure_call18)
  %widen19 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen20 = sext i32 %16 to i64
  %17 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %17, i64 1)
  call void @avra_array_push(ptr %17, i64 2)
  call void @avra_array_push(ptr %17, i64 3)
  call void @avra_array_push(ptr %17, i64 4)
  call void @avra_array_push(ptr %17, i64 5)
  store ptr %17, ptr @nums, align 8
  %nums = load ptr, ptr @nums, align 8
  %18 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %18, i64 -559038737)
  call void @avra_array_push(ptr %18, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast21 = ptrtoint ptr %18 to i64
  %19 = call ptr @avra_array_map(ptr %nums, i64 %cast21)
  store ptr %19, ptr @step1, align 8
  %step1 = load ptr, ptr @step1, align 8
  %20 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %20, i64 -559038737)
  call void @avra_array_push(ptr %20, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast22 = ptrtoint ptr %20 to i64
  %21 = call ptr @avra_array_map(ptr %step1, i64 %cast22)
  store ptr %21, ptr @step2, align 8
  %step2 = load ptr, ptr @step2, align 8
  %22 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %22, i64 -559038737)
  call void @avra_array_push(ptr %22, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast23 = ptrtoint ptr %22 to i64
  %23 = call ptr @avra_array_filter(ptr %step2, i64 %cast23)
  store ptr %23, ptr @step3, align 8
  %step3 = load ptr, ptr @step3, align 8
  %24 = call i64 @avra_array_len(ptr %step3)
  store i64 %24, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %25 = call i64 @avra_array_get(ptr %step3, i64 %forin_i_val)
  store i64 %25, ptr %v, align 8
  %v24 = load i64, ptr %v, align 8
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.4, i64 %v24)
  %widen25 = sext i32 %27 to i64
  %28 = call i32 @puts(ptr %26)
  %widen26 = sext i32 %28 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %29 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %29, i64 2)
  call void @avra_array_push(ptr %29, i64 3)
  call void @avra_array_push(ptr %29, i64 4)
  call void @avra_array_push(ptr %29, i64 5)
  %30 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %30, i64 -559038737)
  call void @avra_array_push(ptr %30, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast27 = ptrtoint ptr %30 to i64
  %31 = call i64 @avra_array_reduce(ptr %29, i64 1, i64 %cast27)
  store i64 %31, ptr @product, align 8
  %product = load i64, ptr @product, align 8
  %32 = call ptr @avra_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.5, i64 %product)
  %widen28 = sext i32 %33 to i64
  %34 = call i32 @puts(ptr %32)
  %widen29 = sext i32 %34 to i64
  %35 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %35, i64 100)
  call void @avra_array_push(ptr %35, i64 200)
  call void @avra_array_push(ptr %35, i64 300)
  store ptr %35, ptr @items, align 8
  %items = load ptr, ptr @items, align 8
  %36 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %36, i64 -559038737)
  call void @avra_array_push(ptr %36, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast30 = ptrtoint ptr %36 to i64
  call void @avra_array_foreach(ptr %items, i64 %cast30)
  %37 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %37, i64 -559038737)
  call void @avra_array_push(ptr %37, i64 ptrtoint (ptr @__lambda_6 to i64))
  %cast31 = ptrtoint ptr %37 to i64
  store i64 %cast31, ptr @double, align 8
  %double = load i64, ptr @double, align 8
  %cast32 = inttoptr i64 %double to ptr
  %38 = call i64 @avra_array_get(ptr %cast32, i64 1)
  %fn_ptr33 = inttoptr i64 %38 to ptr
  %double34 = load i64, ptr @double, align 8
  %cast35 = inttoptr i64 %double34 to ptr
  %39 = call i64 @avra_array_get(ptr %cast35, i64 1)
  %fn_ptr36 = inttoptr i64 %39 to ptr
  %closure_call37 = call i64 %fn_ptr36(i64 3)
  %closure_call38 = call i64 %fn_ptr33(i64 %closure_call37)
  %40 = call ptr @avra_rc_alloc(i64 32)
  %41 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %40, i64 32, ptr @.i2s_fmt.7, i64 %closure_call38)
  %widen39 = sext i32 %41 to i64
  %42 = call i32 @puts(ptr %40)
  %widen40 = sext i32 %42 to i64
  %43 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %43, i64 1)
  call void @avra_array_push(ptr %43, i64 2)
  call void @avra_array_push(ptr %43, i64 3)
  call void @avra_array_push(ptr %43, i64 4)
  call void @avra_array_push(ptr %43, i64 5)
  call void @avra_array_push(ptr %43, i64 6)
  call void @avra_array_push(ptr %43, i64 7)
  call void @avra_array_push(ptr %43, i64 8)
  call void @avra_array_push(ptr %43, i64 9)
  call void @avra_array_push(ptr %43, i64 10)
  store ptr %43, ptr @data, align 8
  %data = load ptr, ptr @data, align 8
  %44 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %44, i64 -559038737)
  call void @avra_array_push(ptr %44, i64 ptrtoint (ptr @__lambda_7 to i64))
  %cast41 = ptrtoint ptr %44 to i64
  %45 = call ptr @avra_array_filter(ptr %data, i64 %cast41)
  %46 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %46, i64 -559038737)
  call void @avra_array_push(ptr %46, i64 ptrtoint (ptr @__lambda_8 to i64))
  %cast42 = ptrtoint ptr %46 to i64
  %47 = call ptr @avra_array_map(ptr %45, i64 %cast42)
  %48 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %48, i64 -559038737)
  call void @avra_array_push(ptr %48, i64 ptrtoint (ptr @__lambda_9 to i64))
  %cast43 = ptrtoint ptr %48 to i64
  %49 = call i64 @avra_array_reduce(ptr %47, i64 0, i64 %cast43)
  store i64 %49, ptr @even_squares, align 8
  %even_squares = load i64, ptr @even_squares, align 8
  %50 = call ptr @avra_rc_alloc(i64 32)
  %51 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %50, i64 32, ptr @.i2s_fmt.8, i64 %even_squares)
  %widen44 = sext i32 %51 to i64
  %52 = call i32 @puts(ptr %50)
  %widen45 = sext i32 %52 to i64
  %53 = call i32 @avra_test_summary()
  %widen46 = sext i32 %53 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 100
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %x2 = load i64, ptr %x, align 8
  %sgt3 = icmp sgt i64 %x2, 50
  %sgt_ext4 = zext i1 %sgt3 to i64
  %if_cond6 = icmp ne i64 %sgt_ext4, 0
  br i1 %if_cond6, label %if_then7, label %if_else8

if_then:                                          ; preds = %entry
  ret i64 3

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont5:                                          ; preds = %if_else8
  %x9 = load i64, ptr %x, align 8
  %sgt10 = icmp sgt i64 %x9, 0
  %sgt_ext11 = zext i1 %sgt10 to i64
  %if_cond13 = icmp ne i64 %sgt_ext11, 0
  br i1 %if_cond13, label %if_then14, label %if_else15

if_then7:                                         ; preds = %ifcont
  ret i64 2

if_else8:                                         ; preds = %ifcont
  br label %ifcont5

ifcont12:                                         ; preds = %if_else15
  ret i64 0

if_then14:                                        ; preds = %ifcont5
  ret i64 1

if_else15:                                        ; preds = %ifcont5
  br label %ifcont12
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 10
  ret i64 %mul
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %add = add i64 %x1, 1
  ret i64 %add
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 21
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_4(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %acc1, %x2
  ret i64 %mul
}

define i64 @__lambda_5(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.6, i64 %x1)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen2 = sext i32 %3 to i64
  ret i64 0
}

define i64 @__lambda_6(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_7(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 101, i64 36)
  %mod = srem i64 %x1, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  ret i64 %eq_ext
}

define i64 @__lambda_8(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, %x2
  ret i64 %mul
}

define i64 @__lambda_9(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %a1 = load i64, ptr %a, align 8
  %b2 = load i64, ptr %b, align 8
  %add = add i64 %a1, %b2
  ret i64 %add
}
