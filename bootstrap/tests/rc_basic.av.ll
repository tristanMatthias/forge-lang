; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { i64, i64 }
%Color = type { i64, ptr }
%Color__Blue = type { ptr }

@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/rc_basic.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.2 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.3 = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/rc_basic.av\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"red-variant\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/rc_basic.av\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@fld_name.7 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.8 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.9 = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/rc_basic.av\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.12 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.13 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.14 = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/rc_basic.av\00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.17 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.19 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c")\00", align 1

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

define ptr @make_point(i64 %0, i64 %1) {
entry:
  %y = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %y, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %x1 = load i64, ptr %x, align 8
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 0
  store i64 %x1, ptr %fld_ptr, align 8
  %y2 = load i64, ptr %y, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 1
  store i64 %y2, ptr %fld_ptr3, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast4 = inttoptr i64 %cast to ptr
  ret ptr %cast4
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %t = alloca ptr, align 8
  %p2 = alloca ptr, align 8
  %name17 = alloca ptr, align 8
  %match_stmt_discard = alloca i64, align 8
  %c = alloca ptr, align 8
  %p = alloca ptr, align 8
  %1 = call ptr @make_point(i64 10, i64 20)
  store ptr %1, ptr %p, align 8
  %p1 = load ptr, ptr %p, align 8
  %cast = ptrtoint ptr %p1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 94, i64 16)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen2 = sext i32 %4 to i64
  %p3 = load ptr, ptr %p, align 8
  %cast4 = ptrtoint ptr %p3 to i64
  %null_chk5 = icmp eq i64 %cast4, 0
  %null_ext6 = zext i1 %null_chk5 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 1, ptr @sty_name.2, i64 5, i64 %null_ext6, ptr @src_file.3, i64 94, i64 17)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p3, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.4, i64 %y)
  %widen7 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen8 = sext i32 %7 to i64
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %8, i32 0, i32 0
  store i64 6383934317, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 8)
  store ptr %9, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %9 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast9 = ptrtoint ptr %8 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  store ptr %cast10, ptr %c, align 8
  %c11 = load ptr, ptr %c, align 8
  %tag_ptr12 = getelementptr inbounds nuw %Color, ptr %c11, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr12, align 8
  %tag_eq = icmp eq i64 %tag, 193469728
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm14, %march_arm
  %p20 = load ptr, ptr %p, align 8
  %10 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Point, ptr %p20, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Point, ptr %10, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src21 = getelementptr inbounds nuw %Point, ptr %p20, i32 0, i32 1
  %with_cp_val22 = load i64, ptr %with_cp_src21, align 8
  %with_cp_dst23 = getelementptr inbounds nuw %Point, ptr %10, i32 0, i32 1
  store i64 %with_cp_val22, ptr %with_cp_dst23, align 8
  %with_ovr = getelementptr inbounds nuw %Point, ptr %10, i32 0, i32 0
  store i64 30, ptr %with_ovr, align 8
  %with_ovr24 = getelementptr inbounds nuw %Point, ptr %10, i32 0, i32 1
  store i64 40, ptr %with_ovr24, align 8
  %cast25 = ptrtoint ptr %10 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  store ptr %cast26, ptr %p2, align 8
  %p227 = load ptr, ptr %p2, align 8
  %cast28 = ptrtoint ptr %p227 to i64
  %null_chk29 = icmp eq i64 %cast28, 0
  %null_ext30 = zext i1 %null_chk29 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 1, ptr @sty_name.8, i64 5, i64 %null_ext30, ptr @src_file.9, i64 94, i64 28)
  %x_ptr31 = getelementptr inbounds nuw %Point, ptr %p227, i32 0, i32 0
  %x32 = load i64, ptr %x_ptr31, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.10, i64 %x32)
  %widen33 = sext i32 %12 to i64
  %13 = call i64 @strlen(ptr @.str.6)
  %14 = call i64 @strlen(ptr %11)
  %concat_total = add i64 %13, %14
  %concat_size = add i64 %concat_total, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size)
  %16 = call ptr @memcpy(ptr %15, ptr @.str.6, i64 %13)
  %cast34 = ptrtoint ptr %15 to i64
  %dst2_int = add i64 %cast34, %13
  %cast35 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast35, ptr %11, i64 %rhs_len_p1)
  %18 = call i64 @strlen(ptr %15)
  %19 = call i64 @strlen(ptr @.str.11)
  %concat_total36 = add i64 %18, %19
  %concat_size37 = add i64 %concat_total36, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size37)
  %21 = call ptr @memcpy(ptr %20, ptr %15, i64 %18)
  %cast38 = ptrtoint ptr %20 to i64
  %dst2_int39 = add i64 %cast38, %18
  %cast40 = inttoptr i64 %dst2_int39 to ptr
  %rhs_len_p141 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast40, ptr @.str.11, i64 %rhs_len_p141)
  %p242 = load ptr, ptr %p2, align 8
  %cast43 = ptrtoint ptr %p242 to i64
  %null_chk44 = icmp eq i64 %cast43, 0
  %null_ext45 = zext i1 %null_chk44 to i64
  call void @avra_null_deref_trap(ptr @fld_name.12, i64 1, ptr @sty_name.13, i64 5, i64 %null_ext45, ptr @src_file.14, i64 94, i64 28)
  %y_ptr46 = getelementptr inbounds nuw %Point, ptr %p242, i32 0, i32 1
  %y47 = load i64, ptr %y_ptr46, align 8
  %23 = call ptr @avra_rc_alloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @.i2s_fmt.15, i64 %y47)
  %widen48 = sext i32 %24 to i64
  %25 = call i64 @strlen(ptr %20)
  %26 = call i64 @strlen(ptr %23)
  %concat_total49 = add i64 %25, %26
  %concat_size50 = add i64 %concat_total49, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size50)
  %28 = call ptr @memcpy(ptr %27, ptr %20, i64 %25)
  %cast51 = ptrtoint ptr %27 to i64
  %dst2_int52 = add i64 %cast51, %25
  %cast53 = inttoptr i64 %dst2_int52 to ptr
  %rhs_len_p154 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast53, ptr %23, i64 %rhs_len_p154)
  %30 = call i64 @strlen(ptr %27)
  %31 = call i64 @strlen(ptr @.str.16)
  %concat_total55 = add i64 %30, %31
  %concat_size56 = add i64 %concat_total55, 1
  %32 = call ptr @avra_rc_alloc(i64 %concat_size56)
  %33 = call ptr @memcpy(ptr %32, ptr %27, i64 %30)
  %cast57 = ptrtoint ptr %32 to i64
  %dst2_int58 = add i64 %cast57, %30
  %cast59 = inttoptr i64 %dst2_int58 to ptr
  %rhs_len_p160 = add i64 %31, 1
  %34 = call ptr @memcpy(ptr %cast59, ptr @.str.16, i64 %rhs_len_p160)
  %35 = call i32 @puts(ptr %32)
  %widen61 = sext i32 %35 to i64
  %36 = call ptr @avra_rc_alloc(i64 16)
  %slot_base62 = ptrtoint ptr %36 to i64
  %slot_addr63 = add i64 %slot_base62, 0
  %slot64 = inttoptr i64 %slot_addr63 to ptr
  store i64 1, ptr %slot64, align 8
  %slot_base65 = ptrtoint ptr %36 to i64
  %slot_addr66 = add i64 %slot_base65, 8
  %slot67 = inttoptr i64 %slot_addr66 to ptr
  store i64 2, ptr %slot67, align 8
  %cast68 = ptrtoint ptr %36 to i64
  %cast69 = inttoptr i64 %cast68 to ptr
  store ptr %cast69, ptr %t, align 8
  %t70 = load ptr, ptr %t, align 8
  %tup_val_slot_base = ptrtoint ptr %t70 to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  %37 = call ptr @avra_rc_alloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @.i2s_fmt.18, i64 %tup_val)
  %widen71 = sext i32 %38 to i64
  %39 = call i64 @strlen(ptr @.str.17)
  %40 = call i64 @strlen(ptr %37)
  %concat_total72 = add i64 %39, %40
  %concat_size73 = add i64 %concat_total72, 1
  %41 = call ptr @avra_rc_alloc(i64 %concat_size73)
  %42 = call ptr @memcpy(ptr %41, ptr @.str.17, i64 %39)
  %cast74 = ptrtoint ptr %41 to i64
  %dst2_int75 = add i64 %cast74, %39
  %cast76 = inttoptr i64 %dst2_int75 to ptr
  %rhs_len_p177 = add i64 %40, 1
  %43 = call ptr @memcpy(ptr %cast76, ptr %37, i64 %rhs_len_p177)
  %44 = call i64 @strlen(ptr %41)
  %45 = call i64 @strlen(ptr @.str.19)
  %concat_total78 = add i64 %44, %45
  %concat_size79 = add i64 %concat_total78, 1
  %46 = call ptr @avra_rc_alloc(i64 %concat_size79)
  %47 = call ptr @memcpy(ptr %46, ptr %41, i64 %44)
  %cast80 = ptrtoint ptr %46 to i64
  %dst2_int81 = add i64 %cast80, %44
  %cast82 = inttoptr i64 %dst2_int81 to ptr
  %rhs_len_p183 = add i64 %45, 1
  %48 = call ptr @memcpy(ptr %cast82, ptr @.str.19, i64 %rhs_len_p183)
  %t84 = load ptr, ptr %t, align 8
  %tup_val_slot_base85 = ptrtoint ptr %t84 to i64
  %tup_val_slot_addr86 = add i64 %tup_val_slot_base85, 8
  %tup_val_slot87 = inttoptr i64 %tup_val_slot_addr86 to ptr
  %tup_val88 = load i64, ptr %tup_val_slot87, align 8
  %49 = call ptr @avra_rc_alloc(i64 32)
  %50 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %49, i64 32, ptr @.i2s_fmt.20, i64 %tup_val88)
  %widen89 = sext i32 %50 to i64
  %51 = call i64 @strlen(ptr %46)
  %52 = call i64 @strlen(ptr %49)
  %concat_total90 = add i64 %51, %52
  %concat_size91 = add i64 %concat_total90, 1
  %53 = call ptr @avra_rc_alloc(i64 %concat_size91)
  %54 = call ptr @memcpy(ptr %53, ptr %46, i64 %51)
  %cast92 = ptrtoint ptr %53 to i64
  %dst2_int93 = add i64 %cast92, %51
  %cast94 = inttoptr i64 %dst2_int93 to ptr
  %rhs_len_p195 = add i64 %52, 1
  %55 = call ptr @memcpy(ptr %cast94, ptr %49, i64 %rhs_len_p195)
  %56 = call i64 @strlen(ptr %53)
  %57 = call i64 @strlen(ptr @.str.21)
  %concat_total96 = add i64 %56, %57
  %concat_size97 = add i64 %concat_total96, 1
  %58 = call ptr @avra_rc_alloc(i64 %concat_size97)
  %59 = call ptr @memcpy(ptr %58, ptr %53, i64 %56)
  %cast98 = ptrtoint ptr %58 to i64
  %dst2_int99 = add i64 %cast98, %56
  %cast100 = inttoptr i64 %dst2_int99 to ptr
  %rhs_len_p1101 = add i64 %57, 1
  %60 = call ptr @memcpy(ptr %cast100, ptr @.str.21, i64 %rhs_len_p1101)
  %61 = call i32 @puts(ptr %58)
  %widen102 = sext i32 %61 to i64
  %p2_cleanup = load ptr, ptr %p2, align 8
  call void @avra_rc_release(ptr %p2_cleanup)
  ret i64 0

march_arm:                                        ; preds = %entry
  %62 = call i32 @puts(ptr @.str.5)
  %widen13 = sext i32 %62 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq16 = icmp eq i64 %tag, 6383934317
  br i1 %tag_eq16, label %march_arm14, label %march_next15

march_arm14:                                      ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %Color, ptr %c11, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %name_slot_base = ptrtoint ptr %payload to i64
  %name_slot_addr = add i64 %name_slot_base, 0
  %name_slot = inttoptr i64 %name_slot_addr to ptr
  %name = load ptr, ptr %name_slot, align 8
  call void @avra_rc_retain(ptr %name)
  store ptr %name, ptr %name17, align 8
  %name18 = load ptr, ptr %name17, align 8
  %63 = call i32 @puts(ptr %name18)
  %widen19 = sext i32 %63 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next15:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 21)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Color(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Blue = icmp eq i64 %tag, 6383934317
  br i1 %is_Blue, label %rel_Blue, label %try_next_Blue

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Blue, %vrel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Blue:                                         ; preds = %do_free
  %vrel_name_ptr = getelementptr inbounds nuw %Color__Blue, ptr %payload, i32 0, i32 0
  %vrel_name = load ptr, ptr %vrel_name_ptr, align 8
  %vrel_null_name = icmp eq ptr %vrel_name, null
  br i1 %vrel_null_name, label %vrel_name_skip, label %vrel_name_do

try_next_Blue:                                    ; preds = %do_free
  br label %fields_done

vrel_name_skip:                                   ; preds = %vrel_name_do, %rel_Blue
  br label %fields_done

vrel_name_do:                                     ; preds = %rel_Blue
  call void @avra_rc_release(ptr %vrel_name)
  br label %vrel_name_skip
}
