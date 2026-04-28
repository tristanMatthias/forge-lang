; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Box = type { ptr, ptr }
%__union = type { i64, ptr }
%Multi = type { ptr, ptr }

@.str = private unnamed_addr constant [6 x i8] c"first\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"updated\00", align 1
@fld_name = private unnamed_addr constant [4 x i8] c"val\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@fld_name.2 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@sty_name.3 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.4 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"first\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"second\00", align 1
@fld_name.8 = private unnamed_addr constant [4 x i8] c"val\00", align 1
@sty_name.9 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.10 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c"int:\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"str:\00", align 1
@.match_fn.14 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.15 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@fld_name.16 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@sty_name.17 = private unnamed_addr constant [4 x i8] c"Box\00", align 1
@src_file.18 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@fld_name.20 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@sty_name.21 = private unnamed_addr constant [6 x i8] c"Multi\00", align 1
@src_file.22 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@.str.23 = private unnamed_addr constant [6 x i8] c"a int\00", align 1
@.str.24 = private unnamed_addr constant [8 x i8] c"a str: \00", align 1
@.match_fn.25 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.26 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@fld_name.27 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@sty_name.28 = private unnamed_addr constant [6 x i8] c"Multi\00", align 1
@src_file.29 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1
@.str.30 = private unnamed_addr constant [6 x i8] c"b int\00", align 1
@.str.31 = private unnamed_addr constant [9 x i8] c"b bool: \00", align 1
@.i2s_fmt.32 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.33 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.34 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_with.av\00", align 1

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
  %v = alloca i1, align 1
  %n184 = alloca i64, align 8
  %union_match_result173 = alloca i64, align 8
  %s157 = alloca ptr, align 8
  %n146 = alloca i64, align 8
  %union_match_result135 = alloca i64, align 8
  %m = alloca ptr, align 8
  %s94 = alloca ptr, align 8
  %n79 = alloca i64, align 8
  %union_match_result68 = alloca i64, align 8
  %b2 = alloca ptr, align 8
  %b1 = alloca ptr, align 8
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %c2 = alloca ptr, align 8
  %c1 = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Box, ptr %1, i32 0, i32 0
  %2 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %2, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %2, i32 0, i32 1
  store ptr %3, ptr %union_pay_ptr, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %fld_ptr, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Box, ptr %1, i32 0, i32 1
  store ptr @.str, ptr %fld_ptr2, align 8
  %cast3 = ptrtoint ptr %1 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  store ptr %cast4, ptr %c1, align 8
  %c15 = load ptr, ptr %c1, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Box, ptr %c15, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Box, ptr %4, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src6 = getelementptr inbounds nuw %Box, ptr %c15, i32 0, i32 1
  %with_cp_val7 = load ptr, ptr %with_cp_src6, align 8
  %with_cp_dst8 = getelementptr inbounds nuw %Box, ptr %4, i32 0, i32 1
  store ptr %with_cp_val7, ptr %with_cp_dst8, align 8
  %with_ovr = getelementptr inbounds nuw %Box, ptr %4, i32 0, i32 0
  %5 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr9 = getelementptr inbounds nuw %__union, ptr %5, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr9, align 8
  %6 = call ptr @avra_rc_alloc(i64 8)
  %slot_base10 = ptrtoint ptr %6 to i64
  %slot_addr11 = add i64 %slot_base10, 0
  %slot12 = inttoptr i64 %slot_addr11 to ptr
  store ptr @.str.1, ptr %slot12, align 8
  %union_pay_ptr13 = getelementptr inbounds nuw %__union, ptr %5, i32 0, i32 1
  store ptr %6, ptr %union_pay_ptr13, align 8
  %cast14 = ptrtoint ptr %5 to i64
  store i64 %cast14, ptr %with_ovr, align 8
  %cast15 = ptrtoint ptr %4 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  store ptr %cast16, ptr %c2, align 8
  %c217 = load ptr, ptr %c2, align 8
  %cast18 = ptrtoint ptr %c217 to i64
  %null_chk = icmp eq i64 %cast18, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 96, i64 15)
  %val_ptr = getelementptr inbounds nuw %Box, ptr %c217, i32 0, i32 0
  %val = load ptr, ptr %val_ptr, align 8
  %union_tag_ptr19 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr19, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm23, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %c234 = load ptr, ptr %c2, align 8
  %cast35 = ptrtoint ptr %c234 to i64
  %null_chk36 = icmp eq i64 %cast35, 0
  %null_ext37 = zext i1 %null_chk36 to i64
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 5, ptr @sty_name.3, i64 3, i64 %null_ext37, ptr @src_file.4, i64 96, i64 19)
  %label_ptr = getelementptr inbounds nuw %Box, ptr %c234, i32 0, i32 1
  %label = load ptr, ptr %label_ptr, align 8
  %7 = call i32 @puts(ptr %label)
  %widen38 = sext i32 %7 to i64
  %8 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr39 = getelementptr inbounds nuw %Box, ptr %8, i32 0, i32 0
  %9 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr40 = getelementptr inbounds nuw %__union, ptr %9, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr40, align 8
  %10 = call ptr @avra_rc_alloc(i64 8)
  %slot_base41 = ptrtoint ptr %10 to i64
  %slot_addr42 = add i64 %slot_base41, 0
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  store ptr @.str.5, ptr %slot43, align 8
  %union_pay_ptr44 = getelementptr inbounds nuw %__union, ptr %9, i32 0, i32 1
  store ptr %10, ptr %union_pay_ptr44, align 8
  %cast45 = ptrtoint ptr %9 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  store ptr %cast46, ptr %fld_ptr39, align 8
  %fld_ptr47 = getelementptr inbounds nuw %Box, ptr %8, i32 0, i32 1
  store ptr @.str.6, ptr %fld_ptr47, align 8
  %cast48 = ptrtoint ptr %8 to i64
  %cast49 = inttoptr i64 %cast48 to ptr
  store ptr %cast49, ptr %b1, align 8
  %b150 = load ptr, ptr %b1, align 8
  %11 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src51 = getelementptr inbounds nuw %Box, ptr %b150, i32 0, i32 0
  %with_cp_val52 = load ptr, ptr %with_cp_src51, align 8
  %with_cp_dst53 = getelementptr inbounds nuw %Box, ptr %11, i32 0, i32 0
  store ptr %with_cp_val52, ptr %with_cp_dst53, align 8
  %with_cp_src54 = getelementptr inbounds nuw %Box, ptr %b150, i32 0, i32 1
  %with_cp_val55 = load ptr, ptr %with_cp_src54, align 8
  %with_cp_dst56 = getelementptr inbounds nuw %Box, ptr %11, i32 0, i32 1
  store ptr %with_cp_val55, ptr %with_cp_dst56, align 8
  %with_ovr57 = getelementptr inbounds nuw %Box, ptr %11, i32 0, i32 1
  store ptr @.str.7, ptr %with_ovr57, align 8
  %cast58 = ptrtoint ptr %11 to i64
  %cast59 = inttoptr i64 %cast58 to ptr
  store ptr %cast59, ptr %b2, align 8
  %b260 = load ptr, ptr %b2, align 8
  %cast61 = ptrtoint ptr %b260 to i64
  %null_chk62 = icmp eq i64 %cast61, 0
  %null_ext63 = zext i1 %null_chk62 to i64
  call void @avra_null_deref_trap(ptr @fld_name.8, i64 3, ptr @sty_name.9, i64 3, i64 %null_ext63, ptr @src_file.10, i64 96, i64 24)
  %val_ptr64 = getelementptr inbounds nuw %Box, ptr %b260, i32 0, i32 0
  %val65 = load ptr, ptr %val_ptr64, align 8
  %union_tag_ptr66 = getelementptr inbounds nuw %__union, ptr %val65, i32 0, i32 0
  %union_tag67 = load i64, ptr %union_tag_ptr66, align 8
  store i64 0, ptr %union_match_result68, align 8
  %union_tag_eq72 = icmp eq i64 %union_tag67, 193495088
  br i1 %union_tag_eq72, label %union_arm70, label %union_next71

union_arm:                                        ; preds = %entry
  %union_pay_ptr20 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr20, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %n21 = load i64, ptr %n, align 8
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt, i64 %n21)
  %widen = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen22 = sext i32 %14 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq25 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq25, label %union_arm23, label %union_next24

union_arm23:                                      ; preds = %union_next
  %union_pay_ptr26 = getelementptr inbounds nuw %__union, ptr %val, i32 0, i32 1
  %union_payload27 = load ptr, ptr %union_pay_ptr26, align 8
  %union_val_slot_base28 = ptrtoint ptr %union_payload27 to i64
  %union_val_slot_addr29 = add i64 %union_val_slot_base28, 0
  %union_val_slot30 = inttoptr i64 %union_val_slot_addr29 to ptr
  %union_val31 = load ptr, ptr %union_val_slot30, align 8
  store ptr %union_val31, ptr %s, align 8
  %s32 = load ptr, ptr %s, align 8
  %15 = call i32 @puts(ptr %s32)
  %widen33 = sext i32 %15 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next24:                                     ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 15)
  unreachable

union_match_end69:                                ; preds = %union_arm85, %union_arm70
  %union_match_val103 = load i64, ptr %union_match_result68, align 8
  %b2104 = load ptr, ptr %b2, align 8
  %cast105 = ptrtoint ptr %b2104 to i64
  %null_chk106 = icmp eq i64 %cast105, 0
  %null_ext107 = zext i1 %null_chk106 to i64
  call void @avra_null_deref_trap(ptr @fld_name.16, i64 5, ptr @sty_name.17, i64 3, i64 %null_ext107, ptr @src_file.18, i64 96, i64 28)
  %label_ptr108 = getelementptr inbounds nuw %Box, ptr %b2104, i32 0, i32 1
  %label109 = load ptr, ptr %label_ptr108, align 8
  %16 = call i32 @puts(ptr %label109)
  %widen110 = sext i32 %16 to i64
  %17 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr111 = getelementptr inbounds nuw %Multi, ptr %17, i32 0, i32 0
  %18 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr112 = getelementptr inbounds nuw %__union, ptr %18, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr112, align 8
  %19 = call ptr @avra_rc_alloc(i64 8)
  %slot_base113 = ptrtoint ptr %19 to i64
  %slot_addr114 = add i64 %slot_base113, 0
  %slot115 = inttoptr i64 %slot_addr114 to ptr
  store ptr @.str.19, ptr %slot115, align 8
  %union_pay_ptr116 = getelementptr inbounds nuw %__union, ptr %18, i32 0, i32 1
  store ptr %19, ptr %union_pay_ptr116, align 8
  %cast117 = ptrtoint ptr %18 to i64
  %cast118 = inttoptr i64 %cast117 to ptr
  store ptr %cast118, ptr %fld_ptr111, align 8
  %fld_ptr119 = getelementptr inbounds nuw %Multi, ptr %17, i32 0, i32 1
  %20 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr120 = getelementptr inbounds nuw %__union, ptr %20, i32 0, i32 0
  store i64 6385087377, ptr %union_tag_ptr120, align 8
  %21 = call ptr @avra_rc_alloc(i64 8)
  %slot_base121 = ptrtoint ptr %21 to i64
  %slot_addr122 = add i64 %slot_base121, 0
  %slot123 = inttoptr i64 %slot_addr122 to ptr
  store i1 true, ptr %slot123, align 8
  %union_pay_ptr124 = getelementptr inbounds nuw %__union, ptr %20, i32 0, i32 1
  store ptr %21, ptr %union_pay_ptr124, align 8
  %cast125 = ptrtoint ptr %20 to i64
  %cast126 = inttoptr i64 %cast125 to ptr
  store ptr %cast126, ptr %fld_ptr119, align 8
  %cast127 = ptrtoint ptr %17 to i64
  %cast128 = inttoptr i64 %cast127 to ptr
  store ptr %cast128, ptr %m, align 8
  %m129 = load ptr, ptr %m, align 8
  %cast130 = ptrtoint ptr %m129 to i64
  %null_chk131 = icmp eq i64 %cast130, 0
  %null_ext132 = zext i1 %null_chk131 to i64
  call void @avra_null_deref_trap(ptr @fld_name.20, i64 1, ptr @sty_name.21, i64 5, i64 %null_ext132, ptr @src_file.22, i64 96, i64 32)
  %a_ptr = getelementptr inbounds nuw %Multi, ptr %m129, i32 0, i32 0
  %a = load ptr, ptr %a_ptr, align 8
  %union_tag_ptr133 = getelementptr inbounds nuw %__union, ptr %a, i32 0, i32 0
  %union_tag134 = load i64, ptr %union_tag_ptr133, align 8
  store i64 0, ptr %union_match_result135, align 8
  %union_tag_eq139 = icmp eq i64 %union_tag134, 193495088
  br i1 %union_tag_eq139, label %union_arm137, label %union_next138

union_arm70:                                      ; preds = %union_match_end
  %union_pay_ptr73 = getelementptr inbounds nuw %__union, ptr %val65, i32 0, i32 1
  %union_payload74 = load ptr, ptr %union_pay_ptr73, align 8
  %union_val_slot_base75 = ptrtoint ptr %union_payload74 to i64
  %union_val_slot_addr76 = add i64 %union_val_slot_base75, 0
  %union_val_slot77 = inttoptr i64 %union_val_slot_addr76 to ptr
  %union_val78 = load i64, ptr %union_val_slot77, align 8
  store i64 %union_val78, ptr %n79, align 8
  %n80 = load i64, ptr %n79, align 8
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.12, i64 %n80)
  %widen81 = sext i32 %23 to i64
  %24 = call i64 @strlen(ptr @.str.11)
  %25 = call i64 @strlen(ptr %22)
  %concat_total = add i64 %24, %25
  %concat_size = add i64 %concat_total, 1
  %26 = call ptr @avra_rc_alloc(i64 %concat_size)
  %27 = call ptr @memcpy(ptr %26, ptr @.str.11, i64 %24)
  %cast82 = ptrtoint ptr %26 to i64
  %dst2_int = add i64 %cast82, %24
  %cast83 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast83, ptr %22, i64 %rhs_len_p1)
  %29 = call i32 @puts(ptr %26)
  %widen84 = sext i32 %29 to i64
  store i64 0, ptr %union_match_result68, align 8
  br label %union_match_end69

union_next71:                                     ; preds = %union_match_end
  %union_tag_eq87 = icmp eq i64 %union_tag67, 6954031493116
  br i1 %union_tag_eq87, label %union_arm85, label %union_next86

union_arm85:                                      ; preds = %union_next71
  %union_pay_ptr88 = getelementptr inbounds nuw %__union, ptr %val65, i32 0, i32 1
  %union_payload89 = load ptr, ptr %union_pay_ptr88, align 8
  %union_val_slot_base90 = ptrtoint ptr %union_payload89 to i64
  %union_val_slot_addr91 = add i64 %union_val_slot_base90, 0
  %union_val_slot92 = inttoptr i64 %union_val_slot_addr91 to ptr
  %union_val93 = load ptr, ptr %union_val_slot92, align 8
  store ptr %union_val93, ptr %s94, align 8
  %s95 = load ptr, ptr %s94, align 8
  %30 = call i64 @strlen(ptr @.str.13)
  %31 = call i64 @strlen(ptr %s95)
  %concat_total96 = add i64 %30, %31
  %concat_size97 = add i64 %concat_total96, 1
  %32 = call ptr @avra_rc_alloc(i64 %concat_size97)
  %33 = call ptr @memcpy(ptr %32, ptr @.str.13, i64 %30)
  %cast98 = ptrtoint ptr %32 to i64
  %dst2_int99 = add i64 %cast98, %30
  %cast100 = inttoptr i64 %dst2_int99 to ptr
  %rhs_len_p1101 = add i64 %31, 1
  %34 = call ptr @memcpy(ptr %cast100, ptr %s95, i64 %rhs_len_p1101)
  %35 = call i32 @puts(ptr %32)
  %widen102 = sext i32 %35 to i64
  store i64 0, ptr %union_match_result68, align 8
  br label %union_match_end69

union_next86:                                     ; preds = %union_next71
  call void @avra_match_unreachable(ptr @.match_fn.14, i64 %union_tag67, ptr @mu_file.15, i64 24)
  unreachable

union_match_end136:                               ; preds = %union_arm148, %union_arm137
  %union_match_val166 = load i64, ptr %union_match_result135, align 8
  %m167 = load ptr, ptr %m, align 8
  %cast168 = ptrtoint ptr %m167 to i64
  %null_chk169 = icmp eq i64 %cast168, 0
  %null_ext170 = zext i1 %null_chk169 to i64
  call void @avra_null_deref_trap(ptr @fld_name.27, i64 1, ptr @sty_name.28, i64 5, i64 %null_ext170, ptr @src_file.29, i64 96, i64 36)
  %b_ptr = getelementptr inbounds nuw %Multi, ptr %m167, i32 0, i32 1
  %b = load ptr, ptr %b_ptr, align 8
  %union_tag_ptr171 = getelementptr inbounds nuw %__union, ptr %b, i32 0, i32 0
  %union_tag172 = load i64, ptr %union_tag_ptr171, align 8
  store i64 0, ptr %union_match_result173, align 8
  %union_tag_eq177 = icmp eq i64 %union_tag172, 193495088
  br i1 %union_tag_eq177, label %union_arm175, label %union_next176

union_arm137:                                     ; preds = %union_match_end69
  %union_pay_ptr140 = getelementptr inbounds nuw %__union, ptr %a, i32 0, i32 1
  %union_payload141 = load ptr, ptr %union_pay_ptr140, align 8
  %union_val_slot_base142 = ptrtoint ptr %union_payload141 to i64
  %union_val_slot_addr143 = add i64 %union_val_slot_base142, 0
  %union_val_slot144 = inttoptr i64 %union_val_slot_addr143 to ptr
  %union_val145 = load i64, ptr %union_val_slot144, align 8
  store i64 %union_val145, ptr %n146, align 8
  %36 = call i32 @puts(ptr @.str.23)
  %widen147 = sext i32 %36 to i64
  store i64 0, ptr %union_match_result135, align 8
  br label %union_match_end136

union_next138:                                    ; preds = %union_match_end69
  %union_tag_eq150 = icmp eq i64 %union_tag134, 6954031493116
  br i1 %union_tag_eq150, label %union_arm148, label %union_next149

union_arm148:                                     ; preds = %union_next138
  %union_pay_ptr151 = getelementptr inbounds nuw %__union, ptr %a, i32 0, i32 1
  %union_payload152 = load ptr, ptr %union_pay_ptr151, align 8
  %union_val_slot_base153 = ptrtoint ptr %union_payload152 to i64
  %union_val_slot_addr154 = add i64 %union_val_slot_base153, 0
  %union_val_slot155 = inttoptr i64 %union_val_slot_addr154 to ptr
  %union_val156 = load ptr, ptr %union_val_slot155, align 8
  store ptr %union_val156, ptr %s157, align 8
  %s158 = load ptr, ptr %s157, align 8
  %37 = call i64 @strlen(ptr @.str.24)
  %38 = call i64 @strlen(ptr %s158)
  %concat_total159 = add i64 %37, %38
  %concat_size160 = add i64 %concat_total159, 1
  %39 = call ptr @avra_rc_alloc(i64 %concat_size160)
  %40 = call ptr @memcpy(ptr %39, ptr @.str.24, i64 %37)
  %cast161 = ptrtoint ptr %39 to i64
  %dst2_int162 = add i64 %cast161, %37
  %cast163 = inttoptr i64 %dst2_int162 to ptr
  %rhs_len_p1164 = add i64 %38, 1
  %41 = call ptr @memcpy(ptr %cast163, ptr %s158, i64 %rhs_len_p1164)
  %42 = call i32 @puts(ptr %39)
  %widen165 = sext i32 %42 to i64
  store i64 0, ptr %union_match_result135, align 8
  br label %union_match_end136

union_next149:                                    ; preds = %union_next138
  call void @avra_match_unreachable(ptr @.match_fn.25, i64 %union_tag134, ptr @mu_file.26, i64 32)
  unreachable

union_match_end174:                               ; preds = %union_arm186, %union_arm175
  %union_match_val204 = load i64, ptr %union_match_result173, align 8
  %m_cleanup = load ptr, ptr %m, align 8
  %43 = call i64 @__release_Multi(ptr %m_cleanup)
  %b2_cleanup = load ptr, ptr %b2, align 8
  %44 = call i64 @__release_Box(ptr %b2_cleanup)
  %c2_cleanup = load ptr, ptr %c2, align 8
  %45 = call i64 @__release_Box(ptr %c2_cleanup)
  ret i64 %union_match_val204

union_arm175:                                     ; preds = %union_match_end136
  %union_pay_ptr178 = getelementptr inbounds nuw %__union, ptr %b, i32 0, i32 1
  %union_payload179 = load ptr, ptr %union_pay_ptr178, align 8
  %union_val_slot_base180 = ptrtoint ptr %union_payload179 to i64
  %union_val_slot_addr181 = add i64 %union_val_slot_base180, 0
  %union_val_slot182 = inttoptr i64 %union_val_slot_addr181 to ptr
  %union_val183 = load i64, ptr %union_val_slot182, align 8
  store i64 %union_val183, ptr %n184, align 8
  %46 = call i32 @puts(ptr @.str.30)
  %widen185 = sext i32 %46 to i64
  store i64 0, ptr %union_match_result173, align 8
  br label %union_match_end174

union_next176:                                    ; preds = %union_match_end136
  %union_tag_eq188 = icmp eq i64 %union_tag172, 6385087377
  br i1 %union_tag_eq188, label %union_arm186, label %union_next187

union_arm186:                                     ; preds = %union_next176
  %union_pay_ptr189 = getelementptr inbounds nuw %__union, ptr %b, i32 0, i32 1
  %union_payload190 = load ptr, ptr %union_pay_ptr189, align 8
  %union_val_slot_base191 = ptrtoint ptr %union_payload190 to i64
  %union_val_slot_addr192 = add i64 %union_val_slot_base191, 0
  %union_val_slot193 = inttoptr i64 %union_val_slot_addr192 to ptr
  %union_val194 = load i1, ptr %union_val_slot193, align 8
  store i1 %union_val194, ptr %v, align 8
  %v195 = load i1, ptr %v, align 8
  %47 = call ptr @avra_rc_alloc(i64 32)
  %48 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %47, i64 32, ptr @.i2s_fmt.32, i1 %v195)
  %widen196 = sext i32 %48 to i64
  %49 = call i64 @strlen(ptr @.str.31)
  %50 = call i64 @strlen(ptr %47)
  %concat_total197 = add i64 %49, %50
  %concat_size198 = add i64 %concat_total197, 1
  %51 = call ptr @avra_rc_alloc(i64 %concat_size198)
  %52 = call ptr @memcpy(ptr %51, ptr @.str.31, i64 %49)
  %cast199 = ptrtoint ptr %51 to i64
  %dst2_int200 = add i64 %cast199, %49
  %cast201 = inttoptr i64 %dst2_int200 to ptr
  %rhs_len_p1202 = add i64 %50, 1
  %53 = call ptr @memcpy(ptr %cast201, ptr %47, i64 %rhs_len_p1202)
  %54 = call i32 @puts(ptr %51)
  %widen203 = sext i32 %54 to i64
  store i64 0, ptr %union_match_result173, align 8
  br label %union_match_end174

union_next187:                                    ; preds = %union_next176
  call void @avra_match_unreachable(ptr @.match_fn.33, i64 %union_tag172, ptr @mu_file.34, i64 36)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Multi(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_a_ptr = getelementptr inbounds nuw %Multi, ptr %0, i32 0, i32 0
  %rel_a = load ptr, ptr %rel_a_ptr, align 8
  %is_null_a = icmp eq ptr %rel_a, null
  br i1 %is_null_a, label %rel_a_skip, label %rel_a_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_b_skip
  ret i64 0

rel_a_skip:                                       ; preds = %rel_a_do, %do_free
  %rel_b_ptr = getelementptr inbounds nuw %Multi, ptr %0, i32 0, i32 1
  %rel_b = load ptr, ptr %rel_b_ptr, align 8
  %is_null_b = icmp eq ptr %rel_b, null
  br i1 %is_null_b, label %rel_b_skip, label %rel_b_do

rel_a_do:                                         ; preds = %do_free
  call void @avra_rc_release(ptr %rel_a)
  br label %rel_a_skip

rel_b_skip:                                       ; preds = %rel_b_do, %rel_a_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_b_do:                                         ; preds = %rel_a_skip
  call void @avra_rc_release(ptr %rel_b)
  br label %rel_b_skip
}

define i64 @__release_Box(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_val_ptr = getelementptr inbounds nuw %Box, ptr %0, i32 0, i32 0
  %rel_val = load ptr, ptr %rel_val_ptr, align 8
  %is_null_val = icmp eq ptr %rel_val, null
  br i1 %is_null_val, label %rel_val_skip, label %rel_val_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_label_skip
  ret i64 0

rel_val_skip:                                     ; preds = %rel_val_do, %do_free
  %rel_label_ptr = getelementptr inbounds nuw %Box, ptr %0, i32 0, i32 1
  %rel_label = load ptr, ptr %rel_label_ptr, align 8
  %is_null_label = icmp eq ptr %rel_label, null
  br i1 %is_null_label, label %rel_label_skip, label %rel_label_do

rel_val_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_val)
  br label %rel_val_skip

rel_label_skip:                                   ; preds = %rel_label_do, %rel_val_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_label_do:                                     ; preds = %rel_val_skip
  call void @avra_rc_release(ptr %rel_label)
  br label %rel_label_skip
}
