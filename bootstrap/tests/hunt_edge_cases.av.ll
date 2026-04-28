; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Inner = type { i64 }
%Middle = type { ptr }
%Outer = type { ptr }

@empty = global ptr null
@single = global i64 0
@o = global i64 0
@x = global i64 0
@r = global i64 0
@yes = global i64 0
@no = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name = private unnamed_addr constant [7 x i8] c"middle\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Outer\00", align 1
@src_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_edge_cases.av\00", align 1
@fld_name.3 = private unnamed_addr constant [6 x i8] c"inner\00", align 1
@sty_name.4 = private unnamed_addr constant [7 x i8] c"Middle\00", align 1
@src_file.5 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_edge_cases.av\00", align 1
@fld_name.6 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.7 = private unnamed_addr constant [6 x i8] c"Inner\00", align 1
@src_file.8 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_edge_cases.av\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"catch all\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_edge_cases.av\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [4 x i8] c"abc\00", align 1
@.str.13 = private unnamed_addr constant [4 x i8] c"abc\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"abc\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"def\00", align 1
@.i2s_fmt.16 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @abs(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %slt = icmp slt i64 %n1, 0
  %slt_ext = zext i1 %slt to i64
  %if_cond = icmp ne i64 %slt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %n3 = load i64, ptr %n, align 8
  ret i64 %n3

if_then:                                          ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  %neg = sub i64 0, %n2
  ret i64 %neg

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @main() {
entry:
  %pmatch_result = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  store ptr %0, ptr @empty, align 8
  %empty = load ptr, ptr @empty, align 8
  %1 = call i64 @avra_array_len(ptr %empty)
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %1)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen1 = sext i32 %4 to i64
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 42)
  store ptr %5, ptr @single, align 8
  %single = load ptr, ptr @single, align 8
  %6 = call i64 @avra_array_get(ptr %single, i64 0)
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.1, i64 %6)
  %widen2 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen3 = sext i32 %9 to i64
  %single4 = load ptr, ptr @single, align 8
  %10 = call i64 @avra_array_len(ptr %single4)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.2, i64 %10)
  %widen5 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen6 = sext i32 %13 to i64
  %14 = call ptr @avra_rc_alloc(i64 8)
  %15 = call ptr @avra_rc_alloc(i64 8)
  %16 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Inner, ptr %16, i32 0, i32 0
  store i64 99, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %16 to i64
  %fld_ptr7 = getelementptr inbounds nuw %Middle, ptr %15, i32 0, i32 0
  %cast8 = inttoptr i64 %cast to ptr
  store ptr %cast8, ptr %fld_ptr7, align 8
  %cast9 = ptrtoint ptr %15 to i64
  %fld_ptr10 = getelementptr inbounds nuw %Outer, ptr %14, i32 0, i32 0
  %cast11 = inttoptr i64 %cast9 to ptr
  store ptr %cast11, ptr %fld_ptr10, align 8
  %cast12 = ptrtoint ptr %14 to i64
  store i64 %cast12, ptr @o, align 8
  %o = load ptr, ptr @o, align 8
  %cast13 = ptrtoint ptr %o to i64
  %null_chk = icmp eq i64 %cast13, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 6, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 101, i64 16)
  %middle_ptr = getelementptr inbounds nuw %Outer, ptr %o, i32 0, i32 0
  %middle = load ptr, ptr %middle_ptr, align 8
  %cast14 = ptrtoint ptr %middle to i64
  %null_chk15 = icmp eq i64 %cast14, 0
  %null_ext16 = zext i1 %null_chk15 to i64
  call void @avra_null_deref_trap(ptr @fld_name.3, i64 5, ptr @sty_name.4, i64 6, i64 %null_ext16, ptr @src_file.5, i64 101, i64 16)
  %inner_ptr = getelementptr inbounds nuw %Middle, ptr %middle, i32 0, i32 0
  %inner = load ptr, ptr %inner_ptr, align 8
  %cast17 = ptrtoint ptr %inner to i64
  %null_chk18 = icmp eq i64 %cast17, 0
  %null_ext19 = zext i1 %null_chk18 to i64
  call void @avra_null_deref_trap(ptr @fld_name.6, i64 5, ptr @sty_name.7, i64 5, i64 %null_ext19, ptr @src_file.8, i64 101, i64 16)
  %value_ptr = getelementptr inbounds nuw %Inner, ptr %inner, i32 0, i32 0
  %value = load i64, ptr %value_ptr, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.9, i64 %value)
  %widen20 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen21 = sext i32 %19 to i64
  store i64 5, ptr @x, align 8
  %x = load i64, ptr @x, align 8
  store i64 0, ptr %pmatch_result, align 8
  br label %parm_body

pmatch_end:                                       ; preds = %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  store i64 %pmatch_val, ptr @r, align 8
  %r = load ptr, ptr @r, align 8
  %20 = call i32 @puts(ptr %r)
  %widen22 = sext i32 %20 to i64
  %21 = call i64 @abs(i64 -7)
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.10, i64 %21)
  %widen23 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen24 = sext i32 %24 to i64
  %25 = call i64 @abs(i64 3)
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.11, i64 %25)
  %widen25 = sext i32 %27 to i64
  %28 = call i32 @puts(ptr %26)
  %widen26 = sext i32 %28 to i64
  %29 = call i32 @strcmp(ptr @.str.12, ptr @.str.13)
  %widen27 = sext i32 %29 to i64
  %streq_cmp = icmp eq i64 %widen27, 0
  %streq_ext = zext i1 %streq_cmp to i64
  store i64 %streq_ext, ptr @yes, align 8
  %30 = call i32 @strcmp(ptr @.str.14, ptr @.str.15)
  %widen28 = sext i32 %30 to i64
  %streq_cmp29 = icmp eq i64 %widen28, 0
  %streq_ext30 = zext i1 %streq_cmp29 to i64
  store i64 %streq_ext30, ptr @no, align 8
  %yes = load i1, ptr @yes, align 8
  %31 = call ptr @avra_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.16, i1 %yes)
  %widen31 = sext i32 %32 to i64
  %33 = call i32 @puts(ptr %31)
  %widen32 = sext i32 %33 to i64
  %no = load i1, ptr @no, align 8
  %34 = call ptr @avra_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.17, i1 %no)
  %widen33 = sext i32 %35 to i64
  %36 = call i32 @puts(ptr %34)
  %widen34 = sext i32 %36 to i64
  %37 = call i32 @avra_test_summary()
  %widen35 = sext i32 %37 to i64
  call void @avra_rc_collect()
  ret i64 0

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 20)
  unreachable
}

define i64 @__release_Outer(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_middle_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  %rel_middle = load ptr, ptr %rel_middle_ptr, align 8
  %is_null_middle = icmp eq ptr %rel_middle, null
  br i1 %is_null_middle, label %rel_middle_skip, label %rel_middle_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_middle_skip
  ret i64 0

rel_middle_skip:                                  ; preds = %rel_middle_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_middle_do:                                    ; preds = %do_free
  %2 = call i64 @__release_Middle(ptr %rel_middle)
  br label %rel_middle_skip
}

define i64 @__release_Middle(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_inner_ptr = getelementptr inbounds nuw %Middle, ptr %0, i32 0, i32 0
  %rel_inner = load ptr, ptr %rel_inner_ptr, align 8
  %is_null_inner = icmp eq ptr %rel_inner, null
  br i1 %is_null_inner, label %rel_inner_skip, label %rel_inner_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_inner_skip
  ret i64 0

rel_inner_skip:                                   ; preds = %rel_inner_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_inner_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_inner)
  br label %rel_inner_skip
}
