; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@words = global i64 0
@uppers = global i64 0
@items = global i64 0
@apples = global i64 0
@count = global i64 0
@desc = global i64 0
@csv = global i64 0
@parts = global i64 0
@messy = global i64 0
@clean = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"foo\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"bar\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"apple pie\00", align 1
@.str.5 = private unnamed_addr constant [13 x i8] c"banana split\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"apple sauce\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"cherry\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"apple\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"no items\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"one item\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c" items\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_strings_it_match.av\00", align 1
@.str.13 = private unnamed_addr constant [18 x i8] c"Alice,30,Engineer\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c"name=\00", align 1
@.str.16 = private unnamed_addr constant [7 x i8] c", age=\00", align 1
@.str.17 = private unnamed_addr constant [8 x i8] c", role=\00", align 1
@.str.18 = private unnamed_addr constant [16 x i8] c"  hello world  \00", align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.20 = private unnamed_addr constant [5 x i8] c"avra\00", align 1

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
  %pmatch_result = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str to i64))
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str.1 to i64))
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str.2 to i64))
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str.3 to i64))
  store ptr %0, ptr @words, align 8
  %words = load ptr, ptr @words, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @avra_array_map(ptr %words, i64 %cast)
  store ptr %2, ptr @uppers, align 8
  %uppers = load ptr, ptr @uppers, align 8
  %3 = call i64 @avra_array_get(ptr %uppers, i64 0)
  %cast1 = inttoptr i64 %3 to ptr
  %4 = call i32 @puts(ptr %cast1)
  %widen = sext i32 %4 to i64
  %uppers2 = load ptr, ptr @uppers, align 8
  %5 = call i64 @avra_array_get(ptr %uppers2, i64 1)
  %cast3 = inttoptr i64 %5 to ptr
  %6 = call i32 @puts(ptr %cast3)
  %widen4 = sext i32 %6 to i64
  %7 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @.str.4 to i64))
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @.str.5 to i64))
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @.str.6 to i64))
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @.str.7 to i64))
  store ptr %7, ptr @items, align 8
  %items = load ptr, ptr @items, align 8
  %8 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %8, i64 -559038737)
  call void @avra_array_push(ptr %8, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast5 = ptrtoint ptr %8 to i64
  %9 = call ptr @avra_array_filter(ptr %items, i64 %cast5)
  store ptr %9, ptr @apples, align 8
  %apples = load ptr, ptr @apples, align 8
  %10 = call i64 @avra_array_len(ptr %apples)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt, i64 %10)
  %widen6 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen7 = sext i32 %13 to i64
  %apples8 = load ptr, ptr @apples, align 8
  %14 = call i64 @avra_array_get(ptr %apples8, i64 0)
  %cast9 = inttoptr i64 %14 to ptr
  %15 = call i32 @puts(ptr %cast9)
  %widen10 = sext i32 %15 to i64
  %apples11 = load ptr, ptr @apples, align 8
  %16 = call i64 @avra_array_get(ptr %apples11, i64 1)
  %cast12 = inttoptr i64 %16 to ptr
  %17 = call i32 @puts(ptr %cast12)
  %widen13 = sext i32 %17 to i64
  store i64 3, ptr @count, align 8
  %count = load i64, ptr @count, align 8
  store i64 0, ptr %pmatch_result, align 8
  %lit_eq = icmp eq i64 %count, 0
  br i1 %lit_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body17, %parm_body14, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  store i64 %pmatch_val, ptr @desc, align 8
  %desc = load ptr, ptr @desc, align 8
  %18 = call i32 @puts(ptr %desc)
  %widen24 = sext i32 %18 to i64
  store ptr @.str.13, ptr @csv, align 8
  %csv = load ptr, ptr @csv, align 8
  %19 = call ptr @avra_str_split(ptr %csv, ptr @.str.14)
  store ptr %19, ptr @parts, align 8
  %parts = load ptr, ptr @parts, align 8
  %20 = call i64 @avra_array_get(ptr %parts, i64 0)
  %rhs_ptr = inttoptr i64 %20 to ptr
  %21 = call i64 @strlen(ptr @.str.15)
  %22 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total25 = add i64 %21, %22
  %concat_size26 = add i64 %concat_total25, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %24 = call ptr @memcpy(ptr %23, ptr @.str.15, i64 %21)
  %cast27 = ptrtoint ptr %23 to i64
  %dst2_int28 = add i64 %cast27, %21
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast29, ptr %rhs_ptr, i64 %rhs_len_p130)
  %26 = call i64 @strlen(ptr %23)
  %27 = call i64 @strlen(ptr @.str.16)
  %concat_total31 = add i64 %26, %27
  %concat_size32 = add i64 %concat_total31, 1
  %28 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %29 = call ptr @memcpy(ptr %28, ptr %23, i64 %26)
  %cast33 = ptrtoint ptr %28 to i64
  %dst2_int34 = add i64 %cast33, %26
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %27, 1
  %30 = call ptr @memcpy(ptr %cast35, ptr @.str.16, i64 %rhs_len_p136)
  %parts37 = load ptr, ptr @parts, align 8
  %31 = call i64 @avra_array_get(ptr %parts37, i64 1)
  %rhs_ptr38 = inttoptr i64 %31 to ptr
  %32 = call i64 @strlen(ptr %28)
  %33 = call i64 @strlen(ptr %rhs_ptr38)
  %concat_total39 = add i64 %32, %33
  %concat_size40 = add i64 %concat_total39, 1
  %34 = call ptr @avra_rc_alloc(i64 %concat_size40)
  %35 = call ptr @memcpy(ptr %34, ptr %28, i64 %32)
  %cast41 = ptrtoint ptr %34 to i64
  %dst2_int42 = add i64 %cast41, %32
  %cast43 = inttoptr i64 %dst2_int42 to ptr
  %rhs_len_p144 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast43, ptr %rhs_ptr38, i64 %rhs_len_p144)
  %37 = call i64 @strlen(ptr %34)
  %38 = call i64 @strlen(ptr @.str.17)
  %concat_total45 = add i64 %37, %38
  %concat_size46 = add i64 %concat_total45, 1
  %39 = call ptr @avra_rc_alloc(i64 %concat_size46)
  %40 = call ptr @memcpy(ptr %39, ptr %34, i64 %37)
  %cast47 = ptrtoint ptr %39 to i64
  %dst2_int48 = add i64 %cast47, %37
  %cast49 = inttoptr i64 %dst2_int48 to ptr
  %rhs_len_p150 = add i64 %38, 1
  %41 = call ptr @memcpy(ptr %cast49, ptr @.str.17, i64 %rhs_len_p150)
  %parts51 = load ptr, ptr @parts, align 8
  %42 = call i64 @avra_array_get(ptr %parts51, i64 2)
  %rhs_ptr52 = inttoptr i64 %42 to ptr
  %43 = call i64 @strlen(ptr %39)
  %44 = call i64 @strlen(ptr %rhs_ptr52)
  %concat_total53 = add i64 %43, %44
  %concat_size54 = add i64 %concat_total53, 1
  %45 = call ptr @avra_rc_alloc(i64 %concat_size54)
  %46 = call ptr @memcpy(ptr %45, ptr %39, i64 %43)
  %cast55 = ptrtoint ptr %45 to i64
  %dst2_int56 = add i64 %cast55, %43
  %cast57 = inttoptr i64 %dst2_int56 to ptr
  %rhs_len_p158 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast57, ptr %rhs_ptr52, i64 %rhs_len_p158)
  %48 = call i32 @puts(ptr %45)
  %widen59 = sext i32 %48 to i64
  store ptr @.str.18, ptr @messy, align 8
  %messy = load ptr, ptr @messy, align 8
  %49 = call ptr @avra_str_trim(ptr %messy)
  %50 = call ptr @avra_str_replace(ptr %49, ptr @.str.19, ptr @.str.20)
  %51 = call ptr @avra_str_to_upper(ptr %50)
  store ptr %51, ptr @clean, align 8
  %clean = load ptr, ptr @clean, align 8
  %52 = call i32 @puts(ptr %clean)
  %widen60 = sext i32 %52 to i64
  %53 = call i32 @avra_test_summary()
  %widen61 = sext i32 %53 to i64
  call void @avra_rc_collect()
  ret i64 0

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.9 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %lit_eq16 = icmp eq i64 %count, 1
  br i1 %lit_eq16, label %parm_body14, label %parm_next15

parm_body14:                                      ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next15:                                      ; preds = %parm_next
  br label %parm_body17

parm_body17:                                      ; preds = %parm_next15
  %count19 = load i64, ptr @count, align 8
  %54 = call ptr @avra_rc_alloc(i64 32)
  %55 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %54, i64 32, ptr @.i2s_fmt.11, i64 %count19)
  %widen20 = sext i32 %55 to i64
  %56 = call i64 @strlen(ptr %54)
  %57 = call i64 @strlen(ptr @.str.12)
  %concat_total = add i64 %56, %57
  %concat_size = add i64 %concat_total, 1
  %58 = call ptr @avra_rc_alloc(i64 %concat_size)
  %59 = call ptr @memcpy(ptr %58, ptr %54, i64 %56)
  %cast21 = ptrtoint ptr %58 to i64
  %dst2_int = add i64 %cast21, %56
  %cast22 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %57, 1
  %60 = call ptr @memcpy(ptr %cast22, ptr @.str.12, i64 %rhs_len_p1)
  %cast23 = ptrtoint ptr %58 to i64
  store i64 %cast23, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next18:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 16)
  unreachable
}

define i64 @__lambda_0(ptr %0) {
entry:
  %it = alloca ptr, align 8
  store ptr %0, ptr %it, align 8
  %it1 = load ptr, ptr %it, align 8
  %1 = call ptr @avra_str_to_upper(ptr %it1)
  %cast = ptrtoint ptr %1 to i64
  ret i64 %cast
}

define i64 @__lambda_1(ptr %0) {
entry:
  %it = alloca ptr, align 8
  store ptr %0, ptr %it, align 8
  %it1 = load ptr, ptr %it, align 8
  %1 = call i64 @avra_str_contains(ptr %it1, ptr @.str.8)
  ret i64 %1
}
