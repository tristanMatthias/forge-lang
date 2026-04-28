; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Outer = type { i64, ptr }
%Inner = type { i64, ptr }

@.match_fn = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/match_in_match.av\00", align 1
@.match_fn.1 = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file.2 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/match_in_match.av\00", align 1
@.match_fn.3 = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file.4 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/match_in_match.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @classify(ptr %0, ptr %1) {
entry:
  %v40 = alloca i64, align 8
  %match_result26 = alloca i64, align 8
  %v17 = alloca i64, align 8
  %match_result6 = alloca i64, align 8
  %x2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %i = alloca ptr, align 8
  %o = alloca ptr, align 8
  store ptr %0, ptr %o, align 8
  store ptr %1, ptr %i, align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 177638
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %match_end27, %match_end7
  %match_val43 = load i64, ptr %match_result, align 8
  ret i64 %match_val43

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %x_slot_base = ptrtoint ptr %payload to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x2, align 8
  %i3 = load ptr, ptr %i, align 8
  %tag_ptr4 = getelementptr inbounds nuw %Inner, ptr %i3, i32 0, i32 0
  %tag5 = load i64, ptr %tag_ptr4, align 8
  store i64 0, ptr %match_result6, align 8
  %tag_eq10 = icmp eq i64 %tag5, 177661
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_next:                                       ; preds = %entry
  %tag_eq22 = icmp eq i64 %tag, 177639
  br i1 %tag_eq22, label %march_arm20, label %march_next21

match_end7:                                       ; preds = %march_arm12, %march_arm8
  %match_val = load i64, ptr %match_result6, align 8
  store i64 %match_val, ptr %match_result, align 8
  br label %match_end

march_arm8:                                       ; preds = %march_arm
  %x11 = load i64, ptr %x2, align 8
  store i64 %x11, ptr %match_result6, align 8
  br label %match_end7

march_next9:                                      ; preds = %march_arm
  %tag_eq14 = icmp eq i64 %tag5, 177662
  br i1 %tag_eq14, label %march_arm12, label %march_next13

march_arm12:                                      ; preds = %march_next9
  %pay_slot15 = getelementptr inbounds nuw %Inner, ptr %i3, i32 0, i32 1
  %payload16 = load ptr, ptr %pay_slot15, align 8
  %v_slot_base = ptrtoint ptr %payload16 to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v17, align 8
  %x18 = load i64, ptr %x2, align 8
  %v19 = load i64, ptr %v17, align 8
  %add = add i64 %x18, %v19
  store i64 %add, ptr %match_result6, align 8
  br label %match_end7

march_next13:                                     ; preds = %march_next9
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag5, ptr @mu_file, i64 9)
  unreachable

march_arm20:                                      ; preds = %march_next
  %i23 = load ptr, ptr %i, align 8
  %tag_ptr24 = getelementptr inbounds nuw %Inner, ptr %i23, i32 0, i32 0
  %tag25 = load i64, ptr %tag_ptr24, align 8
  store i64 0, ptr %match_result26, align 8
  %tag_eq30 = icmp eq i64 %tag25, 177661
  br i1 %tag_eq30, label %march_arm28, label %march_next29

march_next21:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %tag, ptr @mu_file.4, i64 6)
  unreachable

match_end27:                                      ; preds = %march_arm31, %march_arm28
  %match_val42 = load i64, ptr %match_result26, align 8
  store i64 %match_val42, ptr %match_result, align 8
  br label %match_end

march_arm28:                                      ; preds = %march_arm20
  store i64 -1, ptr %match_result26, align 8
  br label %match_end27

march_next29:                                     ; preds = %march_arm20
  %tag_eq33 = icmp eq i64 %tag25, 177662
  br i1 %tag_eq33, label %march_arm31, label %march_next32

march_arm31:                                      ; preds = %march_next29
  %pay_slot34 = getelementptr inbounds nuw %Inner, ptr %i23, i32 0, i32 1
  %payload35 = load ptr, ptr %pay_slot34, align 8
  %v_slot_base36 = ptrtoint ptr %payload35 to i64
  %v_slot_addr37 = add i64 %v_slot_base36, 0
  %v_slot38 = inttoptr i64 %v_slot_addr37 to ptr
  %v39 = load i64, ptr %v_slot38, align 8
  store i64 %v39, ptr %v40, align 8
  %v41 = load i64, ptr %v40, align 8
  %mul = mul i64 %v41, 10
  store i64 %mul, ptr %match_result26, align 8
  br label %match_end27

march_next32:                                     ; preds = %march_next29
  call void @avra_match_unreachable(ptr @.match_fn.1, i64 %tag25, ptr @mu_file.2, i64 16)
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
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %0 to i64
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Inner, ptr %2, i32 0, i32 0
  store i64 177661, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Inner, ptr %2, i32 0, i32 1
  store ptr null, ptr %pay_ptr2, align 8
  %cast3 = ptrtoint ptr %2 to i64
  %cast4 = inttoptr i64 %cast to ptr
  %cast5 = inttoptr i64 %cast3 to ptr
  %3 = call i64 @classify(ptr %cast4, ptr %cast5)
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %3)
  %widen = sext i32 %5 to i64
  %6 = call i32 @puts(ptr %4)
  %widen6 = sext i32 %6 to i64
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr7 = getelementptr inbounds nuw %Outer, ptr %7, i32 0, i32 0
  store i64 177638, ptr %tag_ptr7, align 8
  %pay_ptr8 = getelementptr inbounds nuw %Outer, ptr %7, i32 0, i32 1
  %8 = call ptr @avra_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr8, align 8
  %slot_base9 = ptrtoint ptr %8 to i64
  %slot_addr10 = add i64 %slot_base9, 0
  %slot11 = inttoptr i64 %slot_addr10 to ptr
  store i64 5, ptr %slot11, align 8
  %cast12 = ptrtoint ptr %7 to i64
  %9 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr13 = getelementptr inbounds nuw %Inner, ptr %9, i32 0, i32 0
  store i64 177662, ptr %tag_ptr13, align 8
  %pay_ptr14 = getelementptr inbounds nuw %Inner, ptr %9, i32 0, i32 1
  %10 = call ptr @avra_rc_alloc(i64 8)
  store ptr %10, ptr %pay_ptr14, align 8
  %slot_base15 = ptrtoint ptr %10 to i64
  %slot_addr16 = add i64 %slot_base15, 0
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  store i64 3, ptr %slot17, align 8
  %cast18 = ptrtoint ptr %9 to i64
  %cast19 = inttoptr i64 %cast12 to ptr
  %cast20 = inttoptr i64 %cast18 to ptr
  %11 = call i64 @classify(ptr %cast19, ptr %cast20)
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.5, i64 %11)
  %widen21 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen22 = sext i32 %14 to i64
  %15 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr23 = getelementptr inbounds nuw %Outer, ptr %15, i32 0, i32 0
  store i64 177639, ptr %tag_ptr23, align 8
  %pay_ptr24 = getelementptr inbounds nuw %Outer, ptr %15, i32 0, i32 1
  store ptr null, ptr %pay_ptr24, align 8
  %cast25 = ptrtoint ptr %15 to i64
  %16 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %Inner, ptr %16, i32 0, i32 0
  store i64 177661, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %Inner, ptr %16, i32 0, i32 1
  store ptr null, ptr %pay_ptr27, align 8
  %cast28 = ptrtoint ptr %16 to i64
  %cast29 = inttoptr i64 %cast25 to ptr
  %cast30 = inttoptr i64 %cast28 to ptr
  %17 = call i64 @classify(ptr %cast29, ptr %cast30)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.6, i64 %17)
  %widen31 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen32 = sext i32 %20 to i64
  %21 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr33 = getelementptr inbounds nuw %Outer, ptr %21, i32 0, i32 0
  store i64 177639, ptr %tag_ptr33, align 8
  %pay_ptr34 = getelementptr inbounds nuw %Outer, ptr %21, i32 0, i32 1
  store ptr null, ptr %pay_ptr34, align 8
  %cast35 = ptrtoint ptr %21 to i64
  %22 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %Inner, ptr %22, i32 0, i32 0
  store i64 177662, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %Inner, ptr %22, i32 0, i32 1
  %23 = call ptr @avra_rc_alloc(i64 8)
  store ptr %23, ptr %pay_ptr37, align 8
  %slot_base38 = ptrtoint ptr %23 to i64
  %slot_addr39 = add i64 %slot_base38, 0
  %slot40 = inttoptr i64 %slot_addr39 to ptr
  store i64 7, ptr %slot40, align 8
  %cast41 = ptrtoint ptr %22 to i64
  %cast42 = inttoptr i64 %cast35 to ptr
  %cast43 = inttoptr i64 %cast41 to ptr
  %24 = call i64 @classify(ptr %cast42, ptr %cast43)
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.7, i64 %24)
  %widen44 = sext i32 %26 to i64
  %27 = call i32 @puts(ptr %25)
  %widen45 = sext i32 %27 to i64
  %28 = call i32 @avra_test_summary()
  %widen46 = sext i32 %28 to i64
  call void @avra_rc_collect()
  ret i64 0
}
