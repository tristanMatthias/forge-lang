; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { i64, i64 }

@x = global i64 0
@a = global i64 0
@b = global i64 0
@p = global i64 0
@name = global i64 0
@.str = private unnamed_addr constant [15 x i8] c"the answer is \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c" + \00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c" = \00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"point: \00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/template_expr.av\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.9 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.10 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.11 = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/template_expr.av\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [12 x i8] c"double 5 = \00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.16 = private unnamed_addr constant [7 x i8] c"hello \00", align 1

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

define i64 @double(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, 2
  ret i64 %mul
}

define i64 @main() {
entry:
  store i64 42, ptr @x, align 8
  %x = load i64, ptr @x, align 8
  %0 = call ptr @avra_rc_alloc(i64 32)
  %1 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %0, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen = sext i32 %1 to i64
  %2 = call i64 @strlen(ptr @.str)
  %3 = call i64 @strlen(ptr %0)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr @.str, i64 %2)
  %cast = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast, %2
  %cast1 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast1, ptr %0, i64 %rhs_len_p1)
  %7 = call i32 @puts(ptr %4)
  %widen2 = sext i32 %7 to i64
  store i64 3, ptr @a, align 8
  store i64 4, ptr @b, align 8
  %a = load i64, ptr @a, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.1, i64 %a)
  %widen3 = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr %8)
  %11 = call i64 @strlen(ptr @.str.2)
  %concat_total4 = add i64 %10, %11
  %concat_size5 = add i64 %concat_total4, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %13 = call ptr @memcpy(ptr %12, ptr %8, i64 %10)
  %cast6 = ptrtoint ptr %12 to i64
  %dst2_int7 = add i64 %cast6, %10
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast8, ptr @.str.2, i64 %rhs_len_p19)
  %b = load i64, ptr @b, align 8
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.3, i64 %b)
  %widen10 = sext i32 %16 to i64
  %17 = call i64 @strlen(ptr %12)
  %18 = call i64 @strlen(ptr %15)
  %concat_total11 = add i64 %17, %18
  %concat_size12 = add i64 %concat_total11, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size12)
  %20 = call ptr @memcpy(ptr %19, ptr %12, i64 %17)
  %cast13 = ptrtoint ptr %19 to i64
  %dst2_int14 = add i64 %cast13, %17
  %cast15 = inttoptr i64 %dst2_int14 to ptr
  %rhs_len_p116 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast15, ptr %15, i64 %rhs_len_p116)
  %22 = call i64 @strlen(ptr %19)
  %23 = call i64 @strlen(ptr @.str.4)
  %concat_total17 = add i64 %22, %23
  %concat_size18 = add i64 %concat_total17, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size18)
  %25 = call ptr @memcpy(ptr %24, ptr %19, i64 %22)
  %cast19 = ptrtoint ptr %24 to i64
  %dst2_int20 = add i64 %cast19, %22
  %cast21 = inttoptr i64 %dst2_int20 to ptr
  %rhs_len_p122 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast21, ptr @.str.4, i64 %rhs_len_p122)
  %a23 = load i64, ptr @a, align 8
  %b24 = load i64, ptr @b, align 8
  %add = add i64 %a23, %b24
  %27 = call ptr @avra_rc_alloc(i64 32)
  %28 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %27, i64 32, ptr @.i2s_fmt.5, i64 %add)
  %widen25 = sext i32 %28 to i64
  %29 = call i64 @strlen(ptr %24)
  %30 = call i64 @strlen(ptr %27)
  %concat_total26 = add i64 %29, %30
  %concat_size27 = add i64 %concat_total26, 1
  %31 = call ptr @avra_rc_alloc(i64 %concat_size27)
  %32 = call ptr @memcpy(ptr %31, ptr %24, i64 %29)
  %cast28 = ptrtoint ptr %31 to i64
  %dst2_int29 = add i64 %cast28, %29
  %cast30 = inttoptr i64 %dst2_int29 to ptr
  %rhs_len_p131 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast30, ptr %27, i64 %rhs_len_p131)
  %34 = call i32 @puts(ptr %31)
  %widen32 = sext i32 %34 to i64
  %35 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %35, i32 0, i32 0
  store i64 10, ptr %fld_ptr, align 8
  %fld_ptr33 = getelementptr inbounds nuw %Point, ptr %35, i32 0, i32 1
  store i64 20, ptr %fld_ptr33, align 8
  %cast34 = ptrtoint ptr %35 to i64
  store i64 %cast34, ptr @p, align 8
  %p = load ptr, ptr @p, align 8
  %cast35 = ptrtoint ptr %p to i64
  %null_chk = icmp eq i64 %cast35, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 99, i64 13)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p, i32 0, i32 0
  %x36 = load i64, ptr %x_ptr, align 8
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.7, i64 %x36)
  %widen37 = sext i32 %37 to i64
  %38 = call i64 @strlen(ptr @.str.6)
  %39 = call i64 @strlen(ptr %36)
  %concat_total38 = add i64 %38, %39
  %concat_size39 = add i64 %concat_total38, 1
  %40 = call ptr @avra_rc_alloc(i64 %concat_size39)
  %41 = call ptr @memcpy(ptr %40, ptr @.str.6, i64 %38)
  %cast40 = ptrtoint ptr %40 to i64
  %dst2_int41 = add i64 %cast40, %38
  %cast42 = inttoptr i64 %dst2_int41 to ptr
  %rhs_len_p143 = add i64 %39, 1
  %42 = call ptr @memcpy(ptr %cast42, ptr %36, i64 %rhs_len_p143)
  %43 = call i64 @strlen(ptr %40)
  %44 = call i64 @strlen(ptr @.str.8)
  %concat_total44 = add i64 %43, %44
  %concat_size45 = add i64 %concat_total44, 1
  %45 = call ptr @avra_rc_alloc(i64 %concat_size45)
  %46 = call ptr @memcpy(ptr %45, ptr %40, i64 %43)
  %cast46 = ptrtoint ptr %45 to i64
  %dst2_int47 = add i64 %cast46, %43
  %cast48 = inttoptr i64 %dst2_int47 to ptr
  %rhs_len_p149 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast48, ptr @.str.8, i64 %rhs_len_p149)
  %p50 = load ptr, ptr @p, align 8
  %cast51 = ptrtoint ptr %p50 to i64
  %null_chk52 = icmp eq i64 %cast51, 0
  %null_ext53 = zext i1 %null_chk52 to i64
  call void @avra_null_deref_trap(ptr @fld_name.9, i64 1, ptr @sty_name.10, i64 5, i64 %null_ext53, ptr @src_file.11, i64 99, i64 13)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p50, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %48 = call ptr @avra_rc_alloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @.i2s_fmt.12, i64 %y)
  %widen54 = sext i32 %49 to i64
  %50 = call i64 @strlen(ptr %45)
  %51 = call i64 @strlen(ptr %48)
  %concat_total55 = add i64 %50, %51
  %concat_size56 = add i64 %concat_total55, 1
  %52 = call ptr @avra_rc_alloc(i64 %concat_size56)
  %53 = call ptr @memcpy(ptr %52, ptr %45, i64 %50)
  %cast57 = ptrtoint ptr %52 to i64
  %dst2_int58 = add i64 %cast57, %50
  %cast59 = inttoptr i64 %dst2_int58 to ptr
  %rhs_len_p160 = add i64 %51, 1
  %54 = call ptr @memcpy(ptr %cast59, ptr %48, i64 %rhs_len_p160)
  %55 = call i32 @puts(ptr %52)
  %widen61 = sext i32 %55 to i64
  %56 = call i64 @double(i64 5)
  %57 = call ptr @avra_rc_alloc(i64 32)
  %58 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %57, i64 32, ptr @.i2s_fmt.14, i64 %56)
  %widen62 = sext i32 %58 to i64
  %59 = call i64 @strlen(ptr @.str.13)
  %60 = call i64 @strlen(ptr %57)
  %concat_total63 = add i64 %59, %60
  %concat_size64 = add i64 %concat_total63, 1
  %61 = call ptr @avra_rc_alloc(i64 %concat_size64)
  %62 = call ptr @memcpy(ptr %61, ptr @.str.13, i64 %59)
  %cast65 = ptrtoint ptr %61 to i64
  %dst2_int66 = add i64 %cast65, %59
  %cast67 = inttoptr i64 %dst2_int66 to ptr
  %rhs_len_p168 = add i64 %60, 1
  %63 = call ptr @memcpy(ptr %cast67, ptr %57, i64 %rhs_len_p168)
  %64 = call i32 @puts(ptr %61)
  %widen69 = sext i32 %64 to i64
  store ptr @.str.15, ptr @name, align 8
  %name = load ptr, ptr @name, align 8
  %65 = call i64 @strlen(ptr @.str.16)
  %66 = call i64 @strlen(ptr %name)
  %concat_total70 = add i64 %65, %66
  %concat_size71 = add i64 %concat_total70, 1
  %67 = call ptr @avra_rc_alloc(i64 %concat_size71)
  %68 = call ptr @memcpy(ptr %67, ptr @.str.16, i64 %65)
  %cast72 = ptrtoint ptr %67 to i64
  %dst2_int73 = add i64 %cast72, %65
  %cast74 = inttoptr i64 %dst2_int73 to ptr
  %rhs_len_p175 = add i64 %66, 1
  %69 = call ptr @memcpy(ptr %cast74, ptr %name, i64 %rhs_len_p175)
  %70 = call i32 @puts(ptr %67)
  %widen76 = sext i32 %70 to i64
  %71 = call i32 @avra_test_summary()
  %widen77 = sext i32 %71 to i64
  call void @avra_rc_collect()
  ret i64 0
}
