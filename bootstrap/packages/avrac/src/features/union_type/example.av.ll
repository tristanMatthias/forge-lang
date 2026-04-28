; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%__union = type { i64, ptr }

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"show\00", align 1
@mu_file = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/union_type/example.av\00", align 1
@.str = private unnamed_addr constant [12 x i8] c"int value: \00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"string value: \00", align 1
@.match_fn.3 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file.4 = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/union_type/example.av\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"got int: \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [17 x i8] c"matched wildcard\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"anything\00", align 1

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
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 8)
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
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %union_tag, ptr @mu_file.4, i64 15)
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
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
