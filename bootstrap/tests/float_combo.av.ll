; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { double, double }
%Value = type { i64, ptr }
%Value__Str = type { ptr }

@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/float_combo.av\00", align 1
@fld_name.1 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.2 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.3 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/float_combo.av\00", align 1
@fld_name.4 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.5 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.6 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/float_combo.av\00", align 1
@fld_name.7 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.8 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.9 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/float_combo.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [16 x i8] c"value_to_string\00", align 1
@mu_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/float_combo.av\00", align 1
@.float_str = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.flit_str = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.flit_str.10 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"one\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn.13 = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file.14 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/float_combo.av\00", align 1
@.float_str.15 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.16 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.str.17 = private unnamed_addr constant [10 x i8] c"value is \00", align 1
@.float_str.18 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.19 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.20 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.21 = private unnamed_addr constant [4 x i8] c"4.0\00", align 1
@.float_str.22 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.float_str.23 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.24 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.25 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.26 = private unnamed_addr constant [5 x i8] c"99.0\00", align 1
@.float_str.27 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.28 = private unnamed_addr constant [4 x i8] c"5.5\00", align 1
@.float_str.29 = private unnamed_addr constant [6 x i8] c"2.718\00", align 1
@.float_str.30 = private unnamed_addr constant [5 x i8] c"10.0\00", align 1
@.float_str.31 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.32 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.33 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.str.34 = private unnamed_addr constant [12 x i8] c"div by zero\00", align 1
@.float_str.35 = private unnamed_addr constant [4 x i8] c"1.5\00", align 1
@.float_str.36 = private unnamed_addr constant [4 x i8] c"0.1\00", align 1
@.float_str.37 = private unnamed_addr constant [4 x i8] c"0.2\00", align 1
@.float_str.38 = private unnamed_addr constant [10 x i8] c"1000000.0\00", align 1
@.float_str.39 = private unnamed_addr constant [10 x i8] c"1000000.0\00", align 1
@.float_str.40 = private unnamed_addr constant [4 x i8] c"0.0\00", align 1
@.float_str.41 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.42 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1

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

define double @dist(ptr %0) {
entry:
  %dy = alloca double, align 8
  %dx = alloca double, align 8
  %p = alloca ptr, align 8
  store ptr %0, ptr %p, align 8
  %p1 = load ptr, ptr %p, align 8
  %cast = ptrtoint ptr %p1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 97, i64 7)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 0
  %x = load double, ptr %x_ptr, align 8
  %p2 = load ptr, ptr %p, align 8
  %cast3 = ptrtoint ptr %p2 to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 1, ptr @sty_name.2, i64 5, i64 %null_ext5, ptr @src_file.3, i64 97, i64 7)
  %x_ptr6 = getelementptr inbounds nuw %Point, ptr %p2, i32 0, i32 0
  %x7 = load double, ptr %x_ptr6, align 8
  %fmul = fmul double %x, %x7
  store double %fmul, ptr %dx, align 8
  %p8 = load ptr, ptr %p, align 8
  %cast9 = ptrtoint ptr %p8 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 1, ptr @sty_name.5, i64 5, i64 %null_ext11, ptr @src_file.6, i64 97, i64 8)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p8, i32 0, i32 1
  %y = load double, ptr %y_ptr, align 8
  %p12 = load ptr, ptr %p, align 8
  %cast13 = ptrtoint ptr %p12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 1, ptr @sty_name.8, i64 5, i64 %null_ext15, ptr @src_file.9, i64 97, i64 8)
  %y_ptr16 = getelementptr inbounds nuw %Point, ptr %p12, i32 0, i32 1
  %y17 = load double, ptr %y_ptr16, align 8
  %fmul18 = fmul double %y, %y17
  store double %fmul18, ptr %dy, align 8
  %dx19 = load double, ptr %dx, align 8
  %dy20 = load double, ptr %dy, align 8
  %fadd = fadd double %dx19, %dy20
  ret double %fadd
}

define ptr @value_to_string(ptr %0) {
entry:
  %s17 = alloca ptr, align 8
  %f9 = alloca double, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %v = alloca ptr, align 8
  store ptr %0, ptr %v, align 8
  %v1 = load ptr, ptr %v, align 8
  %tag_ptr = getelementptr inbounds nuw %Value, ptr %v1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193460240
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm12, %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = inttoptr i64 %match_val to ptr
  ret ptr %cast20

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Value, ptr %v1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %n3 = load i64, ptr %n2, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %n3)
  %widen = sext i32 %2 to i64
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 210674569595
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Value, ptr %v1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %f_slot_base = ptrtoint ptr %payload8 to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load double, ptr %f_slot, align 8
  store double %f, ptr %f9, align 8
  %f10 = load double, ptr %f9, align 8
  %cast11 = bitcast double %f10 to i64
  %3 = call i64 @avra_float_to_string(i64 %cast11)
  store i64 %3, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  %tag_eq14 = icmp eq i64 %tag, 193471326
  br i1 %tag_eq14, label %march_arm12, label %march_next13

march_arm12:                                      ; preds = %march_next5
  %pay_slot15 = getelementptr inbounds nuw %Value, ptr %v1, i32 0, i32 1
  %payload16 = load ptr, ptr %pay_slot15, align 8
  %s_slot_base = ptrtoint ptr %payload16 to i64
  %s_slot_addr = add i64 %s_slot_base, 0
  %s_slot = inttoptr i64 %s_slot_addr to ptr
  %s = load ptr, ptr %s_slot, align 8
  call void @avra_rc_retain(ptr %s)
  store ptr %s, ptr %s17, align 8
  %s18 = load ptr, ptr %s17, align 8
  %cast19 = ptrtoint ptr %s18 to i64
  store i64 %cast19, ptr %match_result, align 8
  br label %match_end

march_next13:                                     ; preds = %march_next5
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 20)
  unreachable
}

define double @sum_floats(ptr %0) {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %total = alloca double, align 8
  %nums = alloca ptr, align 8
  store ptr %0, ptr %nums, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %1 to double
  store double %cast, ptr %total, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %2 = call i64 @avra_array_len(ptr %nums1)
  store i64 0, ptr %i, align 8
  store i64 %2, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i2 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i2, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %total3 = load double, ptr %total, align 8
  %nums4 = load ptr, ptr %nums, align 8
  %i5 = load i64, ptr %i, align 8
  %3 = call i64 @avra_array_get(ptr %nums4, i64 %i5)
  %cast6 = bitcast i64 %3 to double
  %fadd = fadd double %total3, %cast6
  store double %fadd, ptr %total, align 8
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i7 = load i64, ptr %i, align 8
  %for_next = add i64 %i7, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %total8 = load double, ptr %total, align 8
  ret double %total8
}

define ptr @classify(double %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  store i64 0, ptr %pmatch_result, align 8
  %1 = call i64 @avra_float_parse(ptr @.flit_str)
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
  %2 = call i64 @avra_float_parse(ptr @.flit_str.10)
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
  call void @avra_match_unreachable(ptr @.match_fn.13, i64 -1, ptr @mu_file.14, i64 42)
  unreachable
}

define double @abs(double %0) {
entry:
  %sif_result = alloca i64, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str.15)
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
  %2 = call i64 @avra_float_parse(ptr @.float_str.16)
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

define ptr @describe(double %0) {
entry:
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %cast = bitcast double %x1 to i64
  %1 = call i64 @avra_float_to_string(i64 %cast)
  %rhs_ptr = inttoptr i64 %1 to ptr
  %2 = call i64 @strlen(ptr @.str.17)
  %3 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr @.str.17, i64 %2)
  %cast2 = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast2, %2
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast3, ptr %rhs_ptr, i64 %rhs_len_p1)
  ret ptr %4
}

define double @safe_div(double %0, double %1) {
entry:
  %b = alloca double, align 8
  %a = alloca double, align 8
  store double %0, ptr %a, align 8
  store double %1, ptr %b, align 8
  %b1 = load double, ptr %b, align 8
  %2 = call i64 @avra_float_parse(ptr @.float_str.18)
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

define double @double_f(double %0) {
entry:
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str.19)
  %cast = bitcast i64 %1 to double
  %fmul = fmul double %x1, %cast
  ret double %fmul
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %bad = alloca double, align 8
  %r = alloca double, align 8
  %double_val = alloca ptr, align 8
  %p = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %2 = call i64 @avra_float_parse(ptr @.float_str.20)
  %cast = bitcast i64 %2 to double
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %1, i32 0, i32 0
  store double %cast, ptr %fld_ptr, align 8
  %3 = call i64 @avra_float_parse(ptr @.float_str.21)
  %cast1 = bitcast i64 %3 to double
  %fld_ptr2 = getelementptr inbounds nuw %Point, ptr %1, i32 0, i32 1
  store double %cast1, ptr %fld_ptr2, align 8
  %cast3 = ptrtoint ptr %1 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  store ptr %cast4, ptr %p, align 8
  %p5 = load ptr, ptr %p, align 8
  %4 = call double @dist(ptr %p5)
  %cast6 = bitcast double %4 to i64
  %5 = call i64 @avra_float_to_string(i64 %cast6)
  %cast7 = inttoptr i64 %5 to ptr
  %6 = call i32 @puts(ptr %cast7)
  %widen = sext i32 %6 to i64
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Value, ptr %7, i32 0, i32 0
  store i64 210674569595, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Value, ptr %7, i32 0, i32 1
  %8 = call ptr @avra_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr, align 8
  %9 = call i64 @avra_float_parse(ptr @.float_str.22)
  %cast8 = bitcast i64 %9 to double
  %slot_base = ptrtoint ptr %8 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store double %cast8, ptr %slot, align 8
  %cast9 = ptrtoint ptr %7 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  %10 = call ptr @value_to_string(ptr %cast10)
  %11 = call i32 @puts(ptr %10)
  %widen11 = sext i32 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr12 = getelementptr inbounds nuw %Value, ptr %12, i32 0, i32 0
  store i64 193460240, ptr %tag_ptr12, align 8
  %pay_ptr13 = getelementptr inbounds nuw %Value, ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 8)
  store ptr %13, ptr %pay_ptr13, align 8
  %slot_base14 = ptrtoint ptr %13 to i64
  %slot_addr15 = add i64 %slot_base14, 0
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  store i64 42, ptr %slot16, align 8
  %cast17 = ptrtoint ptr %12 to i64
  %cast18 = inttoptr i64 %cast17 to ptr
  %14 = call ptr @value_to_string(ptr %cast18)
  %15 = call i32 @puts(ptr %14)
  %widen19 = sext i32 %15 to i64
  %16 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %16, i64 -559038737)
  call void @avra_array_push(ptr %16, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast20 = ptrtoint ptr %16 to i64
  %cast21 = inttoptr i64 %cast20 to ptr
  store ptr %cast21, ptr %double_val, align 8
  %double_val22 = load i64, ptr %double_val, align 8
  %cast23 = inttoptr i64 %double_val22 to ptr
  %17 = call i64 @avra_array_get(ptr %cast23, i64 1)
  %fn_ptr = inttoptr i64 %17 to ptr
  %closure_call = call i64 %fn_ptr(i64 5)
  %18 = call i64 @avra_float_to_string(i64 %closure_call)
  %cast24 = inttoptr i64 %18 to ptr
  %19 = call i32 @puts(ptr %cast24)
  %widen25 = sext i32 %19 to i64
  %20 = call i64 @avra_float_parse(ptr @.float_str.24)
  %cast26 = bitcast i64 %20 to double
  %21 = call ptr @classify(double %cast26)
  %22 = call i32 @puts(ptr %21)
  %widen27 = sext i32 %22 to i64
  %23 = call i64 @avra_float_parse(ptr @.float_str.25)
  %cast28 = bitcast i64 %23 to double
  %24 = call ptr @classify(double %cast28)
  %25 = call i32 @puts(ptr %24)
  %widen29 = sext i32 %25 to i64
  %26 = call i64 @avra_float_parse(ptr @.float_str.26)
  %cast30 = bitcast i64 %26 to double
  %27 = call ptr @classify(double %cast30)
  %28 = call i32 @puts(ptr %27)
  %widen31 = sext i32 %28 to i64
  %29 = call i64 @avra_float_parse(ptr @.float_str.27)
  %cast32 = bitcast i64 %29 to double
  %30 = call i64 @avra_float_parse(ptr @.float_str.28)
  %cast33 = bitcast i64 %30 to double
  %fsub = fsub double %cast32, %cast33
  %31 = call double @abs(double %fsub)
  %cast34 = bitcast double %31 to i64
  %32 = call i64 @avra_float_to_string(i64 %cast34)
  %cast35 = inttoptr i64 %32 to ptr
  %33 = call i32 @puts(ptr %cast35)
  %widen36 = sext i32 %33 to i64
  %34 = call i64 @avra_float_parse(ptr @.float_str.29)
  %cast37 = bitcast i64 %34 to double
  %35 = call ptr @describe(double %cast37)
  %36 = call i32 @puts(ptr %35)
  %widen38 = sext i32 %36 to i64
  %37 = call i64 @avra_float_parse(ptr @.float_str.30)
  %cast39 = bitcast i64 %37 to double
  %38 = call i64 @avra_float_parse(ptr @.float_str.31)
  %cast40 = bitcast i64 %38 to double
  %39 = call double @safe_div(double %cast39, double %cast40)
  store double %39, ptr %r, align 8
  %r41 = load double, ptr %r, align 8
  %fne = fcmp one double %r41, 0.000000e+00
  %fne_ext = zext i1 %fne to i64
  %if_cond = icmp ne i64 %fne_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %40 = call i64 @avra_float_parse(ptr @.float_str.32)
  %cast46 = bitcast i64 %40 to double
  %41 = call i64 @avra_float_parse(ptr @.float_str.33)
  %cast47 = bitcast i64 %41 to double
  %42 = call double @safe_div(double %cast46, double %cast47)
  store double %42, ptr %bad, align 8
  %bad48 = load double, ptr %bad, align 8
  %feq = fcmp oeq double %bad48, 0.000000e+00
  %feq_ext = zext i1 %feq to i64
  %if_cond50 = icmp ne i64 %feq_ext, 0
  br i1 %if_cond50, label %if_then51, label %if_else52

if_then:                                          ; preds = %entry
  %r42 = load double, ptr %r, align 8
  %cast43 = bitcast double %r42 to i64
  %43 = call i64 @avra_float_to_string(i64 %cast43)
  %cast44 = inttoptr i64 %43 to ptr
  %44 = call i32 @puts(ptr %cast44)
  %widen45 = sext i32 %44 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont49:                                         ; preds = %if_else52, %if_then51
  %45 = call i64 @avra_float_parse(ptr @.float_str.35)
  %cast54 = bitcast i64 %45 to double
  %46 = call double @double_f(double %cast54)
  %cast55 = bitcast double %46 to i64
  %47 = call i64 @avra_float_to_string(i64 %cast55)
  %cast56 = inttoptr i64 %47 to ptr
  %48 = call i32 @puts(ptr %cast56)
  %widen57 = sext i32 %48 to i64
  %49 = call i64 @avra_float_parse(ptr @.float_str.36)
  %cast58 = bitcast i64 %49 to double
  %50 = call i64 @avra_float_parse(ptr @.float_str.37)
  %cast59 = bitcast i64 %50 to double
  %fadd = fadd double %cast58, %cast59
  %cast60 = bitcast double %fadd to i64
  %51 = call i64 @avra_float_to_string(i64 %cast60)
  %cast61 = inttoptr i64 %51 to ptr
  %52 = call i32 @puts(ptr %cast61)
  %widen62 = sext i32 %52 to i64
  %53 = call i64 @avra_float_parse(ptr @.float_str.38)
  %cast63 = bitcast i64 %53 to double
  %54 = call i64 @avra_float_parse(ptr @.float_str.39)
  %cast64 = bitcast i64 %54 to double
  %fmul = fmul double %cast63, %cast64
  %cast65 = bitcast double %fmul to i64
  %55 = call i64 @avra_float_to_string(i64 %cast65)
  %cast66 = inttoptr i64 %55 to ptr
  %56 = call i32 @puts(ptr %cast66)
  %widen67 = sext i32 %56 to i64
  %57 = call i64 @avra_float_parse(ptr @.float_str.40)
  %cast68 = bitcast i64 %57 to double
  %58 = call i64 @avra_float_parse(ptr @.float_str.41)
  %cast69 = bitcast i64 %58 to double
  %fsub70 = fsub double %cast68, %cast69
  %cast71 = bitcast double %fsub70 to i64
  %59 = call i64 @avra_float_to_string(i64 %cast71)
  %cast72 = inttoptr i64 %59 to ptr
  %60 = call i32 @puts(ptr %cast72)
  %widen73 = sext i32 %60 to i64
  %61 = call i64 @avra_float_parse(ptr @.float_str.42)
  %cast74 = bitcast i64 %61 to double
  %fadd75 = fadd double %cast74, 1.000000e+00
  %cast76 = bitcast double %fadd75 to i64
  %62 = call i64 @avra_float_to_string(i64 %cast76)
  %cast77 = inttoptr i64 %62 to ptr
  %63 = call i32 @puts(ptr %cast77)
  %widen78 = sext i32 %63 to i64
  ret i64 0

if_then51:                                        ; preds = %ifcont
  %64 = call i32 @puts(ptr @.str.34)
  %widen53 = sext i32 %64 to i64
  br label %ifcont49

if_else52:                                        ; preds = %ifcont
  br label %ifcont49
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Value(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Value, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Value, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Str = icmp eq i64 %tag, 193471326
  br i1 %is_Str, label %rel_Str, label %try_next_Str

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Str, %vrel_s_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Str:                                          ; preds = %do_free
  %vrel_s_ptr = getelementptr inbounds nuw %Value__Str, ptr %payload, i32 0, i32 0
  %vrel_s = load ptr, ptr %vrel_s_ptr, align 8
  %vrel_null_s = icmp eq ptr %vrel_s, null
  br i1 %vrel_null_s, label %vrel_s_skip, label %vrel_s_do

try_next_Str:                                     ; preds = %do_free
  br label %fields_done

vrel_s_skip:                                      ; preds = %vrel_s_do, %rel_Str
  br label %fields_done

vrel_s_do:                                        ; preds = %rel_Str
  call void @avra_rc_release(ptr %vrel_s)
  br label %vrel_s_skip
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %i2f = sitofp i64 %x1 to double
  %1 = call i64 @avra_float_parse(ptr @.float_str.23)
  %cast = bitcast i64 %1 to double
  %fmul = fmul double %i2f, %cast
  %cast2 = bitcast double %fmul to i64
  ret i64 %cast2
}
