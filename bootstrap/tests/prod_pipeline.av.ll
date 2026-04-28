; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Student = type { ptr, i64 }

@data = global i64 0
@high_count = global i64 0
@total = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"Carol\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"Dave\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"Eve\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"score\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"Student\00", align 1
@src_file = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_pipeline.av\00", align 1
@fld_name.5 = private unnamed_addr constant [6 x i8] c"score\00", align 1
@sty_name.6 = private unnamed_addr constant [8 x i8] c"Student\00", align 1
@src_file.7 = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_pipeline.av\00", align 1
@fld_name.8 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.9 = private unnamed_addr constant [8 x i8] c"Student\00", align 1
@src_file.10 = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_pipeline.av\00", align 1
@.str.11 = private unnamed_addr constant [3 x i8] c": \00", align 1
@fld_name.12 = private unnamed_addr constant [6 x i8] c"score\00", align 1
@sty_name.13 = private unnamed_addr constant [8 x i8] c"Student\00", align 1
@src_file.14 = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_pipeline.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [8 x i8] c" (high)\00", align 1
@.str.16 = private unnamed_addr constant [8 x i8] c"Total: \00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.18 = private unnamed_addr constant [18 x i8] c"High performers: \00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.20 = private unnamed_addr constant [10 x i8] c"Average: \00", align 1
@dz_file = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_pipeline.av\00", align 1
@.i2s_fmt.21 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Student, ptr %1, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Student, ptr %1, i32 0, i32 1
  store i64 95, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %2 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr2 = getelementptr inbounds nuw %Student, ptr %2, i32 0, i32 0
  store ptr @.str.1, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Student, ptr %2, i32 0, i32 1
  store i64 82, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %0, i64 %cast4)
  %3 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr5 = getelementptr inbounds nuw %Student, ptr %3, i32 0, i32 0
  store ptr @.str.2, ptr %fld_ptr5, align 8
  %fld_ptr6 = getelementptr inbounds nuw %Student, ptr %3, i32 0, i32 1
  store i64 91, ptr %fld_ptr6, align 8
  %cast7 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %0, i64 %cast7)
  %4 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr8 = getelementptr inbounds nuw %Student, ptr %4, i32 0, i32 0
  store ptr @.str.3, ptr %fld_ptr8, align 8
  %fld_ptr9 = getelementptr inbounds nuw %Student, ptr %4, i32 0, i32 1
  store i64 67, ptr %fld_ptr9, align 8
  %cast10 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %0, i64 %cast10)
  %5 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr11 = getelementptr inbounds nuw %Student, ptr %5, i32 0, i32 0
  store ptr @.str.4, ptr %fld_ptr11, align 8
  %fld_ptr12 = getelementptr inbounds nuw %Student, ptr %5, i32 0, i32 1
  store i64 88, ptr %fld_ptr12, align 8
  %cast13 = ptrtoint ptr %5 to i64
  call void @avra_array_push(ptr %0, i64 %cast13)
  store ptr %0, ptr @data, align 8
  store i64 0, ptr @high_count, align 8
  store i64 0, ptr @total, align 8
  %data = load ptr, ptr @data, align 8
  %6 = call i64 @avra_array_len(ptr %data)
  store i64 %6, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %7 = call i64 @avra_array_get(ptr %data, i64 %forin_i_val)
  store i64 %7, ptr %s, align 8
  %total = load i64, ptr @total, align 8
  %s14 = load ptr, ptr %s, align 8
  %cast15 = ptrtoint ptr %s14 to i64
  %null_chk = icmp eq i64 %cast15, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 99, i64 15)
  %score_ptr = getelementptr inbounds nuw %Student, ptr %s14, i32 0, i32 1
  %score = load i64, ptr %score_ptr, align 8
  %add = add i64 %total, %score
  store i64 %add, ptr @total, align 8
  %s16 = load ptr, ptr %s, align 8
  %cast17 = ptrtoint ptr %s16 to i64
  %null_chk18 = icmp eq i64 %cast17, 0
  %null_ext19 = zext i1 %null_chk18 to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 5, ptr @sty_name.6, i64 7, i64 %null_ext19, ptr @src_file.7, i64 99, i64 16)
  %score_ptr20 = getelementptr inbounds nuw %Student, ptr %s16, i32 0, i32 1
  %score21 = load i64, ptr %score_ptr20, align 8
  %sge = icmp sge i64 %score21, 90
  %sge_ext = zext i1 %sge to i64
  %if_cond = icmp ne i64 %sge_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

forin.incr:                                       ; preds = %ifcont
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %total48 = load i64, ptr @total, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.17, i64 %total48)
  %widen49 = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str.16)
  %11 = call i64 @strlen(ptr %8)
  %concat_total50 = add i64 %10, %11
  %concat_size51 = add i64 %concat_total50, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size51)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.16, i64 %10)
  %cast52 = ptrtoint ptr %12 to i64
  %dst2_int53 = add i64 %cast52, %10
  %cast54 = inttoptr i64 %dst2_int53 to ptr
  %rhs_len_p155 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast54, ptr %8, i64 %rhs_len_p155)
  %15 = call i32 @puts(ptr %12)
  %widen56 = sext i32 %15 to i64
  %high_count57 = load i64, ptr @high_count, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.19, i64 %high_count57)
  %widen58 = sext i32 %17 to i64
  %18 = call i64 @strlen(ptr @.str.18)
  %19 = call i64 @strlen(ptr %16)
  %concat_total59 = add i64 %18, %19
  %concat_size60 = add i64 %concat_total59, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size60)
  %21 = call ptr @memcpy(ptr %20, ptr @.str.18, i64 %18)
  %cast61 = ptrtoint ptr %20 to i64
  %dst2_int62 = add i64 %cast61, %18
  %cast63 = inttoptr i64 %dst2_int62 to ptr
  %rhs_len_p164 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast63, ptr %16, i64 %rhs_len_p164)
  %23 = call i32 @puts(ptr %20)
  %widen65 = sext i32 %23 to i64
  %total66 = load i64, ptr @total, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 99, i64 23)
  %div = sdiv i64 %total66, 5
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.21, i64 %div)
  %widen67 = sext i32 %25 to i64
  %26 = call i64 @strlen(ptr @.str.20)
  %27 = call i64 @strlen(ptr %24)
  %concat_total68 = add i64 %26, %27
  %concat_size69 = add i64 %concat_total68, 1
  %28 = call ptr @avra_rc_alloc(i64 %concat_size69)
  %29 = call ptr @memcpy(ptr %28, ptr @.str.20, i64 %26)
  %cast70 = ptrtoint ptr %28 to i64
  %dst2_int71 = add i64 %cast70, %26
  %cast72 = inttoptr i64 %dst2_int71 to ptr
  %rhs_len_p173 = add i64 %27, 1
  %30 = call ptr @memcpy(ptr %cast72, ptr %24, i64 %rhs_len_p173)
  %31 = call i32 @puts(ptr %28)
  %widen74 = sext i32 %31 to i64
  %32 = call i32 @avra_test_summary()
  %widen75 = sext i32 %32 to i64
  call void @avra_rc_collect()
  ret i64 0

ifcont:                                           ; preds = %if_else, %if_then
  br label %forin.incr

if_then:                                          ; preds = %forin.body
  %high_count = load i64, ptr @high_count, align 8
  %add22 = add i64 %high_count, 1
  store i64 %add22, ptr @high_count, align 8
  %s23 = load ptr, ptr %s, align 8
  %cast24 = ptrtoint ptr %s23 to i64
  %null_chk25 = icmp eq i64 %cast24, 0
  %null_ext26 = zext i1 %null_chk25 to i64
  call void @avra_null_deref_trap(ptr @fld_name.8, i64 4, ptr @sty_name.9, i64 7, i64 %null_ext26, ptr @src_file.10, i64 99, i64 18)
  %name_ptr = getelementptr inbounds nuw %Student, ptr %s23, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %33 = call i64 @strlen(ptr %name)
  %34 = call i64 @strlen(ptr @.str.11)
  %concat_total = add i64 %33, %34
  %concat_size = add i64 %concat_total, 1
  %35 = call ptr @avra_rc_alloc(i64 %concat_size)
  %36 = call ptr @memcpy(ptr %35, ptr %name, i64 %33)
  %cast27 = ptrtoint ptr %35 to i64
  %dst2_int = add i64 %cast27, %33
  %cast28 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %34, 1
  %37 = call ptr @memcpy(ptr %cast28, ptr @.str.11, i64 %rhs_len_p1)
  %s29 = load ptr, ptr %s, align 8
  %cast30 = ptrtoint ptr %s29 to i64
  %null_chk31 = icmp eq i64 %cast30, 0
  %null_ext32 = zext i1 %null_chk31 to i64
  call void @avra_null_deref_trap(ptr @fld_name.12, i64 5, ptr @sty_name.13, i64 7, i64 %null_ext32, ptr @src_file.14, i64 99, i64 18)
  %score_ptr33 = getelementptr inbounds nuw %Student, ptr %s29, i32 0, i32 1
  %score34 = load i64, ptr %score_ptr33, align 8
  %38 = call ptr @avra_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt, i64 %score34)
  %widen = sext i32 %39 to i64
  %40 = call i64 @strlen(ptr %35)
  %41 = call i64 @strlen(ptr %38)
  %concat_total35 = add i64 %40, %41
  %concat_size36 = add i64 %concat_total35, 1
  %42 = call ptr @avra_rc_alloc(i64 %concat_size36)
  %43 = call ptr @memcpy(ptr %42, ptr %35, i64 %40)
  %cast37 = ptrtoint ptr %42 to i64
  %dst2_int38 = add i64 %cast37, %40
  %cast39 = inttoptr i64 %dst2_int38 to ptr
  %rhs_len_p140 = add i64 %41, 1
  %44 = call ptr @memcpy(ptr %cast39, ptr %38, i64 %rhs_len_p140)
  %45 = call i64 @strlen(ptr %42)
  %46 = call i64 @strlen(ptr @.str.15)
  %concat_total41 = add i64 %45, %46
  %concat_size42 = add i64 %concat_total41, 1
  %47 = call ptr @avra_rc_alloc(i64 %concat_size42)
  %48 = call ptr @memcpy(ptr %47, ptr %42, i64 %45)
  %cast43 = ptrtoint ptr %47 to i64
  %dst2_int44 = add i64 %cast43, %45
  %cast45 = inttoptr i64 %dst2_int44 to ptr
  %rhs_len_p146 = add i64 %46, 1
  %49 = call ptr @memcpy(ptr %cast45, ptr @.str.15, i64 %rhs_len_p146)
  %50 = call i32 @puts(ptr %47)
  %widen47 = sext i32 %50 to i64
  br label %ifcont

if_else:                                          ; preds = %forin.body
  br label %ifcont
}

define i64 @__release_Student(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Student, ptr %0, i32 0, i32 0
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
