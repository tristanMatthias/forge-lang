; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result = type { i64, ptr }
%Result__Err = type { i64, ptr }

@ok = global i64 0
@err = global i64 0
@.str = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/multi_payload_enum.av\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.match_fn.5 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.6 = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/enum_decl/tests/multi_payload_enum.av\00", align 1

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
  %msg60 = alloca ptr, align 8
  %code53 = alloca i64, align 8
  %v40 = alloca i64, align 8
  %match_stmt_discard30 = alloca i64, align 8
  %msg22 = alloca ptr, align 8
  %code19 = alloca i64, align 8
  %v11 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 8)
  store ptr %1, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @ok, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr2, align 8
  %slot_base3 = ptrtoint ptr %3 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 404, ptr %slot5, align 8
  %slot_base6 = ptrtoint ptr %3 to i64
  %slot_addr7 = add i64 %slot_base6, 8
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store ptr @.str, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %2 to i64
  store i64 %cast9, ptr @err, align 8
  %ok = load ptr, ptr @ok, align 8
  %tag_ptr10 = getelementptr inbounds nuw %Result, ptr %ok, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr10, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm14, %march_arm
  %err = load ptr, ptr @err, align 8
  %tag_ptr27 = getelementptr inbounds nuw %Result, ptr %err, i32 0, i32 0
  %tag28 = load i64, ptr %tag_ptr27, align 8
  %tag_eq33 = icmp eq i64 %tag28, 5862623
  br i1 %tag_eq33, label %march_arm31, label %march_next32

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %ok, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v11, align 8
  %v12 = load i64, ptr %v11, align 8
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %v12)
  %widen = sext i32 %5 to i64
  %6 = call i32 @puts(ptr %4)
  %widen13 = sext i32 %6 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq16 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq16, label %march_arm14, label %march_next15

march_arm14:                                      ; preds = %march_next
  %pay_slot17 = getelementptr inbounds nuw %Result, ptr %ok, i32 0, i32 1
  %payload18 = load ptr, ptr %pay_slot17, align 8
  %code_slot_base = ptrtoint ptr %payload18 to i64
  %code_slot_addr = add i64 %code_slot_base, 0
  %code_slot = inttoptr i64 %code_slot_addr to ptr
  %code = load i64, ptr %code_slot, align 8
  store i64 %code, ptr %code19, align 8
  %pay_slot20 = getelementptr inbounds nuw %Result, ptr %ok, i32 0, i32 1
  %payload21 = load ptr, ptr %pay_slot20, align 8
  %msg_slot_base = ptrtoint ptr %payload21 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 8
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @avra_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg22, align 8
  %msg23 = load ptr, ptr %msg22, align 8
  %7 = call i64 @strlen(ptr @.str.1)
  %8 = call i64 @strlen(ptr %msg23)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.1, i64 %7)
  %cast24 = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast24, %7
  %cast25 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast25, ptr %msg23, i64 %rhs_len_p1)
  %12 = call i32 @puts(ptr %9)
  %widen26 = sext i32 %12 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next15:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 10)
  unreachable

match_end29:                                      ; preds = %march_arm44, %march_arm31
  %13 = call i32 @avra_test_summary()
  %widen77 = sext i32 %13 to i64
  call void @avra_rc_collect()
  ret i64 0

march_arm31:                                      ; preds = %match_end
  %pay_slot34 = getelementptr inbounds nuw %Result, ptr %err, i32 0, i32 1
  %payload35 = load ptr, ptr %pay_slot34, align 8
  %v_slot_base36 = ptrtoint ptr %payload35 to i64
  %v_slot_addr37 = add i64 %v_slot_base36, 0
  %v_slot38 = inttoptr i64 %v_slot_addr37 to ptr
  %v39 = load i64, ptr %v_slot38, align 8
  store i64 %v39, ptr %v40, align 8
  %v41 = load i64, ptr %v40, align 8
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.2, i64 %v41)
  %widen42 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen43 = sext i32 %16 to i64
  store i64 0, ptr %match_stmt_discard30, align 8
  br label %match_end29

march_next32:                                     ; preds = %match_end
  %tag_eq46 = icmp eq i64 %tag28, 193456014
  br i1 %tag_eq46, label %march_arm44, label %march_next45

march_arm44:                                      ; preds = %march_next32
  %pay_slot47 = getelementptr inbounds nuw %Result, ptr %err, i32 0, i32 1
  %payload48 = load ptr, ptr %pay_slot47, align 8
  %code_slot_base49 = ptrtoint ptr %payload48 to i64
  %code_slot_addr50 = add i64 %code_slot_base49, 0
  %code_slot51 = inttoptr i64 %code_slot_addr50 to ptr
  %code52 = load i64, ptr %code_slot51, align 8
  store i64 %code52, ptr %code53, align 8
  %pay_slot54 = getelementptr inbounds nuw %Result, ptr %err, i32 0, i32 1
  %payload55 = load ptr, ptr %pay_slot54, align 8
  %msg_slot_base56 = ptrtoint ptr %payload55 to i64
  %msg_slot_addr57 = add i64 %msg_slot_base56, 8
  %msg_slot58 = inttoptr i64 %msg_slot_addr57 to ptr
  %msg59 = load ptr, ptr %msg_slot58, align 8
  call void @avra_rc_retain(ptr %msg59)
  store ptr %msg59, ptr %msg60, align 8
  %code61 = load i64, ptr %code53, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.3, i64 %code61)
  %widen62 = sext i32 %18 to i64
  %19 = call i64 @strlen(ptr %17)
  %20 = call i64 @strlen(ptr @.str.4)
  %concat_total63 = add i64 %19, %20
  %concat_size64 = add i64 %concat_total63, 1
  %21 = call ptr @avra_rc_alloc(i64 %concat_size64)
  %22 = call ptr @memcpy(ptr %21, ptr %17, i64 %19)
  %cast65 = ptrtoint ptr %21 to i64
  %dst2_int66 = add i64 %cast65, %19
  %cast67 = inttoptr i64 %dst2_int66 to ptr
  %rhs_len_p168 = add i64 %20, 1
  %23 = call ptr @memcpy(ptr %cast67, ptr @.str.4, i64 %rhs_len_p168)
  %msg69 = load ptr, ptr %msg60, align 8
  %24 = call i64 @strlen(ptr %21)
  %25 = call i64 @strlen(ptr %msg69)
  %concat_total70 = add i64 %24, %25
  %concat_size71 = add i64 %concat_total70, 1
  %26 = call ptr @avra_rc_alloc(i64 %concat_size71)
  %27 = call ptr @memcpy(ptr %26, ptr %21, i64 %24)
  %cast72 = ptrtoint ptr %26 to i64
  %dst2_int73 = add i64 %cast72, %24
  %cast74 = inttoptr i64 %dst2_int73 to ptr
  %rhs_len_p175 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast74, ptr %msg69, i64 %rhs_len_p175)
  %29 = call i32 @puts(ptr %26)
  %widen76 = sext i32 %29 to i64
  store i64 0, ptr %match_stmt_discard30, align 8
  br label %match_end29

march_next45:                                     ; preds = %march_next32
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 %tag28, ptr @mu_file.6, i64 15)
  unreachable
}

define i64 @__release_Result(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %Result__Err, ptr %payload, i32 0, i32 1
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_Err:                                     ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_Err
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_Err
  call void @avra_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}
