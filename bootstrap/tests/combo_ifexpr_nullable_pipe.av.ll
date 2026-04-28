; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Pair = type { i64, i64 }

@x = global i64 0
@piped = global i64 0
@r1 = global i64 0
@r2 = global i64 0
@p = global i64 0
@dz_file = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ifexpr_nullable_pipe.av\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"hello \00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"stranger\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"value: \00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"double: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"a\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"Pair\00", align 1
@src_file = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ifexpr_nullable_pipe.av\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.11 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@sty_name.12 = private unnamed_addr constant [5 x i8] c"Pair\00", align 1
@src_file.13 = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ifexpr_nullable_pipe.av\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @negate(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %neg = sub i64 0, %n1
  ret i64 %neg
}

define i64 @safe_div(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %b1 = load i64, ptr %b, align 8
  %eq = icmp eq i64 %b1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %a2 = load i64, ptr %a, align 8
  %b3 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b3, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 112, i64 15)
  %div = sdiv i64 %a2, %b3
  ret i64 %div

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont
}

define ptr @greet(ptr %0) {
entry:
  %nc_result = alloca i64, align 8
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  %name1 = load ptr, ptr %name, align 8
  %nc_null = icmp eq ptr %name1, null
  %cast = ptrtoint ptr %name1 to i64
  store i64 %cast, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

nc_rhs:                                           ; preds = %entry
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %entry
  %nc_val = load i64, ptr %nc_result, align 8
  %rhs_ptr = inttoptr i64 %nc_val to ptr
  %1 = call i64 @strlen(ptr @.str)
  %2 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %rhs_ptr, i64 %rhs_len_p1)
  ret ptr %3
}

define i64 @main() {
entry:
  %ife_result42 = alloca i64, align 8
  %nc_result31 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %ife_result21 = alloca i64, align 8
  %ife_result5 = alloca i64, align 8
  %ife_result = alloca i64, align 8
  store i64 42, ptr @x, align 8
  %x = load i64, ptr @x, align 8
  %sgt = icmp sgt i64 %x, 0
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %rhs_ptr = inttoptr i64 %ife_val to ptr
  %0 = call i64 @strlen(ptr @.str.2)
  %1 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total = add i64 %0, %1
  %concat_size = add i64 %concat_total, 1
  %2 = call ptr @avra_rc_alloc(i64 %concat_size)
  %3 = call ptr @memcpy(ptr %2, ptr @.str.2, i64 %0)
  %cast = ptrtoint ptr %2 to i64
  %dst2_int = add i64 %cast, %0
  %cast1 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %1, 1
  %4 = call ptr @memcpy(ptr %cast1, ptr %rhs_ptr, i64 %rhs_len_p1)
  %5 = call i32 @puts(ptr %2)
  %widen = sext i32 %5 to i64
  %x2 = load i64, ptr @x, align 8
  %sgt3 = icmp sgt i64 %x2, 20
  %sgt_ext4 = zext i1 %sgt3 to i64
  %ife_cond7 = icmp ne i64 %sgt_ext4, 0
  br i1 %ife_cond7, label %ife_then8, label %ife_else9

ife_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_end6:                                         ; preds = %ife_else9, %ife_then8
  %ife_val12 = load i64, ptr %ife_result5, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %ife_val12)
  %widen13 = sext i32 %7 to i64
  %8 = call i64 @strlen(ptr @.str.5)
  %9 = call i64 @strlen(ptr %6)
  %concat_total14 = add i64 %8, %9
  %concat_size15 = add i64 %concat_total14, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %11 = call ptr @memcpy(ptr %10, ptr @.str.5, i64 %8)
  %cast16 = ptrtoint ptr %10 to i64
  %dst2_int17 = add i64 %cast16, %8
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast18, ptr %6, i64 %rhs_len_p119)
  %13 = call i32 @puts(ptr %10)
  %widen20 = sext i32 %13 to i64
  br i1 true, label %ife_then23, label %ife_else24

ife_then8:                                        ; preds = %ife_end
  %x10 = load i64, ptr @x, align 8
  %mul = mul i64 %x10, 2
  store i64 %mul, ptr %ife_result5, align 8
  br label %ife_end6

ife_else9:                                        ; preds = %ife_end
  %x11 = load i64, ptr @x, align 8
  store i64 %x11, ptr %ife_result5, align 8
  br label %ife_end6

ife_end22:                                        ; preds = %ife_else24, %ife_then23
  %ife_val25 = load i64, ptr %ife_result21, align 8
  %14 = call i64 @double(i64 %ife_val25)
  %15 = call i64 @negate(i64 %14)
  store i64 %15, ptr @piped, align 8
  %piped = load i64, ptr @piped, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.6, i64 %piped)
  %widen26 = sext i32 %17 to i64
  %18 = call i32 @puts(ptr %16)
  %widen27 = sext i32 %18 to i64
  %19 = call i64 @safe_div(i64 10, i64 2)
  %nc_null = icmp eq i64 %19, 0
  store i64 %19, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

ife_then23:                                       ; preds = %ife_end6
  store i64 5, ptr %ife_result21, align 8
  br label %ife_end22

ife_else24:                                       ; preds = %ife_end6
  store i64 10, ptr %ife_result21, align 8
  br label %ife_end22

nc_rhs:                                           ; preds = %ife_end22
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %ife_end22
  %nc_val = load i64, ptr %nc_result, align 8
  store i64 %nc_val, ptr @r1, align 8
  %20 = call i64 @safe_div(i64 10, i64 0)
  %nc_null28 = icmp eq i64 %20, 0
  store i64 %20, ptr %nc_result31, align 8
  br i1 %nc_null28, label %nc_rhs29, label %nc_end30

nc_rhs29:                                         ; preds = %nc_end
  store i64 -1, ptr %nc_result31, align 8
  br label %nc_end30

nc_end30:                                         ; preds = %nc_rhs29, %nc_end
  %nc_val32 = load i64, ptr %nc_result31, align 8
  store i64 %nc_val32, ptr @r2, align 8
  %r1 = load i64, ptr @r1, align 8
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.7, i64 %r1)
  %widen33 = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen34 = sext i32 %23 to i64
  %r2 = load i64, ptr @r2, align 8
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.8, i64 %r2)
  %widen35 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen36 = sext i32 %26 to i64
  %27 = call ptr @greet(ptr @.str.9)
  %28 = call i32 @puts(ptr %27)
  %widen37 = sext i32 %28 to i64
  %29 = call ptr @greet(ptr null)
  %30 = call i32 @puts(ptr %29)
  %widen38 = sext i32 %30 to i64
  %x39 = load i64, ptr @x, align 8
  %sgt40 = icmp sgt i64 %x39, 0
  %sgt_ext41 = zext i1 %sgt40 to i64
  %ife_cond44 = icmp ne i64 %sgt_ext41, 0
  br i1 %ife_cond44, label %ife_then45, label %ife_else46

ife_end43:                                        ; preds = %ife_else46, %ife_then45
  %ife_val52 = load i64, ptr %ife_result42, align 8
  store i64 %ife_val52, ptr @p, align 8
  %p = load ptr, ptr @p, align 8
  %cast53 = ptrtoint ptr %p to i64
  %null_chk = icmp eq i64 %cast53, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 112, i64 32)
  %a_ptr = getelementptr inbounds nuw %Pair, ptr %p, i32 0, i32 0
  %a = load i64, ptr %a_ptr, align 8
  %31 = call ptr @avra_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.10, i64 %a)
  %widen54 = sext i32 %32 to i64
  %33 = call i32 @puts(ptr %31)
  %widen55 = sext i32 %33 to i64
  %p56 = load ptr, ptr @p, align 8
  %cast57 = ptrtoint ptr %p56 to i64
  %null_chk58 = icmp eq i64 %cast57, 0
  %null_ext59 = zext i1 %null_chk58 to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 1, ptr @sty_name.12, i64 4, i64 %null_ext59, ptr @src_file.13, i64 112, i64 33)
  %b_ptr = getelementptr inbounds nuw %Pair, ptr %p56, i32 0, i32 1
  %b = load i64, ptr %b_ptr, align 8
  %34 = call ptr @avra_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.14, i64 %b)
  %widen60 = sext i32 %35 to i64
  %36 = call i32 @puts(ptr %34)
  %widen61 = sext i32 %36 to i64
  %37 = call i32 @avra_test_summary()
  %widen62 = sext i32 %37 to i64
  call void @avra_rc_collect()
  ret i64 0

ife_then45:                                       ; preds = %nc_end30
  %38 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Pair, ptr %38, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr47 = getelementptr inbounds nuw %Pair, ptr %38, i32 0, i32 1
  store i64 2, ptr %fld_ptr47, align 8
  %cast48 = ptrtoint ptr %38 to i64
  store i64 %cast48, ptr %ife_result42, align 8
  br label %ife_end43

ife_else46:                                       ; preds = %nc_end30
  %39 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr49 = getelementptr inbounds nuw %Pair, ptr %39, i32 0, i32 0
  store i64 0, ptr %fld_ptr49, align 8
  %fld_ptr50 = getelementptr inbounds nuw %Pair, ptr %39, i32 0, i32 1
  store i64 0, ptr %fld_ptr50, align 8
  %cast51 = ptrtoint ptr %39 to i64
  store i64 %cast51, ptr %ife_result42, align 8
  br label %ife_end43
}
