; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Handler = type { ptr }
%Color = type { i64, ptr }

@h = global i64 0
@.match_fn = private unnamed_addr constant [11 x i8] c"__lambda_0\00", align 1
@mu_file = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/closures/tests/match_in_lambda.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %0 = call ptr @avra_rc_alloc(i64 8)
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %1 to i64
  %fld_ptr = getelementptr inbounds nuw %Handler, ptr %0, i32 0, i32 0
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %fld_ptr, align 8
  %cast2 = ptrtoint ptr %0 to i64
  store i64 %cast2, ptr @h, align 8
  %h = load ptr, ptr @h, align 8
  %fn_field_ptr = getelementptr inbounds nuw %Handler, ptr %h, i32 0, i32 0
  %fn_field_val = load i64, ptr %fn_field_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %2, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %2, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast3 = ptrtoint ptr %2 to i64
  %3 = call i64 @avra_closure_call_2(i64 %fn_field_val, i64 5, i64 %cast3)
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %3)
  %widen = sext i32 %5 to i64
  %6 = call i32 @puts(ptr %4)
  %widen4 = sext i32 %6 to i64
  %h5 = load ptr, ptr @h, align 8
  %fn_field_ptr6 = getelementptr inbounds nuw %Handler, ptr %h5, i32 0, i32 0
  %fn_field_val7 = load i64, ptr %fn_field_ptr6, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr8 = getelementptr inbounds nuw %Color, ptr %7, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr8, align 8
  %pay_ptr9 = getelementptr inbounds nuw %Color, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr9, align 8
  %cast10 = ptrtoint ptr %7 to i64
  %8 = call i64 @avra_closure_call_2(i64 %fn_field_val7, i64 5, i64 %cast10)
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.1, i64 %8)
  %widen11 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen12 = sext i32 %11 to i64
  %h13 = load ptr, ptr @h, align 8
  %fn_field_ptr14 = getelementptr inbounds nuw %Handler, ptr %h13, i32 0, i32 0
  %fn_field_val15 = load i64, ptr %fn_field_ptr14, align 8
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr16 = getelementptr inbounds nuw %Color, ptr %12, i32 0, i32 0
  store i64 6383934317, ptr %tag_ptr16, align 8
  %pay_ptr17 = getelementptr inbounds nuw %Color, ptr %12, i32 0, i32 1
  store ptr null, ptr %pay_ptr17, align 8
  %cast18 = ptrtoint ptr %12 to i64
  %13 = call i64 @avra_closure_call_2(i64 %fn_field_val15, i64 5, i64 %cast18)
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.2, i64 %13)
  %widen19 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen20 = sext i32 %16 to i64
  %17 = call i32 @avra_test_summary()
  %widen21 = sext i32 %17 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Handler(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_action_ptr = getelementptr inbounds nuw %Handler, ptr %0, i32 0, i32 0
  %rel_action = load ptr, ptr %rel_action_ptr, align 8
  %is_null_action = icmp eq ptr %rel_action, null
  br i1 %is_null_action, label %rel_action_skip, label %rel_action_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_action_skip
  ret i64 0

rel_action_skip:                                  ; preds = %rel_action_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_action_do:                                    ; preds = %do_free
  call void @avra_rc_release(ptr %rel_action)
  br label %rel_action_skip
}

define i64 @__lambda_0(i64 %0, ptr %1) {
entry:
  %match_result = alloca i64, align 8
  %c = alloca ptr, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  store ptr %1, ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %c1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193469728
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm8, %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  %mul = mul i64 %n2, 10
  store i64 %mul, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 210675960374
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %n6 = load i64, ptr %n, align 8
  %mul7 = mul i64 %n6, 20
  store i64 %mul7, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  %tag_eq10 = icmp eq i64 %tag, 6383934317
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_arm8:                                       ; preds = %march_next4
  %n11 = load i64, ptr %n, align 8
  %mul12 = mul i64 %n11, 30
  store i64 %mul12, ptr %match_result, align 8
  br label %match_end

march_next9:                                      ; preds = %march_next4
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 6)
  unreachable
}
