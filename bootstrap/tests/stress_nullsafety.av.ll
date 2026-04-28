; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%User = type { ptr, i64 }

@result = global i64 0
@a = global ptr null
@b = global ptr null
@c = global i64 0
@u = global i64 0
@n = global ptr null
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @step1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %slt = icmp slt i64 %x1, 0
  %slt_ext = zext i1 %slt to i64
  %if_cond = icmp ne i64 %slt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %x2, 2
  ret i64 %mul

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @step2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 100
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %x2, 10
  ret i64 %add

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @step3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %eq = icmp eq i64 %x1, 42
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %x2 = load i64, ptr %x, align 8
  ret i64 %x2

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @pipeline(i64 %0) {
entry:
  %c = alloca i64, align 8
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call i64 @step1(i64 %x1)
  %try_null = icmp eq i64 %1, 0
  br i1 %try_null, label %try_ret, label %try_ok

try_ok:                                           ; preds = %entry
  store i64 %1, ptr %a, align 8
  %a2 = load i64, ptr %a, align 8
  %2 = call i64 @step2(i64 %a2)
  %try_null3 = icmp eq i64 %2, 0
  br i1 %try_null3, label %try_ret5, label %try_ok4

try_ret:                                          ; preds = %entry
  ret i64 0

try_ok4:                                          ; preds = %try_ok
  store i64 %2, ptr %b, align 8
  %b6 = load i64, ptr %b, align 8
  %3 = call i64 @step3(i64 %b6)
  %try_null7 = icmp eq i64 %3, 0
  br i1 %try_null7, label %try_ret9, label %try_ok8

try_ret5:                                         ; preds = %try_ok
  ret i64 0

try_ok8:                                          ; preds = %try_ok4
  store i64 %3, ptr %c, align 8
  %c10 = load i64, ptr %c, align 8
  ret i64 %c10

try_ret9:                                         ; preds = %try_ok4
  ret i64 0
}

define i64 @main() {
entry:
  %nc_result52 = alloca i64, align 8
  %oc_result47 = alloca i64, align 8
  %oc_result = alloca i64, align 8
  %nc_result37 = alloca i64, align 8
  %nc_result32 = alloca i64, align 8
  %nc_result25 = alloca i64, align 8
  %nc_result19 = alloca i64, align 8
  %nc_result12 = alloca i64, align 8
  %nc_result5 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %0 = call i64 @pipeline(i64 5)
  %nc_null = icmp eq i64 %0, 0
  store i64 %0, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

nc_rhs:                                           ; preds = %entry
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %entry
  %nc_val = load i64, ptr %nc_result, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %nc_val)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen1 = sext i32 %3 to i64
  %4 = call i64 @pipeline(i64 -1)
  %nc_null2 = icmp eq i64 %4, 0
  store i64 %4, ptr %nc_result5, align 8
  br i1 %nc_null2, label %nc_rhs3, label %nc_end4

nc_rhs3:                                          ; preds = %nc_end
  store i64 -1, ptr %nc_result5, align 8
  br label %nc_end4

nc_end4:                                          ; preds = %nc_rhs3, %nc_end
  %nc_val6 = load i64, ptr %nc_result5, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.1, i64 %nc_val6)
  %widen7 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen8 = sext i32 %7 to i64
  %8 = call i64 @pipeline(i64 60)
  %nc_null9 = icmp eq i64 %8, 0
  store i64 %8, ptr %nc_result12, align 8
  br i1 %nc_null9, label %nc_rhs10, label %nc_end11

nc_rhs10:                                         ; preds = %nc_end4
  store i64 -1, ptr %nc_result12, align 8
  br label %nc_end11

nc_end11:                                         ; preds = %nc_rhs10, %nc_end4
  %nc_val13 = load i64, ptr %nc_result12, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.2, i64 %nc_val13)
  %widen14 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen15 = sext i32 %11 to i64
  %12 = call i64 @pipeline(i64 16)
  %nc_null16 = icmp eq i64 %12, 0
  store i64 %12, ptr %nc_result19, align 8
  br i1 %nc_null16, label %nc_rhs17, label %nc_end18

nc_rhs17:                                         ; preds = %nc_end11
  store i64 -1, ptr %nc_result19, align 8
  br label %nc_end18

nc_end18:                                         ; preds = %nc_rhs17, %nc_end11
  %nc_val20 = load i64, ptr %nc_result19, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.3, i64 %nc_val20)
  %widen21 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen22 = sext i32 %15 to i64
  store i64 0, ptr %nc_result25, align 8
  br i1 true, label %nc_rhs23, label %nc_end24

nc_rhs23:                                         ; preds = %nc_end18
  store i64 30, ptr %nc_result25, align 8
  br label %nc_end24

nc_end24:                                         ; preds = %nc_rhs23, %nc_end18
  %nc_val26 = load i64, ptr %nc_result25, align 8
  store i64 %nc_val26, ptr @result, align 8
  %result = load i64, ptr @result, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.4, i64 %result)
  %widen27 = sext i32 %17 to i64
  %18 = call i32 @puts(ptr %16)
  %widen28 = sext i32 %18 to i64
  store i64 0, ptr @a, align 8
  store i64 0, ptr @b, align 8
  %a = load i64, ptr @a, align 8
  %nc_null29 = icmp eq i64 %a, 0
  store i64 %a, ptr %nc_result32, align 8
  br i1 %nc_null29, label %nc_rhs30, label %nc_end31

nc_rhs30:                                         ; preds = %nc_end24
  %b = load i64, ptr @b, align 8
  store i64 %b, ptr %nc_result32, align 8
  br label %nc_end31

nc_end31:                                         ; preds = %nc_rhs30, %nc_end24
  %nc_val33 = load i64, ptr %nc_result32, align 8
  %nc_null34 = icmp eq i64 %nc_val33, 0
  store i64 %nc_val33, ptr %nc_result37, align 8
  br i1 %nc_null34, label %nc_rhs35, label %nc_end36

nc_rhs35:                                         ; preds = %nc_end31
  store i64 99, ptr %nc_result37, align 8
  br label %nc_end36

nc_end36:                                         ; preds = %nc_rhs35, %nc_end31
  %nc_val38 = load i64, ptr %nc_result37, align 8
  store i64 %nc_val38, ptr @c, align 8
  %c = load i64, ptr @c, align 8
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.5, i64 %c)
  %widen39 = sext i32 %20 to i64
  %21 = call i32 @puts(ptr %19)
  %widen40 = sext i32 %21 to i64
  %22 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %User, ptr %22, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %fld_ptr41 = getelementptr inbounds nuw %User, ptr %22, i32 0, i32 1
  store i64 30, ptr %fld_ptr41, align 8
  %cast = ptrtoint ptr %22 to i64
  store i64 %cast, ptr @u, align 8
  %u = load ptr, ptr @u, align 8
  %oc_null = icmp eq ptr %u, null
  store i64 0, ptr %oc_result, align 8
  br i1 %oc_null, label %oc_end, label %oc_access

oc_access:                                        ; preds = %nc_end36
  %oc_fld = getelementptr inbounds nuw %User, ptr %u, i32 0, i32 1
  %age = load i64, ptr %oc_fld, align 8
  store i64 %age, ptr %oc_result, align 8
  br label %oc_end

oc_end:                                           ; preds = %oc_access, %nc_end36
  %oc_val = load i64, ptr %oc_result, align 8
  %23 = call ptr @avra_rc_alloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @.i2s_fmt.6, i64 %oc_val)
  %widen42 = sext i32 %24 to i64
  %25 = call i32 @puts(ptr %23)
  %widen43 = sext i32 %25 to i64
  store i64 0, ptr @n, align 8
  %n = load i64, ptr @n, align 8
  %oc_null44 = icmp eq i64 %n, 0
  store i64 0, ptr %oc_result47, align 8
  br i1 %oc_null44, label %oc_end46, label %oc_access45

oc_access45:                                      ; preds = %oc_end
  store i64 %n, ptr %oc_result47, align 8
  br label %oc_end46

oc_end46:                                         ; preds = %oc_access45, %oc_end
  %oc_val48 = load i64, ptr %oc_result47, align 8
  %nc_null49 = icmp eq i64 %oc_val48, 0
  store i64 %oc_val48, ptr %nc_result52, align 8
  br i1 %nc_null49, label %nc_rhs50, label %nc_end51

nc_rhs50:                                         ; preds = %oc_end46
  store i64 0, ptr %nc_result52, align 8
  br label %nc_end51

nc_end51:                                         ; preds = %nc_rhs50, %oc_end46
  %nc_val53 = load i64, ptr %nc_result52, align 8
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.7, i64 %nc_val53)
  %widen54 = sext i32 %27 to i64
  %28 = call i32 @puts(ptr %26)
  %widen55 = sext i32 %28 to i64
  %29 = call i32 @avra_test_summary()
  %widen56 = sext i32 %29 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_User(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %User, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}
