; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Tree = type { i64, ptr }
%Tree__Branch = type { ptr, ptr }

@tree = global i64 0
@summer = global i64 0
@forest = global i64 0
@sums = global i64 0
@.match_fn = private unnamed_addr constant [9 x i8] c"tree_sum\00", align 1
@mu_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_closure.av\00", align 1
@.match_fn.1 = private unnamed_addr constant [11 x i8] c"tree_depth\00", align 1
@mu_file.2 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_closure.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c" + \00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.match_fn.5 = private unnamed_addr constant [15 x i8] c"tree_to_string\00", align 1
@mu_file.6 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_closure.av\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"sum=\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c"depth=\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @tree_sum(ptr %0) {
entry:
  %r12 = alloca ptr, align 8
  %l9 = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %t = alloca ptr, align 8
  store ptr %0, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384285405
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %v3 = load i64, ptr %v2, align 8
  store i64 %v3, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 6952110881171
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %l_slot_base = ptrtoint ptr %payload8 to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @avra_rc_retain(ptr %l)
  store ptr %l, ptr %l9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %r_slot_base = ptrtoint ptr %payload11 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @avra_rc_retain(ptr %r)
  store ptr %r, ptr %r12, align 8
  %l13 = load ptr, ptr %l9, align 8
  %1 = call i64 @tree_sum(ptr %l13)
  %r14 = load ptr, ptr %r12, align 8
  %2 = call i64 @tree_sum(ptr %r14)
  %add = add i64 %1, %2
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable
}

define i64 @tree_depth(ptr %0) {
entry:
  %ife_result = alloca i64, align 8
  %rd = alloca i64, align 8
  %ld = alloca i64, align 8
  %r8 = alloca ptr, align 8
  %l5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %t = alloca ptr, align 8
  store ptr %0, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384285405
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %ife_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  store i64 1, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6952110881171
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %l_slot_base = ptrtoint ptr %payload to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @avra_rc_retain(ptr %l)
  store ptr %l, ptr %l5, align 8
  %pay_slot6 = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %r_slot_base = ptrtoint ptr %payload7 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @avra_rc_retain(ptr %r)
  store ptr %r, ptr %r8, align 8
  %l9 = load ptr, ptr %l5, align 8
  %1 = call i64 @tree_depth(ptr %l9)
  store i64 %1, ptr %ld, align 8
  %r10 = load ptr, ptr %r8, align 8
  %2 = call i64 @tree_depth(ptr %r10)
  store i64 %2, ptr %rd, align 8
  %ld11 = load i64, ptr %ld, align 8
  %rd12 = load i64, ptr %rd, align 8
  %sgt = icmp sgt i64 %ld11, %rd12
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.1, i64 %tag, ptr @mu_file.2, i64 15)
  unreachable

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %add = add i64 1, %ife_val
  store i64 %add, ptr %match_result, align 8
  br label %match_end

ife_then:                                         ; preds = %march_arm2
  %ld13 = load i64, ptr %ld, align 8
  store i64 %ld13, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %march_arm2
  %rd14 = load i64, ptr %rd, align 8
  store i64 %rd14, ptr %ife_result, align 8
  br label %ife_end
}

define ptr @tree_to_string(ptr %0) {
entry:
  %r12 = alloca ptr, align 8
  %l9 = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %t = alloca ptr, align 8
  store ptr %0, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384285405
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast36 = inttoptr i64 %match_val to ptr
  ret ptr %cast36

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %v3 = load i64, ptr %v2, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %v3)
  %widen = sext i32 %2 to i64
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 6952110881171
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %l_slot_base = ptrtoint ptr %payload8 to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @avra_rc_retain(ptr %l)
  store ptr %l, ptr %l9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %r_slot_base = ptrtoint ptr %payload11 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @avra_rc_retain(ptr %r)
  store ptr %r, ptr %r12, align 8
  %l13 = load ptr, ptr %l9, align 8
  %3 = call ptr @tree_to_string(ptr %l13)
  %4 = call i64 @strlen(ptr @.str)
  %5 = call i64 @strlen(ptr %3)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr @.str, i64 %4)
  %cast14 = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast14, %4
  %cast15 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast15, ptr %3, i64 %rhs_len_p1)
  %9 = call i64 @strlen(ptr %6)
  %10 = call i64 @strlen(ptr @.str.3)
  %concat_total16 = add i64 %9, %10
  %concat_size17 = add i64 %concat_total16, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %12 = call ptr @memcpy(ptr %11, ptr %6, i64 %9)
  %cast18 = ptrtoint ptr %11 to i64
  %dst2_int19 = add i64 %cast18, %9
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast20, ptr @.str.3, i64 %rhs_len_p121)
  %r22 = load ptr, ptr %r12, align 8
  %14 = call ptr @tree_to_string(ptr %r22)
  %15 = call i64 @strlen(ptr %11)
  %16 = call i64 @strlen(ptr %14)
  %concat_total23 = add i64 %15, %16
  %concat_size24 = add i64 %concat_total23, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size24)
  %18 = call ptr @memcpy(ptr %17, ptr %11, i64 %15)
  %cast25 = ptrtoint ptr %17 to i64
  %dst2_int26 = add i64 %cast25, %15
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast27, ptr %14, i64 %rhs_len_p128)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.4)
  %concat_total29 = add i64 %20, %21
  %concat_size30 = add i64 %concat_total29, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size30)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast31 = ptrtoint ptr %22 to i64
  %dst2_int32 = add i64 %cast31, %20
  %cast33 = inttoptr i64 %dst2_int32 to ptr
  %rhs_len_p134 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast33, ptr @.str.4, i64 %rhs_len_p134)
  %cast35 = ptrtoint ptr %22 to i64
  store i64 %cast35, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 27)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %0, i32 0, i32 0
  store i64 6952110881171, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Tree, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 16)
  store ptr %1, ptr %pay_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Tree, ptr %2, i32 0, i32 0
  store i64 6952110881171, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Tree, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr2, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Tree, ptr %4, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Tree, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr4, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 1, ptr %slot, align 8
  %cast = ptrtoint ptr %4 to i64
  %slot_base5 = ptrtoint ptr %3 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  %cast8 = inttoptr i64 %cast to ptr
  store ptr %cast8, ptr %slot7, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr9 = getelementptr inbounds nuw %Tree, ptr %6, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr9, align 8
  %pay_ptr10 = getelementptr inbounds nuw %Tree, ptr %6, i32 0, i32 1
  %7 = call ptr @avra_rc_alloc(i64 8)
  store ptr %7, ptr %pay_ptr10, align 8
  %slot_base11 = ptrtoint ptr %7 to i64
  %slot_addr12 = add i64 %slot_base11, 0
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store i64 2, ptr %slot13, align 8
  %cast14 = ptrtoint ptr %6 to i64
  %slot_base15 = ptrtoint ptr %3 to i64
  %slot_addr16 = add i64 %slot_base15, 8
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  %cast18 = inttoptr i64 %cast14 to ptr
  store ptr %cast18, ptr %slot17, align 8
  %cast19 = ptrtoint ptr %2 to i64
  %slot_base20 = ptrtoint ptr %1 to i64
  %slot_addr21 = add i64 %slot_base20, 0
  %slot22 = inttoptr i64 %slot_addr21 to ptr
  %cast23 = inttoptr i64 %cast19 to ptr
  store ptr %cast23, ptr %slot22, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr24 = getelementptr inbounds nuw %Tree, ptr %8, i32 0, i32 0
  store i64 6952110881171, ptr %tag_ptr24, align 8
  %pay_ptr25 = getelementptr inbounds nuw %Tree, ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 16)
  store ptr %9, ptr %pay_ptr25, align 8
  %10 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %Tree, ptr %10, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %Tree, ptr %10, i32 0, i32 1
  %11 = call ptr @avra_rc_alloc(i64 8)
  store ptr %11, ptr %pay_ptr27, align 8
  %slot_base28 = ptrtoint ptr %11 to i64
  %slot_addr29 = add i64 %slot_base28, 0
  %slot30 = inttoptr i64 %slot_addr29 to ptr
  store i64 3, ptr %slot30, align 8
  %cast31 = ptrtoint ptr %10 to i64
  %slot_base32 = ptrtoint ptr %9 to i64
  %slot_addr33 = add i64 %slot_base32, 0
  %slot34 = inttoptr i64 %slot_addr33 to ptr
  %cast35 = inttoptr i64 %cast31 to ptr
  store ptr %cast35, ptr %slot34, align 8
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %Tree, ptr %12, i32 0, i32 0
  store i64 6952110881171, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %Tree, ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 16)
  store ptr %13, ptr %pay_ptr37, align 8
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %Tree, ptr %14, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %Tree, ptr %14, i32 0, i32 1
  %15 = call ptr @avra_rc_alloc(i64 8)
  store ptr %15, ptr %pay_ptr39, align 8
  %slot_base40 = ptrtoint ptr %15 to i64
  %slot_addr41 = add i64 %slot_base40, 0
  %slot42 = inttoptr i64 %slot_addr41 to ptr
  store i64 4, ptr %slot42, align 8
  %cast43 = ptrtoint ptr %14 to i64
  %slot_base44 = ptrtoint ptr %13 to i64
  %slot_addr45 = add i64 %slot_base44, 0
  %slot46 = inttoptr i64 %slot_addr45 to ptr
  %cast47 = inttoptr i64 %cast43 to ptr
  store ptr %cast47, ptr %slot46, align 8
  %16 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr48 = getelementptr inbounds nuw %Tree, ptr %16, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr48, align 8
  %pay_ptr49 = getelementptr inbounds nuw %Tree, ptr %16, i32 0, i32 1
  %17 = call ptr @avra_rc_alloc(i64 8)
  store ptr %17, ptr %pay_ptr49, align 8
  %slot_base50 = ptrtoint ptr %17 to i64
  %slot_addr51 = add i64 %slot_base50, 0
  %slot52 = inttoptr i64 %slot_addr51 to ptr
  store i64 5, ptr %slot52, align 8
  %cast53 = ptrtoint ptr %16 to i64
  %slot_base54 = ptrtoint ptr %13 to i64
  %slot_addr55 = add i64 %slot_base54, 8
  %slot56 = inttoptr i64 %slot_addr55 to ptr
  %cast57 = inttoptr i64 %cast53 to ptr
  store ptr %cast57, ptr %slot56, align 8
  %cast58 = ptrtoint ptr %12 to i64
  %slot_base59 = ptrtoint ptr %9 to i64
  %slot_addr60 = add i64 %slot_base59, 8
  %slot61 = inttoptr i64 %slot_addr60 to ptr
  %cast62 = inttoptr i64 %cast58 to ptr
  store ptr %cast62, ptr %slot61, align 8
  %cast63 = ptrtoint ptr %8 to i64
  %slot_base64 = ptrtoint ptr %1 to i64
  %slot_addr65 = add i64 %slot_base64, 8
  %slot66 = inttoptr i64 %slot_addr65 to ptr
  %cast67 = inttoptr i64 %cast63 to ptr
  store ptr %cast67, ptr %slot66, align 8
  %cast68 = ptrtoint ptr %0 to i64
  store i64 %cast68, ptr @tree, align 8
  %tree = load ptr, ptr @tree, align 8
  %18 = call ptr @tree_to_string(ptr %tree)
  %19 = call i32 @puts(ptr %18)
  %widen = sext i32 %19 to i64
  %tree69 = load ptr, ptr @tree, align 8
  %20 = call i64 @tree_sum(ptr %tree69)
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.8, i64 %20)
  %widen70 = sext i32 %22 to i64
  %23 = call i64 @strlen(ptr @.str.7)
  %24 = call i64 @strlen(ptr %21)
  %concat_total = add i64 %23, %24
  %concat_size = add i64 %concat_total, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size)
  %26 = call ptr @memcpy(ptr %25, ptr @.str.7, i64 %23)
  %cast71 = ptrtoint ptr %25 to i64
  %dst2_int = add i64 %cast71, %23
  %cast72 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast72, ptr %21, i64 %rhs_len_p1)
  %28 = call i32 @puts(ptr %25)
  %widen73 = sext i32 %28 to i64
  %tree74 = load ptr, ptr @tree, align 8
  %29 = call i64 @tree_depth(ptr %tree74)
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.10, i64 %29)
  %widen75 = sext i32 %31 to i64
  %32 = call i64 @strlen(ptr @.str.9)
  %33 = call i64 @strlen(ptr %30)
  %concat_total76 = add i64 %32, %33
  %concat_size77 = add i64 %concat_total76, 1
  %34 = call ptr @avra_rc_alloc(i64 %concat_size77)
  %35 = call ptr @memcpy(ptr %34, ptr @.str.9, i64 %32)
  %cast78 = ptrtoint ptr %34 to i64
  %dst2_int79 = add i64 %cast78, %32
  %cast80 = inttoptr i64 %dst2_int79 to ptr
  %rhs_len_p181 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast80, ptr %30, i64 %rhs_len_p181)
  %37 = call i32 @puts(ptr %34)
  %widen82 = sext i32 %37 to i64
  %38 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %38, i64 -559038737)
  call void @avra_array_push(ptr %38, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast83 = ptrtoint ptr %38 to i64
  store i64 %cast83, ptr @summer, align 8
  %summer = load i64, ptr @summer, align 8
  %cast84 = inttoptr i64 %summer to ptr
  %39 = call i64 @avra_array_get(ptr %cast84, i64 1)
  %fn_ptr = inttoptr i64 %39 to ptr
  %40 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr85 = getelementptr inbounds nuw %Tree, ptr %40, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr85, align 8
  %pay_ptr86 = getelementptr inbounds nuw %Tree, ptr %40, i32 0, i32 1
  %41 = call ptr @avra_rc_alloc(i64 8)
  store ptr %41, ptr %pay_ptr86, align 8
  %slot_base87 = ptrtoint ptr %41 to i64
  %slot_addr88 = add i64 %slot_base87, 0
  %slot89 = inttoptr i64 %slot_addr88 to ptr
  store i64 99, ptr %slot89, align 8
  %cast90 = ptrtoint ptr %40 to i64
  %closure_call = call i64 %fn_ptr(i64 %cast90)
  %42 = call ptr @avra_rc_alloc(i64 32)
  %43 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %42, i64 32, ptr @.i2s_fmt.11, i64 %closure_call)
  %widen91 = sext i32 %43 to i64
  %44 = call i32 @puts(ptr %42)
  %widen92 = sext i32 %44 to i64
  %45 = call ptr @avra_array_new()
  %46 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr93 = getelementptr inbounds nuw %Tree, ptr %46, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr93, align 8
  %pay_ptr94 = getelementptr inbounds nuw %Tree, ptr %46, i32 0, i32 1
  %47 = call ptr @avra_rc_alloc(i64 8)
  store ptr %47, ptr %pay_ptr94, align 8
  %slot_base95 = ptrtoint ptr %47 to i64
  %slot_addr96 = add i64 %slot_base95, 0
  %slot97 = inttoptr i64 %slot_addr96 to ptr
  store i64 10, ptr %slot97, align 8
  %cast98 = ptrtoint ptr %46 to i64
  call void @avra_array_push(ptr %45, i64 %cast98)
  %48 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr99 = getelementptr inbounds nuw %Tree, ptr %48, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr99, align 8
  %pay_ptr100 = getelementptr inbounds nuw %Tree, ptr %48, i32 0, i32 1
  %49 = call ptr @avra_rc_alloc(i64 8)
  store ptr %49, ptr %pay_ptr100, align 8
  %slot_base101 = ptrtoint ptr %49 to i64
  %slot_addr102 = add i64 %slot_base101, 0
  %slot103 = inttoptr i64 %slot_addr102 to ptr
  store i64 20, ptr %slot103, align 8
  %cast104 = ptrtoint ptr %48 to i64
  call void @avra_array_push(ptr %45, i64 %cast104)
  %50 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr105 = getelementptr inbounds nuw %Tree, ptr %50, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr105, align 8
  %pay_ptr106 = getelementptr inbounds nuw %Tree, ptr %50, i32 0, i32 1
  %51 = call ptr @avra_rc_alloc(i64 8)
  store ptr %51, ptr %pay_ptr106, align 8
  %slot_base107 = ptrtoint ptr %51 to i64
  %slot_addr108 = add i64 %slot_base107, 0
  %slot109 = inttoptr i64 %slot_addr108 to ptr
  store i64 30, ptr %slot109, align 8
  %cast110 = ptrtoint ptr %50 to i64
  call void @avra_array_push(ptr %45, i64 %cast110)
  store ptr %45, ptr @forest, align 8
  %forest = load ptr, ptr @forest, align 8
  %52 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %52, i64 -559038737)
  call void @avra_array_push(ptr %52, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast111 = ptrtoint ptr %52 to i64
  %53 = call ptr @avra_array_map(ptr %forest, i64 %cast111)
  store ptr %53, ptr @sums, align 8
  %sums = load ptr, ptr @sums, align 8
  %54 = call i64 @avra_array_get(ptr %sums, i64 0)
  %55 = call ptr @avra_rc_alloc(i64 32)
  %56 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %55, i64 32, ptr @.i2s_fmt.12, i64 %54)
  %widen112 = sext i32 %56 to i64
  %57 = call i32 @puts(ptr %55)
  %widen113 = sext i32 %57 to i64
  %sums114 = load ptr, ptr @sums, align 8
  %58 = call i64 @avra_array_get(ptr %sums114, i64 1)
  %59 = call ptr @avra_rc_alloc(i64 32)
  %60 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %59, i64 32, ptr @.i2s_fmt.13, i64 %58)
  %widen115 = sext i32 %60 to i64
  %61 = call i32 @puts(ptr %59)
  %widen116 = sext i32 %61 to i64
  %sums117 = load ptr, ptr @sums, align 8
  %62 = call i64 @avra_array_get(ptr %sums117, i64 2)
  %63 = call ptr @avra_rc_alloc(i64 32)
  %64 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %63, i64 32, ptr @.i2s_fmt.14, i64 %62)
  %widen118 = sext i32 %64 to i64
  %65 = call i32 @puts(ptr %63)
  %widen119 = sext i32 %65 to i64
  %66 = call i32 @avra_test_summary()
  %widen120 = sext i32 %66 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Tree(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Tree, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Branch = icmp eq i64 %tag, 6952110881171
  br i1 %is_Branch, label %rel_Branch, label %try_next_Branch

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Branch, %vrel_right_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Branch:                                       ; preds = %do_free
  %vrel_left_ptr = getelementptr inbounds nuw %Tree__Branch, ptr %payload, i32 0, i32 0
  %vrel_left = load ptr, ptr %vrel_left_ptr, align 8
  %vrel_null_left = icmp eq ptr %vrel_left, null
  br i1 %vrel_null_left, label %vrel_left_skip, label %vrel_left_do

try_next_Branch:                                  ; preds = %do_free
  br label %fields_done

vrel_left_skip:                                   ; preds = %vrel_left_do, %rel_Branch
  %vrel_right_ptr = getelementptr inbounds nuw %Tree__Branch, ptr %payload, i32 0, i32 1
  %vrel_right = load ptr, ptr %vrel_right_ptr, align 8
  %vrel_null_right = icmp eq ptr %vrel_right, null
  br i1 %vrel_null_right, label %vrel_right_skip, label %vrel_right_do

vrel_left_do:                                     ; preds = %rel_Branch
  %2 = call i64 @__release_Tree(ptr %vrel_left)
  br label %vrel_left_skip

vrel_right_skip:                                  ; preds = %vrel_right_do, %vrel_left_skip
  br label %fields_done

vrel_right_do:                                    ; preds = %vrel_left_skip
  %3 = call i64 @__release_Tree(ptr %vrel_right)
  br label %vrel_right_skip
}

define i64 @__lambda_0(i64 %0) {
entry:
  %t = alloca i64, align 8
  store i64 %0, ptr %t, align 8
  %t1 = load i64, ptr %t, align 8
  %cast = inttoptr i64 %t1 to ptr
  %1 = call i64 @tree_sum(ptr %cast)
  ret i64 %1
}

define i64 @__lambda_1(ptr %0) {
entry:
  %it = alloca ptr, align 8
  store ptr %0, ptr %it, align 8
  %it1 = load ptr, ptr %it, align 8
  %1 = call i64 @tree_sum(ptr %it1)
  ret i64 %1
}
