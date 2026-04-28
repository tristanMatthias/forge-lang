; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%__union = type { i64, ptr }
%Person = type { ptr, i64 }

@.str = private unnamed_addr constant [7 x i8] c"bool: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"float: \00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"int: \00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"string: \00", align 1
@.match_fn = private unnamed_addr constant [11 x i8] c"show_multi\00", align 1
@mu_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_combo.av\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"int: \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [9 x i8] c"struct: \00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Person\00", align 1
@src_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_combo.av\00", align 1
@.match_fn.8 = private unnamed_addr constant [12 x i8] c"show_struct\00", align 1
@mu_file.9 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_combo.av\00", align 1
@.str.10 = private unnamed_addr constant [17 x i8] c"hello from union\00", align 1
@.str.11 = private unnamed_addr constant [13 x i8] c"nested: got \00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [11 x i8] c"unexpected\00", align 1
@.str.14 = private unnamed_addr constant [8 x i8] c"not int\00", align 1
@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.16 = private unnamed_addr constant [13 x i8] c"passed int: \00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.18 = private unnamed_addr constant [16 x i8] c"passed string: \00", align 1
@.match_fn.19 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.20 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_combo.av\00", align 1
@.str.21 = private unnamed_addr constant [11 x i8] c"returned: \00", align 1
@.i2s_fmt.22 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.23 = private unnamed_addr constant [11 x i8] c"returned: \00", align 1
@.match_fn.24 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.25 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_combo.av\00", align 1

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

define ptr @show_multi(ptr %0) {
entry:
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %f = alloca double, align 8
  %b = alloca i1, align 1
  %union_match_result = alloca i64, align 8
  %val = alloca ptr, align 8
  store ptr %0, ptr %val, align 8
  %val1 = load ptr, ptr %val, align 8
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 6385087377
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm41, %union_arm23, %union_arm5, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %cast58 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast58

union_arm:                                        ; preds = %entry
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i1, ptr %union_val_slot, align 8
  store i1 %union_val, ptr %b, align 8
  %b2 = load i1, ptr %b, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i1 %b2)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast3, ptr %1, i64 %rhs_len_p1)
  %cast4 = ptrtoint ptr %5 to i64
  store i64 %cast4, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq7 = icmp eq i64 %union_tag, 210712519067
  br i1 %union_tag_eq7, label %union_arm5, label %union_next6

union_arm5:                                       ; preds = %union_next
  %union_pay_ptr8 = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload9 = load ptr, ptr %union_pay_ptr8, align 8
  %union_val_slot_base10 = ptrtoint ptr %union_payload9 to i64
  %union_val_slot_addr11 = add i64 %union_val_slot_base10, 0
  %union_val_slot12 = inttoptr i64 %union_val_slot_addr11 to ptr
  %union_val13 = load double, ptr %union_val_slot12, align 8
  store double %union_val13, ptr %f, align 8
  %f14 = load double, ptr %f, align 8
  %cast15 = bitcast double %f14 to i64
  %8 = call i64 @avra_float_to_string(i64 %cast15)
  %rhs_ptr = inttoptr i64 %8 to ptr
  %9 = call i64 @strlen(ptr @.str.1)
  %10 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total16 = add i64 %9, %10
  %concat_size17 = add i64 %concat_total16, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %12 = call ptr @memcpy(ptr %11, ptr @.str.1, i64 %9)
  %cast18 = ptrtoint ptr %11 to i64
  %dst2_int19 = add i64 %cast18, %9
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast20, ptr %rhs_ptr, i64 %rhs_len_p121)
  %cast22 = ptrtoint ptr %11 to i64
  store i64 %cast22, ptr %union_match_result, align 8
  br label %union_match_end

union_next6:                                      ; preds = %union_next
  %union_tag_eq25 = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq25, label %union_arm23, label %union_next24

union_arm23:                                      ; preds = %union_next6
  %union_pay_ptr26 = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload27 = load ptr, ptr %union_pay_ptr26, align 8
  %union_val_slot_base28 = ptrtoint ptr %union_payload27 to i64
  %union_val_slot_addr29 = add i64 %union_val_slot_base28, 0
  %union_val_slot30 = inttoptr i64 %union_val_slot_addr29 to ptr
  %union_val31 = load i64, ptr %union_val_slot30, align 8
  store i64 %union_val31, ptr %n, align 8
  %n32 = load i64, ptr %n, align 8
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.3, i64 %n32)
  %widen33 = sext i32 %15 to i64
  %16 = call i64 @strlen(ptr @.str.2)
  %17 = call i64 @strlen(ptr %14)
  %concat_total34 = add i64 %16, %17
  %concat_size35 = add i64 %concat_total34, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size35)
  %19 = call ptr @memcpy(ptr %18, ptr @.str.2, i64 %16)
  %cast36 = ptrtoint ptr %18 to i64
  %dst2_int37 = add i64 %cast36, %16
  %cast38 = inttoptr i64 %dst2_int37 to ptr
  %rhs_len_p139 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast38, ptr %14, i64 %rhs_len_p139)
  %cast40 = ptrtoint ptr %18 to i64
  store i64 %cast40, ptr %union_match_result, align 8
  br label %union_match_end

union_next24:                                     ; preds = %union_next6
  %union_tag_eq43 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq43, label %union_arm41, label %union_next42

union_arm41:                                      ; preds = %union_next24
  %union_pay_ptr44 = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload45 = load ptr, ptr %union_pay_ptr44, align 8
  %union_val_slot_base46 = ptrtoint ptr %union_payload45 to i64
  %union_val_slot_addr47 = add i64 %union_val_slot_base46, 0
  %union_val_slot48 = inttoptr i64 %union_val_slot_addr47 to ptr
  %union_val49 = load ptr, ptr %union_val_slot48, align 8
  store ptr %union_val49, ptr %s, align 8
  %s50 = load ptr, ptr %s, align 8
  %21 = call i64 @strlen(ptr @.str.4)
  %22 = call i64 @strlen(ptr %s50)
  %concat_total51 = add i64 %21, %22
  %concat_size52 = add i64 %concat_total51, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size52)
  %24 = call ptr @memcpy(ptr %23, ptr @.str.4, i64 %21)
  %cast53 = ptrtoint ptr %23 to i64
  %dst2_int54 = add i64 %cast53, %21
  %cast55 = inttoptr i64 %dst2_int54 to ptr
  %rhs_len_p156 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast55, ptr %s50, i64 %rhs_len_p156)
  %cast57 = ptrtoint ptr %23 to i64
  store i64 %cast57, ptr %union_match_result, align 8
  br label %union_match_end

union_next42:                                     ; preds = %union_next24
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 14)
  unreachable
}

define ptr @show_struct(ptr %0) {
entry:
  %p = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %val = alloca ptr, align 8
  store ptr %0, ptr %val, align 8
  %val1 = load ptr, ptr %val, align 8
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm5, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %cast23 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast23

union_arm:                                        ; preds = %entry
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %n2 = load i64, ptr %n, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.6, i64 %n2)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.5)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.5, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast3, ptr %1, i64 %rhs_len_p1)
  %cast4 = ptrtoint ptr %5 to i64
  store i64 %cast4, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq7 = icmp eq i64 %union_tag, 6952643976476
  br i1 %union_tag_eq7, label %union_arm5, label %union_next6

union_arm5:                                       ; preds = %union_next
  %union_pay_ptr8 = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload9 = load ptr, ptr %union_pay_ptr8, align 8
  %union_val_slot_base10 = ptrtoint ptr %union_payload9 to i64
  %union_val_slot_addr11 = add i64 %union_val_slot_base10, 0
  %union_val_slot12 = inttoptr i64 %union_val_slot_addr11 to ptr
  %union_val13 = load ptr, ptr %union_val_slot12, align 8
  store ptr %union_val13, ptr %p, align 8
  %p14 = load ptr, ptr %p, align 8
  %cast15 = ptrtoint ptr %p14 to i64
  %null_chk = icmp eq i64 %cast15, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 97, i64 23)
  %name_ptr = getelementptr inbounds nuw %Person, ptr %p14, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %8 = call i64 @strlen(ptr @.str.7)
  %9 = call i64 @strlen(ptr %name)
  %concat_total16 = add i64 %8, %9
  %concat_size17 = add i64 %concat_total16, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %11 = call ptr @memcpy(ptr %10, ptr @.str.7, i64 %8)
  %cast18 = ptrtoint ptr %10 to i64
  %dst2_int19 = add i64 %cast18, %8
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast20, ptr %name, i64 %rhs_len_p121)
  %cast22 = ptrtoint ptr %10 to i64
  store i64 %cast22, ptr %union_match_result, align 8
  br label %union_match_end

union_next6:                                      ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn.8, i64 %union_tag, ptr @mu_file.9, i64 23)
  unreachable
}

define ptr @passthrough(ptr %0) {
entry:
  %val = alloca ptr, align 8
  store ptr %0, ptr %val, align 8
  %val1 = load ptr, ptr %val, align 8
  ret ptr %val1
}

define ptr @make_union(i1 %0) {
entry:
  %x11 = alloca ptr, align 8
  %x = alloca ptr, align 8
  %sif_result = alloca i64, align 8
  %use_int = alloca i1, align 1
  store i1 %0, ptr %use_int, align 8
  %use_int1 = load i1, ptr %use_int, align 8
  store i64 0, ptr %sif_result, align 8
  br i1 %use_int1, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %1 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 1
  store ptr %2, ptr %union_pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %x, align 8
  %x3 = load ptr, ptr %x, align 8
  %cast4 = ptrtoint ptr %x3 to i64
  store i64 %cast4, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr5 = getelementptr inbounds nuw %__union, ptr %3, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr5, align 8
  %4 = call ptr @avra_rc_alloc(i64 8)
  %slot_base6 = ptrtoint ptr %4 to i64
  %slot_addr7 = add i64 %slot_base6, 0
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store ptr @.str.10, ptr %slot8, align 8
  %union_pay_ptr9 = getelementptr inbounds nuw %__union, ptr %3, i32 0, i32 1
  store ptr %4, ptr %union_pay_ptr9, align 8
  %cast10 = ptrtoint ptr %3 to i64
  %cast12 = inttoptr i64 %cast10 to ptr
  store ptr %cast12, ptr %x11, align 8
  %x13 = load ptr, ptr %x11, align 8
  %cast14 = ptrtoint ptr %x13 to i64
  store i64 %cast14, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast15 = inttoptr i64 %sif_val to ptr
  ret ptr %cast15
}

define ptr @nested_match(ptr %0) {
entry:
  %m = alloca i64, align 8
  %union_match_result9 = alloca i64, align 8
  %inner = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %outer = alloca ptr, align 8
  store ptr %0, ptr %outer, align 8
  %outer1 = load ptr, ptr %outer, align 8
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %outer1, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_next, %union_match_end10
  %union_match_val24 = load i64, ptr %union_match_result, align 8
  %cast25 = inttoptr i64 %union_match_val24 to ptr
  ret ptr %cast25

union_arm:                                        ; preds = %entry
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %outer1, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %n2 = load i64, ptr %n, align 8
  %add = add i64 %n2, 1
  %1 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr3 = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr3, align 8
  %2 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %add, ptr %slot, align 8
  %union_pay_ptr4 = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 1
  store ptr %2, ptr %union_pay_ptr4, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast5 = inttoptr i64 %cast to ptr
  store ptr %cast5, ptr %inner, align 8
  %inner6 = load ptr, ptr %inner, align 8
  %union_tag_ptr7 = getelementptr inbounds nuw %__union, ptr %inner6, i32 0, i32 0
  %union_tag8 = load i64, ptr %union_tag_ptr7, align 8
  store i64 0, ptr %union_match_result9, align 8
  %union_tag_eq13 = icmp eq i64 %union_tag8, 193495088
  br i1 %union_tag_eq13, label %union_arm11, label %union_next12

union_next:                                       ; preds = %entry
  store i64 ptrtoint (ptr @.str.14 to i64), ptr %union_match_result, align 8
  br label %union_match_end

union_match_end10:                                ; preds = %union_next12, %union_arm11
  %union_match_val = load i64, ptr %union_match_result9, align 8
  store i64 %union_match_val, ptr %union_match_result, align 8
  br label %union_match_end

union_arm11:                                      ; preds = %union_arm
  %union_pay_ptr14 = getelementptr inbounds nuw %__union, ptr %inner6, i32 0, i32 1
  %union_payload15 = load ptr, ptr %union_pay_ptr14, align 8
  %union_val_slot_base16 = ptrtoint ptr %union_payload15 to i64
  %union_val_slot_addr17 = add i64 %union_val_slot_base16, 0
  %union_val_slot18 = inttoptr i64 %union_val_slot_addr17 to ptr
  %union_val19 = load i64, ptr %union_val_slot18, align 8
  store i64 %union_val19, ptr %m, align 8
  %m20 = load i64, ptr %m, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.12, i64 %m20)
  %widen = sext i32 %4 to i64
  %5 = call i64 @strlen(ptr @.str.11)
  %6 = call i64 @strlen(ptr %3)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.11, i64 %5)
  %cast21 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast21, %5
  %cast22 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast22, ptr %3, i64 %rhs_len_p1)
  %cast23 = ptrtoint ptr %7 to i64
  store i64 %cast23, ptr %union_match_result9, align 8
  br label %union_match_end10

union_next12:                                     ; preds = %union_arm
  store i64 ptrtoint (ptr @.str.13 to i64), ptr %union_match_result9, align 8
  br label %union_match_end10
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %x = alloca ptr, align 8
  %s88 = alloca ptr, align 8
  %n69 = alloca i64, align 8
  %union_match_result58 = alloca i64, align 8
  %r = alloca ptr, align 8
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %v = alloca ptr, align 8
  %p = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 0
  store i64 6385087377, ptr %union_tag_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i1 true, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 1
  store ptr %2, ptr %union_pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %3 = call ptr @show_multi(ptr %cast1)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %5 = call i64 @avra_float_parse(ptr @.float_str)
  %cast2 = bitcast i64 %5 to double
  %6 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr3 = getelementptr inbounds nuw %__union, ptr %6, i32 0, i32 0
  store i64 210712519067, ptr %union_tag_ptr3, align 8
  %7 = call ptr @avra_rc_alloc(i64 8)
  %slot_base4 = ptrtoint ptr %7 to i64
  %slot_addr5 = add i64 %slot_base4, 0
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store double %cast2, ptr %slot6, align 8
  %union_pay_ptr7 = getelementptr inbounds nuw %__union, ptr %6, i32 0, i32 1
  store ptr %7, ptr %union_pay_ptr7, align 8
  %cast8 = ptrtoint ptr %6 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  %8 = call ptr @show_multi(ptr %cast9)
  %9 = call i32 @puts(ptr %8)
  %widen10 = sext i32 %9 to i64
  %10 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Person, ptr %10, i32 0, i32 0
  store ptr @.str.15, ptr %fld_ptr, align 8
  %fld_ptr11 = getelementptr inbounds nuw %Person, ptr %10, i32 0, i32 1
  store i64 30, ptr %fld_ptr11, align 8
  %cast12 = ptrtoint ptr %10 to i64
  %cast13 = inttoptr i64 %cast12 to ptr
  store ptr %cast13, ptr %p, align 8
  %p14 = load ptr, ptr %p, align 8
  %11 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr15 = getelementptr inbounds nuw %__union, ptr %11, i32 0, i32 0
  store i64 6952643976476, ptr %union_tag_ptr15, align 8
  %12 = call ptr @avra_rc_alloc(i64 8)
  %slot_base16 = ptrtoint ptr %12 to i64
  %slot_addr17 = add i64 %slot_base16, 0
  %slot18 = inttoptr i64 %slot_addr17 to ptr
  store ptr %p14, ptr %slot18, align 8
  %union_pay_ptr19 = getelementptr inbounds nuw %__union, ptr %11, i32 0, i32 1
  store ptr %12, ptr %union_pay_ptr19, align 8
  %cast20 = ptrtoint ptr %11 to i64
  %cast21 = inttoptr i64 %cast20 to ptr
  %13 = call ptr @show_struct(ptr %cast21)
  %14 = call i32 @puts(ptr %13)
  %widen22 = sext i32 %14 to i64
  %15 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr23 = getelementptr inbounds nuw %__union, ptr %15, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr23, align 8
  %16 = call ptr @avra_rc_alloc(i64 8)
  %slot_base24 = ptrtoint ptr %16 to i64
  %slot_addr25 = add i64 %slot_base24, 0
  %slot26 = inttoptr i64 %slot_addr25 to ptr
  store i64 42, ptr %slot26, align 8
  %union_pay_ptr27 = getelementptr inbounds nuw %__union, ptr %15, i32 0, i32 1
  store ptr %16, ptr %union_pay_ptr27, align 8
  %cast28 = ptrtoint ptr %15 to i64
  %cast29 = inttoptr i64 %cast28 to ptr
  store ptr %cast29, ptr %v, align 8
  %v30 = load ptr, ptr %v, align 8
  %17 = call ptr @passthrough(ptr %v30)
  %union_tag_ptr31 = getelementptr inbounds nuw %__union, ptr %17, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr31, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm38, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %18 = call ptr @make_union(i1 false)
  store ptr %18, ptr %r, align 8
  %r55 = load ptr, ptr %r, align 8
  %union_tag_ptr56 = getelementptr inbounds nuw %__union, ptr %r55, i32 0, i32 0
  %union_tag57 = load i64, ptr %union_tag_ptr56, align 8
  store i64 0, ptr %union_match_result58, align 8
  %union_tag_eq62 = icmp eq i64 %union_tag57, 193495088
  br i1 %union_tag_eq62, label %union_arm60, label %union_next61

union_arm:                                        ; preds = %entry
  %union_pay_ptr32 = getelementptr inbounds nuw %__union, ptr %17, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr32, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %n33 = load i64, ptr %n, align 8
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.17, i64 %n33)
  %widen34 = sext i32 %20 to i64
  %21 = call i64 @strlen(ptr @.str.16)
  %22 = call i64 @strlen(ptr %19)
  %concat_total = add i64 %21, %22
  %concat_size = add i64 %concat_total, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size)
  %24 = call ptr @memcpy(ptr %23, ptr @.str.16, i64 %21)
  %cast35 = ptrtoint ptr %23 to i64
  %dst2_int = add i64 %cast35, %21
  %cast36 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast36, ptr %19, i64 %rhs_len_p1)
  %26 = call i32 @puts(ptr %23)
  %widen37 = sext i32 %26 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq40 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq40, label %union_arm38, label %union_next39

union_arm38:                                      ; preds = %union_next
  %union_pay_ptr41 = getelementptr inbounds nuw %__union, ptr %17, i32 0, i32 1
  %union_payload42 = load ptr, ptr %union_pay_ptr41, align 8
  %union_val_slot_base43 = ptrtoint ptr %union_payload42 to i64
  %union_val_slot_addr44 = add i64 %union_val_slot_base43, 0
  %union_val_slot45 = inttoptr i64 %union_val_slot_addr44 to ptr
  %union_val46 = load ptr, ptr %union_val_slot45, align 8
  store ptr %union_val46, ptr %s, align 8
  %s47 = load ptr, ptr %s, align 8
  %27 = call i64 @strlen(ptr @.str.18)
  %28 = call i64 @strlen(ptr %s47)
  %concat_total48 = add i64 %27, %28
  %concat_size49 = add i64 %concat_total48, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size49)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.18, i64 %27)
  %cast50 = ptrtoint ptr %29 to i64
  %dst2_int51 = add i64 %cast50, %27
  %cast52 = inttoptr i64 %dst2_int51 to ptr
  %rhs_len_p153 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast52, ptr %s47, i64 %rhs_len_p153)
  %32 = call i32 @puts(ptr %29)
  %widen54 = sext i32 %32 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next39:                                     ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn.19, i64 %union_tag, ptr @mu_file.20, i64 68)
  unreachable

union_match_end59:                                ; preds = %union_arm79, %union_arm60
  %union_match_val97 = load i64, ptr %union_match_result58, align 8
  %33 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr98 = getelementptr inbounds nuw %__union, ptr %33, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr98, align 8
  %34 = call ptr @avra_rc_alloc(i64 8)
  %slot_base99 = ptrtoint ptr %34 to i64
  %slot_addr100 = add i64 %slot_base99, 0
  %slot101 = inttoptr i64 %slot_addr100 to ptr
  store i64 6, ptr %slot101, align 8
  %union_pay_ptr102 = getelementptr inbounds nuw %__union, ptr %33, i32 0, i32 1
  store ptr %34, ptr %union_pay_ptr102, align 8
  %cast103 = ptrtoint ptr %33 to i64
  %cast104 = inttoptr i64 %cast103 to ptr
  store ptr %cast104, ptr %x, align 8
  %x105 = load ptr, ptr %x, align 8
  %35 = call ptr @nested_match(ptr %x105)
  %36 = call i32 @puts(ptr %35)
  %widen106 = sext i32 %36 to i64
  ret i64 0

union_arm60:                                      ; preds = %union_match_end
  %union_pay_ptr63 = getelementptr inbounds nuw %__union, ptr %r55, i32 0, i32 1
  %union_payload64 = load ptr, ptr %union_pay_ptr63, align 8
  %union_val_slot_base65 = ptrtoint ptr %union_payload64 to i64
  %union_val_slot_addr66 = add i64 %union_val_slot_base65, 0
  %union_val_slot67 = inttoptr i64 %union_val_slot_addr66 to ptr
  %union_val68 = load i64, ptr %union_val_slot67, align 8
  store i64 %union_val68, ptr %n69, align 8
  %n70 = load i64, ptr %n69, align 8
  %37 = call ptr @avra_rc_alloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @.i2s_fmt.22, i64 %n70)
  %widen71 = sext i32 %38 to i64
  %39 = call i64 @strlen(ptr @.str.21)
  %40 = call i64 @strlen(ptr %37)
  %concat_total72 = add i64 %39, %40
  %concat_size73 = add i64 %concat_total72, 1
  %41 = call ptr @avra_rc_alloc(i64 %concat_size73)
  %42 = call ptr @memcpy(ptr %41, ptr @.str.21, i64 %39)
  %cast74 = ptrtoint ptr %41 to i64
  %dst2_int75 = add i64 %cast74, %39
  %cast76 = inttoptr i64 %dst2_int75 to ptr
  %rhs_len_p177 = add i64 %40, 1
  %43 = call ptr @memcpy(ptr %cast76, ptr %37, i64 %rhs_len_p177)
  %44 = call i32 @puts(ptr %41)
  %widen78 = sext i32 %44 to i64
  store i64 0, ptr %union_match_result58, align 8
  br label %union_match_end59

union_next61:                                     ; preds = %union_match_end
  %union_tag_eq81 = icmp eq i64 %union_tag57, 6954031493116
  br i1 %union_tag_eq81, label %union_arm79, label %union_next80

union_arm79:                                      ; preds = %union_next61
  %union_pay_ptr82 = getelementptr inbounds nuw %__union, ptr %r55, i32 0, i32 1
  %union_payload83 = load ptr, ptr %union_pay_ptr82, align 8
  %union_val_slot_base84 = ptrtoint ptr %union_payload83 to i64
  %union_val_slot_addr85 = add i64 %union_val_slot_base84, 0
  %union_val_slot86 = inttoptr i64 %union_val_slot_addr85 to ptr
  %union_val87 = load ptr, ptr %union_val_slot86, align 8
  store ptr %union_val87, ptr %s88, align 8
  %s89 = load ptr, ptr %s88, align 8
  %45 = call i64 @strlen(ptr @.str.23)
  %46 = call i64 @strlen(ptr %s89)
  %concat_total90 = add i64 %45, %46
  %concat_size91 = add i64 %concat_total90, 1
  %47 = call ptr @avra_rc_alloc(i64 %concat_size91)
  %48 = call ptr @memcpy(ptr %47, ptr @.str.23, i64 %45)
  %cast92 = ptrtoint ptr %47 to i64
  %dst2_int93 = add i64 %cast92, %45
  %cast94 = inttoptr i64 %dst2_int93 to ptr
  %rhs_len_p195 = add i64 %46, 1
  %49 = call ptr @memcpy(ptr %cast94, ptr %s89, i64 %rhs_len_p195)
  %50 = call i32 @puts(ptr %47)
  %widen96 = sext i32 %50 to i64
  store i64 0, ptr %union_match_result58, align 8
  br label %union_match_end59

union_next80:                                     ; preds = %union_next61
  call void @avra_match_unreachable(ptr @.match_fn.24, i64 %union_tag57, ptr @mu_file.25, i64 75)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Person(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Person, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}
