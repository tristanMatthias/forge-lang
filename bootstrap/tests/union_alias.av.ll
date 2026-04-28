; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%__union = type { i64, ptr }
%Wrapper = type { ptr }

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"show\00", align 1
@mu_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_alias.av\00", align 1
@.str = private unnamed_addr constant [3 x i8] c"hi\00", align 1
@fld_name = private unnamed_addr constant [4 x i8] c"val\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"Wrapper\00", align 1
@src_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_alias.av\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"struct alias: \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"struct alias: \00", align 1
@.match_fn.4 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.5 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_alias.av\00", align 1

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

define ptr @show(i64 %0) {
entry:
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %v = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %v, align 8
  %v1 = load ptr, ptr %v, align 8
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %v1, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm4, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %cast15 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast15

union_arm:                                        ; preds = %entry
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %v1, i32 0, i32 1
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
  %cast3 = ptrtoint ptr %1 to i64
  store i64 %cast3, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq6 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq6, label %union_arm4, label %union_next5

union_arm4:                                       ; preds = %union_next
  %union_pay_ptr7 = getelementptr inbounds nuw %__union, ptr %v1, i32 0, i32 1
  %union_payload8 = load ptr, ptr %union_pay_ptr7, align 8
  %union_val_slot_base9 = ptrtoint ptr %union_payload8 to i64
  %union_val_slot_addr10 = add i64 %union_val_slot_base9, 0
  %union_val_slot11 = inttoptr i64 %union_val_slot_addr10 to ptr
  %union_val12 = load ptr, ptr %union_val_slot11, align 8
  store ptr %union_val12, ptr %s, align 8
  %s13 = load ptr, ptr %s, align 8
  %cast14 = ptrtoint ptr %s13 to i64
  store i64 %cast14, ptr %union_match_result, align 8
  br label %union_match_end

union_next5:                                      ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 8)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %w = alloca ptr, align 8
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
  %3 = call ptr @show(i64 %cast)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr1 = getelementptr inbounds nuw %__union, ptr %5, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr1, align 8
  %6 = call ptr @avra_rc_alloc(i64 8)
  %slot_base2 = ptrtoint ptr %6 to i64
  %slot_addr3 = add i64 %slot_base2, 0
  %slot4 = inttoptr i64 %slot_addr3 to ptr
  store ptr @.str, ptr %slot4, align 8
  %union_pay_ptr5 = getelementptr inbounds nuw %__union, ptr %5, i32 0, i32 1
  store ptr %6, ptr %union_pay_ptr5, align 8
  %cast6 = ptrtoint ptr %5 to i64
  %7 = call ptr @show(i64 %cast6)
  %8 = call i32 @puts(ptr %7)
  %widen7 = sext i32 %8 to i64
  %9 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Wrapper, ptr %9, i32 0, i32 0
  %10 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr8 = getelementptr inbounds nuw %__union, ptr %10, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr8, align 8
  %11 = call ptr @avra_rc_alloc(i64 8)
  %slot_base9 = ptrtoint ptr %11 to i64
  %slot_addr10 = add i64 %slot_base9, 0
  %slot11 = inttoptr i64 %slot_addr10 to ptr
  store i64 99, ptr %slot11, align 8
  %union_pay_ptr12 = getelementptr inbounds nuw %__union, ptr %10, i32 0, i32 1
  store ptr %11, ptr %union_pay_ptr12, align 8
  %cast13 = ptrtoint ptr %10 to i64
  %cast14 = inttoptr i64 %cast13 to ptr
  store ptr %cast14, ptr %fld_ptr, align 8
  %cast15 = ptrtoint ptr %9 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  store ptr %cast16, ptr %w, align 8
  %w17 = load ptr, ptr %w, align 8
  %cast18 = ptrtoint ptr %w17 to i64
  %null_chk = icmp eq i64 %cast18, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 97, i64 25)
  %val_ptr = getelementptr inbounds nuw %Wrapper, ptr %w17, i32 0, i32 0
  %val = load ptr, ptr %val_ptr, align 8
  %union_tag_ptr19 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr19, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm26, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %w_cleanup = load ptr, ptr %w, align 8
  %12 = call i64 @__release_Wrapper(ptr %w_cleanup)
  ret i64 %union_match_val

union_arm:                                        ; preds = %entry
  %union_pay_ptr20 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr20, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %n21 = load i64, ptr %n, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.2, i64 %n21)
  %widen22 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.1)
  %16 = call i64 @strlen(ptr %13)
  %concat_total = add i64 %15, %16
  %concat_size = add i64 %concat_total, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.1, i64 %15)
  %cast23 = ptrtoint ptr %17 to i64
  %dst2_int = add i64 %cast23, %15
  %cast24 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast24, ptr %13, i64 %rhs_len_p1)
  %20 = call i32 @puts(ptr %17)
  %widen25 = sext i32 %20 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq28 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq28, label %union_arm26, label %union_next27

union_arm26:                                      ; preds = %union_next
  %union_pay_ptr29 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 1
  %union_payload30 = load ptr, ptr %union_pay_ptr29, align 8
  %union_val_slot_base31 = ptrtoint ptr %union_payload30 to i64
  %union_val_slot_addr32 = add i64 %union_val_slot_base31, 0
  %union_val_slot33 = inttoptr i64 %union_val_slot_addr32 to ptr
  %union_val34 = load ptr, ptr %union_val_slot33, align 8
  store ptr %union_val34, ptr %s, align 8
  %s35 = load ptr, ptr %s, align 8
  %21 = call i64 @strlen(ptr @.str.3)
  %22 = call i64 @strlen(ptr %s35)
  %concat_total36 = add i64 %21, %22
  %concat_size37 = add i64 %concat_total36, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size37)
  %24 = call ptr @memcpy(ptr %23, ptr @.str.3, i64 %21)
  %cast38 = ptrtoint ptr %23 to i64
  %dst2_int39 = add i64 %cast38, %21
  %cast40 = inttoptr i64 %dst2_int39 to ptr
  %rhs_len_p141 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast40, ptr %s35, i64 %rhs_len_p141)
  %26 = call i32 @puts(ptr %23)
  %widen42 = sext i32 %26 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next27:                                     ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn.4, i64 %union_tag, ptr @mu_file.5, i64 25)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Wrapper(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_val_ptr = getelementptr inbounds nuw %Wrapper, ptr %0, i32 0, i32 0
  %rel_val = load ptr, ptr %rel_val_ptr, align 8
  %is_null_val = icmp eq ptr %rel_val, null
  br i1 %is_null_val, label %rel_val_skip, label %rel_val_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_val_skip
  ret i64 0

rel_val_skip:                                     ; preds = %rel_val_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_val_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_val)
  br label %rel_val_skip
}
