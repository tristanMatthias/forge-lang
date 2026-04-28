; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Color = type { i64, ptr }
%Box = type { ptr }

@.str = private unnamed_addr constant [11 x i8] c"direct: ok\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"direct: FAIL\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"direct neq: FAIL\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"direct neq: ok\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"color\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_compare.av\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"field: ok\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"field: FAIL\00", align 1
@fld_name.6 = private unnamed_addr constant [6 x i8] c"color\00", align 1
@sty_name.7 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.8 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_compare.av\00", align 1
@.str.9 = private unnamed_addr constant [16 x i8] c"field neq: FAIL\00", align 1
@.str.10 = private unnamed_addr constant [14 x i8] c"field neq: ok\00", align 1
@fld_name.11 = private unnamed_addr constant [6 x i8] c"color\00", align 1
@sty_name.12 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.13 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_compare.av\00", align 1
@.str.14 = private unnamed_addr constant [7 x i8] c"fn: ok\00", align 1
@.str.15 = private unnamed_addr constant [9 x i8] c"fn: FAIL\00", align 1
@.str.16 = private unnamed_addr constant [14 x i8] c"fn direct: ok\00", align 1
@.str.17 = private unnamed_addr constant [16 x i8] c"fn direct: FAIL\00", align 1

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

define i1 @check(ptr %0, ptr %1) {
entry:
  %expected = alloca ptr, align 8
  %c = alloca ptr, align 8
  store ptr %0, ptr %c, align 8
  store ptr %1, ptr %expected, align 8
  %c1 = load ptr, ptr %c, align 8
  %expected2 = load ptr, ptr %expected, align 8
  %ltag_ptr = getelementptr inbounds nuw %Color, ptr %c1, i32 0, i32 0
  %rtag_ptr = getelementptr inbounds nuw %Color, ptr %expected2, i32 0, i32 0
  %ltag = load i64, ptr %ltag_ptr, align 8
  %rtag = load i64, ptr %rtag_ptr, align 8
  %tag_cmp = icmp eq i64 %ltag, %rtag
  %tag_cmp_ext = zext i1 %tag_cmp to i64
  %cast = trunc i64 %tag_cmp_ext to i1
  ret i1 %cast
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %sif_result = alloca i64, align 8
  %b = alloca ptr, align 8
  %b_copy = alloca %Box, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %fld_ptr = getelementptr inbounds nuw %Box, ptr %b_copy, i32 0, i32 0
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %fld_ptr, align 8
  %cast2 = ptrtoint ptr %b_copy to i64
  %cast3 = inttoptr i64 %cast2 to ptr
  store ptr %cast3, ptr %b, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %Color, ptr %2, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr4, align 8
  %pay_ptr5 = getelementptr inbounds nuw %Color, ptr %2, i32 0, i32 1
  store ptr null, ptr %pay_ptr5, align 8
  %cast6 = ptrtoint ptr %2 to i64
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr7 = getelementptr inbounds nuw %Color, ptr %3, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr7, align 8
  %pay_ptr8 = getelementptr inbounds nuw %Color, ptr %3, i32 0, i32 1
  store ptr null, ptr %pay_ptr8, align 8
  %cast9 = ptrtoint ptr %3 to i64
  %cast10 = inttoptr i64 %cast6 to ptr
  %cast11 = inttoptr i64 %cast9 to ptr
  %ltag_ptr = getelementptr inbounds nuw %Color, ptr %cast10, i32 0, i32 0
  %rtag_ptr = getelementptr inbounds nuw %Color, ptr %cast11, i32 0, i32 0
  %ltag = load i64, ptr %ltag_ptr, align 8
  %rtag = load i64, ptr %rtag_ptr, align 8
  %tag_cmp = icmp eq i64 %ltag, %rtag
  %tag_cmp_ext = zext i1 %tag_cmp to i64
  %if_cond = icmp ne i64 %tag_cmp_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr13 = getelementptr inbounds nuw %Color, ptr %4, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr13, align 8
  %pay_ptr14 = getelementptr inbounds nuw %Color, ptr %4, i32 0, i32 1
  store ptr null, ptr %pay_ptr14, align 8
  %cast15 = ptrtoint ptr %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr16 = getelementptr inbounds nuw %Color, ptr %5, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr16, align 8
  %pay_ptr17 = getelementptr inbounds nuw %Color, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr17, align 8
  %cast18 = ptrtoint ptr %5 to i64
  %cast19 = inttoptr i64 %cast15 to ptr
  %cast20 = inttoptr i64 %cast18 to ptr
  %ltag_ptr21 = getelementptr inbounds nuw %Color, ptr %cast19, i32 0, i32 0
  %rtag_ptr22 = getelementptr inbounds nuw %Color, ptr %cast20, i32 0, i32 0
  %ltag23 = load i64, ptr %ltag_ptr21, align 8
  %rtag24 = load i64, ptr %rtag_ptr22, align 8
  %tag_cmp25 = icmp eq i64 %ltag23, %rtag24
  %tag_cmp_ext26 = zext i1 %tag_cmp25 to i64
  %if_cond28 = icmp ne i64 %tag_cmp_ext26, 0
  br i1 %if_cond28, label %if_then29, label %if_else30

if_then:                                          ; preds = %entry
  %6 = call i32 @puts(ptr @.str)
  %widen = sext i32 %6 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  %7 = call i32 @puts(ptr @.str.1)
  %widen12 = sext i32 %7 to i64
  br label %ifcont

ifcont27:                                         ; preds = %if_else30, %if_then29
  %b33 = load ptr, ptr %b, align 8
  %cast34 = ptrtoint ptr %b33 to i64
  %null_chk = icmp eq i64 %cast34, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 98, i64 19)
  %color_ptr = getelementptr inbounds nuw %Box, ptr %b33, i32 0, i32 0
  %color = load ptr, ptr %color_ptr, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr35 = getelementptr inbounds nuw %Color, ptr %8, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr35, align 8
  %pay_ptr36 = getelementptr inbounds nuw %Color, ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr36, align 8
  %cast37 = ptrtoint ptr %8 to i64
  %rhs_ptr = inttoptr i64 %cast37 to ptr
  %ltag_ptr38 = getelementptr inbounds nuw %Color, ptr %color, i32 0, i32 0
  %rtag_ptr39 = getelementptr inbounds nuw %Color, ptr %rhs_ptr, i32 0, i32 0
  %ltag40 = load i64, ptr %ltag_ptr38, align 8
  %rtag41 = load i64, ptr %rtag_ptr39, align 8
  %tag_cmp42 = icmp eq i64 %ltag40, %rtag41
  %tag_cmp_ext43 = zext i1 %tag_cmp42 to i64
  %if_cond45 = icmp ne i64 %tag_cmp_ext43, 0
  br i1 %if_cond45, label %if_then46, label %if_else47

if_then29:                                        ; preds = %ifcont
  %9 = call i32 @puts(ptr @.str.2)
  %widen31 = sext i32 %9 to i64
  br label %ifcont27

if_else30:                                        ; preds = %ifcont
  %10 = call i32 @puts(ptr @.str.3)
  %widen32 = sext i32 %10 to i64
  br label %ifcont27

ifcont44:                                         ; preds = %if_else47, %if_then46
  %b50 = load ptr, ptr %b, align 8
  %cast51 = ptrtoint ptr %b50 to i64
  %null_chk52 = icmp eq i64 %cast51, 0
  %null_ext53 = zext i1 %null_chk52 to i64
  call void @avra_null_deref_trap(ptr @fld_name.6, i64 5, ptr @sty_name.7, i64 3, i64 %null_ext53, ptr @src_file.8, i64 98, i64 20)
  %color_ptr54 = getelementptr inbounds nuw %Box, ptr %b50, i32 0, i32 0
  %color55 = load ptr, ptr %color_ptr54, align 8
  %11 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr56 = getelementptr inbounds nuw %Color, ptr %11, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr56, align 8
  %pay_ptr57 = getelementptr inbounds nuw %Color, ptr %11, i32 0, i32 1
  store ptr null, ptr %pay_ptr57, align 8
  %cast58 = ptrtoint ptr %11 to i64
  %rhs_ptr59 = inttoptr i64 %cast58 to ptr
  %ltag_ptr60 = getelementptr inbounds nuw %Color, ptr %color55, i32 0, i32 0
  %rtag_ptr61 = getelementptr inbounds nuw %Color, ptr %rhs_ptr59, i32 0, i32 0
  %ltag62 = load i64, ptr %ltag_ptr60, align 8
  %rtag63 = load i64, ptr %rtag_ptr61, align 8
  %tag_cmp64 = icmp eq i64 %ltag62, %rtag63
  %tag_cmp_ext65 = zext i1 %tag_cmp64 to i64
  %if_cond67 = icmp ne i64 %tag_cmp_ext65, 0
  br i1 %if_cond67, label %if_then68, label %if_else69

if_then46:                                        ; preds = %ifcont27
  %12 = call i32 @puts(ptr @.str.4)
  %widen48 = sext i32 %12 to i64
  br label %ifcont44

if_else47:                                        ; preds = %ifcont27
  %13 = call i32 @puts(ptr @.str.5)
  %widen49 = sext i32 %13 to i64
  br label %ifcont44

ifcont66:                                         ; preds = %if_else69, %if_then68
  %b72 = load ptr, ptr %b, align 8
  %cast73 = ptrtoint ptr %b72 to i64
  %null_chk74 = icmp eq i64 %cast73, 0
  %null_ext75 = zext i1 %null_chk74 to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 5, ptr @sty_name.12, i64 3, i64 %null_ext75, ptr @src_file.13, i64 98, i64 23)
  %color_ptr76 = getelementptr inbounds nuw %Box, ptr %b72, i32 0, i32 0
  %color77 = load ptr, ptr %color_ptr76, align 8
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr78 = getelementptr inbounds nuw %Color, ptr %14, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr78, align 8
  %pay_ptr79 = getelementptr inbounds nuw %Color, ptr %14, i32 0, i32 1
  store ptr null, ptr %pay_ptr79, align 8
  %cast80 = ptrtoint ptr %14 to i64
  %cast81 = inttoptr i64 %cast80 to ptr
  %15 = call i1 @check(ptr %color77, ptr %cast81)
  %widen82 = zext i1 %15 to i64
  %if_cond84 = icmp ne i64 %widen82, 0
  br i1 %if_cond84, label %if_then85, label %if_else86

if_then68:                                        ; preds = %ifcont44
  %16 = call i32 @puts(ptr @.str.9)
  %widen70 = sext i32 %16 to i64
  br label %ifcont66

if_else69:                                        ; preds = %ifcont44
  %17 = call i32 @puts(ptr @.str.10)
  %widen71 = sext i32 %17 to i64
  br label %ifcont66

ifcont83:                                         ; preds = %if_else86, %if_then85
  %18 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr89 = getelementptr inbounds nuw %Color, ptr %18, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr89, align 8
  %pay_ptr90 = getelementptr inbounds nuw %Color, ptr %18, i32 0, i32 1
  store ptr null, ptr %pay_ptr90, align 8
  %cast91 = ptrtoint ptr %18 to i64
  %19 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr92 = getelementptr inbounds nuw %Color, ptr %19, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr92, align 8
  %pay_ptr93 = getelementptr inbounds nuw %Color, ptr %19, i32 0, i32 1
  store ptr null, ptr %pay_ptr93, align 8
  %cast94 = ptrtoint ptr %19 to i64
  %cast95 = inttoptr i64 %cast91 to ptr
  %cast96 = inttoptr i64 %cast94 to ptr
  %20 = call i1 @check(ptr %cast95, ptr %cast96)
  %widen97 = zext i1 %20 to i64
  %sif_cond = icmp ne i64 %widen97, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

if_then85:                                        ; preds = %ifcont66
  %21 = call i32 @puts(ptr @.str.14)
  %widen87 = sext i32 %21 to i64
  br label %ifcont83

if_else86:                                        ; preds = %ifcont66
  %22 = call i32 @puts(ptr @.str.15)
  %widen88 = sext i32 %22 to i64
  br label %ifcont83

sif_then:                                         ; preds = %ifcont83
  %23 = call i32 @puts(ptr @.str.16)
  %widen98 = sext i32 %23 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %ifcont83
  %24 = call i32 @puts(ptr @.str.17)
  %widen99 = sext i32 %24 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Box(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_color_ptr = getelementptr inbounds nuw %Box, ptr %0, i32 0, i32 0
  %rel_color = load ptr, ptr %rel_color_ptr, align 8
  %is_null_color = icmp eq ptr %rel_color, null
  br i1 %is_null_color, label %rel_color_skip, label %rel_color_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_color_skip
  ret i64 0

rel_color_skip:                                   ; preds = %rel_color_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_color_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_color)
  br label %rel_color_skip
}
