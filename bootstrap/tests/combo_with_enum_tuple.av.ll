; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result = type { i64, ptr }
%Point = type { i64, i64, i64 }
%Config = type { i64, i64, ptr }
%Result__Err = type { i64, ptr }

@p1 = global i64 0
@p2 = global i64 0
@p3 = global i64 0
@pair = global i64 0
@base = global i64 0
@custom = global i64 0
@.str = private unnamed_addr constant [10 x i8] c"success: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"error \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.match_fn = private unnamed_addr constant [16 x i8] c"describe_result\00", align 1
@mu_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
@.str.4 = private unnamed_addr constant [17 x i8] c"division by zero\00", align 1
@dz_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
@.match_fn.5 = private unnamed_addr constant [7 x i8] c"divide\00", align 1
@mu_file.6 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c",\00", align 1
@fld_name.9 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.10 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.11 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c",\00", align 1
@fld_name.14 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@sty_name.15 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.16 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.20 = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@.str.21 = private unnamed_addr constant [8 x i8] c"default\00", align 1
@.str.22 = private unnamed_addr constant [7 x i8] c"my app\00", align 1
@fld_name.23 = private unnamed_addr constant [6 x i8] c"title\00", align 1
@sty_name.24 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.25 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
@.str.26 = private unnamed_addr constant [3 x i8] c": \00", align 1
@fld_name.27 = private unnamed_addr constant [6 x i8] c"width\00", align 1
@sty_name.28 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.29 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
@.i2s_fmt.30 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.31 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@fld_name.32 = private unnamed_addr constant [7 x i8] c"height\00", align 1
@sty_name.33 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.34 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_with_enum_tuple.av\00", align 1
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

define ptr @describe_result(ptr %0) {
entry:
  %m14 = alloca ptr, align 8
  %c11 = alloca i64, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast37 = inttoptr i64 %match_val to ptr
  ret ptr %cast37

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %v3 = load i64, ptr %v2, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %v3)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast4, ptr %1, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %5 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %c_slot_base = ptrtoint ptr %payload10 to i64
  %c_slot_addr = add i64 %c_slot_base, 0
  %c_slot = inttoptr i64 %c_slot_addr to ptr
  %c = load i64, ptr %c_slot, align 8
  store i64 %c, ptr %c11, align 8
  %pay_slot12 = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload13 = load ptr, ptr %pay_slot12, align 8
  %m_slot_base = ptrtoint ptr %payload13 to i64
  %m_slot_addr = add i64 %m_slot_base, 8
  %m_slot = inttoptr i64 %m_slot_addr to ptr
  %m = load ptr, ptr %m_slot, align 8
  call void @avra_rc_retain(ptr %m)
  store ptr %m, ptr %m14, align 8
  %c15 = load i64, ptr %c11, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.2, i64 %c15)
  %widen16 = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str.1)
  %11 = call i64 @strlen(ptr %8)
  %concat_total17 = add i64 %10, %11
  %concat_size18 = add i64 %concat_total17, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size18)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.1, i64 %10)
  %cast19 = ptrtoint ptr %12 to i64
  %dst2_int20 = add i64 %cast19, %10
  %cast21 = inttoptr i64 %dst2_int20 to ptr
  %rhs_len_p122 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast21, ptr %8, i64 %rhs_len_p122)
  %15 = call i64 @strlen(ptr %12)
  %16 = call i64 @strlen(ptr @.str.3)
  %concat_total23 = add i64 %15, %16
  %concat_size24 = add i64 %concat_total23, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size24)
  %18 = call ptr @memcpy(ptr %17, ptr %12, i64 %15)
  %cast25 = ptrtoint ptr %17 to i64
  %dst2_int26 = add i64 %cast25, %15
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast27, ptr @.str.3, i64 %rhs_len_p128)
  %m29 = load ptr, ptr %m14, align 8
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr %m29)
  %concat_total30 = add i64 %20, %21
  %concat_size31 = add i64 %concat_total30, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size31)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast32 = ptrtoint ptr %22 to i64
  %dst2_int33 = add i64 %cast32, %20
  %cast34 = inttoptr i64 %dst2_int33 to ptr
  %rhs_len_p135 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast34, ptr %m29, i64 %rhs_len_p135)
  %cast36 = ptrtoint ptr %22 to i64
  store i64 %cast36, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 23)
  unreachable
}

define ptr @divide(i64 %0, i64 %1) {
entry:
  %pmatch_result = alloca i64, align 8
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %b1 = load i64, ptr %b, align 8
  store i64 0, ptr %pmatch_result, align 8
  %lit_eq = icmp eq i64 %b1, 0
  br i1 %lit_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body5, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast15 = inttoptr i64 %pmatch_val to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast15, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

parm_body:                                        ; preds = %entry
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 1, ptr %slot, align 8
  %slot_base2 = ptrtoint ptr %3 to i64
  %slot_addr3 = add i64 %slot_base2, 8
  %slot4 = inttoptr i64 %slot_addr3 to ptr
  store ptr @.str.4, ptr %slot4, align 8
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  br label %parm_body5

parm_body5:                                       ; preds = %parm_next
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr7 = getelementptr inbounds nuw %Result, ptr %4, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr7, align 8
  %pay_ptr8 = getelementptr inbounds nuw %Result, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr8, align 8
  %a9 = load i64, ptr %a, align 8
  %b10 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b10, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 107, i64 33)
  %div = sdiv i64 %a9, %b10
  %slot_base11 = ptrtoint ptr %5 to i64
  %slot_addr12 = add i64 %slot_base11, 0
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store i64 %div, ptr %slot13, align 8
  %cast14 = ptrtoint ptr %4 to i64
  store i64 %cast14, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next6:                                       ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 -1, ptr @mu_file.6, i64 33)
  unreachable

errdefer_path:                                    ; preds = %pmatch_end
  br label %defer_done

defer_path:                                       ; preds = %pmatch_end
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast16 = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast16
}

define i64 @main() {
entry:
  %text59 = alloca i64, align 8
  %num58 = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %0, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Point, ptr %0, i32 0, i32 1
  store i64 2, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Point, ptr %0, i32 0, i32 2
  store i64 3, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @p1, align 8
  %p1 = load ptr, ptr @p1, align 8
  %1 = call ptr @avra_rc_alloc(i64 24)
  %with_cp_src = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Point, ptr %1, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src3 = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 1
  %with_cp_val4 = load i64, ptr %with_cp_src3, align 8
  %with_cp_dst5 = getelementptr inbounds nuw %Point, ptr %1, i32 0, i32 1
  store i64 %with_cp_val4, ptr %with_cp_dst5, align 8
  %with_cp_src6 = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 2
  %with_cp_val7 = load i64, ptr %with_cp_src6, align 8
  %with_cp_dst8 = getelementptr inbounds nuw %Point, ptr %1, i32 0, i32 2
  store i64 %with_cp_val7, ptr %with_cp_dst8, align 8
  %with_ovr = getelementptr inbounds nuw %Point, ptr %1, i32 0, i32 0
  store i64 10, ptr %with_ovr, align 8
  %cast9 = ptrtoint ptr %1 to i64
  store i64 %cast9, ptr @p2, align 8
  %p2 = load ptr, ptr @p2, align 8
  %2 = call ptr @avra_rc_alloc(i64 24)
  %with_cp_src10 = getelementptr inbounds nuw %Point, ptr %p2, i32 0, i32 0
  %with_cp_val11 = load i64, ptr %with_cp_src10, align 8
  %with_cp_dst12 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 0
  store i64 %with_cp_val11, ptr %with_cp_dst12, align 8
  %with_cp_src13 = getelementptr inbounds nuw %Point, ptr %p2, i32 0, i32 1
  %with_cp_val14 = load i64, ptr %with_cp_src13, align 8
  %with_cp_dst15 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 1
  store i64 %with_cp_val14, ptr %with_cp_dst15, align 8
  %with_cp_src16 = getelementptr inbounds nuw %Point, ptr %p2, i32 0, i32 2
  %with_cp_val17 = load i64, ptr %with_cp_src16, align 8
  %with_cp_dst18 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 2
  store i64 %with_cp_val17, ptr %with_cp_dst18, align 8
  %with_ovr19 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 1
  store i64 20, ptr %with_ovr19, align 8
  %with_ovr20 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 2
  store i64 30, ptr %with_ovr20, align 8
  %cast21 = ptrtoint ptr %2 to i64
  store i64 %cast21, ptr @p3, align 8
  %p3 = load ptr, ptr @p3, align 8
  %cast22 = ptrtoint ptr %p3 to i64
  %null_chk = icmp eq i64 %cast22, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 107, i64 8)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p3, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.7, i64 %x)
  %widen = sext i32 %4 to i64
  %5 = call i64 @strlen(ptr %3)
  %6 = call i64 @strlen(ptr @.str.8)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr %3, i64 %5)
  %cast23 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast23, %5
  %cast24 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast24, ptr @.str.8, i64 %rhs_len_p1)
  %p325 = load ptr, ptr @p3, align 8
  %cast26 = ptrtoint ptr %p325 to i64
  %null_chk27 = icmp eq i64 %cast26, 0
  %null_ext28 = zext i1 %null_chk27 to i64
  call void @avra_null_deref_trap(ptr @fld_name.9, i64 1, ptr @sty_name.10, i64 5, i64 %null_ext28, ptr @src_file.11, i64 107, i64 8)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p325, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.12, i64 %y)
  %widen29 = sext i32 %11 to i64
  %12 = call i64 @strlen(ptr %7)
  %13 = call i64 @strlen(ptr %10)
  %concat_total30 = add i64 %12, %13
  %concat_size31 = add i64 %concat_total30, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size31)
  %15 = call ptr @memcpy(ptr %14, ptr %7, i64 %12)
  %cast32 = ptrtoint ptr %14 to i64
  %dst2_int33 = add i64 %cast32, %12
  %cast34 = inttoptr i64 %dst2_int33 to ptr
  %rhs_len_p135 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast34, ptr %10, i64 %rhs_len_p135)
  %17 = call i64 @strlen(ptr %14)
  %18 = call i64 @strlen(ptr @.str.13)
  %concat_total36 = add i64 %17, %18
  %concat_size37 = add i64 %concat_total36, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size37)
  %20 = call ptr @memcpy(ptr %19, ptr %14, i64 %17)
  %cast38 = ptrtoint ptr %19 to i64
  %dst2_int39 = add i64 %cast38, %17
  %cast40 = inttoptr i64 %dst2_int39 to ptr
  %rhs_len_p141 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast40, ptr @.str.13, i64 %rhs_len_p141)
  %p342 = load ptr, ptr @p3, align 8
  %cast43 = ptrtoint ptr %p342 to i64
  %null_chk44 = icmp eq i64 %cast43, 0
  %null_ext45 = zext i1 %null_chk44 to i64
  call void @avra_null_deref_trap(ptr @fld_name.14, i64 1, ptr @sty_name.15, i64 5, i64 %null_ext45, ptr @src_file.16, i64 107, i64 8)
  %z_ptr = getelementptr inbounds nuw %Point, ptr %p342, i32 0, i32 2
  %z = load i64, ptr %z_ptr, align 8
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.17, i64 %z)
  %widen46 = sext i32 %23 to i64
  %24 = call i64 @strlen(ptr %19)
  %25 = call i64 @strlen(ptr %22)
  %concat_total47 = add i64 %24, %25
  %concat_size48 = add i64 %concat_total47, 1
  %26 = call ptr @avra_rc_alloc(i64 %concat_size48)
  %27 = call ptr @memcpy(ptr %26, ptr %19, i64 %24)
  %cast49 = ptrtoint ptr %26 to i64
  %dst2_int50 = add i64 %cast49, %24
  %cast51 = inttoptr i64 %dst2_int50 to ptr
  %rhs_len_p152 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast51, ptr %22, i64 %rhs_len_p152)
  %29 = call i32 @puts(ptr %26)
  %widen53 = sext i32 %29 to i64
  %30 = call ptr @avra_rc_alloc(i64 16)
  %slot_base = ptrtoint ptr %30 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %slot_base54 = ptrtoint ptr %30 to i64
  %slot_addr55 = add i64 %slot_base54, 8
  %slot56 = inttoptr i64 %slot_addr55 to ptr
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %slot56, align 8
  %cast57 = ptrtoint ptr %30 to i64
  store i64 %cast57, ptr @pair, align 8
  %pair = load ptr, ptr @pair, align 8
  %num_slot_base = ptrtoint ptr %pair to i64
  %num_slot_addr = add i64 %num_slot_base, 0
  %num_slot = inttoptr i64 %num_slot_addr to ptr
  %num = load i64, ptr %num_slot, align 8
  store i64 %num, ptr %num58, align 8
  %text_slot_base = ptrtoint ptr %pair to i64
  %text_slot_addr = add i64 %text_slot_base, 8
  %text_slot = inttoptr i64 %text_slot_addr to ptr
  %text = load i64, ptr %text_slot, align 8
  store i64 %text, ptr %text59, align 8
  %num60 = load i64, ptr %num58, align 8
  %31 = call ptr @avra_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.19, i64 %num60)
  %widen61 = sext i32 %32 to i64
  %33 = call i32 @puts(ptr %31)
  %widen62 = sext i32 %33 to i64
  %text63 = load ptr, ptr %text59, align 8
  %34 = call i32 @puts(ptr %text63)
  %widen64 = sext i32 %34 to i64
  %35 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %35, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %35, i32 0, i32 1
  %36 = call ptr @avra_rc_alloc(i64 8)
  store ptr %36, ptr %pay_ptr, align 8
  %slot_base65 = ptrtoint ptr %36 to i64
  %slot_addr66 = add i64 %slot_base65, 0
  %slot67 = inttoptr i64 %slot_addr66 to ptr
  store i64 42, ptr %slot67, align 8
  %cast68 = ptrtoint ptr %35 to i64
  %cast69 = inttoptr i64 %cast68 to ptr
  %37 = call ptr @describe_result(ptr %cast69)
  %38 = call i32 @puts(ptr %37)
  %widen70 = sext i32 %38 to i64
  %39 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr71 = getelementptr inbounds nuw %Result, ptr %39, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr71, align 8
  %pay_ptr72 = getelementptr inbounds nuw %Result, ptr %39, i32 0, i32 1
  %40 = call ptr @avra_rc_alloc(i64 16)
  store ptr %40, ptr %pay_ptr72, align 8
  %slot_base73 = ptrtoint ptr %40 to i64
  %slot_addr74 = add i64 %slot_base73, 0
  %slot75 = inttoptr i64 %slot_addr74 to ptr
  store i64 404, ptr %slot75, align 8
  %slot_base76 = ptrtoint ptr %40 to i64
  %slot_addr77 = add i64 %slot_base76, 8
  %slot78 = inttoptr i64 %slot_addr77 to ptr
  store ptr @.str.20, ptr %slot78, align 8
  %cast79 = ptrtoint ptr %39 to i64
  %cast80 = inttoptr i64 %cast79 to ptr
  %41 = call ptr @describe_result(ptr %cast80)
  %42 = call i32 @puts(ptr %41)
  %widen81 = sext i32 %42 to i64
  %43 = call ptr @divide(i64 10, i64 3)
  %44 = call ptr @describe_result(ptr %43)
  %45 = call i32 @puts(ptr %44)
  %widen82 = sext i32 %45 to i64
  %46 = call ptr @divide(i64 10, i64 0)
  %47 = call ptr @describe_result(ptr %46)
  %48 = call i32 @puts(ptr %47)
  %widen83 = sext i32 %48 to i64
  %49 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr84 = getelementptr inbounds nuw %Config, ptr %49, i32 0, i32 0
  store i64 800, ptr %fld_ptr84, align 8
  %fld_ptr85 = getelementptr inbounds nuw %Config, ptr %49, i32 0, i32 1
  store i64 600, ptr %fld_ptr85, align 8
  %fld_ptr86 = getelementptr inbounds nuw %Config, ptr %49, i32 0, i32 2
  store ptr @.str.21, ptr %fld_ptr86, align 8
  %cast87 = ptrtoint ptr %49 to i64
  store i64 %cast87, ptr @base, align 8
  %base = load ptr, ptr @base, align 8
  %50 = call ptr @avra_rc_alloc(i64 24)
  %with_cp_src88 = getelementptr inbounds nuw %Config, ptr %base, i32 0, i32 0
  %with_cp_val89 = load i64, ptr %with_cp_src88, align 8
  %with_cp_dst90 = getelementptr inbounds nuw %Config, ptr %50, i32 0, i32 0
  store i64 %with_cp_val89, ptr %with_cp_dst90, align 8
  %with_cp_src91 = getelementptr inbounds nuw %Config, ptr %base, i32 0, i32 1
  %with_cp_val92 = load i64, ptr %with_cp_src91, align 8
  %with_cp_dst93 = getelementptr inbounds nuw %Config, ptr %50, i32 0, i32 1
  store i64 %with_cp_val92, ptr %with_cp_dst93, align 8
  %with_cp_src94 = getelementptr inbounds nuw %Config, ptr %base, i32 0, i32 2
  %with_cp_val95 = load ptr, ptr %with_cp_src94, align 8
  %with_cp_dst96 = getelementptr inbounds nuw %Config, ptr %50, i32 0, i32 2
  store ptr %with_cp_val95, ptr %with_cp_dst96, align 8
  %with_ovr97 = getelementptr inbounds nuw %Config, ptr %50, i32 0, i32 2
  store ptr @.str.22, ptr %with_ovr97, align 8
  %with_ovr98 = getelementptr inbounds nuw %Config, ptr %50, i32 0, i32 0
  store i64 1920, ptr %with_ovr98, align 8
  %cast99 = ptrtoint ptr %50 to i64
  store i64 %cast99, ptr @custom, align 8
  %custom = load ptr, ptr @custom, align 8
  %cast100 = ptrtoint ptr %custom to i64
  %null_chk101 = icmp eq i64 %cast100, 0
  %null_ext102 = zext i1 %null_chk101 to i64
  call void @avra_null_deref_trap(ptr @fld_name.23, i64 5, ptr @sty_name.24, i64 6, i64 %null_ext102, ptr @src_file.25, i64 107, i64 45)
  %title_ptr = getelementptr inbounds nuw %Config, ptr %custom, i32 0, i32 2
  %title = load ptr, ptr %title_ptr, align 8
  %51 = call i64 @strlen(ptr %title)
  %52 = call i64 @strlen(ptr @.str.26)
  %concat_total103 = add i64 %51, %52
  %concat_size104 = add i64 %concat_total103, 1
  %53 = call ptr @avra_rc_alloc(i64 %concat_size104)
  %54 = call ptr @memcpy(ptr %53, ptr %title, i64 %51)
  %cast105 = ptrtoint ptr %53 to i64
  %dst2_int106 = add i64 %cast105, %51
  %cast107 = inttoptr i64 %dst2_int106 to ptr
  %rhs_len_p1108 = add i64 %52, 1
  %55 = call ptr @memcpy(ptr %cast107, ptr @.str.26, i64 %rhs_len_p1108)
  %custom109 = load ptr, ptr @custom, align 8
  %cast110 = ptrtoint ptr %custom109 to i64
  %null_chk111 = icmp eq i64 %cast110, 0
  %null_ext112 = zext i1 %null_chk111 to i64
  call void @avra_null_deref_trap(ptr @fld_name.27, i64 5, ptr @sty_name.28, i64 6, i64 %null_ext112, ptr @src_file.29, i64 107, i64 45)
  %width_ptr = getelementptr inbounds nuw %Config, ptr %custom109, i32 0, i32 0
  %width = load i64, ptr %width_ptr, align 8
  %56 = call ptr @avra_rc_alloc(i64 32)
  %57 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %56, i64 32, ptr @.i2s_fmt.30, i64 %width)
  %widen113 = sext i32 %57 to i64
  %58 = call i64 @strlen(ptr %53)
  %59 = call i64 @strlen(ptr %56)
  %concat_total114 = add i64 %58, %59
  %concat_size115 = add i64 %concat_total114, 1
  %60 = call ptr @avra_rc_alloc(i64 %concat_size115)
  %61 = call ptr @memcpy(ptr %60, ptr %53, i64 %58)
  %cast116 = ptrtoint ptr %60 to i64
  %dst2_int117 = add i64 %cast116, %58
  %cast118 = inttoptr i64 %dst2_int117 to ptr
  %rhs_len_p1119 = add i64 %59, 1
  %62 = call ptr @memcpy(ptr %cast118, ptr %56, i64 %rhs_len_p1119)
  %63 = call i64 @strlen(ptr %60)
  %64 = call i64 @strlen(ptr @.str.31)
  %concat_total120 = add i64 %63, %64
  %concat_size121 = add i64 %concat_total120, 1
  %65 = call ptr @avra_rc_alloc(i64 %concat_size121)
  %66 = call ptr @memcpy(ptr %65, ptr %60, i64 %63)
  %cast122 = ptrtoint ptr %65 to i64
  %dst2_int123 = add i64 %cast122, %63
  %cast124 = inttoptr i64 %dst2_int123 to ptr
  %rhs_len_p1125 = add i64 %64, 1
  %67 = call ptr @memcpy(ptr %cast124, ptr @.str.31, i64 %rhs_len_p1125)
  %custom126 = load ptr, ptr @custom, align 8
  %cast127 = ptrtoint ptr %custom126 to i64
  %null_chk128 = icmp eq i64 %cast127, 0
  %null_ext129 = zext i1 %null_chk128 to i64
  call void @avra_null_deref_trap(ptr @fld_name.32, i64 6, ptr @sty_name.33, i64 6, i64 %null_ext129, ptr @src_file.34, i64 107, i64 45)
  %height_ptr = getelementptr inbounds nuw %Config, ptr %custom126, i32 0, i32 1
  %height = load i64, ptr %height_ptr, align 8
  %68 = call ptr @avra_rc_alloc(i64 32)
  %69 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %68, i64 32, ptr @.i2s_fmt.35, i64 %height)
  %widen130 = sext i32 %69 to i64
  %70 = call i64 @strlen(ptr %65)
  %71 = call i64 @strlen(ptr %68)
  %concat_total131 = add i64 %70, %71
  %concat_size132 = add i64 %concat_total131, 1
  %72 = call ptr @avra_rc_alloc(i64 %concat_size132)
  %73 = call ptr @memcpy(ptr %72, ptr %65, i64 %70)
  %cast133 = ptrtoint ptr %72 to i64
  %dst2_int134 = add i64 %cast133, %70
  %cast135 = inttoptr i64 %dst2_int134 to ptr
  %rhs_len_p1136 = add i64 %71, 1
  %74 = call ptr @memcpy(ptr %cast135, ptr %68, i64 %rhs_len_p1136)
  %75 = call i32 @puts(ptr %72)
  %widen137 = sext i32 %75 to i64
  %76 = call i32 @avra_test_summary()
  %widen138 = sext i32 %76 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Config(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_title_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 2
  %rel_title = load ptr, ptr %rel_title_ptr, align 8
  %is_null_title = icmp eq ptr %rel_title, null
  br i1 %is_null_title, label %rel_title_skip, label %rel_title_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_title_skip
  ret i64 0

rel_title_skip:                                   ; preds = %rel_title_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_title_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_title)
  br label %rel_title_skip
}

define i64 @__release_Result(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %Result__Err, ptr %payload, i32 0, i32 1
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_Err:                                     ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_Err
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_Err
  call void @avra_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}
