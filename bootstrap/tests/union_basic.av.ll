; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%__union = type { i64, ptr }

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"show\00", align 1
@mu_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_basic.av\00", align 1
@.str = private unnamed_addr constant [12 x i8] c"int value: \00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"string value: \00", align 1
@.match_fn.3 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file.4 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_basic.av\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"got int: \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [17 x i8] c"matched wildcard\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"anything\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"let int: \00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [13 x i8] c"let string: \00", align 1
@.match_fn.14 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.15 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_basic.av\00", align 1
@.str.16 = private unnamed_addr constant [3 x i8] c"hi\00", align 1
@.str.17 = private unnamed_addr constant [10 x i8] c"let int: \00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.19 = private unnamed_addr constant [13 x i8] c"let string: \00", align 1
@.match_fn.20 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.21 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_basic.av\00", align 1

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

define ptr @show(ptr %0) {
entry:
  %s = alloca ptr, align 8
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

union_match_end:                                  ; preds = %union_arm3, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %cast14 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast14

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
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %n2)
  %widen = sext i32 %2 to i64
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq5 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq5, label %union_arm3, label %union_next4

union_arm3:                                       ; preds = %union_next
  %union_pay_ptr6 = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload7 = load ptr, ptr %union_pay_ptr6, align 8
  %union_val_slot_base8 = ptrtoint ptr %union_payload7 to i64
  %union_val_slot_addr9 = add i64 %union_val_slot_base8, 0
  %union_val_slot10 = inttoptr i64 %union_val_slot_addr9 to ptr
  %union_val11 = load ptr, ptr %union_val_slot10, align 8
  store ptr %union_val11, ptr %s, align 8
  %s12 = load ptr, ptr %s, align 8
  %cast13 = ptrtoint ptr %s12 to i64
  store i64 %cast13, ptr %union_match_result, align 8
  br label %union_match_end

union_next4:                                      ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 10)
  unreachable
}

define ptr @describe(ptr %0) {
entry:
  %s = alloca ptr, align 8
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
  %cast22 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast22

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
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.1, i64 %n2)
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
  %union_tag_eq7 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq7, label %union_arm5, label %union_next6

union_arm5:                                       ; preds = %union_next
  %union_pay_ptr8 = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload9 = load ptr, ptr %union_pay_ptr8, align 8
  %union_val_slot_base10 = ptrtoint ptr %union_payload9 to i64
  %union_val_slot_addr11 = add i64 %union_val_slot_base10, 0
  %union_val_slot12 = inttoptr i64 %union_val_slot_addr11 to ptr
  %union_val13 = load ptr, ptr %union_val_slot12, align 8
  store ptr %union_val13, ptr %s, align 8
  %s14 = load ptr, ptr %s, align 8
  %8 = call i64 @strlen(ptr @.str.2)
  %9 = call i64 @strlen(ptr %s14)
  %concat_total15 = add i64 %8, %9
  %concat_size16 = add i64 %concat_total15, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size16)
  %11 = call ptr @memcpy(ptr %10, ptr @.str.2, i64 %8)
  %cast17 = ptrtoint ptr %10 to i64
  %dst2_int18 = add i64 %cast17, %8
  %cast19 = inttoptr i64 %dst2_int18 to ptr
  %rhs_len_p120 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast19, ptr %s14, i64 %rhs_len_p120)
  %cast21 = ptrtoint ptr %10 to i64
  store i64 %cast21, ptr %union_match_result, align 8
  br label %union_match_end

union_next6:                                      ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %union_tag, ptr @mu_file.4, i64 17)
  unreachable
}

define ptr @with_wildcard(ptr %0) {
entry:
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

union_match_end:                                  ; preds = %union_next, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %cast5 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast5

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
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %union_match_result, align 8
  br label %union_match_end
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %s106 = alloca ptr, align 8
  %n87 = alloca i64, align 8
  %union_match_result76 = alloca i64, align 8
  %y = alloca ptr, align 8
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %x = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str.8, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 1
  store ptr %2, ptr %union_pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %3 = call ptr @show(ptr %cast1)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr2 = getelementptr inbounds nuw %__union, ptr %5, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr2, align 8
  %6 = call ptr @avra_rc_alloc(i64 8)
  %slot_base3 = ptrtoint ptr %6 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 42, ptr %slot5, align 8
  %union_pay_ptr6 = getelementptr inbounds nuw %__union, ptr %5, i32 0, i32 1
  store ptr %6, ptr %union_pay_ptr6, align 8
  %cast7 = ptrtoint ptr %5 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %7 = call ptr @show(ptr %cast8)
  %8 = call i32 @puts(ptr %7)
  %widen9 = sext i32 %8 to i64
  %9 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr10 = getelementptr inbounds nuw %__union, ptr %9, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr10, align 8
  %10 = call ptr @avra_rc_alloc(i64 8)
  %slot_base11 = ptrtoint ptr %10 to i64
  %slot_addr12 = add i64 %slot_base11, 0
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store i64 10, ptr %slot13, align 8
  %union_pay_ptr14 = getelementptr inbounds nuw %__union, ptr %9, i32 0, i32 1
  store ptr %10, ptr %union_pay_ptr14, align 8
  %cast15 = ptrtoint ptr %9 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  %11 = call ptr @describe(ptr %cast16)
  %12 = call i32 @puts(ptr %11)
  %widen17 = sext i32 %12 to i64
  %13 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr18 = getelementptr inbounds nuw %__union, ptr %13, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr18, align 8
  %14 = call ptr @avra_rc_alloc(i64 8)
  %slot_base19 = ptrtoint ptr %14 to i64
  %slot_addr20 = add i64 %slot_base19, 0
  %slot21 = inttoptr i64 %slot_addr20 to ptr
  store ptr @.str.9, ptr %slot21, align 8
  %union_pay_ptr22 = getelementptr inbounds nuw %__union, ptr %13, i32 0, i32 1
  store ptr %14, ptr %union_pay_ptr22, align 8
  %cast23 = ptrtoint ptr %13 to i64
  %cast24 = inttoptr i64 %cast23 to ptr
  %15 = call ptr @describe(ptr %cast24)
  %16 = call i32 @puts(ptr %15)
  %widen25 = sext i32 %16 to i64
  %17 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr26 = getelementptr inbounds nuw %__union, ptr %17, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr26, align 8
  %18 = call ptr @avra_rc_alloc(i64 8)
  %slot_base27 = ptrtoint ptr %18 to i64
  %slot_addr28 = add i64 %slot_base27, 0
  %slot29 = inttoptr i64 %slot_addr28 to ptr
  store ptr @.str.10, ptr %slot29, align 8
  %union_pay_ptr30 = getelementptr inbounds nuw %__union, ptr %17, i32 0, i32 1
  store ptr %18, ptr %union_pay_ptr30, align 8
  %cast31 = ptrtoint ptr %17 to i64
  %cast32 = inttoptr i64 %cast31 to ptr
  %19 = call ptr @with_wildcard(ptr %cast32)
  %20 = call i32 @puts(ptr %19)
  %widen33 = sext i32 %20 to i64
  %21 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr34 = getelementptr inbounds nuw %__union, ptr %21, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr34, align 8
  %22 = call ptr @avra_rc_alloc(i64 8)
  %slot_base35 = ptrtoint ptr %22 to i64
  %slot_addr36 = add i64 %slot_base35, 0
  %slot37 = inttoptr i64 %slot_addr36 to ptr
  store i64 99, ptr %slot37, align 8
  %union_pay_ptr38 = getelementptr inbounds nuw %__union, ptr %21, i32 0, i32 1
  store ptr %22, ptr %union_pay_ptr38, align 8
  %cast39 = ptrtoint ptr %21 to i64
  %cast40 = inttoptr i64 %cast39 to ptr
  store ptr %cast40, ptr %x, align 8
  %x41 = load ptr, ptr %x, align 8
  %union_tag_ptr42 = getelementptr inbounds nuw %__union, ptr %x41, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr42, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm49, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %23 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr66 = getelementptr inbounds nuw %__union, ptr %23, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr66, align 8
  %24 = call ptr @avra_rc_alloc(i64 8)
  %slot_base67 = ptrtoint ptr %24 to i64
  %slot_addr68 = add i64 %slot_base67, 0
  %slot69 = inttoptr i64 %slot_addr68 to ptr
  store ptr @.str.16, ptr %slot69, align 8
  %union_pay_ptr70 = getelementptr inbounds nuw %__union, ptr %23, i32 0, i32 1
  store ptr %24, ptr %union_pay_ptr70, align 8
  %cast71 = ptrtoint ptr %23 to i64
  %cast72 = inttoptr i64 %cast71 to ptr
  store ptr %cast72, ptr %y, align 8
  %y73 = load ptr, ptr %y, align 8
  %union_tag_ptr74 = getelementptr inbounds nuw %__union, ptr %y73, i32 0, i32 0
  %union_tag75 = load i64, ptr %union_tag_ptr74, align 8
  store i64 0, ptr %union_match_result76, align 8
  %union_tag_eq80 = icmp eq i64 %union_tag75, 193495088
  br i1 %union_tag_eq80, label %union_arm78, label %union_next79

union_arm:                                        ; preds = %entry
  %union_pay_ptr43 = getelementptr inbounds nuw %__union, ptr %x41, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr43, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %n44 = load i64, ptr %n, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.12, i64 %n44)
  %widen45 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr @.str.11)
  %28 = call i64 @strlen(ptr %25)
  %concat_total = add i64 %27, %28
  %concat_size = add i64 %concat_total, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.11, i64 %27)
  %cast46 = ptrtoint ptr %29 to i64
  %dst2_int = add i64 %cast46, %27
  %cast47 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast47, ptr %25, i64 %rhs_len_p1)
  %32 = call i32 @puts(ptr %29)
  %widen48 = sext i32 %32 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq51 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq51, label %union_arm49, label %union_next50

union_arm49:                                      ; preds = %union_next
  %union_pay_ptr52 = getelementptr inbounds nuw %__union, ptr %x41, i32 0, i32 1
  %union_payload53 = load ptr, ptr %union_pay_ptr52, align 8
  %union_val_slot_base54 = ptrtoint ptr %union_payload53 to i64
  %union_val_slot_addr55 = add i64 %union_val_slot_base54, 0
  %union_val_slot56 = inttoptr i64 %union_val_slot_addr55 to ptr
  %union_val57 = load ptr, ptr %union_val_slot56, align 8
  store ptr %union_val57, ptr %s, align 8
  %s58 = load ptr, ptr %s, align 8
  %33 = call i64 @strlen(ptr @.str.13)
  %34 = call i64 @strlen(ptr %s58)
  %concat_total59 = add i64 %33, %34
  %concat_size60 = add i64 %concat_total59, 1
  %35 = call ptr @avra_rc_alloc(i64 %concat_size60)
  %36 = call ptr @memcpy(ptr %35, ptr @.str.13, i64 %33)
  %cast61 = ptrtoint ptr %35 to i64
  %dst2_int62 = add i64 %cast61, %33
  %cast63 = inttoptr i64 %dst2_int62 to ptr
  %rhs_len_p164 = add i64 %34, 1
  %37 = call ptr @memcpy(ptr %cast63, ptr %s58, i64 %rhs_len_p164)
  %38 = call i32 @puts(ptr %35)
  %widen65 = sext i32 %38 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next50:                                     ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn.14, i64 %union_tag, ptr @mu_file.15, i64 39)
  unreachable

union_match_end77:                                ; preds = %union_arm97, %union_arm78
  %union_match_val115 = load i64, ptr %union_match_result76, align 8
  ret i64 %union_match_val115

union_arm78:                                      ; preds = %union_match_end
  %union_pay_ptr81 = getelementptr inbounds nuw %__union, ptr %y73, i32 0, i32 1
  %union_payload82 = load ptr, ptr %union_pay_ptr81, align 8
  %union_val_slot_base83 = ptrtoint ptr %union_payload82 to i64
  %union_val_slot_addr84 = add i64 %union_val_slot_base83, 0
  %union_val_slot85 = inttoptr i64 %union_val_slot_addr84 to ptr
  %union_val86 = load i64, ptr %union_val_slot85, align 8
  store i64 %union_val86, ptr %n87, align 8
  %n88 = load i64, ptr %n87, align 8
  %39 = call ptr @avra_rc_alloc(i64 32)
  %40 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %39, i64 32, ptr @.i2s_fmt.18, i64 %n88)
  %widen89 = sext i32 %40 to i64
  %41 = call i64 @strlen(ptr @.str.17)
  %42 = call i64 @strlen(ptr %39)
  %concat_total90 = add i64 %41, %42
  %concat_size91 = add i64 %concat_total90, 1
  %43 = call ptr @avra_rc_alloc(i64 %concat_size91)
  %44 = call ptr @memcpy(ptr %43, ptr @.str.17, i64 %41)
  %cast92 = ptrtoint ptr %43 to i64
  %dst2_int93 = add i64 %cast92, %41
  %cast94 = inttoptr i64 %dst2_int93 to ptr
  %rhs_len_p195 = add i64 %42, 1
  %45 = call ptr @memcpy(ptr %cast94, ptr %39, i64 %rhs_len_p195)
  %46 = call i32 @puts(ptr %43)
  %widen96 = sext i32 %46 to i64
  store i64 0, ptr %union_match_result76, align 8
  br label %union_match_end77

union_next79:                                     ; preds = %union_match_end
  %union_tag_eq99 = icmp eq i64 %union_tag75, 6954031493116
  br i1 %union_tag_eq99, label %union_arm97, label %union_next98

union_arm97:                                      ; preds = %union_next79
  %union_pay_ptr100 = getelementptr inbounds nuw %__union, ptr %y73, i32 0, i32 1
  %union_payload101 = load ptr, ptr %union_pay_ptr100, align 8
  %union_val_slot_base102 = ptrtoint ptr %union_payload101 to i64
  %union_val_slot_addr103 = add i64 %union_val_slot_base102, 0
  %union_val_slot104 = inttoptr i64 %union_val_slot_addr103 to ptr
  %union_val105 = load ptr, ptr %union_val_slot104, align 8
  store ptr %union_val105, ptr %s106, align 8
  %s107 = load ptr, ptr %s106, align 8
  %47 = call i64 @strlen(ptr @.str.19)
  %48 = call i64 @strlen(ptr %s107)
  %concat_total108 = add i64 %47, %48
  %concat_size109 = add i64 %concat_total108, 1
  %49 = call ptr @avra_rc_alloc(i64 %concat_size109)
  %50 = call ptr @memcpy(ptr %49, ptr @.str.19, i64 %47)
  %cast110 = ptrtoint ptr %49 to i64
  %dst2_int111 = add i64 %cast110, %47
  %cast112 = inttoptr i64 %dst2_int111 to ptr
  %rhs_len_p1113 = add i64 %48, 1
  %51 = call ptr @memcpy(ptr %cast112, ptr %s107, i64 %rhs_len_p1113)
  %52 = call i32 @puts(ptr %49)
  %widen114 = sext i32 %52 to i64
  store i64 0, ptr %union_match_result76, align 8
  br label %union_match_end77

union_next98:                                     ; preds = %union_next79
  call void @avra_match_unreachable(ptr @.match_fn.20, i64 %union_tag75, ptr @mu_file.21, i64 45)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
