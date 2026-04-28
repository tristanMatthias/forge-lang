; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result__string__string = type { i64, ptr }
%Result__string__string__Ok = type { ptr }
%Result__string__string__Err = type { ptr }

@.str = private unnamed_addr constant [10 x i8] c"released \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"cleanup\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"failed\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"err: \00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/errdefer_implicit.av\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"---\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"err: \00", align 1
@.match_fn.9 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.10 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/errdefer_implicit.av\00", align 1

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

define i64 @release(i64 %0) {
entry:
  %r = alloca i64, align 8
  store i64 %0, ptr %r, align 8
  %r1 = load i64, ptr %r, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %r1)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast2, ptr %1, i64 %rhs_len_p1)
  %8 = call i32 @puts(ptr %5)
  %widen3 = sext i32 %8 to i64
  ret i64 0
}

define i64 @cleanup() {
entry:
  %0 = call i32 @puts(ptr @.str.1)
  %widen = sext i32 %0 to i64
  ret i64 0
}

define ptr @do_work(i1 %0) {
entry:
  %resource = alloca i64, align 8
  %fail = alloca i1, align 1
  store i1 %0, ptr %fail, align 8
  store i64 42, ptr %resource, align 8
  %fail1 = load i1, ptr %fail, align 8
  br i1 %fail1, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr4, align 8
  %pay_ptr5 = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr5, align 8
  %slot_base6 = ptrtoint ptr %2 to i64
  %slot_addr7 = add i64 %slot_base6, 0
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store ptr @.str.3, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %1 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %cast10, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str.2, ptr %slot, align 8
  %cast = ptrtoint ptr %3 to i64
  %5 = call i64 @cleanup()
  %resource2 = load i64, ptr %resource, align 8
  %6 = call i64 @release(i64 %resource2)
  %cast3 = inttoptr i64 %cast to ptr
  ret ptr %cast3

if_else:                                          ; preds = %entry
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  %7 = call i64 @cleanup()
  %resource11 = load i64, ptr %resource, align 8
  %8 = call i64 @release(i64 %resource11)
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  %9 = call i64 @cleanup()
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast12 = inttoptr i64 %cast9 to ptr
  ret ptr %cast12
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %e49 = alloca ptr, align 8
  %v31 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %e9 = alloca ptr, align 8
  %v1 = alloca ptr, align 8
  %match_stmt_discard = alloca i64, align 8
  %1 = call ptr @do_work(i1 true)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %2 = call i32 @puts(ptr @.str.6)
  %widen18 = sext i32 %2 to i64
  %3 = call ptr @do_work(i1 false)
  %tag_ptr19 = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 0
  %tag20 = load i64, ptr %tag_ptr19, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq24 = icmp eq i64 %tag20, 5862623
  br i1 %tag_eq24, label %march_arm22, label %march_next23

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @avra_rc_retain(ptr %v)
  store ptr %v, ptr %v1, align 8
  %v2 = load ptr, ptr %v1, align 8
  %4 = call i64 @strlen(ptr @.str.4)
  %5 = call i64 @strlen(ptr %v2)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr @.str.4, i64 %4)
  %cast = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast, %4
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast3, ptr %v2, i64 %rhs_len_p1)
  %9 = call i32 @puts(ptr %6)
  %widen = sext i32 %9 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %e_slot_base = ptrtoint ptr %payload8 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e)
  store ptr %e, ptr %e9, align 8
  %e10 = load ptr, ptr %e9, align 8
  %10 = call i64 @strlen(ptr @.str.5)
  %11 = call i64 @strlen(ptr %e10)
  %concat_total11 = add i64 %10, %11
  %concat_size12 = add i64 %concat_total11, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size12)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.5, i64 %10)
  %cast13 = ptrtoint ptr %12 to i64
  %dst2_int14 = add i64 %cast13, %10
  %cast15 = inttoptr i64 %dst2_int14 to ptr
  %rhs_len_p116 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast15, ptr %e10, i64 %rhs_len_p116)
  %15 = call i32 @puts(ptr %12)
  %widen17 = sext i32 %15 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 21)
  unreachable

match_end21:                                      ; preds = %march_arm40, %march_arm22
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm22:                                      ; preds = %match_end
  %pay_slot25 = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 1
  %payload26 = load ptr, ptr %pay_slot25, align 8
  %v_slot_base27 = ptrtoint ptr %payload26 to i64
  %v_slot_addr28 = add i64 %v_slot_base27, 0
  %v_slot29 = inttoptr i64 %v_slot_addr28 to ptr
  %v30 = load ptr, ptr %v_slot29, align 8
  call void @avra_rc_retain(ptr %v30)
  store ptr %v30, ptr %v31, align 8
  %v32 = load ptr, ptr %v31, align 8
  %16 = call i64 @strlen(ptr @.str.7)
  %17 = call i64 @strlen(ptr %v32)
  %concat_total33 = add i64 %16, %17
  %concat_size34 = add i64 %concat_total33, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size34)
  %19 = call ptr @memcpy(ptr %18, ptr @.str.7, i64 %16)
  %cast35 = ptrtoint ptr %18 to i64
  %dst2_int36 = add i64 %cast35, %16
  %cast37 = inttoptr i64 %dst2_int36 to ptr
  %rhs_len_p138 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast37, ptr %v32, i64 %rhs_len_p138)
  %21 = call i32 @puts(ptr %18)
  %widen39 = sext i32 %21 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end21

march_next23:                                     ; preds = %match_end
  %tag_eq42 = icmp eq i64 %tag20, 193456014
  br i1 %tag_eq42, label %march_arm40, label %march_next41

march_arm40:                                      ; preds = %march_next23
  %pay_slot43 = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 1
  %payload44 = load ptr, ptr %pay_slot43, align 8
  %e_slot_base45 = ptrtoint ptr %payload44 to i64
  %e_slot_addr46 = add i64 %e_slot_base45, 0
  %e_slot47 = inttoptr i64 %e_slot_addr46 to ptr
  %e48 = load ptr, ptr %e_slot47, align 8
  call void @avra_rc_retain(ptr %e48)
  store ptr %e48, ptr %e49, align 8
  %e50 = load ptr, ptr %e49, align 8
  %22 = call i64 @strlen(ptr @.str.8)
  %23 = call i64 @strlen(ptr %e50)
  %concat_total51 = add i64 %22, %23
  %concat_size52 = add i64 %concat_total51, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size52)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.8, i64 %22)
  %cast53 = ptrtoint ptr %24 to i64
  %dst2_int54 = add i64 %cast53, %22
  %cast55 = inttoptr i64 %dst2_int54 to ptr
  %rhs_len_p156 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast55, ptr %e50, i64 %rhs_len_p156)
  %27 = call i32 @puts(ptr %24)
  %widen57 = sext i32 %27 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end21

march_next41:                                     ; preds = %march_next23
  call void @avra_match_unreachable(ptr @.match_fn.9, i64 %tag20, ptr @mu_file.10, i64 26)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Result__string__string(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Ok = icmp eq i64 %tag, 5862623
  br i1 %is_Ok, label %rel_Ok, label %try_next_Ok

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_error_skip, %vrel_value_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Ok:                                           ; preds = %do_free
  %vrel_value_ptr = getelementptr inbounds nuw %Result__string__string__Ok, ptr %payload, i32 0, i32 0
  %vrel_value = load ptr, ptr %vrel_value_ptr, align 8
  %vrel_null_value = icmp eq ptr %vrel_value, null
  br i1 %vrel_null_value, label %vrel_value_skip, label %vrel_value_do

try_next_Ok:                                      ; preds = %do_free
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

vrel_value_skip:                                  ; preds = %vrel_value_do, %rel_Ok
  br label %fields_done

vrel_value_do:                                    ; preds = %rel_Ok
  call void @avra_rc_release(ptr %vrel_value)
  br label %vrel_value_skip

rel_Err:                                          ; preds = %try_next_Ok
  %vrel_error_ptr = getelementptr inbounds nuw %Result__string__string__Err, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_Err:                                     ; preds = %try_next_Ok
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_Err
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_Err
  call void @avra_rc_release(ptr %vrel_error)
  br label %vrel_error_skip
}
