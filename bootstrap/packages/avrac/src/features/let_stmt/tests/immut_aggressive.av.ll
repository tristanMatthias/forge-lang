; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Counter = type { i64 }
%Action = type { i64, ptr }
%Point = type { i64, i64 }

@global_counter = global i64 0
@total = global i64 0
@x = global i64 0
@c = global i64 0
@acc = global i64 0
@actions = global i64 0
@sum = global i64 0
@p = global i64 0
@p2 = global i64 0
@result = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"Counter\00", align 1
@src_file = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/let_stmt/tests/immut_aggressive.av\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/let_stmt/tests/immut_aggressive.av\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.10 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.11 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.12 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/let_stmt/tests/immut_aggressive.av\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.14 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.15 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.16 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/let_stmt/tests/immut_aggressive.av\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @increment() {
entry:
  %global_counter = load i64, ptr @global_counter, align 8
  %add = add i64 %global_counter, 1
  store i64 %add, ptr @global_counter, align 8
  %global_counter1 = load i64, ptr @global_counter, align 8
  ret i64 %global_counter1
}

define i64 @maybe(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  ret i64 0

if_then:                                          ; preds = %entry
  %x2 = load i64, ptr %x, align 8
  ret i64 %x2

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @main() {
entry:
  %nc_result104 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %n66 = alloca i64, align 8
  %n54 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %a = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %x16 = alloca i64, align 8
  %x = alloca i64, align 8
  %local = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  store i64 0, ptr @global_counter, align 8
  %0 = call i64 @increment()
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %0)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen1 = sext i32 %3 to i64
  %4 = call i64 @increment()
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.1, i64 %4)
  %widen2 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen3 = sext i32 %7 to i64
  %8 = call i64 @increment()
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.2, i64 %8)
  %widen4 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen5 = sext i32 %11 to i64
  store i64 0, ptr @total, align 8
  store i64 0, ptr %i, align 8
  store i64 10, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i6 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i6, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %i7 = load i64, ptr %i, align 8
  %i8 = load i64, ptr %i, align 8
  %mul = mul i64 %i7, %i8
  store i64 %mul, ptr %local, align 8
  %local9 = load i64, ptr %local, align 8
  %add = add i64 %local9, 1
  store i64 %add, ptr %local, align 8
  %total = load i64, ptr @total, align 8
  %local10 = load i64, ptr %local, align 8
  %add11 = add i64 %total, %local10
  store i64 %add11, ptr @total, align 8
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i12 = load i64, ptr %i, align 8
  %for_next = add i64 %i12, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %total13 = load i64, ptr @total, align 8
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.3, i64 %total13)
  %widen14 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen15 = sext i32 %14 to i64
  store i64 100, ptr @x, align 8
  store i64 200, ptr %x, align 8
  store i64 300, ptr %x16, align 8
  %x17 = load i64, ptr %x16, align 8
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.4, i64 %x17)
  %widen18 = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen19 = sext i32 %17 to i64
  %x20 = load i64, ptr %x, align 8
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.5, i64 %x20)
  %widen21 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen22 = sext i32 %20 to i64
  %x23 = load i64, ptr @x, align 8
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.6, i64 %x23)
  %widen24 = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen25 = sext i32 %23 to i64
  %24 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Counter, ptr %24, i32 0, i32 0
  store i64 0, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %24 to i64
  store i64 %cast, ptr @c, align 8
  %c = load ptr, ptr @c, align 8
  %fa_fld = getelementptr inbounds nuw %Counter, ptr %c, i32 0, i32 0
  store i64 42, ptr %fa_fld, align 8
  %c26 = load ptr, ptr @c, align 8
  %cast27 = ptrtoint ptr %c26 to i64
  %null_chk = icmp eq i64 %cast27, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 139, i64 38)
  %value_ptr = getelementptr inbounds nuw %Counter, ptr %c26, i32 0, i32 0
  %value = load i64, ptr %value_ptr, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.7, i64 %value)
  %widen28 = sext i32 %26 to i64
  %27 = call i32 @puts(ptr %25)
  %widen29 = sext i32 %27 to i64
  store i64 50, ptr @acc, align 8
  %28 = call ptr @avra_array_new()
  %29 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Action, ptr %29, i32 0, i32 0
  store i64 193460223, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Action, ptr %29, i32 0, i32 1
  %30 = call ptr @avra_rc_alloc(i64 8)
  store ptr %30, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %30 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 10, ptr %slot, align 8
  %cast30 = ptrtoint ptr %29 to i64
  call void @avra_array_push(ptr %28, i64 %cast30)
  %31 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr31 = getelementptr inbounds nuw %Action, ptr %31, i32 0, i32 0
  store i64 193454481, ptr %tag_ptr31, align 8
  %pay_ptr32 = getelementptr inbounds nuw %Action, ptr %31, i32 0, i32 1
  %32 = call ptr @avra_rc_alloc(i64 8)
  store ptr %32, ptr %pay_ptr32, align 8
  %slot_base33 = ptrtoint ptr %32 to i64
  %slot_addr34 = add i64 %slot_base33, 0
  %slot35 = inttoptr i64 %slot_addr34 to ptr
  store i64 3, ptr %slot35, align 8
  %cast36 = ptrtoint ptr %31 to i64
  call void @avra_array_push(ptr %28, i64 %cast36)
  %33 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr37 = getelementptr inbounds nuw %Action, ptr %33, i32 0, i32 0
  store i64 193460223, ptr %tag_ptr37, align 8
  %pay_ptr38 = getelementptr inbounds nuw %Action, ptr %33, i32 0, i32 1
  %34 = call ptr @avra_rc_alloc(i64 8)
  store ptr %34, ptr %pay_ptr38, align 8
  %slot_base39 = ptrtoint ptr %34 to i64
  %slot_addr40 = add i64 %slot_base39, 0
  %slot41 = inttoptr i64 %slot_addr40 to ptr
  store i64 7, ptr %slot41, align 8
  %cast42 = ptrtoint ptr %33 to i64
  call void @avra_array_push(ptr %28, i64 %cast42)
  %35 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr43 = getelementptr inbounds nuw %Action, ptr %35, i32 0, i32 0
  store i64 210688553576, ptr %tag_ptr43, align 8
  %pay_ptr44 = getelementptr inbounds nuw %Action, ptr %35, i32 0, i32 1
  store ptr null, ptr %pay_ptr44, align 8
  %cast45 = ptrtoint ptr %35 to i64
  call void @avra_array_push(ptr %28, i64 %cast45)
  %36 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr46 = getelementptr inbounds nuw %Action, ptr %36, i32 0, i32 0
  store i64 193460223, ptr %tag_ptr46, align 8
  %pay_ptr47 = getelementptr inbounds nuw %Action, ptr %36, i32 0, i32 1
  %37 = call ptr @avra_rc_alloc(i64 8)
  store ptr %37, ptr %pay_ptr47, align 8
  %slot_base48 = ptrtoint ptr %37 to i64
  %slot_addr49 = add i64 %slot_base48, 0
  %slot50 = inttoptr i64 %slot_addr49 to ptr
  store i64 5, ptr %slot50, align 8
  %cast51 = ptrtoint ptr %36 to i64
  call void @avra_array_push(ptr %28, i64 %cast51)
  store ptr %28, ptr @actions, align 8
  %actions = load ptr, ptr @actions, align 8
  %38 = call i64 @avra_array_len(ptr %actions)
  store i64 %38, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %for.exit
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %39 = call i64 @avra_array_get(ptr %actions, i64 %forin_i_val)
  store i64 %39, ptr %a, align 8
  %a52 = load ptr, ptr %a, align 8
  %tag_ptr53 = getelementptr inbounds nuw %Action, ptr %a52, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr53, align 8
  %tag_eq = icmp eq i64 %tag, 193460223
  br i1 %tag_eq, label %march_arm, label %march_next

forin.incr:                                       ; preds = %match_end
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %acc72 = load i64, ptr @acc, align 8
  %40 = call ptr @avra_rc_alloc(i64 32)
  %41 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %40, i64 32, ptr @.i2s_fmt.8, i64 %acc72)
  %widen73 = sext i32 %41 to i64
  %42 = call i32 @puts(ptr %40)
  %widen74 = sext i32 %42 to i64
  store i64 0, ptr @sum, align 8
  %43 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %43, i64 1)
  call void @avra_array_push(ptr %43, i64 2)
  call void @avra_array_push(ptr %43, i64 3)
  call void @avra_array_push(ptr %43, i64 4)
  call void @avra_array_push(ptr %43, i64 5)
  %44 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %44, i64 -559038737)
  call void @avra_array_push(ptr %44, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast75 = ptrtoint ptr %44 to i64
  call void @avra_array_foreach(ptr %43, i64 %cast75)
  %sum = load i64, ptr @sum, align 8
  %45 = call ptr @avra_rc_alloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @.i2s_fmt.9, i64 %sum)
  %widen76 = sext i32 %46 to i64
  %47 = call i32 @puts(ptr %45)
  %widen77 = sext i32 %47 to i64
  %48 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr78 = getelementptr inbounds nuw %Point, ptr %48, i32 0, i32 0
  store i64 1, ptr %fld_ptr78, align 8
  %fld_ptr79 = getelementptr inbounds nuw %Point, ptr %48, i32 0, i32 1
  store i64 2, ptr %fld_ptr79, align 8
  %cast80 = ptrtoint ptr %48 to i64
  store i64 %cast80, ptr @p, align 8
  %p = load ptr, ptr @p, align 8
  %49 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Point, ptr %p, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Point, ptr %49, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src81 = getelementptr inbounds nuw %Point, ptr %p, i32 0, i32 1
  %with_cp_val82 = load i64, ptr %with_cp_src81, align 8
  %with_cp_dst83 = getelementptr inbounds nuw %Point, ptr %49, i32 0, i32 1
  store i64 %with_cp_val82, ptr %with_cp_dst83, align 8
  %with_ovr = getelementptr inbounds nuw %Point, ptr %49, i32 0, i32 0
  store i64 99, ptr %with_ovr, align 8
  %cast84 = ptrtoint ptr %49 to i64
  store i64 %cast84, ptr @p2, align 8
  %p85 = load ptr, ptr @p, align 8
  %cast86 = ptrtoint ptr %p85 to i64
  %null_chk87 = icmp eq i64 %cast86, 0
  %null_ext88 = zext i1 %null_chk87 to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 1, ptr @sty_name.11, i64 5, i64 %null_ext88, ptr @src_file.12, i64 139, i64 64)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p85, i32 0, i32 0
  %x89 = load i64, ptr %x_ptr, align 8
  %50 = call ptr @avra_rc_alloc(i64 32)
  %51 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %50, i64 32, ptr @.i2s_fmt.13, i64 %x89)
  %widen90 = sext i32 %51 to i64
  %52 = call i32 @puts(ptr %50)
  %widen91 = sext i32 %52 to i64
  %p2 = load ptr, ptr @p2, align 8
  %cast92 = ptrtoint ptr %p2 to i64
  %null_chk93 = icmp eq i64 %cast92, 0
  %null_ext94 = zext i1 %null_chk93 to i64
  call void @avra_null_deref_trap(ptr @fld_name.14, i64 1, ptr @sty_name.15, i64 5, i64 %null_ext94, ptr @src_file.16, i64 139, i64 65)
  %x_ptr95 = getelementptr inbounds nuw %Point, ptr %p2, i32 0, i32 0
  %x96 = load i64, ptr %x_ptr95, align 8
  %53 = call ptr @avra_rc_alloc(i64 32)
  %54 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %53, i64 32, ptr @.i2s_fmt.17, i64 %x96)
  %widen97 = sext i32 %54 to i64
  %55 = call i32 @puts(ptr %53)
  %widen98 = sext i32 %55 to i64
  store i64 0, ptr @result, align 8
  %56 = call i64 @maybe(i64 42)
  %nc_null = icmp eq i64 %56, 0
  store i64 %56, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

match_end:                                        ; preds = %march_arm69, %march_arm57, %march_arm
  br label %forin.incr

march_arm:                                        ; preds = %forin.body
  %pay_slot = getelementptr inbounds nuw %Action, ptr %a52, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n54, align 8
  %acc = load i64, ptr @acc, align 8
  %n55 = load i64, ptr %n54, align 8
  %add56 = add i64 %acc, %n55
  store i64 %add56, ptr @acc, align 8
  store i64 %add56, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %forin.body
  %tag_eq59 = icmp eq i64 %tag, 193454481
  br i1 %tag_eq59, label %march_arm57, label %march_next58

march_arm57:                                      ; preds = %march_next
  %pay_slot60 = getelementptr inbounds nuw %Action, ptr %a52, i32 0, i32 1
  %payload61 = load ptr, ptr %pay_slot60, align 8
  %n_slot_base62 = ptrtoint ptr %payload61 to i64
  %n_slot_addr63 = add i64 %n_slot_base62, 0
  %n_slot64 = inttoptr i64 %n_slot_addr63 to ptr
  %n65 = load i64, ptr %n_slot64, align 8
  store i64 %n65, ptr %n66, align 8
  %acc67 = load i64, ptr @acc, align 8
  %n68 = load i64, ptr %n66, align 8
  %sub = sub i64 %acc67, %n68
  store i64 %sub, ptr @acc, align 8
  store i64 %sub, ptr %match_stmt_discard, align 8
  br label %match_end

march_next58:                                     ; preds = %march_next
  %tag_eq71 = icmp eq i64 %tag, 210688553576
  br i1 %tag_eq71, label %march_arm69, label %march_next70

march_arm69:                                      ; preds = %march_next58
  store i64 0, ptr @acc, align 8
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next70:                                     ; preds = %march_next58
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 45)
  unreachable

nc_rhs:                                           ; preds = %forin.exit
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %forin.exit
  %nc_val = load i64, ptr %nc_result, align 8
  store i64 %nc_val, ptr @result, align 8
  %result = load i64, ptr @result, align 8
  %57 = call ptr @avra_rc_alloc(i64 32)
  %58 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %57, i64 32, ptr @.i2s_fmt.18, i64 %result)
  %widen99 = sext i32 %58 to i64
  %59 = call i32 @puts(ptr %57)
  %widen100 = sext i32 %59 to i64
  %60 = call i64 @maybe(i64 -5)
  %nc_null101 = icmp eq i64 %60, 0
  store i64 %60, ptr %nc_result104, align 8
  br i1 %nc_null101, label %nc_rhs102, label %nc_end103

nc_rhs102:                                        ; preds = %nc_end
  store i64 -1, ptr %nc_result104, align 8
  br label %nc_end103

nc_end103:                                        ; preds = %nc_rhs102, %nc_end
  %nc_val105 = load i64, ptr %nc_result104, align 8
  store i64 %nc_val105, ptr @result, align 8
  %result106 = load i64, ptr @result, align 8
  %61 = call ptr @avra_rc_alloc(i64 32)
  %62 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %61, i64 32, ptr @.i2s_fmt.19, i64 %result106)
  %widen107 = sext i32 %62 to i64
  %63 = call i32 @puts(ptr %61)
  %widen108 = sext i32 %63 to i64
  %64 = call i32 @avra_test_summary()
  %widen109 = sext i32 %64 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %sum = load i64, ptr @sum, align 8
  %x1 = load i64, ptr %x, align 8
  %add = add i64 %sum, %x1
  store i64 %add, ptr @sum, align 8
  ret i64 %add
}
