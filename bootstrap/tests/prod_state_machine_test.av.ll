; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%PsmState = type { i64, ptr }
%PsmState__PsmError = type { ptr }

@.str = private unnamed_addr constant [6 x i8] c"start\00", align 1
@.str.1 = private unnamed_addr constant [24 x i8] c"invalid action for idle\00", align 1
@.match_fn = private unnamed_addr constant [15 x i8] c"psm_transition\00", align 1
@mu_file = private unnamed_addr constant [33 x i8] c"tests/prod_state_machine_test.fg\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"progress\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"pause\00", align 1
@.str.4 = private unnamed_addr constant [27 x i8] c"invalid action for running\00", align 1
@.match_fn.5 = private unnamed_addr constant [15 x i8] c"psm_transition\00", align 1
@mu_file.6 = private unnamed_addr constant [33 x i8] c"tests/prod_state_machine_test.fg\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"resume\00", align 1
@.str.8 = private unnamed_addr constant [26 x i8] c"invalid action for paused\00", align 1
@.match_fn.9 = private unnamed_addr constant [15 x i8] c"psm_transition\00", align 1
@mu_file.10 = private unnamed_addr constant [33 x i8] c"tests/prod_state_machine_test.fg\00", align 1
@.match_fn.11 = private unnamed_addr constant [15 x i8] c"psm_transition\00", align 1
@mu_file.12 = private unnamed_addr constant [33 x i8] c"tests/prod_state_machine_test.fg\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"idle\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"running(\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.16 = private unnamed_addr constant [8 x i8] c"paused(\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"done(\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.22 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn.23 = private unnamed_addr constant [10 x i8] c"psm_label\00", align 1
@mu_file.24 = private unnamed_addr constant [33 x i8] c"tests/prod_state_machine_test.fg\00", align 1
@.str.25 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@spec_str = private unnamed_addr constant [21 x i8] c"\22prod state machine\22\00", align 1
@.str.26 = private unnamed_addr constant [6 x i8] c"start\00", align 1
@.str.27 = private unnamed_addr constant [11 x i8] c"running(0)\00", align 1
@spec_str.28 = private unnamed_addr constant [18 x i8] c"\22start from idle\22\00", align 1
@.str.29 = private unnamed_addr constant [9 x i8] c"progress\00", align 1
@.str.30 = private unnamed_addr constant [12 x i8] c"running(25)\00", align 1
@spec_str.31 = private unnamed_addr constant [16 x i8] c"\22progress step\22\00", align 1
@.str.32 = private unnamed_addr constant [6 x i8] c"pause\00", align 1
@.str.33 = private unnamed_addr constant [7 x i8] c"resume\00", align 1
@.str.34 = private unnamed_addr constant [12 x i8] c"running(50)\00", align 1
@spec_str.35 = private unnamed_addr constant [19 x i8] c"\22pause and resume\22\00", align 1
@.str.36 = private unnamed_addr constant [6 x i8] c"start\00", align 1
@.str.37 = private unnamed_addr constant [9 x i8] c"progress\00", align 1
@.str.38 = private unnamed_addr constant [9 x i8] c"progress\00", align 1
@.str.39 = private unnamed_addr constant [9 x i8] c"progress\00", align 1
@.str.40 = private unnamed_addr constant [9 x i8] c"progress\00", align 1
@.str.41 = private unnamed_addr constant [9 x i8] c"progress\00", align 1
@.str.42 = private unnamed_addr constant [10 x i8] c"done(100)\00", align 1
@spec_str.43 = private unnamed_addr constant [19 x i8] c"\22full run to done\22\00", align 1

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

define ptr @psm_transition(ptr %0, ptr %1) {
entry:
  %pmatch_result73 = alloca i64, align 8
  %at71 = alloca i64, align 8
  %pmatch_result18 = alloca i64, align 8
  %p16 = alloca i64, align 8
  %pmatch_result = alloca i64, align 8
  %match_result = alloca i64, align 8
  %action = alloca ptr, align 8
  %state = alloca ptr, align 8
  store ptr %0, ptr %state, align 8
  store ptr %1, ptr %action, align 8
  %state1 = load ptr, ptr %state, align 8
  %tag_ptr = getelementptr inbounds nuw %PsmState, ptr %state1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 229437791668307
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm98, %pmatch_end74, %pmatch_end19, %pmatch_end
  %match_val = load i64, ptr %match_result, align 8
  %cast102 = inttoptr i64 %match_val to ptr
  ret ptr %cast102

march_arm:                                        ; preds = %entry
  %action2 = load ptr, ptr %action, align 8
  store i64 0, ptr %pmatch_result, align 8
  %action3 = load ptr, ptr %action, align 8
  %2 = call i32 @strcmp(ptr %action3, ptr @.str)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %pguard = icmp ne i64 %streq_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

march_next:                                       ; preds = %entry
  %tag_eq15 = icmp eq i64 %tag, 8245305931475275414
  br i1 %tag_eq15, label %march_arm13, label %march_next14

pmatch_end:                                       ; preds = %parm_body5, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  store i64 %pmatch_val, ptr %match_result, align 8
  br label %match_end

parm_body:                                        ; preds = %march_arm
  %3 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %PsmState, ptr %3, i32 0, i32 0
  store i64 8245305931475275414, ptr %tag_ptr4, align 8
  %pay_ptr = getelementptr inbounds nuw %PsmState, ptr %3, i32 0, i32 1
  %4 = call ptr @forge_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 0, ptr %slot, align 8
  %cast = ptrtoint ptr %3 to i64
  store i64 %cast, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %march_arm
  br label %parm_body5

parm_body5:                                       ; preds = %parm_next
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr7 = getelementptr inbounds nuw %PsmState, ptr %5, i32 0, i32 0
  store i64 7571447120820543, ptr %tag_ptr7, align 8
  %pay_ptr8 = getelementptr inbounds nuw %PsmState, ptr %5, i32 0, i32 1
  %6 = call ptr @forge_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr8, align 8
  %slot_base9 = ptrtoint ptr %6 to i64
  %slot_addr10 = add i64 %slot_base9, 0
  %slot11 = inttoptr i64 %slot_addr10 to ptr
  store ptr @.str.1, ptr %slot11, align 8
  %cast12 = ptrtoint ptr %5 to i64
  store i64 %cast12, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next6:                                       ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 15)
  unreachable

march_arm13:                                      ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %PsmState, ptr %state1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %p_slot_base = ptrtoint ptr %payload to i64
  %p_slot_addr = add i64 %p_slot_base, 0
  %p_slot = inttoptr i64 %p_slot_addr to ptr
  %p = load i64, ptr %p_slot, align 8
  store i64 %p, ptr %p16, align 8
  %action17 = load ptr, ptr %action, align 8
  store i64 0, ptr %pmatch_result18, align 8
  %action22 = load ptr, ptr %action, align 8
  %7 = call i32 @strcmp(ptr %action22, ptr @.str.2)
  %widen23 = sext i32 %7 to i64
  %streq_cmp24 = icmp eq i64 %widen23, 0
  %streq_ext25 = zext i1 %streq_cmp24 to i64
  %pguard26 = icmp ne i64 %streq_ext25, 0
  br i1 %pguard26, label %parm_body20, label %parm_next21

march_next14:                                     ; preds = %march_next
  %tag_eq68 = icmp eq i64 %tag, 249857755397518423
  br i1 %tag_eq68, label %march_arm66, label %march_next67

pmatch_end19:                                     ; preds = %parm_body57, %parm_body43, %ifcont
  %pmatch_val65 = load i64, ptr %pmatch_result18, align 8
  store i64 %pmatch_val65, ptr %match_result, align 8
  br label %match_end

parm_body20:                                      ; preds = %march_arm13
  %p27 = load i64, ptr %p16, align 8
  %sge = icmp sge i64 %p27, 100
  %sge_ext = zext i1 %sge to i64
  %if_cond = icmp ne i64 %sge_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

parm_next21:                                      ; preds = %march_arm13
  %action45 = load ptr, ptr %action, align 8
  %8 = call i32 @strcmp(ptr %action45, ptr @.str.3)
  %widen46 = sext i32 %8 to i64
  %streq_cmp47 = icmp eq i64 %widen46, 0
  %streq_ext48 = zext i1 %streq_cmp47 to i64
  %pguard49 = icmp ne i64 %streq_ext48, 0
  br i1 %pguard49, label %parm_body43, label %parm_next44

ifcont:                                           ; preds = %if_else
  %9 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %PsmState, ptr %9, i32 0, i32 0
  store i64 8245305931475275414, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %PsmState, ptr %9, i32 0, i32 1
  %10 = call ptr @forge_rc_alloc(i64 8)
  store ptr %10, ptr %pay_ptr37, align 8
  %p38 = load i64, ptr %p16, align 8
  %add = add i64 %p38, 25
  %slot_base39 = ptrtoint ptr %10 to i64
  %slot_addr40 = add i64 %slot_base39, 0
  %slot41 = inttoptr i64 %slot_addr40 to ptr
  store i64 %add, ptr %slot41, align 8
  %cast42 = ptrtoint ptr %9 to i64
  store i64 %cast42, ptr %pmatch_result18, align 8
  br label %pmatch_end19

if_then:                                          ; preds = %parm_body20
  %11 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr28 = getelementptr inbounds nuw %PsmState, ptr %11, i32 0, i32 0
  store i64 229437791500667, ptr %tag_ptr28, align 8
  %pay_ptr29 = getelementptr inbounds nuw %PsmState, ptr %11, i32 0, i32 1
  %12 = call ptr @forge_rc_alloc(i64 8)
  store ptr %12, ptr %pay_ptr29, align 8
  %p30 = load i64, ptr %p16, align 8
  %slot_base31 = ptrtoint ptr %12 to i64
  %slot_addr32 = add i64 %slot_base31, 0
  %slot33 = inttoptr i64 %slot_addr32 to ptr
  store i64 %p30, ptr %slot33, align 8
  %cast34 = ptrtoint ptr %11 to i64
  %cast35 = inttoptr i64 %cast34 to ptr
  ret ptr %cast35

if_else:                                          ; preds = %parm_body20
  br label %ifcont

parm_body43:                                      ; preds = %parm_next21
  %13 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr50 = getelementptr inbounds nuw %PsmState, ptr %13, i32 0, i32 0
  store i64 249857755397518423, ptr %tag_ptr50, align 8
  %pay_ptr51 = getelementptr inbounds nuw %PsmState, ptr %13, i32 0, i32 1
  %14 = call ptr @forge_rc_alloc(i64 8)
  store ptr %14, ptr %pay_ptr51, align 8
  %p52 = load i64, ptr %p16, align 8
  %slot_base53 = ptrtoint ptr %14 to i64
  %slot_addr54 = add i64 %slot_base53, 0
  %slot55 = inttoptr i64 %slot_addr54 to ptr
  store i64 %p52, ptr %slot55, align 8
  %cast56 = ptrtoint ptr %13 to i64
  store i64 %cast56, ptr %pmatch_result18, align 8
  br label %pmatch_end19

parm_next44:                                      ; preds = %parm_next21
  br label %parm_body57

parm_body57:                                      ; preds = %parm_next44
  %15 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr59 = getelementptr inbounds nuw %PsmState, ptr %15, i32 0, i32 0
  store i64 7571447120820543, ptr %tag_ptr59, align 8
  %pay_ptr60 = getelementptr inbounds nuw %PsmState, ptr %15, i32 0, i32 1
  %16 = call ptr @forge_rc_alloc(i64 8)
  store ptr %16, ptr %pay_ptr60, align 8
  %slot_base61 = ptrtoint ptr %16 to i64
  %slot_addr62 = add i64 %slot_base61, 0
  %slot63 = inttoptr i64 %slot_addr62 to ptr
  store ptr @.str.4, ptr %slot63, align 8
  %cast64 = ptrtoint ptr %15 to i64
  store i64 %cast64, ptr %pmatch_result18, align 8
  br label %pmatch_end19

parm_next58:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.5, i64 -1, ptr @mu_file.6, i64 22)
  unreachable

march_arm66:                                      ; preds = %march_next14
  %pay_slot69 = getelementptr inbounds nuw %PsmState, ptr %state1, i32 0, i32 1
  %payload70 = load ptr, ptr %pay_slot69, align 8
  %at_slot_base = ptrtoint ptr %payload70 to i64
  %at_slot_addr = add i64 %at_slot_base, 0
  %at_slot = inttoptr i64 %at_slot_addr to ptr
  %at = load i64, ptr %at_slot, align 8
  store i64 %at, ptr %at71, align 8
  %action72 = load ptr, ptr %action, align 8
  store i64 0, ptr %pmatch_result73, align 8
  %action77 = load ptr, ptr %action, align 8
  %17 = call i32 @strcmp(ptr %action77, ptr @.str.7)
  %widen78 = sext i32 %17 to i64
  %streq_cmp79 = icmp eq i64 %widen78, 0
  %streq_ext80 = zext i1 %streq_cmp79 to i64
  %pguard81 = icmp ne i64 %streq_ext80, 0
  br i1 %pguard81, label %parm_body75, label %parm_next76

march_next67:                                     ; preds = %march_next14
  br label %march_arm98

pmatch_end74:                                     ; preds = %parm_body89, %parm_body75
  %pmatch_val97 = load i64, ptr %pmatch_result73, align 8
  store i64 %pmatch_val97, ptr %match_result, align 8
  br label %match_end

parm_body75:                                      ; preds = %march_arm66
  %18 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr82 = getelementptr inbounds nuw %PsmState, ptr %18, i32 0, i32 0
  store i64 8245305931475275414, ptr %tag_ptr82, align 8
  %pay_ptr83 = getelementptr inbounds nuw %PsmState, ptr %18, i32 0, i32 1
  %19 = call ptr @forge_rc_alloc(i64 8)
  store ptr %19, ptr %pay_ptr83, align 8
  %at84 = load i64, ptr %at71, align 8
  %slot_base85 = ptrtoint ptr %19 to i64
  %slot_addr86 = add i64 %slot_base85, 0
  %slot87 = inttoptr i64 %slot_addr86 to ptr
  store i64 %at84, ptr %slot87, align 8
  %cast88 = ptrtoint ptr %18 to i64
  store i64 %cast88, ptr %pmatch_result73, align 8
  br label %pmatch_end74

parm_next76:                                      ; preds = %march_arm66
  br label %parm_body89

parm_body89:                                      ; preds = %parm_next76
  %20 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr91 = getelementptr inbounds nuw %PsmState, ptr %20, i32 0, i32 0
  store i64 7571447120820543, ptr %tag_ptr91, align 8
  %pay_ptr92 = getelementptr inbounds nuw %PsmState, ptr %20, i32 0, i32 1
  %21 = call ptr @forge_rc_alloc(i64 8)
  store ptr %21, ptr %pay_ptr92, align 8
  %slot_base93 = ptrtoint ptr %21 to i64
  %slot_addr94 = add i64 %slot_base93, 0
  %slot95 = inttoptr i64 %slot_addr94 to ptr
  store ptr @.str.8, ptr %slot95, align 8
  %cast96 = ptrtoint ptr %20 to i64
  store i64 %cast96, ptr %pmatch_result73, align 8
  br label %pmatch_end74

parm_next90:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.9, i64 -1, ptr @mu_file.10, i64 36)
  unreachable

march_arm98:                                      ; preds = %march_next67
  %state100 = load ptr, ptr %state, align 8
  %cast101 = ptrtoint ptr %state100 to i64
  store i64 %cast101, ptr %match_result, align 8
  br label %match_end

march_next99:                                     ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.11, i64 %tag, ptr @mu_file.12, i64 12)
  unreachable
}

define ptr @psm_label(ptr %0) {
entry:
  %msg62 = alloca ptr, align 8
  %r41 = alloca i64, align 8
  %at20 = alloca i64, align 8
  %p5 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %PsmState, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 229437791668307
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm57, %march_arm36, %march_arm15, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast71 = inttoptr i64 %match_val to ptr
  ret ptr %cast71

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.13 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 8245305931475275414
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %PsmState, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %p_slot_base = ptrtoint ptr %payload to i64
  %p_slot_addr = add i64 %p_slot_base, 0
  %p_slot = inttoptr i64 %p_slot_addr to ptr
  %p = load i64, ptr %p_slot, align 8
  store i64 %p, ptr %p5, align 8
  %p6 = load i64, ptr %p5, align 8
  %1 = call ptr @forge_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %p6)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.14)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @forge_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.14, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast7 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast7, ptr %1, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.15)
  %concat_total8 = add i64 %8, %9
  %concat_size9 = add i64 %concat_total8, 1
  %10 = call ptr @forge_rc_alloc(i64 %concat_size9)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast10 = ptrtoint ptr %10 to i64
  %dst2_int11 = add i64 %cast10, %8
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast12, ptr @.str.15, i64 %rhs_len_p113)
  %cast14 = ptrtoint ptr %10 to i64
  store i64 %cast14, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq17 = icmp eq i64 %tag, 249857755397518423
  br i1 %tag_eq17, label %march_arm15, label %march_next16

march_arm15:                                      ; preds = %march_next3
  %pay_slot18 = getelementptr inbounds nuw %PsmState, ptr %s1, i32 0, i32 1
  %payload19 = load ptr, ptr %pay_slot18, align 8
  %at_slot_base = ptrtoint ptr %payload19 to i64
  %at_slot_addr = add i64 %at_slot_base, 0
  %at_slot = inttoptr i64 %at_slot_addr to ptr
  %at = load i64, ptr %at_slot, align 8
  store i64 %at, ptr %at20, align 8
  %at21 = load i64, ptr %at20, align 8
  %13 = call ptr @forge_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.17, i64 %at21)
  %widen22 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.16)
  %16 = call i64 @strlen(ptr %13)
  %concat_total23 = add i64 %15, %16
  %concat_size24 = add i64 %concat_total23, 1
  %17 = call ptr @forge_rc_alloc(i64 %concat_size24)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.16, i64 %15)
  %cast25 = ptrtoint ptr %17 to i64
  %dst2_int26 = add i64 %cast25, %15
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast27, ptr %13, i64 %rhs_len_p128)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.18)
  %concat_total29 = add i64 %20, %21
  %concat_size30 = add i64 %concat_total29, 1
  %22 = call ptr @forge_rc_alloc(i64 %concat_size30)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast31 = ptrtoint ptr %22 to i64
  %dst2_int32 = add i64 %cast31, %20
  %cast33 = inttoptr i64 %dst2_int32 to ptr
  %rhs_len_p134 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast33, ptr @.str.18, i64 %rhs_len_p134)
  %cast35 = ptrtoint ptr %22 to i64
  store i64 %cast35, ptr %match_result, align 8
  br label %match_end

march_next16:                                     ; preds = %march_next3
  %tag_eq38 = icmp eq i64 %tag, 229437791500667
  br i1 %tag_eq38, label %march_arm36, label %march_next37

march_arm36:                                      ; preds = %march_next16
  %pay_slot39 = getelementptr inbounds nuw %PsmState, ptr %s1, i32 0, i32 1
  %payload40 = load ptr, ptr %pay_slot39, align 8
  %r_slot_base = ptrtoint ptr %payload40 to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r41, align 8
  %r42 = load i64, ptr %r41, align 8
  %25 = call ptr @forge_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.20, i64 %r42)
  %widen43 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr @.str.19)
  %28 = call i64 @strlen(ptr %25)
  %concat_total44 = add i64 %27, %28
  %concat_size45 = add i64 %concat_total44, 1
  %29 = call ptr @forge_rc_alloc(i64 %concat_size45)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.19, i64 %27)
  %cast46 = ptrtoint ptr %29 to i64
  %dst2_int47 = add i64 %cast46, %27
  %cast48 = inttoptr i64 %dst2_int47 to ptr
  %rhs_len_p149 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast48, ptr %25, i64 %rhs_len_p149)
  %32 = call i64 @strlen(ptr %29)
  %33 = call i64 @strlen(ptr @.str.21)
  %concat_total50 = add i64 %32, %33
  %concat_size51 = add i64 %concat_total50, 1
  %34 = call ptr @forge_rc_alloc(i64 %concat_size51)
  %35 = call ptr @memcpy(ptr %34, ptr %29, i64 %32)
  %cast52 = ptrtoint ptr %34 to i64
  %dst2_int53 = add i64 %cast52, %32
  %cast54 = inttoptr i64 %dst2_int53 to ptr
  %rhs_len_p155 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast54, ptr @.str.21, i64 %rhs_len_p155)
  %cast56 = ptrtoint ptr %34 to i64
  store i64 %cast56, ptr %match_result, align 8
  br label %match_end

march_next37:                                     ; preds = %march_next16
  %tag_eq59 = icmp eq i64 %tag, 7571447120820543
  br i1 %tag_eq59, label %march_arm57, label %march_next58

march_arm57:                                      ; preds = %march_next37
  %pay_slot60 = getelementptr inbounds nuw %PsmState, ptr %s1, i32 0, i32 1
  %payload61 = load ptr, ptr %pay_slot60, align 8
  %msg_slot_base = ptrtoint ptr %payload61 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 0
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @forge_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg62, align 8
  %msg63 = load ptr, ptr %msg62, align 8
  %37 = call i64 @strlen(ptr @.str.22)
  %38 = call i64 @strlen(ptr %msg63)
  %concat_total64 = add i64 %37, %38
  %concat_size65 = add i64 %concat_total64, 1
  %39 = call ptr @forge_rc_alloc(i64 %concat_size65)
  %40 = call ptr @memcpy(ptr %39, ptr @.str.22, i64 %37)
  %cast66 = ptrtoint ptr %39 to i64
  %dst2_int67 = add i64 %cast66, %37
  %cast68 = inttoptr i64 %dst2_int67 to ptr
  %rhs_len_p169 = add i64 %38, 1
  %41 = call ptr @memcpy(ptr %cast68, ptr %msg63, i64 %rhs_len_p169)
  %cast70 = ptrtoint ptr %39 to i64
  store i64 %cast70, ptr %match_result, align 8
  br label %match_end

march_next58:                                     ; preds = %march_next37
  call void @forge_match_unreachable(ptr @.match_fn.23, i64 %tag, ptr @mu_file.24, i64 46)
  unreachable
}

define ptr @psm_run_actions(ptr %0) {
entry:
  %action = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %last = alloca ptr, align 8
  %state = alloca ptr, align 8
  %actions = alloca ptr, align 8
  store ptr %0, ptr %actions, align 8
  %1 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %PsmState, ptr %1, i32 0, i32 0
  store i64 229437791668307, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %PsmState, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %state, align 8
  store ptr @.str.25, ptr %last, align 8
  %actions2 = load ptr, ptr %actions, align 8
  %2 = call i64 @forge_array_len(ptr %actions2)
  store i64 %2, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %3 = call i64 @forge_array_get(ptr %actions2, i64 %forin_i_val)
  store i64 %3, ptr %action, align 8
  %state3 = load ptr, ptr %state, align 8
  %action4 = load ptr, ptr %action, align 8
  %4 = call ptr @psm_transition(ptr %state3, ptr %action4)
  store ptr %4, ptr %state, align 8
  %state5 = load ptr, ptr %state, align 8
  %5 = call ptr @psm_label(ptr %state5)
  store ptr %5, ptr %last, align 8
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %last6 = load ptr, ptr %last, align 8
  ret ptr %last6
}

define i64 @main() {
entry:
  %paused = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %PsmState, ptr %1, i32 0, i32 0
  store i64 229437791668307, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %PsmState, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %2 = call ptr @psm_transition(ptr %cast1, ptr @.str.26)
  %3 = call ptr @psm_label(ptr %2)
  %4 = call i32 @strcmp(ptr %3, ptr @.str.27)
  %widen2 = sext i32 %4 to i64
  %streq_cmp = icmp eq i64 %widen2, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %5 = call i64 @forge_test_run_then(ptr @spec_str.28, i64 %streq_ext)
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %PsmState, ptr %6, i32 0, i32 0
  store i64 8245305931475275414, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %PsmState, ptr %6, i32 0, i32 1
  %7 = call ptr @forge_rc_alloc(i64 8)
  store ptr %7, ptr %pay_ptr4, align 8
  %slot_base = ptrtoint ptr %7 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 0, ptr %slot, align 8
  %cast5 = ptrtoint ptr %6 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  %8 = call ptr @psm_transition(ptr %cast6, ptr @.str.29)
  %9 = call ptr @psm_label(ptr %8)
  %10 = call i32 @strcmp(ptr %9, ptr @.str.30)
  %widen7 = sext i32 %10 to i64
  %streq_cmp8 = icmp eq i64 %widen7, 0
  %streq_ext9 = zext i1 %streq_cmp8 to i64
  %11 = call i64 @forge_test_run_then(ptr @spec_str.31, i64 %streq_ext9)
  %12 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %PsmState, ptr %12, i32 0, i32 0
  store i64 8245305931475275414, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %PsmState, ptr %12, i32 0, i32 1
  %13 = call ptr @forge_rc_alloc(i64 8)
  store ptr %13, ptr %pay_ptr11, align 8
  %slot_base12 = ptrtoint ptr %13 to i64
  %slot_addr13 = add i64 %slot_base12, 0
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  store i64 50, ptr %slot14, align 8
  %cast15 = ptrtoint ptr %12 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  %14 = call ptr @psm_transition(ptr %cast16, ptr @.str.32)
  store ptr %14, ptr %paused, align 8
  %paused17 = load ptr, ptr %paused, align 8
  %15 = call ptr @psm_transition(ptr %paused17, ptr @.str.33)
  %16 = call ptr @psm_label(ptr %15)
  %17 = call i32 @strcmp(ptr %16, ptr @.str.34)
  %widen18 = sext i32 %17 to i64
  %streq_cmp19 = icmp eq i64 %widen18, 0
  %streq_ext20 = zext i1 %streq_cmp19 to i64
  %18 = call i64 @forge_test_run_then(ptr @spec_str.35, i64 %streq_ext20)
  %19 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %19, i64 ptrtoint (ptr @.str.36 to i64))
  call void @forge_array_push(ptr %19, i64 ptrtoint (ptr @.str.37 to i64))
  call void @forge_array_push(ptr %19, i64 ptrtoint (ptr @.str.38 to i64))
  call void @forge_array_push(ptr %19, i64 ptrtoint (ptr @.str.39 to i64))
  call void @forge_array_push(ptr %19, i64 ptrtoint (ptr @.str.40 to i64))
  call void @forge_array_push(ptr %19, i64 ptrtoint (ptr @.str.41 to i64))
  %20 = call ptr @psm_run_actions(ptr %19)
  %21 = call i32 @strcmp(ptr %20, ptr @.str.42)
  %widen21 = sext i32 %21 to i64
  %streq_cmp22 = icmp eq i64 %widen21, 0
  %streq_ext23 = zext i1 %streq_cmp22 to i64
  %22 = call i64 @forge_test_run_then(ptr @spec_str.43, i64 %streq_ext23)
  %23 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen24 = sext i32 %23 to i64
  %24 = call i32 @forge_test_summary()
  %widen25 = sext i32 %24 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_PsmState(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %PsmState, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %PsmState, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_PsmError = icmp eq i64 %tag, 7571447120820543
  br i1 %is_PsmError, label %rel_PsmError, label %try_next_PsmError

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_PsmError, %vrel_msg_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_PsmError:                                     ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %PsmState__PsmError, ptr %payload, i32 0, i32 0
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_PsmError:                                ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_PsmError
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_PsmError
  call void @forge_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}
