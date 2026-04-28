; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Action = type { i64, ptr }
%Config = type { ptr, i64 }
%Action__Start = type { ptr }

@fld_name = private unnamed_addr constant [5 x i8] c"mode\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_match_enum_struct.av\00", align 1
@.lit_str = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"DEBUG\00", align 1
@.lit_str.1 = private unnamed_addr constant [8 x i8] c"release\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"RELEASE\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"UNKNOWN\00", align 1
@.match_fn = private unnamed_addr constant [16 x i8] c"describe_action\00", align 1
@mu_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_match_enum_struct.av\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"Starting in \00", align 1
@.str.5 = private unnamed_addr constant [14 x i8] c" mode (level \00", align 1
@fld_name.6 = private unnamed_addr constant [6 x i8] c"level\00", align 1
@sty_name.7 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.8 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_match_enum_struct.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"Stopping\00", align 1
@.str.11 = private unnamed_addr constant [15 x i8] c"Restarting in \00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.match_fn.14 = private unnamed_addr constant [16 x i8] c"describe_action\00", align 1
@mu_file.15 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_match_enum_struct.av\00", align 1
@.str.16 = private unnamed_addr constant [4 x i8] c"\E2\9C\93\00", align 1
@.str.17 = private unnamed_addr constant [4 x i8] c"\E2\9C\97\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c"?\00", align 1
@.match_fn.20 = private unnamed_addr constant [6 x i8] c"badge\00", align 1
@mu_file.21 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_match_enum_struct.av\00", align 1
@.str.22 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str.23 = private unnamed_addr constant [3 x i8] c"] \00", align 1
@.i2s_fmt.24 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@.str.26 = private unnamed_addr constant [8 x i8] c"release\00", align 1

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

define ptr @describe_action(ptr %0) {
entry:
  %d46 = alloca i64, align 8
  %mode_desc = alloca ptr, align 8
  %pmatch_result = alloca i64, align 8
  %cfg2 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %Action, ptr %a1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210690259379
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm41, %march_arm38, %pmatch_end
  %match_val = load i64, ptr %match_result, align 8
  %cast62 = inttoptr i64 %match_val to ptr
  ret ptr %cast62

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Action, ptr %a1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cfg_slot_base = ptrtoint ptr %payload to i64
  %cfg_slot_addr = add i64 %cfg_slot_base, 0
  %cfg_slot = inttoptr i64 %cfg_slot_addr to ptr
  %cfg = load ptr, ptr %cfg_slot, align 8
  call void @avra_rc_retain(ptr %cfg)
  store ptr %cfg, ptr %cfg2, align 8
  %cfg3 = load ptr, ptr %cfg2, align 8
  %cast = ptrtoint ptr %cfg3 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 109, i64 14)
  %mode_ptr = getelementptr inbounds nuw %Config, ptr %cfg3, i32 0, i32 0
  %mode = load ptr, ptr %mode_ptr, align 8
  store i64 0, ptr %pmatch_result, align 8
  %1 = call i32 @strcmp(ptr %mode, ptr @.lit_str)
  %widen = sext i32 %1 to i64
  %str_eq = icmp eq i64 %widen, 0
  br i1 %str_eq, label %parm_body, label %parm_next

march_next:                                       ; preds = %entry
  %tag_eq40 = icmp eq i64 %tag, 6384553771
  br i1 %tag_eq40, label %march_arm38, label %march_next39

pmatch_end:                                       ; preds = %parm_body8, %parm_body4, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast10 = inttoptr i64 %pmatch_val to ptr
  store ptr %cast10, ptr %mode_desc, align 8
  %mode_desc11 = load ptr, ptr %mode_desc, align 8
  %2 = call i64 @strlen(ptr @.str.4)
  %3 = call i64 @strlen(ptr %mode_desc11)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr @.str.4, i64 %2)
  %cast12 = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast12, %2
  %cast13 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast13, ptr %mode_desc11, i64 %rhs_len_p1)
  %7 = call i64 @strlen(ptr %4)
  %8 = call i64 @strlen(ptr @.str.5)
  %concat_total14 = add i64 %7, %8
  %concat_size15 = add i64 %concat_total14, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %10 = call ptr @memcpy(ptr %9, ptr %4, i64 %7)
  %cast16 = ptrtoint ptr %9 to i64
  %dst2_int17 = add i64 %cast16, %7
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast18, ptr @.str.5, i64 %rhs_len_p119)
  %cfg20 = load ptr, ptr %cfg2, align 8
  %cast21 = ptrtoint ptr %cfg20 to i64
  %null_chk22 = icmp eq i64 %cast21, 0
  %null_ext23 = zext i1 %null_chk22 to i64
  call void @avra_null_deref_trap(ptr @fld_name.6, i64 5, ptr @sty_name.7, i64 6, i64 %null_ext23, ptr @src_file.8, i64 109, i64 19)
  %level_ptr = getelementptr inbounds nuw %Config, ptr %cfg20, i32 0, i32 1
  %level = load i64, ptr %level_ptr, align 8
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt, i64 %level)
  %widen24 = sext i32 %13 to i64
  %14 = call i64 @strlen(ptr %9)
  %15 = call i64 @strlen(ptr %12)
  %concat_total25 = add i64 %14, %15
  %concat_size26 = add i64 %concat_total25, 1
  %16 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %17 = call ptr @memcpy(ptr %16, ptr %9, i64 %14)
  %cast27 = ptrtoint ptr %16 to i64
  %dst2_int28 = add i64 %cast27, %14
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %15, 1
  %18 = call ptr @memcpy(ptr %cast29, ptr %12, i64 %rhs_len_p130)
  %19 = call i64 @strlen(ptr %16)
  %20 = call i64 @strlen(ptr @.str.9)
  %concat_total31 = add i64 %19, %20
  %concat_size32 = add i64 %concat_total31, 1
  %21 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %22 = call ptr @memcpy(ptr %21, ptr %16, i64 %19)
  %cast33 = ptrtoint ptr %21 to i64
  %dst2_int34 = add i64 %cast33, %19
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %20, 1
  %23 = call ptr @memcpy(ptr %cast35, ptr @.str.9, i64 %rhs_len_p136)
  %cast37 = ptrtoint ptr %21 to i64
  store i64 %cast37, ptr %match_result, align 8
  br label %match_end

parm_body:                                        ; preds = %march_arm
  store i64 ptrtoint (ptr @.str to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %march_arm
  %24 = call i32 @strcmp(ptr %mode, ptr @.lit_str.1)
  %widen6 = sext i32 %24 to i64
  %str_eq7 = icmp eq i64 %widen6, 0
  br i1 %str_eq7, label %parm_body4, label %parm_next5

parm_body4:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next5:                                       ; preds = %parm_next
  br label %parm_body8

parm_body8:                                       ; preds = %parm_next5
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next9:                                       ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 14)
  unreachable

march_arm38:                                      ; preds = %march_next
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %match_result, align 8
  br label %match_end

march_next39:                                     ; preds = %march_next
  %tag_eq43 = icmp eq i64 %tag, 229439835366506
  br i1 %tag_eq43, label %march_arm41, label %march_next42

march_arm41:                                      ; preds = %march_next39
  %pay_slot44 = getelementptr inbounds nuw %Action, ptr %a1, i32 0, i32 1
  %payload45 = load ptr, ptr %pay_slot44, align 8
  %d_slot_base = ptrtoint ptr %payload45 to i64
  %d_slot_addr = add i64 %d_slot_base, 0
  %d_slot = inttoptr i64 %d_slot_addr to ptr
  %d = load i64, ptr %d_slot, align 8
  store i64 %d, ptr %d46, align 8
  %d47 = load i64, ptr %d46, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.12, i64 %d47)
  %widen48 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr @.str.11)
  %28 = call i64 @strlen(ptr %25)
  %concat_total49 = add i64 %27, %28
  %concat_size50 = add i64 %concat_total49, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size50)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.11, i64 %27)
  %cast51 = ptrtoint ptr %29 to i64
  %dst2_int52 = add i64 %cast51, %27
  %cast53 = inttoptr i64 %dst2_int52 to ptr
  %rhs_len_p154 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast53, ptr %25, i64 %rhs_len_p154)
  %32 = call i64 @strlen(ptr %29)
  %33 = call i64 @strlen(ptr @.str.13)
  %concat_total55 = add i64 %32, %33
  %concat_size56 = add i64 %concat_total55, 1
  %34 = call ptr @avra_rc_alloc(i64 %concat_size56)
  %35 = call ptr @memcpy(ptr %34, ptr %29, i64 %32)
  %cast57 = ptrtoint ptr %34 to i64
  %dst2_int58 = add i64 %cast57, %32
  %cast59 = inttoptr i64 %dst2_int58 to ptr
  %rhs_len_p160 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast59, ptr @.str.13, i64 %rhs_len_p160)
  %cast61 = ptrtoint ptr %34 to i64
  store i64 %cast61, ptr %match_result, align 8
  br label %match_end

march_next42:                                     ; preds = %march_next39
  call void @avra_match_unreachable(ptr @.match_fn.14, i64 %tag, ptr @mu_file.15, i64 11)
  unreachable
}

define ptr @badge(i64 %0) {
entry:
  %icon = alloca ptr, align 8
  %pmatch_result = alloca i64, align 8
  %status = alloca i64, align 8
  store i64 %0, ptr %status, align 8
  %status1 = load i64, ptr %status, align 8
  store i64 0, ptr %pmatch_result, align 8
  %lit_eq = icmp eq i64 %status1, 200
  br i1 %lit_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body8, %parm_body5, %parm_body2, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  store ptr %cast, ptr %icon, align 8
  %icon10 = load ptr, ptr %icon, align 8
  %1 = call i64 @strlen(ptr @.str.22)
  %2 = call i64 @strlen(ptr %icon10)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.22, i64 %1)
  %cast11 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast11, %1
  %cast12 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast12, ptr %icon10, i64 %rhs_len_p1)
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.23)
  %concat_total13 = add i64 %6, %7
  %concat_size14 = add i64 %concat_total13, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast15 = ptrtoint ptr %8 to i64
  %dst2_int16 = add i64 %cast15, %6
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast17, ptr @.str.23, i64 %rhs_len_p118)
  %status19 = load i64, ptr %status, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.24, i64 %status19)
  %widen = sext i32 %12 to i64
  %13 = call i64 @strlen(ptr %8)
  %14 = call i64 @strlen(ptr %11)
  %concat_total20 = add i64 %13, %14
  %concat_size21 = add i64 %concat_total20, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size21)
  %16 = call ptr @memcpy(ptr %15, ptr %8, i64 %13)
  %cast22 = ptrtoint ptr %15 to i64
  %dst2_int23 = add i64 %cast22, %13
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast24, ptr %11, i64 %rhs_len_p125)
  ret ptr %15

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.16 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %lit_eq4 = icmp eq i64 %status1, 404
  br i1 %lit_eq4, label %parm_body2, label %parm_next3

parm_body2:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.17 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next3:                                       ; preds = %parm_next
  %lit_eq7 = icmp eq i64 %status1, 500
  br i1 %lit_eq7, label %parm_body5, label %parm_next6

parm_body5:                                       ; preds = %parm_next3
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next6:                                       ; preds = %parm_next3
  br label %parm_body8

parm_body8:                                       ; preds = %parm_next6
  store i64 ptrtoint (ptr @.str.19 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next9:                                       ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.20, i64 -1, ptr @mu_file.21, i64 33)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Action, ptr %0, i32 0, i32 0
  store i64 210690259379, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Action, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 8)
  store ptr %1, ptr %pay_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 0
  store ptr @.str.25, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 1
  store i64 3, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %2 to i64
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %slot, align 8
  %cast3 = ptrtoint ptr %0 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  %3 = call ptr @describe_action(ptr %cast4)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr5 = getelementptr inbounds nuw %Action, ptr %5, i32 0, i32 0
  store i64 210690259379, ptr %tag_ptr5, align 8
  %pay_ptr6 = getelementptr inbounds nuw %Action, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr6, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr7 = getelementptr inbounds nuw %Config, ptr %7, i32 0, i32 0
  store ptr @.str.26, ptr %fld_ptr7, align 8
  %fld_ptr8 = getelementptr inbounds nuw %Config, ptr %7, i32 0, i32 1
  store i64 1, ptr %fld_ptr8, align 8
  %cast9 = ptrtoint ptr %7 to i64
  %slot_base10 = ptrtoint ptr %6 to i64
  %slot_addr11 = add i64 %slot_base10, 0
  %slot12 = inttoptr i64 %slot_addr11 to ptr
  %cast13 = inttoptr i64 %cast9 to ptr
  store ptr %cast13, ptr %slot12, align 8
  %cast14 = ptrtoint ptr %5 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  %8 = call ptr @describe_action(ptr %cast15)
  %9 = call i32 @puts(ptr %8)
  %widen16 = sext i32 %9 to i64
  %10 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr17 = getelementptr inbounds nuw %Action, ptr %10, i32 0, i32 0
  store i64 6384553771, ptr %tag_ptr17, align 8
  %pay_ptr18 = getelementptr inbounds nuw %Action, ptr %10, i32 0, i32 1
  store ptr null, ptr %pay_ptr18, align 8
  %cast19 = ptrtoint ptr %10 to i64
  %cast20 = inttoptr i64 %cast19 to ptr
  %11 = call ptr @describe_action(ptr %cast20)
  %12 = call i32 @puts(ptr %11)
  %widen21 = sext i32 %12 to i64
  %13 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr22 = getelementptr inbounds nuw %Action, ptr %13, i32 0, i32 0
  store i64 229439835366506, ptr %tag_ptr22, align 8
  %pay_ptr23 = getelementptr inbounds nuw %Action, ptr %13, i32 0, i32 1
  %14 = call ptr @avra_rc_alloc(i64 8)
  store ptr %14, ptr %pay_ptr23, align 8
  %slot_base24 = ptrtoint ptr %14 to i64
  %slot_addr25 = add i64 %slot_base24, 0
  %slot26 = inttoptr i64 %slot_addr25 to ptr
  store i64 5, ptr %slot26, align 8
  %cast27 = ptrtoint ptr %13 to i64
  %cast28 = inttoptr i64 %cast27 to ptr
  %15 = call ptr @describe_action(ptr %cast28)
  %16 = call i32 @puts(ptr %15)
  %widen29 = sext i32 %16 to i64
  %17 = call ptr @badge(i64 200)
  %18 = call i32 @puts(ptr %17)
  %widen30 = sext i32 %18 to i64
  %19 = call ptr @badge(i64 404)
  %20 = call i32 @puts(ptr %19)
  %widen31 = sext i32 %20 to i64
  %21 = call ptr @badge(i64 999)
  %22 = call i32 @puts(ptr %21)
  %widen32 = sext i32 %22 to i64
  %23 = call i32 @avra_test_summary()
  %widen33 = sext i32 %23 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Config(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_mode_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  %rel_mode = load ptr, ptr %rel_mode_ptr, align 8
  %is_null_mode = icmp eq ptr %rel_mode, null
  br i1 %is_null_mode, label %rel_mode_skip, label %rel_mode_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_mode_skip
  ret i64 0

rel_mode_skip:                                    ; preds = %rel_mode_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_mode_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_mode)
  br label %rel_mode_skip
}

define i64 @__release_Action(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Action, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Action, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Start = icmp eq i64 %tag, 210690259379
  br i1 %is_Start, label %rel_Start, label %try_next_Start

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Start, %vrel_config_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Start:                                        ; preds = %do_free
  %vrel_config_ptr = getelementptr inbounds nuw %Action__Start, ptr %payload, i32 0, i32 0
  %vrel_config = load ptr, ptr %vrel_config_ptr, align 8
  %vrel_null_config = icmp eq ptr %vrel_config, null
  br i1 %vrel_null_config, label %vrel_config_skip, label %vrel_config_do

try_next_Start:                                   ; preds = %do_free
  br label %fields_done

vrel_config_skip:                                 ; preds = %vrel_config_do, %rel_Start
  br label %fields_done

vrel_config_do:                                   ; preds = %rel_Start
  %2 = call i64 @__release_Config(ptr %vrel_config)
  br label %vrel_config_skip
}
