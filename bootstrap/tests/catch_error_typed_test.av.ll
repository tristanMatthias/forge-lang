; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%CetResult = type { i64, ptr }
%CetResult__CetErr = type { ptr }

@.str = private unnamed_addr constant [3 x i8] c"42\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"not a number\00", align 1
@.match_fn = private unnamed_addr constant [14 x i8] c"cet_unwrap_or\00", align 1
@mu_file = private unnamed_addr constant [32 x i8] c"tests/catch_error_typed_test.fg\00", align 1
@.str.2 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.match_fn.3 = private unnamed_addr constant [14 x i8] c"cet_error_msg\00", align 1
@mu_file.4 = private unnamed_addr constant [32 x i8] c"tests/catch_error_typed_test.fg\00", align 1
@spec_str = private unnamed_addr constant [20 x i8] c"\22catch error typed\22\00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c"42\00", align 1
@spec_str.6 = private unnamed_addr constant [24 x i8] c"\22success returns value\22\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@spec_str.8 = private unnamed_addr constant [27 x i8] c"\22failure returns fallback\22\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.str.10 = private unnamed_addr constant [13 x i8] c"not a number\00", align 1
@spec_str.11 = private unnamed_addr constant [26 x i8] c"\22error message preserved\22\00", align 1

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

define ptr @cet_parse(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i32 @strcmp(ptr %s1, ptr @.str)
  %widen = sext i32 %1 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %CetResult, ptr %2, i32 0, i32 0
  store i64 6952135238250, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %CetResult, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %slot_base5 = ptrtoint ptr %3 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  store ptr @.str.1, ptr %slot7, align 8
  %cast8 = ptrtoint ptr %2 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  ret ptr %cast9

if_then:                                          ; preds = %entry
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %CetResult, ptr %4, i32 0, i32 0
  store i64 210670765115, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %CetResult, ptr %4, i32 0, i32 1
  %5 = call ptr @forge_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast = ptrtoint ptr %4 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @cet_unwrap_or(ptr %0, i64 %1) {
entry:
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %default_val = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  store i64 %1, ptr %default_val, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %CetResult, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210670765115
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %CetResult, ptr %r1, i32 0, i32 1
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
  %tag_eq6 = icmp eq i64 %tag, 6952135238250
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %default_val7 = load i64, ptr %default_val, align 8
  store i64 %default_val7, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 11)
  unreachable
}

define ptr @cet_error_msg(ptr %0) {
entry:
  %msg5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %CetResult, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210670765115
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast7 = inttoptr i64 %match_val to ptr
  ret ptr %cast7

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6952135238250
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %CetResult, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %msg_slot_base = ptrtoint ptr %payload to i64
  %msg_slot_addr = add i64 %msg_slot_base, 0
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @forge_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg5, align 8
  %msg6 = load ptr, ptr %msg5, align 8
  %cast = ptrtoint ptr %msg6 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.3, i64 %tag, ptr @mu_file.4, i64 18)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @cet_parse(ptr @.str.5)
  %2 = call i64 @cet_unwrap_or(ptr %1, i64 0)
  %eq = icmp eq i64 %2, 42
  %eq_ext = zext i1 %eq to i64
  %3 = call i64 @forge_test_run_then(ptr @spec_str.6, i64 %eq_ext)
  %4 = call ptr @cet_parse(ptr @.str.7)
  %5 = call i64 @cet_unwrap_or(ptr %4, i64 0)
  %eq1 = icmp eq i64 %5, 0
  %eq_ext2 = zext i1 %eq1 to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %eq_ext2)
  %7 = call ptr @cet_parse(ptr @.str.9)
  %8 = call ptr @cet_error_msg(ptr %7)
  %9 = call i32 @strcmp(ptr %8, ptr @.str.10)
  %widen3 = sext i32 %9 to i64
  %streq_cmp = icmp eq i64 %widen3, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %10 = call i64 @forge_test_run_then(ptr @spec_str.11, i64 %streq_ext)
  %11 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen4 = sext i32 %11 to i64
  %12 = call i32 @forge_test_summary()
  %widen5 = sext i32 %12 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_CetResult(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %CetResult, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %CetResult, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_CetErr = icmp eq i64 %tag, 6952135238250
  br i1 %is_CetErr, label %rel_CetErr, label %try_next_CetErr

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_CetErr, %vrel_msg_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_CetErr:                                       ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %CetResult__CetErr, ptr %payload, i32 0, i32 0
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_CetErr:                                  ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_CetErr
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_CetErr
  call void @forge_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}
