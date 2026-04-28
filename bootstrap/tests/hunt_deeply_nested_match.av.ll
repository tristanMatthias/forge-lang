; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Outer = type { i64, ptr }
%Inner = type { i64, ptr }
%Outer__A = type { ptr }

@.str = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"zero or negative\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"deep\00", align 1
@mu_file = private unnamed_addr constant [111 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_deeply_nested_match.av\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"Y\00", align 1
@.match_fn.4 = private unnamed_addr constant [5 x i8] c"deep\00", align 1
@mu_file.5 = private unnamed_addr constant [111 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_deeply_nested_match.av\00", align 1
@.match_fn.6 = private unnamed_addr constant [5 x i8] c"deep\00", align 1
@mu_file.7 = private unnamed_addr constant [111 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_deeply_nested_match.av\00", align 1

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

define ptr @deep(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %v13 = alloca i64, align 8
  %match_result6 = alloca i64, align 8
  %inner2 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %o = alloca ptr, align 8
  store ptr %0, ptr %o, align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 177638
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %match_end7
  %match_val27 = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val27 to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %inner_slot_base = ptrtoint ptr %payload to i64
  %inner_slot_addr = add i64 %inner_slot_base, 0
  %inner_slot = inttoptr i64 %inner_slot_addr to ptr
  %inner = load ptr, ptr %inner_slot, align 8
  call void @avra_rc_retain(ptr %inner)
  store ptr %inner, ptr %inner2, align 8
  %inner3 = load ptr, ptr %inner2, align 8
  %tag_ptr4 = getelementptr inbounds nuw %Inner, ptr %inner3, i32 0, i32 0
  %tag5 = load i64, ptr %tag_ptr4, align 8
  store i64 0, ptr %match_result6, align 8
  %tag_eq10 = icmp eq i64 %tag5, 177661
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_next:                                       ; preds = %entry
  call void @avra_match_unreachable(ptr @.match_fn.6, i64 %tag, ptr @mu_file.7, i64 6)
  unreachable

match_end7:                                       ; preds = %march_arm24, %pmatch_end
  %match_val = load i64, ptr %match_result6, align 8
  store i64 %match_val, ptr %match_result, align 8
  br label %match_end

march_arm8:                                       ; preds = %march_arm
  %pay_slot11 = getelementptr inbounds nuw %Inner, ptr %inner3, i32 0, i32 1
  %payload12 = load ptr, ptr %pay_slot11, align 8
  %v_slot_base = ptrtoint ptr %payload12 to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v13, align 8
  %v14 = load i64, ptr %v13, align 8
  store i64 0, ptr %pmatch_result, align 8
  %v15 = load i64, ptr %v13, align 8
  %sgt = icmp sgt i64 %v15, 10
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

march_next9:                                      ; preds = %march_arm
  %tag_eq26 = icmp eq i64 %tag5, 177662
  br i1 %tag_eq26, label %march_arm24, label %march_next25

pmatch_end:                                       ; preds = %parm_body22, %parm_body16, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  store i64 %pmatch_val, ptr %match_result6, align 8
  br label %match_end7

parm_body:                                        ; preds = %march_arm8
  store i64 ptrtoint (ptr @.str to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %march_arm8
  %v18 = load i64, ptr %v13, align 8
  %sgt19 = icmp sgt i64 %v18, 0
  %sgt_ext20 = zext i1 %sgt19 to i64
  %pguard21 = icmp ne i64 %sgt_ext20, 0
  br i1 %pguard21, label %parm_body16, label %parm_next17

parm_body16:                                      ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next17:                                      ; preds = %parm_next
  br label %parm_body22

parm_body22:                                      ; preds = %parm_next17
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next23:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 12)
  unreachable

march_arm24:                                      ; preds = %march_next9
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result6, align 8
  br label %match_end7

march_next25:                                     ; preds = %march_next9
  call void @avra_match_unreachable(ptr @.match_fn.4, i64 %tag5, ptr @mu_file.5, i64 9)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  store i64 177638, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 8)
  store ptr %1, ptr %pay_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Inner, ptr %2, i32 0, i32 0
  store i64 177661, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Inner, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr2, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  %slot_base3 = ptrtoint ptr %1 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  %cast6 = inttoptr i64 %cast to ptr
  store ptr %cast6, ptr %slot5, align 8
  %cast7 = ptrtoint ptr %0 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %4 = call ptr @deep(ptr %cast8)
  %5 = call i32 @puts(ptr %4)
  %widen = sext i32 %5 to i64
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr9 = getelementptr inbounds nuw %Outer, ptr %6, i32 0, i32 0
  store i64 177638, ptr %tag_ptr9, align 8
  %pay_ptr10 = getelementptr inbounds nuw %Outer, ptr %6, i32 0, i32 1
  %7 = call ptr @avra_rc_alloc(i64 8)
  store ptr %7, ptr %pay_ptr10, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %Inner, ptr %8, i32 0, i32 0
  store i64 177661, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %Inner, ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 8)
  store ptr %9, ptr %pay_ptr12, align 8
  %slot_base13 = ptrtoint ptr %9 to i64
  %slot_addr14 = add i64 %slot_base13, 0
  %slot15 = inttoptr i64 %slot_addr14 to ptr
  store i64 3, ptr %slot15, align 8
  %cast16 = ptrtoint ptr %8 to i64
  %slot_base17 = ptrtoint ptr %7 to i64
  %slot_addr18 = add i64 %slot_base17, 0
  %slot19 = inttoptr i64 %slot_addr18 to ptr
  %cast20 = inttoptr i64 %cast16 to ptr
  store ptr %cast20, ptr %slot19, align 8
  %cast21 = ptrtoint ptr %6 to i64
  %cast22 = inttoptr i64 %cast21 to ptr
  %10 = call ptr @deep(ptr %cast22)
  %11 = call i32 @puts(ptr %10)
  %widen23 = sext i32 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr24 = getelementptr inbounds nuw %Outer, ptr %12, i32 0, i32 0
  store i64 177638, ptr %tag_ptr24, align 8
  %pay_ptr25 = getelementptr inbounds nuw %Outer, ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 8)
  store ptr %13, ptr %pay_ptr25, align 8
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %Inner, ptr %14, i32 0, i32 0
  store i64 177661, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %Inner, ptr %14, i32 0, i32 1
  %15 = call ptr @avra_rc_alloc(i64 8)
  store ptr %15, ptr %pay_ptr27, align 8
  %slot_base28 = ptrtoint ptr %15 to i64
  %slot_addr29 = add i64 %slot_base28, 0
  %slot30 = inttoptr i64 %slot_addr29 to ptr
  store i64 0, ptr %slot30, align 8
  %cast31 = ptrtoint ptr %14 to i64
  %slot_base32 = ptrtoint ptr %13 to i64
  %slot_addr33 = add i64 %slot_base32, 0
  %slot34 = inttoptr i64 %slot_addr33 to ptr
  %cast35 = inttoptr i64 %cast31 to ptr
  store ptr %cast35, ptr %slot34, align 8
  %cast36 = ptrtoint ptr %12 to i64
  %cast37 = inttoptr i64 %cast36 to ptr
  %16 = call ptr @deep(ptr %cast37)
  %17 = call i32 @puts(ptr %16)
  %widen38 = sext i32 %17 to i64
  %18 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr39 = getelementptr inbounds nuw %Outer, ptr %18, i32 0, i32 0
  store i64 177638, ptr %tag_ptr39, align 8
  %pay_ptr40 = getelementptr inbounds nuw %Outer, ptr %18, i32 0, i32 1
  %19 = call ptr @avra_rc_alloc(i64 8)
  store ptr %19, ptr %pay_ptr40, align 8
  %20 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr41 = getelementptr inbounds nuw %Inner, ptr %20, i32 0, i32 0
  store i64 177662, ptr %tag_ptr41, align 8
  %pay_ptr42 = getelementptr inbounds nuw %Inner, ptr %20, i32 0, i32 1
  store ptr null, ptr %pay_ptr42, align 8
  %cast43 = ptrtoint ptr %20 to i64
  %slot_base44 = ptrtoint ptr %19 to i64
  %slot_addr45 = add i64 %slot_base44, 0
  %slot46 = inttoptr i64 %slot_addr45 to ptr
  %cast47 = inttoptr i64 %cast43 to ptr
  store ptr %cast47, ptr %slot46, align 8
  %cast48 = ptrtoint ptr %18 to i64
  %cast49 = inttoptr i64 %cast48 to ptr
  %21 = call ptr @deep(ptr %cast49)
  %22 = call i32 @puts(ptr %21)
  %widen50 = sext i32 %22 to i64
  %23 = call i32 @avra_test_summary()
  %widen51 = sext i32 %23 to i64
  call void @avra_rc_collect()
  ret i64 0
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
  %is_A = icmp eq i64 %tag, 177638
  br i1 %is_A, label %rel_A, label %try_next_A

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_A, %vrel_inner_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_A:                                            ; preds = %do_free
  %vrel_inner_ptr = getelementptr inbounds nuw %Outer__A, ptr %payload, i32 0, i32 0
  %vrel_inner = load ptr, ptr %vrel_inner_ptr, align 8
  %vrel_null_inner = icmp eq ptr %vrel_inner, null
  br i1 %vrel_null_inner, label %vrel_inner_skip, label %vrel_inner_do

try_next_A:                                       ; preds = %do_free
  br label %fields_done

vrel_inner_skip:                                  ; preds = %vrel_inner_do, %rel_A
  br label %fields_done

vrel_inner_do:                                    ; preds = %rel_A
  call void @avra_rc_release(ptr %vrel_inner)
  br label %vrel_inner_skip
}
