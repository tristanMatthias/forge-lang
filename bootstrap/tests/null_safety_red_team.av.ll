; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Config = type { i64 }

@fld_name = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/null_safety_red_team.av\00", align 1
@.str = private unnamed_addr constant [8 x i8] c"found: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"fallback: \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"chained: hello\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"exists\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"default\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"chained null: \00", align 1
@.str.7 = private unnamed_addr constant [13 x i8] c"propagated: \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [18 x i8] c"propagated null: \00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @find_val(ptr %0, i64 %1) {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %target = alloca i64, align 8
  %items = alloca ptr, align 8
  store ptr %0, ptr %items, align 8
  store i64 %1, ptr %target, align 8
  %items1 = load ptr, ptr %items, align 8
  %2 = call i64 @avra_array_len(ptr %items1)
  store i64 0, ptr %i, align 8
  store i64 %2, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i2 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i2, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %items3 = load ptr, ptr %items, align 8
  %i4 = load i64, ptr %i, align 8
  %3 = call i64 @avra_array_get(ptr %items3, i64 %i4)
  %target5 = load i64, ptr %target, align 8
  %eq = icmp eq i64 %3, %target5
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

for.incr:                                         ; preds = %ifcont
  %i8 = load i64, ptr %i, align 8
  %for_next = add i64 %i8, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  ret i64 0

ifcont:                                           ; preds = %if_else
  br label %for.incr

if_then:                                          ; preds = %for.body
  %items6 = load ptr, ptr %items, align 8
  %i7 = load i64, ptr %i, align 8
  %4 = call i64 @avra_array_get(ptr %items6, i64 %i7)
  ret i64 %4

if_else:                                          ; preds = %for.body
  br label %ifcont
}

define ptr @get_config(i1 %0) {
entry:
  %sif_result = alloca i64, align 8
  %valid = alloca i1, align 1
  store i1 %0, ptr %valid, align 8
  %valid1 = load i1, ptr %valid, align 8
  store i64 0, ptr %sif_result, align 8
  br i1 %valid1, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %1 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 0
  store i64 8080, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast2 = inttoptr i64 %sif_val to ptr
  ret ptr %cast2
}

define i64 @try_port(i1 %0) {
entry:
  %cfg = alloca ptr, align 8
  %valid = alloca i1, align 1
  store i1 %0, ptr %valid, align 8
  %valid1 = load i1, ptr %valid, align 8
  %1 = call ptr @get_config(i1 %valid1)
  %try_null = icmp eq ptr %1, null
  br i1 %try_null, label %try_ret, label %try_ok

try_ok:                                           ; preds = %entry
  store ptr %1, ptr %cfg, align 8
  %cfg2 = load ptr, ptr %cfg, align 8
  %cast = ptrtoint ptr %cfg2 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 106, i64 23)
  %port_ptr = getelementptr inbounds nuw %Config, ptr %cfg2, i32 0, i32 0
  %port = load i64, ptr %port_ptr, align 8
  ret i64 %port

try_ret:                                          ; preds = %entry
  ret i64 0
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %nc_result54 = alloca i64, align 8
  %port2 = alloca i64, align 8
  %nc_result40 = alloca i64, align 8
  %port = alloca i64, align 8
  %msg = alloca ptr, align 8
  %ife_result = alloca i64, align 8
  %cfg2 = alloca ptr, align 8
  %cfg = alloca ptr, align 8
  %v = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %r25 = alloca i64, align 8
  %r = alloca i64, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 10)
  call void @avra_array_push(ptr %1, i64 20)
  call void @avra_array_push(ptr %1, i64 30)
  %2 = call i64 @find_val(ptr %1, i64 20)
  store i64 %2, ptr %r, align 8
  %r1 = load i64, ptr %r, align 8
  %ne = icmp ne i64 %r1, 0
  %ne_ext = zext i1 %ne to i64
  %if_cond = icmp ne i64 %ne_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 10)
  call void @avra_array_push(ptr %3, i64 20)
  call void @avra_array_push(ptr %3, i64 30)
  %4 = call i64 @find_val(ptr %3, i64 99)
  store i64 %4, ptr %r25, align 8
  %r26 = load i64, ptr %r25, align 8
  %nc_null = icmp eq i64 %r26, 0
  store i64 %r26, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

if_then:                                          ; preds = %entry
  %r2 = load i64, ptr %r, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %r2)
  %widen = sext i32 %6 to i64
  %7 = call i64 @strlen(ptr @.str)
  %8 = call i64 @strlen(ptr %5)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str, i64 %7)
  %cast = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast, %7
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast3, ptr %5, i64 %rhs_len_p1)
  %12 = call i32 @puts(ptr %9)
  %widen4 = sext i32 %12 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  br label %ifcont

nc_rhs:                                           ; preds = %ifcont
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %ifcont
  %nc_val = load i64, ptr %nc_result, align 8
  store i64 %nc_val, ptr %v, align 8
  %v7 = load i64, ptr %v, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.2, i64 %v7)
  %widen8 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.1)
  %16 = call i64 @strlen(ptr %13)
  %concat_total9 = add i64 %15, %16
  %concat_size10 = add i64 %concat_total9, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size10)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.1, i64 %15)
  %cast11 = ptrtoint ptr %17 to i64
  %dst2_int12 = add i64 %cast11, %15
  %cast13 = inttoptr i64 %dst2_int12 to ptr
  %rhs_len_p114 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast13, ptr %13, i64 %rhs_len_p114)
  %20 = call i32 @puts(ptr %17)
  %widen15 = sext i32 %20 to i64
  %21 = call ptr @get_config(i1 true)
  store ptr %21, ptr %cfg, align 8
  %cfg16 = load ptr, ptr %cfg, align 8
  %ne17 = icmp ne ptr %cfg16, null
  %ne_ext18 = zext i1 %ne17 to i64
  %if_cond20 = icmp ne i64 %ne_ext18, 0
  br i1 %if_cond20, label %if_then21, label %if_else22

ifcont19:                                         ; preds = %if_else22, %if_then21
  %22 = call ptr @get_config(i1 false)
  store ptr %22, ptr %cfg2, align 8
  %cfg224 = load ptr, ptr %cfg2, align 8
  %ne25 = icmp ne ptr %cfg224, null
  %ne_ext26 = zext i1 %ne25 to i64
  %ife_cond = icmp ne i64 %ne_ext26, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

if_then21:                                        ; preds = %nc_end
  %23 = call i32 @puts(ptr @.str.3)
  %widen23 = sext i32 %23 to i64
  br label %ifcont19

if_else22:                                        ; preds = %nc_end
  br label %ifcont19

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %cast27 = inttoptr i64 %ife_val to ptr
  store ptr %cast27, ptr %msg, align 8
  %msg28 = load ptr, ptr %msg, align 8
  %24 = call i64 @strlen(ptr @.str.6)
  %25 = call i64 @strlen(ptr %msg28)
  %concat_total29 = add i64 %24, %25
  %concat_size30 = add i64 %concat_total29, 1
  %26 = call ptr @avra_rc_alloc(i64 %concat_size30)
  %27 = call ptr @memcpy(ptr %26, ptr @.str.6, i64 %24)
  %cast31 = ptrtoint ptr %26 to i64
  %dst2_int32 = add i64 %cast31, %24
  %cast33 = inttoptr i64 %dst2_int32 to ptr
  %rhs_len_p134 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast33, ptr %msg28, i64 %rhs_len_p134)
  %29 = call i32 @puts(ptr %26)
  %widen35 = sext i32 %29 to i64
  %30 = call i64 @try_port(i1 true)
  store i64 %30, ptr %port, align 8
  %port36 = load i64, ptr %port, align 8
  %nc_null37 = icmp eq i64 %port36, 0
  store i64 %port36, ptr %nc_result40, align 8
  br i1 %nc_null37, label %nc_rhs38, label %nc_end39

ife_then:                                         ; preds = %ifcont19
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %ifcont19
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %ife_result, align 8
  br label %ife_end

nc_rhs38:                                         ; preds = %ife_end
  store i64 0, ptr %nc_result40, align 8
  br label %nc_end39

nc_end39:                                         ; preds = %nc_rhs38, %ife_end
  %nc_val41 = load i64, ptr %nc_result40, align 8
  %31 = call ptr @avra_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.8, i64 %nc_val41)
  %widen42 = sext i32 %32 to i64
  %33 = call i64 @strlen(ptr @.str.7)
  %34 = call i64 @strlen(ptr %31)
  %concat_total43 = add i64 %33, %34
  %concat_size44 = add i64 %concat_total43, 1
  %35 = call ptr @avra_rc_alloc(i64 %concat_size44)
  %36 = call ptr @memcpy(ptr %35, ptr @.str.7, i64 %33)
  %cast45 = ptrtoint ptr %35 to i64
  %dst2_int46 = add i64 %cast45, %33
  %cast47 = inttoptr i64 %dst2_int46 to ptr
  %rhs_len_p148 = add i64 %34, 1
  %37 = call ptr @memcpy(ptr %cast47, ptr %31, i64 %rhs_len_p148)
  %38 = call i32 @puts(ptr %35)
  %widen49 = sext i32 %38 to i64
  %39 = call i64 @try_port(i1 false)
  store i64 %39, ptr %port2, align 8
  %port250 = load i64, ptr %port2, align 8
  %nc_null51 = icmp eq i64 %port250, 0
  store i64 %port250, ptr %nc_result54, align 8
  br i1 %nc_null51, label %nc_rhs52, label %nc_end53

nc_rhs52:                                         ; preds = %nc_end39
  store i64 -1, ptr %nc_result54, align 8
  br label %nc_end53

nc_end53:                                         ; preds = %nc_rhs52, %nc_end39
  %nc_val55 = load i64, ptr %nc_result54, align 8
  %40 = call ptr @avra_rc_alloc(i64 32)
  %41 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %40, i64 32, ptr @.i2s_fmt.10, i64 %nc_val55)
  %widen56 = sext i32 %41 to i64
  %42 = call i64 @strlen(ptr @.str.9)
  %43 = call i64 @strlen(ptr %40)
  %concat_total57 = add i64 %42, %43
  %concat_size58 = add i64 %concat_total57, 1
  %44 = call ptr @avra_rc_alloc(i64 %concat_size58)
  %45 = call ptr @memcpy(ptr %44, ptr @.str.9, i64 %42)
  %cast59 = ptrtoint ptr %44 to i64
  %dst2_int60 = add i64 %cast59, %42
  %cast61 = inttoptr i64 %dst2_int60 to ptr
  %rhs_len_p162 = add i64 %43, 1
  %46 = call ptr @memcpy(ptr %cast61, ptr %40, i64 %rhs_len_p162)
  %47 = call i32 @puts(ptr %44)
  %widen63 = sext i32 %47 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
