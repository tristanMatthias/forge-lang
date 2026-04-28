; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.float_str.1 = private unnamed_addr constant [6 x i8] c"2.718\00", align 1
@.float_str.2 = private unnamed_addr constant [4 x i8] c"0.5\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"9.81\00", align 1
@.float_str.3 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.4 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.5 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.6 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.7 = private unnamed_addr constant [5 x i8] c"10.0\00", align 1
@.float_str.8 = private unnamed_addr constant [4 x i8] c"4.0\00", align 1
@.float_str.9 = private unnamed_addr constant [5 x i8] c"10.0\00", align 1
@.float_str.10 = private unnamed_addr constant [4 x i8] c"3.5\00", align 1
@.float_str.11 = private unnamed_addr constant [4 x i8] c"1.5\00", align 1
@.float_str.12 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.float_str.13 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.str.14 = private unnamed_addr constant [3 x i8] c"gt\00", align 1
@.float_str.15 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.16 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"lt\00", align 1
@.float_str.18 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.19 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.str.20 = private unnamed_addr constant [3 x i8] c"eq\00", align 1
@.float_str.21 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.flit_str = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.str.22 = private unnamed_addr constant [4 x i8] c"one\00", align 1
@.flit_str.23 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c"pi\00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [126 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/float_lit/example.av\00", align 1

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
  %0 = call i64 @__bs_top_level()
  %pmatch_result = alloca i64, align 8
  %val = alloca double, align 8
  %sum = alloca double, align 8
  %b = alloca double, align 8
  %a = alloca double, align 8
  %z = alloca double, align 8
  %y = alloca double, align 8
  %x = alloca double, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %1 to double
  store double %cast, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %cast2 = bitcast double %x1 to i64
  %2 = call i64 @avra_float_to_string(i64 %cast2)
  %cast3 = inttoptr i64 %2 to ptr
  %3 = call i32 @puts(ptr %cast3)
  %widen = sext i32 %3 to i64
  %4 = call i64 @avra_float_parse(ptr @.float_str.1)
  %cast4 = bitcast i64 %4 to double
  store double %cast4, ptr %y, align 8
  %y5 = load double, ptr %y, align 8
  %cast6 = bitcast double %y5 to i64
  %5 = call i64 @avra_float_to_string(i64 %cast6)
  %cast7 = inttoptr i64 %5 to ptr
  %6 = call i32 @puts(ptr %cast7)
  %widen8 = sext i32 %6 to i64
  %7 = call i64 @avra_float_parse(ptr @.float_str.2)
  %cast9 = bitcast i64 %7 to double
  store double %cast9, ptr %z, align 8
  %z10 = load double, ptr %z, align 8
  %cast11 = bitcast double %z10 to i64
  %8 = call i64 @avra_float_to_string(i64 %cast11)
  %cast12 = inttoptr i64 %8 to ptr
  %9 = call i32 @puts(ptr %cast12)
  %widen13 = sext i32 %9 to i64
  %10 = call i64 @avra_float_parse(ptr @.str)
  %cast14 = bitcast i64 %10 to double
  store double %cast14, ptr %a, align 8
  %a15 = load double, ptr %a, align 8
  %cast16 = bitcast double %a15 to i64
  %11 = call i64 @avra_float_to_string(i64 %cast16)
  %cast17 = inttoptr i64 %11 to ptr
  %12 = call i32 @puts(ptr %cast17)
  %widen18 = sext i32 %12 to i64
  store double 1.000000e+02, ptr %b, align 8
  %b19 = load double, ptr %b, align 8
  %cast20 = bitcast double %b19 to i64
  %13 = call i64 @avra_float_to_string(i64 %cast20)
  %cast21 = inttoptr i64 %13 to ptr
  %14 = call i32 @puts(ptr %cast21)
  %widen22 = sext i32 %14 to i64
  %15 = call i64 @avra_float_parse(ptr @.float_str.3)
  %cast23 = bitcast i64 %15 to double
  %16 = call i64 @avra_float_parse(ptr @.float_str.4)
  %cast24 = bitcast i64 %16 to double
  %fadd = fadd double %cast23, %cast24
  store double %fadd, ptr %sum, align 8
  %sum25 = load double, ptr %sum, align 8
  %cast26 = bitcast double %sum25 to i64
  %17 = call i64 @avra_float_to_string(i64 %cast26)
  %cast27 = inttoptr i64 %17 to ptr
  %18 = call i32 @puts(ptr %cast27)
  %widen28 = sext i32 %18 to i64
  %19 = call i64 @avra_float_parse(ptr @.float_str.5)
  %cast29 = bitcast i64 %19 to double
  %20 = call i64 @avra_float_parse(ptr @.float_str.6)
  %cast30 = bitcast i64 %20 to double
  %fmul = fmul double %cast29, %cast30
  %cast31 = bitcast double %fmul to i64
  %21 = call i64 @avra_float_to_string(i64 %cast31)
  %cast32 = inttoptr i64 %21 to ptr
  %22 = call i32 @puts(ptr %cast32)
  %widen33 = sext i32 %22 to i64
  %23 = call i64 @avra_float_parse(ptr @.float_str.7)
  %cast34 = bitcast i64 %23 to double
  %24 = call i64 @avra_float_parse(ptr @.float_str.8)
  %cast35 = bitcast i64 %24 to double
  %fdiv = fdiv double %cast34, %cast35
  %cast36 = bitcast double %fdiv to i64
  %25 = call i64 @avra_float_to_string(i64 %cast36)
  %cast37 = inttoptr i64 %25 to ptr
  %26 = call i32 @puts(ptr %cast37)
  %widen38 = sext i32 %26 to i64
  %27 = call i64 @avra_float_parse(ptr @.float_str.9)
  %cast39 = bitcast i64 %27 to double
  %28 = call i64 @avra_float_parse(ptr @.float_str.10)
  %cast40 = bitcast i64 %28 to double
  %fsub = fsub double %cast39, %cast40
  %cast41 = bitcast double %fsub to i64
  %29 = call i64 @avra_float_to_string(i64 %cast41)
  %cast42 = inttoptr i64 %29 to ptr
  %30 = call i32 @puts(ptr %cast42)
  %widen43 = sext i32 %30 to i64
  %31 = call i64 @avra_float_parse(ptr @.float_str.11)
  %cast44 = bitcast i64 %31 to double
  %fneg = fneg double %cast44
  %cast45 = bitcast double %fneg to i64
  %32 = call i64 @avra_float_to_string(i64 %cast45)
  %cast46 = inttoptr i64 %32 to ptr
  %33 = call i32 @puts(ptr %cast46)
  %widen47 = sext i32 %33 to i64
  %34 = call i64 @avra_float_parse(ptr @.float_str.12)
  %cast48 = bitcast i64 %34 to double
  %35 = call i64 @avra_float_parse(ptr @.float_str.13)
  %cast49 = bitcast i64 %35 to double
  %fgt = fcmp ogt double %cast48, %cast49
  %fgt_ext = zext i1 %fgt to i64
  %if_cond = icmp ne i64 %fgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %36 = call i64 @avra_float_parse(ptr @.float_str.15)
  %cast51 = bitcast i64 %36 to double
  %37 = call i64 @avra_float_parse(ptr @.float_str.16)
  %cast52 = bitcast i64 %37 to double
  %flt = fcmp olt double %cast51, %cast52
  %flt_ext = zext i1 %flt to i64
  %if_cond54 = icmp ne i64 %flt_ext, 0
  br i1 %if_cond54, label %if_then55, label %if_else56

if_then:                                          ; preds = %entry
  %38 = call i32 @puts(ptr @.str.14)
  %widen50 = sext i32 %38 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont53:                                         ; preds = %if_else56, %if_then55
  %39 = call i64 @avra_float_parse(ptr @.float_str.18)
  %cast58 = bitcast i64 %39 to double
  %40 = call i64 @avra_float_parse(ptr @.float_str.19)
  %cast59 = bitcast i64 %40 to double
  %feq = fcmp oeq double %cast58, %cast59
  %feq_ext = zext i1 %feq to i64
  %if_cond61 = icmp ne i64 %feq_ext, 0
  br i1 %if_cond61, label %if_then62, label %if_else63

if_then55:                                        ; preds = %ifcont
  %41 = call i32 @puts(ptr @.str.17)
  %widen57 = sext i32 %41 to i64
  br label %ifcont53

if_else56:                                        ; preds = %ifcont
  br label %ifcont53

ifcont60:                                         ; preds = %if_else63, %if_then62
  %42 = call i64 @avra_float_parse(ptr @.float_str.21)
  %cast65 = bitcast i64 %42 to double
  store double %cast65, ptr %val, align 8
  %val66 = load double, ptr %val, align 8
  store i64 0, ptr %pmatch_result, align 8
  %43 = call i64 @avra_float_parse(ptr @.flit_str)
  %cast67 = bitcast i64 %43 to double
  %flit_eq = fcmp oeq double %val66, %cast67
  br i1 %flit_eq, label %parm_body, label %parm_next

if_then62:                                        ; preds = %ifcont53
  %44 = call i32 @puts(ptr @.str.20)
  %widen64 = sext i32 %44 to i64
  br label %ifcont60

if_else63:                                        ; preds = %ifcont53
  br label %ifcont60

pmatch_end:                                       ; preds = %parm_body74, %parm_body69, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  ret i64 %pmatch_val

parm_body:                                        ; preds = %ifcont60
  %45 = call i32 @puts(ptr @.str.22)
  %widen68 = sext i32 %45 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %ifcont60
  %46 = call i64 @avra_float_parse(ptr @.flit_str.23)
  %cast71 = bitcast i64 %46 to double
  %flit_eq72 = fcmp oeq double %val66, %cast71
  br i1 %flit_eq72, label %parm_body69, label %parm_next70

parm_body69:                                      ; preds = %parm_next
  %47 = call i32 @puts(ptr @.str.24)
  %widen73 = sext i32 %47 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next70:                                      ; preds = %parm_next
  br label %parm_body74

parm_body74:                                      ; preds = %parm_next70
  %48 = call i32 @puts(ptr @.str.25)
  %widen76 = sext i32 %48 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next75:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 45)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
