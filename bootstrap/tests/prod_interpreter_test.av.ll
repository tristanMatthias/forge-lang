; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%PiExpr = type { i64, ptr }
%PiExpr__PiAdd = type { ptr, ptr }
%PiExpr__PiMul = type { ptr, ptr }
%PiExpr__PiNeg = type { ptr }

@pi_expr = global i64 0
@.match_fn = private unnamed_addr constant [8 x i8] c"pi_eval\00", align 1
@mu_file = private unnamed_addr constant [31 x i8] c"tests/prod_interpreter_test.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c" + \00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c" * \00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"(-\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.match_fn.8 = private unnamed_addr constant [13 x i8] c"pi_to_string\00", align 1
@mu_file.9 = private unnamed_addr constant [31 x i8] c"tests/prod_interpreter_test.fg\00", align 1
@spec_str = private unnamed_addr constant [19 x i8] c"\22prod interpreter\22\00", align 1
@spec_str.10 = private unnamed_addr constant [18 x i8] c"\22eval expression\22\00", align 1
@.str.11 = private unnamed_addr constant [17 x i8] c"((2 + 3) * (-4))\00", align 1
@spec_str.12 = private unnamed_addr constant [23 x i8] c"\22to string expression\22\00", align 1

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

define i64 @pi_eval(ptr %0) {
entry:
  %inner39 = alloca ptr, align 8
  %b31 = alloca ptr, align 8
  %a24 = alloca ptr, align 8
  %b12 = alloca ptr, align 8
  %a9 = alloca ptr, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e = alloca ptr, align 8
  store ptr %0, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210686285710
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm34, %march_arm15, %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %n3 = load i64, ptr %n2, align 8
  store i64 %n3, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 210686270983
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %a_slot_base = ptrtoint ptr %payload8 to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @forge_rc_retain(ptr %a)
  store ptr %a, ptr %a9, align 8
  %pay_slot10 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %b_slot_base = ptrtoint ptr %payload11 to i64
  %b_slot_addr = add i64 %b_slot_base, 8
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load ptr, ptr %b_slot, align 8
  call void @forge_rc_retain(ptr %b)
  store ptr %b, ptr %b12, align 8
  %a13 = load ptr, ptr %a9, align 8
  %1 = call i64 @pi_eval(ptr %a13)
  %b14 = load ptr, ptr %b12, align 8
  %2 = call i64 @pi_eval(ptr %b14)
  %add = add i64 %1, %2
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  %tag_eq17 = icmp eq i64 %tag, 210686284620
  br i1 %tag_eq17, label %march_arm15, label %march_next16

march_arm15:                                      ; preds = %march_next5
  %pay_slot18 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload19 = load ptr, ptr %pay_slot18, align 8
  %a_slot_base20 = ptrtoint ptr %payload19 to i64
  %a_slot_addr21 = add i64 %a_slot_base20, 0
  %a_slot22 = inttoptr i64 %a_slot_addr21 to ptr
  %a23 = load ptr, ptr %a_slot22, align 8
  call void @forge_rc_retain(ptr %a23)
  store ptr %a23, ptr %a24, align 8
  %pay_slot25 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload26 = load ptr, ptr %pay_slot25, align 8
  %b_slot_base27 = ptrtoint ptr %payload26 to i64
  %b_slot_addr28 = add i64 %b_slot_base27, 8
  %b_slot29 = inttoptr i64 %b_slot_addr28 to ptr
  %b30 = load ptr, ptr %b_slot29, align 8
  call void @forge_rc_retain(ptr %b30)
  store ptr %b30, ptr %b31, align 8
  %a32 = load ptr, ptr %a24, align 8
  %3 = call i64 @pi_eval(ptr %a32)
  %b33 = load ptr, ptr %b31, align 8
  %4 = call i64 @pi_eval(ptr %b33)
  %mul = mul i64 %3, %4
  store i64 %mul, ptr %match_result, align 8
  br label %match_end

march_next16:                                     ; preds = %march_next5
  %tag_eq36 = icmp eq i64 %tag, 210686285176
  br i1 %tag_eq36, label %march_arm34, label %march_next35

march_arm34:                                      ; preds = %march_next16
  %pay_slot37 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload38 = load ptr, ptr %pay_slot37, align 8
  %inner_slot_base = ptrtoint ptr %payload38 to i64
  %inner_slot_addr = add i64 %inner_slot_base, 0
  %inner_slot = inttoptr i64 %inner_slot_addr to ptr
  %inner = load ptr, ptr %inner_slot, align 8
  call void @forge_rc_retain(ptr %inner)
  store ptr %inner, ptr %inner39, align 8
  %inner40 = load ptr, ptr %inner39, align 8
  %5 = call i64 @pi_eval(ptr %inner40)
  %neg = sub i64 0, %5
  store i64 %neg, ptr %match_result, align 8
  br label %match_end

march_next35:                                     ; preds = %march_next16
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 11)
  unreachable
}

define ptr @pi_to_string(ptr %0) {
entry:
  %inner85 = alloca ptr, align 8
  %b52 = alloca ptr, align 8
  %a45 = alloca ptr, align 8
  %b12 = alloca ptr, align 8
  %a9 = alloca ptr, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e = alloca ptr, align 8
  store ptr %0, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210686285710
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm80, %march_arm36, %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast100 = inttoptr i64 %match_val to ptr
  ret ptr %cast100

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %n3 = load i64, ptr %n2, align 8
  %1 = call ptr @forge_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %n3)
  %widen = sext i32 %2 to i64
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 210686270983
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %a_slot_base = ptrtoint ptr %payload8 to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @forge_rc_retain(ptr %a)
  store ptr %a, ptr %a9, align 8
  %pay_slot10 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %b_slot_base = ptrtoint ptr %payload11 to i64
  %b_slot_addr = add i64 %b_slot_base, 8
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load ptr, ptr %b_slot, align 8
  call void @forge_rc_retain(ptr %b)
  store ptr %b, ptr %b12, align 8
  %a13 = load ptr, ptr %a9, align 8
  %3 = call ptr @pi_to_string(ptr %a13)
  %4 = call i64 @strlen(ptr @.str)
  %5 = call i64 @strlen(ptr %3)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @forge_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr @.str, i64 %4)
  %cast14 = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast14, %4
  %cast15 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast15, ptr %3, i64 %rhs_len_p1)
  %9 = call i64 @strlen(ptr %6)
  %10 = call i64 @strlen(ptr @.str.1)
  %concat_total16 = add i64 %9, %10
  %concat_size17 = add i64 %concat_total16, 1
  %11 = call ptr @forge_rc_alloc(i64 %concat_size17)
  %12 = call ptr @memcpy(ptr %11, ptr %6, i64 %9)
  %cast18 = ptrtoint ptr %11 to i64
  %dst2_int19 = add i64 %cast18, %9
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast20, ptr @.str.1, i64 %rhs_len_p121)
  %b22 = load ptr, ptr %b12, align 8
  %14 = call ptr @pi_to_string(ptr %b22)
  %15 = call i64 @strlen(ptr %11)
  %16 = call i64 @strlen(ptr %14)
  %concat_total23 = add i64 %15, %16
  %concat_size24 = add i64 %concat_total23, 1
  %17 = call ptr @forge_rc_alloc(i64 %concat_size24)
  %18 = call ptr @memcpy(ptr %17, ptr %11, i64 %15)
  %cast25 = ptrtoint ptr %17 to i64
  %dst2_int26 = add i64 %cast25, %15
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast27, ptr %14, i64 %rhs_len_p128)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.2)
  %concat_total29 = add i64 %20, %21
  %concat_size30 = add i64 %concat_total29, 1
  %22 = call ptr @forge_rc_alloc(i64 %concat_size30)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast31 = ptrtoint ptr %22 to i64
  %dst2_int32 = add i64 %cast31, %20
  %cast33 = inttoptr i64 %dst2_int32 to ptr
  %rhs_len_p134 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast33, ptr @.str.2, i64 %rhs_len_p134)
  %cast35 = ptrtoint ptr %22 to i64
  store i64 %cast35, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  %tag_eq38 = icmp eq i64 %tag, 210686284620
  br i1 %tag_eq38, label %march_arm36, label %march_next37

march_arm36:                                      ; preds = %march_next5
  %pay_slot39 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload40 = load ptr, ptr %pay_slot39, align 8
  %a_slot_base41 = ptrtoint ptr %payload40 to i64
  %a_slot_addr42 = add i64 %a_slot_base41, 0
  %a_slot43 = inttoptr i64 %a_slot_addr42 to ptr
  %a44 = load ptr, ptr %a_slot43, align 8
  call void @forge_rc_retain(ptr %a44)
  store ptr %a44, ptr %a45, align 8
  %pay_slot46 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload47 = load ptr, ptr %pay_slot46, align 8
  %b_slot_base48 = ptrtoint ptr %payload47 to i64
  %b_slot_addr49 = add i64 %b_slot_base48, 8
  %b_slot50 = inttoptr i64 %b_slot_addr49 to ptr
  %b51 = load ptr, ptr %b_slot50, align 8
  call void @forge_rc_retain(ptr %b51)
  store ptr %b51, ptr %b52, align 8
  %a53 = load ptr, ptr %a45, align 8
  %25 = call ptr @pi_to_string(ptr %a53)
  %26 = call i64 @strlen(ptr @.str.3)
  %27 = call i64 @strlen(ptr %25)
  %concat_total54 = add i64 %26, %27
  %concat_size55 = add i64 %concat_total54, 1
  %28 = call ptr @forge_rc_alloc(i64 %concat_size55)
  %29 = call ptr @memcpy(ptr %28, ptr @.str.3, i64 %26)
  %cast56 = ptrtoint ptr %28 to i64
  %dst2_int57 = add i64 %cast56, %26
  %cast58 = inttoptr i64 %dst2_int57 to ptr
  %rhs_len_p159 = add i64 %27, 1
  %30 = call ptr @memcpy(ptr %cast58, ptr %25, i64 %rhs_len_p159)
  %31 = call i64 @strlen(ptr %28)
  %32 = call i64 @strlen(ptr @.str.4)
  %concat_total60 = add i64 %31, %32
  %concat_size61 = add i64 %concat_total60, 1
  %33 = call ptr @forge_rc_alloc(i64 %concat_size61)
  %34 = call ptr @memcpy(ptr %33, ptr %28, i64 %31)
  %cast62 = ptrtoint ptr %33 to i64
  %dst2_int63 = add i64 %cast62, %31
  %cast64 = inttoptr i64 %dst2_int63 to ptr
  %rhs_len_p165 = add i64 %32, 1
  %35 = call ptr @memcpy(ptr %cast64, ptr @.str.4, i64 %rhs_len_p165)
  %b66 = load ptr, ptr %b52, align 8
  %36 = call ptr @pi_to_string(ptr %b66)
  %37 = call i64 @strlen(ptr %33)
  %38 = call i64 @strlen(ptr %36)
  %concat_total67 = add i64 %37, %38
  %concat_size68 = add i64 %concat_total67, 1
  %39 = call ptr @forge_rc_alloc(i64 %concat_size68)
  %40 = call ptr @memcpy(ptr %39, ptr %33, i64 %37)
  %cast69 = ptrtoint ptr %39 to i64
  %dst2_int70 = add i64 %cast69, %37
  %cast71 = inttoptr i64 %dst2_int70 to ptr
  %rhs_len_p172 = add i64 %38, 1
  %41 = call ptr @memcpy(ptr %cast71, ptr %36, i64 %rhs_len_p172)
  %42 = call i64 @strlen(ptr %39)
  %43 = call i64 @strlen(ptr @.str.5)
  %concat_total73 = add i64 %42, %43
  %concat_size74 = add i64 %concat_total73, 1
  %44 = call ptr @forge_rc_alloc(i64 %concat_size74)
  %45 = call ptr @memcpy(ptr %44, ptr %39, i64 %42)
  %cast75 = ptrtoint ptr %44 to i64
  %dst2_int76 = add i64 %cast75, %42
  %cast77 = inttoptr i64 %dst2_int76 to ptr
  %rhs_len_p178 = add i64 %43, 1
  %46 = call ptr @memcpy(ptr %cast77, ptr @.str.5, i64 %rhs_len_p178)
  %cast79 = ptrtoint ptr %44 to i64
  store i64 %cast79, ptr %match_result, align 8
  br label %match_end

march_next37:                                     ; preds = %march_next5
  %tag_eq82 = icmp eq i64 %tag, 210686285176
  br i1 %tag_eq82, label %march_arm80, label %march_next81

march_arm80:                                      ; preds = %march_next37
  %pay_slot83 = getelementptr inbounds nuw %PiExpr, ptr %e1, i32 0, i32 1
  %payload84 = load ptr, ptr %pay_slot83, align 8
  %inner_slot_base = ptrtoint ptr %payload84 to i64
  %inner_slot_addr = add i64 %inner_slot_base, 0
  %inner_slot = inttoptr i64 %inner_slot_addr to ptr
  %inner = load ptr, ptr %inner_slot, align 8
  call void @forge_rc_retain(ptr %inner)
  store ptr %inner, ptr %inner85, align 8
  %inner86 = load ptr, ptr %inner85, align 8
  %47 = call ptr @pi_to_string(ptr %inner86)
  %48 = call i64 @strlen(ptr @.str.6)
  %49 = call i64 @strlen(ptr %47)
  %concat_total87 = add i64 %48, %49
  %concat_size88 = add i64 %concat_total87, 1
  %50 = call ptr @forge_rc_alloc(i64 %concat_size88)
  %51 = call ptr @memcpy(ptr %50, ptr @.str.6, i64 %48)
  %cast89 = ptrtoint ptr %50 to i64
  %dst2_int90 = add i64 %cast89, %48
  %cast91 = inttoptr i64 %dst2_int90 to ptr
  %rhs_len_p192 = add i64 %49, 1
  %52 = call ptr @memcpy(ptr %cast91, ptr %47, i64 %rhs_len_p192)
  %53 = call i64 @strlen(ptr %50)
  %54 = call i64 @strlen(ptr @.str.7)
  %concat_total93 = add i64 %53, %54
  %concat_size94 = add i64 %concat_total93, 1
  %55 = call ptr @forge_rc_alloc(i64 %concat_size94)
  %56 = call ptr @memcpy(ptr %55, ptr %50, i64 %53)
  %cast95 = ptrtoint ptr %55 to i64
  %dst2_int96 = add i64 %cast95, %53
  %cast97 = inttoptr i64 %dst2_int96 to ptr
  %rhs_len_p198 = add i64 %54, 1
  %57 = call ptr @memcpy(ptr %cast97, ptr @.str.7, i64 %rhs_len_p198)
  %cast99 = ptrtoint ptr %55 to i64
  store i64 %cast99, ptr %match_result, align 8
  br label %match_end

march_next81:                                     ; preds = %march_next37
  call void @forge_match_unreachable(ptr @.match_fn.8, i64 %tag, ptr @mu_file.9, i64 20)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %PiExpr, ptr %0, i32 0, i32 0
  store i64 210686284620, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %PiExpr, ptr %0, i32 0, i32 1
  %1 = call ptr @forge_rc_alloc(i64 16)
  store ptr %1, ptr %pay_ptr, align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %PiExpr, ptr %2, i32 0, i32 0
  store i64 210686270983, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %PiExpr, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr2, align 8
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %PiExpr, ptr %4, i32 0, i32 0
  store i64 210686285710, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %PiExpr, ptr %4, i32 0, i32 1
  %5 = call ptr @forge_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr4, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 2, ptr %slot, align 8
  %cast = ptrtoint ptr %4 to i64
  %slot_base5 = ptrtoint ptr %3 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  %cast8 = inttoptr i64 %cast to ptr
  store ptr %cast8, ptr %slot7, align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr9 = getelementptr inbounds nuw %PiExpr, ptr %6, i32 0, i32 0
  store i64 210686285710, ptr %tag_ptr9, align 8
  %pay_ptr10 = getelementptr inbounds nuw %PiExpr, ptr %6, i32 0, i32 1
  %7 = call ptr @forge_rc_alloc(i64 8)
  store ptr %7, ptr %pay_ptr10, align 8
  %slot_base11 = ptrtoint ptr %7 to i64
  %slot_addr12 = add i64 %slot_base11, 0
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store i64 3, ptr %slot13, align 8
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
  %8 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr24 = getelementptr inbounds nuw %PiExpr, ptr %8, i32 0, i32 0
  store i64 210686285176, ptr %tag_ptr24, align 8
  %pay_ptr25 = getelementptr inbounds nuw %PiExpr, ptr %8, i32 0, i32 1
  %9 = call ptr @forge_rc_alloc(i64 8)
  store ptr %9, ptr %pay_ptr25, align 8
  %10 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %PiExpr, ptr %10, i32 0, i32 0
  store i64 210686285710, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %PiExpr, ptr %10, i32 0, i32 1
  %11 = call ptr @forge_rc_alloc(i64 8)
  store ptr %11, ptr %pay_ptr27, align 8
  %slot_base28 = ptrtoint ptr %11 to i64
  %slot_addr29 = add i64 %slot_base28, 0
  %slot30 = inttoptr i64 %slot_addr29 to ptr
  store i64 4, ptr %slot30, align 8
  %cast31 = ptrtoint ptr %10 to i64
  %slot_base32 = ptrtoint ptr %9 to i64
  %slot_addr33 = add i64 %slot_base32, 0
  %slot34 = inttoptr i64 %slot_addr33 to ptr
  %cast35 = inttoptr i64 %cast31 to ptr
  store ptr %cast35, ptr %slot34, align 8
  %cast36 = ptrtoint ptr %8 to i64
  %slot_base37 = ptrtoint ptr %1 to i64
  %slot_addr38 = add i64 %slot_base37, 8
  %slot39 = inttoptr i64 %slot_addr38 to ptr
  %cast40 = inttoptr i64 %cast36 to ptr
  store ptr %cast40, ptr %slot39, align 8
  %cast41 = ptrtoint ptr %0 to i64
  store i64 %cast41, ptr @pi_expr, align 8
  %12 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %12 to i64
  %pi_expr = load ptr, ptr @pi_expr, align 8
  %13 = call i64 @pi_eval(ptr %pi_expr)
  %eq = icmp eq i64 %13, -20
  %eq_ext = zext i1 %eq to i64
  %14 = call i64 @forge_test_run_then(ptr @spec_str.10, i64 %eq_ext)
  %pi_expr42 = load ptr, ptr @pi_expr, align 8
  %15 = call ptr @pi_to_string(ptr %pi_expr42)
  %16 = call i32 @strcmp(ptr %15, ptr @.str.11)
  %widen43 = sext i32 %16 to i64
  %streq_cmp = icmp eq i64 %widen43, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %17 = call i64 @forge_test_run_then(ptr @spec_str.12, i64 %streq_ext)
  %18 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen44 = sext i32 %18 to i64
  %19 = call i32 @forge_test_summary()
  %widen45 = sext i32 %19 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_PiExpr(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %PiExpr, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %PiExpr, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_PiAdd = icmp eq i64 %tag, 210686270983
  br i1 %is_PiAdd, label %rel_PiAdd, label %try_next_PiAdd

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_PiNeg, %vrel_e_skip, %vrel_b_skip9, %vrel_b_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_PiAdd:                                        ; preds = %do_free
  %vrel_a_ptr = getelementptr inbounds nuw %PiExpr__PiAdd, ptr %payload, i32 0, i32 0
  %vrel_a = load ptr, ptr %vrel_a_ptr, align 8
  %vrel_null_a = icmp eq ptr %vrel_a, null
  br i1 %vrel_null_a, label %vrel_a_skip, label %vrel_a_do

try_next_PiAdd:                                   ; preds = %do_free
  %is_PiMul = icmp eq i64 %tag, 210686284620
  br i1 %is_PiMul, label %rel_PiMul, label %try_next_PiMul

vrel_a_skip:                                      ; preds = %vrel_a_do, %rel_PiAdd
  %vrel_b_ptr = getelementptr inbounds nuw %PiExpr__PiAdd, ptr %payload, i32 0, i32 1
  %vrel_b = load ptr, ptr %vrel_b_ptr, align 8
  %vrel_null_b = icmp eq ptr %vrel_b, null
  br i1 %vrel_null_b, label %vrel_b_skip, label %vrel_b_do

vrel_a_do:                                        ; preds = %rel_PiAdd
  %2 = call i64 @__release_PiExpr(ptr %vrel_a)
  br label %vrel_a_skip

vrel_b_skip:                                      ; preds = %vrel_b_do, %vrel_a_skip
  br label %fields_done

vrel_b_do:                                        ; preds = %vrel_a_skip
  %3 = call i64 @__release_PiExpr(ptr %vrel_b)
  br label %vrel_b_skip

rel_PiMul:                                        ; preds = %try_next_PiAdd
  %vrel_a_ptr1 = getelementptr inbounds nuw %PiExpr__PiMul, ptr %payload, i32 0, i32 0
  %vrel_a2 = load ptr, ptr %vrel_a_ptr1, align 8
  %vrel_null_a3 = icmp eq ptr %vrel_a2, null
  br i1 %vrel_null_a3, label %vrel_a_skip4, label %vrel_a_do5

try_next_PiMul:                                   ; preds = %try_next_PiAdd
  %is_PiNeg = icmp eq i64 %tag, 210686285176
  br i1 %is_PiNeg, label %rel_PiNeg, label %try_next_PiNeg

vrel_a_skip4:                                     ; preds = %vrel_a_do5, %rel_PiMul
  %vrel_b_ptr6 = getelementptr inbounds nuw %PiExpr__PiMul, ptr %payload, i32 0, i32 1
  %vrel_b7 = load ptr, ptr %vrel_b_ptr6, align 8
  %vrel_null_b8 = icmp eq ptr %vrel_b7, null
  br i1 %vrel_null_b8, label %vrel_b_skip9, label %vrel_b_do10

vrel_a_do5:                                       ; preds = %rel_PiMul
  %4 = call i64 @__release_PiExpr(ptr %vrel_a2)
  br label %vrel_a_skip4

vrel_b_skip9:                                     ; preds = %vrel_b_do10, %vrel_a_skip4
  br label %fields_done

vrel_b_do10:                                      ; preds = %vrel_a_skip4
  %5 = call i64 @__release_PiExpr(ptr %vrel_b7)
  br label %vrel_b_skip9

rel_PiNeg:                                        ; preds = %try_next_PiMul
  %vrel_e_ptr = getelementptr inbounds nuw %PiExpr__PiNeg, ptr %payload, i32 0, i32 0
  %vrel_e = load ptr, ptr %vrel_e_ptr, align 8
  %vrel_null_e = icmp eq ptr %vrel_e, null
  br i1 %vrel_null_e, label %vrel_e_skip, label %vrel_e_do

try_next_PiNeg:                                   ; preds = %try_next_PiMul
  br label %fields_done

vrel_e_skip:                                      ; preds = %vrel_e_do, %rel_PiNeg
  br label %fields_done

vrel_e_do:                                        ; preds = %rel_PiNeg
  %6 = call i64 @__release_PiExpr(ptr %vrel_e)
  br label %vrel_e_skip
}
