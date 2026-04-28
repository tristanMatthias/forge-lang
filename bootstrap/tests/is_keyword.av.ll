; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Color = type { i64, ptr }
%Option = type { i64, ptr }

@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"blue\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"has value\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"empty\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [11 x i8] c"warm color\00", align 1

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
  %c = alloca ptr, align 8
  store ptr %0, ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %c1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 193469728
  %is_eq_ext = zext i1 %is_eq to i64
  %if_cond = icmp ne i64 %is_eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %c2 = load ptr, ptr %c, align 8
  %tag_ptr3 = getelementptr inbounds nuw %Color, ptr %c2, i32 0, i32 0
  %tag4 = load i64, ptr %tag_ptr3, align 8
  %is_eq5 = icmp eq i64 %tag4, 210675960374
  %is_eq_ext6 = zext i1 %is_eq5 to i64
  %if_cond8 = icmp ne i64 %is_eq_ext6, 0
  br i1 %if_cond8, label %if_then9, label %if_else10

if_then:                                          ; preds = %entry
  ret ptr @.str

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont7:                                          ; preds = %if_else10
  ret ptr @.str.2

if_then9:                                         ; preds = %ifcont
  ret ptr @.str.1

if_else10:                                        ; preds = %ifcont
  br label %ifcont7
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %sif_result = alloca i64, align 8
  %x = alloca ptr, align 8
  %empty = alloca ptr, align 8
  %opt = alloca ptr, align 8
  %c = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %c, align 8
  %c2 = load ptr, ptr %c, align 8
  %tag_ptr3 = getelementptr inbounds nuw %Color, ptr %c2, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr3, align 8
  %is_eq = icmp eq i64 %tag, 193469728
  %is_eq_ext = zext i1 %is_eq to i64
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %is_eq_ext)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen4 = sext i32 %4 to i64
  %c5 = load ptr, ptr %c, align 8
  %tag_ptr6 = getelementptr inbounds nuw %Color, ptr %c5, i32 0, i32 0
  %tag7 = load i64, ptr %tag_ptr6, align 8
  %is_eq8 = icmp eq i64 %tag7, 6383934317
  %is_eq_ext9 = zext i1 %is_eq8 to i64
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.3, i64 %is_eq_ext9)
  %widen10 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen11 = sext i32 %7 to i64
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr12 = getelementptr inbounds nuw %Color, ptr %8, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr12, align 8
  %pay_ptr13 = getelementptr inbounds nuw %Color, ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr13, align 8
  %cast14 = ptrtoint ptr %8 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  %9 = call ptr @describe(ptr %cast15)
  %10 = call i32 @puts(ptr %9)
  %widen16 = sext i32 %10 to i64
  %11 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr17 = getelementptr inbounds nuw %Color, ptr %11, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr17, align 8
  %pay_ptr18 = getelementptr inbounds nuw %Color, ptr %11, i32 0, i32 1
  store ptr null, ptr %pay_ptr18, align 8
  %cast19 = ptrtoint ptr %11 to i64
  %cast20 = inttoptr i64 %cast19 to ptr
  %12 = call ptr @describe(ptr %cast20)
  %13 = call i32 @puts(ptr %12)
  %widen21 = sext i32 %13 to i64
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr22 = getelementptr inbounds nuw %Color, ptr %14, i32 0, i32 0
  store i64 6383934317, ptr %tag_ptr22, align 8
  %pay_ptr23 = getelementptr inbounds nuw %Color, ptr %14, i32 0, i32 1
  store ptr null, ptr %pay_ptr23, align 8
  %cast24 = ptrtoint ptr %14 to i64
  %cast25 = inttoptr i64 %cast24 to ptr
  %15 = call ptr @describe(ptr %cast25)
  %16 = call i32 @puts(ptr %15)
  %widen26 = sext i32 %16 to i64
  %17 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr27 = getelementptr inbounds nuw %Option, ptr %17, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr27, align 8
  %pay_ptr28 = getelementptr inbounds nuw %Option, ptr %17, i32 0, i32 1
  %18 = call ptr @avra_rc_alloc(i64 8)
  store ptr %18, ptr %pay_ptr28, align 8
  %slot_base = ptrtoint ptr %18 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast29 = ptrtoint ptr %17 to i64
  %cast30 = inttoptr i64 %cast29 to ptr
  store ptr %cast30, ptr %opt, align 8
  %opt31 = load ptr, ptr %opt, align 8
  %tag_ptr32 = getelementptr inbounds nuw %Option, ptr %opt31, i32 0, i32 0
  %tag33 = load i64, ptr %tag_ptr32, align 8
  %is_eq34 = icmp eq i64 %tag33, 6384548249
  %is_eq_ext35 = zext i1 %is_eq34 to i64
  %if_cond = icmp ne i64 %is_eq_ext35, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %opt37 = load ptr, ptr %opt, align 8
  %tag_ptr38 = getelementptr inbounds nuw %Option, ptr %opt37, i32 0, i32 0
  %tag39 = load i64, ptr %tag_ptr38, align 8
  %is_eq40 = icmp eq i64 %tag39, 6384368597
  %is_eq_ext41 = zext i1 %is_eq40 to i64
  %if_cond43 = icmp ne i64 %is_eq_ext41, 0
  br i1 %if_cond43, label %if_then44, label %if_else45

if_then:                                          ; preds = %entry
  %19 = call i32 @puts(ptr @.str.4)
  %widen36 = sext i32 %19 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont42:                                         ; preds = %if_else45, %if_then44
  %20 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr47 = getelementptr inbounds nuw %Option, ptr %20, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr47, align 8
  %pay_ptr48 = getelementptr inbounds nuw %Option, ptr %20, i32 0, i32 1
  store ptr null, ptr %pay_ptr48, align 8
  %cast49 = ptrtoint ptr %20 to i64
  %cast50 = inttoptr i64 %cast49 to ptr
  store ptr %cast50, ptr %empty, align 8
  %empty51 = load ptr, ptr %empty, align 8
  %tag_ptr52 = getelementptr inbounds nuw %Option, ptr %empty51, i32 0, i32 0
  %tag53 = load i64, ptr %tag_ptr52, align 8
  %is_eq54 = icmp eq i64 %tag53, 6384368597
  %is_eq_ext55 = zext i1 %is_eq54 to i64
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.6, i64 %is_eq_ext55)
  %widen56 = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen57 = sext i32 %23 to i64
  %empty58 = load ptr, ptr %empty, align 8
  %tag_ptr59 = getelementptr inbounds nuw %Option, ptr %empty58, i32 0, i32 0
  %tag60 = load i64, ptr %tag_ptr59, align 8
  %is_eq61 = icmp eq i64 %tag60, 6384548249
  %is_eq_ext62 = zext i1 %is_eq61 to i64
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.7, i64 %is_eq_ext62)
  %widen63 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen64 = sext i32 %26 to i64
  %27 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr65 = getelementptr inbounds nuw %Color, ptr %27, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr65, align 8
  %pay_ptr66 = getelementptr inbounds nuw %Color, ptr %27, i32 0, i32 1
  store ptr null, ptr %pay_ptr66, align 8
  %cast67 = ptrtoint ptr %27 to i64
  %cast68 = inttoptr i64 %cast67 to ptr
  store ptr %cast68, ptr %x, align 8
  %x69 = load ptr, ptr %x, align 8
  %tag_ptr70 = getelementptr inbounds nuw %Color, ptr %x69, i32 0, i32 0
  %tag71 = load i64, ptr %tag_ptr70, align 8
  %is_eq72 = icmp eq i64 %tag71, 193469728
  %is_eq_ext73 = zext i1 %is_eq72 to i64
  %l_bool = icmp ne i64 %is_eq_ext73, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

if_then44:                                        ; preds = %ifcont
  %28 = call i32 @puts(ptr @.str.5)
  %widen46 = sext i32 %28 to i64
  br label %ifcont42

if_else45:                                        ; preds = %ifcont
  br label %ifcont42

sc_rhs:                                           ; preds = %ifcont42
  %x74 = load ptr, ptr %x, align 8
  %tag_ptr75 = getelementptr inbounds nuw %Color, ptr %x74, i32 0, i32 0
  %tag76 = load i64, ptr %tag_ptr75, align 8
  %is_eq77 = icmp eq i64 %tag76, 210675960374
  %is_eq_ext78 = zext i1 %is_eq77 to i64
  %r_bool = icmp ne i64 %is_eq_ext78, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %ifcont42
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ true, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %sif_cond = icmp ne i64 %sc_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

sif_then:                                         ; preds = %sc_merge
  %29 = call i32 @puts(ptr @.str.8)
  %widen79 = sext i32 %29 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %sc_merge
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
