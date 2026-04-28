; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Color = type { i64, ptr }
%Dir = type { i64, ptr }
%Option = type { i64, ptr }

@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"blue\00", align 1
@.match_fn = private unnamed_addr constant [11 x i8] c"color_name\00", align 1
@mu_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/contextual_enum.av\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"up\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"down\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.match_fn.7 = private unnamed_addr constant [9 x i8] c"dir_name\00", align 1
@mu_file.8 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/contextual_enum.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.match_fn.10 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.11 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/contextual_enum.av\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.match_fn.14 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.15 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/contextual_enum.av\00", align 1
@.i2s_fmt.16 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.17 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.match_fn.18 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.19 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/contextual_enum.av\00", align 1

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

define ptr @color_name(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %c = alloca ptr, align 8
  store ptr %0, ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %c1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193469728
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm5, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 210675960374
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq7 = icmp eq i64 %tag, 6383934317
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next3
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next3
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define ptr @dir_name(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %d = alloca ptr, align 8
  store ptr %0, ptr %d, align 8
  %d1 = load ptr, ptr %d, align 8
  %tag_ptr = getelementptr inbounds nuw %Dir, ptr %d1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 5862826
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm8, %march_arm5, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384009533
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq7 = icmp eq i64 %tag, 6384285584
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next3
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next3
  %tag_eq10 = icmp eq i64 %tag, 210688684355
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_arm8:                                       ; preds = %march_next6
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %match_result, align 8
  br label %match_end

march_next9:                                      ; preds = %march_next6
  call void @avra_match_unreachable(ptr @.match_fn.7, i64 %tag, ptr @mu_file.8, i64 17)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %v87 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %result = alloca ptr, align 8
  %ife_result = alloca i64, align 8
  %v56 = alloca i64, align 8
  %match_stmt_discard46 = alloca i64, align 8
  %n = alloca ptr, align 8
  %v30 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %x = alloca ptr, align 8
  %d = alloca ptr, align 8
  %c = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %c, align 8
  %c2 = load ptr, ptr %c, align 8
  %2 = call ptr @color_name(ptr %c2)
  %3 = call i32 @puts(ptr %2)
  %widen = sext i32 %3 to i64
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Color, ptr %4, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Color, ptr %4, i32 0, i32 1
  store ptr null, ptr %pay_ptr4, align 8
  %cast5 = ptrtoint ptr %4 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  %5 = call ptr @color_name(ptr %cast6)
  %6 = call i32 @puts(ptr %5)
  %widen7 = sext i32 %6 to i64
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr8 = getelementptr inbounds nuw %Color, ptr %7, i32 0, i32 0
  store i64 6383934317, ptr %tag_ptr8, align 8
  %pay_ptr9 = getelementptr inbounds nuw %Color, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr9, align 8
  %cast10 = ptrtoint ptr %7 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  %8 = call ptr @color_name(ptr %cast11)
  %9 = call i32 @puts(ptr %8)
  %widen12 = sext i32 %9 to i64
  %10 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr13 = getelementptr inbounds nuw %Dir, ptr %10, i32 0, i32 0
  store i64 5862826, ptr %tag_ptr13, align 8
  %pay_ptr14 = getelementptr inbounds nuw %Dir, ptr %10, i32 0, i32 1
  store ptr null, ptr %pay_ptr14, align 8
  %cast15 = ptrtoint ptr %10 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  store ptr %cast16, ptr %d, align 8
  %d17 = load ptr, ptr %d, align 8
  %11 = call ptr @dir_name(ptr %d17)
  %12 = call i32 @puts(ptr %11)
  %widen18 = sext i32 %12 to i64
  %13 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr19 = getelementptr inbounds nuw %Dir, ptr %13, i32 0, i32 0
  store i64 210688684355, ptr %tag_ptr19, align 8
  %pay_ptr20 = getelementptr inbounds nuw %Dir, ptr %13, i32 0, i32 1
  store ptr null, ptr %pay_ptr20, align 8
  %cast21 = ptrtoint ptr %13 to i64
  %cast22 = inttoptr i64 %cast21 to ptr
  %14 = call ptr @dir_name(ptr %cast22)
  %15 = call i32 @puts(ptr %14)
  %widen23 = sext i32 %15 to i64
  %16 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr24 = getelementptr inbounds nuw %Option, ptr %16, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr24, align 8
  %pay_ptr25 = getelementptr inbounds nuw %Option, ptr %16, i32 0, i32 1
  %17 = call ptr @avra_rc_alloc(i64 8)
  store ptr %17, ptr %pay_ptr25, align 8
  %slot_base = ptrtoint ptr %17 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast26 = ptrtoint ptr %16 to i64
  %cast27 = inttoptr i64 %cast26 to ptr
  store ptr %cast27, ptr %x, align 8
  %x28 = load ptr, ptr %x, align 8
  %tag_ptr29 = getelementptr inbounds nuw %Option, ptr %x28, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr29, align 8
  %tag_eq = icmp eq i64 %tag, 6384548249
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm34, %march_arm
  %18 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %Option, ptr %18, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %Option, ptr %18, i32 0, i32 1
  store ptr null, ptr %pay_ptr39, align 8
  %cast40 = ptrtoint ptr %18 to i64
  %cast41 = inttoptr i64 %cast40 to ptr
  store ptr %cast41, ptr %n, align 8
  %n42 = load ptr, ptr %n, align 8
  %tag_ptr43 = getelementptr inbounds nuw %Option, ptr %n42, i32 0, i32 0
  %tag44 = load i64, ptr %tag_ptr43, align 8
  %tag_eq49 = icmp eq i64 %tag44, 6384548249
  br i1 %tag_eq49, label %march_arm47, label %march_next48

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Option, ptr %x28, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v30, align 8
  %v31 = load i64, ptr %v30, align 8
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt, i64 %v31)
  %widen32 = sext i32 %20 to i64
  %21 = call i32 @puts(ptr %19)
  %widen33 = sext i32 %21 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq36 = icmp eq i64 %tag, 6384368597
  br i1 %tag_eq36, label %march_arm34, label %march_next35

march_arm34:                                      ; preds = %march_next
  %22 = call i32 @puts(ptr @.str.9)
  %widen37 = sext i32 %22 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next35:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.10, i64 %tag, ptr @mu_file.11, i64 39)
  unreachable

match_end45:                                      ; preds = %march_arm60, %march_arm47
  br i1 true, label %ife_then, label %ife_else

march_arm47:                                      ; preds = %match_end
  %pay_slot50 = getelementptr inbounds nuw %Option, ptr %n42, i32 0, i32 1
  %payload51 = load ptr, ptr %pay_slot50, align 8
  %v_slot_base52 = ptrtoint ptr %payload51 to i64
  %v_slot_addr53 = add i64 %v_slot_base52, 0
  %v_slot54 = inttoptr i64 %v_slot_addr53 to ptr
  %v55 = load i64, ptr %v_slot54, align 8
  store i64 %v55, ptr %v56, align 8
  %v57 = load i64, ptr %v56, align 8
  %23 = call ptr @avra_rc_alloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @.i2s_fmt.12, i64 %v57)
  %widen58 = sext i32 %24 to i64
  %25 = call i32 @puts(ptr %23)
  %widen59 = sext i32 %25 to i64
  store i64 0, ptr %match_stmt_discard46, align 8
  br label %match_end45

march_next48:                                     ; preds = %match_end
  %tag_eq62 = icmp eq i64 %tag44, 6384368597
  br i1 %tag_eq62, label %march_arm60, label %march_next61

march_arm60:                                      ; preds = %march_next48
  %26 = call i32 @puts(ptr @.str.13)
  %widen63 = sext i32 %26 to i64
  store i64 0, ptr %match_stmt_discard46, align 8
  br label %match_end45

march_next61:                                     ; preds = %march_next48
  call void @avra_match_unreachable(ptr @.match_fn.14, i64 %tag44, ptr @mu_file.15, i64 45)
  unreachable

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %cast73 = inttoptr i64 %ife_val to ptr
  store ptr %cast73, ptr %result, align 8
  %result74 = load ptr, ptr %result, align 8
  %tag_ptr75 = getelementptr inbounds nuw %Option, ptr %result74, i32 0, i32 0
  %tag76 = load i64, ptr %tag_ptr75, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq80 = icmp eq i64 %tag76, 6384548249
  br i1 %tag_eq80, label %march_arm78, label %march_next79

ife_then:                                         ; preds = %match_end45
  %27 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr64 = getelementptr inbounds nuw %Option, ptr %27, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr64, align 8
  %pay_ptr65 = getelementptr inbounds nuw %Option, ptr %27, i32 0, i32 1
  %28 = call ptr @avra_rc_alloc(i64 8)
  store ptr %28, ptr %pay_ptr65, align 8
  %slot_base66 = ptrtoint ptr %28 to i64
  %slot_addr67 = add i64 %slot_base66, 0
  %slot68 = inttoptr i64 %slot_addr67 to ptr
  store i64 99, ptr %slot68, align 8
  %cast69 = ptrtoint ptr %27 to i64
  store i64 %cast69, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %match_end45
  %29 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr70 = getelementptr inbounds nuw %Option, ptr %29, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr70, align 8
  %pay_ptr71 = getelementptr inbounds nuw %Option, ptr %29, i32 0, i32 1
  store ptr null, ptr %pay_ptr71, align 8
  %cast72 = ptrtoint ptr %29 to i64
  store i64 %cast72, ptr %ife_result, align 8
  br label %ife_end

match_end77:                                      ; preds = %march_arm91, %march_arm78
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm78:                                      ; preds = %ife_end
  %pay_slot81 = getelementptr inbounds nuw %Option, ptr %result74, i32 0, i32 1
  %payload82 = load ptr, ptr %pay_slot81, align 8
  %v_slot_base83 = ptrtoint ptr %payload82 to i64
  %v_slot_addr84 = add i64 %v_slot_base83, 0
  %v_slot85 = inttoptr i64 %v_slot_addr84 to ptr
  %v86 = load i64, ptr %v_slot85, align 8
  store i64 %v86, ptr %v87, align 8
  %v88 = load i64, ptr %v87, align 8
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.16, i64 %v88)
  %widen89 = sext i32 %31 to i64
  %32 = call i32 @puts(ptr %30)
  %widen90 = sext i32 %32 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end77

march_next79:                                     ; preds = %ife_end
  %tag_eq93 = icmp eq i64 %tag76, 6384368597
  br i1 %tag_eq93, label %march_arm91, label %march_next92

march_arm91:                                      ; preds = %march_next79
  %33 = call i32 @puts(ptr @.str.17)
  %widen94 = sext i32 %33 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end77

march_next92:                                     ; preds = %march_next79
  call void @avra_match_unreachable(ptr @.match_fn.18, i64 %tag76, ptr @mu_file.19, i64 52)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
