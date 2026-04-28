; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { i64, i64 }

@big = global i64 0
@mixed = global i64 0
@pairs = global i64 0
@sum = global i64 0
@dz_file = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_tuples.av\00", align 1
@dz_file.1 = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_tuples.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
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

define i64 @divmod(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %a1 = load i64, ptr %a, align 8
  %b2 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b2, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 99, i64 27)
  %div = sdiv i64 %a1, %b2
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %div, ptr %slot, align 8
  %a3 = load i64, ptr %a, align 8
  %b4 = load i64, ptr %b, align 8
  %dz_chk5 = icmp eq i64 %b4, 0
  %dz_chk_ext6 = zext i1 %dz_chk5 to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext6, ptr @dz_file.1, i64 99, i64 27)
  %mod = srem i64 %a3, %b4
  %slot_base7 = ptrtoint ptr %2 to i64
  %slot_addr8 = add i64 %slot_base7, 8
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %mod, ptr %slot9, align 8
  %cast = ptrtoint ptr %2 to i64
  ret i64 %cast
}

define i64 @main() {
entry:
  %r128 = alloca i64, align 8
  %q127 = alloca i64, align 8
  %p = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %d83 = alloca i64, align 8
  %c82 = alloca i64, align 8
  %b68 = alloca i64, align 8
  %a67 = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 80)
  %slot_base = ptrtoint ptr %0 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 1, ptr %slot, align 8
  %slot_base1 = ptrtoint ptr %0 to i64
  %slot_addr2 = add i64 %slot_base1, 8
  %slot3 = inttoptr i64 %slot_addr2 to ptr
  store i64 2, ptr %slot3, align 8
  %slot_base4 = ptrtoint ptr %0 to i64
  %slot_addr5 = add i64 %slot_base4, 16
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store i64 3, ptr %slot6, align 8
  %slot_base7 = ptrtoint ptr %0 to i64
  %slot_addr8 = add i64 %slot_base7, 24
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 4, ptr %slot9, align 8
  %slot_base10 = ptrtoint ptr %0 to i64
  %slot_addr11 = add i64 %slot_base10, 32
  %slot12 = inttoptr i64 %slot_addr11 to ptr
  store i64 5, ptr %slot12, align 8
  %slot_base13 = ptrtoint ptr %0 to i64
  %slot_addr14 = add i64 %slot_base13, 40
  %slot15 = inttoptr i64 %slot_addr14 to ptr
  store i64 6, ptr %slot15, align 8
  %slot_base16 = ptrtoint ptr %0 to i64
  %slot_addr17 = add i64 %slot_base16, 48
  %slot18 = inttoptr i64 %slot_addr17 to ptr
  store i64 7, ptr %slot18, align 8
  %slot_base19 = ptrtoint ptr %0 to i64
  %slot_addr20 = add i64 %slot_base19, 56
  %slot21 = inttoptr i64 %slot_addr20 to ptr
  store i64 8, ptr %slot21, align 8
  %slot_base22 = ptrtoint ptr %0 to i64
  %slot_addr23 = add i64 %slot_base22, 64
  %slot24 = inttoptr i64 %slot_addr23 to ptr
  store i64 9, ptr %slot24, align 8
  %slot_base25 = ptrtoint ptr %0 to i64
  %slot_addr26 = add i64 %slot_base25, 72
  %slot27 = inttoptr i64 %slot_addr26 to ptr
  store i64 10, ptr %slot27, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @big, align 8
  %big = load ptr, ptr @big, align 8
  %tup_val_slot_base = ptrtoint ptr %big to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  %big28 = load ptr, ptr @big, align 8
  %tup_val_slot_base29 = ptrtoint ptr %big28 to i64
  %tup_val_slot_addr30 = add i64 %tup_val_slot_base29, 72
  %tup_val_slot31 = inttoptr i64 %tup_val_slot_addr30 to ptr
  %tup_val32 = load i64, ptr %tup_val_slot31, align 8
  %add = add i64 %tup_val, %tup_val32
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %add)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen33 = sext i32 %3 to i64
  %4 = call ptr @avra_rc_alloc(i64 24)
  %slot_base34 = ptrtoint ptr %4 to i64
  %slot_addr35 = add i64 %slot_base34, 0
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  store i64 42, ptr %slot36, align 8
  %slot_base37 = ptrtoint ptr %4 to i64
  %slot_addr38 = add i64 %slot_base37, 8
  %slot39 = inttoptr i64 %slot_addr38 to ptr
  store i64 ptrtoint (ptr @.str to i64), ptr %slot39, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %5, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr40 = getelementptr inbounds nuw %Point, ptr %5, i32 0, i32 1
  store i64 2, ptr %fld_ptr40, align 8
  %cast41 = ptrtoint ptr %5 to i64
  %slot_base42 = ptrtoint ptr %4 to i64
  %slot_addr43 = add i64 %slot_base42, 16
  %slot44 = inttoptr i64 %slot_addr43 to ptr
  store i64 %cast41, ptr %slot44, align 8
  %cast45 = ptrtoint ptr %4 to i64
  store i64 %cast45, ptr @mixed, align 8
  %mixed = load ptr, ptr @mixed, align 8
  %tup_val_slot_base46 = ptrtoint ptr %mixed to i64
  %tup_val_slot_addr47 = add i64 %tup_val_slot_base46, 0
  %tup_val_slot48 = inttoptr i64 %tup_val_slot_addr47 to ptr
  %tup_val49 = load i64, ptr %tup_val_slot48, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.2, i64 %tup_val49)
  %widen50 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen51 = sext i32 %8 to i64
  %mixed52 = load ptr, ptr @mixed, align 8
  %tup_val_slot_base53 = ptrtoint ptr %mixed52 to i64
  %tup_val_slot_addr54 = add i64 %tup_val_slot_base53, 8
  %tup_val_slot55 = inttoptr i64 %tup_val_slot_addr54 to ptr
  %tup_val56 = load i64, ptr %tup_val_slot55, align 8
  %cast57 = inttoptr i64 %tup_val56 to ptr
  %9 = call i32 @puts(ptr %cast57)
  %widen58 = sext i32 %9 to i64
  %10 = call ptr @avra_rc_alloc(i64 16)
  %slot_base59 = ptrtoint ptr %10 to i64
  %slot_addr60 = add i64 %slot_base59, 0
  %slot61 = inttoptr i64 %slot_addr60 to ptr
  store i64 10, ptr %slot61, align 8
  %slot_base62 = ptrtoint ptr %10 to i64
  %slot_addr63 = add i64 %slot_base62, 8
  %slot64 = inttoptr i64 %slot_addr63 to ptr
  store i64 20, ptr %slot64, align 8
  %cast65 = ptrtoint ptr %10 to i64
  %cast66 = inttoptr i64 %cast65 to ptr
  %a_slot_base = ptrtoint ptr %cast66 to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load i64, ptr %a_slot, align 8
  store i64 %a, ptr %a67, align 8
  %b_slot_base = ptrtoint ptr %cast66 to i64
  %b_slot_addr = add i64 %b_slot_base, 8
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load i64, ptr %b_slot, align 8
  store i64 %b, ptr %b68, align 8
  %11 = call ptr @avra_rc_alloc(i64 16)
  %a69 = load i64, ptr %a67, align 8
  %b70 = load i64, ptr %b68, align 8
  %add71 = add i64 %a69, %b70
  %slot_base72 = ptrtoint ptr %11 to i64
  %slot_addr73 = add i64 %slot_base72, 0
  %slot74 = inttoptr i64 %slot_addr73 to ptr
  store i64 %add71, ptr %slot74, align 8
  %a75 = load i64, ptr %a67, align 8
  %b76 = load i64, ptr %b68, align 8
  %mul = mul i64 %a75, %b76
  %slot_base77 = ptrtoint ptr %11 to i64
  %slot_addr78 = add i64 %slot_base77, 8
  %slot79 = inttoptr i64 %slot_addr78 to ptr
  store i64 %mul, ptr %slot79, align 8
  %cast80 = ptrtoint ptr %11 to i64
  %cast81 = inttoptr i64 %cast80 to ptr
  %c_slot_base = ptrtoint ptr %cast81 to i64
  %c_slot_addr = add i64 %c_slot_base, 0
  %c_slot = inttoptr i64 %c_slot_addr to ptr
  %c = load i64, ptr %c_slot, align 8
  store i64 %c, ptr %c82, align 8
  %d_slot_base = ptrtoint ptr %cast81 to i64
  %d_slot_addr = add i64 %d_slot_base, 8
  %d_slot = inttoptr i64 %d_slot_addr to ptr
  %d = load i64, ptr %d_slot, align 8
  store i64 %d, ptr %d83, align 8
  %c84 = load i64, ptr %c82, align 8
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.3, i64 %c84)
  %widen85 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen86 = sext i32 %14 to i64
  %d87 = load i64, ptr %d83, align 8
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.4, i64 %d87)
  %widen88 = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen89 = sext i32 %17 to i64
  %18 = call ptr @avra_array_new()
  %19 = call ptr @avra_rc_alloc(i64 16)
  %slot_base90 = ptrtoint ptr %19 to i64
  %slot_addr91 = add i64 %slot_base90, 0
  %slot92 = inttoptr i64 %slot_addr91 to ptr
  store i64 1, ptr %slot92, align 8
  %slot_base93 = ptrtoint ptr %19 to i64
  %slot_addr94 = add i64 %slot_base93, 8
  %slot95 = inttoptr i64 %slot_addr94 to ptr
  store i64 10, ptr %slot95, align 8
  %cast96 = ptrtoint ptr %19 to i64
  call void @avra_array_push(ptr %18, i64 %cast96)
  %20 = call ptr @avra_rc_alloc(i64 16)
  %slot_base97 = ptrtoint ptr %20 to i64
  %slot_addr98 = add i64 %slot_base97, 0
  %slot99 = inttoptr i64 %slot_addr98 to ptr
  store i64 2, ptr %slot99, align 8
  %slot_base100 = ptrtoint ptr %20 to i64
  %slot_addr101 = add i64 %slot_base100, 8
  %slot102 = inttoptr i64 %slot_addr101 to ptr
  store i64 20, ptr %slot102, align 8
  %cast103 = ptrtoint ptr %20 to i64
  call void @avra_array_push(ptr %18, i64 %cast103)
  %21 = call ptr @avra_rc_alloc(i64 16)
  %slot_base104 = ptrtoint ptr %21 to i64
  %slot_addr105 = add i64 %slot_base104, 0
  %slot106 = inttoptr i64 %slot_addr105 to ptr
  store i64 3, ptr %slot106, align 8
  %slot_base107 = ptrtoint ptr %21 to i64
  %slot_addr108 = add i64 %slot_base107, 8
  %slot109 = inttoptr i64 %slot_addr108 to ptr
  store i64 30, ptr %slot109, align 8
  %cast110 = ptrtoint ptr %21 to i64
  call void @avra_array_push(ptr %18, i64 %cast110)
  store ptr %18, ptr @pairs, align 8
  store i64 0, ptr @sum, align 8
  %pairs = load ptr, ptr @pairs, align 8
  %22 = call i64 @avra_array_len(ptr %pairs)
  store i64 %22, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %23 = call i64 @avra_array_get(ptr %pairs, i64 %forin_i_val)
  store i64 %23, ptr %p, align 8
  %sum = load i64, ptr @sum, align 8
  %p111 = load ptr, ptr %p, align 8
  %tup_val_slot_base112 = ptrtoint ptr %p111 to i64
  %tup_val_slot_addr113 = add i64 %tup_val_slot_base112, 0
  %tup_val_slot114 = inttoptr i64 %tup_val_slot_addr113 to ptr
  %tup_val115 = load i64, ptr %tup_val_slot114, align 8
  %add116 = add i64 %sum, %tup_val115
  %p117 = load ptr, ptr %p, align 8
  %tup_val_slot_base118 = ptrtoint ptr %p117 to i64
  %tup_val_slot_addr119 = add i64 %tup_val_slot_base118, 8
  %tup_val_slot120 = inttoptr i64 %tup_val_slot_addr119 to ptr
  %tup_val121 = load i64, ptr %tup_val_slot120, align 8
  %add122 = add i64 %add116, %tup_val121
  store i64 %add122, ptr @sum, align 8
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %sum123 = load i64, ptr @sum, align 8
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.5, i64 %sum123)
  %widen124 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen125 = sext i32 %26 to i64
  %27 = call i64 @divmod(i64 17, i64 5)
  %cast126 = inttoptr i64 %27 to ptr
  %q_slot_base = ptrtoint ptr %cast126 to i64
  %q_slot_addr = add i64 %q_slot_base, 0
  %q_slot = inttoptr i64 %q_slot_addr to ptr
  %q = load i64, ptr %q_slot, align 8
  store i64 %q, ptr %q127, align 8
  %r_slot_base = ptrtoint ptr %cast126 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r128, align 8
  %q129 = load i64, ptr %q127, align 8
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.6, i64 %q129)
  %widen130 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen131 = sext i32 %30 to i64
  %r132 = load i64, ptr %r128, align 8
  %31 = call ptr @avra_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.7, i64 %r132)
  %widen133 = sext i32 %32 to i64
  %33 = call i32 @puts(ptr %31)
  %widen134 = sext i32 %33 to i64
  %34 = call i32 @avra_test_summary()
  %widen135 = sext i32 %34 to i64
  call void @avra_rc_collect()
  ret i64 0
}
