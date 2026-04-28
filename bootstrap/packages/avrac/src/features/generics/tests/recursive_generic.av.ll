; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%List__int = type { i64, ptr }
%List__int__Node = type { i64, ptr }

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [11 x i8] c"print_list\00", align 1
@mu_file = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/generics/tests/recursive_generic.av\00", align 1

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

define i64 @print_list(ptr %0) {
entry:
  %next8 = alloca ptr, align 8
  %v5 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %list = alloca ptr, align 8
  store ptr %0, ptr %list, align 8
  %list1 = load ptr, ptr %list, align 8
  %tag_ptr = getelementptr inbounds nuw %List__int, ptr %list1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %1 = call ptr @avra_map_new_cstr()
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %List__int, ptr %list1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v5, align 8
  %pay_slot6 = getelementptr inbounds nuw %List__int, ptr %list1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %v9 = load i64, ptr %v5, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %v9)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen10 = sext i32 %4 to i64
  %next11 = load ptr, ptr %next8, align 8
  %5 = call i64 @print_list(ptr %next11)
  store i64 %5, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 12)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %list = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %List__int, ptr %1, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %List__int, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 16)
  store ptr %2, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 1, ptr %slot, align 8
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %List__int, ptr %3, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %List__int, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 16)
  store ptr %4, ptr %pay_ptr2, align 8
  %slot_base3 = ptrtoint ptr %4 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 2, ptr %slot5, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %List__int, ptr %5, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %List__int, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 16)
  store ptr %6, ptr %pay_ptr7, align 8
  %slot_base8 = ptrtoint ptr %6 to i64
  %slot_addr9 = add i64 %slot_base8, 0
  %slot10 = inttoptr i64 %slot_addr9 to ptr
  store i64 3, ptr %slot10, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %List__int, ptr %7, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %List__int, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr12, align 8
  %cast = ptrtoint ptr %7 to i64
  %slot_base13 = ptrtoint ptr %6 to i64
  %slot_addr14 = add i64 %slot_base13, 8
  %slot15 = inttoptr i64 %slot_addr14 to ptr
  %cast16 = inttoptr i64 %cast to ptr
  store ptr %cast16, ptr %slot15, align 8
  %cast17 = ptrtoint ptr %5 to i64
  %slot_base18 = ptrtoint ptr %4 to i64
  %slot_addr19 = add i64 %slot_base18, 8
  %slot20 = inttoptr i64 %slot_addr19 to ptr
  %cast21 = inttoptr i64 %cast17 to ptr
  store ptr %cast21, ptr %slot20, align 8
  %cast22 = ptrtoint ptr %3 to i64
  %slot_base23 = ptrtoint ptr %2 to i64
  %slot_addr24 = add i64 %slot_base23, 8
  %slot25 = inttoptr i64 %slot_addr24 to ptr
  %cast26 = inttoptr i64 %cast22 to ptr
  store ptr %cast26, ptr %slot25, align 8
  %cast27 = ptrtoint ptr %1 to i64
  %cast28 = inttoptr i64 %cast27 to ptr
  store ptr %cast28, ptr %list, align 8
  %list29 = load ptr, ptr %list, align 8
  %8 = call i64 @print_list(ptr %list29)
  ret i64 %8
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_List__int(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %List__int, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %List__int, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_next_ptr = getelementptr inbounds nuw %List__int__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_next_skip:                                   ; preds = %vrel_next_do, %rel_Node
  br label %fields_done

vrel_next_do:                                     ; preds = %rel_Node
  call void @avra_rc_release(ptr %vrel_next)
  br label %vrel_next_skip
}
