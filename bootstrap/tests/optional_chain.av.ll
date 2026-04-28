; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%App = type { ptr }
%Config = type { ptr, i64 }

@fld_name = private unnamed_addr constant [7 x i8] c"config\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"App\00", align 1
@src_file = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/optional_chain.av\00", align 1
@fld_name.1 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name.2 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.3 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/optional_chain.av\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"null fallback\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"got \00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"got \00", align 1

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

define ptr @get_host(ptr %0) {
entry:
  %app = alloca ptr, align 8
  store ptr %0, ptr %app, align 8
  %app1 = load ptr, ptr %app, align 8
  %ne = icmp ne ptr %app1, null
  %ne_ext = zext i1 %ne to i64
  %if_cond = icmp ne i64 %ne_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  ret ptr @.str

if_then:                                          ; preds = %entry
  %app2 = load ptr, ptr %app, align 8
  %cast = ptrtoint ptr %app2 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 6, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 100, i64 9)
  %config_ptr = getelementptr inbounds nuw %App, ptr %app2, i32 0, i32 0
  %config = load ptr, ptr %config_ptr, align 8
  %cast3 = ptrtoint ptr %config to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 4, ptr @sty_name.2, i64 6, i64 %null_ext5, ptr @src_file.3, i64 100, i64 9)
  %host_ptr = getelementptr inbounds nuw %Config, ptr %config, i32 0, i32 0
  %host = load ptr, ptr %host_ptr, align 8
  ret ptr %host

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %a = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 8)
  %2 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 0
  store ptr @.str.4, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 1
  store i64 8080, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %2 to i64
  %fld_ptr2 = getelementptr inbounds nuw %App, ptr %1, i32 0, i32 0
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %fld_ptr2, align 8
  %cast4 = ptrtoint ptr %1 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  store ptr %cast5, ptr %a, align 8
  %a6 = load ptr, ptr %a, align 8
  %3 = call ptr @get_host(ptr %a6)
  %4 = call i64 @strlen(ptr @.str.5)
  %5 = call i64 @strlen(ptr %3)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr @.str.5, i64 %4)
  %cast7 = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast7, %4
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast8, ptr %3, i64 %rhs_len_p1)
  %9 = call i32 @puts(ptr %6)
  %widen = sext i32 %9 to i64
  %10 = call ptr @get_host(ptr null)
  %11 = call i64 @strlen(ptr @.str.6)
  %12 = call i64 @strlen(ptr %10)
  %concat_total9 = add i64 %11, %12
  %concat_size10 = add i64 %concat_total9, 1
  %13 = call ptr @avra_rc_alloc(i64 %concat_size10)
  %14 = call ptr @memcpy(ptr %13, ptr @.str.6, i64 %11)
  %cast11 = ptrtoint ptr %13 to i64
  %dst2_int12 = add i64 %cast11, %11
  %cast13 = inttoptr i64 %dst2_int12 to ptr
  %rhs_len_p114 = add i64 %12, 1
  %15 = call ptr @memcpy(ptr %cast13, ptr %10, i64 %rhs_len_p114)
  %16 = call i32 @puts(ptr %13)
  %widen15 = sext i32 %16 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_App(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_config_ptr = getelementptr inbounds nuw %App, ptr %0, i32 0, i32 0
  %rel_config = load ptr, ptr %rel_config_ptr, align 8
  %is_null_config = icmp eq ptr %rel_config, null
  br i1 %is_null_config, label %rel_config_skip, label %rel_config_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_config_skip
  ret i64 0

rel_config_skip:                                  ; preds = %rel_config_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_config_do:                                    ; preds = %do_free
  %2 = call i64 @__release_Config(ptr %rel_config)
  br label %rel_config_skip
}

define i64 @__release_Config(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_host_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  %rel_host = load ptr, ptr %rel_host_ptr, align 8
  %is_null_host = icmp eq ptr %rel_host, null
  br i1 %is_null_host, label %rel_host_skip, label %rel_host_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_host_skip
  ret i64 0

rel_host_skip:                                    ; preds = %rel_host_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_host_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_host)
  br label %rel_host_skip
}
