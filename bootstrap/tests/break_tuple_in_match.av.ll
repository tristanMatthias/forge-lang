; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Color = type { i64, ptr }

@pair = global i64 0
@first = global i64 0
@second = global i64 0
@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_tuple_in_match.av\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"blue \00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.6 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.7 = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_tuple_in_match.av\00", align 1

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
  %s49 = alloca i64, align 8
  %match_stmt_discard31 = alloca i64, align 8
  %s19 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %slot_base = ptrtoint ptr %0 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %cast, ptr %slot, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Color, ptr %2, i32 0, i32 0
  store i64 6383934317, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Color, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr2, align 8
  %slot_base3 = ptrtoint ptr %3 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 42, ptr %slot5, align 8
  %cast6 = ptrtoint ptr %2 to i64
  %slot_base7 = ptrtoint ptr %0 to i64
  %slot_addr8 = add i64 %slot_base7, 8
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %cast6, ptr %slot9, align 8
  %cast10 = ptrtoint ptr %0 to i64
  store i64 %cast10, ptr @pair, align 8
  %pair = load ptr, ptr @pair, align 8
  %tup_val_slot_base = ptrtoint ptr %pair to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  store i64 %tup_val, ptr @first, align 8
  %first = load ptr, ptr @first, align 8
  %tag_ptr11 = getelementptr inbounds nuw %Color, ptr %first, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr11, align 8
  %tag_eq = icmp eq i64 %tag, 193469728
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm16, %march_arm12, %march_arm
  %pair23 = load ptr, ptr @pair, align 8
  %tup_val_slot_base24 = ptrtoint ptr %pair23 to i64
  %tup_val_slot_addr25 = add i64 %tup_val_slot_base24, 8
  %tup_val_slot26 = inttoptr i64 %tup_val_slot_addr25 to ptr
  %tup_val27 = load i64, ptr %tup_val_slot26, align 8
  store i64 %tup_val27, ptr @second, align 8
  %second = load ptr, ptr @second, align 8
  %tag_ptr28 = getelementptr inbounds nuw %Color, ptr %second, i32 0, i32 0
  %tag29 = load i64, ptr %tag_ptr28, align 8
  %tag_eq34 = icmp eq i64 %tag29, 193469728
  br i1 %tag_eq34, label %march_arm32, label %march_next33

march_arm:                                        ; preds = %entry
  %4 = call i32 @puts(ptr @.str)
  %widen = sext i32 %4 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq14 = icmp eq i64 %tag, 210675960374
  br i1 %tag_eq14, label %march_arm12, label %march_next13

march_arm12:                                      ; preds = %march_next
  %5 = call i32 @puts(ptr @.str.1)
  %widen15 = sext i32 %5 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next13:                                     ; preds = %march_next
  %tag_eq18 = icmp eq i64 %tag, 6383934317
  br i1 %tag_eq18, label %march_arm16, label %march_next17

march_arm16:                                      ; preds = %march_next13
  %pay_slot = getelementptr inbounds nuw %Color, ptr %first, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %s_slot_base = ptrtoint ptr %payload to i64
  %s_slot_addr = add i64 %s_slot_base, 0
  %s_slot = inttoptr i64 %s_slot_addr to ptr
  %s = load i64, ptr %s_slot, align 8
  store i64 %s, ptr %s19, align 8
  %s20 = load i64, ptr %s19, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %s20)
  %widen21 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen22 = sext i32 %8 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next17:                                     ; preds = %march_next13
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 6)
  unreachable

match_end30:                                      ; preds = %march_arm40, %march_arm36, %march_arm32
  %9 = call i32 @avra_test_summary()
  %widen55 = sext i32 %9 to i64
  call void @avra_rc_collect()
  ret i64 0

march_arm32:                                      ; preds = %match_end
  %10 = call i32 @puts(ptr @.str.2)
  %widen35 = sext i32 %10 to i64
  store i64 0, ptr %match_stmt_discard31, align 8
  br label %match_end30

march_next33:                                     ; preds = %match_end
  %tag_eq38 = icmp eq i64 %tag29, 210675960374
  br i1 %tag_eq38, label %march_arm36, label %march_next37

march_arm36:                                      ; preds = %march_next33
  %11 = call i32 @puts(ptr @.str.3)
  %widen39 = sext i32 %11 to i64
  store i64 0, ptr %match_stmt_discard31, align 8
  br label %match_end30

march_next37:                                     ; preds = %march_next33
  %tag_eq42 = icmp eq i64 %tag29, 6383934317
  br i1 %tag_eq42, label %march_arm40, label %march_next41

march_arm40:                                      ; preds = %march_next37
  %pay_slot43 = getelementptr inbounds nuw %Color, ptr %second, i32 0, i32 1
  %payload44 = load ptr, ptr %pay_slot43, align 8
  %s_slot_base45 = ptrtoint ptr %payload44 to i64
  %s_slot_addr46 = add i64 %s_slot_base45, 0
  %s_slot47 = inttoptr i64 %s_slot_addr46 to ptr
  %s48 = load i64, ptr %s_slot47, align 8
  store i64 %s48, ptr %s49, align 8
  %s50 = load i64, ptr %s49, align 8
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.5, i64 %s50)
  %widen51 = sext i32 %13 to i64
  %14 = call i64 @strlen(ptr @.str.4)
  %15 = call i64 @strlen(ptr %12)
  %concat_total = add i64 %14, %15
  %concat_size = add i64 %concat_total, 1
  %16 = call ptr @avra_rc_alloc(i64 %concat_size)
  %17 = call ptr @memcpy(ptr %16, ptr @.str.4, i64 %14)
  %cast52 = ptrtoint ptr %16 to i64
  %dst2_int = add i64 %cast52, %14
  %cast53 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %15, 1
  %18 = call ptr @memcpy(ptr %cast53, ptr %12, i64 %rhs_len_p1)
  %19 = call i32 @puts(ptr %16)
  %widen54 = sext i32 %19 to i64
  store i64 0, ptr %match_stmt_discard31, align 8
  br label %match_end30

march_next41:                                     ; preds = %march_next37
  call void @avra_match_unreachable(ptr @.match_fn.6, i64 %tag29, ptr @mu_file.7, i64 13)
  unreachable
}
