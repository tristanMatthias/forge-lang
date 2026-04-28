; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { i64, i64 }

@scores = global i64 0
@max_val = global i64 0
@counts = global i64 0
@matrix = global i64 0
@flat = global i64 0
@total = global i64 0
@nums = global i64 0
@mid = global i64 0
@points = global i64 0
@distances = global i64 0
@evens = global i64 0
@even_sum = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"max: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"a: \00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"d: \00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"d\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"sum: \00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"mid: \00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.18 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.20 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.i2s_fmt.21 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.22 = private unnamed_addr constant [12 x i8] c"slice len: \00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_collections.av\00", align 1
@fld_name.24 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.25 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.26 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_collections.av\00", align 1
@fld_name.27 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.28 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.29 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_collections.av\00", align 1
@fld_name.30 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.31 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.32 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_collections.av\00", align 1
@.i2s_fmt.33 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@dz_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_collections.av\00", align 1
@.str.34 = private unnamed_addr constant [11 x i8] c"even sum: \00", align 1
@.i2s_fmt.35 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %forin_i128 = alloca i64, align 8
  %forin_len127 = alloca i64, align 8
  %val = alloca i64, align 8
  %forin_i50 = alloca i64, align 8
  %forin_len49 = alloca i64, align 8
  %row = alloca i64, align 8
  %forin_i40 = alloca i64, align 8
  %forin_len39 = alloca i64, align 8
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 42)
  call void @avra_array_push(ptr %0, i64 17)
  call void @avra_array_push(ptr %0, i64 93)
  call void @avra_array_push(ptr %0, i64 65)
  call void @avra_array_push(ptr %0, i64 28)
  call void @avra_array_push(ptr %0, i64 81)
  call void @avra_array_push(ptr %0, i64 54)
  store ptr %0, ptr @scores, align 8
  %scores = load ptr, ptr @scores, align 8
  %1 = call i64 @avra_array_get(ptr %scores, i64 0)
  store i64 %1, ptr @max_val, align 8
  %scores1 = load ptr, ptr @scores, align 8
  %2 = call i64 @avra_array_len(ptr %scores1)
  store i64 %2, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %3 = call i64 @avra_array_get(ptr %scores1, i64 %forin_i_val)
  store i64 %3, ptr %s, align 8
  %s2 = load i64, ptr %s, align 8
  %max_val = load i64, ptr @max_val, align 8
  %sgt = icmp sgt i64 %s2, %max_val
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

forin.incr:                                       ; preds = %ifcont
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %max_val4 = load i64, ptr @max_val, align 8
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %max_val4)
  %widen = sext i32 %5 to i64
  %6 = call i64 @strlen(ptr @.str)
  %7 = call i64 @strlen(ptr %4)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr @.str, i64 %6)
  %cast = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast, %6
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast5, ptr %4, i64 %rhs_len_p1)
  %11 = call i32 @puts(ptr %8)
  %widen6 = sext i32 %11 to i64
  %12 = call ptr @avra_map_new_cstr()
  store ptr %12, ptr @counts, align 8
  %counts = load ptr, ptr @counts, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.2, i64 1)
  %widen7 = sext i32 %14 to i64
  %cast8 = ptrtoint ptr %13 to i64
  call void @avra_map_set_cstr(ptr %counts, ptr @.str.1, i64 %cast8)
  %counts9 = load ptr, ptr @counts, align 8
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.4, i64 2)
  %widen10 = sext i32 %16 to i64
  %cast11 = ptrtoint ptr %15 to i64
  call void @avra_map_set_cstr(ptr %counts9, ptr @.str.3, i64 %cast11)
  %counts12 = load ptr, ptr @counts, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.6, i64 3)
  %widen13 = sext i32 %18 to i64
  %cast14 = ptrtoint ptr %17 to i64
  call void @avra_map_set_cstr(ptr %counts12, ptr @.str.5, i64 %cast14)
  %counts15 = load ptr, ptr @counts, align 8
  %19 = call i64 @avra_map_has_cstr(ptr %counts15, ptr @.str.8)
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.9, i64 %19)
  %widen16 = sext i32 %21 to i64
  %22 = call i64 @strlen(ptr @.str.7)
  %23 = call i64 @strlen(ptr %20)
  %concat_total17 = add i64 %22, %23
  %concat_size18 = add i64 %concat_total17, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size18)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.7, i64 %22)
  %cast19 = ptrtoint ptr %24 to i64
  %dst2_int20 = add i64 %cast19, %22
  %cast21 = inttoptr i64 %dst2_int20 to ptr
  %rhs_len_p122 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast21, ptr %20, i64 %rhs_len_p122)
  %27 = call i32 @puts(ptr %24)
  %widen23 = sext i32 %27 to i64
  %counts24 = load ptr, ptr @counts, align 8
  %28 = call i64 @avra_map_has_cstr(ptr %counts24, ptr @.str.11)
  %29 = call ptr @avra_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.12, i64 %28)
  %widen25 = sext i32 %30 to i64
  %31 = call i64 @strlen(ptr @.str.10)
  %32 = call i64 @strlen(ptr %29)
  %concat_total26 = add i64 %31, %32
  %concat_size27 = add i64 %concat_total26, 1
  %33 = call ptr @avra_rc_alloc(i64 %concat_size27)
  %34 = call ptr @memcpy(ptr %33, ptr @.str.10, i64 %31)
  %cast28 = ptrtoint ptr %33 to i64
  %dst2_int29 = add i64 %cast28, %31
  %cast30 = inttoptr i64 %dst2_int29 to ptr
  %rhs_len_p131 = add i64 %32, 1
  %35 = call ptr @memcpy(ptr %cast30, ptr %29, i64 %rhs_len_p131)
  %36 = call i32 @puts(ptr %33)
  %widen32 = sext i32 %36 to i64
  %counts33 = load ptr, ptr @counts, align 8
  %37 = call i64 @avra_map_len_cstr(ptr %counts33)
  %38 = call ptr @avra_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.13, i64 %37)
  %widen34 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen35 = sext i32 %40 to i64
  %41 = call ptr @avra_array_new()
  %42 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %42, i64 1)
  call void @avra_array_push(ptr %42, i64 2)
  call void @avra_array_push(ptr %42, i64 3)
  %cast36 = ptrtoint ptr %42 to i64
  call void @avra_array_push(ptr %41, i64 %cast36)
  %43 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %43, i64 4)
  call void @avra_array_push(ptr %43, i64 5)
  call void @avra_array_push(ptr %43, i64 6)
  %cast37 = ptrtoint ptr %43 to i64
  call void @avra_array_push(ptr %41, i64 %cast37)
  %44 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %44, i64 7)
  call void @avra_array_push(ptr %44, i64 8)
  call void @avra_array_push(ptr %44, i64 9)
  %cast38 = ptrtoint ptr %44 to i64
  call void @avra_array_push(ptr %41, i64 %cast38)
  store ptr %41, ptr @matrix, align 8
  %45 = call ptr @avra_array_new()
  store ptr %45, ptr @flat, align 8
  %matrix = load ptr, ptr @matrix, align 8
  %46 = call i64 @avra_array_len(ptr %matrix)
  store i64 %46, ptr %forin_len39, align 8
  store i64 0, ptr %forin_i40, align 8
  br label %forin.cond41

ifcont:                                           ; preds = %if_else, %if_then
  br label %forin.incr

if_then:                                          ; preds = %forin.body
  %s3 = load i64, ptr %s, align 8
  store i64 %s3, ptr @max_val, align 8
  br label %ifcont

if_else:                                          ; preds = %forin.body
  br label %ifcont

forin.cond41:                                     ; preds = %forin.incr43, %forin.exit
  %forin_i_val45 = load i64, ptr %forin_i40, align 8
  %forin_len_val46 = load i64, ptr %forin_len39, align 8
  %forin_cmp47 = icmp slt i64 %forin_i_val45, %forin_len_val46
  br i1 %forin_cmp47, label %forin.body42, label %forin.exit44

forin.body42:                                     ; preds = %forin.cond41
  %47 = call i64 @avra_array_get(ptr %matrix, i64 %forin_i_val45)
  store i64 %47, ptr %row, align 8
  %row48 = load ptr, ptr %row, align 8
  %48 = call i64 @avra_array_len(ptr %row48)
  store i64 %48, ptr %forin_len49, align 8
  store i64 0, ptr %forin_i50, align 8
  br label %forin.cond51

forin.incr43:                                     ; preds = %forin.exit54
  %forin_i_old61 = load i64, ptr %forin_i40, align 8
  %forin_next62 = add i64 %forin_i_old61, 1
  store i64 %forin_next62, ptr %forin_i40, align 8
  br label %forin.cond41

forin.exit44:                                     ; preds = %forin.cond41
  %flat63 = load ptr, ptr @flat, align 8
  %49 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %49, i64 -559038737)
  call void @avra_array_push(ptr %49, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast64 = ptrtoint ptr %49 to i64
  %50 = call i64 @avra_array_reduce(ptr %flat63, i64 0, i64 %cast64)
  store i64 %50, ptr @total, align 8
  %total = load i64, ptr @total, align 8
  %51 = call ptr @avra_rc_alloc(i64 32)
  %52 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %51, i64 32, ptr @.i2s_fmt.15, i64 %total)
  %widen65 = sext i32 %52 to i64
  %53 = call i64 @strlen(ptr @.str.14)
  %54 = call i64 @strlen(ptr %51)
  %concat_total66 = add i64 %53, %54
  %concat_size67 = add i64 %concat_total66, 1
  %55 = call ptr @avra_rc_alloc(i64 %concat_size67)
  %56 = call ptr @memcpy(ptr %55, ptr @.str.14, i64 %53)
  %cast68 = ptrtoint ptr %55 to i64
  %dst2_int69 = add i64 %cast68, %53
  %cast70 = inttoptr i64 %dst2_int69 to ptr
  %rhs_len_p171 = add i64 %54, 1
  %57 = call ptr @memcpy(ptr %cast70, ptr %51, i64 %rhs_len_p171)
  %58 = call i32 @puts(ptr %55)
  %widen72 = sext i32 %58 to i64
  %59 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %59, i64 10)
  call void @avra_array_push(ptr %59, i64 20)
  call void @avra_array_push(ptr %59, i64 30)
  call void @avra_array_push(ptr %59, i64 40)
  call void @avra_array_push(ptr %59, i64 50)
  store ptr %59, ptr @nums, align 8
  %nums = load ptr, ptr @nums, align 8
  %60 = call ptr @avra_array_slice(ptr %nums, i64 1, i64 4)
  store ptr %60, ptr @mid, align 8
  %mid = load ptr, ptr @mid, align 8
  %61 = call i64 @avra_array_get(ptr %mid, i64 0)
  %62 = call ptr @avra_rc_alloc(i64 32)
  %63 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %62, i64 32, ptr @.i2s_fmt.17, i64 %61)
  %widen73 = sext i32 %63 to i64
  %64 = call i64 @strlen(ptr @.str.16)
  %65 = call i64 @strlen(ptr %62)
  %concat_total74 = add i64 %64, %65
  %concat_size75 = add i64 %concat_total74, 1
  %66 = call ptr @avra_rc_alloc(i64 %concat_size75)
  %67 = call ptr @memcpy(ptr %66, ptr @.str.16, i64 %64)
  %cast76 = ptrtoint ptr %66 to i64
  %dst2_int77 = add i64 %cast76, %64
  %cast78 = inttoptr i64 %dst2_int77 to ptr
  %rhs_len_p179 = add i64 %65, 1
  %68 = call ptr @memcpy(ptr %cast78, ptr %62, i64 %rhs_len_p179)
  %69 = call i64 @strlen(ptr %66)
  %70 = call i64 @strlen(ptr @.str.18)
  %concat_total80 = add i64 %69, %70
  %concat_size81 = add i64 %concat_total80, 1
  %71 = call ptr @avra_rc_alloc(i64 %concat_size81)
  %72 = call ptr @memcpy(ptr %71, ptr %66, i64 %69)
  %cast82 = ptrtoint ptr %71 to i64
  %dst2_int83 = add i64 %cast82, %69
  %cast84 = inttoptr i64 %dst2_int83 to ptr
  %rhs_len_p185 = add i64 %70, 1
  %73 = call ptr @memcpy(ptr %cast84, ptr @.str.18, i64 %rhs_len_p185)
  %mid86 = load ptr, ptr @mid, align 8
  %74 = call i64 @avra_array_get(ptr %mid86, i64 1)
  %75 = call ptr @avra_rc_alloc(i64 32)
  %76 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %75, i64 32, ptr @.i2s_fmt.19, i64 %74)
  %widen87 = sext i32 %76 to i64
  %77 = call i64 @strlen(ptr %71)
  %78 = call i64 @strlen(ptr %75)
  %concat_total88 = add i64 %77, %78
  %concat_size89 = add i64 %concat_total88, 1
  %79 = call ptr @avra_rc_alloc(i64 %concat_size89)
  %80 = call ptr @memcpy(ptr %79, ptr %71, i64 %77)
  %cast90 = ptrtoint ptr %79 to i64
  %dst2_int91 = add i64 %cast90, %77
  %cast92 = inttoptr i64 %dst2_int91 to ptr
  %rhs_len_p193 = add i64 %78, 1
  %81 = call ptr @memcpy(ptr %cast92, ptr %75, i64 %rhs_len_p193)
  %82 = call i64 @strlen(ptr %79)
  %83 = call i64 @strlen(ptr @.str.20)
  %concat_total94 = add i64 %82, %83
  %concat_size95 = add i64 %concat_total94, 1
  %84 = call ptr @avra_rc_alloc(i64 %concat_size95)
  %85 = call ptr @memcpy(ptr %84, ptr %79, i64 %82)
  %cast96 = ptrtoint ptr %84 to i64
  %dst2_int97 = add i64 %cast96, %82
  %cast98 = inttoptr i64 %dst2_int97 to ptr
  %rhs_len_p199 = add i64 %83, 1
  %86 = call ptr @memcpy(ptr %cast98, ptr @.str.20, i64 %rhs_len_p199)
  %mid100 = load ptr, ptr @mid, align 8
  %87 = call i64 @avra_array_get(ptr %mid100, i64 2)
  %88 = call ptr @avra_rc_alloc(i64 32)
  %89 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %88, i64 32, ptr @.i2s_fmt.21, i64 %87)
  %widen101 = sext i32 %89 to i64
  %90 = call i64 @strlen(ptr %84)
  %91 = call i64 @strlen(ptr %88)
  %concat_total102 = add i64 %90, %91
  %concat_size103 = add i64 %concat_total102, 1
  %92 = call ptr @avra_rc_alloc(i64 %concat_size103)
  %93 = call ptr @memcpy(ptr %92, ptr %84, i64 %90)
  %cast104 = ptrtoint ptr %92 to i64
  %dst2_int105 = add i64 %cast104, %90
  %cast106 = inttoptr i64 %dst2_int105 to ptr
  %rhs_len_p1107 = add i64 %91, 1
  %94 = call ptr @memcpy(ptr %cast106, ptr %88, i64 %rhs_len_p1107)
  %95 = call i32 @puts(ptr %92)
  %widen108 = sext i32 %95 to i64
  %mid109 = load ptr, ptr @mid, align 8
  %96 = call i64 @avra_array_len(ptr %mid109)
  %97 = call ptr @avra_rc_alloc(i64 32)
  %98 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %97, i64 32, ptr @.i2s_fmt.23, i64 %96)
  %widen110 = sext i32 %98 to i64
  %99 = call i64 @strlen(ptr @.str.22)
  %100 = call i64 @strlen(ptr %97)
  %concat_total111 = add i64 %99, %100
  %concat_size112 = add i64 %concat_total111, 1
  %101 = call ptr @avra_rc_alloc(i64 %concat_size112)
  %102 = call ptr @memcpy(ptr %101, ptr @.str.22, i64 %99)
  %cast113 = ptrtoint ptr %101 to i64
  %dst2_int114 = add i64 %cast113, %99
  %cast115 = inttoptr i64 %dst2_int114 to ptr
  %rhs_len_p1116 = add i64 %100, 1
  %103 = call ptr @memcpy(ptr %cast115, ptr %97, i64 %rhs_len_p1116)
  %104 = call i32 @puts(ptr %101)
  %widen117 = sext i32 %104 to i64
  %105 = call ptr @avra_array_new()
  %106 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %106, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr118 = getelementptr inbounds nuw %Point, ptr %106, i32 0, i32 1
  store i64 2, ptr %fld_ptr118, align 8
  %cast119 = ptrtoint ptr %106 to i64
  call void @avra_array_push(ptr %105, i64 %cast119)
  %107 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr120 = getelementptr inbounds nuw %Point, ptr %107, i32 0, i32 0
  store i64 3, ptr %fld_ptr120, align 8
  %fld_ptr121 = getelementptr inbounds nuw %Point, ptr %107, i32 0, i32 1
  store i64 4, ptr %fld_ptr121, align 8
  %cast122 = ptrtoint ptr %107 to i64
  call void @avra_array_push(ptr %105, i64 %cast122)
  %108 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr123 = getelementptr inbounds nuw %Point, ptr %108, i32 0, i32 0
  store i64 5, ptr %fld_ptr123, align 8
  %fld_ptr124 = getelementptr inbounds nuw %Point, ptr %108, i32 0, i32 1
  store i64 6, ptr %fld_ptr124, align 8
  %cast125 = ptrtoint ptr %108 to i64
  call void @avra_array_push(ptr %105, i64 %cast125)
  store ptr %105, ptr @points, align 8
  %points = load ptr, ptr @points, align 8
  %109 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %109, i64 -559038737)
  call void @avra_array_push(ptr %109, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast126 = ptrtoint ptr %109 to i64
  %110 = call ptr @avra_array_map(ptr %points, i64 %cast126)
  store ptr %110, ptr @distances, align 8
  %distances = load ptr, ptr @distances, align 8
  %111 = call i64 @avra_array_len(ptr %distances)
  store i64 %111, ptr %forin_len127, align 8
  store i64 0, ptr %forin_i128, align 8
  br label %forin.cond129

forin.cond51:                                     ; preds = %forin.incr53, %forin.body42
  %forin_i_val55 = load i64, ptr %forin_i50, align 8
  %forin_len_val56 = load i64, ptr %forin_len49, align 8
  %forin_cmp57 = icmp slt i64 %forin_i_val55, %forin_len_val56
  br i1 %forin_cmp57, label %forin.body52, label %forin.exit54

forin.body52:                                     ; preds = %forin.cond51
  %112 = call i64 @avra_array_get(ptr %row48, i64 %forin_i_val55)
  store i64 %112, ptr %val, align 8
  %flat = load ptr, ptr @flat, align 8
  %val58 = load i64, ptr %val, align 8
  call void @avra_array_push(ptr %flat, i64 %val58)
  br label %forin.incr53

forin.incr53:                                     ; preds = %forin.body52
  %forin_i_old59 = load i64, ptr %forin_i50, align 8
  %forin_next60 = add i64 %forin_i_old59, 1
  store i64 %forin_next60, ptr %forin_i50, align 8
  br label %forin.cond51

forin.exit54:                                     ; preds = %forin.cond51
  br label %forin.incr43

forin.cond129:                                    ; preds = %forin.incr131, %forin.exit44
  %forin_i_val133 = load i64, ptr %forin_i128, align 8
  %forin_len_val134 = load i64, ptr %forin_len127, align 8
  %forin_cmp135 = icmp slt i64 %forin_i_val133, %forin_len_val134
  br i1 %forin_cmp135, label %forin.body130, label %forin.exit132

forin.body130:                                    ; preds = %forin.cond129
  %113 = call i64 @avra_array_get(ptr %distances, i64 %forin_i_val133)
  store i64 %113, ptr %d, align 8
  %d136 = load i64, ptr %d, align 8
  %114 = call ptr @avra_rc_alloc(i64 32)
  %115 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %114, i64 32, ptr @.i2s_fmt.33, i64 %d136)
  %widen137 = sext i32 %115 to i64
  %116 = call i32 @puts(ptr %114)
  %widen138 = sext i32 %116 to i64
  br label %forin.incr131

forin.incr131:                                    ; preds = %forin.body130
  %forin_i_old139 = load i64, ptr %forin_i128, align 8
  %forin_next140 = add i64 %forin_i_old139, 1
  store i64 %forin_next140, ptr %forin_i128, align 8
  br label %forin.cond129

forin.exit132:                                    ; preds = %forin.cond129
  %117 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %117, i64 1)
  call void @avra_array_push(ptr %117, i64 2)
  call void @avra_array_push(ptr %117, i64 3)
  call void @avra_array_push(ptr %117, i64 4)
  call void @avra_array_push(ptr %117, i64 5)
  call void @avra_array_push(ptr %117, i64 6)
  call void @avra_array_push(ptr %117, i64 7)
  call void @avra_array_push(ptr %117, i64 8)
  call void @avra_array_push(ptr %117, i64 9)
  call void @avra_array_push(ptr %117, i64 10)
  %118 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %118, i64 -559038737)
  call void @avra_array_push(ptr %118, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast141 = ptrtoint ptr %118 to i64
  %119 = call ptr @avra_array_filter(ptr %117, i64 %cast141)
  store ptr %119, ptr @evens, align 8
  %evens = load ptr, ptr @evens, align 8
  %120 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %120, i64 -559038737)
  call void @avra_array_push(ptr %120, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast142 = ptrtoint ptr %120 to i64
  %121 = call i64 @avra_array_reduce(ptr %evens, i64 0, i64 %cast142)
  store i64 %121, ptr @even_sum, align 8
  %even_sum = load i64, ptr @even_sum, align 8
  %122 = call ptr @avra_rc_alloc(i64 32)
  %123 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %122, i64 32, ptr @.i2s_fmt.35, i64 %even_sum)
  %widen143 = sext i32 %123 to i64
  %124 = call i64 @strlen(ptr @.str.34)
  %125 = call i64 @strlen(ptr %122)
  %concat_total144 = add i64 %124, %125
  %concat_size145 = add i64 %concat_total144, 1
  %126 = call ptr @avra_rc_alloc(i64 %concat_size145)
  %127 = call ptr @memcpy(ptr %126, ptr @.str.34, i64 %124)
  %cast146 = ptrtoint ptr %126 to i64
  %dst2_int147 = add i64 %cast146, %124
  %cast148 = inttoptr i64 %dst2_int147 to ptr
  %rhs_len_p1149 = add i64 %125, 1
  %128 = call ptr @memcpy(ptr %cast148, ptr %122, i64 %rhs_len_p1149)
  %129 = call i32 @puts(ptr %126)
  %widen150 = sext i32 %129 to i64
  %130 = call i32 @avra_test_summary()
  %widen151 = sext i32 %130 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0, i64 %1) {
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

define i64 @__lambda_1(ptr %0) {
entry:
  %p = alloca ptr, align 8
  store ptr %0, ptr %p, align 8
  %p1 = load ptr, ptr %p, align 8
  %cast = ptrtoint ptr %p1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 102, i64 40)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %p2 = load ptr, ptr %p, align 8
  %cast3 = ptrtoint ptr %p2 to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @avra_null_deref_trap(ptr @fld_name.24, i64 1, ptr @sty_name.25, i64 5, i64 %null_ext5, ptr @src_file.26, i64 102, i64 40)
  %x_ptr6 = getelementptr inbounds nuw %Point, ptr %p2, i32 0, i32 0
  %x7 = load i64, ptr %x_ptr6, align 8
  %mul = mul i64 %x, %x7
  %p8 = load ptr, ptr %p, align 8
  %cast9 = ptrtoint ptr %p8 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @avra_null_deref_trap(ptr @fld_name.27, i64 1, ptr @sty_name.28, i64 5, i64 %null_ext11, ptr @src_file.29, i64 102, i64 40)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p8, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %p12 = load ptr, ptr %p, align 8
  %cast13 = ptrtoint ptr %p12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.30, i64 1, ptr @sty_name.31, i64 5, i64 %null_ext15, ptr @src_file.32, i64 102, i64 40)
  %y_ptr16 = getelementptr inbounds nuw %Point, ptr %p12, i32 0, i32 1
  %y17 = load i64, ptr %y_ptr16, align 8
  %mul18 = mul i64 %y, %y17
  %add = add i64 %mul, %mul18
  ret i64 %add
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 102, i64 46)
  %mod = srem i64 %x1, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  ret i64 %eq_ext
}

define i64 @__lambda_3(i64 %0, i64 %1) {
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
