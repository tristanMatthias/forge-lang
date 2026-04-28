; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Shape = type { i64, ptr }
%Point = type { i64, i64 }
%Shape__Rect = type { ptr }

@shapes = global i64 0
@descriptions = global i64 0
@areas = global i64 0
@i = global i64 0
@total = global i64 0
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_mega_combo.av\00", align 1
@fld_name.1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.2 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.3 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_mega_combo.av\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"area\00", align 1
@mu_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_mega_combo.av\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"circle(r=\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"rect(\00", align 1
@fld_name.6 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.7 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.8 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_mega_combo.av\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@fld_name.11 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.12 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.13 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_mega_combo.av\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.match_fn.16 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file.17 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_mega_combo.av\00", align 1
@.str.18 = private unnamed_addr constant [8 x i8] c": area=\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.20 = private unnamed_addr constant [13 x i8] c"total area: \00", align 1
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

define i64 @area(ptr %0) {
entry:
  %p11 = alloca ptr, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %r3 = load i64, ptr %r2, align 8
  %r4 = load i64, ptr %r2, align 8
  %mul = mul i64 %r3, %r4
  %mul5 = mul i64 %mul, 3
  store i64 %mul5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %p_slot_base = ptrtoint ptr %payload10 to i64
  %p_slot_addr = add i64 %p_slot_base, 0
  %p_slot = inttoptr i64 %p_slot_addr to ptr
  %p = load ptr, ptr %p_slot, align 8
  call void @avra_rc_retain(ptr %p)
  store ptr %p, ptr %p11, align 8
  %p12 = load ptr, ptr %p11, align 8
  %cast = ptrtoint ptr %p12 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 101, i64 9)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p12, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %p13 = load ptr, ptr %p11, align 8
  %cast14 = ptrtoint ptr %p13 to i64
  %null_chk15 = icmp eq i64 %cast14, 0
  %null_ext16 = zext i1 %null_chk15 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 1, ptr @sty_name.2, i64 5, i64 %null_ext16, ptr @src_file.3, i64 101, i64 9)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p13, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %mul17 = mul i64 %x, %y
  store i64 %mul17, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define ptr @describe(ptr %0) {
entry:
  %p17 = alloca ptr, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm12, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast51 = inttoptr i64 %match_val to ptr
  ret ptr %cast51

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %r3 = load i64, ptr %r2, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %r3)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast4, ptr %1, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.4)
  %concat_total5 = add i64 %8, %9
  %concat_size6 = add i64 %concat_total5, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size6)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast7 = ptrtoint ptr %10 to i64
  %dst2_int8 = add i64 %cast7, %8
  %cast9 = inttoptr i64 %dst2_int8 to ptr
  %rhs_len_p110 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast9, ptr @.str.4, i64 %rhs_len_p110)
  %cast11 = ptrtoint ptr %10 to i64
  store i64 %cast11, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq14 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq14, label %march_arm12, label %march_next13

march_arm12:                                      ; preds = %march_next
  %pay_slot15 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload16 = load ptr, ptr %pay_slot15, align 8
  %p_slot_base = ptrtoint ptr %payload16 to i64
  %p_slot_addr = add i64 %p_slot_base, 0
  %p_slot = inttoptr i64 %p_slot_addr to ptr
  %p = load ptr, ptr %p_slot, align 8
  call void @avra_rc_retain(ptr %p)
  store ptr %p, ptr %p17, align 8
  %p18 = load ptr, ptr %p17, align 8
  %cast19 = ptrtoint ptr %p18 to i64
  %null_chk = icmp eq i64 %cast19, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.6, i64 1, ptr @sty_name.7, i64 5, i64 %null_ext, ptr @src_file.8, i64 101, i64 16)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p18, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.9, i64 %x)
  %widen20 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.5)
  %16 = call i64 @strlen(ptr %13)
  %concat_total21 = add i64 %15, %16
  %concat_size22 = add i64 %concat_total21, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size22)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.5, i64 %15)
  %cast23 = ptrtoint ptr %17 to i64
  %dst2_int24 = add i64 %cast23, %15
  %cast25 = inttoptr i64 %dst2_int24 to ptr
  %rhs_len_p126 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast25, ptr %13, i64 %rhs_len_p126)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.10)
  %concat_total27 = add i64 %20, %21
  %concat_size28 = add i64 %concat_total27, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size28)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast29 = ptrtoint ptr %22 to i64
  %dst2_int30 = add i64 %cast29, %20
  %cast31 = inttoptr i64 %dst2_int30 to ptr
  %rhs_len_p132 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast31, ptr @.str.10, i64 %rhs_len_p132)
  %p33 = load ptr, ptr %p17, align 8
  %cast34 = ptrtoint ptr %p33 to i64
  %null_chk35 = icmp eq i64 %cast34, 0
  %null_ext36 = zext i1 %null_chk35 to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 1, ptr @sty_name.12, i64 5, i64 %null_ext36, ptr @src_file.13, i64 101, i64 16)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p33, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.14, i64 %y)
  %widen37 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr %22)
  %28 = call i64 @strlen(ptr %25)
  %concat_total38 = add i64 %27, %28
  %concat_size39 = add i64 %concat_total38, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size39)
  %30 = call ptr @memcpy(ptr %29, ptr %22, i64 %27)
  %cast40 = ptrtoint ptr %29 to i64
  %dst2_int41 = add i64 %cast40, %27
  %cast42 = inttoptr i64 %dst2_int41 to ptr
  %rhs_len_p143 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast42, ptr %25, i64 %rhs_len_p143)
  %32 = call i64 @strlen(ptr %29)
  %33 = call i64 @strlen(ptr @.str.15)
  %concat_total44 = add i64 %32, %33
  %concat_size45 = add i64 %concat_total44, 1
  %34 = call ptr @avra_rc_alloc(i64 %concat_size45)
  %35 = call ptr @memcpy(ptr %34, ptr %29, i64 %32)
  %cast46 = ptrtoint ptr %34 to i64
  %dst2_int47 = add i64 %cast46, %32
  %cast48 = inttoptr i64 %dst2_int47 to ptr
  %rhs_len_p149 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast48, ptr @.str.15, i64 %rhs_len_p149)
  %cast50 = ptrtoint ptr %34 to i64
  store i64 %cast50, ptr %match_result, align 8
  br label %match_end

march_next13:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.16, i64 %tag, ptr @mu_file.17, i64 16)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Shape, ptr %3, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Shape, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr2, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %5, i32 0, i32 0
  store i64 3, ptr %fld_ptr, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Point, ptr %5, i32 0, i32 1
  store i64 4, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %5 to i64
  %slot_base5 = ptrtoint ptr %4 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  %cast8 = inttoptr i64 %cast4 to ptr
  store ptr %cast8, ptr %slot7, align 8
  %cast9 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %0, i64 %cast9)
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Shape, ptr %6, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %Shape, ptr %6, i32 0, i32 1
  %7 = call ptr @avra_rc_alloc(i64 8)
  store ptr %7, ptr %pay_ptr11, align 8
  %slot_base12 = ptrtoint ptr %7 to i64
  %slot_addr13 = add i64 %slot_base12, 0
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  store i64 10, ptr %slot14, align 8
  %cast15 = ptrtoint ptr %6 to i64
  call void @avra_array_push(ptr %0, i64 %cast15)
  store ptr %0, ptr @shapes, align 8
  %shapes = load ptr, ptr @shapes, align 8
  %8 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %8, i64 -559038737)
  call void @avra_array_push(ptr %8, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast16 = ptrtoint ptr %8 to i64
  %9 = call ptr @avra_array_map(ptr %shapes, i64 %cast16)
  store ptr %9, ptr @descriptions, align 8
  %shapes17 = load ptr, ptr @shapes, align 8
  %10 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %10, i64 -559038737)
  call void @avra_array_push(ptr %10, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast18 = ptrtoint ptr %10 to i64
  %11 = call ptr @avra_array_map(ptr %shapes17, i64 %cast18)
  store ptr %11, ptr @areas, align 8
  store i64 0, ptr @i, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i = load i64, ptr @i, align 8
  %slt = icmp slt i64 %i, 3
  %slt_ext = zext i1 %slt to i64
  %while_cond = icmp ne i64 %slt_ext, 0
  br i1 %while_cond, label %while.body, label %while.exit

while.body:                                       ; preds = %while.cond
  %descriptions = load ptr, ptr @descriptions, align 8
  %i19 = load i64, ptr @i, align 8
  %12 = call i64 @avra_array_get(ptr %descriptions, i64 %i19)
  %lhs_ptr = inttoptr i64 %12 to ptr
  %13 = call i64 @strlen(ptr %lhs_ptr)
  %14 = call i64 @strlen(ptr @.str.18)
  %concat_total = add i64 %13, %14
  %concat_size = add i64 %concat_total, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size)
  %16 = call ptr @memcpy(ptr %15, ptr %lhs_ptr, i64 %13)
  %cast20 = ptrtoint ptr %15 to i64
  %dst2_int = add i64 %cast20, %13
  %cast21 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast21, ptr @.str.18, i64 %rhs_len_p1)
  %areas = load ptr, ptr @areas, align 8
  %i22 = load i64, ptr @i, align 8
  %18 = call i64 @avra_array_get(ptr %areas, i64 %i22)
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.19, i64 %18)
  %widen = sext i32 %20 to i64
  %21 = call i64 @strlen(ptr %15)
  %22 = call i64 @strlen(ptr %19)
  %concat_total23 = add i64 %21, %22
  %concat_size24 = add i64 %concat_total23, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size24)
  %24 = call ptr @memcpy(ptr %23, ptr %15, i64 %21)
  %cast25 = ptrtoint ptr %23 to i64
  %dst2_int26 = add i64 %cast25, %21
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast27, ptr %19, i64 %rhs_len_p128)
  %26 = call i32 @puts(ptr %23)
  %widen29 = sext i32 %26 to i64
  %i30 = load i64, ptr @i, align 8
  %add = add i64 %i30, 1
  store i64 %add, ptr @i, align 8
  br label %while.cond

while.exit:                                       ; preds = %while.cond
  %areas31 = load ptr, ptr @areas, align 8
  %27 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %27, i64 -559038737)
  call void @avra_array_push(ptr %27, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast32 = ptrtoint ptr %27 to i64
  %28 = call i64 @avra_array_reduce(ptr %areas31, i64 0, i64 %cast32)
  store i64 %28, ptr @total, align 8
  %total = load i64, ptr @total, align 8
  %29 = call ptr @avra_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.21, i64 %total)
  %widen33 = sext i32 %30 to i64
  %31 = call i64 @strlen(ptr @.str.20)
  %32 = call i64 @strlen(ptr %29)
  %concat_total34 = add i64 %31, %32
  %concat_size35 = add i64 %concat_total34, 1
  %33 = call ptr @avra_rc_alloc(i64 %concat_size35)
  %34 = call ptr @memcpy(ptr %33, ptr @.str.20, i64 %31)
  %cast36 = ptrtoint ptr %33 to i64
  %dst2_int37 = add i64 %cast36, %31
  %cast38 = inttoptr i64 %dst2_int37 to ptr
  %rhs_len_p139 = add i64 %32, 1
  %35 = call ptr @memcpy(ptr %cast38, ptr %29, i64 %rhs_len_p139)
  %36 = call i32 @puts(ptr %33)
  %widen40 = sext i32 %36 to i64
  %37 = call i32 @avra_test_summary()
  %widen41 = sext i32 %37 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Shape(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Rect = icmp eq i64 %tag, 6384501107
  br i1 %is_Rect, label %rel_Rect, label %try_next_Rect

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Rect, %vrel_p_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Rect:                                         ; preds = %do_free
  %vrel_p_ptr = getelementptr inbounds nuw %Shape__Rect, ptr %payload, i32 0, i32 0
  %vrel_p = load ptr, ptr %vrel_p_ptr, align 8
  %vrel_null_p = icmp eq ptr %vrel_p, null
  br i1 %vrel_null_p, label %vrel_p_skip, label %vrel_p_do

try_next_Rect:                                    ; preds = %do_free
  br label %fields_done

vrel_p_skip:                                      ; preds = %vrel_p_do, %rel_Rect
  br label %fields_done

vrel_p_do:                                        ; preds = %rel_Rect
  call void @avra_rc_release(ptr %vrel_p)
  br label %vrel_p_skip
}

define i64 @__lambda_0(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call ptr @describe(ptr %s1)
  %cast = ptrtoint ptr %1 to i64
  ret i64 %cast
}

define i64 @__lambda_1(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i64 @area(ptr %s1)
  ret i64 %1
}

define i64 @__lambda_2(i64 %0, i64 %1) {
entry:
  %a = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %a, align 8
  %acc1 = load i64, ptr %acc, align 8
  %a2 = load i64, ptr %a, align 8
  %add = add i64 %acc1, %a2
  ret i64 %add
}
