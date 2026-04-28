; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@dz_file = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/std_core.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.float_str.3 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c" world\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [9 x i8] c"div ok: \00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [18 x i8] c"div by zero: null\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @double(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @safe_div(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %b1 = load i64, ptr %b, align 8
  %eq = icmp eq i64 %b1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %a2 = load i64, ptr %a, align 8
  %b3 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b3, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 94, i64 8)
  %div = sdiv i64 %a2, %b3
  ret i64 %div

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %f3 = alloca ptr, align 8
  %val = alloca i64, align 8
  %nc_result73 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %r2 = alloca i64, align 8
  %r1 = alloca i64, align 8
  %s = alloca ptr, align 8
  %f2 = alloca i1, align 1
  %t = alloca i1, align 1
  %g = alloca double, align 8
  %f = alloca double, align 8
  %x = alloca i64, align 8
  store i64 42, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x1)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen2 = sext i32 %3 to i64
  %x3 = load i64, ptr %x, align 8
  %add = add i64 %x3, 8
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt.1, i64 %add)
  %widen4 = sext i32 %5 to i64
  %6 = call i32 @puts(ptr %4)
  %widen5 = sext i32 %6 to i64
  %x6 = load i64, ptr %x, align 8
  %neg = sub i64 0, %x6
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.2, i64 %neg)
  %widen7 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen8 = sext i32 %9 to i64
  %10 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %10 to double
  store double %cast, ptr %f, align 8
  %f9 = load double, ptr %f, align 8
  %cast10 = bitcast double %f9 to i64
  %11 = call i64 @avra_float_to_string(i64 %cast10)
  %cast11 = inttoptr i64 %11 to ptr
  %12 = call i32 @puts(ptr %cast11)
  %widen12 = sext i32 %12 to i64
  %f13 = load double, ptr %f, align 8
  %13 = call i64 @avra_float_parse(ptr @.float_str.3)
  %cast14 = bitcast i64 %13 to double
  %fadd = fadd double %f13, %cast14
  store double %fadd, ptr %g, align 8
  %g15 = load double, ptr %g, align 8
  %cast16 = bitcast double %g15 to i64
  %14 = call i64 @avra_float_to_string(i64 %cast16)
  %cast17 = inttoptr i64 %14 to ptr
  %15 = call i32 @puts(ptr %cast17)
  %widen18 = sext i32 %15 to i64
  store i1 true, ptr %t, align 8
  store i1 false, ptr %f2, align 8
  %t19 = load i1, ptr %t, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.4, i1 %t19)
  %widen20 = sext i32 %17 to i64
  %18 = call i32 @puts(ptr %16)
  %widen21 = sext i32 %18 to i64
  %f222 = load i1, ptr %f2, align 8
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.5, i1 %f222)
  %widen23 = sext i32 %20 to i64
  %21 = call i32 @puts(ptr %19)
  %widen24 = sext i32 %21 to i64
  %t25 = load i1, ptr %t, align 8
  br i1 %t25, label %sc_rhs, label %sc_short

sc_rhs:                                           ; preds = %entry
  %f226 = load i1, ptr %f2, align 8
  br i1 %f226, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %f226, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.6, i64 %sc_ext)
  %widen27 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen28 = sext i32 %24 to i64
  %t29 = load i1, ptr %t, align 8
  br i1 %t29, label %sc_short31, label %sc_rhs30

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

sc_rhs30:                                         ; preds = %sc_merge
  %f233 = load i1, ptr %f2, align 8
  br i1 %f233, label %sc_r_true34, label %sc_r_false35

sc_short31:                                       ; preds = %sc_merge
  br label %sc_merge32

sc_merge32:                                       ; preds = %sc_r_merge36, %sc_short31
  %sc_phi37 = phi i1 [ true, %sc_short31 ], [ %f233, %sc_r_merge36 ]
  %sc_ext38 = zext i1 %sc_phi37 to i64
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.7, i64 %sc_ext38)
  %widen39 = sext i32 %26 to i64
  %27 = call i32 @puts(ptr %25)
  %widen40 = sext i32 %27 to i64
  %f241 = load i1, ptr %f2, align 8
  %not_cmp = icmp eq i1 %f241, false
  %not_cmp_ext = zext i1 %not_cmp to i64
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.8, i64 %not_cmp_ext)
  %widen42 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen43 = sext i32 %30 to i64
  store ptr @.str, ptr %s, align 8
  %s44 = load ptr, ptr %s, align 8
  %31 = call i32 @puts(ptr %s44)
  %widen45 = sext i32 %31 to i64
  %s46 = load ptr, ptr %s, align 8
  %32 = call i64 @strlen(ptr %s46)
  %33 = call i64 @strlen(ptr @.str.9)
  %concat_total = add i64 %32, %33
  %concat_size = add i64 %concat_total, 1
  %34 = call ptr @avra_rc_alloc(i64 %concat_size)
  %35 = call ptr @memcpy(ptr %34, ptr %s46, i64 %32)
  %cast47 = ptrtoint ptr %34 to i64
  %dst2_int = add i64 %cast47, %32
  %cast48 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast48, ptr @.str.9, i64 %rhs_len_p1)
  %37 = call i32 @puts(ptr %34)
  %widen49 = sext i32 %37 to i64
  %s50 = load ptr, ptr %s, align 8
  %38 = call i64 @strlen(ptr %s50)
  %39 = call ptr @avra_rc_alloc(i64 32)
  %40 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %39, i64 32, ptr @.i2s_fmt.10, i64 %38)
  %widen51 = sext i32 %40 to i64
  %41 = call i32 @puts(ptr %39)
  %widen52 = sext i32 %41 to i64
  %42 = call i64 @safe_div(i64 10, i64 2)
  store i64 %42, ptr %r1, align 8
  %43 = call i64 @safe_div(i64 10, i64 0)
  store i64 %43, ptr %r2, align 8
  %r153 = load i64, ptr %r1, align 8
  %ne = icmp ne i64 %r153, 0
  %ne_ext = zext i1 %ne to i64
  %if_cond = icmp ne i64 %ne_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

sc_r_true34:                                      ; preds = %sc_rhs30
  br label %sc_r_merge36

sc_r_false35:                                     ; preds = %sc_rhs30
  br label %sc_r_merge36

sc_r_merge36:                                     ; preds = %sc_r_false35, %sc_r_true34
  br label %sc_merge32

ifcont:                                           ; preds = %if_else, %nc_end
  %r263 = load i64, ptr %r2, align 8
  %eq = icmp eq i64 %r263, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond65 = icmp ne i64 %eq_ext, 0
  br i1 %if_cond65, label %if_then66, label %if_else67

if_then:                                          ; preds = %sc_merge32
  %r154 = load i64, ptr %r1, align 8
  %nc_null = icmp eq i64 %r154, 0
  store i64 %r154, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

if_else:                                          ; preds = %sc_merge32
  br label %ifcont

nc_rhs:                                           ; preds = %if_then
  store i64 0, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %if_then
  %nc_val = load i64, ptr %nc_result, align 8
  %44 = call ptr @avra_rc_alloc(i64 32)
  %45 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %44, i64 32, ptr @.i2s_fmt.12, i64 %nc_val)
  %widen55 = sext i32 %45 to i64
  %46 = call i64 @strlen(ptr @.str.11)
  %47 = call i64 @strlen(ptr %44)
  %concat_total56 = add i64 %46, %47
  %concat_size57 = add i64 %concat_total56, 1
  %48 = call ptr @avra_rc_alloc(i64 %concat_size57)
  %49 = call ptr @memcpy(ptr %48, ptr @.str.11, i64 %46)
  %cast58 = ptrtoint ptr %48 to i64
  %dst2_int59 = add i64 %cast58, %46
  %cast60 = inttoptr i64 %dst2_int59 to ptr
  %rhs_len_p161 = add i64 %47, 1
  %50 = call ptr @memcpy(ptr %cast60, ptr %44, i64 %rhs_len_p161)
  %51 = call i32 @puts(ptr %48)
  %widen62 = sext i32 %51 to i64
  br label %ifcont

ifcont64:                                         ; preds = %if_else67, %if_then66
  %r269 = load i64, ptr %r2, align 8
  %nc_null70 = icmp eq i64 %r269, 0
  store i64 %r269, ptr %nc_result73, align 8
  br i1 %nc_null70, label %nc_rhs71, label %nc_end72

if_then66:                                        ; preds = %ifcont
  %52 = call i32 @puts(ptr @.str.13)
  %widen68 = sext i32 %52 to i64
  br label %ifcont64

if_else67:                                        ; preds = %ifcont
  br label %ifcont64

nc_rhs71:                                         ; preds = %ifcont64
  store i64 -1, ptr %nc_result73, align 8
  br label %nc_end72

nc_end72:                                         ; preds = %nc_rhs71, %ifcont64
  %nc_val74 = load i64, ptr %nc_result73, align 8
  store i64 %nc_val74, ptr %val, align 8
  %val75 = load i64, ptr %val, align 8
  %53 = call ptr @avra_rc_alloc(i64 32)
  %54 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %53, i64 32, ptr @.i2s_fmt.14, i64 %val75)
  %widen76 = sext i32 %54 to i64
  %55 = call i32 @puts(ptr %53)
  %widen77 = sext i32 %55 to i64
  %56 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %56, i64 -559038737)
  call void @avra_array_push(ptr %56, i64 ptrtoint (ptr @double to i64))
  %cast78 = ptrtoint ptr %56 to i64
  %cast79 = inttoptr i64 %cast78 to ptr
  store ptr %cast79, ptr %f3, align 8
  %f380 = load i64, ptr %f3, align 8
  %cast81 = inttoptr i64 %f380 to ptr
  %57 = call i64 @avra_array_get(ptr %cast81, i64 1)
  %fn_ptr = inttoptr i64 %57 to ptr
  %closure_call = call i64 %fn_ptr(i64 21)
  %58 = call ptr @avra_rc_alloc(i64 32)
  %59 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %58, i64 32, ptr @.i2s_fmt.15, i64 %closure_call)
  %widen82 = sext i32 %59 to i64
  %60 = call i32 @puts(ptr %58)
  %widen83 = sext i32 %60 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
