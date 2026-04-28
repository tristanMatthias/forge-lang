; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Color = type { i64, ptr }
%AB = type { i64, ptr }
%Maybe = type { i64, ptr }

@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"blue\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/exhaustive_match.av\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"matched A\00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c"matched other\00", align 1
@.match_fn.5 = private unnamed_addr constant [14 x i8] c"test_wildcard\00", align 1
@mu_file.6 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/exhaustive_match.av\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"got value\00", align 1
@.str.8 = private unnamed_addr constant [8 x i8] c"nothing\00", align 1
@.match_fn.9 = private unnamed_addr constant [10 x i8] c"test_expr\00", align 1
@mu_file.10 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/exhaustive_match.av\00", align 1

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

define i64 @test_wildcard(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %x = alloca ptr, align 8
  store ptr %0, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %tag_ptr = getelementptr inbounds nuw %AB, ptr %x1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 177638
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %1 = call i32 @puts(ptr @.str.3)
  %widen = sext i32 %1 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  br label %march_arm2

march_arm2:                                       ; preds = %march_next
  %2 = call i32 @puts(ptr @.str.4)
  %widen4 = sext i32 %2 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 19)
  unreachable
}

define ptr @test_expr(ptr %0) {
entry:
  %result = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %m = alloca ptr, align 8
  store ptr %0, ptr %m, align 8
  %m1 = load ptr, ptr %m, align 8
  %tag_ptr = getelementptr inbounds nuw %Maybe, ptr %m1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384548249
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  store ptr %cast, ptr %result, align 8
  %result5 = load ptr, ptr %result, align 8
  ret ptr %result5

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Maybe, ptr %m1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  br label %march_arm3

march_arm3:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.9, i64 %tag, ptr @mu_file.10, i64 28)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %AB, ptr %1, i32 0, i32 0
  store i64 177638, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %AB, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %2 = call i64 @test_wildcard(ptr %cast1)
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %AB, ptr %3, i32 0, i32 0
  store i64 177639, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %AB, ptr %3, i32 0, i32 1
  store ptr null, ptr %pay_ptr3, align 8
  %cast4 = ptrtoint ptr %3 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  %4 = call i64 @test_wildcard(ptr %cast5)
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %Maybe, ptr %5, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %Maybe, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr7, align 8
  %slot_base = ptrtoint ptr %6 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast8 = ptrtoint ptr %5 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  %7 = call ptr @test_expr(ptr %cast9)
  %8 = call i32 @puts(ptr %7)
  %widen = sext i32 %8 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
