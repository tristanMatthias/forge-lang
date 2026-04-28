; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%HasName = type { ptr }
%Tree = type { i64, ptr }
%Person = type { ptr, i64 }
%Tree__Branch = type { ptr, ptr }

@.str = private unnamed_addr constant [9 x i8] c"custom: \00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"HasName\00", align 1
@src_file = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/type_system_edge_cases.av\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"sum_tree\00", align 1
@mu_file = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/type_system_edge_cases.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@.str.7 = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.8 = private unnamed_addr constant [9 x i8] c"fallback\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @greet(ptr %0) {
entry:
  %x = alloca ptr, align 8
  store ptr %0, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %cast = ptrtoint ptr %x1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 108, i64 17)
  %name_ptr = getelementptr inbounds nuw %HasName, ptr %x1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr @.str)
  %2 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %name, i64 %rhs_len_p1)
  ret ptr %3
}

define i64 @apply(ptr %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %f = alloca ptr, align 8
  store ptr %0, ptr %f, align 8
  store i64 %1, ptr %x, align 8
  %f1 = load i64, ptr %f, align 8
  %x2 = load i64, ptr %x, align 8
  %2 = call i64 @avra_closure_call_1(i64 %f1, i64 %x2)
  ret i64 %2
}

define i64 @sum_tree(ptr %0) {
entry:
  %right12 = alloca ptr, align 8
  %left9 = alloca ptr, align 8
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
  %left_slot_base = ptrtoint ptr %payload8 to i64
  %left_slot_addr = add i64 %left_slot_base, 0
  %left_slot = inttoptr i64 %left_slot_addr to ptr
  %left = load ptr, ptr %left_slot, align 8
  call void @avra_rc_retain(ptr %left)
  store ptr %left, ptr %left9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %right_slot_base = ptrtoint ptr %payload11 to i64
  %right_slot_addr = add i64 %right_slot_base, 8
  %right_slot = inttoptr i64 %right_slot_addr to ptr
  %right = load ptr, ptr %right_slot, align 8
  call void @avra_rc_retain(ptr %right)
  store ptr %right, ptr %right12, align 8
  %left13 = load ptr, ptr %left9, align 8
  %1 = call i64 @sum_tree(ptr %left13)
  %right14 = load ptr, ptr %right12, align 8
  %2 = call i64 @sum_tree(ptr %right14)
  %add = add i64 %1, %2
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 32)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %tree = alloca ptr, align 8
  %label = alloca ptr, align 8
  %when_result = alloca i64, align 8
  %x = alloca i64, align 8
  %uid = alloca i64, align 8
  %p = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 42)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen1 = sext i32 %3 to i64
  %4 = call i32 @puts(ptr @.str.1)
  %widen2 = sext i32 %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.2, i64 1)
  %widen3 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen4 = sext i32 %7 to i64
  %8 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %8 to double
  %cast5 = bitcast double %cast to i64
  %9 = call i64 @avra_float_to_string(i64 %cast5)
  %cast6 = inttoptr i64 %9 to ptr
  %10 = call i32 @puts(ptr %cast6)
  %widen7 = sext i32 %10 to i64
  %11 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Person, ptr %11, i32 0, i32 0
  store ptr @.str.3, ptr %fld_ptr, align 8
  %fld_ptr8 = getelementptr inbounds nuw %Person, ptr %11, i32 0, i32 1
  store i64 25, ptr %fld_ptr8, align 8
  %cast9 = ptrtoint ptr %11 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  store ptr %cast10, ptr %p, align 8
  %p11 = load ptr, ptr %p, align 8
  %12 = call ptr @greet(ptr %p11)
  %13 = call i32 @puts(ptr %12)
  %widen12 = sext i32 %13 to i64
  store i64 99, ptr %uid, align 8
  %uid13 = load i64, ptr %uid, align 8
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.4, i64 %uid13)
  %widen14 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen15 = sext i32 %16 to i64
  %17 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %17, i64 -559038737)
  call void @avra_array_push(ptr %17, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast16 = ptrtoint ptr %17 to i64
  %cast17 = inttoptr i64 %cast16 to ptr
  %18 = call i64 @apply(ptr %cast17, i64 5)
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.5, i64 %18)
  %widen18 = sext i32 %20 to i64
  %21 = call i32 @puts(ptr %19)
  %widen19 = sext i32 %21 to i64
  store i64 0, ptr %x, align 8
  store i64 0, ptr %when_result, align 8
  %x20 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x20, 0
  %sgt_ext = zext i1 %sgt to i64
  %when_cond = icmp ne i64 %sgt_ext, 0
  br i1 %when_cond, label %when_arm, label %when_next

when_end:                                         ; preds = %when_next24, %when_arm23, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast25 = inttoptr i64 %when_val to ptr
  store ptr %cast25, ptr %label, align 8
  %label26 = load ptr, ptr %label, align 8
  %22 = call i32 @puts(ptr %label26)
  %widen27 = sext i32 %22 to i64
  %23 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %23, i32 0, i32 0
  store i64 6952110881171, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Tree, ptr %23, i32 0, i32 1
  %24 = call ptr @avra_rc_alloc(i64 16)
  store ptr %24, ptr %pay_ptr, align 8
  %25 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr28 = getelementptr inbounds nuw %Tree, ptr %25, i32 0, i32 0
  store i64 6952110881171, ptr %tag_ptr28, align 8
  %pay_ptr29 = getelementptr inbounds nuw %Tree, ptr %25, i32 0, i32 1
  %26 = call ptr @avra_rc_alloc(i64 16)
  store ptr %26, ptr %pay_ptr29, align 8
  %27 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr30 = getelementptr inbounds nuw %Tree, ptr %27, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr30, align 8
  %pay_ptr31 = getelementptr inbounds nuw %Tree, ptr %27, i32 0, i32 1
  %28 = call ptr @avra_rc_alloc(i64 8)
  store ptr %28, ptr %pay_ptr31, align 8
  %slot_base = ptrtoint ptr %28 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 1, ptr %slot, align 8
  %cast32 = ptrtoint ptr %27 to i64
  %slot_base33 = ptrtoint ptr %26 to i64
  %slot_addr34 = add i64 %slot_base33, 0
  %slot35 = inttoptr i64 %slot_addr34 to ptr
  %cast36 = inttoptr i64 %cast32 to ptr
  store ptr %cast36, ptr %slot35, align 8
  %29 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr37 = getelementptr inbounds nuw %Tree, ptr %29, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr37, align 8
  %pay_ptr38 = getelementptr inbounds nuw %Tree, ptr %29, i32 0, i32 1
  %30 = call ptr @avra_rc_alloc(i64 8)
  store ptr %30, ptr %pay_ptr38, align 8
  %slot_base39 = ptrtoint ptr %30 to i64
  %slot_addr40 = add i64 %slot_base39, 0
  %slot41 = inttoptr i64 %slot_addr40 to ptr
  store i64 2, ptr %slot41, align 8
  %cast42 = ptrtoint ptr %29 to i64
  %slot_base43 = ptrtoint ptr %26 to i64
  %slot_addr44 = add i64 %slot_base43, 8
  %slot45 = inttoptr i64 %slot_addr44 to ptr
  %cast46 = inttoptr i64 %cast42 to ptr
  store ptr %cast46, ptr %slot45, align 8
  %cast47 = ptrtoint ptr %25 to i64
  %slot_base48 = ptrtoint ptr %24 to i64
  %slot_addr49 = add i64 %slot_base48, 0
  %slot50 = inttoptr i64 %slot_addr49 to ptr
  %cast51 = inttoptr i64 %cast47 to ptr
  store ptr %cast51, ptr %slot50, align 8
  %31 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr52 = getelementptr inbounds nuw %Tree, ptr %31, i32 0, i32 0
  store i64 6952110881171, ptr %tag_ptr52, align 8
  %pay_ptr53 = getelementptr inbounds nuw %Tree, ptr %31, i32 0, i32 1
  %32 = call ptr @avra_rc_alloc(i64 16)
  store ptr %32, ptr %pay_ptr53, align 8
  %33 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr54 = getelementptr inbounds nuw %Tree, ptr %33, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr54, align 8
  %pay_ptr55 = getelementptr inbounds nuw %Tree, ptr %33, i32 0, i32 1
  %34 = call ptr @avra_rc_alloc(i64 8)
  store ptr %34, ptr %pay_ptr55, align 8
  %slot_base56 = ptrtoint ptr %34 to i64
  %slot_addr57 = add i64 %slot_base56, 0
  %slot58 = inttoptr i64 %slot_addr57 to ptr
  store i64 5, ptr %slot58, align 8
  %cast59 = ptrtoint ptr %33 to i64
  %slot_base60 = ptrtoint ptr %32 to i64
  %slot_addr61 = add i64 %slot_base60, 0
  %slot62 = inttoptr i64 %slot_addr61 to ptr
  %cast63 = inttoptr i64 %cast59 to ptr
  store ptr %cast63, ptr %slot62, align 8
  %35 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr64 = getelementptr inbounds nuw %Tree, ptr %35, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr64, align 8
  %pay_ptr65 = getelementptr inbounds nuw %Tree, ptr %35, i32 0, i32 1
  %36 = call ptr @avra_rc_alloc(i64 8)
  store ptr %36, ptr %pay_ptr65, align 8
  %slot_base66 = ptrtoint ptr %36 to i64
  %slot_addr67 = add i64 %slot_base66, 0
  %slot68 = inttoptr i64 %slot_addr67 to ptr
  store i64 7, ptr %slot68, align 8
  %cast69 = ptrtoint ptr %35 to i64
  %slot_base70 = ptrtoint ptr %32 to i64
  %slot_addr71 = add i64 %slot_base70, 8
  %slot72 = inttoptr i64 %slot_addr71 to ptr
  %cast73 = inttoptr i64 %cast69 to ptr
  store ptr %cast73, ptr %slot72, align 8
  %cast74 = ptrtoint ptr %31 to i64
  %slot_base75 = ptrtoint ptr %24 to i64
  %slot_addr76 = add i64 %slot_base75, 8
  %slot77 = inttoptr i64 %slot_addr76 to ptr
  %cast78 = inttoptr i64 %cast74 to ptr
  store ptr %cast78, ptr %slot77, align 8
  %cast79 = ptrtoint ptr %23 to i64
  %cast80 = inttoptr i64 %cast79 to ptr
  store ptr %cast80, ptr %tree, align 8
  %tree81 = load ptr, ptr %tree, align 8
  %37 = call i64 @sum_tree(ptr %tree81)
  %38 = call ptr @avra_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.9, i64 %37)
  %widen82 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen83 = sext i32 %40 to i64
  ret i64 0

when_arm:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %entry
  %x21 = load i64, ptr %x, align 8
  %slt = icmp slt i64 %x21, 0
  %slt_ext = zext i1 %slt to i64
  %when_cond22 = icmp ne i64 %slt_ext, 0
  br i1 %when_cond22, label %when_arm23, label %when_next24

when_arm23:                                       ; preds = %when_next
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %when_result, align 8
  br label %when_end

when_next24:                                      ; preds = %when_next
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %when_result, align 8
  br label %when_end
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Person(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Person, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}

define i64 @__release_HasName(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %HasName, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
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
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}
