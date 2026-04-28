; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Dog = type { ptr }
%Cat = type { ptr }
%Pair__int__string = type { i64, ptr }

@.str = private unnamed_addr constant [5 x i8] c"woof\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"meow\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"Rex\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"Whiskers\00", align 1
@.str.4 = private unnamed_addr constant [11 x i8] c"Dog says: \00", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"Cat says: \00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"sum: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.8 = private unnamed_addr constant [8 x i8] c"pair: (\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"first\00", align 1
@sty_name = private unnamed_addr constant [18 x i8] c"Pair__int__string\00", align 1
@src_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/polymorphism_red_team.av\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.11 = private unnamed_addr constant [7 x i8] c"second\00", align 1
@sty_name.12 = private unnamed_addr constant [18 x i8] c"Pair__int__string\00", align 1
@src_file.13 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/polymorphism_red_team.av\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c")\00", align 1

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

define ptr @Dog__say(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str
}

define ptr @Cat__say(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.1
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %p = alloca ptr, align 8
  %total = alloca i64, align 8
  %nums = alloca ptr, align 8
  %c = alloca ptr, align 8
  %d = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 0
  store ptr @.str.2, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @avra_array_new()
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 -559038737)
  call void @avra_array_push(ptr %3, i64 ptrtoint (ptr @Dog__say to i64))
  %cast1 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %2, i64 %cast1)
  %cast2 = inttoptr i64 %cast to ptr
  %cast3 = ptrtoint ptr %2 to i64
  %4 = call i64 @avra_trait_object_new(ptr %cast2, i64 %cast3)
  %cast4 = inttoptr i64 %4 to ptr
  store ptr %cast4, ptr %d, align 8
  %5 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr5 = getelementptr inbounds nuw %Cat, ptr %5, i32 0, i32 0
  store ptr @.str.3, ptr %fld_ptr5, align 8
  %cast6 = ptrtoint ptr %5 to i64
  %6 = call ptr @avra_array_new()
  %7 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %7, i64 -559038737)
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @Cat__say to i64))
  %cast7 = ptrtoint ptr %7 to i64
  call void @avra_array_push(ptr %6, i64 %cast7)
  %cast8 = inttoptr i64 %cast6 to ptr
  %cast9 = ptrtoint ptr %6 to i64
  %8 = call i64 @avra_trait_object_new(ptr %cast8, i64 %cast9)
  %cast10 = inttoptr i64 %8 to ptr
  store ptr %cast10, ptr %c, align 8
  %d11 = load ptr, ptr %d, align 8
  %9 = call i64 @avra_trait_object_value(ptr %d11)
  %10 = call ptr @avra_trait_object_vtable(ptr %d11)
  %11 = call i64 @avra_array_get(ptr %10, i64 0)
  %12 = call i64 @avra_closure_call_1(i64 %11, i64 %9)
  %cast12 = inttoptr i64 %12 to ptr
  %13 = call i64 @strlen(ptr @.str.4)
  %14 = call i64 @strlen(ptr %cast12)
  %concat_total = add i64 %13, %14
  %concat_size = add i64 %concat_total, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size)
  %16 = call ptr @memcpy(ptr %15, ptr @.str.4, i64 %13)
  %cast13 = ptrtoint ptr %15 to i64
  %dst2_int = add i64 %cast13, %13
  %cast14 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast14, ptr %cast12, i64 %rhs_len_p1)
  %18 = call i32 @puts(ptr %15)
  %widen = sext i32 %18 to i64
  %c15 = load ptr, ptr %c, align 8
  %19 = call i64 @avra_trait_object_value(ptr %c15)
  %20 = call ptr @avra_trait_object_vtable(ptr %c15)
  %21 = call i64 @avra_array_get(ptr %20, i64 0)
  %22 = call i64 @avra_closure_call_1(i64 %21, i64 %19)
  %cast16 = inttoptr i64 %22 to ptr
  %23 = call i64 @strlen(ptr @.str.5)
  %24 = call i64 @strlen(ptr %cast16)
  %concat_total17 = add i64 %23, %24
  %concat_size18 = add i64 %concat_total17, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size18)
  %26 = call ptr @memcpy(ptr %25, ptr @.str.5, i64 %23)
  %cast19 = ptrtoint ptr %25 to i64
  %dst2_int20 = add i64 %cast19, %23
  %cast21 = inttoptr i64 %dst2_int20 to ptr
  %rhs_len_p122 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast21, ptr %cast16, i64 %rhs_len_p122)
  %28 = call i32 @puts(ptr %25)
  %widen23 = sext i32 %28 to i64
  %29 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %29, i64 1)
  call void @avra_array_push(ptr %29, i64 2)
  call void @avra_array_push(ptr %29, i64 3)
  store ptr %29, ptr %nums, align 8
  %nums24 = load ptr, ptr %nums, align 8
  %30 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %30, i64 -559038737)
  call void @avra_array_push(ptr %30, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast25 = ptrtoint ptr %30 to i64
  %31 = call i64 @avra_array_reduce(ptr %nums24, i64 0, i64 %cast25)
  store i64 %31, ptr %total, align 8
  %total26 = load i64, ptr %total, align 8
  %32 = call ptr @avra_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt, i64 %total26)
  %widen27 = sext i32 %33 to i64
  %34 = call i64 @strlen(ptr @.str.6)
  %35 = call i64 @strlen(ptr %32)
  %concat_total28 = add i64 %34, %35
  %concat_size29 = add i64 %concat_total28, 1
  %36 = call ptr @avra_rc_alloc(i64 %concat_size29)
  %37 = call ptr @memcpy(ptr %36, ptr @.str.6, i64 %34)
  %cast30 = ptrtoint ptr %36 to i64
  %dst2_int31 = add i64 %cast30, %34
  %cast32 = inttoptr i64 %dst2_int31 to ptr
  %rhs_len_p133 = add i64 %35, 1
  %38 = call ptr @memcpy(ptr %cast32, ptr %32, i64 %rhs_len_p133)
  %39 = call i32 @puts(ptr %36)
  %widen34 = sext i32 %39 to i64
  %40 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr35 = getelementptr inbounds nuw %Pair__int__string, ptr %40, i32 0, i32 0
  store i64 1, ptr %fld_ptr35, align 8
  %fld_ptr36 = getelementptr inbounds nuw %Pair__int__string, ptr %40, i32 0, i32 1
  store ptr @.str.7, ptr %fld_ptr36, align 8
  %cast37 = ptrtoint ptr %40 to i64
  %cast38 = inttoptr i64 %cast37 to ptr
  store ptr %cast38, ptr %p, align 8
  %p39 = load ptr, ptr %p, align 8
  %cast40 = ptrtoint ptr %p39 to i64
  %null_chk = icmp eq i64 %cast40, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 17, i64 %null_ext, ptr @src_file, i64 107, i64 25)
  %first_ptr = getelementptr inbounds nuw %Pair__int__string, ptr %p39, i32 0, i32 0
  %first = load i64, ptr %first_ptr, align 8
  %41 = call ptr @avra_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt.9, i64 %first)
  %widen41 = sext i32 %42 to i64
  %43 = call i64 @strlen(ptr @.str.8)
  %44 = call i64 @strlen(ptr %41)
  %concat_total42 = add i64 %43, %44
  %concat_size43 = add i64 %concat_total42, 1
  %45 = call ptr @avra_rc_alloc(i64 %concat_size43)
  %46 = call ptr @memcpy(ptr %45, ptr @.str.8, i64 %43)
  %cast44 = ptrtoint ptr %45 to i64
  %dst2_int45 = add i64 %cast44, %43
  %cast46 = inttoptr i64 %dst2_int45 to ptr
  %rhs_len_p147 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast46, ptr %41, i64 %rhs_len_p147)
  %48 = call i64 @strlen(ptr %45)
  %49 = call i64 @strlen(ptr @.str.10)
  %concat_total48 = add i64 %48, %49
  %concat_size49 = add i64 %concat_total48, 1
  %50 = call ptr @avra_rc_alloc(i64 %concat_size49)
  %51 = call ptr @memcpy(ptr %50, ptr %45, i64 %48)
  %cast50 = ptrtoint ptr %50 to i64
  %dst2_int51 = add i64 %cast50, %48
  %cast52 = inttoptr i64 %dst2_int51 to ptr
  %rhs_len_p153 = add i64 %49, 1
  %52 = call ptr @memcpy(ptr %cast52, ptr @.str.10, i64 %rhs_len_p153)
  %p54 = load ptr, ptr %p, align 8
  %cast55 = ptrtoint ptr %p54 to i64
  %null_chk56 = icmp eq i64 %cast55, 0
  %null_ext57 = zext i1 %null_chk56 to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 6, ptr @sty_name.12, i64 17, i64 %null_ext57, ptr @src_file.13, i64 107, i64 25)
  %second_ptr = getelementptr inbounds nuw %Pair__int__string, ptr %p54, i32 0, i32 1
  %second = load ptr, ptr %second_ptr, align 8
  %53 = call i64 @strlen(ptr %50)
  %54 = call i64 @strlen(ptr %second)
  %concat_total58 = add i64 %53, %54
  %concat_size59 = add i64 %concat_total58, 1
  %55 = call ptr @avra_rc_alloc(i64 %concat_size59)
  %56 = call ptr @memcpy(ptr %55, ptr %50, i64 %53)
  %cast60 = ptrtoint ptr %55 to i64
  %dst2_int61 = add i64 %cast60, %53
  %cast62 = inttoptr i64 %dst2_int61 to ptr
  %rhs_len_p163 = add i64 %54, 1
  %57 = call ptr @memcpy(ptr %cast62, ptr %second, i64 %rhs_len_p163)
  %58 = call i64 @strlen(ptr %55)
  %59 = call i64 @strlen(ptr @.str.14)
  %concat_total64 = add i64 %58, %59
  %concat_size65 = add i64 %concat_total64, 1
  %60 = call ptr @avra_rc_alloc(i64 %concat_size65)
  %61 = call ptr @memcpy(ptr %60, ptr %55, i64 %58)
  %cast66 = ptrtoint ptr %60 to i64
  %dst2_int67 = add i64 %cast66, %58
  %cast68 = inttoptr i64 %dst2_int67 to ptr
  %rhs_len_p169 = add i64 %59, 1
  %62 = call ptr @memcpy(ptr %cast68, ptr @.str.14, i64 %rhs_len_p169)
  %63 = call i32 @puts(ptr %60)
  %widen70 = sext i32 %63 to i64
  %p_cleanup = load ptr, ptr %p, align 8
  %64 = call i64 @__release_Pair__int__string(ptr %p_cleanup)
  %c_cleanup = load ptr, ptr %c, align 8
  call void @avra_rc_release(ptr %c_cleanup)
  %d_cleanup = load ptr, ptr %d, align 8
  call void @avra_rc_release(ptr %d_cleanup)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Cat(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Cat, ptr %0, i32 0, i32 0
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

define i64 @__release_Dog(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Dog, ptr %0, i32 0, i32 0
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

define i64 @__release_Pair__int__string(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_second_ptr = getelementptr inbounds nuw %Pair__int__string, ptr %0, i32 0, i32 1
  %rel_second = load ptr, ptr %rel_second_ptr, align 8
  %is_null_second = icmp eq ptr %rel_second, null
  br i1 %is_null_second, label %rel_second_skip, label %rel_second_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_second_skip
  ret i64 0

rel_second_skip:                                  ; preds = %rel_second_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_second_do:                                    ; preds = %do_free
  call void @avra_rc_release(ptr %rel_second)
  br label %rel_second_skip
}

define i64 @__lambda_0(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %acc1, %x2
  ret i64 %add
}
