; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result = type { i64, ptr }

@results = global i64 0
@dz_file = private unnamed_addr constant [133 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/tuples/tests/tuple_match.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [133 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/tuples/tests/tuple_match.av\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"div by zero\00", align 1
@.match_fn.3 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.4 = private unnamed_addr constant [133 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/tuples/tests/tuple_match.av\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.match_fn.7 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.8 = private unnamed_addr constant [133 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/tuples/tests/tuple_match.av\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"div by zero\00", align 1
@.match_fn.11 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.12 = private unnamed_addr constant [133 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/tuples/tests/tuple_match.av\00", align 1

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

define ptr @divide(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %b1 = load i64, ptr %b, align 8
  %eq = icmp eq i64 %b1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %a5 = load i64, ptr %a, align 8
  %b6 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b6, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 132, i64 8)
  %div = sdiv i64 %a5, %b6
  %slot_base7 = ptrtoint ptr %3 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %div, ptr %slot9, align 8
  %cast10 = ptrtoint ptr %2 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast11, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %4, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 0, ptr %slot, align 8
  %cast = ptrtoint ptr %4 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast12 = inttoptr i64 %cast10 to ptr
  ret ptr %cast12
}

define i64 @main() {
entry:
  %v91 = alloca i64, align 8
  %match_stmt_discard81 = alloca i64, align 8
  %v69 = alloca i64, align 8
  %match_stmt_discard59 = alloca i64, align 8
  %r254 = alloca i64, align 8
  %r153 = alloca i64, align 8
  %v35 = alloca i64, align 8
  %match_stmt_discard25 = alloca i64, align 8
  %v8 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %1 = call ptr @divide(i64 10, i64 2)
  %slot_base = ptrtoint ptr %0 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %slot, align 8
  %2 = call ptr @divide(i64 10, i64 0)
  %slot_base1 = ptrtoint ptr %0 to i64
  %slot_addr2 = add i64 %slot_base1, 8
  %slot3 = inttoptr i64 %slot_addr2 to ptr
  %cast4 = ptrtoint ptr %2 to i64
  store i64 %cast4, ptr %slot3, align 8
  %cast5 = ptrtoint ptr %0 to i64
  store i64 %cast5, ptr @results, align 8
  %results = load ptr, ptr @results, align 8
  %tup_val_slot_base = ptrtoint ptr %results to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  %cast6 = inttoptr i64 %tup_val to ptr
  %cast7 = inttoptr i64 %tup_val to ptr
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %cast7, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm11, %march_arm
  %results15 = load ptr, ptr @results, align 8
  %tup_val_slot_base16 = ptrtoint ptr %results15 to i64
  %tup_val_slot_addr17 = add i64 %tup_val_slot_base16, 8
  %tup_val_slot18 = inttoptr i64 %tup_val_slot_addr17 to ptr
  %tup_val19 = load i64, ptr %tup_val_slot18, align 8
  %cast20 = inttoptr i64 %tup_val19 to ptr
  %cast21 = inttoptr i64 %tup_val19 to ptr
  %tag_ptr22 = getelementptr inbounds nuw %Result, ptr %cast21, i32 0, i32 0
  %tag23 = load i64, ptr %tag_ptr22, align 8
  %tag_eq28 = icmp eq i64 %tag23, 5862623
  br i1 %tag_eq28, label %march_arm26, label %march_next27

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %cast6, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v8, align 8
  %v9 = load i64, ptr %v8, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %v9)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen10 = sext i32 %5 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq13 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq13, label %march_arm11, label %march_next12

march_arm11:                                      ; preds = %march_next
  %6 = call i32 @puts(ptr @.str)
  %widen14 = sext i32 %6 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next12:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 14)
  unreachable

match_end24:                                      ; preds = %march_arm39, %march_arm26
  %7 = call ptr @avra_rc_alloc(i64 16)
  %8 = call ptr @divide(i64 20, i64 4)
  %slot_base43 = ptrtoint ptr %7 to i64
  %slot_addr44 = add i64 %slot_base43, 0
  %slot45 = inttoptr i64 %slot_addr44 to ptr
  %cast46 = ptrtoint ptr %8 to i64
  store i64 %cast46, ptr %slot45, align 8
  %9 = call ptr @divide(i64 20, i64 0)
  %slot_base47 = ptrtoint ptr %7 to i64
  %slot_addr48 = add i64 %slot_base47, 8
  %slot49 = inttoptr i64 %slot_addr48 to ptr
  %cast50 = ptrtoint ptr %9 to i64
  store i64 %cast50, ptr %slot49, align 8
  %cast51 = ptrtoint ptr %7 to i64
  %cast52 = inttoptr i64 %cast51 to ptr
  %r1_slot_base = ptrtoint ptr %cast52 to i64
  %r1_slot_addr = add i64 %r1_slot_base, 0
  %r1_slot = inttoptr i64 %r1_slot_addr to ptr
  %r1 = load i64, ptr %r1_slot, align 8
  store i64 %r1, ptr %r153, align 8
  %r2_slot_base = ptrtoint ptr %cast52 to i64
  %r2_slot_addr = add i64 %r2_slot_base, 8
  %r2_slot = inttoptr i64 %r2_slot_addr to ptr
  %r2 = load i64, ptr %r2_slot, align 8
  store i64 %r2, ptr %r254, align 8
  %r155 = load ptr, ptr %r153, align 8
  %tag_ptr56 = getelementptr inbounds nuw %Result, ptr %r155, i32 0, i32 0
  %tag57 = load i64, ptr %tag_ptr56, align 8
  %tag_eq62 = icmp eq i64 %tag57, 5862623
  br i1 %tag_eq62, label %march_arm60, label %march_next61

march_arm26:                                      ; preds = %match_end
  %pay_slot29 = getelementptr inbounds nuw %Result, ptr %cast20, i32 0, i32 1
  %payload30 = load ptr, ptr %pay_slot29, align 8
  %v_slot_base31 = ptrtoint ptr %payload30 to i64
  %v_slot_addr32 = add i64 %v_slot_base31, 0
  %v_slot33 = inttoptr i64 %v_slot_addr32 to ptr
  %v34 = load i64, ptr %v_slot33, align 8
  store i64 %v34, ptr %v35, align 8
  %v36 = load i64, ptr %v35, align 8
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.1, i64 %v36)
  %widen37 = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen38 = sext i32 %12 to i64
  store i64 0, ptr %match_stmt_discard25, align 8
  br label %match_end24

march_next27:                                     ; preds = %match_end
  %tag_eq41 = icmp eq i64 %tag23, 193456014
  br i1 %tag_eq41, label %march_arm39, label %march_next40

march_arm39:                                      ; preds = %march_next27
  %13 = call i32 @puts(ptr @.str.2)
  %widen42 = sext i32 %13 to i64
  store i64 0, ptr %match_stmt_discard25, align 8
  br label %match_end24

march_next40:                                     ; preds = %march_next27
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %tag23, ptr @mu_file.4, i64 18)
  unreachable

match_end58:                                      ; preds = %march_arm73, %march_arm60
  %r277 = load ptr, ptr %r254, align 8
  %tag_ptr78 = getelementptr inbounds nuw %Result, ptr %r277, i32 0, i32 0
  %tag79 = load i64, ptr %tag_ptr78, align 8
  %tag_eq84 = icmp eq i64 %tag79, 5862623
  br i1 %tag_eq84, label %march_arm82, label %march_next83

march_arm60:                                      ; preds = %match_end24
  %pay_slot63 = getelementptr inbounds nuw %Result, ptr %r155, i32 0, i32 1
  %payload64 = load ptr, ptr %pay_slot63, align 8
  %v_slot_base65 = ptrtoint ptr %payload64 to i64
  %v_slot_addr66 = add i64 %v_slot_base65, 0
  %v_slot67 = inttoptr i64 %v_slot_addr66 to ptr
  %v68 = load i64, ptr %v_slot67, align 8
  store i64 %v68, ptr %v69, align 8
  %v70 = load i64, ptr %v69, align 8
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.5, i64 %v70)
  %widen71 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen72 = sext i32 %16 to i64
  store i64 0, ptr %match_stmt_discard59, align 8
  br label %match_end58

march_next61:                                     ; preds = %match_end24
  %tag_eq75 = icmp eq i64 %tag57, 193456014
  br i1 %tag_eq75, label %march_arm73, label %march_next74

march_arm73:                                      ; preds = %march_next61
  %17 = call i32 @puts(ptr @.str.6)
  %widen76 = sext i32 %17 to i64
  store i64 0, ptr %match_stmt_discard59, align 8
  br label %match_end58

march_next74:                                     ; preds = %march_next61
  call void @avra_match_unreachable(ptr @.match_fn.7, i64 %tag57, ptr @mu_file.8, i64 25)
  unreachable

match_end80:                                      ; preds = %march_arm95, %march_arm82
  %18 = call i32 @avra_test_summary()
  %widen99 = sext i32 %18 to i64
  call void @avra_rc_collect()
  ret i64 0

march_arm82:                                      ; preds = %match_end58
  %pay_slot85 = getelementptr inbounds nuw %Result, ptr %r277, i32 0, i32 1
  %payload86 = load ptr, ptr %pay_slot85, align 8
  %v_slot_base87 = ptrtoint ptr %payload86 to i64
  %v_slot_addr88 = add i64 %v_slot_base87, 0
  %v_slot89 = inttoptr i64 %v_slot_addr88 to ptr
  %v90 = load i64, ptr %v_slot89, align 8
  store i64 %v90, ptr %v91, align 8
  %v92 = load i64, ptr %v91, align 8
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.9, i64 %v92)
  %widen93 = sext i32 %20 to i64
  %21 = call i32 @puts(ptr %19)
  %widen94 = sext i32 %21 to i64
  store i64 0, ptr %match_stmt_discard81, align 8
  br label %match_end80

march_next83:                                     ; preds = %match_end58
  %tag_eq97 = icmp eq i64 %tag79, 193456014
  br i1 %tag_eq97, label %march_arm95, label %march_next96

march_arm95:                                      ; preds = %march_next83
  %22 = call i32 @puts(ptr @.str.10)
  %widen98 = sext i32 %22 to i64
  store i64 0, ptr %match_stmt_discard81, align 8
  br label %match_end80

march_next96:                                     ; preds = %march_next83
  call void @avra_match_unreachable(ptr @.match_fn.11, i64 %tag79, ptr @mu_file.12, i64 29)
  unreachable
}
