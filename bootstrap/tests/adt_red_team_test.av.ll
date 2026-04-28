; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%ArtShape = type { i64, ptr }
%ArtOption = type { i64, ptr }
%ArtIntList = type { i64, ptr }
%ArtResult = type { i64, ptr }
%ArtColor = type { i64, ptr }
%ArtResult__ArtOk = type { ptr }
%ArtResult__ArtErr = type { ptr }
%ArtIntList__ArtCons = type { i64, ptr }

@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"art_area\00", align 1
@mu_file = private unnamed_addr constant [27 x i8] c"tests/adt_red_team_test.fg\00", align 1
@.match_fn.1 = private unnamed_addr constant [13 x i8] c"art_sum_list\00", align 1
@mu_file.2 = private unnamed_addr constant [27 x i8] c"tests/adt_red_team_test.fg\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"oops\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.match_fn.4 = private unnamed_addr constant [11 x i8] c"art_try_it\00", align 1
@mu_file.5 = private unnamed_addr constant [27 x i8] c"tests/adt_red_team_test.fg\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"Ok: \00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"Err: \00", align 1
@.match_fn.8 = private unnamed_addr constant [19 x i8] c"art_describe_match\00", align 1
@mu_file.9 = private unnamed_addr constant [27 x i8] c"tests/adt_red_team_test.fg\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"found at \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@.match_fn.12 = private unnamed_addr constant [15 x i8] c"art_find_match\00", align 1
@mu_file.13 = private unnamed_addr constant [27 x i8] c"tests/adt_red_team_test.fg\00", align 1
@spec_str = private unnamed_addr constant [15 x i8] c"\22adt red team\22\00", align 1
@.float_str.14 = private unnamed_addr constant [4 x i8] c"5.0\00", align 1
@.float_str.15 = private unnamed_addr constant [5 x i8] c"78.5\00", align 1
@spec_str.16 = private unnamed_addr constant [14 x i8] c"\22circle area\22\00", align 1
@.float_str.17 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.18 = private unnamed_addr constant [4 x i8] c"4.0\00", align 1
@.float_str.19 = private unnamed_addr constant [5 x i8] c"12.0\00", align 1
@spec_str.20 = private unnamed_addr constant [12 x i8] c"\22rect area\22\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"apple\00", align 1
@.str.22 = private unnamed_addr constant [7 x i8] c"banana\00", align 1
@.str.23 = private unnamed_addr constant [7 x i8] c"cherry\00", align 1
@.str.24 = private unnamed_addr constant [7 x i8] c"banana\00", align 1
@.str.25 = private unnamed_addr constant [11 x i8] c"found at 1\00", align 1
@spec_str.26 = private unnamed_addr constant [19 x i8] c"\22find index found\22\00", align 1
@.str.27 = private unnamed_addr constant [6 x i8] c"apple\00", align 1
@.str.28 = private unnamed_addr constant [7 x i8] c"banana\00", align 1
@.str.29 = private unnamed_addr constant [6 x i8] c"grape\00", align 1
@.str.30 = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@spec_str.31 = private unnamed_addr constant [23 x i8] c"\22find index not found\22\00", align 1
@spec_str.32 = private unnamed_addr constant [21 x i8] c"\22recursive enum sum\22\00", align 1
@.str.33 = private unnamed_addr constant [10 x i8] c"Ok: hello\00", align 1
@spec_str.34 = private unnamed_addr constant [12 x i8] c"\22result ok\22\00", align 1
@.str.35 = private unnamed_addr constant [10 x i8] c"Err: oops\00", align 1
@spec_str.36 = private unnamed_addr constant [13 x i8] c"\22result err\22\00", align 1
@spec_str.37 = private unnamed_addr constant [14 x i8] c"\22is operator\22\00", align 1

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare void @forge_test_flush()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

define double @art_area(ptr %0) {
entry:
  %h15 = alloca double, align 8
  %w12 = alloca double, align 8
  %r2 = alloca double, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %ArtShape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm7, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = bitcast i64 %match_val to double
  ret double %cast20

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %ArtShape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load double, ptr %r_slot, align 8
  store double %r, ptr %r2, align 8
  %1 = call i64 @forge_float_parse(ptr @.float_str)
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
  %pay_slot10 = getelementptr inbounds nuw %ArtShape, ptr %s1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %w_slot_base = ptrtoint ptr %payload11 to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load double, ptr %w_slot, align 8
  store double %w, ptr %w12, align 8
  %pay_slot13 = getelementptr inbounds nuw %ArtShape, ptr %s1, i32 0, i32 1
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
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define ptr @art_find_index(ptr %0, ptr %1) {
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
  %2 = call i64 @forge_array_index_of(ptr %items1, i64 %cast)
  store i64 %2, ptr %idx, align 8
  %idx3 = load i64, ptr %idx, align 8
  %sge = icmp sge i64 %idx3, 0
  %sge_ext = zext i1 %sge to i64
  %sif_cond = icmp ne i64 %sge_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %3 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %ArtOption, ptr %3, i32 0, i32 0
  store i64 229418389186208, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ArtOption, ptr %3, i32 0, i32 1
  %4 = call ptr @forge_rc_alloc(i64 8)
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
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %ArtOption, ptr %5, i32 0, i32 0
  store i64 229418389006556, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %ArtOption, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr7, align 8
  %cast8 = ptrtoint ptr %5 to i64
  store i64 %cast8, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast9 = inttoptr i64 %sif_val to ptr
  ret ptr %cast9
}

define i64 @art_sum_list(ptr %0) {
entry:
  %t8 = alloca ptr, align 8
  %h5 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %l = alloca ptr, align 8
  store ptr %0, ptr %l, align 8
  %l1 = load ptr, ptr %l, align 8
  %tag_ptr = getelementptr inbounds nuw %ArtIntList, ptr %l1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952072393935
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 229418388611263
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %ArtIntList, ptr %l1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %h_slot_base = ptrtoint ptr %payload to i64
  %h_slot_addr = add i64 %h_slot_base, 0
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h5, align 8
  %pay_slot6 = getelementptr inbounds nuw %ArtIntList, ptr %l1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %t_slot_base = ptrtoint ptr %payload7 to i64
  %t_slot_addr = add i64 %t_slot_base, 8
  %t_slot = inttoptr i64 %t_slot_addr to ptr
  %t = load ptr, ptr %t_slot, align 8
  call void @forge_rc_retain(ptr %t)
  store ptr %t, ptr %t8, align 8
  %h9 = load i64, ptr %h5, align 8
  %t10 = load ptr, ptr %t8, align 8
  %1 = call i64 @art_sum_list(ptr %t10)
  %add = add i64 %h9, %1
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.1, i64 %tag, ptr @mu_file.2, i64 25)
  unreachable
}

define ptr @art_maybe_hello(i1 %0) {
entry:
  %fail = alloca i1, align 1
  store i1 %0, ptr %fail, align 8
  %fail1 = load i1, ptr %fail, align 8
  br i1 %fail1, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %1 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %ArtResult, ptr %1, i32 0, i32 0
  store i64 210668860454, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %ArtResult, ptr %1, i32 0, i32 1
  %2 = call ptr @forge_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr4, align 8
  %slot_base5 = ptrtoint ptr %2 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  store ptr @.str.3, ptr %slot7, align 8
  %cast8 = ptrtoint ptr %1 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  ret ptr %cast9

if_then:                                          ; preds = %entry
  %3 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %ArtResult, ptr %3, i32 0, i32 0
  store i64 6952072384437, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ArtResult, ptr %3, i32 0, i32 1
  %4 = call ptr @forge_rc_alloc(i64 8)
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
}

define ptr @art_try_it(i1 %0) {
entry:
  %e11 = alloca ptr, align 8
  %v3 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  %fail = alloca i1, align 1
  store i1 %0, ptr %fail, align 8
  %fail1 = load i1, ptr %fail, align 8
  %1 = call ptr @art_maybe_hello(i1 %fail1)
  store ptr %1, ptr %r, align 8
  %r2 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %ArtResult, ptr %r2, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210668860454
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast19 = inttoptr i64 %match_val to ptr
  ret ptr %cast19

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %ArtResult, ptr %r2, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @forge_rc_retain(ptr %v)
  store ptr %v, ptr %v3, align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %ArtResult, ptr %2, i32 0, i32 0
  store i64 210668860454, ptr %tag_ptr4, align 8
  %pay_ptr = getelementptr inbounds nuw %ArtResult, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %v5 = load ptr, ptr %v3, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %v5, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6952072384437
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %ArtResult, ptr %r2, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %e_slot_base = ptrtoint ptr %payload10 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @forge_rc_retain(ptr %e)
  store ptr %e, ptr %e11, align 8
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr12 = getelementptr inbounds nuw %ArtResult, ptr %4, i32 0, i32 0
  store i64 6952072384437, ptr %tag_ptr12, align 8
  %pay_ptr13 = getelementptr inbounds nuw %ArtResult, ptr %4, i32 0, i32 1
  %5 = call ptr @forge_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr13, align 8
  %e14 = load ptr, ptr %e11, align 8
  %slot_base15 = ptrtoint ptr %5 to i64
  %slot_addr16 = add i64 %slot_base15, 0
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  store ptr %e14, ptr %slot17, align 8
  %cast18 = ptrtoint ptr %4 to i64
  store i64 %cast18, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.4, i64 %tag, ptr @mu_file.5, i64 40)
  unreachable
}

define ptr @art_describe_match(ptr %0) {
entry:
  %e11 = alloca ptr, align 8
  %v2 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %ArtResult, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210668860454
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = inttoptr i64 %match_val to ptr
  ret ptr %cast20

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %ArtResult, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @forge_rc_retain(ptr %v)
  store ptr %v, ptr %v2, align 8
  %v3 = load ptr, ptr %v2, align 8
  %1 = call i64 @strlen(ptr @.str.6)
  %2 = call i64 @strlen(ptr %v3)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @forge_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.6, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast4, ptr %v3, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %3 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6952072384437
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %ArtResult, ptr %r1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %e_slot_base = ptrtoint ptr %payload10 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @forge_rc_retain(ptr %e)
  store ptr %e, ptr %e11, align 8
  %e12 = load ptr, ptr %e11, align 8
  %6 = call i64 @strlen(ptr @.str.7)
  %7 = call i64 @strlen(ptr %e12)
  %concat_total13 = add i64 %6, %7
  %concat_size14 = add i64 %concat_total13, 1
  %8 = call ptr @forge_rc_alloc(i64 %concat_size14)
  %9 = call ptr @memcpy(ptr %8, ptr @.str.7, i64 %6)
  %cast15 = ptrtoint ptr %8 to i64
  %dst2_int16 = add i64 %cast15, %6
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast17, ptr %e12, i64 %rhs_len_p118)
  %cast19 = ptrtoint ptr %8 to i64
  store i64 %cast19, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.8, i64 %tag, ptr @mu_file.9, i64 49)
  unreachable
}

define ptr @art_find_match(ptr %0) {
entry:
  %idx2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %opt = alloca ptr, align 8
  store ptr %0, ptr %opt, align 8
  %opt1 = load ptr, ptr %opt, align 8
  %tag_ptr = getelementptr inbounds nuw %ArtOption, ptr %opt1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 229418389186208
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast9 = inttoptr i64 %match_val to ptr
  ret ptr %cast9

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %ArtOption, ptr %opt1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %idx_slot_base = ptrtoint ptr %payload to i64
  %idx_slot_addr = add i64 %idx_slot_base, 0
  %idx_slot = inttoptr i64 %idx_slot_addr to ptr
  %idx = load i64, ptr %idx_slot, align 8
  store i64 %idx, ptr %idx2, align 8
  %idx3 = load i64, ptr %idx2, align 8
  %1 = call ptr @forge_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %idx3)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.10)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @forge_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.10, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast4, ptr %1, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %5 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 229418389006556
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.12, i64 %tag, ptr @mu_file.13, i64 56)
  unreachable
}

define i64 @main() {
entry:
  %c = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %ArtShape, ptr %1, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ArtShape, ptr %1, i32 0, i32 1
  %2 = call ptr @forge_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %3 = call i64 @forge_float_parse(ptr @.float_str.14)
  %cast = bitcast i64 %3 to double
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store double %cast, ptr %slot, align 8
  %cast1 = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast1 to ptr
  %4 = call double @art_area(ptr %cast2)
  %5 = call i64 @forge_float_parse(ptr @.float_str.15)
  %cast3 = bitcast i64 %5 to double
  %feq = fcmp oeq double %4, %cast3
  %feq_ext = zext i1 %feq to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.16, i64 %feq_ext)
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %ArtShape, ptr %7, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr4, align 8
  %pay_ptr5 = getelementptr inbounds nuw %ArtShape, ptr %7, i32 0, i32 1
  %8 = call ptr @forge_rc_alloc(i64 16)
  store ptr %8, ptr %pay_ptr5, align 8
  %9 = call i64 @forge_float_parse(ptr @.float_str.17)
  %cast6 = bitcast i64 %9 to double
  %slot_base7 = ptrtoint ptr %8 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store double %cast6, ptr %slot9, align 8
  %10 = call i64 @forge_float_parse(ptr @.float_str.18)
  %cast10 = bitcast i64 %10 to double
  %slot_base11 = ptrtoint ptr %8 to i64
  %slot_addr12 = add i64 %slot_base11, 8
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store double %cast10, ptr %slot13, align 8
  %cast14 = ptrtoint ptr %7 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  %11 = call double @art_area(ptr %cast15)
  %12 = call i64 @forge_float_parse(ptr @.float_str.19)
  %cast16 = bitcast i64 %12 to double
  %feq17 = fcmp oeq double %11, %cast16
  %feq_ext18 = zext i1 %feq17 to i64
  %13 = call i64 @forge_test_run_then(ptr @spec_str.20, i64 %feq_ext18)
  %14 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %14, i64 ptrtoint (ptr @.str.21 to i64))
  call void @forge_array_push(ptr %14, i64 ptrtoint (ptr @.str.22 to i64))
  call void @forge_array_push(ptr %14, i64 ptrtoint (ptr @.str.23 to i64))
  %15 = call ptr @art_find_index(ptr %14, ptr @.str.24)
  %16 = call ptr @art_find_match(ptr %15)
  %17 = call i32 @strcmp(ptr %16, ptr @.str.25)
  %widen19 = sext i32 %17 to i64
  %streq_cmp = icmp eq i64 %widen19, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %18 = call i64 @forge_test_run_then(ptr @spec_str.26, i64 %streq_ext)
  %19 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %19, i64 ptrtoint (ptr @.str.27 to i64))
  call void @forge_array_push(ptr %19, i64 ptrtoint (ptr @.str.28 to i64))
  %20 = call ptr @art_find_index(ptr %19, ptr @.str.29)
  %21 = call ptr @art_find_match(ptr %20)
  %22 = call i32 @strcmp(ptr %21, ptr @.str.30)
  %widen20 = sext i32 %22 to i64
  %streq_cmp21 = icmp eq i64 %widen20, 0
  %streq_ext22 = zext i1 %streq_cmp21 to i64
  %23 = call i64 @forge_test_run_then(ptr @spec_str.31, i64 %streq_ext22)
  %24 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr23 = getelementptr inbounds nuw %ArtIntList, ptr %24, i32 0, i32 0
  store i64 229418388611263, ptr %tag_ptr23, align 8
  %pay_ptr24 = getelementptr inbounds nuw %ArtIntList, ptr %24, i32 0, i32 1
  %25 = call ptr @forge_rc_alloc(i64 16)
  store ptr %25, ptr %pay_ptr24, align 8
  %slot_base25 = ptrtoint ptr %25 to i64
  %slot_addr26 = add i64 %slot_base25, 0
  %slot27 = inttoptr i64 %slot_addr26 to ptr
  store i64 1, ptr %slot27, align 8
  %26 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr28 = getelementptr inbounds nuw %ArtIntList, ptr %26, i32 0, i32 0
  store i64 229418388611263, ptr %tag_ptr28, align 8
  %pay_ptr29 = getelementptr inbounds nuw %ArtIntList, ptr %26, i32 0, i32 1
  %27 = call ptr @forge_rc_alloc(i64 16)
  store ptr %27, ptr %pay_ptr29, align 8
  %slot_base30 = ptrtoint ptr %27 to i64
  %slot_addr31 = add i64 %slot_base30, 0
  %slot32 = inttoptr i64 %slot_addr31 to ptr
  store i64 2, ptr %slot32, align 8
  %28 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr33 = getelementptr inbounds nuw %ArtIntList, ptr %28, i32 0, i32 0
  store i64 229418388611263, ptr %tag_ptr33, align 8
  %pay_ptr34 = getelementptr inbounds nuw %ArtIntList, ptr %28, i32 0, i32 1
  %29 = call ptr @forge_rc_alloc(i64 16)
  store ptr %29, ptr %pay_ptr34, align 8
  %slot_base35 = ptrtoint ptr %29 to i64
  %slot_addr36 = add i64 %slot_base35, 0
  %slot37 = inttoptr i64 %slot_addr36 to ptr
  store i64 3, ptr %slot37, align 8
  %30 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %ArtIntList, ptr %30, i32 0, i32 0
  store i64 229418388611263, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %ArtIntList, ptr %30, i32 0, i32 1
  %31 = call ptr @forge_rc_alloc(i64 16)
  store ptr %31, ptr %pay_ptr39, align 8
  %slot_base40 = ptrtoint ptr %31 to i64
  %slot_addr41 = add i64 %slot_base40, 0
  %slot42 = inttoptr i64 %slot_addr41 to ptr
  store i64 4, ptr %slot42, align 8
  %32 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr43 = getelementptr inbounds nuw %ArtIntList, ptr %32, i32 0, i32 0
  store i64 229418388611263, ptr %tag_ptr43, align 8
  %pay_ptr44 = getelementptr inbounds nuw %ArtIntList, ptr %32, i32 0, i32 1
  %33 = call ptr @forge_rc_alloc(i64 16)
  store ptr %33, ptr %pay_ptr44, align 8
  %slot_base45 = ptrtoint ptr %33 to i64
  %slot_addr46 = add i64 %slot_base45, 0
  %slot47 = inttoptr i64 %slot_addr46 to ptr
  store i64 5, ptr %slot47, align 8
  %34 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr48 = getelementptr inbounds nuw %ArtIntList, ptr %34, i32 0, i32 0
  store i64 6952072393935, ptr %tag_ptr48, align 8
  %pay_ptr49 = getelementptr inbounds nuw %ArtIntList, ptr %34, i32 0, i32 1
  store ptr null, ptr %pay_ptr49, align 8
  %cast50 = ptrtoint ptr %34 to i64
  %slot_base51 = ptrtoint ptr %33 to i64
  %slot_addr52 = add i64 %slot_base51, 8
  %slot53 = inttoptr i64 %slot_addr52 to ptr
  %cast54 = inttoptr i64 %cast50 to ptr
  store ptr %cast54, ptr %slot53, align 8
  %cast55 = ptrtoint ptr %32 to i64
  %slot_base56 = ptrtoint ptr %31 to i64
  %slot_addr57 = add i64 %slot_base56, 8
  %slot58 = inttoptr i64 %slot_addr57 to ptr
  %cast59 = inttoptr i64 %cast55 to ptr
  store ptr %cast59, ptr %slot58, align 8
  %cast60 = ptrtoint ptr %30 to i64
  %slot_base61 = ptrtoint ptr %29 to i64
  %slot_addr62 = add i64 %slot_base61, 8
  %slot63 = inttoptr i64 %slot_addr62 to ptr
  %cast64 = inttoptr i64 %cast60 to ptr
  store ptr %cast64, ptr %slot63, align 8
  %cast65 = ptrtoint ptr %28 to i64
  %slot_base66 = ptrtoint ptr %27 to i64
  %slot_addr67 = add i64 %slot_base66, 8
  %slot68 = inttoptr i64 %slot_addr67 to ptr
  %cast69 = inttoptr i64 %cast65 to ptr
  store ptr %cast69, ptr %slot68, align 8
  %cast70 = ptrtoint ptr %26 to i64
  %slot_base71 = ptrtoint ptr %25 to i64
  %slot_addr72 = add i64 %slot_base71, 8
  %slot73 = inttoptr i64 %slot_addr72 to ptr
  %cast74 = inttoptr i64 %cast70 to ptr
  store ptr %cast74, ptr %slot73, align 8
  %cast75 = ptrtoint ptr %24 to i64
  %cast76 = inttoptr i64 %cast75 to ptr
  %35 = call i64 @art_sum_list(ptr %cast76)
  %eq = icmp eq i64 %35, 15
  %eq_ext = zext i1 %eq to i64
  %36 = call i64 @forge_test_run_then(ptr @spec_str.32, i64 %eq_ext)
  %37 = call ptr @art_try_it(i1 false)
  %38 = call ptr @art_describe_match(ptr %37)
  %39 = call i32 @strcmp(ptr %38, ptr @.str.33)
  %widen77 = sext i32 %39 to i64
  %streq_cmp78 = icmp eq i64 %widen77, 0
  %streq_ext79 = zext i1 %streq_cmp78 to i64
  %40 = call i64 @forge_test_run_then(ptr @spec_str.34, i64 %streq_ext79)
  %41 = call ptr @art_try_it(i1 true)
  %42 = call ptr @art_describe_match(ptr %41)
  %43 = call i32 @strcmp(ptr %42, ptr @.str.35)
  %widen80 = sext i32 %43 to i64
  %streq_cmp81 = icmp eq i64 %widen80, 0
  %streq_ext82 = zext i1 %streq_cmp81 to i64
  %44 = call i64 @forge_test_run_then(ptr @spec_str.36, i64 %streq_ext82)
  %45 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr83 = getelementptr inbounds nuw %ArtColor, ptr %45, i32 0, i32 0
  store i64 6952072398151, ptr %tag_ptr83, align 8
  %pay_ptr84 = getelementptr inbounds nuw %ArtColor, ptr %45, i32 0, i32 1
  store ptr null, ptr %pay_ptr84, align 8
  %cast85 = ptrtoint ptr %45 to i64
  %cast86 = inttoptr i64 %cast85 to ptr
  store ptr %cast86, ptr %c, align 8
  %c87 = load ptr, ptr %c, align 8
  %tag_ptr88 = getelementptr inbounds nuw %ArtColor, ptr %c87, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr88, align 8
  %is_eq = icmp eq i64 %tag, 6952072398151
  %is_eq_ext = zext i1 %is_eq to i64
  %46 = call i64 @forge_test_run_then(ptr @spec_str.37, i64 %is_eq_ext)
  %47 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen89 = sext i32 %47 to i64
  %48 = call i32 @forge_test_summary()
  %widen90 = sext i32 %48 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_ArtResult(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %ArtResult, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ArtResult, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_ArtOk = icmp eq i64 %tag, 210668860454
  br i1 %is_ArtOk, label %rel_ArtOk, label %try_next_ArtOk

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_ArtErr, %vrel_error_skip, %vrel_value_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_ArtOk:                                        ; preds = %do_free
  %vrel_value_ptr = getelementptr inbounds nuw %ArtResult__ArtOk, ptr %payload, i32 0, i32 0
  %vrel_value = load ptr, ptr %vrel_value_ptr, align 8
  %vrel_null_value = icmp eq ptr %vrel_value, null
  br i1 %vrel_null_value, label %vrel_value_skip, label %vrel_value_do

try_next_ArtOk:                                   ; preds = %do_free
  %is_ArtErr = icmp eq i64 %tag, 6952072384437
  br i1 %is_ArtErr, label %rel_ArtErr, label %try_next_ArtErr

vrel_value_skip:                                  ; preds = %vrel_value_do, %rel_ArtOk
  br label %fields_done

vrel_value_do:                                    ; preds = %rel_ArtOk
  call void @forge_rc_release(ptr %vrel_value)
  br label %vrel_value_skip

rel_ArtErr:                                       ; preds = %try_next_ArtOk
  %vrel_error_ptr = getelementptr inbounds nuw %ArtResult__ArtErr, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_ArtErr:                                  ; preds = %try_next_ArtOk
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_ArtErr
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_ArtErr
  call void @forge_rc_release(ptr %vrel_error)
  br label %vrel_error_skip
}

define i64 @__release_ArtIntList(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %ArtIntList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ArtIntList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_ArtCons = icmp eq i64 %tag, 229418388611263
  br i1 %is_ArtCons, label %rel_ArtCons, label %try_next_ArtCons

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_ArtCons, %vrel_tail_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_ArtCons:                                      ; preds = %do_free
  %vrel_tail_ptr = getelementptr inbounds nuw %ArtIntList__ArtCons, ptr %payload, i32 0, i32 1
  %vrel_tail = load ptr, ptr %vrel_tail_ptr, align 8
  %vrel_null_tail = icmp eq ptr %vrel_tail, null
  br i1 %vrel_null_tail, label %vrel_tail_skip, label %vrel_tail_do

try_next_ArtCons:                                 ; preds = %do_free
  br label %fields_done

vrel_tail_skip:                                   ; preds = %vrel_tail_do, %rel_ArtCons
  br label %fields_done

vrel_tail_do:                                     ; preds = %rel_ArtCons
  %2 = call i64 @__release_ArtIntList(ptr %vrel_tail)
  br label %vrel_tail_skip
}
