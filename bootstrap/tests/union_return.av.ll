; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%__union = type { i64, ptr }
%Wrapper = type { ptr }

@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_return.av\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.3 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.4 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_return.av\00", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"implicit: \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [11 x i8] c"implicit: \00", align 1
@.match_fn.8 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.9 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_return.av\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"mut int: \00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [13 x i8] c"mut string: \00", align 1
@.match_fn.13 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.14 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_return.av\00", align 1
@.str.15 = private unnamed_addr constant [11 x i8] c"reassigned\00", align 1
@.str.16 = private unnamed_addr constant [10 x i8] c"mut int: \00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.18 = private unnamed_addr constant [13 x i8] c"mut string: \00", align 1
@.match_fn.19 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.20 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_return.av\00", align 1
@fld_name = private unnamed_addr constant [4 x i8] c"val\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"Wrapper\00", align 1
@src_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_return.av\00", align 1
@.str.21 = private unnamed_addr constant [15 x i8] c"struct field: \00", align 1
@.i2s_fmt.22 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.23 = private unnamed_addr constant [15 x i8] c"struct field: \00", align 1
@.match_fn.24 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.25 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_return.av\00", align 1

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

define ptr @make(i1 %0) {
entry:
  %flag = alloca i1, align 1
  store i1 %0, ptr %flag, align 8
  %flag1 = load i1, ptr %flag, align 8
  br i1 %flag1, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %1 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr3 = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr3, align 8
  %2 = call ptr @avra_rc_alloc(i64 8)
  %slot_base4 = ptrtoint ptr %2 to i64
  %slot_addr5 = add i64 %slot_base4, 0
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store ptr @.str, ptr %slot6, align 8
  %union_pay_ptr7 = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 1
  store ptr %2, ptr %union_pay_ptr7, align 8
  %cast8 = ptrtoint ptr %1 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  ret ptr %cast9

if_then:                                          ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %3, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr, align 8
  %4 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %3, i32 0, i32 1
  store ptr %4, ptr %union_pay_ptr, align 8
  %cast = ptrtoint ptr %3 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  br label %ifcont
}

define ptr @implicit_return() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %0, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str.1, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %0, i32 0, i32 1
  store ptr %1, ptr %union_pay_ptr, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  ret ptr %cast1
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %s221 = alloca ptr, align 8
  %n202 = alloca i64, align 8
  %union_match_result191 = alloca i64, align 8
  %w = alloca ptr, align 8
  %s168 = alloca ptr, align 8
  %n149 = alloca i64, align 8
  %union_match_result138 = alloca i64, align 8
  %s118 = alloca ptr, align 8
  %n99 = alloca i64, align 8
  %union_match_result88 = alloca i64, align 8
  %u = alloca ptr, align 8
  %s71 = alloca ptr, align 8
  %n57 = alloca i64, align 8
  %union_match_result46 = alloca i64, align 8
  %s40 = alloca ptr, align 8
  %n27 = alloca i64, align 8
  %union_match_result16 = alloca i64, align 8
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %1 = call ptr @make(i1 true)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm3, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %2 = call ptr @make(i1 false)
  %union_tag_ptr14 = getelementptr inbounds nuw %__union, ptr %2, i32 0, i32 0
  %union_tag15 = load i64, ptr %union_tag_ptr14, align 8
  store i64 0, ptr %union_match_result16, align 8
  %union_tag_eq20 = icmp eq i64 %union_tag15, 193495088
  br i1 %union_tag_eq20, label %union_arm18, label %union_next19

union_arm:                                        ; preds = %entry
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %n1)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen2 = sext i32 %5 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq5 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq5, label %union_arm3, label %union_next4

union_arm3:                                       ; preds = %union_next
  %union_pay_ptr6 = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 1
  %union_payload7 = load ptr, ptr %union_pay_ptr6, align 8
  %union_val_slot_base8 = ptrtoint ptr %union_payload7 to i64
  %union_val_slot_addr9 = add i64 %union_val_slot_base8, 0
  %union_val_slot10 = inttoptr i64 %union_val_slot_addr9 to ptr
  %union_val11 = load ptr, ptr %union_val_slot10, align 8
  store ptr %union_val11, ptr %s, align 8
  %s12 = load ptr, ptr %s, align 8
  %6 = call i32 @puts(ptr %s12)
  %widen13 = sext i32 %6 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next4:                                      ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 25)
  unreachable

union_match_end17:                                ; preds = %union_arm31, %union_arm18
  %union_match_val43 = load i64, ptr %union_match_result16, align 8
  %7 = call ptr @implicit_return()
  %union_tag_ptr44 = getelementptr inbounds nuw %__union, ptr %7, i32 0, i32 0
  %union_tag45 = load i64, ptr %union_tag_ptr44, align 8
  store i64 0, ptr %union_match_result46, align 8
  %union_tag_eq50 = icmp eq i64 %union_tag45, 193495088
  br i1 %union_tag_eq50, label %union_arm48, label %union_next49

union_arm18:                                      ; preds = %union_match_end
  %union_pay_ptr21 = getelementptr inbounds nuw %__union, ptr %2, i32 0, i32 1
  %union_payload22 = load ptr, ptr %union_pay_ptr21, align 8
  %union_val_slot_base23 = ptrtoint ptr %union_payload22 to i64
  %union_val_slot_addr24 = add i64 %union_val_slot_base23, 0
  %union_val_slot25 = inttoptr i64 %union_val_slot_addr24 to ptr
  %union_val26 = load i64, ptr %union_val_slot25, align 8
  store i64 %union_val26, ptr %n27, align 8
  %n28 = load i64, ptr %n27, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.2, i64 %n28)
  %widen29 = sext i32 %9 to i64
  %10 = call i32 @puts(ptr %8)
  %widen30 = sext i32 %10 to i64
  store i64 0, ptr %union_match_result16, align 8
  br label %union_match_end17

union_next19:                                     ; preds = %union_match_end
  %union_tag_eq33 = icmp eq i64 %union_tag15, 6954031493116
  br i1 %union_tag_eq33, label %union_arm31, label %union_next32

union_arm31:                                      ; preds = %union_next19
  %union_pay_ptr34 = getelementptr inbounds nuw %__union, ptr %2, i32 0, i32 1
  %union_payload35 = load ptr, ptr %union_pay_ptr34, align 8
  %union_val_slot_base36 = ptrtoint ptr %union_payload35 to i64
  %union_val_slot_addr37 = add i64 %union_val_slot_base36, 0
  %union_val_slot38 = inttoptr i64 %union_val_slot_addr37 to ptr
  %union_val39 = load ptr, ptr %union_val_slot38, align 8
  store ptr %union_val39, ptr %s40, align 8
  %s41 = load ptr, ptr %s40, align 8
  %11 = call i32 @puts(ptr %s41)
  %widen42 = sext i32 %11 to i64
  store i64 0, ptr %union_match_result16, align 8
  br label %union_match_end17

union_next32:                                     ; preds = %union_next19
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %union_tag15, ptr @mu_file.4, i64 29)
  unreachable

union_match_end47:                                ; preds = %union_arm62, %union_arm48
  %union_match_val80 = load i64, ptr %union_match_result46, align 8
  %12 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr81 = getelementptr inbounds nuw %__union, ptr %12, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr81, align 8
  %13 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %13 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 10, ptr %slot, align 8
  %union_pay_ptr82 = getelementptr inbounds nuw %__union, ptr %12, i32 0, i32 1
  store ptr %13, ptr %union_pay_ptr82, align 8
  %cast83 = ptrtoint ptr %12 to i64
  %cast84 = inttoptr i64 %cast83 to ptr
  store ptr %cast84, ptr %u, align 8
  %u85 = load ptr, ptr %u, align 8
  %union_tag_ptr86 = getelementptr inbounds nuw %__union, ptr %u85, i32 0, i32 0
  %union_tag87 = load i64, ptr %union_tag_ptr86, align 8
  store i64 0, ptr %union_match_result88, align 8
  %union_tag_eq92 = icmp eq i64 %union_tag87, 193495088
  br i1 %union_tag_eq92, label %union_arm90, label %union_next91

union_arm48:                                      ; preds = %union_match_end17
  %union_pay_ptr51 = getelementptr inbounds nuw %__union, ptr %7, i32 0, i32 1
  %union_payload52 = load ptr, ptr %union_pay_ptr51, align 8
  %union_val_slot_base53 = ptrtoint ptr %union_payload52 to i64
  %union_val_slot_addr54 = add i64 %union_val_slot_base53, 0
  %union_val_slot55 = inttoptr i64 %union_val_slot_addr54 to ptr
  %union_val56 = load i64, ptr %union_val_slot55, align 8
  store i64 %union_val56, ptr %n57, align 8
  %n58 = load i64, ptr %n57, align 8
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.6, i64 %n58)
  %widen59 = sext i32 %15 to i64
  %16 = call i64 @strlen(ptr @.str.5)
  %17 = call i64 @strlen(ptr %14)
  %concat_total = add i64 %16, %17
  %concat_size = add i64 %concat_total, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size)
  %19 = call ptr @memcpy(ptr %18, ptr @.str.5, i64 %16)
  %cast = ptrtoint ptr %18 to i64
  %dst2_int = add i64 %cast, %16
  %cast60 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast60, ptr %14, i64 %rhs_len_p1)
  %21 = call i32 @puts(ptr %18)
  %widen61 = sext i32 %21 to i64
  store i64 0, ptr %union_match_result46, align 8
  br label %union_match_end47

union_next49:                                     ; preds = %union_match_end17
  %union_tag_eq64 = icmp eq i64 %union_tag45, 6954031493116
  br i1 %union_tag_eq64, label %union_arm62, label %union_next63

union_arm62:                                      ; preds = %union_next49
  %union_pay_ptr65 = getelementptr inbounds nuw %__union, ptr %7, i32 0, i32 1
  %union_payload66 = load ptr, ptr %union_pay_ptr65, align 8
  %union_val_slot_base67 = ptrtoint ptr %union_payload66 to i64
  %union_val_slot_addr68 = add i64 %union_val_slot_base67, 0
  %union_val_slot69 = inttoptr i64 %union_val_slot_addr68 to ptr
  %union_val70 = load ptr, ptr %union_val_slot69, align 8
  store ptr %union_val70, ptr %s71, align 8
  %s72 = load ptr, ptr %s71, align 8
  %22 = call i64 @strlen(ptr @.str.7)
  %23 = call i64 @strlen(ptr %s72)
  %concat_total73 = add i64 %22, %23
  %concat_size74 = add i64 %concat_total73, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size74)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.7, i64 %22)
  %cast75 = ptrtoint ptr %24 to i64
  %dst2_int76 = add i64 %cast75, %22
  %cast77 = inttoptr i64 %dst2_int76 to ptr
  %rhs_len_p178 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast77, ptr %s72, i64 %rhs_len_p178)
  %27 = call i32 @puts(ptr %24)
  %widen79 = sext i32 %27 to i64
  store i64 0, ptr %union_match_result46, align 8
  br label %union_match_end47

union_next63:                                     ; preds = %union_next49
  call void @avra_match_unreachable(ptr @.match_fn.8, i64 %union_tag45, ptr @mu_file.9, i64 35)
  unreachable

union_match_end89:                                ; preds = %union_arm109, %union_arm90
  %union_match_val127 = load i64, ptr %union_match_result88, align 8
  %28 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr128 = getelementptr inbounds nuw %__union, ptr %28, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr128, align 8
  %29 = call ptr @avra_rc_alloc(i64 8)
  %slot_base129 = ptrtoint ptr %29 to i64
  %slot_addr130 = add i64 %slot_base129, 0
  %slot131 = inttoptr i64 %slot_addr130 to ptr
  store ptr @.str.15, ptr %slot131, align 8
  %union_pay_ptr132 = getelementptr inbounds nuw %__union, ptr %28, i32 0, i32 1
  store ptr %29, ptr %union_pay_ptr132, align 8
  %cast133 = ptrtoint ptr %28 to i64
  %cast134 = inttoptr i64 %cast133 to ptr
  store ptr %cast134, ptr %u, align 8
  %u135 = load ptr, ptr %u, align 8
  %union_tag_ptr136 = getelementptr inbounds nuw %__union, ptr %u135, i32 0, i32 0
  %union_tag137 = load i64, ptr %union_tag_ptr136, align 8
  store i64 0, ptr %union_match_result138, align 8
  %union_tag_eq142 = icmp eq i64 %union_tag137, 193495088
  br i1 %union_tag_eq142, label %union_arm140, label %union_next141

union_arm90:                                      ; preds = %union_match_end47
  %union_pay_ptr93 = getelementptr inbounds nuw %__union, ptr %u85, i32 0, i32 1
  %union_payload94 = load ptr, ptr %union_pay_ptr93, align 8
  %union_val_slot_base95 = ptrtoint ptr %union_payload94 to i64
  %union_val_slot_addr96 = add i64 %union_val_slot_base95, 0
  %union_val_slot97 = inttoptr i64 %union_val_slot_addr96 to ptr
  %union_val98 = load i64, ptr %union_val_slot97, align 8
  store i64 %union_val98, ptr %n99, align 8
  %n100 = load i64, ptr %n99, align 8
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.11, i64 %n100)
  %widen101 = sext i32 %31 to i64
  %32 = call i64 @strlen(ptr @.str.10)
  %33 = call i64 @strlen(ptr %30)
  %concat_total102 = add i64 %32, %33
  %concat_size103 = add i64 %concat_total102, 1
  %34 = call ptr @avra_rc_alloc(i64 %concat_size103)
  %35 = call ptr @memcpy(ptr %34, ptr @.str.10, i64 %32)
  %cast104 = ptrtoint ptr %34 to i64
  %dst2_int105 = add i64 %cast104, %32
  %cast106 = inttoptr i64 %dst2_int105 to ptr
  %rhs_len_p1107 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast106, ptr %30, i64 %rhs_len_p1107)
  %37 = call i32 @puts(ptr %34)
  %widen108 = sext i32 %37 to i64
  store i64 0, ptr %union_match_result88, align 8
  br label %union_match_end89

union_next91:                                     ; preds = %union_match_end47
  %union_tag_eq111 = icmp eq i64 %union_tag87, 6954031493116
  br i1 %union_tag_eq111, label %union_arm109, label %union_next110

union_arm109:                                     ; preds = %union_next91
  %union_pay_ptr112 = getelementptr inbounds nuw %__union, ptr %u85, i32 0, i32 1
  %union_payload113 = load ptr, ptr %union_pay_ptr112, align 8
  %union_val_slot_base114 = ptrtoint ptr %union_payload113 to i64
  %union_val_slot_addr115 = add i64 %union_val_slot_base114, 0
  %union_val_slot116 = inttoptr i64 %union_val_slot_addr115 to ptr
  %union_val117 = load ptr, ptr %union_val_slot116, align 8
  store ptr %union_val117, ptr %s118, align 8
  %s119 = load ptr, ptr %s118, align 8
  %38 = call i64 @strlen(ptr @.str.12)
  %39 = call i64 @strlen(ptr %s119)
  %concat_total120 = add i64 %38, %39
  %concat_size121 = add i64 %concat_total120, 1
  %40 = call ptr @avra_rc_alloc(i64 %concat_size121)
  %41 = call ptr @memcpy(ptr %40, ptr @.str.12, i64 %38)
  %cast122 = ptrtoint ptr %40 to i64
  %dst2_int123 = add i64 %cast122, %38
  %cast124 = inttoptr i64 %dst2_int123 to ptr
  %rhs_len_p1125 = add i64 %39, 1
  %42 = call ptr @memcpy(ptr %cast124, ptr %s119, i64 %rhs_len_p1125)
  %43 = call i32 @puts(ptr %40)
  %widen126 = sext i32 %43 to i64
  store i64 0, ptr %union_match_result88, align 8
  br label %union_match_end89

union_next110:                                    ; preds = %union_next91
  call void @avra_match_unreachable(ptr @.match_fn.13, i64 %union_tag87, ptr @mu_file.14, i64 42)
  unreachable

union_match_end139:                               ; preds = %union_arm159, %union_arm140
  %union_match_val177 = load i64, ptr %union_match_result138, align 8
  %44 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Wrapper, ptr %44, i32 0, i32 0
  %45 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr178 = getelementptr inbounds nuw %__union, ptr %45, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr178, align 8
  %46 = call ptr @avra_rc_alloc(i64 8)
  %slot_base179 = ptrtoint ptr %46 to i64
  %slot_addr180 = add i64 %slot_base179, 0
  %slot181 = inttoptr i64 %slot_addr180 to ptr
  store i64 99, ptr %slot181, align 8
  %union_pay_ptr182 = getelementptr inbounds nuw %__union, ptr %45, i32 0, i32 1
  store ptr %46, ptr %union_pay_ptr182, align 8
  %cast183 = ptrtoint ptr %45 to i64
  %cast184 = inttoptr i64 %cast183 to ptr
  store ptr %cast184, ptr %fld_ptr, align 8
  %cast185 = ptrtoint ptr %44 to i64
  %cast186 = inttoptr i64 %cast185 to ptr
  store ptr %cast186, ptr %w, align 8
  %w187 = load ptr, ptr %w, align 8
  %cast188 = ptrtoint ptr %w187 to i64
  %null_chk = icmp eq i64 %cast188, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 98, i64 54)
  %val_ptr = getelementptr inbounds nuw %Wrapper, ptr %w187, i32 0, i32 0
  %val = load ptr, ptr %val_ptr, align 8
  %union_tag_ptr189 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 0
  %union_tag190 = load i64, ptr %union_tag_ptr189, align 8
  store i64 0, ptr %union_match_result191, align 8
  %union_tag_eq195 = icmp eq i64 %union_tag190, 193495088
  br i1 %union_tag_eq195, label %union_arm193, label %union_next194

union_arm140:                                     ; preds = %union_match_end89
  %union_pay_ptr143 = getelementptr inbounds nuw %__union, ptr %u135, i32 0, i32 1
  %union_payload144 = load ptr, ptr %union_pay_ptr143, align 8
  %union_val_slot_base145 = ptrtoint ptr %union_payload144 to i64
  %union_val_slot_addr146 = add i64 %union_val_slot_base145, 0
  %union_val_slot147 = inttoptr i64 %union_val_slot_addr146 to ptr
  %union_val148 = load i64, ptr %union_val_slot147, align 8
  store i64 %union_val148, ptr %n149, align 8
  %n150 = load i64, ptr %n149, align 8
  %47 = call ptr @avra_rc_alloc(i64 32)
  %48 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %47, i64 32, ptr @.i2s_fmt.17, i64 %n150)
  %widen151 = sext i32 %48 to i64
  %49 = call i64 @strlen(ptr @.str.16)
  %50 = call i64 @strlen(ptr %47)
  %concat_total152 = add i64 %49, %50
  %concat_size153 = add i64 %concat_total152, 1
  %51 = call ptr @avra_rc_alloc(i64 %concat_size153)
  %52 = call ptr @memcpy(ptr %51, ptr @.str.16, i64 %49)
  %cast154 = ptrtoint ptr %51 to i64
  %dst2_int155 = add i64 %cast154, %49
  %cast156 = inttoptr i64 %dst2_int155 to ptr
  %rhs_len_p1157 = add i64 %50, 1
  %53 = call ptr @memcpy(ptr %cast156, ptr %47, i64 %rhs_len_p1157)
  %54 = call i32 @puts(ptr %51)
  %widen158 = sext i32 %54 to i64
  store i64 0, ptr %union_match_result138, align 8
  br label %union_match_end139

union_next141:                                    ; preds = %union_match_end89
  %union_tag_eq161 = icmp eq i64 %union_tag137, 6954031493116
  br i1 %union_tag_eq161, label %union_arm159, label %union_next160

union_arm159:                                     ; preds = %union_next141
  %union_pay_ptr162 = getelementptr inbounds nuw %__union, ptr %u135, i32 0, i32 1
  %union_payload163 = load ptr, ptr %union_pay_ptr162, align 8
  %union_val_slot_base164 = ptrtoint ptr %union_payload163 to i64
  %union_val_slot_addr165 = add i64 %union_val_slot_base164, 0
  %union_val_slot166 = inttoptr i64 %union_val_slot_addr165 to ptr
  %union_val167 = load ptr, ptr %union_val_slot166, align 8
  store ptr %union_val167, ptr %s168, align 8
  %s169 = load ptr, ptr %s168, align 8
  %55 = call i64 @strlen(ptr @.str.18)
  %56 = call i64 @strlen(ptr %s169)
  %concat_total170 = add i64 %55, %56
  %concat_size171 = add i64 %concat_total170, 1
  %57 = call ptr @avra_rc_alloc(i64 %concat_size171)
  %58 = call ptr @memcpy(ptr %57, ptr @.str.18, i64 %55)
  %cast172 = ptrtoint ptr %57 to i64
  %dst2_int173 = add i64 %cast172, %55
  %cast174 = inttoptr i64 %dst2_int173 to ptr
  %rhs_len_p1175 = add i64 %56, 1
  %59 = call ptr @memcpy(ptr %cast174, ptr %s169, i64 %rhs_len_p1175)
  %60 = call i32 @puts(ptr %57)
  %widen176 = sext i32 %60 to i64
  store i64 0, ptr %union_match_result138, align 8
  br label %union_match_end139

union_next160:                                    ; preds = %union_next141
  call void @avra_match_unreachable(ptr @.match_fn.19, i64 %union_tag137, ptr @mu_file.20, i64 47)
  unreachable

union_match_end192:                               ; preds = %union_arm212, %union_arm193
  %union_match_val230 = load i64, ptr %union_match_result191, align 8
  %w_cleanup = load ptr, ptr %w, align 8
  %61 = call i64 @__release_Wrapper(ptr %w_cleanup)
  ret i64 %union_match_val230

union_arm193:                                     ; preds = %union_match_end139
  %union_pay_ptr196 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 1
  %union_payload197 = load ptr, ptr %union_pay_ptr196, align 8
  %union_val_slot_base198 = ptrtoint ptr %union_payload197 to i64
  %union_val_slot_addr199 = add i64 %union_val_slot_base198, 0
  %union_val_slot200 = inttoptr i64 %union_val_slot_addr199 to ptr
  %union_val201 = load i64, ptr %union_val_slot200, align 8
  store i64 %union_val201, ptr %n202, align 8
  %n203 = load i64, ptr %n202, align 8
  %62 = call ptr @avra_rc_alloc(i64 32)
  %63 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %62, i64 32, ptr @.i2s_fmt.22, i64 %n203)
  %widen204 = sext i32 %63 to i64
  %64 = call i64 @strlen(ptr @.str.21)
  %65 = call i64 @strlen(ptr %62)
  %concat_total205 = add i64 %64, %65
  %concat_size206 = add i64 %concat_total205, 1
  %66 = call ptr @avra_rc_alloc(i64 %concat_size206)
  %67 = call ptr @memcpy(ptr %66, ptr @.str.21, i64 %64)
  %cast207 = ptrtoint ptr %66 to i64
  %dst2_int208 = add i64 %cast207, %64
  %cast209 = inttoptr i64 %dst2_int208 to ptr
  %rhs_len_p1210 = add i64 %65, 1
  %68 = call ptr @memcpy(ptr %cast209, ptr %62, i64 %rhs_len_p1210)
  %69 = call i32 @puts(ptr %66)
  %widen211 = sext i32 %69 to i64
  store i64 0, ptr %union_match_result191, align 8
  br label %union_match_end192

union_next194:                                    ; preds = %union_match_end139
  %union_tag_eq214 = icmp eq i64 %union_tag190, 6954031493116
  br i1 %union_tag_eq214, label %union_arm212, label %union_next213

union_arm212:                                     ; preds = %union_next194
  %union_pay_ptr215 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 1
  %union_payload216 = load ptr, ptr %union_pay_ptr215, align 8
  %union_val_slot_base217 = ptrtoint ptr %union_payload216 to i64
  %union_val_slot_addr218 = add i64 %union_val_slot_base217, 0
  %union_val_slot219 = inttoptr i64 %union_val_slot_addr218 to ptr
  %union_val220 = load ptr, ptr %union_val_slot219, align 8
  store ptr %union_val220, ptr %s221, align 8
  %s222 = load ptr, ptr %s221, align 8
  %70 = call i64 @strlen(ptr @.str.23)
  %71 = call i64 @strlen(ptr %s222)
  %concat_total223 = add i64 %70, %71
  %concat_size224 = add i64 %concat_total223, 1
  %72 = call ptr @avra_rc_alloc(i64 %concat_size224)
  %73 = call ptr @memcpy(ptr %72, ptr @.str.23, i64 %70)
  %cast225 = ptrtoint ptr %72 to i64
  %dst2_int226 = add i64 %cast225, %70
  %cast227 = inttoptr i64 %dst2_int226 to ptr
  %rhs_len_p1228 = add i64 %71, 1
  %74 = call ptr @memcpy(ptr %cast227, ptr %s222, i64 %rhs_len_p1228)
  %75 = call i32 @puts(ptr %72)
  %widen229 = sext i32 %75 to i64
  store i64 0, ptr %union_match_result191, align 8
  br label %union_match_end192

union_next213:                                    ; preds = %union_next194
  call void @avra_match_unreachable(ptr @.match_fn.24, i64 %union_tag190, ptr @mu_file.25, i64 54)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Wrapper(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_val_ptr = getelementptr inbounds nuw %Wrapper, ptr %0, i32 0, i32 0
  %rel_val = load ptr, ptr %rel_val_ptr, align 8
  %is_null_val = icmp eq ptr %rel_val, null
  br i1 %is_null_val, label %rel_val_skip, label %rel_val_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_val_skip
  ret i64 0

rel_val_skip:                                     ; preds = %rel_val_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_val_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_val)
  br label %rel_val_skip
}
