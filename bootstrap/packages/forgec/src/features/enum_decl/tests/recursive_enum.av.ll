; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%IntList = type { i64, ptr }
%IntList__Cons = type { i64, ptr }

@list = global i64 0
@.match_fn = private unnamed_addr constant [9 x i8] c"list_sum\00", align 1
@mu_file = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/recursive_enum.av\00", align 1
@.match_fn.1 = private unnamed_addr constant [12 x i8] c"list_length\00", align 1
@mu_file.2 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/recursive_enum.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @list_sum(ptr %0) {
entry:
  %tail8 = alloca ptr, align 8
  %head5 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %list = alloca ptr, align 8
  store ptr %0, ptr %list, align 8
  %list1 = load ptr, ptr %list, align 8
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %list1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %IntList, ptr %list1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %head_slot_base = ptrtoint ptr %payload to i64
  %head_slot_addr = add i64 %head_slot_base, 0
  %head_slot = inttoptr i64 %head_slot_addr to ptr
  %head = load i64, ptr %head_slot, align 8
  store i64 %head, ptr %head5, align 8
  %pay_slot6 = getelementptr inbounds nuw %IntList, ptr %list1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %tail_slot_base = ptrtoint ptr %payload7 to i64
  %tail_slot_addr = add i64 %tail_slot_base, 8
  %tail_slot = inttoptr i64 %tail_slot_addr to ptr
  %tail = load ptr, ptr %tail_slot, align 8
  call void @avra_rc_retain(ptr %tail)
  store ptr %tail, ptr %tail8, align 8
  %head9 = load i64, ptr %head5, align 8
  %tail10 = load ptr, ptr %tail8, align 8
  %1 = call i64 @list_sum(ptr %tail10)
  %add = add i64 %head9, %1
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable
}

define i64 @list_length(ptr %0) {
entry:
  %tail5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %list = alloca ptr, align 8
  store ptr %0, ptr %list, align 8
  %list1 = load ptr, ptr %list, align 8
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %list1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %IntList, ptr %list1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %tail_slot_base = ptrtoint ptr %payload to i64
  %tail_slot_addr = add i64 %tail_slot_base, 8
  %tail_slot = inttoptr i64 %tail_slot_addr to ptr
  %tail = load ptr, ptr %tail_slot, align 8
  call void @avra_rc_retain(ptr %tail)
  store ptr %tail, ptr %tail5, align 8
  %tail6 = load ptr, ptr %tail5, align 8
  %1 = call i64 @list_length(ptr %tail6)
  %add = add i64 1, %1
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.1, i64 %tag, ptr @mu_file.2, i64 15)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 16)
  store ptr %1, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 1, ptr %slot, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %IntList, ptr %2, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %IntList, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr2, align 8
  %slot_base3 = ptrtoint ptr %3 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 2, ptr %slot5, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %IntList, ptr %4, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %IntList, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 16)
  store ptr %5, ptr %pay_ptr7, align 8
  %slot_base8 = ptrtoint ptr %5 to i64
  %slot_addr9 = add i64 %slot_base8, 0
  %slot10 = inttoptr i64 %slot_addr9 to ptr
  store i64 3, ptr %slot10, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %IntList, ptr %6, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %IntList, ptr %6, i32 0, i32 1
  %7 = call ptr @avra_rc_alloc(i64 16)
  store ptr %7, ptr %pay_ptr12, align 8
  %slot_base13 = ptrtoint ptr %7 to i64
  %slot_addr14 = add i64 %slot_base13, 0
  %slot15 = inttoptr i64 %slot_addr14 to ptr
  store i64 4, ptr %slot15, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr16 = getelementptr inbounds nuw %IntList, ptr %8, i32 0, i32 0
  store i64 193465512, ptr %tag_ptr16, align 8
  %pay_ptr17 = getelementptr inbounds nuw %IntList, ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr17, align 8
  %cast = ptrtoint ptr %8 to i64
  %slot_base18 = ptrtoint ptr %7 to i64
  %slot_addr19 = add i64 %slot_base18, 8
  %slot20 = inttoptr i64 %slot_addr19 to ptr
  %cast21 = inttoptr i64 %cast to ptr
  store ptr %cast21, ptr %slot20, align 8
  %cast22 = ptrtoint ptr %6 to i64
  %slot_base23 = ptrtoint ptr %5 to i64
  %slot_addr24 = add i64 %slot_base23, 8
  %slot25 = inttoptr i64 %slot_addr24 to ptr
  %cast26 = inttoptr i64 %cast22 to ptr
  store ptr %cast26, ptr %slot25, align 8
  %cast27 = ptrtoint ptr %4 to i64
  %slot_base28 = ptrtoint ptr %3 to i64
  %slot_addr29 = add i64 %slot_base28, 8
  %slot30 = inttoptr i64 %slot_addr29 to ptr
  %cast31 = inttoptr i64 %cast27 to ptr
  store ptr %cast31, ptr %slot30, align 8
  %cast32 = ptrtoint ptr %2 to i64
  %slot_base33 = ptrtoint ptr %1 to i64
  %slot_addr34 = add i64 %slot_base33, 8
  %slot35 = inttoptr i64 %slot_addr34 to ptr
  %cast36 = inttoptr i64 %cast32 to ptr
  store ptr %cast36, ptr %slot35, align 8
  %cast37 = ptrtoint ptr %0 to i64
  store i64 %cast37, ptr @list, align 8
  %list = load ptr, ptr @list, align 8
  %9 = call i64 @list_sum(ptr %list)
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt, i64 %9)
  %widen = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen38 = sext i32 %12 to i64
  %list39 = load ptr, ptr @list, align 8
  %13 = call i64 @list_length(ptr %list39)
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.3, i64 %13)
  %widen40 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen41 = sext i32 %16 to i64
  %17 = call i32 @avra_test_summary()
  %widen42 = sext i32 %17 to i64
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
