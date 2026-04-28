; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Shape = type { i64, ptr }
%Option__int = type { i64, ptr }
%IntList = type { i64, ptr }
%Result__string__string = type { i64, ptr }
%Color = type { i64, ptr }
%IntList__Cons = type { i64, ptr }
%Result__string__string__Ok = type { ptr }
%Result__string__string__Err = type { ptr }

@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"area\00", align 1
@mu_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/adt_red_team.av\00", align 1
@.match_fn.1 = private unnamed_addr constant [9 x i8] c"sum_list\00", align 1
@mu_file.2 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/adt_red_team.av\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"oops\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c"circle area: \00", align 1
@.float_str.5 = private unnamed_addr constant [4 x i8] c"5.0\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"rect area: \00", align 1
@.float_str.7 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.8 = private unnamed_addr constant [4 x i8] c"4.0\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"apple\00", align 1
@.str.10 = private unnamed_addr constant [7 x i8] c"banana\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c"cherry\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c"banana\00", align 1
@.str.13 = private unnamed_addr constant [18 x i8] c"found: banana at \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@.match_fn.15 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.16 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/adt_red_team.av\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"apple\00", align 1
@.str.18 = private unnamed_addr constant [7 x i8] c"banana\00", align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"grape\00", align 1
@.str.20 = private unnamed_addr constant [17 x i8] c"found: grape at \00", align 1
@.i2s_fmt.21 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.22 = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@.match_fn.23 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.24 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/adt_red_team.av\00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"sum: \00", align 1
@.i2s_fmt.26 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.27 = private unnamed_addr constant [5 x i8] c"Ok: \00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"Err: \00", align 1
@.match_fn.29 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.30 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/adt_red_team.av\00", align 1
@.str.31 = private unnamed_addr constant [5 x i8] c"Ok: \00", align 1
@.str.32 = private unnamed_addr constant [6 x i8] c"Err: \00", align 1
@.match_fn.33 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.34 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/adt_red_team.av\00", align 1
@.str.35 = private unnamed_addr constant [14 x i8] c"narrowed: Red\00", align 1

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

define double @area(ptr %0) {
entry:
  %h15 = alloca double, align 8
  %w12 = alloca double, align 8
  %r2 = alloca double, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm7, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = bitcast i64 %match_val to double
  ret double %cast20

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load double, ptr %r_slot, align 8
  store double %r, ptr %r2, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %1 to double
  %r3 = load double, ptr %r2, align 8
  %fmul = fmul double %cast, %r3
  %r4 = load double, ptr %r2, align 8
  %fmul5 = fmul double %fmul, %r4
  %cast6 = bitcast double %fmul5 to i64
  store i64 %cast6, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq9 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq9, label %march_arm7, label %march_next8

march_arm7:                                       ; preds = %march_next
  %pay_slot10 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %w_slot_base = ptrtoint ptr %payload11 to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load double, ptr %w_slot, align 8
  store double %w, ptr %w12, align 8
  %pay_slot13 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload14 = load ptr, ptr %pay_slot13, align 8
  %h_slot_base = ptrtoint ptr %payload14 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load double, ptr %h_slot, align 8
  store double %h, ptr %h15, align 8
  %w16 = load double, ptr %w12, align 8
  %h17 = load double, ptr %h15, align 8
  %fmul18 = fmul double %w16, %h17
  %cast19 = bitcast double %fmul18 to i64
  store i64 %cast19, ptr %match_result, align 8
  br label %match_end

march_next8:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 17)
  unreachable
}

define ptr @find_index(ptr %0, ptr %1) {
entry:
  %sif_result = alloca i64, align 8
  %idx = alloca i64, align 8
  %target = alloca ptr, align 8
  %items = alloca ptr, align 8
  store ptr %0, ptr %items, align 8
  store ptr %1, ptr %target, align 8
  %items1 = load ptr, ptr %items, align 8
  %target2 = load ptr, ptr %target, align 8
  %cast = ptrtoint ptr %target2 to i64
  %2 = call i64 @avra_array_index_of(ptr %items1, i64 %cast)
  store i64 %2, ptr %idx, align 8
  %idx3 = load i64, ptr %idx, align 8
  %sge = icmp sge i64 %idx3, 0
  %sge_ext = zext i1 %sge to i64
  %sif_cond = icmp ne i64 %sge_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Option__int, ptr %3, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Option__int, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %idx4 = load i64, ptr %idx, align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %idx4, ptr %slot, align 8
  %cast5 = ptrtoint ptr %3 to i64
  store i64 %cast5, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %Option__int, ptr %5, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %Option__int, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr7, align 8
  %cast8 = ptrtoint ptr %5 to i64
  store i64 %cast8, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast9 = inttoptr i64 %sif_val to ptr
  ret ptr %cast9
}

define i64 @sum_list(ptr %0) {
entry:
  %t8 = alloca ptr, align 8
  %h5 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %l = alloca ptr, align 8
  store ptr %0, ptr %l, align 8
  %l1 = load ptr, ptr %l, align 8
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %l1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465512
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6383973304
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %IntList, ptr %l1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %h_slot_base = ptrtoint ptr %payload to i64
  %h_slot_addr = add i64 %h_slot_base, 0
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h5, align 8
  %pay_slot6 = getelementptr inbounds nuw %IntList, ptr %l1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %t_slot_base = ptrtoint ptr %payload7 to i64
  %t_slot_addr = add i64 %t_slot_base, 8
  %t_slot = inttoptr i64 %t_slot_addr to ptr
  %t = load ptr, ptr %t_slot, align 8
  call void @avra_rc_retain(ptr %t)
  store ptr %t, ptr %t8, align 8
  %h9 = load i64, ptr %h5, align 8
  %t10 = load ptr, ptr %t8, align 8
  %1 = call i64 @sum_list(ptr %t10)
  %add = add i64 %h9, %1
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.1, i64 %tag, ptr @mu_file.2, i64 35)
  unreachable
}

define ptr @maybe_hello(i1 %0) {
entry:
  %fail = alloca i1, align 1
  store i1 %0, ptr %fail, align 8
  %fail1 = load i1, ptr %fail, align 8
  br i1 %fail1, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr4, align 8
  %slot_base5 = ptrtoint ptr %2 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  store ptr @.str.3, ptr %slot7, align 8
  %cast8 = ptrtoint ptr %1 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %cast9, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast = ptrtoint ptr %3 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast10 = inttoptr i64 %cast8 to ptr
  ret ptr %cast10
}

define ptr @try_it(i1 %0) {
entry:
  %val = alloca ptr, align 8
  %fail = alloca i1, align 1
  store i1 %0, ptr %fail, align 8
  %fail1 = load i1, ptr %fail, align 8
  %1 = call ptr @maybe_hello(i1 %fail1)
  %try_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 0
  %try_tag = load i64, ptr %try_tag_ptr, align 8
  %try_is_ok = icmp eq i64 %try_tag, 5862623
  br i1 %try_is_ok, label %try_ok, label %try_err

try_ok:                                           ; preds = %entry
  %try_pay_slot = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 1
  %try_payload = load ptr, ptr %try_pay_slot, align 8
  %try_ok_val = load i64, ptr %try_payload, align 8
  %try_ok_ptr = inttoptr i64 %try_ok_val to ptr
  call void @avra_rc_retain(ptr %try_ok_ptr)
  %cast = inttoptr i64 %try_ok_val to ptr
  store ptr %cast, ptr %val, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %val2 = load ptr, ptr %val, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %val2, ptr %slot, align 8
  %cast3 = ptrtoint ptr %2 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %cast4, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

try_err:                                          ; preds = %entry
  ret ptr %1

errdefer_path:                                    ; preds = %try_ok
  br label %defer_done

defer_path:                                       ; preds = %try_ok
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast5 = inttoptr i64 %cast3 to ptr
  ret ptr %cast5
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %sif_result = alloca i64, align 8
  %c = alloca ptr, align 8
  %e195 = alloca ptr, align 8
  %v177 = alloca ptr, align 8
  %match_stmt_discard167 = alloca i64, align 8
  %e155 = alloca ptr, align 8
  %v141 = alloca ptr, align 8
  %match_stmt_discard135 = alloca i64, align 8
  %list = alloca ptr, align 8
  %idx55 = alloca i64, align 8
  %match_stmt_discard45 = alloca i64, align 8
  %idx28 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %3 = call i64 @avra_float_parse(ptr @.float_str.5)
  %cast = bitcast i64 %3 to double
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store double %cast, ptr %slot, align 8
  %cast1 = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast1 to ptr
  %4 = call double @area(ptr %cast2)
  %cast3 = bitcast double %4 to i64
  %5 = call i64 @avra_float_to_string(i64 %cast3)
  %rhs_ptr = inttoptr i64 %5 to ptr
  %6 = call i64 @strlen(ptr @.str.4)
  %7 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr @.str.4, i64 %6)
  %cast4 = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast4, %6
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast5, ptr %rhs_ptr, i64 %rhs_len_p1)
  %11 = call i32 @puts(ptr %8)
  %widen = sext i32 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %Shape, ptr %12, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %Shape, ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 16)
  store ptr %13, ptr %pay_ptr7, align 8
  %14 = call i64 @avra_float_parse(ptr @.float_str.7)
  %cast8 = bitcast i64 %14 to double
  %slot_base9 = ptrtoint ptr %13 to i64
  %slot_addr10 = add i64 %slot_base9, 0
  %slot11 = inttoptr i64 %slot_addr10 to ptr
  store double %cast8, ptr %slot11, align 8
  %15 = call i64 @avra_float_parse(ptr @.float_str.8)
  %cast12 = bitcast i64 %15 to double
  %slot_base13 = ptrtoint ptr %13 to i64
  %slot_addr14 = add i64 %slot_base13, 8
  %slot15 = inttoptr i64 %slot_addr14 to ptr
  store double %cast12, ptr %slot15, align 8
  %cast16 = ptrtoint ptr %12 to i64
  %cast17 = inttoptr i64 %cast16 to ptr
  %16 = call double @area(ptr %cast17)
  %cast18 = bitcast double %16 to i64
  %17 = call i64 @avra_float_to_string(i64 %cast18)
  %rhs_ptr19 = inttoptr i64 %17 to ptr
  %18 = call i64 @strlen(ptr @.str.6)
  %19 = call i64 @strlen(ptr %rhs_ptr19)
  %concat_total20 = add i64 %18, %19
  %concat_size21 = add i64 %concat_total20, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size21)
  %21 = call ptr @memcpy(ptr %20, ptr @.str.6, i64 %18)
  %cast22 = ptrtoint ptr %20 to i64
  %dst2_int23 = add i64 %cast22, %18
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast24, ptr %rhs_ptr19, i64 %rhs_len_p125)
  %23 = call i32 @puts(ptr %20)
  %widen26 = sext i32 %23 to i64
  %24 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %24, i64 ptrtoint (ptr @.str.9 to i64))
  call void @avra_array_push(ptr %24, i64 ptrtoint (ptr @.str.10 to i64))
  call void @avra_array_push(ptr %24, i64 ptrtoint (ptr @.str.11 to i64))
  %25 = call ptr @find_index(ptr %24, ptr @.str.12)
  %tag_ptr27 = getelementptr inbounds nuw %Option__int, ptr %25, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr27, align 8
  %tag_eq = icmp eq i64 %tag, 6384548249
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm38, %march_arm
  %26 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %26, i64 ptrtoint (ptr @.str.17 to i64))
  call void @avra_array_push(ptr %26, i64 ptrtoint (ptr @.str.18 to i64))
  %27 = call ptr @find_index(ptr %26, ptr @.str.19)
  %tag_ptr42 = getelementptr inbounds nuw %Option__int, ptr %27, i32 0, i32 0
  %tag43 = load i64, ptr %tag_ptr42, align 8
  %tag_eq48 = icmp eq i64 %tag43, 6384548249
  br i1 %tag_eq48, label %march_arm46, label %march_next47

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Option__int, ptr %25, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %idx_slot_base = ptrtoint ptr %payload to i64
  %idx_slot_addr = add i64 %idx_slot_base, 0
  %idx_slot = inttoptr i64 %idx_slot_addr to ptr
  %idx = load i64, ptr %idx_slot, align 8
  store i64 %idx, ptr %idx28, align 8
  %idx29 = load i64, ptr %idx28, align 8
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt, i64 %idx29)
  %widen30 = sext i32 %29 to i64
  %30 = call i64 @strlen(ptr @.str.13)
  %31 = call i64 @strlen(ptr %28)
  %concat_total31 = add i64 %30, %31
  %concat_size32 = add i64 %concat_total31, 1
  %32 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %33 = call ptr @memcpy(ptr %32, ptr @.str.13, i64 %30)
  %cast33 = ptrtoint ptr %32 to i64
  %dst2_int34 = add i64 %cast33, %30
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %31, 1
  %34 = call ptr @memcpy(ptr %cast35, ptr %28, i64 %rhs_len_p136)
  %35 = call i32 @puts(ptr %32)
  %widen37 = sext i32 %35 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq40 = icmp eq i64 %tag, 6384368597
  br i1 %tag_eq40, label %march_arm38, label %march_next39

march_arm38:                                      ; preds = %march_next
  %36 = call i32 @puts(ptr @.str.14)
  %widen41 = sext i32 %36 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next39:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.15, i64 %tag, ptr @mu_file.16, i64 63)
  unreachable

match_end44:                                      ; preds = %march_arm65, %march_arm46
  %37 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr69 = getelementptr inbounds nuw %IntList, ptr %37, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr69, align 8
  %pay_ptr70 = getelementptr inbounds nuw %IntList, ptr %37, i32 0, i32 1
  %38 = call ptr @avra_rc_alloc(i64 16)
  store ptr %38, ptr %pay_ptr70, align 8
  %slot_base71 = ptrtoint ptr %38 to i64
  %slot_addr72 = add i64 %slot_base71, 0
  %slot73 = inttoptr i64 %slot_addr72 to ptr
  store i64 1, ptr %slot73, align 8
  %39 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr74 = getelementptr inbounds nuw %IntList, ptr %39, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr74, align 8
  %pay_ptr75 = getelementptr inbounds nuw %IntList, ptr %39, i32 0, i32 1
  %40 = call ptr @avra_rc_alloc(i64 16)
  store ptr %40, ptr %pay_ptr75, align 8
  %slot_base76 = ptrtoint ptr %40 to i64
  %slot_addr77 = add i64 %slot_base76, 0
  %slot78 = inttoptr i64 %slot_addr77 to ptr
  store i64 2, ptr %slot78, align 8
  %41 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr79 = getelementptr inbounds nuw %IntList, ptr %41, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr79, align 8
  %pay_ptr80 = getelementptr inbounds nuw %IntList, ptr %41, i32 0, i32 1
  %42 = call ptr @avra_rc_alloc(i64 16)
  store ptr %42, ptr %pay_ptr80, align 8
  %slot_base81 = ptrtoint ptr %42 to i64
  %slot_addr82 = add i64 %slot_base81, 0
  %slot83 = inttoptr i64 %slot_addr82 to ptr
  store i64 3, ptr %slot83, align 8
  %43 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr84 = getelementptr inbounds nuw %IntList, ptr %43, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr84, align 8
  %pay_ptr85 = getelementptr inbounds nuw %IntList, ptr %43, i32 0, i32 1
  %44 = call ptr @avra_rc_alloc(i64 16)
  store ptr %44, ptr %pay_ptr85, align 8
  %slot_base86 = ptrtoint ptr %44 to i64
  %slot_addr87 = add i64 %slot_base86, 0
  %slot88 = inttoptr i64 %slot_addr87 to ptr
  store i64 4, ptr %slot88, align 8
  %45 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr89 = getelementptr inbounds nuw %IntList, ptr %45, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr89, align 8
  %pay_ptr90 = getelementptr inbounds nuw %IntList, ptr %45, i32 0, i32 1
  %46 = call ptr @avra_rc_alloc(i64 16)
  store ptr %46, ptr %pay_ptr90, align 8
  %slot_base91 = ptrtoint ptr %46 to i64
  %slot_addr92 = add i64 %slot_base91, 0
  %slot93 = inttoptr i64 %slot_addr92 to ptr
  store i64 5, ptr %slot93, align 8
  %47 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr94 = getelementptr inbounds nuw %IntList, ptr %47, i32 0, i32 0
  store i64 193465512, ptr %tag_ptr94, align 8
  %pay_ptr95 = getelementptr inbounds nuw %IntList, ptr %47, i32 0, i32 1
  store ptr null, ptr %pay_ptr95, align 8
  %cast96 = ptrtoint ptr %47 to i64
  %slot_base97 = ptrtoint ptr %46 to i64
  %slot_addr98 = add i64 %slot_base97, 8
  %slot99 = inttoptr i64 %slot_addr98 to ptr
  %cast100 = inttoptr i64 %cast96 to ptr
  store ptr %cast100, ptr %slot99, align 8
  %cast101 = ptrtoint ptr %45 to i64
  %slot_base102 = ptrtoint ptr %44 to i64
  %slot_addr103 = add i64 %slot_base102, 8
  %slot104 = inttoptr i64 %slot_addr103 to ptr
  %cast105 = inttoptr i64 %cast101 to ptr
  store ptr %cast105, ptr %slot104, align 8
  %cast106 = ptrtoint ptr %43 to i64
  %slot_base107 = ptrtoint ptr %42 to i64
  %slot_addr108 = add i64 %slot_base107, 8
  %slot109 = inttoptr i64 %slot_addr108 to ptr
  %cast110 = inttoptr i64 %cast106 to ptr
  store ptr %cast110, ptr %slot109, align 8
  %cast111 = ptrtoint ptr %41 to i64
  %slot_base112 = ptrtoint ptr %40 to i64
  %slot_addr113 = add i64 %slot_base112, 8
  %slot114 = inttoptr i64 %slot_addr113 to ptr
  %cast115 = inttoptr i64 %cast111 to ptr
  store ptr %cast115, ptr %slot114, align 8
  %cast116 = ptrtoint ptr %39 to i64
  %slot_base117 = ptrtoint ptr %38 to i64
  %slot_addr118 = add i64 %slot_base117, 8
  %slot119 = inttoptr i64 %slot_addr118 to ptr
  %cast120 = inttoptr i64 %cast116 to ptr
  store ptr %cast120, ptr %slot119, align 8
  %cast121 = ptrtoint ptr %37 to i64
  %cast122 = inttoptr i64 %cast121 to ptr
  store ptr %cast122, ptr %list, align 8
  %list123 = load ptr, ptr %list, align 8
  %48 = call i64 @sum_list(ptr %list123)
  %49 = call ptr @avra_rc_alloc(i64 32)
  %50 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %49, i64 32, ptr @.i2s_fmt.26, i64 %48)
  %widen124 = sext i32 %50 to i64
  %51 = call i64 @strlen(ptr @.str.25)
  %52 = call i64 @strlen(ptr %49)
  %concat_total125 = add i64 %51, %52
  %concat_size126 = add i64 %concat_total125, 1
  %53 = call ptr @avra_rc_alloc(i64 %concat_size126)
  %54 = call ptr @memcpy(ptr %53, ptr @.str.25, i64 %51)
  %cast127 = ptrtoint ptr %53 to i64
  %dst2_int128 = add i64 %cast127, %51
  %cast129 = inttoptr i64 %dst2_int128 to ptr
  %rhs_len_p1130 = add i64 %52, 1
  %55 = call ptr @memcpy(ptr %cast129, ptr %49, i64 %rhs_len_p1130)
  %56 = call i32 @puts(ptr %53)
  %widen131 = sext i32 %56 to i64
  %57 = call ptr @try_it(i1 false)
  %tag_ptr132 = getelementptr inbounds nuw %Result__string__string, ptr %57, i32 0, i32 0
  %tag133 = load i64, ptr %tag_ptr132, align 8
  %tag_eq138 = icmp eq i64 %tag133, 5862623
  br i1 %tag_eq138, label %march_arm136, label %march_next137

march_arm46:                                      ; preds = %match_end
  %pay_slot49 = getelementptr inbounds nuw %Option__int, ptr %27, i32 0, i32 1
  %payload50 = load ptr, ptr %pay_slot49, align 8
  %idx_slot_base51 = ptrtoint ptr %payload50 to i64
  %idx_slot_addr52 = add i64 %idx_slot_base51, 0
  %idx_slot53 = inttoptr i64 %idx_slot_addr52 to ptr
  %idx54 = load i64, ptr %idx_slot53, align 8
  store i64 %idx54, ptr %idx55, align 8
  %idx56 = load i64, ptr %idx55, align 8
  %58 = call ptr @avra_rc_alloc(i64 32)
  %59 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %58, i64 32, ptr @.i2s_fmt.21, i64 %idx56)
  %widen57 = sext i32 %59 to i64
  %60 = call i64 @strlen(ptr @.str.20)
  %61 = call i64 @strlen(ptr %58)
  %concat_total58 = add i64 %60, %61
  %concat_size59 = add i64 %concat_total58, 1
  %62 = call ptr @avra_rc_alloc(i64 %concat_size59)
  %63 = call ptr @memcpy(ptr %62, ptr @.str.20, i64 %60)
  %cast60 = ptrtoint ptr %62 to i64
  %dst2_int61 = add i64 %cast60, %60
  %cast62 = inttoptr i64 %dst2_int61 to ptr
  %rhs_len_p163 = add i64 %61, 1
  %64 = call ptr @memcpy(ptr %cast62, ptr %58, i64 %rhs_len_p163)
  %65 = call i32 @puts(ptr %62)
  %widen64 = sext i32 %65 to i64
  store i64 0, ptr %match_stmt_discard45, align 8
  br label %match_end44

march_next47:                                     ; preds = %match_end
  %tag_eq67 = icmp eq i64 %tag43, 6384368597
  br i1 %tag_eq67, label %march_arm65, label %march_next66

march_arm65:                                      ; preds = %march_next47
  %66 = call i32 @puts(ptr @.str.22)
  %widen68 = sext i32 %66 to i64
  store i64 0, ptr %match_stmt_discard45, align 8
  br label %match_end44

march_next66:                                     ; preds = %march_next47
  call void @avra_match_unreachable(ptr @.match_fn.23, i64 %tag43, ptr @mu_file.24, i64 67)
  unreachable

match_end134:                                     ; preds = %march_arm150, %march_arm136
  %67 = call ptr @try_it(i1 true)
  %tag_ptr164 = getelementptr inbounds nuw %Result__string__string, ptr %67, i32 0, i32 0
  %tag165 = load i64, ptr %tag_ptr164, align 8
  %tag_eq170 = icmp eq i64 %tag165, 5862623
  br i1 %tag_eq170, label %march_arm168, label %march_next169

march_arm136:                                     ; preds = %match_end44
  %pay_slot139 = getelementptr inbounds nuw %Result__string__string, ptr %57, i32 0, i32 1
  %payload140 = load ptr, ptr %pay_slot139, align 8
  %v_slot_base = ptrtoint ptr %payload140 to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @avra_rc_retain(ptr %v)
  store ptr %v, ptr %v141, align 8
  %v142 = load ptr, ptr %v141, align 8
  %68 = call i64 @strlen(ptr @.str.27)
  %69 = call i64 @strlen(ptr %v142)
  %concat_total143 = add i64 %68, %69
  %concat_size144 = add i64 %concat_total143, 1
  %70 = call ptr @avra_rc_alloc(i64 %concat_size144)
  %71 = call ptr @memcpy(ptr %70, ptr @.str.27, i64 %68)
  %cast145 = ptrtoint ptr %70 to i64
  %dst2_int146 = add i64 %cast145, %68
  %cast147 = inttoptr i64 %dst2_int146 to ptr
  %rhs_len_p1148 = add i64 %69, 1
  %72 = call ptr @memcpy(ptr %cast147, ptr %v142, i64 %rhs_len_p1148)
  %73 = call i32 @puts(ptr %70)
  %widen149 = sext i32 %73 to i64
  store i64 0, ptr %match_stmt_discard135, align 8
  br label %match_end134

march_next137:                                    ; preds = %match_end44
  %tag_eq152 = icmp eq i64 %tag133, 193456014
  br i1 %tag_eq152, label %march_arm150, label %march_next151

march_arm150:                                     ; preds = %march_next137
  %pay_slot153 = getelementptr inbounds nuw %Result__string__string, ptr %57, i32 0, i32 1
  %payload154 = load ptr, ptr %pay_slot153, align 8
  %e_slot_base = ptrtoint ptr %payload154 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e)
  store ptr %e, ptr %e155, align 8
  %e156 = load ptr, ptr %e155, align 8
  %74 = call i64 @strlen(ptr @.str.28)
  %75 = call i64 @strlen(ptr %e156)
  %concat_total157 = add i64 %74, %75
  %concat_size158 = add i64 %concat_total157, 1
  %76 = call ptr @avra_rc_alloc(i64 %concat_size158)
  %77 = call ptr @memcpy(ptr %76, ptr @.str.28, i64 %74)
  %cast159 = ptrtoint ptr %76 to i64
  %dst2_int160 = add i64 %cast159, %74
  %cast161 = inttoptr i64 %dst2_int160 to ptr
  %rhs_len_p1162 = add i64 %75, 1
  %78 = call ptr @memcpy(ptr %cast161, ptr %e156, i64 %rhs_len_p1162)
  %79 = call i32 @puts(ptr %76)
  %widen163 = sext i32 %79 to i64
  store i64 0, ptr %match_stmt_discard135, align 8
  br label %match_end134

march_next151:                                    ; preds = %march_next137
  call void @avra_match_unreachable(ptr @.match_fn.29, i64 %tag133, ptr @mu_file.30, i64 77)
  unreachable

match_end166:                                     ; preds = %march_arm186, %march_arm168
  %80 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr204 = getelementptr inbounds nuw %Color, ptr %80, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr204, align 8
  %pay_ptr205 = getelementptr inbounds nuw %Color, ptr %80, i32 0, i32 1
  store ptr null, ptr %pay_ptr205, align 8
  %cast206 = ptrtoint ptr %80 to i64
  %cast207 = inttoptr i64 %cast206 to ptr
  store ptr %cast207, ptr %c, align 8
  %c208 = load ptr, ptr %c, align 8
  %tag_ptr209 = getelementptr inbounds nuw %Color, ptr %c208, i32 0, i32 0
  %tag210 = load i64, ptr %tag_ptr209, align 8
  %is_eq = icmp eq i64 %tag210, 193469728
  %is_eq_ext = zext i1 %is_eq to i64
  %sif_cond = icmp ne i64 %is_eq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_arm168:                                     ; preds = %match_end134
  %pay_slot171 = getelementptr inbounds nuw %Result__string__string, ptr %67, i32 0, i32 1
  %payload172 = load ptr, ptr %pay_slot171, align 8
  %v_slot_base173 = ptrtoint ptr %payload172 to i64
  %v_slot_addr174 = add i64 %v_slot_base173, 0
  %v_slot175 = inttoptr i64 %v_slot_addr174 to ptr
  %v176 = load ptr, ptr %v_slot175, align 8
  call void @avra_rc_retain(ptr %v176)
  store ptr %v176, ptr %v177, align 8
  %v178 = load ptr, ptr %v177, align 8
  %81 = call i64 @strlen(ptr @.str.31)
  %82 = call i64 @strlen(ptr %v178)
  %concat_total179 = add i64 %81, %82
  %concat_size180 = add i64 %concat_total179, 1
  %83 = call ptr @avra_rc_alloc(i64 %concat_size180)
  %84 = call ptr @memcpy(ptr %83, ptr @.str.31, i64 %81)
  %cast181 = ptrtoint ptr %83 to i64
  %dst2_int182 = add i64 %cast181, %81
  %cast183 = inttoptr i64 %dst2_int182 to ptr
  %rhs_len_p1184 = add i64 %82, 1
  %85 = call ptr @memcpy(ptr %cast183, ptr %v178, i64 %rhs_len_p1184)
  %86 = call i32 @puts(ptr %83)
  %widen185 = sext i32 %86 to i64
  store i64 0, ptr %match_stmt_discard167, align 8
  br label %match_end166

march_next169:                                    ; preds = %match_end134
  %tag_eq188 = icmp eq i64 %tag165, 193456014
  br i1 %tag_eq188, label %march_arm186, label %march_next187

march_arm186:                                     ; preds = %march_next169
  %pay_slot189 = getelementptr inbounds nuw %Result__string__string, ptr %67, i32 0, i32 1
  %payload190 = load ptr, ptr %pay_slot189, align 8
  %e_slot_base191 = ptrtoint ptr %payload190 to i64
  %e_slot_addr192 = add i64 %e_slot_base191, 0
  %e_slot193 = inttoptr i64 %e_slot_addr192 to ptr
  %e194 = load ptr, ptr %e_slot193, align 8
  call void @avra_rc_retain(ptr %e194)
  store ptr %e194, ptr %e195, align 8
  %e196 = load ptr, ptr %e195, align 8
  %87 = call i64 @strlen(ptr @.str.32)
  %88 = call i64 @strlen(ptr %e196)
  %concat_total197 = add i64 %87, %88
  %concat_size198 = add i64 %concat_total197, 1
  %89 = call ptr @avra_rc_alloc(i64 %concat_size198)
  %90 = call ptr @memcpy(ptr %89, ptr @.str.32, i64 %87)
  %cast199 = ptrtoint ptr %89 to i64
  %dst2_int200 = add i64 %cast199, %87
  %cast201 = inttoptr i64 %dst2_int200 to ptr
  %rhs_len_p1202 = add i64 %88, 1
  %91 = call ptr @memcpy(ptr %cast201, ptr %e196, i64 %rhs_len_p1202)
  %92 = call i32 @puts(ptr %89)
  %widen203 = sext i32 %92 to i64
  store i64 0, ptr %match_stmt_discard167, align 8
  br label %match_end166

march_next187:                                    ; preds = %march_next169
  call void @avra_match_unreachable(ptr @.match_fn.33, i64 %tag165, ptr @mu_file.34, i64 81)
  unreachable

sif_then:                                         ; preds = %match_end166
  %93 = call i32 @puts(ptr @.str.35)
  %widen211 = sext i32 %93 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %match_end166
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

define i64 @__release_IntList(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Cons = icmp eq i64 %tag, 6383973304
  br i1 %is_Cons, label %rel_Cons, label %try_next_Cons

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Cons, %vrel_tail_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Cons:                                         ; preds = %do_free
  %vrel_tail_ptr = getelementptr inbounds nuw %IntList__Cons, ptr %payload, i32 0, i32 1
  %vrel_tail = load ptr, ptr %vrel_tail_ptr, align 8
  %vrel_null_tail = icmp eq ptr %vrel_tail, null
  br i1 %vrel_null_tail, label %vrel_tail_skip, label %vrel_tail_do

try_next_Cons:                                    ; preds = %do_free
  br label %fields_done

vrel_tail_skip:                                   ; preds = %vrel_tail_do, %rel_Cons
  br label %fields_done

vrel_tail_do:                                     ; preds = %rel_Cons
  %2 = call i64 @__release_IntList(ptr %vrel_tail)
  br label %vrel_tail_skip
}

define i64 @__release_Result__string__string(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Ok = icmp eq i64 %tag, 5862623
  br i1 %is_Ok, label %rel_Ok, label %try_next_Ok

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_error_skip, %vrel_value_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Ok:                                           ; preds = %do_free
  %vrel_value_ptr = getelementptr inbounds nuw %Result__string__string__Ok, ptr %payload, i32 0, i32 0
  %vrel_value = load ptr, ptr %vrel_value_ptr, align 8
  %vrel_null_value = icmp eq ptr %vrel_value, null
  br i1 %vrel_null_value, label %vrel_value_skip, label %vrel_value_do

try_next_Ok:                                      ; preds = %do_free
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

vrel_value_skip:                                  ; preds = %vrel_value_do, %rel_Ok
  br label %fields_done

vrel_value_do:                                    ; preds = %rel_Ok
  call void @avra_rc_release(ptr %vrel_value)
  br label %vrel_value_skip

rel_Err:                                          ; preds = %try_next_Ok
  %vrel_error_ptr = getelementptr inbounds nuw %Result__string__string__Err, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_Err:                                     ; preds = %try_next_Ok
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_Err
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_Err
  call void @avra_rc_release(ptr %vrel_error)
  br label %vrel_error_skip
}
