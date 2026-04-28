; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%TransformList = type { i64, ptr }
%Transform = type { ptr, ptr }
%TransformList__Node = type { ptr, ptr }

@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [10 x i8] c"Transform\00", align 1
@src_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/feature_registry.av\00", align 1
@.str = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c") = \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [8 x i8] c"run_all\00", align 1
@mu_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/feature_registry.av\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"not found: \00", align 1
@fld_name.4 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.5 = private unnamed_addr constant [10 x i8] c"Transform\00", align 1
@src_file.6 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/feature_registry.av\00", align 1
@.match_fn.7 = private unnamed_addr constant [13 x i8] c"find_and_run\00", align 1
@mu_file.8 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/feature_registry.av\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c"double\00", align 1
@.str.10 = private unnamed_addr constant [7 x i8] c"triple\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c"negate\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.str.13 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [7 x i8] c"negate\00", align 1
@.i2s_fmt.16 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @triple(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, 3
  ret i64 %mul
}

define i64 @negate(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sub = sub i64 0, %n1
  ret i64 %sub
}

define i64 @square(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %n2 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, %n2
  ret i64 %mul
}

define i64 @run_all(ptr %0, i64 %1) {
entry:
  %result = alloca i64, align 8
  %rest8 = alloca ptr, align 8
  %t5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %input = alloca i64, align 8
  %transforms = alloca ptr, align 8
  store ptr %0, ptr %transforms, align 8
  store i64 %1, ptr %input, align 8
  %transforms1 = load ptr, ptr %transforms, align 8
  %tag_ptr = getelementptr inbounds nuw %TransformList, ptr %transforms1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %2 = call ptr @avra_map_new_cstr()
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %TransformList, ptr %transforms1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %t_slot_base = ptrtoint ptr %payload to i64
  %t_slot_addr = add i64 %t_slot_base, 0
  %t_slot = inttoptr i64 %t_slot_addr to ptr
  %t = load ptr, ptr %t_slot, align 8
  call void @avra_rc_retain(ptr %t)
  store ptr %t, ptr %t5, align 8
  %pay_slot6 = getelementptr inbounds nuw %TransformList, ptr %transforms1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %rest_slot_base = ptrtoint ptr %payload7 to i64
  %rest_slot_addr = add i64 %rest_slot_base, 8
  %rest_slot = inttoptr i64 %rest_slot_addr to ptr
  %rest = load ptr, ptr %rest_slot, align 8
  call void @avra_rc_retain(ptr %rest)
  store ptr %rest, ptr %rest8, align 8
  %t9 = load ptr, ptr %t5, align 8
  %fn_field_ptr = getelementptr inbounds nuw %Transform, ptr %t9, i32 0, i32 1
  %fn_field_val = load i64, ptr %fn_field_ptr, align 8
  %input10 = load i64, ptr %input, align 8
  %3 = call i64 @avra_closure_call_1(i64 %fn_field_val, i64 %input10)
  store i64 %3, ptr %result, align 8
  %t11 = load ptr, ptr %t5, align 8
  %cast12 = ptrtoint ptr %t11 to i64
  %null_chk = icmp eq i64 %cast12, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 9, i64 %null_ext, ptr @src_file, i64 102, i64 25)
  %name_ptr = getelementptr inbounds nuw %Transform, ptr %t11, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %4 = call i64 @strlen(ptr %name)
  %5 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr %name, i64 %4)
  %cast13 = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast13, %4
  %cast14 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast14, ptr @.str, i64 %rhs_len_p1)
  %input15 = load i64, ptr %input, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt, i64 %input15)
  %widen = sext i32 %10 to i64
  %11 = call i64 @strlen(ptr %6)
  %12 = call i64 @strlen(ptr %9)
  %concat_total16 = add i64 %11, %12
  %concat_size17 = add i64 %concat_total16, 1
  %13 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %14 = call ptr @memcpy(ptr %13, ptr %6, i64 %11)
  %cast18 = ptrtoint ptr %13 to i64
  %dst2_int19 = add i64 %cast18, %11
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %12, 1
  %15 = call ptr @memcpy(ptr %cast20, ptr %9, i64 %rhs_len_p121)
  %16 = call i64 @strlen(ptr %13)
  %17 = call i64 @strlen(ptr @.str.1)
  %concat_total22 = add i64 %16, %17
  %concat_size23 = add i64 %concat_total22, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size23)
  %19 = call ptr @memcpy(ptr %18, ptr %13, i64 %16)
  %cast24 = ptrtoint ptr %18 to i64
  %dst2_int25 = add i64 %cast24, %16
  %cast26 = inttoptr i64 %dst2_int25 to ptr
  %rhs_len_p127 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast26, ptr @.str.1, i64 %rhs_len_p127)
  %result28 = load i64, ptr %result, align 8
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.2, i64 %result28)
  %widen29 = sext i32 %22 to i64
  %23 = call i64 @strlen(ptr %18)
  %24 = call i64 @strlen(ptr %21)
  %concat_total30 = add i64 %23, %24
  %concat_size31 = add i64 %concat_total30, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size31)
  %26 = call ptr @memcpy(ptr %25, ptr %18, i64 %23)
  %cast32 = ptrtoint ptr %25 to i64
  %dst2_int33 = add i64 %cast32, %23
  %cast34 = inttoptr i64 %dst2_int33 to ptr
  %rhs_len_p135 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast34, ptr %21, i64 %rhs_len_p135)
  %28 = call i32 @puts(ptr %25)
  %widen36 = sext i32 %28 to i64
  %rest37 = load ptr, ptr %rest8, align 8
  %input38 = load i64, ptr %input, align 8
  %29 = call i64 @run_all(ptr %rest37, i64 %input38)
  store i64 %29, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 20)
  unreachable
}

define i64 @find_and_run(ptr %0, ptr %1, i64 %2) {
entry:
  %rest10 = alloca ptr, align 8
  %t7 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %input = alloca i64, align 8
  %name = alloca ptr, align 8
  %transforms = alloca ptr, align 8
  store ptr %0, ptr %transforms, align 8
  store ptr %1, ptr %name, align 8
  store i64 %2, ptr %input, align 8
  %transforms1 = load ptr, ptr %transforms, align 8
  %tag_ptr = getelementptr inbounds nuw %TransformList, ptr %transforms1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %ifcont, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %name2 = load ptr, ptr %name, align 8
  %3 = call i64 @strlen(ptr @.str.3)
  %4 = call i64 @strlen(ptr %name2)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.3, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast3, ptr %name2, i64 %rhs_len_p1)
  %8 = call i32 @puts(ptr %5)
  %widen = sext i32 %8 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %TransformList, ptr %transforms1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %t_slot_base = ptrtoint ptr %payload to i64
  %t_slot_addr = add i64 %t_slot_base, 0
  %t_slot = inttoptr i64 %t_slot_addr to ptr
  %t = load ptr, ptr %t_slot, align 8
  call void @avra_rc_retain(ptr %t)
  store ptr %t, ptr %t7, align 8
  %pay_slot8 = getelementptr inbounds nuw %TransformList, ptr %transforms1, i32 0, i32 1
  %payload9 = load ptr, ptr %pay_slot8, align 8
  %rest_slot_base = ptrtoint ptr %payload9 to i64
  %rest_slot_addr = add i64 %rest_slot_base, 8
  %rest_slot = inttoptr i64 %rest_slot_addr to ptr
  %rest = load ptr, ptr %rest_slot, align 8
  call void @avra_rc_retain(ptr %rest)
  store ptr %rest, ptr %rest10, align 8
  %t11 = load ptr, ptr %t7, align 8
  %cast12 = ptrtoint ptr %t11 to i64
  %null_chk = icmp eq i64 %cast12, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 4, ptr @sty_name.5, i64 9, i64 %null_ext, ptr @src_file.6, i64 102, i64 40)
  %name_ptr = getelementptr inbounds nuw %Transform, ptr %t11, i32 0, i32 0
  %name13 = load ptr, ptr %name_ptr, align 8
  %name14 = load ptr, ptr %name, align 8
  %9 = call i32 @strcmp(ptr %name13, ptr %name14)
  %widen15 = sext i32 %9 to i64
  %streq_cmp = icmp eq i64 %widen15, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.7, i64 %tag, ptr @mu_file.8, i64 32)
  unreachable

ifcont:                                           ; preds = %if_else
  %rest18 = load ptr, ptr %rest10, align 8
  %name19 = load ptr, ptr %name, align 8
  %input20 = load i64, ptr %input, align 8
  %10 = call i64 @find_and_run(ptr %rest18, ptr %name19, i64 %input20)
  store i64 %10, ptr %match_result, align 8
  br label %match_end

if_then:                                          ; preds = %march_arm4
  %t16 = load ptr, ptr %t7, align 8
  %fn_field_ptr = getelementptr inbounds nuw %Transform, ptr %t16, i32 0, i32 1
  %fn_field_val = load i64, ptr %fn_field_ptr, align 8
  %input17 = load i64, ptr %input, align 8
  %11 = call i64 @avra_closure_call_1(i64 %fn_field_val, i64 %input17)
  ret i64 %11

if_else:                                          ; preds = %march_arm4
  br label %ifcont
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %registry = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %TransformList, ptr %1, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %TransformList, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 16)
  store ptr %2, ptr %pay_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Transform, ptr %3, i32 0, i32 0
  store ptr @.str.9, ptr %fld_ptr, align 8
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 -559038737)
  call void @avra_array_push(ptr %4, i64 ptrtoint (ptr @double to i64))
  %cast = ptrtoint ptr %4 to i64
  %fld_ptr1 = getelementptr inbounds nuw %Transform, ptr %3, i32 0, i32 1
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %fld_ptr1, align 8
  %cast3 = ptrtoint ptr %3 to i64
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast4 = inttoptr i64 %cast3 to ptr
  store ptr %cast4, ptr %slot, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr5 = getelementptr inbounds nuw %TransformList, ptr %5, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr5, align 8
  %pay_ptr6 = getelementptr inbounds nuw %TransformList, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 16)
  store ptr %6, ptr %pay_ptr6, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr7 = getelementptr inbounds nuw %Transform, ptr %7, i32 0, i32 0
  store ptr @.str.10, ptr %fld_ptr7, align 8
  %8 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %8, i64 -559038737)
  call void @avra_array_push(ptr %8, i64 ptrtoint (ptr @triple to i64))
  %cast8 = ptrtoint ptr %8 to i64
  %fld_ptr9 = getelementptr inbounds nuw %Transform, ptr %7, i32 0, i32 1
  %cast10 = inttoptr i64 %cast8 to ptr
  store ptr %cast10, ptr %fld_ptr9, align 8
  %cast11 = ptrtoint ptr %7 to i64
  %slot_base12 = ptrtoint ptr %6 to i64
  %slot_addr13 = add i64 %slot_base12, 0
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  %cast15 = inttoptr i64 %cast11 to ptr
  store ptr %cast15, ptr %slot14, align 8
  %9 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr16 = getelementptr inbounds nuw %TransformList, ptr %9, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr16, align 8
  %pay_ptr17 = getelementptr inbounds nuw %TransformList, ptr %9, i32 0, i32 1
  %10 = call ptr @avra_rc_alloc(i64 16)
  store ptr %10, ptr %pay_ptr17, align 8
  %11 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr18 = getelementptr inbounds nuw %Transform, ptr %11, i32 0, i32 0
  store ptr @.str.11, ptr %fld_ptr18, align 8
  %12 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %12, i64 -559038737)
  call void @avra_array_push(ptr %12, i64 ptrtoint (ptr @negate to i64))
  %cast19 = ptrtoint ptr %12 to i64
  %fld_ptr20 = getelementptr inbounds nuw %Transform, ptr %11, i32 0, i32 1
  %cast21 = inttoptr i64 %cast19 to ptr
  store ptr %cast21, ptr %fld_ptr20, align 8
  %cast22 = ptrtoint ptr %11 to i64
  %slot_base23 = ptrtoint ptr %10 to i64
  %slot_addr24 = add i64 %slot_base23, 0
  %slot25 = inttoptr i64 %slot_addr24 to ptr
  %cast26 = inttoptr i64 %cast22 to ptr
  store ptr %cast26, ptr %slot25, align 8
  %13 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr27 = getelementptr inbounds nuw %TransformList, ptr %13, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr27, align 8
  %pay_ptr28 = getelementptr inbounds nuw %TransformList, ptr %13, i32 0, i32 1
  %14 = call ptr @avra_rc_alloc(i64 16)
  store ptr %14, ptr %pay_ptr28, align 8
  %15 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr29 = getelementptr inbounds nuw %Transform, ptr %15, i32 0, i32 0
  store ptr @.str.12, ptr %fld_ptr29, align 8
  %16 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %16, i64 -559038737)
  call void @avra_array_push(ptr %16, i64 ptrtoint (ptr @square to i64))
  %cast30 = ptrtoint ptr %16 to i64
  %fld_ptr31 = getelementptr inbounds nuw %Transform, ptr %15, i32 0, i32 1
  %cast32 = inttoptr i64 %cast30 to ptr
  store ptr %cast32, ptr %fld_ptr31, align 8
  %cast33 = ptrtoint ptr %15 to i64
  %slot_base34 = ptrtoint ptr %14 to i64
  %slot_addr35 = add i64 %slot_base34, 0
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  %cast37 = inttoptr i64 %cast33 to ptr
  store ptr %cast37, ptr %slot36, align 8
  %17 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %TransformList, ptr %17, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %TransformList, ptr %17, i32 0, i32 1
  store ptr null, ptr %pay_ptr39, align 8
  %cast40 = ptrtoint ptr %17 to i64
  %slot_base41 = ptrtoint ptr %14 to i64
  %slot_addr42 = add i64 %slot_base41, 8
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  %cast44 = inttoptr i64 %cast40 to ptr
  store ptr %cast44, ptr %slot43, align 8
  %cast45 = ptrtoint ptr %13 to i64
  %slot_base46 = ptrtoint ptr %10 to i64
  %slot_addr47 = add i64 %slot_base46, 8
  %slot48 = inttoptr i64 %slot_addr47 to ptr
  %cast49 = inttoptr i64 %cast45 to ptr
  store ptr %cast49, ptr %slot48, align 8
  %cast50 = ptrtoint ptr %9 to i64
  %slot_base51 = ptrtoint ptr %6 to i64
  %slot_addr52 = add i64 %slot_base51, 8
  %slot53 = inttoptr i64 %slot_addr52 to ptr
  %cast54 = inttoptr i64 %cast50 to ptr
  store ptr %cast54, ptr %slot53, align 8
  %cast55 = ptrtoint ptr %5 to i64
  %slot_base56 = ptrtoint ptr %2 to i64
  %slot_addr57 = add i64 %slot_base56, 8
  %slot58 = inttoptr i64 %slot_addr57 to ptr
  %cast59 = inttoptr i64 %cast55 to ptr
  store ptr %cast59, ptr %slot58, align 8
  %cast60 = ptrtoint ptr %1 to i64
  %cast61 = inttoptr i64 %cast60 to ptr
  store ptr %cast61, ptr %registry, align 8
  %registry62 = load ptr, ptr %registry, align 8
  %18 = call i64 @run_all(ptr %registry62, i64 5)
  %registry63 = load ptr, ptr %registry, align 8
  %19 = call i64 @find_and_run(ptr %registry63, ptr @.str.13, i64 7)
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.14, i64 %19)
  %widen = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen64 = sext i32 %22 to i64
  %registry65 = load ptr, ptr %registry, align 8
  %23 = call i64 @find_and_run(ptr %registry65, ptr @.str.15, i64 3)
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.16, i64 %23)
  %widen66 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen67 = sext i32 %26 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Transform(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Transform, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_apply_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_apply_ptr = getelementptr inbounds nuw %Transform, ptr %0, i32 0, i32 1
  %rel_apply = load ptr, ptr %rel_apply_ptr, align 8
  %is_null_apply = icmp eq ptr %rel_apply, null
  br i1 %is_null_apply, label %rel_apply_skip, label %rel_apply_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_apply_skip:                                   ; preds = %rel_apply_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_apply_do:                                     ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_apply)
  br label %rel_apply_skip
}

define i64 @__release_TransformList(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %TransformList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %TransformList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_t_ptr = getelementptr inbounds nuw %TransformList__Node, ptr %payload, i32 0, i32 0
  %vrel_t = load ptr, ptr %vrel_t_ptr, align 8
  %vrel_null_t = icmp eq ptr %vrel_t, null
  br i1 %vrel_null_t, label %vrel_t_skip, label %vrel_t_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_t_skip:                                      ; preds = %vrel_t_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %TransformList__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_t_do:                                        ; preds = %rel_Node
  %2 = call i64 @__release_Transform(ptr %vrel_t)
  br label %vrel_t_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_t_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_t_skip
  %3 = call i64 @__release_TransformList(ptr %vrel_next)
  br label %vrel_next_skip
}
