; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Outer = type { i64, ptr }
%Inner = type { i64, ptr }
%Outer__Wrap = type { ptr }
%Outer__Pair = type { ptr, ptr }
%Inner__B = type { ptr }

@.str = private unnamed_addr constant [9 x i8] c"wrap-a: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"wrap-b: \00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"wrap-empty\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"pair-aa: \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"pair-ab: \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/nested_pattern_combo.av\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"big: \00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [8 x i8] c"small: \00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [2 x i8] c"?\00", align 1
@.match_fn.17 = private unnamed_addr constant [8 x i8] c"guarded\00", align 1
@mu_file.18 = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/nested_pattern_combo.av\00", align 1
@.match_fn.19 = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file.20 = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/nested_pattern_combo.av\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.22 = private unnamed_addr constant [3 x i8] c"yo\00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.24 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.25 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.26 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.27 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.28 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.29 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"skip\00", align 1
@.match_fn.31 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.32 = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/nested_pattern_combo.av\00", align 1

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

define ptr @describe(ptr %0) {
entry:
  %msg175 = alloca ptr, align 8
  %x162 = alloca i64, align 8
  %y103 = alloca i64, align 8
  %x94 = alloca i64, align 8
  %msg31 = alloca ptr, align 8
  %x6 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %o = alloca ptr, align 8
  store ptr %0, ptr %o, align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm201, %march_arm198, %inner_pass149, %inner_pass81, %inner_pass52, %inner_pass22, %inner_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast203 = inttoptr i64 %match_val to ptr
  ret ptr %cast203

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %inner_i64_slot_base = ptrtoint ptr %payload to i64
  %inner_i64_slot_addr = add i64 %inner_i64_slot_base, 0
  %inner_i64_slot = inttoptr i64 %inner_i64_slot_addr to ptr
  %inner_i64 = load ptr, ptr %inner_i64_slot, align 8
  %inner_tag_ptr = getelementptr inbounds nuw %Inner, ptr %inner_i64, i32 0, i32 0
  %inner_tag = load i64, ptr %inner_tag_ptr, align 8
  %inner_tag_eq = icmp eq i64 %inner_tag, 177638
  br i1 %inner_tag_eq, label %inner_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq12 = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq12, label %march_arm10, label %march_next11

inner_pass:                                       ; preds = %march_arm
  %pay_slot2 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload3 = load ptr, ptr %pay_slot2, align 8
  %npat_val_slot_base = ptrtoint ptr %payload3 to i64
  %npat_val_slot_addr = add i64 %npat_val_slot_base, 0
  %npat_val_slot = inttoptr i64 %npat_val_slot_addr to ptr
  %npat_val = load ptr, ptr %npat_val_slot, align 8
  %pay_slot4 = getelementptr inbounds nuw %Inner, ptr %npat_val, i32 0, i32 1
  %payload5 = load ptr, ptr %pay_slot4, align 8
  %x_slot_base = ptrtoint ptr %payload5 to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x6, align 8
  %x7 = load i64, ptr %x6, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x7)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast8, ptr %1, i64 %rhs_len_p1)
  %cast9 = ptrtoint ptr %5 to i64
  store i64 %cast9, ptr %match_result, align 8
  br label %match_end

march_arm10:                                      ; preds = %march_next
  %pay_slot13 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload14 = load ptr, ptr %pay_slot13, align 8
  %inner_i64_slot_base15 = ptrtoint ptr %payload14 to i64
  %inner_i64_slot_addr16 = add i64 %inner_i64_slot_base15, 0
  %inner_i64_slot17 = inttoptr i64 %inner_i64_slot_addr16 to ptr
  %inner_i6418 = load ptr, ptr %inner_i64_slot17, align 8
  %inner_tag_ptr19 = getelementptr inbounds nuw %Inner, ptr %inner_i6418, i32 0, i32 0
  %inner_tag20 = load i64, ptr %inner_tag_ptr19, align 8
  %inner_tag_eq21 = icmp eq i64 %inner_tag20, 177639
  br i1 %inner_tag_eq21, label %inner_pass22, label %march_next11

march_next11:                                     ; preds = %march_arm10, %march_next
  %tag_eq42 = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq42, label %march_arm40, label %march_next41

inner_pass22:                                     ; preds = %march_arm10
  %pay_slot23 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload24 = load ptr, ptr %pay_slot23, align 8
  %npat_val_slot_base25 = ptrtoint ptr %payload24 to i64
  %npat_val_slot_addr26 = add i64 %npat_val_slot_base25, 0
  %npat_val_slot27 = inttoptr i64 %npat_val_slot_addr26 to ptr
  %npat_val28 = load ptr, ptr %npat_val_slot27, align 8
  %pay_slot29 = getelementptr inbounds nuw %Inner, ptr %npat_val28, i32 0, i32 1
  %payload30 = load ptr, ptr %pay_slot29, align 8
  %msg_slot_base = ptrtoint ptr %payload30 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 0
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @avra_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg31, align 8
  %msg32 = load ptr, ptr %msg31, align 8
  %8 = call i64 @strlen(ptr @.str.1)
  %9 = call i64 @strlen(ptr %msg32)
  %concat_total33 = add i64 %8, %9
  %concat_size34 = add i64 %concat_total33, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size34)
  %11 = call ptr @memcpy(ptr %10, ptr @.str.1, i64 %8)
  %cast35 = ptrtoint ptr %10 to i64
  %dst2_int36 = add i64 %cast35, %8
  %cast37 = inttoptr i64 %dst2_int36 to ptr
  %rhs_len_p138 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast37, ptr %msg32, i64 %rhs_len_p138)
  %cast39 = ptrtoint ptr %10 to i64
  store i64 %cast39, ptr %match_result, align 8
  br label %match_end

march_arm40:                                      ; preds = %march_next11
  %pay_slot43 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload44 = load ptr, ptr %pay_slot43, align 8
  %inner_i64_slot_base45 = ptrtoint ptr %payload44 to i64
  %inner_i64_slot_addr46 = add i64 %inner_i64_slot_base45, 0
  %inner_i64_slot47 = inttoptr i64 %inner_i64_slot_addr46 to ptr
  %inner_i6448 = load ptr, ptr %inner_i64_slot47, align 8
  %inner_tag_ptr49 = getelementptr inbounds nuw %Inner, ptr %inner_i6448, i32 0, i32 0
  %inner_tag50 = load i64, ptr %inner_tag_ptr49, align 8
  %inner_tag_eq51 = icmp eq i64 %inner_tag50, 210673421332
  br i1 %inner_tag_eq51, label %inner_pass52, label %march_next41

march_next41:                                     ; preds = %march_arm40, %march_next11
  %tag_eq61 = icmp eq i64 %tag, 6384425073
  br i1 %tag_eq61, label %march_arm59, label %march_next60

inner_pass52:                                     ; preds = %march_arm40
  %pay_slot53 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload54 = load ptr, ptr %pay_slot53, align 8
  %npat_val_slot_base55 = ptrtoint ptr %payload54 to i64
  %npat_val_slot_addr56 = add i64 %npat_val_slot_base55, 0
  %npat_val_slot57 = inttoptr i64 %npat_val_slot_addr56 to ptr
  %npat_val58 = load ptr, ptr %npat_val_slot57, align 8
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_arm59:                                      ; preds = %march_next41
  %pay_slot62 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload63 = load ptr, ptr %pay_slot62, align 8
  %inner_i64_slot_base64 = ptrtoint ptr %payload63 to i64
  %inner_i64_slot_addr65 = add i64 %inner_i64_slot_base64, 0
  %inner_i64_slot66 = inttoptr i64 %inner_i64_slot_addr65 to ptr
  %inner_i6467 = load ptr, ptr %inner_i64_slot66, align 8
  %inner_tag_ptr68 = getelementptr inbounds nuw %Inner, ptr %inner_i6467, i32 0, i32 0
  %inner_tag69 = load i64, ptr %inner_tag_ptr68, align 8
  %inner_tag_eq70 = icmp eq i64 %inner_tag69, 177638
  br i1 %inner_tag_eq70, label %inner_pass71, label %march_next60

march_next60:                                     ; preds = %inner_pass71, %march_arm59, %march_next41
  %tag_eq129 = icmp eq i64 %tag, 6384425073
  br i1 %tag_eq129, label %march_arm127, label %march_next128

inner_pass71:                                     ; preds = %march_arm59
  %pay_slot72 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload73 = load ptr, ptr %pay_slot72, align 8
  %inner_i64_slot_base74 = ptrtoint ptr %payload73 to i64
  %inner_i64_slot_addr75 = add i64 %inner_i64_slot_base74, 8
  %inner_i64_slot76 = inttoptr i64 %inner_i64_slot_addr75 to ptr
  %inner_i6477 = load ptr, ptr %inner_i64_slot76, align 8
  %inner_tag_ptr78 = getelementptr inbounds nuw %Inner, ptr %inner_i6477, i32 0, i32 0
  %inner_tag79 = load i64, ptr %inner_tag_ptr78, align 8
  %inner_tag_eq80 = icmp eq i64 %inner_tag79, 177638
  br i1 %inner_tag_eq80, label %inner_pass81, label %march_next60

inner_pass81:                                     ; preds = %inner_pass71
  %pay_slot82 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload83 = load ptr, ptr %pay_slot82, align 8
  %npat_val_slot_base84 = ptrtoint ptr %payload83 to i64
  %npat_val_slot_addr85 = add i64 %npat_val_slot_base84, 0
  %npat_val_slot86 = inttoptr i64 %npat_val_slot_addr85 to ptr
  %npat_val87 = load ptr, ptr %npat_val_slot86, align 8
  %pay_slot88 = getelementptr inbounds nuw %Inner, ptr %npat_val87, i32 0, i32 1
  %payload89 = load ptr, ptr %pay_slot88, align 8
  %x_slot_base90 = ptrtoint ptr %payload89 to i64
  %x_slot_addr91 = add i64 %x_slot_base90, 0
  %x_slot92 = inttoptr i64 %x_slot_addr91 to ptr
  %x93 = load i64, ptr %x_slot92, align 8
  store i64 %x93, ptr %x94, align 8
  %pay_slot95 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload96 = load ptr, ptr %pay_slot95, align 8
  %npat_val_slot_base97 = ptrtoint ptr %payload96 to i64
  %npat_val_slot_addr98 = add i64 %npat_val_slot_base97, 8
  %npat_val_slot99 = inttoptr i64 %npat_val_slot_addr98 to ptr
  %npat_val100 = load ptr, ptr %npat_val_slot99, align 8
  %pay_slot101 = getelementptr inbounds nuw %Inner, ptr %npat_val100, i32 0, i32 1
  %payload102 = load ptr, ptr %pay_slot101, align 8
  %y_slot_base = ptrtoint ptr %payload102 to i64
  %y_slot_addr = add i64 %y_slot_base, 0
  %y_slot = inttoptr i64 %y_slot_addr to ptr
  %y = load i64, ptr %y_slot, align 8
  store i64 %y, ptr %y103, align 8
  %x104 = load i64, ptr %x94, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.4, i64 %x104)
  %widen105 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.3)
  %16 = call i64 @strlen(ptr %13)
  %concat_total106 = add i64 %15, %16
  %concat_size107 = add i64 %concat_total106, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size107)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.3, i64 %15)
  %cast108 = ptrtoint ptr %17 to i64
  %dst2_int109 = add i64 %cast108, %15
  %cast110 = inttoptr i64 %dst2_int109 to ptr
  %rhs_len_p1111 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast110, ptr %13, i64 %rhs_len_p1111)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.5)
  %concat_total112 = add i64 %20, %21
  %concat_size113 = add i64 %concat_total112, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size113)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast114 = ptrtoint ptr %22 to i64
  %dst2_int115 = add i64 %cast114, %20
  %cast116 = inttoptr i64 %dst2_int115 to ptr
  %rhs_len_p1117 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast116, ptr @.str.5, i64 %rhs_len_p1117)
  %y118 = load i64, ptr %y103, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.6, i64 %y118)
  %widen119 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr %22)
  %28 = call i64 @strlen(ptr %25)
  %concat_total120 = add i64 %27, %28
  %concat_size121 = add i64 %concat_total120, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size121)
  %30 = call ptr @memcpy(ptr %29, ptr %22, i64 %27)
  %cast122 = ptrtoint ptr %29 to i64
  %dst2_int123 = add i64 %cast122, %27
  %cast124 = inttoptr i64 %dst2_int123 to ptr
  %rhs_len_p1125 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast124, ptr %25, i64 %rhs_len_p1125)
  %cast126 = ptrtoint ptr %29 to i64
  store i64 %cast126, ptr %match_result, align 8
  br label %match_end

march_arm127:                                     ; preds = %march_next60
  %pay_slot130 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload131 = load ptr, ptr %pay_slot130, align 8
  %inner_i64_slot_base132 = ptrtoint ptr %payload131 to i64
  %inner_i64_slot_addr133 = add i64 %inner_i64_slot_base132, 0
  %inner_i64_slot134 = inttoptr i64 %inner_i64_slot_addr133 to ptr
  %inner_i64135 = load ptr, ptr %inner_i64_slot134, align 8
  %inner_tag_ptr136 = getelementptr inbounds nuw %Inner, ptr %inner_i64135, i32 0, i32 0
  %inner_tag137 = load i64, ptr %inner_tag_ptr136, align 8
  %inner_tag_eq138 = icmp eq i64 %inner_tag137, 177638
  br i1 %inner_tag_eq138, label %inner_pass139, label %march_next128

march_next128:                                    ; preds = %inner_pass139, %march_arm127, %march_next60
  %tag_eq200 = icmp eq i64 %tag, 6384368597
  br i1 %tag_eq200, label %march_arm198, label %march_next199

inner_pass139:                                    ; preds = %march_arm127
  %pay_slot140 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload141 = load ptr, ptr %pay_slot140, align 8
  %inner_i64_slot_base142 = ptrtoint ptr %payload141 to i64
  %inner_i64_slot_addr143 = add i64 %inner_i64_slot_base142, 8
  %inner_i64_slot144 = inttoptr i64 %inner_i64_slot_addr143 to ptr
  %inner_i64145 = load ptr, ptr %inner_i64_slot144, align 8
  %inner_tag_ptr146 = getelementptr inbounds nuw %Inner, ptr %inner_i64145, i32 0, i32 0
  %inner_tag147 = load i64, ptr %inner_tag_ptr146, align 8
  %inner_tag_eq148 = icmp eq i64 %inner_tag147, 177639
  br i1 %inner_tag_eq148, label %inner_pass149, label %march_next128

inner_pass149:                                    ; preds = %inner_pass139
  %pay_slot150 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload151 = load ptr, ptr %pay_slot150, align 8
  %npat_val_slot_base152 = ptrtoint ptr %payload151 to i64
  %npat_val_slot_addr153 = add i64 %npat_val_slot_base152, 0
  %npat_val_slot154 = inttoptr i64 %npat_val_slot_addr153 to ptr
  %npat_val155 = load ptr, ptr %npat_val_slot154, align 8
  %pay_slot156 = getelementptr inbounds nuw %Inner, ptr %npat_val155, i32 0, i32 1
  %payload157 = load ptr, ptr %pay_slot156, align 8
  %x_slot_base158 = ptrtoint ptr %payload157 to i64
  %x_slot_addr159 = add i64 %x_slot_base158, 0
  %x_slot160 = inttoptr i64 %x_slot_addr159 to ptr
  %x161 = load i64, ptr %x_slot160, align 8
  store i64 %x161, ptr %x162, align 8
  %pay_slot163 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload164 = load ptr, ptr %pay_slot163, align 8
  %npat_val_slot_base165 = ptrtoint ptr %payload164 to i64
  %npat_val_slot_addr166 = add i64 %npat_val_slot_base165, 8
  %npat_val_slot167 = inttoptr i64 %npat_val_slot_addr166 to ptr
  %npat_val168 = load ptr, ptr %npat_val_slot167, align 8
  %pay_slot169 = getelementptr inbounds nuw %Inner, ptr %npat_val168, i32 0, i32 1
  %payload170 = load ptr, ptr %pay_slot169, align 8
  %msg_slot_base171 = ptrtoint ptr %payload170 to i64
  %msg_slot_addr172 = add i64 %msg_slot_base171, 0
  %msg_slot173 = inttoptr i64 %msg_slot_addr172 to ptr
  %msg174 = load ptr, ptr %msg_slot173, align 8
  call void @avra_rc_retain(ptr %msg174)
  store ptr %msg174, ptr %msg175, align 8
  %x176 = load i64, ptr %x162, align 8
  %32 = call ptr @avra_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.8, i64 %x176)
  %widen177 = sext i32 %33 to i64
  %34 = call i64 @strlen(ptr @.str.7)
  %35 = call i64 @strlen(ptr %32)
  %concat_total178 = add i64 %34, %35
  %concat_size179 = add i64 %concat_total178, 1
  %36 = call ptr @avra_rc_alloc(i64 %concat_size179)
  %37 = call ptr @memcpy(ptr %36, ptr @.str.7, i64 %34)
  %cast180 = ptrtoint ptr %36 to i64
  %dst2_int181 = add i64 %cast180, %34
  %cast182 = inttoptr i64 %dst2_int181 to ptr
  %rhs_len_p1183 = add i64 %35, 1
  %38 = call ptr @memcpy(ptr %cast182, ptr %32, i64 %rhs_len_p1183)
  %39 = call i64 @strlen(ptr %36)
  %40 = call i64 @strlen(ptr @.str.9)
  %concat_total184 = add i64 %39, %40
  %concat_size185 = add i64 %concat_total184, 1
  %41 = call ptr @avra_rc_alloc(i64 %concat_size185)
  %42 = call ptr @memcpy(ptr %41, ptr %36, i64 %39)
  %cast186 = ptrtoint ptr %41 to i64
  %dst2_int187 = add i64 %cast186, %39
  %cast188 = inttoptr i64 %dst2_int187 to ptr
  %rhs_len_p1189 = add i64 %40, 1
  %43 = call ptr @memcpy(ptr %cast188, ptr @.str.9, i64 %rhs_len_p1189)
  %msg190 = load ptr, ptr %msg175, align 8
  %44 = call i64 @strlen(ptr %41)
  %45 = call i64 @strlen(ptr %msg190)
  %concat_total191 = add i64 %44, %45
  %concat_size192 = add i64 %concat_total191, 1
  %46 = call ptr @avra_rc_alloc(i64 %concat_size192)
  %47 = call ptr @memcpy(ptr %46, ptr %41, i64 %44)
  %cast193 = ptrtoint ptr %46 to i64
  %dst2_int194 = add i64 %cast193, %44
  %cast195 = inttoptr i64 %dst2_int194 to ptr
  %rhs_len_p1196 = add i64 %45, 1
  %48 = call ptr @memcpy(ptr %cast195, ptr %msg190, i64 %rhs_len_p1196)
  %cast197 = ptrtoint ptr %46 to i64
  store i64 %cast197, ptr %match_result, align 8
  br label %match_end

march_arm198:                                     ; preds = %march_next128
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %match_result, align 8
  br label %match_end

march_next199:                                    ; preds = %march_next128
  br label %march_arm201

march_arm201:                                     ; preds = %march_next199
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %match_result, align 8
  br label %match_end

march_next202:                                    ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable
}

define ptr @guarded(ptr %0) {
entry:
  %x36 = alloca i64, align 8
  %x6 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %o = alloca ptr, align 8
  store ptr %0, ptr %o, align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm46, %inner_pass23, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast48 = inttoptr i64 %match_val to ptr
  ret ptr %cast48

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %inner_i64_slot_base = ptrtoint ptr %payload to i64
  %inner_i64_slot_addr = add i64 %inner_i64_slot_base, 0
  %inner_i64_slot = inttoptr i64 %inner_i64_slot_addr to ptr
  %inner_i64 = load ptr, ptr %inner_i64_slot, align 8
  %inner_tag_ptr = getelementptr inbounds nuw %Inner, ptr %inner_i64, i32 0, i32 0
  %inner_tag = load i64, ptr %inner_tag_ptr, align 8
  %inner_tag_eq = icmp eq i64 %inner_tag, 177638
  br i1 %inner_tag_eq, label %inner_pass, label %march_next

march_next:                                       ; preds = %inner_pass, %march_arm, %entry
  %tag_eq13 = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq13, label %march_arm11, label %march_next12

inner_pass:                                       ; preds = %march_arm
  %pay_slot2 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload3 = load ptr, ptr %pay_slot2, align 8
  %npat_val_slot_base = ptrtoint ptr %payload3 to i64
  %npat_val_slot_addr = add i64 %npat_val_slot_base, 0
  %npat_val_slot = inttoptr i64 %npat_val_slot_addr to ptr
  %npat_val = load ptr, ptr %npat_val_slot, align 8
  %pay_slot4 = getelementptr inbounds nuw %Inner, ptr %npat_val, i32 0, i32 1
  %payload5 = load ptr, ptr %pay_slot4, align 8
  %x_slot_base = ptrtoint ptr %payload5 to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x6, align 8
  %x7 = load i64, ptr %x6, align 8
  %sgt = icmp sgt i64 %x7, 10
  %sgt_ext = zext i1 %sgt to i64
  %guard = icmp ne i64 %sgt_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

guard_pass:                                       ; preds = %inner_pass
  %x8 = load i64, ptr %x6, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.13, i64 %x8)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.12)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.12, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast9 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast9, ptr %1, i64 %rhs_len_p1)
  %cast10 = ptrtoint ptr %5 to i64
  store i64 %cast10, ptr %match_result, align 8
  br label %match_end

march_arm11:                                      ; preds = %march_next
  %pay_slot14 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload15 = load ptr, ptr %pay_slot14, align 8
  %inner_i64_slot_base16 = ptrtoint ptr %payload15 to i64
  %inner_i64_slot_addr17 = add i64 %inner_i64_slot_base16, 0
  %inner_i64_slot18 = inttoptr i64 %inner_i64_slot_addr17 to ptr
  %inner_i6419 = load ptr, ptr %inner_i64_slot18, align 8
  %inner_tag_ptr20 = getelementptr inbounds nuw %Inner, ptr %inner_i6419, i32 0, i32 0
  %inner_tag21 = load i64, ptr %inner_tag_ptr20, align 8
  %inner_tag_eq22 = icmp eq i64 %inner_tag21, 177638
  br i1 %inner_tag_eq22, label %inner_pass23, label %march_next12

march_next12:                                     ; preds = %march_arm11, %march_next
  br label %march_arm46

inner_pass23:                                     ; preds = %march_arm11
  %pay_slot24 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload25 = load ptr, ptr %pay_slot24, align 8
  %npat_val_slot_base26 = ptrtoint ptr %payload25 to i64
  %npat_val_slot_addr27 = add i64 %npat_val_slot_base26, 0
  %npat_val_slot28 = inttoptr i64 %npat_val_slot_addr27 to ptr
  %npat_val29 = load ptr, ptr %npat_val_slot28, align 8
  %pay_slot30 = getelementptr inbounds nuw %Inner, ptr %npat_val29, i32 0, i32 1
  %payload31 = load ptr, ptr %pay_slot30, align 8
  %x_slot_base32 = ptrtoint ptr %payload31 to i64
  %x_slot_addr33 = add i64 %x_slot_base32, 0
  %x_slot34 = inttoptr i64 %x_slot_addr33 to ptr
  %x35 = load i64, ptr %x_slot34, align 8
  store i64 %x35, ptr %x36, align 8
  %x37 = load i64, ptr %x36, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.15, i64 %x37)
  %widen38 = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str.14)
  %11 = call i64 @strlen(ptr %8)
  %concat_total39 = add i64 %10, %11
  %concat_size40 = add i64 %concat_total39, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size40)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.14, i64 %10)
  %cast41 = ptrtoint ptr %12 to i64
  %dst2_int42 = add i64 %cast41, %10
  %cast43 = inttoptr i64 %dst2_int42 to ptr
  %rhs_len_p144 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast43, ptr %8, i64 %rhs_len_p144)
  %cast45 = ptrtoint ptr %12 to i64
  store i64 %cast45, ptr %match_result, align 8
  br label %match_end

march_arm46:                                      ; preds = %march_next12
  store i64 ptrtoint (ptr @.str.16 to i64), ptr %match_result, align 8
  br label %match_end

march_next47:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.17, i64 %tag, ptr @mu_file.18, i64 21)
  unreachable
}

define i64 @classify(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %o = alloca ptr, align 8
  store ptr %0, ptr %o, align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm26, %march_arm23, %inner_pass16, %inner_pass
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %inner_i64_slot_base = ptrtoint ptr %payload to i64
  %inner_i64_slot_addr = add i64 %inner_i64_slot_base, 0
  %inner_i64_slot = inttoptr i64 %inner_i64_slot_addr to ptr
  %inner_i64 = load ptr, ptr %inner_i64_slot, align 8
  %inner_tag_ptr = getelementptr inbounds nuw %Inner, ptr %inner_i64, i32 0, i32 0
  %inner_tag = load i64, ptr %inner_tag_ptr, align 8
  %inner_tag_eq = icmp eq i64 %inner_tag, 177638
  br i1 %inner_tag_eq, label %inner_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq6 = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq6, label %march_arm4, label %march_next5

inner_pass:                                       ; preds = %march_arm
  %pay_slot2 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload3 = load ptr, ptr %pay_slot2, align 8
  %npat_val_slot_base = ptrtoint ptr %payload3 to i64
  %npat_val_slot_addr = add i64 %npat_val_slot_base, 0
  %npat_val_slot = inttoptr i64 %npat_val_slot_addr to ptr
  %npat_val = load ptr, ptr %npat_val_slot, align 8
  store i64 1, ptr %match_result, align 8
  br label %match_end

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %inner_i64_slot_base9 = ptrtoint ptr %payload8 to i64
  %inner_i64_slot_addr10 = add i64 %inner_i64_slot_base9, 0
  %inner_i64_slot11 = inttoptr i64 %inner_i64_slot_addr10 to ptr
  %inner_i6412 = load ptr, ptr %inner_i64_slot11, align 8
  %inner_tag_ptr13 = getelementptr inbounds nuw %Inner, ptr %inner_i6412, i32 0, i32 0
  %inner_tag14 = load i64, ptr %inner_tag_ptr13, align 8
  %inner_tag_eq15 = icmp eq i64 %inner_tag14, 177639
  br i1 %inner_tag_eq15, label %inner_pass16, label %march_next5

march_next5:                                      ; preds = %march_arm4, %march_next
  %tag_eq25 = icmp eq i64 %tag, 6384368597
  br i1 %tag_eq25, label %march_arm23, label %march_next24

inner_pass16:                                     ; preds = %march_arm4
  %pay_slot17 = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload18 = load ptr, ptr %pay_slot17, align 8
  %npat_val_slot_base19 = ptrtoint ptr %payload18 to i64
  %npat_val_slot_addr20 = add i64 %npat_val_slot_base19, 0
  %npat_val_slot21 = inttoptr i64 %npat_val_slot_addr20 to ptr
  %npat_val22 = load ptr, ptr %npat_val_slot21, align 8
  store i64 2, ptr %match_result, align 8
  br label %match_end

march_arm23:                                      ; preds = %march_next5
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next24:                                     ; preds = %march_next5
  br label %march_arm26

march_arm26:                                      ; preds = %march_next24
  store i64 3, ptr %match_result, align 8
  br label %match_end

march_next27:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.19, i64 %tag, ptr @mu_file.20, i64 30)
  unreachable
}

define i1 @is_wrap_a(ptr %0) {
entry:
  %o = alloca ptr, align 8
  store ptr %0, ptr %o, align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 6384694879
  %is_eq_ext = zext i1 %is_eq to i64
  %cast = trunc i64 %is_eq_ext to i1
  ret i1 %cast
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %x223 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %items = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %1, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Outer, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Inner, ptr %3, i32 0, i32 0
  store i64 177638, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Inner, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr2, align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast = ptrtoint ptr %3 to i64
  %slot_base3 = ptrtoint ptr %2 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  %cast6 = inttoptr i64 %cast to ptr
  store ptr %cast6, ptr %slot5, align 8
  %cast7 = ptrtoint ptr %1 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %5 = call ptr @describe(ptr %cast8)
  %6 = call i32 @puts(ptr %5)
  %widen = sext i32 %6 to i64
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr9 = getelementptr inbounds nuw %Outer, ptr %7, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr9, align 8
  %pay_ptr10 = getelementptr inbounds nuw %Outer, ptr %7, i32 0, i32 1
  %8 = call ptr @avra_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr10, align 8
  %9 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %Inner, ptr %9, i32 0, i32 0
  store i64 177639, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %Inner, ptr %9, i32 0, i32 1
  %10 = call ptr @avra_rc_alloc(i64 8)
  store ptr %10, ptr %pay_ptr12, align 8
  %slot_base13 = ptrtoint ptr %10 to i64
  %slot_addr14 = add i64 %slot_base13, 0
  %slot15 = inttoptr i64 %slot_addr14 to ptr
  store ptr @.str.21, ptr %slot15, align 8
  %cast16 = ptrtoint ptr %9 to i64
  %slot_base17 = ptrtoint ptr %8 to i64
  %slot_addr18 = add i64 %slot_base17, 0
  %slot19 = inttoptr i64 %slot_addr18 to ptr
  %cast20 = inttoptr i64 %cast16 to ptr
  store ptr %cast20, ptr %slot19, align 8
  %cast21 = ptrtoint ptr %7 to i64
  %cast22 = inttoptr i64 %cast21 to ptr
  %11 = call ptr @describe(ptr %cast22)
  %12 = call i32 @puts(ptr %11)
  %widen23 = sext i32 %12 to i64
  %13 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr24 = getelementptr inbounds nuw %Outer, ptr %13, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr24, align 8
  %pay_ptr25 = getelementptr inbounds nuw %Outer, ptr %13, i32 0, i32 1
  %14 = call ptr @avra_rc_alloc(i64 8)
  store ptr %14, ptr %pay_ptr25, align 8
  %15 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %Inner, ptr %15, i32 0, i32 0
  store i64 210673421332, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %Inner, ptr %15, i32 0, i32 1
  store ptr null, ptr %pay_ptr27, align 8
  %cast28 = ptrtoint ptr %15 to i64
  %slot_base29 = ptrtoint ptr %14 to i64
  %slot_addr30 = add i64 %slot_base29, 0
  %slot31 = inttoptr i64 %slot_addr30 to ptr
  %cast32 = inttoptr i64 %cast28 to ptr
  store ptr %cast32, ptr %slot31, align 8
  %cast33 = ptrtoint ptr %13 to i64
  %cast34 = inttoptr i64 %cast33 to ptr
  %16 = call ptr @describe(ptr %cast34)
  %17 = call i32 @puts(ptr %16)
  %widen35 = sext i32 %17 to i64
  %18 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %Outer, ptr %18, i32 0, i32 0
  store i64 6384425073, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %Outer, ptr %18, i32 0, i32 1
  %19 = call ptr @avra_rc_alloc(i64 16)
  store ptr %19, ptr %pay_ptr37, align 8
  %20 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %Inner, ptr %20, i32 0, i32 0
  store i64 177638, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %Inner, ptr %20, i32 0, i32 1
  %21 = call ptr @avra_rc_alloc(i64 8)
  store ptr %21, ptr %pay_ptr39, align 8
  %slot_base40 = ptrtoint ptr %21 to i64
  %slot_addr41 = add i64 %slot_base40, 0
  %slot42 = inttoptr i64 %slot_addr41 to ptr
  store i64 1, ptr %slot42, align 8
  %cast43 = ptrtoint ptr %20 to i64
  %slot_base44 = ptrtoint ptr %19 to i64
  %slot_addr45 = add i64 %slot_base44, 0
  %slot46 = inttoptr i64 %slot_addr45 to ptr
  %cast47 = inttoptr i64 %cast43 to ptr
  store ptr %cast47, ptr %slot46, align 8
  %22 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr48 = getelementptr inbounds nuw %Inner, ptr %22, i32 0, i32 0
  store i64 177638, ptr %tag_ptr48, align 8
  %pay_ptr49 = getelementptr inbounds nuw %Inner, ptr %22, i32 0, i32 1
  %23 = call ptr @avra_rc_alloc(i64 8)
  store ptr %23, ptr %pay_ptr49, align 8
  %slot_base50 = ptrtoint ptr %23 to i64
  %slot_addr51 = add i64 %slot_base50, 0
  %slot52 = inttoptr i64 %slot_addr51 to ptr
  store i64 2, ptr %slot52, align 8
  %cast53 = ptrtoint ptr %22 to i64
  %slot_base54 = ptrtoint ptr %19 to i64
  %slot_addr55 = add i64 %slot_base54, 8
  %slot56 = inttoptr i64 %slot_addr55 to ptr
  %cast57 = inttoptr i64 %cast53 to ptr
  store ptr %cast57, ptr %slot56, align 8
  %cast58 = ptrtoint ptr %18 to i64
  %cast59 = inttoptr i64 %cast58 to ptr
  %24 = call ptr @describe(ptr %cast59)
  %25 = call i32 @puts(ptr %24)
  %widen60 = sext i32 %25 to i64
  %26 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr61 = getelementptr inbounds nuw %Outer, ptr %26, i32 0, i32 0
  store i64 6384425073, ptr %tag_ptr61, align 8
  %pay_ptr62 = getelementptr inbounds nuw %Outer, ptr %26, i32 0, i32 1
  %27 = call ptr @avra_rc_alloc(i64 16)
  store ptr %27, ptr %pay_ptr62, align 8
  %28 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr63 = getelementptr inbounds nuw %Inner, ptr %28, i32 0, i32 0
  store i64 177638, ptr %tag_ptr63, align 8
  %pay_ptr64 = getelementptr inbounds nuw %Inner, ptr %28, i32 0, i32 1
  %29 = call ptr @avra_rc_alloc(i64 8)
  store ptr %29, ptr %pay_ptr64, align 8
  %slot_base65 = ptrtoint ptr %29 to i64
  %slot_addr66 = add i64 %slot_base65, 0
  %slot67 = inttoptr i64 %slot_addr66 to ptr
  store i64 3, ptr %slot67, align 8
  %cast68 = ptrtoint ptr %28 to i64
  %slot_base69 = ptrtoint ptr %27 to i64
  %slot_addr70 = add i64 %slot_base69, 0
  %slot71 = inttoptr i64 %slot_addr70 to ptr
  %cast72 = inttoptr i64 %cast68 to ptr
  store ptr %cast72, ptr %slot71, align 8
  %30 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr73 = getelementptr inbounds nuw %Inner, ptr %30, i32 0, i32 0
  store i64 177639, ptr %tag_ptr73, align 8
  %pay_ptr74 = getelementptr inbounds nuw %Inner, ptr %30, i32 0, i32 1
  %31 = call ptr @avra_rc_alloc(i64 8)
  store ptr %31, ptr %pay_ptr74, align 8
  %slot_base75 = ptrtoint ptr %31 to i64
  %slot_addr76 = add i64 %slot_base75, 0
  %slot77 = inttoptr i64 %slot_addr76 to ptr
  store ptr @.str.22, ptr %slot77, align 8
  %cast78 = ptrtoint ptr %30 to i64
  %slot_base79 = ptrtoint ptr %27 to i64
  %slot_addr80 = add i64 %slot_base79, 8
  %slot81 = inttoptr i64 %slot_addr80 to ptr
  %cast82 = inttoptr i64 %cast78 to ptr
  store ptr %cast82, ptr %slot81, align 8
  %cast83 = ptrtoint ptr %26 to i64
  %cast84 = inttoptr i64 %cast83 to ptr
  %32 = call ptr @describe(ptr %cast84)
  %33 = call i32 @puts(ptr %32)
  %widen85 = sext i32 %33 to i64
  %34 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr86 = getelementptr inbounds nuw %Outer, ptr %34, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr86, align 8
  %pay_ptr87 = getelementptr inbounds nuw %Outer, ptr %34, i32 0, i32 1
  store ptr null, ptr %pay_ptr87, align 8
  %cast88 = ptrtoint ptr %34 to i64
  %cast89 = inttoptr i64 %cast88 to ptr
  %35 = call ptr @describe(ptr %cast89)
  %36 = call i32 @puts(ptr %35)
  %widen90 = sext i32 %36 to i64
  %37 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr91 = getelementptr inbounds nuw %Outer, ptr %37, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr91, align 8
  %pay_ptr92 = getelementptr inbounds nuw %Outer, ptr %37, i32 0, i32 1
  %38 = call ptr @avra_rc_alloc(i64 8)
  store ptr %38, ptr %pay_ptr92, align 8
  %39 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr93 = getelementptr inbounds nuw %Inner, ptr %39, i32 0, i32 0
  store i64 177638, ptr %tag_ptr93, align 8
  %pay_ptr94 = getelementptr inbounds nuw %Inner, ptr %39, i32 0, i32 1
  %40 = call ptr @avra_rc_alloc(i64 8)
  store ptr %40, ptr %pay_ptr94, align 8
  %slot_base95 = ptrtoint ptr %40 to i64
  %slot_addr96 = add i64 %slot_base95, 0
  %slot97 = inttoptr i64 %slot_addr96 to ptr
  store i64 5, ptr %slot97, align 8
  %cast98 = ptrtoint ptr %39 to i64
  %slot_base99 = ptrtoint ptr %38 to i64
  %slot_addr100 = add i64 %slot_base99, 0
  %slot101 = inttoptr i64 %slot_addr100 to ptr
  %cast102 = inttoptr i64 %cast98 to ptr
  store ptr %cast102, ptr %slot101, align 8
  %cast103 = ptrtoint ptr %37 to i64
  %cast104 = inttoptr i64 %cast103 to ptr
  %41 = call ptr @guarded(ptr %cast104)
  %42 = call i32 @puts(ptr %41)
  %widen105 = sext i32 %42 to i64
  %43 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr106 = getelementptr inbounds nuw %Outer, ptr %43, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr106, align 8
  %pay_ptr107 = getelementptr inbounds nuw %Outer, ptr %43, i32 0, i32 1
  %44 = call ptr @avra_rc_alloc(i64 8)
  store ptr %44, ptr %pay_ptr107, align 8
  %45 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr108 = getelementptr inbounds nuw %Inner, ptr %45, i32 0, i32 0
  store i64 177638, ptr %tag_ptr108, align 8
  %pay_ptr109 = getelementptr inbounds nuw %Inner, ptr %45, i32 0, i32 1
  %46 = call ptr @avra_rc_alloc(i64 8)
  store ptr %46, ptr %pay_ptr109, align 8
  %slot_base110 = ptrtoint ptr %46 to i64
  %slot_addr111 = add i64 %slot_base110, 0
  %slot112 = inttoptr i64 %slot_addr111 to ptr
  store i64 20, ptr %slot112, align 8
  %cast113 = ptrtoint ptr %45 to i64
  %slot_base114 = ptrtoint ptr %44 to i64
  %slot_addr115 = add i64 %slot_base114, 0
  %slot116 = inttoptr i64 %slot_addr115 to ptr
  %cast117 = inttoptr i64 %cast113 to ptr
  store ptr %cast117, ptr %slot116, align 8
  %cast118 = ptrtoint ptr %43 to i64
  %cast119 = inttoptr i64 %cast118 to ptr
  %47 = call ptr @guarded(ptr %cast119)
  %48 = call i32 @puts(ptr %47)
  %widen120 = sext i32 %48 to i64
  %49 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr121 = getelementptr inbounds nuw %Outer, ptr %49, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr121, align 8
  %pay_ptr122 = getelementptr inbounds nuw %Outer, ptr %49, i32 0, i32 1
  %50 = call ptr @avra_rc_alloc(i64 8)
  store ptr %50, ptr %pay_ptr122, align 8
  %51 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr123 = getelementptr inbounds nuw %Inner, ptr %51, i32 0, i32 0
  store i64 177638, ptr %tag_ptr123, align 8
  %pay_ptr124 = getelementptr inbounds nuw %Inner, ptr %51, i32 0, i32 1
  %52 = call ptr @avra_rc_alloc(i64 8)
  store ptr %52, ptr %pay_ptr124, align 8
  %slot_base125 = ptrtoint ptr %52 to i64
  %slot_addr126 = add i64 %slot_base125, 0
  %slot127 = inttoptr i64 %slot_addr126 to ptr
  store i64 1, ptr %slot127, align 8
  %cast128 = ptrtoint ptr %51 to i64
  %slot_base129 = ptrtoint ptr %50 to i64
  %slot_addr130 = add i64 %slot_base129, 0
  %slot131 = inttoptr i64 %slot_addr130 to ptr
  %cast132 = inttoptr i64 %cast128 to ptr
  store ptr %cast132, ptr %slot131, align 8
  %cast133 = ptrtoint ptr %49 to i64
  %cast134 = inttoptr i64 %cast133 to ptr
  %53 = call i64 @classify(ptr %cast134)
  %54 = call ptr @avra_rc_alloc(i64 32)
  %55 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %54, i64 32, ptr @.i2s_fmt.23, i64 %53)
  %widen135 = sext i32 %55 to i64
  %56 = call i32 @puts(ptr %54)
  %widen136 = sext i32 %56 to i64
  %57 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr137 = getelementptr inbounds nuw %Outer, ptr %57, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr137, align 8
  %pay_ptr138 = getelementptr inbounds nuw %Outer, ptr %57, i32 0, i32 1
  %58 = call ptr @avra_rc_alloc(i64 8)
  store ptr %58, ptr %pay_ptr138, align 8
  %59 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr139 = getelementptr inbounds nuw %Inner, ptr %59, i32 0, i32 0
  store i64 177639, ptr %tag_ptr139, align 8
  %pay_ptr140 = getelementptr inbounds nuw %Inner, ptr %59, i32 0, i32 1
  %60 = call ptr @avra_rc_alloc(i64 8)
  store ptr %60, ptr %pay_ptr140, align 8
  %slot_base141 = ptrtoint ptr %60 to i64
  %slot_addr142 = add i64 %slot_base141, 0
  %slot143 = inttoptr i64 %slot_addr142 to ptr
  store ptr @.str.24, ptr %slot143, align 8
  %cast144 = ptrtoint ptr %59 to i64
  %slot_base145 = ptrtoint ptr %58 to i64
  %slot_addr146 = add i64 %slot_base145, 0
  %slot147 = inttoptr i64 %slot_addr146 to ptr
  %cast148 = inttoptr i64 %cast144 to ptr
  store ptr %cast148, ptr %slot147, align 8
  %cast149 = ptrtoint ptr %57 to i64
  %cast150 = inttoptr i64 %cast149 to ptr
  %61 = call i64 @classify(ptr %cast150)
  %62 = call ptr @avra_rc_alloc(i64 32)
  %63 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %62, i64 32, ptr @.i2s_fmt.25, i64 %61)
  %widen151 = sext i32 %63 to i64
  %64 = call i32 @puts(ptr %62)
  %widen152 = sext i32 %64 to i64
  %65 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr153 = getelementptr inbounds nuw %Outer, ptr %65, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr153, align 8
  %pay_ptr154 = getelementptr inbounds nuw %Outer, ptr %65, i32 0, i32 1
  store ptr null, ptr %pay_ptr154, align 8
  %cast155 = ptrtoint ptr %65 to i64
  %cast156 = inttoptr i64 %cast155 to ptr
  %66 = call i64 @classify(ptr %cast156)
  %67 = call ptr @avra_rc_alloc(i64 32)
  %68 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %67, i64 32, ptr @.i2s_fmt.26, i64 %66)
  %widen157 = sext i32 %68 to i64
  %69 = call i32 @puts(ptr %67)
  %widen158 = sext i32 %69 to i64
  %70 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr159 = getelementptr inbounds nuw %Outer, ptr %70, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr159, align 8
  %pay_ptr160 = getelementptr inbounds nuw %Outer, ptr %70, i32 0, i32 1
  %71 = call ptr @avra_rc_alloc(i64 8)
  store ptr %71, ptr %pay_ptr160, align 8
  %72 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr161 = getelementptr inbounds nuw %Inner, ptr %72, i32 0, i32 0
  store i64 177638, ptr %tag_ptr161, align 8
  %pay_ptr162 = getelementptr inbounds nuw %Inner, ptr %72, i32 0, i32 1
  %73 = call ptr @avra_rc_alloc(i64 8)
  store ptr %73, ptr %pay_ptr162, align 8
  %slot_base163 = ptrtoint ptr %73 to i64
  %slot_addr164 = add i64 %slot_base163, 0
  %slot165 = inttoptr i64 %slot_addr164 to ptr
  store i64 1, ptr %slot165, align 8
  %cast166 = ptrtoint ptr %72 to i64
  %slot_base167 = ptrtoint ptr %71 to i64
  %slot_addr168 = add i64 %slot_base167, 0
  %slot169 = inttoptr i64 %slot_addr168 to ptr
  %cast170 = inttoptr i64 %cast166 to ptr
  store ptr %cast170, ptr %slot169, align 8
  %cast171 = ptrtoint ptr %70 to i64
  %cast172 = inttoptr i64 %cast171 to ptr
  %74 = call i1 @is_wrap_a(ptr %cast172)
  %widen173 = zext i1 %74 to i64
  %75 = call ptr @avra_rc_alloc(i64 32)
  %76 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %75, i64 32, ptr @.i2s_fmt.27, i64 %widen173)
  %widen174 = sext i32 %76 to i64
  %77 = call i32 @puts(ptr %75)
  %widen175 = sext i32 %77 to i64
  %78 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr176 = getelementptr inbounds nuw %Outer, ptr %78, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr176, align 8
  %pay_ptr177 = getelementptr inbounds nuw %Outer, ptr %78, i32 0, i32 1
  store ptr null, ptr %pay_ptr177, align 8
  %cast178 = ptrtoint ptr %78 to i64
  %cast179 = inttoptr i64 %cast178 to ptr
  %79 = call i1 @is_wrap_a(ptr %cast179)
  %widen180 = zext i1 %79 to i64
  %80 = call ptr @avra_rc_alloc(i64 32)
  %81 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %80, i64 32, ptr @.i2s_fmt.28, i64 %widen180)
  %widen181 = sext i32 %81 to i64
  %82 = call i32 @puts(ptr %80)
  %widen182 = sext i32 %82 to i64
  %83 = call ptr @avra_array_new()
  %84 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr183 = getelementptr inbounds nuw %Outer, ptr %84, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr183, align 8
  %pay_ptr184 = getelementptr inbounds nuw %Outer, ptr %84, i32 0, i32 1
  %85 = call ptr @avra_rc_alloc(i64 8)
  store ptr %85, ptr %pay_ptr184, align 8
  %86 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr185 = getelementptr inbounds nuw %Inner, ptr %86, i32 0, i32 0
  store i64 177638, ptr %tag_ptr185, align 8
  %pay_ptr186 = getelementptr inbounds nuw %Inner, ptr %86, i32 0, i32 1
  %87 = call ptr @avra_rc_alloc(i64 8)
  store ptr %87, ptr %pay_ptr186, align 8
  %slot_base187 = ptrtoint ptr %87 to i64
  %slot_addr188 = add i64 %slot_base187, 0
  %slot189 = inttoptr i64 %slot_addr188 to ptr
  store i64 10, ptr %slot189, align 8
  %cast190 = ptrtoint ptr %86 to i64
  %slot_base191 = ptrtoint ptr %85 to i64
  %slot_addr192 = add i64 %slot_base191, 0
  %slot193 = inttoptr i64 %slot_addr192 to ptr
  %cast194 = inttoptr i64 %cast190 to ptr
  store ptr %cast194, ptr %slot193, align 8
  %cast195 = ptrtoint ptr %84 to i64
  call void @avra_array_push(ptr %83, i64 %cast195)
  %88 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr196 = getelementptr inbounds nuw %Outer, ptr %88, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr196, align 8
  %pay_ptr197 = getelementptr inbounds nuw %Outer, ptr %88, i32 0, i32 1
  store ptr null, ptr %pay_ptr197, align 8
  %cast198 = ptrtoint ptr %88 to i64
  call void @avra_array_push(ptr %83, i64 %cast198)
  %89 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr199 = getelementptr inbounds nuw %Outer, ptr %89, i32 0, i32 0
  store i64 6384694879, ptr %tag_ptr199, align 8
  %pay_ptr200 = getelementptr inbounds nuw %Outer, ptr %89, i32 0, i32 1
  %90 = call ptr @avra_rc_alloc(i64 8)
  store ptr %90, ptr %pay_ptr200, align 8
  %91 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr201 = getelementptr inbounds nuw %Inner, ptr %91, i32 0, i32 0
  store i64 177638, ptr %tag_ptr201, align 8
  %pay_ptr202 = getelementptr inbounds nuw %Inner, ptr %91, i32 0, i32 1
  %92 = call ptr @avra_rc_alloc(i64 8)
  store ptr %92, ptr %pay_ptr202, align 8
  %slot_base203 = ptrtoint ptr %92 to i64
  %slot_addr204 = add i64 %slot_base203, 0
  %slot205 = inttoptr i64 %slot_addr204 to ptr
  store i64 20, ptr %slot205, align 8
  %cast206 = ptrtoint ptr %91 to i64
  %slot_base207 = ptrtoint ptr %90 to i64
  %slot_addr208 = add i64 %slot_base207, 0
  %slot209 = inttoptr i64 %slot_addr208 to ptr
  %cast210 = inttoptr i64 %cast206 to ptr
  store ptr %cast210, ptr %slot209, align 8
  %cast211 = ptrtoint ptr %89 to i64
  call void @avra_array_push(ptr %83, i64 %cast211)
  store ptr %83, ptr %items, align 8
  %items212 = load ptr, ptr %items, align 8
  %93 = call i64 @avra_array_len(ptr %items212)
  store i64 0, ptr %i, align 8
  store i64 %93, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i213 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i213, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %items214 = load ptr, ptr %items, align 8
  %i215 = load i64, ptr %i, align 8
  %94 = call i64 @avra_array_get(ptr %items214, i64 %i215)
  %cast216 = inttoptr i64 %94 to ptr
  %cast217 = inttoptr i64 %94 to ptr
  %tag_ptr218 = getelementptr inbounds nuw %Outer, ptr %cast217, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr218, align 8
  %tag_eq = icmp eq i64 %tag, 6384694879
  br i1 %tag_eq, label %march_arm, label %march_next

for.incr:                                         ; preds = %match_end
  %i230 = load i64, ptr %i, align 8
  %for_next = add i64 %i230, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  ret i64 0

match_end:                                        ; preds = %march_arm227, %inner_pass
  br label %for.incr

march_arm:                                        ; preds = %for.body
  %pay_slot = getelementptr inbounds nuw %Outer, ptr %cast216, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %inner_i64_slot_base = ptrtoint ptr %payload to i64
  %inner_i64_slot_addr = add i64 %inner_i64_slot_base, 0
  %inner_i64_slot = inttoptr i64 %inner_i64_slot_addr to ptr
  %inner_i64 = load ptr, ptr %inner_i64_slot, align 8
  %inner_tag_ptr = getelementptr inbounds nuw %Inner, ptr %inner_i64, i32 0, i32 0
  %inner_tag = load i64, ptr %inner_tag_ptr, align 8
  %inner_tag_eq = icmp eq i64 %inner_tag, 177638
  br i1 %inner_tag_eq, label %inner_pass, label %march_next

march_next:                                       ; preds = %march_arm, %for.body
  br label %march_arm227

inner_pass:                                       ; preds = %march_arm
  %pay_slot219 = getelementptr inbounds nuw %Outer, ptr %cast216, i32 0, i32 1
  %payload220 = load ptr, ptr %pay_slot219, align 8
  %npat_val_slot_base = ptrtoint ptr %payload220 to i64
  %npat_val_slot_addr = add i64 %npat_val_slot_base, 0
  %npat_val_slot = inttoptr i64 %npat_val_slot_addr to ptr
  %npat_val = load ptr, ptr %npat_val_slot, align 8
  %pay_slot221 = getelementptr inbounds nuw %Inner, ptr %npat_val, i32 0, i32 1
  %payload222 = load ptr, ptr %pay_slot221, align 8
  %x_slot_base = ptrtoint ptr %payload222 to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x223, align 8
  %x224 = load i64, ptr %x223, align 8
  %95 = call ptr @avra_rc_alloc(i64 32)
  %96 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %95, i64 32, ptr @.i2s_fmt.29, i64 %x224)
  %widen225 = sext i32 %96 to i64
  %97 = call i32 @puts(ptr %95)
  %widen226 = sext i32 %97 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_arm227:                                     ; preds = %march_next
  %98 = call i32 @puts(ptr @.str.30)
  %widen229 = sext i32 %98 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next228:                                    ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.31, i64 %tag, ptr @mu_file.32, i64 67)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Outer(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Wrap = icmp eq i64 %tag, 6384694879
  br i1 %is_Wrap, label %rel_Wrap, label %try_next_Wrap

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Pair, %vrel_b_skip, %vrel_inner_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Wrap:                                         ; preds = %do_free
  %vrel_inner_ptr = getelementptr inbounds nuw %Outer__Wrap, ptr %payload, i32 0, i32 0
  %vrel_inner = load ptr, ptr %vrel_inner_ptr, align 8
  %vrel_null_inner = icmp eq ptr %vrel_inner, null
  br i1 %vrel_null_inner, label %vrel_inner_skip, label %vrel_inner_do

try_next_Wrap:                                    ; preds = %do_free
  %is_Pair = icmp eq i64 %tag, 6384425073
  br i1 %is_Pair, label %rel_Pair, label %try_next_Pair

vrel_inner_skip:                                  ; preds = %vrel_inner_do, %rel_Wrap
  br label %fields_done

vrel_inner_do:                                    ; preds = %rel_Wrap
  %2 = call i64 @__release_Inner(ptr %vrel_inner)
  br label %vrel_inner_skip

rel_Pair:                                         ; preds = %try_next_Wrap
  %vrel_a_ptr = getelementptr inbounds nuw %Outer__Pair, ptr %payload, i32 0, i32 0
  %vrel_a = load ptr, ptr %vrel_a_ptr, align 8
  %vrel_null_a = icmp eq ptr %vrel_a, null
  br i1 %vrel_null_a, label %vrel_a_skip, label %vrel_a_do

try_next_Pair:                                    ; preds = %try_next_Wrap
  br label %fields_done

vrel_a_skip:                                      ; preds = %vrel_a_do, %rel_Pair
  %vrel_b_ptr = getelementptr inbounds nuw %Outer__Pair, ptr %payload, i32 0, i32 1
  %vrel_b = load ptr, ptr %vrel_b_ptr, align 8
  %vrel_null_b = icmp eq ptr %vrel_b, null
  br i1 %vrel_null_b, label %vrel_b_skip, label %vrel_b_do

vrel_a_do:                                        ; preds = %rel_Pair
  %3 = call i64 @__release_Inner(ptr %vrel_a)
  br label %vrel_a_skip

vrel_b_skip:                                      ; preds = %vrel_b_do, %vrel_a_skip
  br label %fields_done

vrel_b_do:                                        ; preds = %vrel_a_skip
  %4 = call i64 @__release_Inner(ptr %vrel_b)
  br label %vrel_b_skip
}

define i64 @__release_Inner(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Inner, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Inner, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_B = icmp eq i64 %tag, 177639
  br i1 %is_B, label %rel_B, label %try_next_B

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_B, %vrel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_B:                                            ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %Inner__B, ptr %payload, i32 0, i32 0
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_B:                                       ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_B
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_B
  call void @avra_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}
