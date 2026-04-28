; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%IkColor = type { i64, ptr }
%IkOption = type { i64, ptr }

@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"blue\00", align 1
@spec_str = private unnamed_addr constant [13 x i8] c"\22is keyword\22\00", align 1
@spec_str.3 = private unnamed_addr constant [14 x i8] c"\22is red true\22\00", align 1
@spec_str.4 = private unnamed_addr constant [16 x i8] c"\22is blue false\22\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"red\00", align 1
@spec_str.6 = private unnamed_addr constant [15 x i8] c"\22describe red\22\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@spec_str.8 = private unnamed_addr constant [17 x i8] c"\22describe green\22\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"blue\00", align 1
@spec_str.10 = private unnamed_addr constant [16 x i8] c"\22describe blue\22\00", align 1
@spec_str.11 = private unnamed_addr constant [26 x i8] c"\22payload variant is some\22\00", align 1
@spec_str.12 = private unnamed_addr constant [15 x i8] c"\22none is none\22\00", align 1
@spec_str.13 = private unnamed_addr constant [19 x i8] c"\22none is not some\22\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@spec_str.15 = private unnamed_addr constant [21 x i8] c"\22is in logical expr\22\00", align 1

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare void @forge_test_flush()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

define ptr @ik_describe(ptr %0) {
entry:
  %col = alloca ptr, align 8
  store ptr %0, ptr %col, align 8
  %col1 = load ptr, ptr %col, align 8
  %tag_ptr = getelementptr inbounds nuw %IkColor, ptr %col1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 210678059956
  %is_eq_ext = zext i1 %is_eq to i64
  %if_cond = icmp ne i64 %is_eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %col2 = load ptr, ptr %col, align 8
  %tag_ptr3 = getelementptr inbounds nuw %IkColor, ptr %col2, i32 0, i32 0
  %tag4 = load i64, ptr %tag_ptr3, align 8
  %is_eq5 = icmp eq i64 %tag4, 229428394718666
  %is_eq_ext6 = zext i1 %is_eq5 to i64
  %if_cond8 = icmp ne i64 %is_eq_ext6, 0
  br i1 %if_cond8, label %if_then9, label %if_else10

if_then:                                          ; preds = %entry
  ret ptr @.str

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont7:                                          ; preds = %if_else10
  ret ptr @.str.2

if_then9:                                         ; preds = %ifcont
  ret ptr @.str.1

if_else10:                                        ; preds = %ifcont
  br label %ifcont7
}

define i1 @ik_is_red(ptr %0) {
entry:
  %col = alloca ptr, align 8
  store ptr %0, ptr %col, align 8
  %col1 = load ptr, ptr %col, align 8
  %tag_ptr = getelementptr inbounds nuw %IkColor, ptr %col1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 210678059956
  %is_eq_ext = zext i1 %is_eq to i64
  %cast = trunc i64 %is_eq_ext to i1
  ret i1 %cast
}

define i1 @ik_is_blue(ptr %0) {
entry:
  %col = alloca ptr, align 8
  store ptr %0, ptr %col, align 8
  %col1 = load ptr, ptr %col, align 8
  %tag_ptr = getelementptr inbounds nuw %IkColor, ptr %col1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 6952375411841
  %is_eq_ext = zext i1 %is_eq to i64
  %cast = trunc i64 %is_eq_ext to i1
  ret i1 %cast
}

define i1 @ik_is_some(ptr %0) {
entry:
  %o = alloca ptr, align 8
  store ptr %0, ptr %o, align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %IkOption, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 6952376025773
  %is_eq_ext = zext i1 %is_eq to i64
  %cast = trunc i64 %is_eq_ext to i1
  ret i1 %cast
}

define i1 @ik_is_none(ptr %0) {
entry:
  %o = alloca ptr, align 8
  store ptr %0, ptr %o, align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %IkOption, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 6952375846121
  %is_eq_ext = zext i1 %is_eq to i64
  %cast = trunc i64 %is_eq_ext to i1
  ret i1 %cast
}

define i64 @main() {
entry:
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %IkColor, ptr %1, i32 0, i32 0
  store i64 210678059956, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %IkColor, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %2 = call i1 @ik_is_red(ptr %cast1)
  %widen2 = zext i1 %2 to i64
  %3 = call i64 @forge_test_run_then(ptr @spec_str.3, i64 %widen2)
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %IkColor, ptr %4, i32 0, i32 0
  store i64 210678059956, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %IkColor, ptr %4, i32 0, i32 1
  store ptr null, ptr %pay_ptr4, align 8
  %cast5 = ptrtoint ptr %4 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  %5 = call i1 @ik_is_blue(ptr %cast6)
  %widen7 = zext i1 %5 to i64
  %not_cmp = icmp eq i64 %widen7, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.4, i64 %not_cmp_ext)
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr8 = getelementptr inbounds nuw %IkColor, ptr %7, i32 0, i32 0
  store i64 210678059956, ptr %tag_ptr8, align 8
  %pay_ptr9 = getelementptr inbounds nuw %IkColor, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr9, align 8
  %cast10 = ptrtoint ptr %7 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  %8 = call ptr @ik_describe(ptr %cast11)
  %9 = call i32 @strcmp(ptr %8, ptr @.str.5)
  %widen12 = sext i32 %9 to i64
  %streq_cmp = icmp eq i64 %widen12, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %10 = call i64 @forge_test_run_then(ptr @spec_str.6, i64 %streq_ext)
  %11 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr13 = getelementptr inbounds nuw %IkColor, ptr %11, i32 0, i32 0
  store i64 229428394718666, ptr %tag_ptr13, align 8
  %pay_ptr14 = getelementptr inbounds nuw %IkColor, ptr %11, i32 0, i32 1
  store ptr null, ptr %pay_ptr14, align 8
  %cast15 = ptrtoint ptr %11 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  %12 = call ptr @ik_describe(ptr %cast16)
  %13 = call i32 @strcmp(ptr %12, ptr @.str.7)
  %widen17 = sext i32 %13 to i64
  %streq_cmp18 = icmp eq i64 %widen17, 0
  %streq_ext19 = zext i1 %streq_cmp18 to i64
  %14 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %streq_ext19)
  %15 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr20 = getelementptr inbounds nuw %IkColor, ptr %15, i32 0, i32 0
  store i64 6952375411841, ptr %tag_ptr20, align 8
  %pay_ptr21 = getelementptr inbounds nuw %IkColor, ptr %15, i32 0, i32 1
  store ptr null, ptr %pay_ptr21, align 8
  %cast22 = ptrtoint ptr %15 to i64
  %cast23 = inttoptr i64 %cast22 to ptr
  %16 = call ptr @ik_describe(ptr %cast23)
  %17 = call i32 @strcmp(ptr %16, ptr @.str.9)
  %widen24 = sext i32 %17 to i64
  %streq_cmp25 = icmp eq i64 %widen24, 0
  %streq_ext26 = zext i1 %streq_cmp25 to i64
  %18 = call i64 @forge_test_run_then(ptr @spec_str.10, i64 %streq_ext26)
  %19 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr27 = getelementptr inbounds nuw %IkOption, ptr %19, i32 0, i32 0
  store i64 6952376025773, ptr %tag_ptr27, align 8
  %pay_ptr28 = getelementptr inbounds nuw %IkOption, ptr %19, i32 0, i32 1
  %20 = call ptr @forge_rc_alloc(i64 8)
  store ptr %20, ptr %pay_ptr28, align 8
  %slot_base = ptrtoint ptr %20 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast29 = ptrtoint ptr %19 to i64
  %cast30 = inttoptr i64 %cast29 to ptr
  %21 = call i1 @ik_is_some(ptr %cast30)
  %widen31 = zext i1 %21 to i64
  %22 = call i64 @forge_test_run_then(ptr @spec_str.11, i64 %widen31)
  %23 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr32 = getelementptr inbounds nuw %IkOption, ptr %23, i32 0, i32 0
  store i64 6952375846121, ptr %tag_ptr32, align 8
  %pay_ptr33 = getelementptr inbounds nuw %IkOption, ptr %23, i32 0, i32 1
  store ptr null, ptr %pay_ptr33, align 8
  %cast34 = ptrtoint ptr %23 to i64
  %cast35 = inttoptr i64 %cast34 to ptr
  %24 = call i1 @ik_is_none(ptr %cast35)
  %widen36 = zext i1 %24 to i64
  %25 = call i64 @forge_test_run_then(ptr @spec_str.12, i64 %widen36)
  %26 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr37 = getelementptr inbounds nuw %IkOption, ptr %26, i32 0, i32 0
  store i64 6952375846121, ptr %tag_ptr37, align 8
  %pay_ptr38 = getelementptr inbounds nuw %IkOption, ptr %26, i32 0, i32 1
  store ptr null, ptr %pay_ptr38, align 8
  %cast39 = ptrtoint ptr %26 to i64
  %cast40 = inttoptr i64 %cast39 to ptr
  %27 = call i1 @ik_is_some(ptr %cast40)
  %widen41 = zext i1 %27 to i64
  %not_cmp42 = icmp eq i64 %widen41, 0
  %not_cmp_ext43 = zext i1 %not_cmp42 to i64
  %28 = call i64 @forge_test_run_then(ptr @spec_str.13, i64 %not_cmp_ext43)
  %29 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr44 = getelementptr inbounds nuw %IkColor, ptr %29, i32 0, i32 0
  store i64 229428394718666, ptr %tag_ptr44, align 8
  %pay_ptr45 = getelementptr inbounds nuw %IkColor, ptr %29, i32 0, i32 1
  store ptr null, ptr %pay_ptr45, align 8
  %cast46 = ptrtoint ptr %29 to i64
  %cast47 = inttoptr i64 %cast46 to ptr
  %30 = call i1 @ik_is_red(ptr %cast47)
  %widen48 = zext i1 %30 to i64
  %l_bool = icmp ne i64 %widen48, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

sc_rhs:                                           ; preds = %entry
  %31 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr49 = getelementptr inbounds nuw %IkColor, ptr %31, i32 0, i32 0
  store i64 229428394718666, ptr %tag_ptr49, align 8
  %pay_ptr50 = getelementptr inbounds nuw %IkColor, ptr %31, i32 0, i32 1
  store ptr null, ptr %pay_ptr50, align 8
  %cast51 = ptrtoint ptr %31 to i64
  %cast52 = inttoptr i64 %cast51 to ptr
  %32 = call i1 @ik_is_blue(ptr %cast52)
  %widen53 = zext i1 %32 to i64
  %r_bool = icmp ne i64 %widen53, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ true, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %l_bool54 = icmp ne i64 %sc_ext, 0
  br i1 %l_bool54, label %sc_short56, label %sc_rhs55

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

sc_rhs55:                                         ; preds = %sc_merge
  %33 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr58 = getelementptr inbounds nuw %IkColor, ptr %33, i32 0, i32 0
  store i64 229428394718666, ptr %tag_ptr58, align 8
  %pay_ptr59 = getelementptr inbounds nuw %IkColor, ptr %33, i32 0, i32 1
  store ptr null, ptr %pay_ptr59, align 8
  %cast60 = ptrtoint ptr %33 to i64
  %cast61 = inttoptr i64 %cast60 to ptr
  %34 = call ptr @ik_describe(ptr %cast61)
  %35 = call i32 @strcmp(ptr %34, ptr @.str.14)
  %widen62 = sext i32 %35 to i64
  %streq_cmp63 = icmp eq i64 %widen62, 0
  %streq_ext64 = zext i1 %streq_cmp63 to i64
  %r_bool65 = icmp ne i64 %streq_ext64, 0
  br i1 %r_bool65, label %sc_r_true66, label %sc_r_false67

sc_short56:                                       ; preds = %sc_merge
  br label %sc_merge57

sc_merge57:                                       ; preds = %sc_r_merge68, %sc_short56
  %sc_phi69 = phi i1 [ true, %sc_short56 ], [ %r_bool65, %sc_r_merge68 ]
  %sc_ext70 = zext i1 %sc_phi69 to i64
  %36 = call i64 @forge_test_run_then(ptr @spec_str.15, i64 %sc_ext70)
  %37 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen71 = sext i32 %37 to i64
  %38 = call i32 @forge_test_summary()
  %widen72 = sext i32 %38 to i64
  call void @forge_rc_collect()
  ret i64 0

sc_r_true66:                                      ; preds = %sc_rhs55
  br label %sc_r_merge68

sc_r_false67:                                     ; preds = %sc_rhs55
  br label %sc_r_merge68

sc_r_merge68:                                     ; preds = %sc_r_false67, %sc_r_true66
  br label %sc_merge57
}
