; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%FcPoint = type { double, double }
%FcValue = type { i64, ptr }
%FcValue__FcStr = type { ptr }

@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"FcPoint\00", align 1
@src_file = private unnamed_addr constant [26 x i8] c"tests/float_combo_test.fg\00", align 1
@fld_name.1 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.2 = private unnamed_addr constant [8 x i8] c"FcPoint\00", align 1
@src_file.3 = private unnamed_addr constant [26 x i8] c"tests/float_combo_test.fg\00", align 1
@fld_name.4 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.5 = private unnamed_addr constant [8 x i8] c"FcPoint\00", align 1
@src_file.6 = private unnamed_addr constant [26 x i8] c"tests/float_combo_test.fg\00", align 1
@fld_name.7 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.8 = private unnamed_addr constant [8 x i8] c"FcPoint\00", align 1
@src_file.9 = private unnamed_addr constant [26 x i8] c"tests/float_combo_test.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [19 x i8] c"fc_value_to_string\00", align 1
@mu_file = private unnamed_addr constant [26 x i8] c"tests/float_combo_test.fg\00", align 1
@.flit_str = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.flit_str.10 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"one\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn.13 = private unnamed_addr constant [12 x i8] c"fc_classify\00", align 1
@mu_file.14 = private unnamed_addr constant [26 x i8] c"tests/float_combo_test.fg\00", align 1
@.float_str = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.15 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.16 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.17 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@spec_str = private unnamed_addr constant [14 x i8] c"\22float combo\22\00", align 1
@.float_str.18 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.19 = private unnamed_addr constant [4 x i8] c"4.0\00", align 1
@.float_str.20 = private unnamed_addr constant [5 x i8] c"25.0\00", align 1
@spec_str.21 = private unnamed_addr constant [26 x i8] c"\22struct distance squared\22\00", align 1
@.float_str.22 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.str.23 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@spec_str.24 = private unnamed_addr constant [21 x i8] c"\22enum float variant\22\00", align 1
@.str.25 = private unnamed_addr constant [3 x i8] c"42\00", align 1
@spec_str.26 = private unnamed_addr constant [19 x i8] c"\22enum int variant\22\00", align 1
@.float_str.27 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.str.28 = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@spec_str.29 = private unnamed_addr constant [13 x i8] c"\22match zero\22\00", align 1
@.float_str.30 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.str.31 = private unnamed_addr constant [4 x i8] c"one\00", align 1
@spec_str.32 = private unnamed_addr constant [12 x i8] c"\22match one\22\00", align 1
@.float_str.33 = private unnamed_addr constant [5 x i8] c"99.0\00", align 1
@.str.34 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@spec_str.35 = private unnamed_addr constant [14 x i8] c"\22match other\22\00", align 1
@.float_str.36 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.37 = private unnamed_addr constant [4 x i8] c"5.5\00", align 1
@.float_str.38 = private unnamed_addr constant [4 x i8] c"5.5\00", align 1
@spec_str.39 = private unnamed_addr constant [15 x i8] c"\22abs negative\22\00", align 1
@.float_str.40 = private unnamed_addr constant [5 x i8] c"10.0\00", align 1
@.float_str.41 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@spec_str.42 = private unnamed_addr constant [19 x i8] c"\22safe div success\22\00", align 1
@.float_str.43 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.44 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@spec_str.45 = private unnamed_addr constant [19 x i8] c"\22safe div by zero\22\00", align 1
@.float_str.46 = private unnamed_addr constant [4 x i8] c"1.5\00", align 1
@.float_str.47 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@spec_str.48 = private unnamed_addr constant [14 x i8] c"\22pipe double\22\00", align 1
@.float_str.49 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.50 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.51 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@spec_str.52 = private unnamed_addr constant [11 x i8] c"\22negation\22\00", align 1

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

define double @fc_dist_sq(ptr %0) {
entry:
  %p = alloca ptr, align 8
  store ptr %0, ptr %p, align 8
  %p1 = load ptr, ptr %p, align 8
  %cast = ptrtoint ptr %p1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 25, i64 6)
  %x_ptr = getelementptr inbounds nuw %FcPoint, ptr %p1, i32 0, i32 0
  %x = load double, ptr %x_ptr, align 8
  %p2 = load ptr, ptr %p, align 8
  %cast3 = ptrtoint ptr %p2 to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @forge_null_deref_trap(ptr @fld_name.1, i64 1, ptr @sty_name.2, i64 7, i64 %null_ext5, ptr @src_file.3, i64 25, i64 6)
  %x_ptr6 = getelementptr inbounds nuw %FcPoint, ptr %p2, i32 0, i32 0
  %x7 = load double, ptr %x_ptr6, align 8
  %fmul = fmul double %x, %x7
  %p8 = load ptr, ptr %p, align 8
  %cast9 = ptrtoint ptr %p8 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @forge_null_deref_trap(ptr @fld_name.4, i64 1, ptr @sty_name.5, i64 7, i64 %null_ext11, ptr @src_file.6, i64 25, i64 6)
  %y_ptr = getelementptr inbounds nuw %FcPoint, ptr %p8, i32 0, i32 1
  %y = load double, ptr %y_ptr, align 8
  %p12 = load ptr, ptr %p, align 8
  %cast13 = ptrtoint ptr %p12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @forge_null_deref_trap(ptr @fld_name.7, i64 1, ptr @sty_name.8, i64 7, i64 %null_ext15, ptr @src_file.9, i64 25, i64 6)
  %y_ptr16 = getelementptr inbounds nuw %FcPoint, ptr %p12, i32 0, i32 1
  %y17 = load double, ptr %y_ptr16, align 8
  %fmul18 = fmul double %y, %y17
  %fadd = fadd double %fmul, %fmul18
  ret double %fadd
}

define ptr @fc_value_to_string(ptr %0) {
entry:
  %s17 = alloca ptr, align 8
  %f9 = alloca double, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %v = alloca ptr, align 8
  store ptr %0, ptr %v, align 8
  %v1 = load ptr, ptr %v, align 8
  %tag_ptr = getelementptr inbounds nuw %FcValue, ptr %v1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210674205209
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm12, %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = inttoptr i64 %match_val to ptr
  ret ptr %cast20

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %FcValue, ptr %v1, i32 0, i32 1
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
  %tag_eq6 = icmp eq i64 %tag, 229424205840836
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %FcValue, ptr %v1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %f_slot_base = ptrtoint ptr %payload8 to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load double, ptr %f_slot, align 8
  store double %f, ptr %f9, align 8
  %f10 = load double, ptr %f9, align 8
  %cast11 = bitcast double %f10 to i64
  %3 = call i64 @forge_float_to_string(i64 %cast11)
  store i64 %3, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  %tag_eq14 = icmp eq i64 %tag, 210674216295
  br i1 %tag_eq14, label %march_arm12, label %march_next13

march_arm12:                                      ; preds = %march_next5
  %pay_slot15 = getelementptr inbounds nuw %FcValue, ptr %v1, i32 0, i32 1
  %payload16 = load ptr, ptr %pay_slot15, align 8
  %s_slot_base = ptrtoint ptr %payload16 to i64
  %s_slot_addr = add i64 %s_slot_base, 0
  %s_slot = inttoptr i64 %s_slot_addr to ptr
  %s = load ptr, ptr %s_slot, align 8
  call void @forge_rc_retain(ptr %s)
  store ptr %s, ptr %s17, align 8
  %s18 = load ptr, ptr %s17, align 8
  %cast19 = ptrtoint ptr %s18 to i64
  store i64 %cast19, ptr %match_result, align 8
  br label %match_end

march_next13:                                     ; preds = %march_next5
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 16)
  unreachable
}

define ptr @fc_classify(double %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  store i64 0, ptr %pmatch_result, align 8
  %1 = call i64 @forge_float_parse(ptr @.flit_str)
  %cast = bitcast i64 %1 to double
  %flit_eq = fcmp oeq double %x1, %cast
  br i1 %flit_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body6, %parm_body2, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast8 = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast8

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %2 = call i64 @forge_float_parse(ptr @.flit_str.10)
  %cast4 = bitcast i64 %2 to double
  %flit_eq5 = fcmp oeq double %x1, %cast4
  br i1 %flit_eq5, label %parm_body2, label %parm_next3

parm_body2:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next3:                                       ; preds = %parm_next
  br label %parm_body6

parm_body6:                                       ; preds = %parm_next3
  store i64 ptrtoint (ptr @.str.12 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next7:                                       ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.13, i64 -1, ptr @mu_file.14, i64 24)
  unreachable
}

define double @fc_abs(double %0) {
entry:
  %sif_result = alloca i64, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = call i64 @forge_float_parse(ptr @.float_str)
  %cast = bitcast i64 %1 to double
  %fgt = fcmp ogt double %x1, %cast
  %fgt_ext = zext i1 %fgt to i64
  %sif_cond = icmp ne i64 %fgt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %x2 = load double, ptr %x, align 8
  %cast3 = bitcast double %x2 to i64
  store i64 %cast3, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %2 = call i64 @forge_float_parse(ptr @.float_str.15)
  %cast4 = bitcast i64 %2 to double
  %x5 = load double, ptr %x, align 8
  %fsub = fsub double %cast4, %x5
  %cast6 = bitcast double %fsub to i64
  store i64 %cast6, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast7 = bitcast i64 %sif_val to double
  ret double %cast7
}

define double @fc_safe_div(double %0, double %1) {
entry:
  %b = alloca double, align 8
  %a = alloca double, align 8
  store double %0, ptr %a, align 8
  store double %1, ptr %b, align 8
  %b1 = load double, ptr %b, align 8
  %2 = call i64 @forge_float_parse(ptr @.float_str.16)
  %cast = bitcast i64 %2 to double
  %feq = fcmp oeq double %b1, %cast
  %feq_ext = zext i1 %feq to i64
  %if_cond = icmp ne i64 %feq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %a2 = load double, ptr %a, align 8
  %b3 = load double, ptr %b, align 8
  %fdiv = fdiv double %a2, %b3
  ret double %fdiv

if_then:                                          ; preds = %entry
  ret double 0.000000e+00

if_else:                                          ; preds = %entry
  br label %ifcont
}

define double @fc_double_f(double %0) {
entry:
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = call i64 @forge_float_parse(ptr @.float_str.17)
  %cast = bitcast i64 %1 to double
  %fmul = fmul double %x1, %cast
  ret double %fmul
}

define i64 @main() {
entry:
  %bad = alloca double, align 8
  %r = alloca double, align 8
  %p = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_rc_alloc(i64 16)
  %2 = call i64 @forge_float_parse(ptr @.float_str.18)
  %cast = bitcast i64 %2 to double
  %fld_ptr = getelementptr inbounds nuw %FcPoint, ptr %1, i32 0, i32 0
  store double %cast, ptr %fld_ptr, align 8
  %3 = call i64 @forge_float_parse(ptr @.float_str.19)
  %cast1 = bitcast i64 %3 to double
  %fld_ptr2 = getelementptr inbounds nuw %FcPoint, ptr %1, i32 0, i32 1
  store double %cast1, ptr %fld_ptr2, align 8
  %cast3 = ptrtoint ptr %1 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  store ptr %cast4, ptr %p, align 8
  %p5 = load ptr, ptr %p, align 8
  %4 = call double @fc_dist_sq(ptr %p5)
  %5 = call i64 @forge_float_parse(ptr @.float_str.20)
  %cast6 = bitcast i64 %5 to double
  %feq = fcmp oeq double %4, %cast6
  %feq_ext = zext i1 %feq to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.21, i64 %feq_ext)
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %FcValue, ptr %7, i32 0, i32 0
  store i64 229424205840836, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %FcValue, ptr %7, i32 0, i32 1
  %8 = call ptr @forge_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr, align 8
  %9 = call i64 @forge_float_parse(ptr @.float_str.22)
  %cast7 = bitcast i64 %9 to double
  %slot_base = ptrtoint ptr %8 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store double %cast7, ptr %slot, align 8
  %cast8 = ptrtoint ptr %7 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  %10 = call ptr @fc_value_to_string(ptr %cast9)
  %11 = call i32 @strcmp(ptr %10, ptr @.str.23)
  %widen10 = sext i32 %11 to i64
  %streq_cmp = icmp eq i64 %widen10, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %12 = call i64 @forge_test_run_then(ptr @spec_str.24, i64 %streq_ext)
  %13 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %FcValue, ptr %13, i32 0, i32 0
  store i64 210674205209, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %FcValue, ptr %13, i32 0, i32 1
  %14 = call ptr @forge_rc_alloc(i64 8)
  store ptr %14, ptr %pay_ptr12, align 8
  %slot_base13 = ptrtoint ptr %14 to i64
  %slot_addr14 = add i64 %slot_base13, 0
  %slot15 = inttoptr i64 %slot_addr14 to ptr
  store i64 42, ptr %slot15, align 8
  %cast16 = ptrtoint ptr %13 to i64
  %cast17 = inttoptr i64 %cast16 to ptr
  %15 = call ptr @fc_value_to_string(ptr %cast17)
  %16 = call i32 @strcmp(ptr %15, ptr @.str.25)
  %widen18 = sext i32 %16 to i64
  %streq_cmp19 = icmp eq i64 %widen18, 0
  %streq_ext20 = zext i1 %streq_cmp19 to i64
  %17 = call i64 @forge_test_run_then(ptr @spec_str.26, i64 %streq_ext20)
  %18 = call i64 @forge_float_parse(ptr @.float_str.27)
  %cast21 = bitcast i64 %18 to double
  %19 = call ptr @fc_classify(double %cast21)
  %20 = call i32 @strcmp(ptr %19, ptr @.str.28)
  %widen22 = sext i32 %20 to i64
  %streq_cmp23 = icmp eq i64 %widen22, 0
  %streq_ext24 = zext i1 %streq_cmp23 to i64
  %21 = call i64 @forge_test_run_then(ptr @spec_str.29, i64 %streq_ext24)
  %22 = call i64 @forge_float_parse(ptr @.float_str.30)
  %cast25 = bitcast i64 %22 to double
  %23 = call ptr @fc_classify(double %cast25)
  %24 = call i32 @strcmp(ptr %23, ptr @.str.31)
  %widen26 = sext i32 %24 to i64
  %streq_cmp27 = icmp eq i64 %widen26, 0
  %streq_ext28 = zext i1 %streq_cmp27 to i64
  %25 = call i64 @forge_test_run_then(ptr @spec_str.32, i64 %streq_ext28)
  %26 = call i64 @forge_float_parse(ptr @.float_str.33)
  %cast29 = bitcast i64 %26 to double
  %27 = call ptr @fc_classify(double %cast29)
  %28 = call i32 @strcmp(ptr %27, ptr @.str.34)
  %widen30 = sext i32 %28 to i64
  %streq_cmp31 = icmp eq i64 %widen30, 0
  %streq_ext32 = zext i1 %streq_cmp31 to i64
  %29 = call i64 @forge_test_run_then(ptr @spec_str.35, i64 %streq_ext32)
  %30 = call i64 @forge_float_parse(ptr @.float_str.36)
  %cast33 = bitcast i64 %30 to double
  %31 = call i64 @forge_float_parse(ptr @.float_str.37)
  %cast34 = bitcast i64 %31 to double
  %fsub = fsub double %cast33, %cast34
  %32 = call double @fc_abs(double %fsub)
  %33 = call i64 @forge_float_parse(ptr @.float_str.38)
  %cast35 = bitcast i64 %33 to double
  %feq36 = fcmp oeq double %32, %cast35
  %feq_ext37 = zext i1 %feq36 to i64
  %34 = call i64 @forge_test_run_then(ptr @spec_str.39, i64 %feq_ext37)
  %35 = call i64 @forge_float_parse(ptr @.float_str.40)
  %cast38 = bitcast i64 %35 to double
  %36 = call i64 @forge_float_parse(ptr @.float_str.41)
  %cast39 = bitcast i64 %36 to double
  %37 = call double @fc_safe_div(double %cast38, double %cast39)
  store double %37, ptr %r, align 8
  %r40 = load double, ptr %r, align 8
  %fne = fcmp one double %r40, 0.000000e+00
  %fne_ext = zext i1 %fne to i64
  %38 = call i64 @forge_test_run_then(ptr @spec_str.42, i64 %fne_ext)
  %39 = call i64 @forge_float_parse(ptr @.float_str.43)
  %cast41 = bitcast i64 %39 to double
  %40 = call i64 @forge_float_parse(ptr @.float_str.44)
  %cast42 = bitcast i64 %40 to double
  %41 = call double @fc_safe_div(double %cast41, double %cast42)
  store double %41, ptr %bad, align 8
  %bad43 = load double, ptr %bad, align 8
  %feq44 = fcmp oeq double %bad43, 0.000000e+00
  %feq_ext45 = zext i1 %feq44 to i64
  %42 = call i64 @forge_test_run_then(ptr @spec_str.45, i64 %feq_ext45)
  %43 = call i64 @forge_float_parse(ptr @.float_str.46)
  %cast46 = bitcast i64 %43 to double
  %44 = call double @fc_double_f(double %cast46)
  %45 = call i64 @forge_float_parse(ptr @.float_str.47)
  %cast47 = bitcast i64 %45 to double
  %feq48 = fcmp oeq double %44, %cast47
  %feq_ext49 = zext i1 %feq48 to i64
  %46 = call i64 @forge_test_run_then(ptr @spec_str.48, i64 %feq_ext49)
  %47 = call i64 @forge_float_parse(ptr @.float_str.49)
  %cast50 = bitcast i64 %47 to double
  %48 = call i64 @forge_float_parse(ptr @.float_str.50)
  %cast51 = bitcast i64 %48 to double
  %fsub52 = fsub double %cast50, %cast51
  %49 = call i64 @forge_float_parse(ptr @.float_str.51)
  %cast53 = bitcast i64 %49 to double
  %fneg = fneg double %cast53
  %feq54 = fcmp oeq double %fsub52, %fneg
  %feq_ext55 = zext i1 %feq54 to i64
  %50 = call i64 @forge_test_run_then(ptr @spec_str.52, i64 %feq_ext55)
  %51 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen56 = sext i32 %51 to i64
  %52 = call i32 @forge_test_summary()
  %widen57 = sext i32 %52 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_FcValue(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %FcValue, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %FcValue, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_FcStr = icmp eq i64 %tag, 210674216295
  br i1 %is_FcStr, label %rel_FcStr, label %try_next_FcStr

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_FcStr, %vrel_s_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_FcStr:                                        ; preds = %do_free
  %vrel_s_ptr = getelementptr inbounds nuw %FcValue__FcStr, ptr %payload, i32 0, i32 0
  %vrel_s = load ptr, ptr %vrel_s_ptr, align 8
  %vrel_null_s = icmp eq ptr %vrel_s, null
  br i1 %vrel_null_s, label %vrel_s_skip, label %vrel_s_do

try_next_FcStr:                                   ; preds = %do_free
  br label %fields_done

vrel_s_skip:                                      ; preds = %vrel_s_do, %rel_FcStr
  br label %fields_done

vrel_s_do:                                        ; preds = %rel_FcStr
  call void @forge_rc_release(ptr %vrel_s)
  br label %vrel_s_skip
}
