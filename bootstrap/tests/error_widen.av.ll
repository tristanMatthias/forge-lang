; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result__string__IoError = type { i64, ptr }
%IoError = type { ptr }
%Result__int__ParseError = type { i64, ptr }
%ParseError = type { ptr }
%"Result__string__IoError|ParseError" = type { i64, ptr }
%__union = type { i64, ptr }
%"Result__int__IoError|ParseError" = type { i64, ptr }
%"Result__int__IoError|ParseError__Err" = type { ptr }
%"Result__string__IoError|ParseError__Ok" = type { ptr }
%"Result__string__IoError|ParseError__Err" = type { ptr }
%Result__int__ParseError__Err = type { ptr }
%Result__string__IoError__Ok = type { ptr }
%Result__string__IoError__Err = type { ptr }

@.str = private unnamed_addr constant [12 x i8] c"missing.txt\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"file not found\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"bad.json\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"bad json\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"ok.txt\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.str.9 = private unnamed_addr constant [11 x i8] c"io error: \00", align 1
@fld_name = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.10 = private unnamed_addr constant [14 x i8] c"parse error: \00", align 1
@fld_name.11 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.12 = private unnamed_addr constant [11 x i8] c"ParseError\00", align 1
@src_file.13 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.14 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.15 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.16 = private unnamed_addr constant [12 x i8] c"missing.txt\00", align 1
@.str.17 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.str.18 = private unnamed_addr constant [11 x i8] c"io error: \00", align 1
@fld_name.19 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.20 = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file.21 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.22 = private unnamed_addr constant [14 x i8] c"parse error: \00", align 1
@fld_name.23 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.24 = private unnamed_addr constant [11 x i8] c"ParseError\00", align 1
@src_file.25 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.26 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.27 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.28 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.29 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.30 = private unnamed_addr constant [9 x i8] c"bad.json\00", align 1
@.str.31 = private unnamed_addr constant [12 x i8] c"ok nested: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.32 = private unnamed_addr constant [11 x i8] c"io error: \00", align 1
@fld_name.33 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.34 = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file.35 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.36 = private unnamed_addr constant [14 x i8] c"parse error: \00", align 1
@fld_name.37 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.38 = private unnamed_addr constant [11 x i8] c"ParseError\00", align 1
@src_file.39 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.40 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.41 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.42 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.43 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.44 = private unnamed_addr constant [7 x i8] c"ok.txt\00", align 1
@.str.45 = private unnamed_addr constant [12 x i8] c"ok nested: \00", align 1
@.i2s_fmt.46 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.47 = private unnamed_addr constant [11 x i8] c"io error: \00", align 1
@fld_name.48 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.49 = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file.50 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.51 = private unnamed_addr constant [14 x i8] c"parse error: \00", align 1
@fld_name.52 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.53 = private unnamed_addr constant [11 x i8] c"ParseError\00", align 1
@src_file.54 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.55 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.56 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.57 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.58 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.59 = private unnamed_addr constant [12 x i8] c"missing.txt\00", align 1
@.str.60 = private unnamed_addr constant [12 x i8] c"ok nested: \00", align 1
@.i2s_fmt.61 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.62 = private unnamed_addr constant [11 x i8] c"io error: \00", align 1
@fld_name.63 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.64 = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file.65 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.str.66 = private unnamed_addr constant [14 x i8] c"parse error: \00", align 1
@fld_name.67 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.68 = private unnamed_addr constant [11 x i8] c"ParseError\00", align 1
@src_file.69 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.70 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.71 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1
@.match_fn.72 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.73 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_widen.av\00", align 1

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

define ptr @read_file(ptr %0) {
entry:
  %path = alloca ptr, align 8
  store ptr %0, ptr %path, align 8
  %path1 = load ptr, ptr %path, align 8
  %1 = call i32 @strcmp(ptr %path1, ptr @.str)
  %widen = sext i32 %1 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %path5 = load ptr, ptr %path, align 8
  %2 = call i32 @strcmp(ptr %path5, ptr @.str.2)
  %widen6 = sext i32 %2 to i64
  %streq_cmp7 = icmp eq i64 %widen6, 0
  %streq_ext8 = zext i1 %streq_cmp7 to i64
  %if_cond10 = icmp ne i64 %streq_ext8, 0
  br i1 %if_cond10, label %if_then11, label %if_else12

if_then:                                          ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__string__IoError, ptr %3, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__IoError, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %5 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %IoError, ptr %5, i32 0, i32 0
  store ptr @.str.1, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %slot, align 8
  %cast3 = ptrtoint ptr %3 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  ret ptr %cast4

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont9:                                          ; preds = %if_else12
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr20 = getelementptr inbounds nuw %Result__string__IoError, ptr %6, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr20, align 8
  %pay_ptr21 = getelementptr inbounds nuw %Result__string__IoError, ptr %6, i32 0, i32 1
  %7 = call ptr @avra_rc_alloc(i64 8)
  store ptr %7, ptr %pay_ptr21, align 8
  %slot_base22 = ptrtoint ptr %7 to i64
  %slot_addr23 = add i64 %slot_base22, 0
  %slot24 = inttoptr i64 %slot_addr23 to ptr
  store ptr @.str.4, ptr %slot24, align 8
  %cast25 = ptrtoint ptr %6 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__string__IoError, ptr %cast26, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then11:                                        ; preds = %ifcont
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr13 = getelementptr inbounds nuw %Result__string__IoError, ptr %8, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr13, align 8
  %pay_ptr14 = getelementptr inbounds nuw %Result__string__IoError, ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 8)
  store ptr %9, ptr %pay_ptr14, align 8
  %slot_base15 = ptrtoint ptr %9 to i64
  %slot_addr16 = add i64 %slot_base15, 0
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  store ptr @.str.3, ptr %slot17, align 8
  %cast18 = ptrtoint ptr %8 to i64
  %cast19 = inttoptr i64 %cast18 to ptr
  ret ptr %cast19

if_else12:                                        ; preds = %ifcont
  br label %ifcont9

errdefer_path:                                    ; preds = %ifcont9
  br label %defer_done

defer_path:                                       ; preds = %ifcont9
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast27 = inttoptr i64 %cast25 to ptr
  ret ptr %cast27
}

define ptr @parse_json(ptr %0) {
entry:
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  %text1 = load ptr, ptr %text, align 8
  %1 = call i32 @strcmp(ptr %text1, ptr @.str.5)
  %widen = sext i32 %1 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr5 = getelementptr inbounds nuw %Result__int__ParseError, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr5, align 8
  %pay_ptr6 = getelementptr inbounds nuw %Result__int__ParseError, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr6, align 8
  %slot_base7 = ptrtoint ptr %3 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 42, ptr %slot9, align 8
  %cast10 = ptrtoint ptr %2 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__int__ParseError, ptr %cast11, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__int__ParseError, ptr %4, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__ParseError, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr, align 8
  %6 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %ParseError, ptr %6, i32 0, i32 0
  store ptr @.str.6, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %6 to i64
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %slot, align 8
  %cast3 = ptrtoint ptr %4 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  ret ptr %cast4

if_else:                                          ; preds = %entry
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast12 = inttoptr i64 %cast10 to ptr
  ret ptr %cast12
}

define ptr @load_config(ptr %0) {
entry:
  %text = alloca ptr, align 8
  %path = alloca ptr, align 8
  store ptr %0, ptr %path, align 8
  %path1 = load ptr, ptr %path, align 8
  %1 = call ptr @read_file(ptr %path1)
  %try_tag_ptr = getelementptr inbounds nuw %Result__string__IoError, ptr %1, i32 0, i32 0
  %try_tag = load i64, ptr %try_tag_ptr, align 8
  %try_is_ok = icmp eq i64 %try_tag, 5862623
  br i1 %try_is_ok, label %try_ok, label %try_err

try_ok:                                           ; preds = %entry
  %try_pay_slot = getelementptr inbounds nuw %Result__string__IoError, ptr %1, i32 0, i32 1
  %try_payload = load ptr, ptr %try_pay_slot, align 8
  %try_ok_val = load i64, ptr %try_payload, align 8
  %try_ok_ptr = inttoptr i64 %try_ok_val to ptr
  call void @avra_rc_retain(ptr %try_ok_ptr)
  %cast9 = inttoptr i64 %try_ok_val to ptr
  store ptr %cast9, ptr %text, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %text10 = load ptr, ptr %text, align 8
  %slot_base11 = ptrtoint ptr %3 to i64
  %slot_addr12 = add i64 %slot_base11, 0
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store ptr %text10, ptr %slot13, align 8
  %cast14 = ptrtoint ptr %2 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %cast15, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

try_err:                                          ; preds = %entry
  %try_widen_pay_slot = getelementptr inbounds nuw %Result__string__IoError, ptr %1, i32 0, i32 1
  %try_widen_payload = load ptr, ptr %try_widen_pay_slot, align 8
  %try_err_val = load i64, ptr %try_widen_payload, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %4, i32 0, i32 0
  store i64 229428548902887, ptr %union_tag_ptr, align 8
  %5 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast = inttoptr i64 %try_err_val to ptr
  store ptr %cast, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %4, i32 0, i32 1
  store ptr %5, ptr %union_pay_ptr, align 8
  %cast2 = ptrtoint ptr %4 to i64
  %6 = call ptr @avra_rc_alloc(i64 16)
  %try_widen_tag = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %6, i32 0, i32 0
  store i64 193456014, ptr %try_widen_tag, align 8
  %7 = call ptr @avra_rc_alloc(i64 8)
  %slot_base3 = ptrtoint ptr %7 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  %cast6 = inttoptr i64 %cast2 to ptr
  store ptr %cast6, ptr %slot5, align 8
  %try_widen_pay = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %6, i32 0, i32 1
  store ptr %7, ptr %try_widen_pay, align 8
  %cast7 = ptrtoint ptr %6 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  ret ptr %cast8

errdefer_path:                                    ; preds = %try_ok
  br label %defer_done

defer_path:                                       ; preds = %try_ok
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast16 = inttoptr i64 %cast14 to ptr
  ret ptr %cast16
}

define ptr @load_and_parse(ptr %0) {
entry:
  %val = alloca i64, align 8
  %text = alloca ptr, align 8
  %path = alloca ptr, align 8
  store ptr %0, ptr %path, align 8
  %path1 = load ptr, ptr %path, align 8
  %1 = call ptr @read_file(ptr %path1)
  %try_tag_ptr = getelementptr inbounds nuw %Result__string__IoError, ptr %1, i32 0, i32 0
  %try_tag = load i64, ptr %try_tag_ptr, align 8
  %try_is_ok = icmp eq i64 %try_tag, 5862623
  br i1 %try_is_ok, label %try_ok, label %try_err

try_ok:                                           ; preds = %entry
  %try_pay_slot = getelementptr inbounds nuw %Result__string__IoError, ptr %1, i32 0, i32 1
  %try_payload = load ptr, ptr %try_pay_slot, align 8
  %try_ok_val = load i64, ptr %try_payload, align 8
  %try_ok_ptr = inttoptr i64 %try_ok_val to ptr
  call void @avra_rc_retain(ptr %try_ok_ptr)
  %cast9 = inttoptr i64 %try_ok_val to ptr
  store ptr %cast9, ptr %text, align 8
  %text10 = load ptr, ptr %text, align 8
  %2 = call ptr @parse_json(ptr %text10)
  %try_tag_ptr11 = getelementptr inbounds nuw %Result__int__ParseError, ptr %2, i32 0, i32 0
  %try_tag12 = load i64, ptr %try_tag_ptr11, align 8
  %try_is_ok13 = icmp eq i64 %try_tag12, 5862623
  br i1 %try_is_ok13, label %try_ok14, label %try_err15

try_err:                                          ; preds = %entry
  %try_widen_pay_slot = getelementptr inbounds nuw %Result__string__IoError, ptr %1, i32 0, i32 1
  %try_widen_payload = load ptr, ptr %try_widen_pay_slot, align 8
  %try_err_val = load i64, ptr %try_widen_payload, align 8
  %3 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %3, i32 0, i32 0
  store i64 229428548902887, ptr %union_tag_ptr, align 8
  %4 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast = inttoptr i64 %try_err_val to ptr
  store ptr %cast, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %3, i32 0, i32 1
  store ptr %4, ptr %union_pay_ptr, align 8
  %cast2 = ptrtoint ptr %3 to i64
  %5 = call ptr @avra_rc_alloc(i64 16)
  %try_widen_tag = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %5, i32 0, i32 0
  store i64 193456014, ptr %try_widen_tag, align 8
  %6 = call ptr @avra_rc_alloc(i64 8)
  %slot_base3 = ptrtoint ptr %6 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  %cast6 = inttoptr i64 %cast2 to ptr
  store ptr %cast6, ptr %slot5, align 8
  %try_widen_pay = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %5, i32 0, i32 1
  store ptr %6, ptr %try_widen_pay, align 8
  %cast7 = ptrtoint ptr %5 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  ret ptr %cast8

try_ok14:                                         ; preds = %try_ok
  %try_pay_slot34 = getelementptr inbounds nuw %Result__int__ParseError, ptr %2, i32 0, i32 1
  %try_payload35 = load ptr, ptr %try_pay_slot34, align 8
  %try_ok_val36 = load i64, ptr %try_payload35, align 8
  store i64 %try_ok_val36, ptr %val, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %7, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %7, i32 0, i32 1
  %8 = call ptr @avra_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr, align 8
  %val37 = load i64, ptr %val, align 8
  %slot_base38 = ptrtoint ptr %8 to i64
  %slot_addr39 = add i64 %slot_base38, 0
  %slot40 = inttoptr i64 %slot_addr39 to ptr
  store i64 %val37, ptr %slot40, align 8
  %cast41 = ptrtoint ptr %7 to i64
  %cast42 = inttoptr i64 %cast41 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %cast42, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

try_err15:                                        ; preds = %try_ok
  %try_widen_pay_slot16 = getelementptr inbounds nuw %Result__int__ParseError, ptr %2, i32 0, i32 1
  %try_widen_payload17 = load ptr, ptr %try_widen_pay_slot16, align 8
  %try_err_val18 = load i64, ptr %try_widen_payload17, align 8
  %9 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr19 = getelementptr inbounds nuw %__union, ptr %9, i32 0, i32 0
  store i64 8245280871156169482, ptr %union_tag_ptr19, align 8
  %10 = call ptr @avra_rc_alloc(i64 8)
  %slot_base20 = ptrtoint ptr %10 to i64
  %slot_addr21 = add i64 %slot_base20, 0
  %slot22 = inttoptr i64 %slot_addr21 to ptr
  %cast23 = inttoptr i64 %try_err_val18 to ptr
  store ptr %cast23, ptr %slot22, align 8
  %union_pay_ptr24 = getelementptr inbounds nuw %__union, ptr %9, i32 0, i32 1
  store ptr %10, ptr %union_pay_ptr24, align 8
  %cast25 = ptrtoint ptr %9 to i64
  %11 = call ptr @avra_rc_alloc(i64 16)
  %try_widen_tag26 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %11, i32 0, i32 0
  store i64 193456014, ptr %try_widen_tag26, align 8
  %12 = call ptr @avra_rc_alloc(i64 8)
  %slot_base27 = ptrtoint ptr %12 to i64
  %slot_addr28 = add i64 %slot_base27, 0
  %slot29 = inttoptr i64 %slot_addr28 to ptr
  %cast30 = inttoptr i64 %cast25 to ptr
  store ptr %cast30, ptr %slot29, align 8
  %try_widen_pay31 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %11, i32 0, i32 1
  store ptr %12, ptr %try_widen_pay31, align 8
  %cast32 = ptrtoint ptr %11 to i64
  %cast33 = inttoptr i64 %cast32 to ptr
  ret ptr %cast33

errdefer_path:                                    ; preds = %try_ok14
  br label %defer_done

defer_path:                                       ; preds = %try_ok14
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast43 = inttoptr i64 %cast41 to ptr
  ret ptr %cast43
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %pe365 = alloca ptr, align 8
  %ie342 = alloca ptr, align 8
  %union_match_result331 = alloca i64, align 8
  %e327 = alloca ptr, align 8
  %v308 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %pe281 = alloca ptr, align 8
  %ie258 = alloca ptr, align 8
  %union_match_result247 = alloca i64, align 8
  %e243 = alloca ptr, align 8
  %v224 = alloca i64, align 8
  %match_stmt_discard214 = alloca i64, align 8
  %pe196 = alloca ptr, align 8
  %ie173 = alloca ptr, align 8
  %union_match_result162 = alloca i64, align 8
  %e158 = alloca ptr, align 8
  %v139 = alloca i64, align 8
  %match_stmt_discard129 = alloca i64, align 8
  %pe111 = alloca ptr, align 8
  %ie88 = alloca ptr, align 8
  %union_match_result77 = alloca i64, align 8
  %e73 = alloca ptr, align 8
  %v55 = alloca ptr, align 8
  %match_stmt_discard45 = alloca i64, align 8
  %pe = alloca ptr, align 8
  %ie = alloca ptr, align 8
  %union_match_result = alloca i64, align 8
  %e9 = alloca ptr, align 8
  %v1 = alloca ptr, align 8
  %match_stmt_discard = alloca i64, align 8
  %1 = call ptr @load_config(ptr @.str.7)
  %tag_ptr = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %union_match_end, %march_arm
  %2 = call ptr @load_config(ptr @.str.16)
  %tag_ptr42 = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %2, i32 0, i32 0
  %tag43 = load i64, ptr %tag_ptr42, align 8
  %tag_eq48 = icmp eq i64 %tag43, 5862623
  br i1 %tag_eq48, label %march_arm46, label %march_next47

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @avra_rc_retain(ptr %v)
  store ptr %v, ptr %v1, align 8
  %v2 = load ptr, ptr %v1, align 8
  %3 = call i64 @strlen(ptr @.str.8)
  %4 = call i64 @strlen(ptr %v2)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.8, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast3, ptr %v2, i64 %rhs_len_p1)
  %8 = call i32 @puts(ptr %5)
  %widen = sext i32 %8 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %e_slot_base = ptrtoint ptr %payload8 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e)
  store ptr %e, ptr %e9, align 8
  %e10 = load ptr, ptr %e9, align 8
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %e10, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 229428548902887
  br i1 %union_tag_eq, label %union_arm, label %union_next

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.14, i64 %tag, ptr @mu_file.15, i64 47)
  unreachable

union_match_end:                                  ; preds = %union_arm20, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  store i64 %union_match_val, ptr %match_stmt_discard, align 8
  br label %match_end

union_arm:                                        ; preds = %march_arm4
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %e10, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load ptr, ptr %union_val_slot, align 8
  store ptr %union_val, ptr %ie, align 8
  %ie11 = load ptr, ptr %ie, align 8
  %cast12 = ptrtoint ptr %ie11 to i64
  %null_chk = icmp eq i64 %cast12, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 7, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 97, i64 47)
  %message_ptr = getelementptr inbounds nuw %IoError, ptr %ie11, i32 0, i32 0
  %message = load ptr, ptr %message_ptr, align 8
  %9 = call i64 @strlen(ptr @.str.9)
  %10 = call i64 @strlen(ptr %message)
  %concat_total13 = add i64 %9, %10
  %concat_size14 = add i64 %concat_total13, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %12 = call ptr @memcpy(ptr %11, ptr @.str.9, i64 %9)
  %cast15 = ptrtoint ptr %11 to i64
  %dst2_int16 = add i64 %cast15, %9
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast17, ptr %message, i64 %rhs_len_p118)
  %14 = call i32 @puts(ptr %11)
  %widen19 = sext i32 %14 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %march_arm4
  %union_tag_eq22 = icmp eq i64 %union_tag, 8245280871156169482
  br i1 %union_tag_eq22, label %union_arm20, label %union_next21

union_arm20:                                      ; preds = %union_next
  %union_pay_ptr23 = getelementptr inbounds nuw %__union, ptr %e10, i32 0, i32 1
  %union_payload24 = load ptr, ptr %union_pay_ptr23, align 8
  %union_val_slot_base25 = ptrtoint ptr %union_payload24 to i64
  %union_val_slot_addr26 = add i64 %union_val_slot_base25, 0
  %union_val_slot27 = inttoptr i64 %union_val_slot_addr26 to ptr
  %union_val28 = load ptr, ptr %union_val_slot27, align 8
  store ptr %union_val28, ptr %pe, align 8
  %pe29 = load ptr, ptr %pe, align 8
  %cast30 = ptrtoint ptr %pe29 to i64
  %null_chk31 = icmp eq i64 %cast30, 0
  %null_ext32 = zext i1 %null_chk31 to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 7, ptr @sty_name.12, i64 10, i64 %null_ext32, ptr @src_file.13, i64 97, i64 47)
  %message_ptr33 = getelementptr inbounds nuw %ParseError, ptr %pe29, i32 0, i32 0
  %message34 = load ptr, ptr %message_ptr33, align 8
  %15 = call i64 @strlen(ptr @.str.10)
  %16 = call i64 @strlen(ptr %message34)
  %concat_total35 = add i64 %15, %16
  %concat_size36 = add i64 %concat_total35, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size36)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.10, i64 %15)
  %cast37 = ptrtoint ptr %17 to i64
  %dst2_int38 = add i64 %cast37, %15
  %cast39 = inttoptr i64 %dst2_int38 to ptr
  %rhs_len_p140 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast39, ptr %message34, i64 %rhs_len_p140)
  %20 = call i32 @puts(ptr %17)
  %widen41 = sext i32 %20 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next21:                                     ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 47)
  unreachable

match_end44:                                      ; preds = %union_match_end78, %march_arm46
  %21 = call ptr @load_and_parse(ptr @.str.30)
  %tag_ptr126 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %21, i32 0, i32 0
  %tag127 = load i64, ptr %tag_ptr126, align 8
  %tag_eq132 = icmp eq i64 %tag127, 5862623
  br i1 %tag_eq132, label %march_arm130, label %march_next131

march_arm46:                                      ; preds = %match_end
  %pay_slot49 = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %2, i32 0, i32 1
  %payload50 = load ptr, ptr %pay_slot49, align 8
  %v_slot_base51 = ptrtoint ptr %payload50 to i64
  %v_slot_addr52 = add i64 %v_slot_base51, 0
  %v_slot53 = inttoptr i64 %v_slot_addr52 to ptr
  %v54 = load ptr, ptr %v_slot53, align 8
  call void @avra_rc_retain(ptr %v54)
  store ptr %v54, ptr %v55, align 8
  %v56 = load ptr, ptr %v55, align 8
  %22 = call i64 @strlen(ptr @.str.17)
  %23 = call i64 @strlen(ptr %v56)
  %concat_total57 = add i64 %22, %23
  %concat_size58 = add i64 %concat_total57, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size58)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.17, i64 %22)
  %cast59 = ptrtoint ptr %24 to i64
  %dst2_int60 = add i64 %cast59, %22
  %cast61 = inttoptr i64 %dst2_int60 to ptr
  %rhs_len_p162 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast61, ptr %v56, i64 %rhs_len_p162)
  %27 = call i32 @puts(ptr %24)
  %widen63 = sext i32 %27 to i64
  store i64 0, ptr %match_stmt_discard45, align 8
  br label %match_end44

march_next47:                                     ; preds = %match_end
  %tag_eq66 = icmp eq i64 %tag43, 193456014
  br i1 %tag_eq66, label %march_arm64, label %march_next65

march_arm64:                                      ; preds = %march_next47
  %pay_slot67 = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %2, i32 0, i32 1
  %payload68 = load ptr, ptr %pay_slot67, align 8
  %e_slot_base69 = ptrtoint ptr %payload68 to i64
  %e_slot_addr70 = add i64 %e_slot_base69, 0
  %e_slot71 = inttoptr i64 %e_slot_addr70 to ptr
  %e72 = load ptr, ptr %e_slot71, align 8
  call void @avra_rc_retain(ptr %e72)
  store ptr %e72, ptr %e73, align 8
  %e74 = load ptr, ptr %e73, align 8
  %union_tag_ptr75 = getelementptr inbounds nuw %__union, ptr %e74, i32 0, i32 0
  %union_tag76 = load i64, ptr %union_tag_ptr75, align 8
  store i64 0, ptr %union_match_result77, align 8
  %union_tag_eq81 = icmp eq i64 %union_tag76, 229428548902887
  br i1 %union_tag_eq81, label %union_arm79, label %union_next80

march_next65:                                     ; preds = %march_next47
  call void @avra_match_unreachable(ptr @.match_fn.28, i64 %tag43, ptr @mu_file.29, i64 55)
  unreachable

union_match_end78:                                ; preds = %union_arm102, %union_arm79
  %union_match_val125 = load i64, ptr %union_match_result77, align 8
  store i64 %union_match_val125, ptr %match_stmt_discard45, align 8
  br label %match_end44

union_arm79:                                      ; preds = %march_arm64
  %union_pay_ptr82 = getelementptr inbounds nuw %__union, ptr %e74, i32 0, i32 1
  %union_payload83 = load ptr, ptr %union_pay_ptr82, align 8
  %union_val_slot_base84 = ptrtoint ptr %union_payload83 to i64
  %union_val_slot_addr85 = add i64 %union_val_slot_base84, 0
  %union_val_slot86 = inttoptr i64 %union_val_slot_addr85 to ptr
  %union_val87 = load ptr, ptr %union_val_slot86, align 8
  store ptr %union_val87, ptr %ie88, align 8
  %ie89 = load ptr, ptr %ie88, align 8
  %cast90 = ptrtoint ptr %ie89 to i64
  %null_chk91 = icmp eq i64 %cast90, 0
  %null_ext92 = zext i1 %null_chk91 to i64
  call void @avra_null_deref_trap(ptr @fld_name.19, i64 7, ptr @sty_name.20, i64 7, i64 %null_ext92, ptr @src_file.21, i64 97, i64 55)
  %message_ptr93 = getelementptr inbounds nuw %IoError, ptr %ie89, i32 0, i32 0
  %message94 = load ptr, ptr %message_ptr93, align 8
  %28 = call i64 @strlen(ptr @.str.18)
  %29 = call i64 @strlen(ptr %message94)
  %concat_total95 = add i64 %28, %29
  %concat_size96 = add i64 %concat_total95, 1
  %30 = call ptr @avra_rc_alloc(i64 %concat_size96)
  %31 = call ptr @memcpy(ptr %30, ptr @.str.18, i64 %28)
  %cast97 = ptrtoint ptr %30 to i64
  %dst2_int98 = add i64 %cast97, %28
  %cast99 = inttoptr i64 %dst2_int98 to ptr
  %rhs_len_p1100 = add i64 %29, 1
  %32 = call ptr @memcpy(ptr %cast99, ptr %message94, i64 %rhs_len_p1100)
  %33 = call i32 @puts(ptr %30)
  %widen101 = sext i32 %33 to i64
  store i64 0, ptr %union_match_result77, align 8
  br label %union_match_end78

union_next80:                                     ; preds = %march_arm64
  %union_tag_eq104 = icmp eq i64 %union_tag76, 8245280871156169482
  br i1 %union_tag_eq104, label %union_arm102, label %union_next103

union_arm102:                                     ; preds = %union_next80
  %union_pay_ptr105 = getelementptr inbounds nuw %__union, ptr %e74, i32 0, i32 1
  %union_payload106 = load ptr, ptr %union_pay_ptr105, align 8
  %union_val_slot_base107 = ptrtoint ptr %union_payload106 to i64
  %union_val_slot_addr108 = add i64 %union_val_slot_base107, 0
  %union_val_slot109 = inttoptr i64 %union_val_slot_addr108 to ptr
  %union_val110 = load ptr, ptr %union_val_slot109, align 8
  store ptr %union_val110, ptr %pe111, align 8
  %pe112 = load ptr, ptr %pe111, align 8
  %cast113 = ptrtoint ptr %pe112 to i64
  %null_chk114 = icmp eq i64 %cast113, 0
  %null_ext115 = zext i1 %null_chk114 to i64
  call void @avra_null_deref_trap(ptr @fld_name.23, i64 7, ptr @sty_name.24, i64 10, i64 %null_ext115, ptr @src_file.25, i64 97, i64 55)
  %message_ptr116 = getelementptr inbounds nuw %ParseError, ptr %pe112, i32 0, i32 0
  %message117 = load ptr, ptr %message_ptr116, align 8
  %34 = call i64 @strlen(ptr @.str.22)
  %35 = call i64 @strlen(ptr %message117)
  %concat_total118 = add i64 %34, %35
  %concat_size119 = add i64 %concat_total118, 1
  %36 = call ptr @avra_rc_alloc(i64 %concat_size119)
  %37 = call ptr @memcpy(ptr %36, ptr @.str.22, i64 %34)
  %cast120 = ptrtoint ptr %36 to i64
  %dst2_int121 = add i64 %cast120, %34
  %cast122 = inttoptr i64 %dst2_int121 to ptr
  %rhs_len_p1123 = add i64 %35, 1
  %38 = call ptr @memcpy(ptr %cast122, ptr %message117, i64 %rhs_len_p1123)
  %39 = call i32 @puts(ptr %36)
  %widen124 = sext i32 %39 to i64
  store i64 0, ptr %union_match_result77, align 8
  br label %union_match_end78

union_next103:                                    ; preds = %union_next80
  call void @avra_match_unreachable(ptr @.match_fn.26, i64 %union_tag76, ptr @mu_file.27, i64 55)
  unreachable

match_end128:                                     ; preds = %union_match_end163, %march_arm130
  %40 = call ptr @load_and_parse(ptr @.str.44)
  %tag_ptr211 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %40, i32 0, i32 0
  %tag212 = load i64, ptr %tag_ptr211, align 8
  %tag_eq217 = icmp eq i64 %tag212, 5862623
  br i1 %tag_eq217, label %march_arm215, label %march_next216

march_arm130:                                     ; preds = %match_end44
  %pay_slot133 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %21, i32 0, i32 1
  %payload134 = load ptr, ptr %pay_slot133, align 8
  %v_slot_base135 = ptrtoint ptr %payload134 to i64
  %v_slot_addr136 = add i64 %v_slot_base135, 0
  %v_slot137 = inttoptr i64 %v_slot_addr136 to ptr
  %v138 = load i64, ptr %v_slot137, align 8
  store i64 %v138, ptr %v139, align 8
  %v140 = load i64, ptr %v139, align 8
  %41 = call ptr @avra_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt, i64 %v140)
  %widen141 = sext i32 %42 to i64
  %43 = call i64 @strlen(ptr @.str.31)
  %44 = call i64 @strlen(ptr %41)
  %concat_total142 = add i64 %43, %44
  %concat_size143 = add i64 %concat_total142, 1
  %45 = call ptr @avra_rc_alloc(i64 %concat_size143)
  %46 = call ptr @memcpy(ptr %45, ptr @.str.31, i64 %43)
  %cast144 = ptrtoint ptr %45 to i64
  %dst2_int145 = add i64 %cast144, %43
  %cast146 = inttoptr i64 %dst2_int145 to ptr
  %rhs_len_p1147 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast146, ptr %41, i64 %rhs_len_p1147)
  %48 = call i32 @puts(ptr %45)
  %widen148 = sext i32 %48 to i64
  store i64 0, ptr %match_stmt_discard129, align 8
  br label %match_end128

march_next131:                                    ; preds = %match_end44
  %tag_eq151 = icmp eq i64 %tag127, 193456014
  br i1 %tag_eq151, label %march_arm149, label %march_next150

march_arm149:                                     ; preds = %march_next131
  %pay_slot152 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %21, i32 0, i32 1
  %payload153 = load ptr, ptr %pay_slot152, align 8
  %e_slot_base154 = ptrtoint ptr %payload153 to i64
  %e_slot_addr155 = add i64 %e_slot_base154, 0
  %e_slot156 = inttoptr i64 %e_slot_addr155 to ptr
  %e157 = load ptr, ptr %e_slot156, align 8
  call void @avra_rc_retain(ptr %e157)
  store ptr %e157, ptr %e158, align 8
  %e159 = load ptr, ptr %e158, align 8
  %union_tag_ptr160 = getelementptr inbounds nuw %__union, ptr %e159, i32 0, i32 0
  %union_tag161 = load i64, ptr %union_tag_ptr160, align 8
  store i64 0, ptr %union_match_result162, align 8
  %union_tag_eq166 = icmp eq i64 %union_tag161, 229428548902887
  br i1 %union_tag_eq166, label %union_arm164, label %union_next165

march_next150:                                    ; preds = %march_next131
  call void @avra_match_unreachable(ptr @.match_fn.42, i64 %tag127, ptr @mu_file.43, i64 64)
  unreachable

union_match_end163:                               ; preds = %union_arm187, %union_arm164
  %union_match_val210 = load i64, ptr %union_match_result162, align 8
  store i64 %union_match_val210, ptr %match_stmt_discard129, align 8
  br label %match_end128

union_arm164:                                     ; preds = %march_arm149
  %union_pay_ptr167 = getelementptr inbounds nuw %__union, ptr %e159, i32 0, i32 1
  %union_payload168 = load ptr, ptr %union_pay_ptr167, align 8
  %union_val_slot_base169 = ptrtoint ptr %union_payload168 to i64
  %union_val_slot_addr170 = add i64 %union_val_slot_base169, 0
  %union_val_slot171 = inttoptr i64 %union_val_slot_addr170 to ptr
  %union_val172 = load ptr, ptr %union_val_slot171, align 8
  store ptr %union_val172, ptr %ie173, align 8
  %ie174 = load ptr, ptr %ie173, align 8
  %cast175 = ptrtoint ptr %ie174 to i64
  %null_chk176 = icmp eq i64 %cast175, 0
  %null_ext177 = zext i1 %null_chk176 to i64
  call void @avra_null_deref_trap(ptr @fld_name.33, i64 7, ptr @sty_name.34, i64 7, i64 %null_ext177, ptr @src_file.35, i64 97, i64 64)
  %message_ptr178 = getelementptr inbounds nuw %IoError, ptr %ie174, i32 0, i32 0
  %message179 = load ptr, ptr %message_ptr178, align 8
  %49 = call i64 @strlen(ptr @.str.32)
  %50 = call i64 @strlen(ptr %message179)
  %concat_total180 = add i64 %49, %50
  %concat_size181 = add i64 %concat_total180, 1
  %51 = call ptr @avra_rc_alloc(i64 %concat_size181)
  %52 = call ptr @memcpy(ptr %51, ptr @.str.32, i64 %49)
  %cast182 = ptrtoint ptr %51 to i64
  %dst2_int183 = add i64 %cast182, %49
  %cast184 = inttoptr i64 %dst2_int183 to ptr
  %rhs_len_p1185 = add i64 %50, 1
  %53 = call ptr @memcpy(ptr %cast184, ptr %message179, i64 %rhs_len_p1185)
  %54 = call i32 @puts(ptr %51)
  %widen186 = sext i32 %54 to i64
  store i64 0, ptr %union_match_result162, align 8
  br label %union_match_end163

union_next165:                                    ; preds = %march_arm149
  %union_tag_eq189 = icmp eq i64 %union_tag161, 8245280871156169482
  br i1 %union_tag_eq189, label %union_arm187, label %union_next188

union_arm187:                                     ; preds = %union_next165
  %union_pay_ptr190 = getelementptr inbounds nuw %__union, ptr %e159, i32 0, i32 1
  %union_payload191 = load ptr, ptr %union_pay_ptr190, align 8
  %union_val_slot_base192 = ptrtoint ptr %union_payload191 to i64
  %union_val_slot_addr193 = add i64 %union_val_slot_base192, 0
  %union_val_slot194 = inttoptr i64 %union_val_slot_addr193 to ptr
  %union_val195 = load ptr, ptr %union_val_slot194, align 8
  store ptr %union_val195, ptr %pe196, align 8
  %pe197 = load ptr, ptr %pe196, align 8
  %cast198 = ptrtoint ptr %pe197 to i64
  %null_chk199 = icmp eq i64 %cast198, 0
  %null_ext200 = zext i1 %null_chk199 to i64
  call void @avra_null_deref_trap(ptr @fld_name.37, i64 7, ptr @sty_name.38, i64 10, i64 %null_ext200, ptr @src_file.39, i64 97, i64 64)
  %message_ptr201 = getelementptr inbounds nuw %ParseError, ptr %pe197, i32 0, i32 0
  %message202 = load ptr, ptr %message_ptr201, align 8
  %55 = call i64 @strlen(ptr @.str.36)
  %56 = call i64 @strlen(ptr %message202)
  %concat_total203 = add i64 %55, %56
  %concat_size204 = add i64 %concat_total203, 1
  %57 = call ptr @avra_rc_alloc(i64 %concat_size204)
  %58 = call ptr @memcpy(ptr %57, ptr @.str.36, i64 %55)
  %cast205 = ptrtoint ptr %57 to i64
  %dst2_int206 = add i64 %cast205, %55
  %cast207 = inttoptr i64 %dst2_int206 to ptr
  %rhs_len_p1208 = add i64 %56, 1
  %59 = call ptr @memcpy(ptr %cast207, ptr %message202, i64 %rhs_len_p1208)
  %60 = call i32 @puts(ptr %57)
  %widen209 = sext i32 %60 to i64
  store i64 0, ptr %union_match_result162, align 8
  br label %union_match_end163

union_next188:                                    ; preds = %union_next165
  call void @avra_match_unreachable(ptr @.match_fn.40, i64 %union_tag161, ptr @mu_file.41, i64 64)
  unreachable

match_end213:                                     ; preds = %union_match_end248, %march_arm215
  %61 = call ptr @load_and_parse(ptr @.str.59)
  %tag_ptr296 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %61, i32 0, i32 0
  %tag297 = load i64, ptr %tag_ptr296, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq301 = icmp eq i64 %tag297, 5862623
  br i1 %tag_eq301, label %march_arm299, label %march_next300

march_arm215:                                     ; preds = %match_end128
  %pay_slot218 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %40, i32 0, i32 1
  %payload219 = load ptr, ptr %pay_slot218, align 8
  %v_slot_base220 = ptrtoint ptr %payload219 to i64
  %v_slot_addr221 = add i64 %v_slot_base220, 0
  %v_slot222 = inttoptr i64 %v_slot_addr221 to ptr
  %v223 = load i64, ptr %v_slot222, align 8
  store i64 %v223, ptr %v224, align 8
  %v225 = load i64, ptr %v224, align 8
  %62 = call ptr @avra_rc_alloc(i64 32)
  %63 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %62, i64 32, ptr @.i2s_fmt.46, i64 %v225)
  %widen226 = sext i32 %63 to i64
  %64 = call i64 @strlen(ptr @.str.45)
  %65 = call i64 @strlen(ptr %62)
  %concat_total227 = add i64 %64, %65
  %concat_size228 = add i64 %concat_total227, 1
  %66 = call ptr @avra_rc_alloc(i64 %concat_size228)
  %67 = call ptr @memcpy(ptr %66, ptr @.str.45, i64 %64)
  %cast229 = ptrtoint ptr %66 to i64
  %dst2_int230 = add i64 %cast229, %64
  %cast231 = inttoptr i64 %dst2_int230 to ptr
  %rhs_len_p1232 = add i64 %65, 1
  %68 = call ptr @memcpy(ptr %cast231, ptr %62, i64 %rhs_len_p1232)
  %69 = call i32 @puts(ptr %66)
  %widen233 = sext i32 %69 to i64
  store i64 0, ptr %match_stmt_discard214, align 8
  br label %match_end213

march_next216:                                    ; preds = %match_end128
  %tag_eq236 = icmp eq i64 %tag212, 193456014
  br i1 %tag_eq236, label %march_arm234, label %march_next235

march_arm234:                                     ; preds = %march_next216
  %pay_slot237 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %40, i32 0, i32 1
  %payload238 = load ptr, ptr %pay_slot237, align 8
  %e_slot_base239 = ptrtoint ptr %payload238 to i64
  %e_slot_addr240 = add i64 %e_slot_base239, 0
  %e_slot241 = inttoptr i64 %e_slot_addr240 to ptr
  %e242 = load ptr, ptr %e_slot241, align 8
  call void @avra_rc_retain(ptr %e242)
  store ptr %e242, ptr %e243, align 8
  %e244 = load ptr, ptr %e243, align 8
  %union_tag_ptr245 = getelementptr inbounds nuw %__union, ptr %e244, i32 0, i32 0
  %union_tag246 = load i64, ptr %union_tag_ptr245, align 8
  store i64 0, ptr %union_match_result247, align 8
  %union_tag_eq251 = icmp eq i64 %union_tag246, 229428548902887
  br i1 %union_tag_eq251, label %union_arm249, label %union_next250

march_next235:                                    ; preds = %march_next216
  call void @avra_match_unreachable(ptr @.match_fn.57, i64 %tag212, ptr @mu_file.58, i64 73)
  unreachable

union_match_end248:                               ; preds = %union_arm272, %union_arm249
  %union_match_val295 = load i64, ptr %union_match_result247, align 8
  store i64 %union_match_val295, ptr %match_stmt_discard214, align 8
  br label %match_end213

union_arm249:                                     ; preds = %march_arm234
  %union_pay_ptr252 = getelementptr inbounds nuw %__union, ptr %e244, i32 0, i32 1
  %union_payload253 = load ptr, ptr %union_pay_ptr252, align 8
  %union_val_slot_base254 = ptrtoint ptr %union_payload253 to i64
  %union_val_slot_addr255 = add i64 %union_val_slot_base254, 0
  %union_val_slot256 = inttoptr i64 %union_val_slot_addr255 to ptr
  %union_val257 = load ptr, ptr %union_val_slot256, align 8
  store ptr %union_val257, ptr %ie258, align 8
  %ie259 = load ptr, ptr %ie258, align 8
  %cast260 = ptrtoint ptr %ie259 to i64
  %null_chk261 = icmp eq i64 %cast260, 0
  %null_ext262 = zext i1 %null_chk261 to i64
  call void @avra_null_deref_trap(ptr @fld_name.48, i64 7, ptr @sty_name.49, i64 7, i64 %null_ext262, ptr @src_file.50, i64 97, i64 73)
  %message_ptr263 = getelementptr inbounds nuw %IoError, ptr %ie259, i32 0, i32 0
  %message264 = load ptr, ptr %message_ptr263, align 8
  %70 = call i64 @strlen(ptr @.str.47)
  %71 = call i64 @strlen(ptr %message264)
  %concat_total265 = add i64 %70, %71
  %concat_size266 = add i64 %concat_total265, 1
  %72 = call ptr @avra_rc_alloc(i64 %concat_size266)
  %73 = call ptr @memcpy(ptr %72, ptr @.str.47, i64 %70)
  %cast267 = ptrtoint ptr %72 to i64
  %dst2_int268 = add i64 %cast267, %70
  %cast269 = inttoptr i64 %dst2_int268 to ptr
  %rhs_len_p1270 = add i64 %71, 1
  %74 = call ptr @memcpy(ptr %cast269, ptr %message264, i64 %rhs_len_p1270)
  %75 = call i32 @puts(ptr %72)
  %widen271 = sext i32 %75 to i64
  store i64 0, ptr %union_match_result247, align 8
  br label %union_match_end248

union_next250:                                    ; preds = %march_arm234
  %union_tag_eq274 = icmp eq i64 %union_tag246, 8245280871156169482
  br i1 %union_tag_eq274, label %union_arm272, label %union_next273

union_arm272:                                     ; preds = %union_next250
  %union_pay_ptr275 = getelementptr inbounds nuw %__union, ptr %e244, i32 0, i32 1
  %union_payload276 = load ptr, ptr %union_pay_ptr275, align 8
  %union_val_slot_base277 = ptrtoint ptr %union_payload276 to i64
  %union_val_slot_addr278 = add i64 %union_val_slot_base277, 0
  %union_val_slot279 = inttoptr i64 %union_val_slot_addr278 to ptr
  %union_val280 = load ptr, ptr %union_val_slot279, align 8
  store ptr %union_val280, ptr %pe281, align 8
  %pe282 = load ptr, ptr %pe281, align 8
  %cast283 = ptrtoint ptr %pe282 to i64
  %null_chk284 = icmp eq i64 %cast283, 0
  %null_ext285 = zext i1 %null_chk284 to i64
  call void @avra_null_deref_trap(ptr @fld_name.52, i64 7, ptr @sty_name.53, i64 10, i64 %null_ext285, ptr @src_file.54, i64 97, i64 73)
  %message_ptr286 = getelementptr inbounds nuw %ParseError, ptr %pe282, i32 0, i32 0
  %message287 = load ptr, ptr %message_ptr286, align 8
  %76 = call i64 @strlen(ptr @.str.51)
  %77 = call i64 @strlen(ptr %message287)
  %concat_total288 = add i64 %76, %77
  %concat_size289 = add i64 %concat_total288, 1
  %78 = call ptr @avra_rc_alloc(i64 %concat_size289)
  %79 = call ptr @memcpy(ptr %78, ptr @.str.51, i64 %76)
  %cast290 = ptrtoint ptr %78 to i64
  %dst2_int291 = add i64 %cast290, %76
  %cast292 = inttoptr i64 %dst2_int291 to ptr
  %rhs_len_p1293 = add i64 %77, 1
  %80 = call ptr @memcpy(ptr %cast292, ptr %message287, i64 %rhs_len_p1293)
  %81 = call i32 @puts(ptr %78)
  %widen294 = sext i32 %81 to i64
  store i64 0, ptr %union_match_result247, align 8
  br label %union_match_end248

union_next273:                                    ; preds = %union_next250
  call void @avra_match_unreachable(ptr @.match_fn.55, i64 %union_tag246, ptr @mu_file.56, i64 73)
  unreachable

match_end298:                                     ; preds = %union_match_end332, %march_arm299
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm299:                                     ; preds = %match_end213
  %pay_slot302 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %61, i32 0, i32 1
  %payload303 = load ptr, ptr %pay_slot302, align 8
  %v_slot_base304 = ptrtoint ptr %payload303 to i64
  %v_slot_addr305 = add i64 %v_slot_base304, 0
  %v_slot306 = inttoptr i64 %v_slot_addr305 to ptr
  %v307 = load i64, ptr %v_slot306, align 8
  store i64 %v307, ptr %v308, align 8
  %v309 = load i64, ptr %v308, align 8
  %82 = call ptr @avra_rc_alloc(i64 32)
  %83 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %82, i64 32, ptr @.i2s_fmt.61, i64 %v309)
  %widen310 = sext i32 %83 to i64
  %84 = call i64 @strlen(ptr @.str.60)
  %85 = call i64 @strlen(ptr %82)
  %concat_total311 = add i64 %84, %85
  %concat_size312 = add i64 %concat_total311, 1
  %86 = call ptr @avra_rc_alloc(i64 %concat_size312)
  %87 = call ptr @memcpy(ptr %86, ptr @.str.60, i64 %84)
  %cast313 = ptrtoint ptr %86 to i64
  %dst2_int314 = add i64 %cast313, %84
  %cast315 = inttoptr i64 %dst2_int314 to ptr
  %rhs_len_p1316 = add i64 %85, 1
  %88 = call ptr @memcpy(ptr %cast315, ptr %82, i64 %rhs_len_p1316)
  %89 = call i32 @puts(ptr %86)
  %widen317 = sext i32 %89 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end298

march_next300:                                    ; preds = %match_end213
  %tag_eq320 = icmp eq i64 %tag297, 193456014
  br i1 %tag_eq320, label %march_arm318, label %march_next319

march_arm318:                                     ; preds = %march_next300
  %pay_slot321 = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %61, i32 0, i32 1
  %payload322 = load ptr, ptr %pay_slot321, align 8
  %e_slot_base323 = ptrtoint ptr %payload322 to i64
  %e_slot_addr324 = add i64 %e_slot_base323, 0
  %e_slot325 = inttoptr i64 %e_slot_addr324 to ptr
  %e326 = load ptr, ptr %e_slot325, align 8
  call void @avra_rc_retain(ptr %e326)
  store ptr %e326, ptr %e327, align 8
  %e328 = load ptr, ptr %e327, align 8
  %union_tag_ptr329 = getelementptr inbounds nuw %__union, ptr %e328, i32 0, i32 0
  %union_tag330 = load i64, ptr %union_tag_ptr329, align 8
  store i64 0, ptr %union_match_result331, align 8
  %union_tag_eq335 = icmp eq i64 %union_tag330, 229428548902887
  br i1 %union_tag_eq335, label %union_arm333, label %union_next334

march_next319:                                    ; preds = %march_next300
  call void @avra_match_unreachable(ptr @.match_fn.72, i64 %tag297, ptr @mu_file.73, i64 82)
  unreachable

union_match_end332:                               ; preds = %union_arm356, %union_arm333
  %union_match_val379 = load i64, ptr %union_match_result331, align 8
  store i64 %union_match_val379, ptr %match_result, align 8
  br label %match_end298

union_arm333:                                     ; preds = %march_arm318
  %union_pay_ptr336 = getelementptr inbounds nuw %__union, ptr %e328, i32 0, i32 1
  %union_payload337 = load ptr, ptr %union_pay_ptr336, align 8
  %union_val_slot_base338 = ptrtoint ptr %union_payload337 to i64
  %union_val_slot_addr339 = add i64 %union_val_slot_base338, 0
  %union_val_slot340 = inttoptr i64 %union_val_slot_addr339 to ptr
  %union_val341 = load ptr, ptr %union_val_slot340, align 8
  store ptr %union_val341, ptr %ie342, align 8
  %ie343 = load ptr, ptr %ie342, align 8
  %cast344 = ptrtoint ptr %ie343 to i64
  %null_chk345 = icmp eq i64 %cast344, 0
  %null_ext346 = zext i1 %null_chk345 to i64
  call void @avra_null_deref_trap(ptr @fld_name.63, i64 7, ptr @sty_name.64, i64 7, i64 %null_ext346, ptr @src_file.65, i64 97, i64 82)
  %message_ptr347 = getelementptr inbounds nuw %IoError, ptr %ie343, i32 0, i32 0
  %message348 = load ptr, ptr %message_ptr347, align 8
  %90 = call i64 @strlen(ptr @.str.62)
  %91 = call i64 @strlen(ptr %message348)
  %concat_total349 = add i64 %90, %91
  %concat_size350 = add i64 %concat_total349, 1
  %92 = call ptr @avra_rc_alloc(i64 %concat_size350)
  %93 = call ptr @memcpy(ptr %92, ptr @.str.62, i64 %90)
  %cast351 = ptrtoint ptr %92 to i64
  %dst2_int352 = add i64 %cast351, %90
  %cast353 = inttoptr i64 %dst2_int352 to ptr
  %rhs_len_p1354 = add i64 %91, 1
  %94 = call ptr @memcpy(ptr %cast353, ptr %message348, i64 %rhs_len_p1354)
  %95 = call i32 @puts(ptr %92)
  %widen355 = sext i32 %95 to i64
  store i64 0, ptr %union_match_result331, align 8
  br label %union_match_end332

union_next334:                                    ; preds = %march_arm318
  %union_tag_eq358 = icmp eq i64 %union_tag330, 8245280871156169482
  br i1 %union_tag_eq358, label %union_arm356, label %union_next357

union_arm356:                                     ; preds = %union_next334
  %union_pay_ptr359 = getelementptr inbounds nuw %__union, ptr %e328, i32 0, i32 1
  %union_payload360 = load ptr, ptr %union_pay_ptr359, align 8
  %union_val_slot_base361 = ptrtoint ptr %union_payload360 to i64
  %union_val_slot_addr362 = add i64 %union_val_slot_base361, 0
  %union_val_slot363 = inttoptr i64 %union_val_slot_addr362 to ptr
  %union_val364 = load ptr, ptr %union_val_slot363, align 8
  store ptr %union_val364, ptr %pe365, align 8
  %pe366 = load ptr, ptr %pe365, align 8
  %cast367 = ptrtoint ptr %pe366 to i64
  %null_chk368 = icmp eq i64 %cast367, 0
  %null_ext369 = zext i1 %null_chk368 to i64
  call void @avra_null_deref_trap(ptr @fld_name.67, i64 7, ptr @sty_name.68, i64 10, i64 %null_ext369, ptr @src_file.69, i64 97, i64 82)
  %message_ptr370 = getelementptr inbounds nuw %ParseError, ptr %pe366, i32 0, i32 0
  %message371 = load ptr, ptr %message_ptr370, align 8
  %96 = call i64 @strlen(ptr @.str.66)
  %97 = call i64 @strlen(ptr %message371)
  %concat_total372 = add i64 %96, %97
  %concat_size373 = add i64 %concat_total372, 1
  %98 = call ptr @avra_rc_alloc(i64 %concat_size373)
  %99 = call ptr @memcpy(ptr %98, ptr @.str.66, i64 %96)
  %cast374 = ptrtoint ptr %98 to i64
  %dst2_int375 = add i64 %cast374, %96
  %cast376 = inttoptr i64 %dst2_int375 to ptr
  %rhs_len_p1377 = add i64 %97, 1
  %100 = call ptr @memcpy(ptr %cast376, ptr %message371, i64 %rhs_len_p1377)
  %101 = call i32 @puts(ptr %98)
  %widen378 = sext i32 %101 to i64
  store i64 0, ptr %union_match_result331, align 8
  br label %union_match_end332

union_next357:                                    ; preds = %union_next334
  call void @avra_match_unreachable(ptr @.match_fn.70, i64 %union_tag330, ptr @mu_file.71, i64 82)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_ParseError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_message_ptr = getelementptr inbounds nuw %ParseError, ptr %0, i32 0, i32 0
  %rel_message = load ptr, ptr %rel_message_ptr, align 8
  %is_null_message = icmp eq ptr %rel_message, null
  br i1 %is_null_message, label %rel_message_skip, label %rel_message_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_message_skip
  ret i64 0

rel_message_skip:                                 ; preds = %rel_message_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_message_do:                                   ; preds = %do_free
  call void @avra_rc_release(ptr %rel_message)
  br label %rel_message_skip
}

define i64 @__release_IoError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_message_ptr = getelementptr inbounds nuw %IoError, ptr %0, i32 0, i32 0
  %rel_message = load ptr, ptr %rel_message_ptr, align 8
  %is_null_message = icmp eq ptr %rel_message, null
  br i1 %is_null_message, label %rel_message_skip, label %rel_message_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_message_skip
  ret i64 0

rel_message_skip:                                 ; preds = %rel_message_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_message_do:                                   ; preds = %do_free
  call void @avra_rc_release(ptr %rel_message)
  br label %rel_message_skip
}

define i64 @"__release_Result__int__IoError|ParseError"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"Result__int__IoError|ParseError", ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_error_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_error_ptr = getelementptr inbounds nuw %"Result__int__IoError|ParseError__Err", ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_Err:                                     ; preds = %do_free
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_Err
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_Err
  call void @avra_rc_release(ptr %vrel_error)
  br label %vrel_error_skip
}

define i64 @"__release_Result__string__IoError|ParseError"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"Result__string__IoError|ParseError", ptr %0, i32 0, i32 1
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
  %vrel_value_ptr = getelementptr inbounds nuw %"Result__string__IoError|ParseError__Ok", ptr %payload, i32 0, i32 0
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
  %vrel_error_ptr = getelementptr inbounds nuw %"Result__string__IoError|ParseError__Err", ptr %payload, i32 0, i32 0
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

define i64 @__release_Result__int__ParseError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result__int__ParseError, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__ParseError, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_error_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_error_ptr = getelementptr inbounds nuw %Result__int__ParseError__Err, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_Err:                                     ; preds = %do_free
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_Err
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_Err
  %2 = call i64 @__release_ParseError(ptr %vrel_error)
  br label %vrel_error_skip
}

define i64 @__release_Result__string__IoError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result__string__IoError, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__IoError, ptr %0, i32 0, i32 1
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
  %vrel_value_ptr = getelementptr inbounds nuw %Result__string__IoError__Ok, ptr %payload, i32 0, i32 0
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
  %vrel_error_ptr = getelementptr inbounds nuw %Result__string__IoError__Err, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_Err:                                     ; preds = %try_next_Ok
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_Err
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_Err
  %2 = call i64 @__release_IoError(ptr %vrel_error)
  br label %vrel_error_skip
}
