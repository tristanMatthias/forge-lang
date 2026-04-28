; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Maybe = type { i64, ptr }
%Result = type { i64, ptr }
%Outer = type { i64, ptr }
%Inner = type { i64, ptr }
%Maybe__Some = type { ptr }
%Result__Err = type { ptr }
%Outer__Wrap = type { ptr }
%Inner__B = type { ptr }

@.str = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"err: \00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"nothing\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/nested_patterns.av\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"empty\00", align 1
@.match_fn.5 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.6 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/nested_patterns.av\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"empty\00", align 1
@.match_fn.10 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.11 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/nested_patterns.av\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"oops\00", align 1

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

define ptr @describe(ptr %0) {
entry:
  %msg31 = alloca ptr, align 8
  %v6 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %m = alloca ptr, align 8
  store ptr %0, ptr %m, align 8
  %m1 = load ptr, ptr %m, align 8
  %tag_ptr = getelementptr inbounds nuw %Maybe, ptr %m1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384548249
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm40, %inner_pass22, %inner_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast43 = inttoptr i64 %match_val to ptr
  ret ptr %cast43

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Maybe, ptr %m1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %inner_i64_slot_base = ptrtoint ptr %payload to i64
  %inner_i64_slot_addr = add i64 %inner_i64_slot_base, 0
  %inner_i64_slot = inttoptr i64 %inner_i64_slot_addr to ptr
  %inner_i64 = load ptr, ptr %inner_i64_slot, align 8
  %inner_tag_ptr = getelementptr inbounds nuw %Result, ptr %inner_i64, i32 0, i32 0
  %inner_tag = load i64, ptr %inner_tag_ptr, align 8
  %inner_tag_eq = icmp eq i64 %inner_tag, 5862623
  br i1 %inner_tag_eq, label %inner_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq12 = icmp eq i64 %tag, 6384548249
  br i1 %tag_eq12, label %march_arm10, label %march_next11

inner_pass:                                       ; preds = %march_arm
  %pay_slot2 = getelementptr inbounds nuw %Maybe, ptr %m1, i32 0, i32 1
  %payload3 = load ptr, ptr %pay_slot2, align 8
  %npat_val_slot_base = ptrtoint ptr %payload3 to i64
  %npat_val_slot_addr = add i64 %npat_val_slot_base, 0
  %npat_val_slot = inttoptr i64 %npat_val_slot_addr to ptr
  %npat_val = load ptr, ptr %npat_val_slot, align 8
  %pay_slot4 = getelementptr inbounds nuw %Result, ptr %npat_val, i32 0, i32 1
  %payload5 = load ptr, ptr %pay_slot4, align 8
  %v_slot_base = ptrtoint ptr %payload5 to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v6, align 8
  %v7 = load i64, ptr %v6, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %v7)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast8, ptr %1, i64 %rhs_len_p1)
  %cast9 = ptrtoint ptr %5 to i64
  store i64 %cast9, ptr %match_result, align 8
  br label %match_end

march_arm10:                                      ; preds = %march_next
  %pay_slot13 = getelementptr inbounds nuw %Maybe, ptr %m1, i32 0, i32 1
  %payload14 = load ptr, ptr %pay_slot13, align 8
  %inner_i64_slot_base15 = ptrtoint ptr %payload14 to i64
  %inner_i64_slot_addr16 = add i64 %inner_i64_slot_base15, 0
  %inner_i64_slot17 = inttoptr i64 %inner_i64_slot_addr16 to ptr
  %inner_i6418 = load ptr, ptr %inner_i64_slot17, align 8
  %inner_tag_ptr19 = getelementptr inbounds nuw %Result, ptr %inner_i6418, i32 0, i32 0
  %inner_tag20 = load i64, ptr %inner_tag_ptr19, align 8
  %inner_tag_eq21 = icmp eq i64 %inner_tag20, 193456014
  br i1 %inner_tag_eq21, label %inner_pass22, label %march_next11

march_next11:                                     ; preds = %march_arm10, %march_next
  %tag_eq42 = icmp eq i64 %tag, 6384368597
  br i1 %tag_eq42, label %march_arm40, label %march_next41

inner_pass22:                                     ; preds = %march_arm10
  %pay_slot23 = getelementptr inbounds nuw %Maybe, ptr %m1, i32 0, i32 1
  %payload24 = load ptr, ptr %pay_slot23, align 8
  %npat_val_slot_base25 = ptrtoint ptr %payload24 to i64
  %npat_val_slot_addr26 = add i64 %npat_val_slot_base25, 0
  %npat_val_slot27 = inttoptr i64 %npat_val_slot_addr26 to ptr
  %npat_val28 = load ptr, ptr %npat_val_slot27, align 8
  %pay_slot29 = getelementptr inbounds nuw %Result, ptr %npat_val28, i32 0, i32 1
  %payload30 = load ptr, ptr %pay_slot29, align 8
  %msg_slot_base = ptrtoint ptr %payload30 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 0
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @avra_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg31, align 8
  %msg32 = load ptr, ptr %msg31, align 8
  %8 = call i64 @strlen(ptr @.str.1)
  %9 = call i64 @strlen(ptr %msg32)
  %concat_total33 = add i64 %8, %9
  %concat_size34 = add i64 %concat_total33, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size34)
  %11 = call ptr @memcpy(ptr %10, ptr @.str.1, i64 %8)
  %cast35 = ptrtoint ptr %10 to i64
  %dst2_int36 = add i64 %cast35, %8
  %cast37 = inttoptr i64 %dst2_int36 to ptr
  %rhs_len_p138 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast37, ptr %msg32, i64 %rhs_len_p138)
  %cast39 = ptrtoint ptr %10 to i64
  store i64 %cast39, ptr %match_result, align 8
  br label %match_end

march_arm40:                                      ; preds = %march_next11
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next41:                                     ; preds = %march_next11
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 24)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %s111 = alloca ptr, align 8
  %n86 = alloca i64, align 8
  %match_stmt_discard64 = alloca i64, align 8
  %val2 = alloca ptr, align 8
  %msg39 = alloca ptr, align 8
  %x15 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %val = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %1, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Outer, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Inner, ptr %3, i32 0, i32 0
  store i64 177638, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Inner, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr2, align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast = ptrtoint ptr %3 to i64
  %slot_base3 = ptrtoint ptr %2 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  %cast6 = inttoptr i64 %cast to ptr
  store ptr %cast6, ptr %slot5, align 8
  %cast7 = ptrtoint ptr %1 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  store ptr %cast8, ptr %val, align 8
  %val9 = load ptr, ptr %val, align 8
  %tag_ptr10 = getelementptr inbounds nuw %Outer, ptr %val9, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr10, align 8
  %tag_eq = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm42, %inner_pass30, %inner_pass
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr46 = getelementptr inbounds nuw %Outer, ptr %5, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr46, align 8
  %pay_ptr47 = getelementptr inbounds nuw %Outer, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr47, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr48 = getelementptr inbounds nuw %Inner, ptr %7, i32 0, i32 0
  store i64 177639, ptr %tag_ptr48, align 8
  %pay_ptr49 = getelementptr inbounds nuw %Inner, ptr %7, i32 0, i32 1
  %8 = call ptr @avra_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr49, align 8
  %slot_base50 = ptrtoint ptr %8 to i64
  %slot_addr51 = add i64 %slot_base50, 0
  %slot52 = inttoptr i64 %slot_addr51 to ptr
  store ptr @.str.7, ptr %slot52, align 8
  %cast53 = ptrtoint ptr %7 to i64
  %slot_base54 = ptrtoint ptr %6 to i64
  %slot_addr55 = add i64 %slot_base54, 0
  %slot56 = inttoptr i64 %slot_addr55 to ptr
  %cast57 = inttoptr i64 %cast53 to ptr
  store ptr %cast57, ptr %slot56, align 8
  %cast58 = ptrtoint ptr %5 to i64
  %cast59 = inttoptr i64 %cast58 to ptr
  store ptr %cast59, ptr %val2, align 8
  %val260 = load ptr, ptr %val2, align 8
  %tag_ptr61 = getelementptr inbounds nuw %Outer, ptr %val260, i32 0, i32 0
  %tag62 = load i64, ptr %tag_ptr61, align 8
  %tag_eq67 = icmp eq i64 %tag62, 6384694879
  br i1 %tag_eq67, label %march_arm65, label %march_next66

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Outer, ptr %val9, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %inner_i64_slot_base = ptrtoint ptr %payload to i64
  %inner_i64_slot_addr = add i64 %inner_i64_slot_base, 0
  %inner_i64_slot = inttoptr i64 %inner_i64_slot_addr to ptr
  %inner_i64 = load ptr, ptr %inner_i64_slot, align 8
  %inner_tag_ptr = getelementptr inbounds nuw %Inner, ptr %inner_i64, i32 0, i32 0
  %inner_tag = load i64, ptr %inner_tag_ptr, align 8
  %inner_tag_eq = icmp eq i64 %inner_tag, 177638
  br i1 %inner_tag_eq, label %inner_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq20 = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq20, label %march_arm18, label %march_next19

inner_pass:                                       ; preds = %march_arm
  %pay_slot11 = getelementptr inbounds nuw %Outer, ptr %val9, i32 0, i32 1
  %payload12 = load ptr, ptr %pay_slot11, align 8
  %npat_val_slot_base = ptrtoint ptr %payload12 to i64
  %npat_val_slot_addr = add i64 %npat_val_slot_base, 0
  %npat_val_slot = inttoptr i64 %npat_val_slot_addr to ptr
  %npat_val = load ptr, ptr %npat_val_slot, align 8
  %pay_slot13 = getelementptr inbounds nuw %Inner, ptr %npat_val, i32 0, i32 1
  %payload14 = load ptr, ptr %pay_slot13, align 8
  %x_slot_base = ptrtoint ptr %payload14 to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x15, align 8
  %x16 = load i64, ptr %x15, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.3, i64 %x16)
  %widen = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen17 = sext i32 %11 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_arm18:                                      ; preds = %march_next
  %pay_slot21 = getelementptr inbounds nuw %Outer, ptr %val9, i32 0, i32 1
  %payload22 = load ptr, ptr %pay_slot21, align 8
  %inner_i64_slot_base23 = ptrtoint ptr %payload22 to i64
  %inner_i64_slot_addr24 = add i64 %inner_i64_slot_base23, 0
  %inner_i64_slot25 = inttoptr i64 %inner_i64_slot_addr24 to ptr
  %inner_i6426 = load ptr, ptr %inner_i64_slot25, align 8
  %inner_tag_ptr27 = getelementptr inbounds nuw %Inner, ptr %inner_i6426, i32 0, i32 0
  %inner_tag28 = load i64, ptr %inner_tag_ptr27, align 8
  %inner_tag_eq29 = icmp eq i64 %inner_tag28, 177639
  br i1 %inner_tag_eq29, label %inner_pass30, label %march_next19

march_next19:                                     ; preds = %march_arm18, %march_next
  %tag_eq44 = icmp eq i64 %tag, 210673421332
  br i1 %tag_eq44, label %march_arm42, label %march_next43

inner_pass30:                                     ; preds = %march_arm18
  %pay_slot31 = getelementptr inbounds nuw %Outer, ptr %val9, i32 0, i32 1
  %payload32 = load ptr, ptr %pay_slot31, align 8
  %npat_val_slot_base33 = ptrtoint ptr %payload32 to i64
  %npat_val_slot_addr34 = add i64 %npat_val_slot_base33, 0
  %npat_val_slot35 = inttoptr i64 %npat_val_slot_addr34 to ptr
  %npat_val36 = load ptr, ptr %npat_val_slot35, align 8
  %pay_slot37 = getelementptr inbounds nuw %Inner, ptr %npat_val36, i32 0, i32 1
  %payload38 = load ptr, ptr %pay_slot37, align 8
  %msg_slot_base = ptrtoint ptr %payload38 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 0
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @avra_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg39, align 8
  %msg40 = load ptr, ptr %msg39, align 8
  %12 = call i32 @puts(ptr %msg40)
  %widen41 = sext i32 %12 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_arm42:                                      ; preds = %march_next19
  %13 = call i32 @puts(ptr @.str.4)
  %widen45 = sext i32 %13 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next43:                                     ; preds = %march_next19
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 34)
  unreachable

match_end63:                                      ; preds = %march_arm114, %inner_pass102, %inner_pass77
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr118 = getelementptr inbounds nuw %Maybe, ptr %14, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr118, align 8
  %pay_ptr119 = getelementptr inbounds nuw %Maybe, ptr %14, i32 0, i32 1
  %15 = call ptr @avra_rc_alloc(i64 8)
  store ptr %15, ptr %pay_ptr119, align 8
  %16 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr120 = getelementptr inbounds nuw %Result, ptr %16, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr120, align 8
  %pay_ptr121 = getelementptr inbounds nuw %Result, ptr %16, i32 0, i32 1
  %17 = call ptr @avra_rc_alloc(i64 8)
  store ptr %17, ptr %pay_ptr121, align 8
  %slot_base122 = ptrtoint ptr %17 to i64
  %slot_addr123 = add i64 %slot_base122, 0
  %slot124 = inttoptr i64 %slot_addr123 to ptr
  store i64 99, ptr %slot124, align 8
  %cast125 = ptrtoint ptr %16 to i64
  %slot_base126 = ptrtoint ptr %15 to i64
  %slot_addr127 = add i64 %slot_base126, 0
  %slot128 = inttoptr i64 %slot_addr127 to ptr
  %cast129 = inttoptr i64 %cast125 to ptr
  store ptr %cast129, ptr %slot128, align 8
  %cast130 = ptrtoint ptr %14 to i64
  %cast131 = inttoptr i64 %cast130 to ptr
  %18 = call ptr @describe(ptr %cast131)
  %19 = call i32 @puts(ptr %18)
  %widen132 = sext i32 %19 to i64
  %20 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr133 = getelementptr inbounds nuw %Maybe, ptr %20, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr133, align 8
  %pay_ptr134 = getelementptr inbounds nuw %Maybe, ptr %20, i32 0, i32 1
  %21 = call ptr @avra_rc_alloc(i64 8)
  store ptr %21, ptr %pay_ptr134, align 8
  %22 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr135 = getelementptr inbounds nuw %Result, ptr %22, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr135, align 8
  %pay_ptr136 = getelementptr inbounds nuw %Result, ptr %22, i32 0, i32 1
  %23 = call ptr @avra_rc_alloc(i64 8)
  store ptr %23, ptr %pay_ptr136, align 8
  %slot_base137 = ptrtoint ptr %23 to i64
  %slot_addr138 = add i64 %slot_base137, 0
  %slot139 = inttoptr i64 %slot_addr138 to ptr
  store ptr @.str.12, ptr %slot139, align 8
  %cast140 = ptrtoint ptr %22 to i64
  %slot_base141 = ptrtoint ptr %21 to i64
  %slot_addr142 = add i64 %slot_base141, 0
  %slot143 = inttoptr i64 %slot_addr142 to ptr
  %cast144 = inttoptr i64 %cast140 to ptr
  store ptr %cast144, ptr %slot143, align 8
  %cast145 = ptrtoint ptr %20 to i64
  %cast146 = inttoptr i64 %cast145 to ptr
  %24 = call ptr @describe(ptr %cast146)
  %25 = call i32 @puts(ptr %24)
  %widen147 = sext i32 %25 to i64
  %26 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr148 = getelementptr inbounds nuw %Maybe, ptr %26, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr148, align 8
  %pay_ptr149 = getelementptr inbounds nuw %Maybe, ptr %26, i32 0, i32 1
  store ptr null, ptr %pay_ptr149, align 8
  %cast150 = ptrtoint ptr %26 to i64
  %cast151 = inttoptr i64 %cast150 to ptr
  %27 = call ptr @describe(ptr %cast151)
  %28 = call i32 @puts(ptr %27)
  %widen152 = sext i32 %28 to i64
  ret i64 0

march_arm65:                                      ; preds = %match_end
  %pay_slot68 = getelementptr inbounds nuw %Outer, ptr %val260, i32 0, i32 1
  %payload69 = load ptr, ptr %pay_slot68, align 8
  %inner_i64_slot_base70 = ptrtoint ptr %payload69 to i64
  %inner_i64_slot_addr71 = add i64 %inner_i64_slot_base70, 0
  %inner_i64_slot72 = inttoptr i64 %inner_i64_slot_addr71 to ptr
  %inner_i6473 = load ptr, ptr %inner_i64_slot72, align 8
  %inner_tag_ptr74 = getelementptr inbounds nuw %Inner, ptr %inner_i6473, i32 0, i32 0
  %inner_tag75 = load i64, ptr %inner_tag_ptr74, align 8
  %inner_tag_eq76 = icmp eq i64 %inner_tag75, 177638
  br i1 %inner_tag_eq76, label %inner_pass77, label %march_next66

march_next66:                                     ; preds = %march_arm65, %match_end
  %tag_eq92 = icmp eq i64 %tag62, 6384694879
  br i1 %tag_eq92, label %march_arm90, label %march_next91

inner_pass77:                                     ; preds = %march_arm65
  %pay_slot78 = getelementptr inbounds nuw %Outer, ptr %val260, i32 0, i32 1
  %payload79 = load ptr, ptr %pay_slot78, align 8
  %npat_val_slot_base80 = ptrtoint ptr %payload79 to i64
  %npat_val_slot_addr81 = add i64 %npat_val_slot_base80, 0
  %npat_val_slot82 = inttoptr i64 %npat_val_slot_addr81 to ptr
  %npat_val83 = load ptr, ptr %npat_val_slot82, align 8
  %pay_slot84 = getelementptr inbounds nuw %Inner, ptr %npat_val83, i32 0, i32 1
  %payload85 = load ptr, ptr %pay_slot84, align 8
  %n_slot_base = ptrtoint ptr %payload85 to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n86, align 8
  %n87 = load i64, ptr %n86, align 8
  %29 = call ptr @avra_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.8, i64 %n87)
  %widen88 = sext i32 %30 to i64
  %31 = call i32 @puts(ptr %29)
  %widen89 = sext i32 %31 to i64
  store i64 0, ptr %match_stmt_discard64, align 8
  br label %match_end63

march_arm90:                                      ; preds = %march_next66
  %pay_slot93 = getelementptr inbounds nuw %Outer, ptr %val260, i32 0, i32 1
  %payload94 = load ptr, ptr %pay_slot93, align 8
  %inner_i64_slot_base95 = ptrtoint ptr %payload94 to i64
  %inner_i64_slot_addr96 = add i64 %inner_i64_slot_base95, 0
  %inner_i64_slot97 = inttoptr i64 %inner_i64_slot_addr96 to ptr
  %inner_i6498 = load ptr, ptr %inner_i64_slot97, align 8
  %inner_tag_ptr99 = getelementptr inbounds nuw %Inner, ptr %inner_i6498, i32 0, i32 0
  %inner_tag100 = load i64, ptr %inner_tag_ptr99, align 8
  %inner_tag_eq101 = icmp eq i64 %inner_tag100, 177639
  br i1 %inner_tag_eq101, label %inner_pass102, label %march_next91

march_next91:                                     ; preds = %march_arm90, %march_next66
  %tag_eq116 = icmp eq i64 %tag62, 210673421332
  br i1 %tag_eq116, label %march_arm114, label %march_next115

inner_pass102:                                    ; preds = %march_arm90
  %pay_slot103 = getelementptr inbounds nuw %Outer, ptr %val260, i32 0, i32 1
  %payload104 = load ptr, ptr %pay_slot103, align 8
  %npat_val_slot_base105 = ptrtoint ptr %payload104 to i64
  %npat_val_slot_addr106 = add i64 %npat_val_slot_base105, 0
  %npat_val_slot107 = inttoptr i64 %npat_val_slot_addr106 to ptr
  %npat_val108 = load ptr, ptr %npat_val_slot107, align 8
  %pay_slot109 = getelementptr inbounds nuw %Inner, ptr %npat_val108, i32 0, i32 1
  %payload110 = load ptr, ptr %pay_slot109, align 8
  %s_slot_base = ptrtoint ptr %payload110 to i64
  %s_slot_addr = add i64 %s_slot_base, 0
  %s_slot = inttoptr i64 %s_slot_addr to ptr
  %s = load ptr, ptr %s_slot, align 8
  call void @avra_rc_retain(ptr %s)
  store ptr %s, ptr %s111, align 8
  %s112 = load ptr, ptr %s111, align 8
  %32 = call i32 @puts(ptr %s112)
  %widen113 = sext i32 %32 to i64
  store i64 0, ptr %match_stmt_discard64, align 8
  br label %match_end63

march_arm114:                                     ; preds = %march_next91
  %33 = call i32 @puts(ptr @.str.9)
  %widen117 = sext i32 %33 to i64
  store i64 0, ptr %match_stmt_discard64, align 8
  br label %match_end63

march_next115:                                    ; preds = %march_next91
  call void @avra_match_unreachable(ptr @.match_fn.10, i64 %tag62, ptr @mu_file.11, i64 42)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Maybe(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Maybe, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Maybe, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Some = icmp eq i64 %tag, 6384548249
  br i1 %is_Some, label %rel_Some, label %try_next_Some

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Some, %vrel_inner_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Some:                                         ; preds = %do_free
  %vrel_inner_ptr = getelementptr inbounds nuw %Maybe__Some, ptr %payload, i32 0, i32 0
  %vrel_inner = load ptr, ptr %vrel_inner_ptr, align 8
  %vrel_null_inner = icmp eq ptr %vrel_inner, null
  br i1 %vrel_null_inner, label %vrel_inner_skip, label %vrel_inner_do

try_next_Some:                                    ; preds = %do_free
  br label %fields_done

vrel_inner_skip:                                  ; preds = %vrel_inner_do, %rel_Some
  br label %fields_done

vrel_inner_do:                                    ; preds = %rel_Some
  %2 = call i64 @__release_Result(ptr %vrel_inner)
  br label %vrel_inner_skip
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
  %vrel_msg_ptr = getelementptr inbounds nuw %Result__Err, ptr %payload, i32 0, i32 0
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

define i64 @__release_Outer(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Wrap = icmp eq i64 %tag, 6384694879
  br i1 %is_Wrap, label %rel_Wrap, label %try_next_Wrap

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Wrap, %vrel_inner_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Wrap:                                         ; preds = %do_free
  %vrel_inner_ptr = getelementptr inbounds nuw %Outer__Wrap, ptr %payload, i32 0, i32 0
  %vrel_inner = load ptr, ptr %vrel_inner_ptr, align 8
  %vrel_null_inner = icmp eq ptr %vrel_inner, null
  br i1 %vrel_null_inner, label %vrel_inner_skip, label %vrel_inner_do

try_next_Wrap:                                    ; preds = %do_free
  br label %fields_done

vrel_inner_skip:                                  ; preds = %vrel_inner_do, %rel_Wrap
  br label %fields_done

vrel_inner_do:                                    ; preds = %rel_Wrap
  %2 = call i64 @__release_Inner(ptr %vrel_inner)
  br label %vrel_inner_skip
}

define i64 @__release_Inner(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Inner, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Inner, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_B = icmp eq i64 %tag, 177639
  br i1 %is_B, label %rel_B, label %try_next_B

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_B, %vrel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_B:                                            ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %Inner__B, ptr %payload, i32 0, i32 0
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_B:                                       ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_B
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_B
  call void @avra_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}
