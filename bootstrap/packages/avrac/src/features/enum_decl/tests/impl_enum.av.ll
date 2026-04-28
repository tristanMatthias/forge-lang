; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Shape = type { i64, ptr }

@c = global i64 0
@r = global i64 0
@.match_fn = private unnamed_addr constant [12 x i8] c"Shape__area\00", align 1
@mu_file = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/enum_decl/tests/impl_enum.av\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"circle r=\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"rect \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.5 = private unnamed_addr constant [16 x i8] c"Shape__describe\00", align 1
@mu_file.6 = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/enum_decl/tests/impl_enum.av\00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"area\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/enum_decl/tests/impl_enum.av\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.8 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@sty_name.9 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.10 = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/enum_decl/tests/impl_enum.av\00", align 1
@fld_name.11 = private unnamed_addr constant [5 x i8] c"area\00", align 1
@sty_name.12 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.13 = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/enum_decl/tests/impl_enum.av\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.15 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@sty_name.16 = private unnamed_addr constant [6 x i8] c"Shape\00", align 1
@src_file.17 = private unnamed_addr constant [134 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/enum_decl/tests/impl_enum.av\00", align 1

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

define i64 @Shape__area(ptr %0) {
entry:
  %h14 = alloca i64, align 8
  %w11 = alloca i64, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
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
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %w_slot_base = ptrtoint ptr %payload10 to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load i64, ptr %w_slot, align 8
  store i64 %w, ptr %w11, align 8
  %pay_slot12 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload13 = load ptr, ptr %pay_slot12, align 8
  %h_slot_base = ptrtoint ptr %payload13 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h14, align 8
  %w15 = load i64, ptr %w11, align 8
  %h16 = load i64, ptr %h14, align 8
  %mul17 = mul i64 %w15, %h16
  store i64 %mul17, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define ptr @Shape__describe(ptr %0) {
entry:
  %h14 = alloca i64, align 8
  %w11 = alloca i64, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast38 = inttoptr i64 %match_val to ptr
  ret ptr %cast38

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
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
  %cast5 = ptrtoint ptr %5 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %w_slot_base = ptrtoint ptr %payload10 to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load i64, ptr %w_slot, align 8
  store i64 %w, ptr %w11, align 8
  %pay_slot12 = getelementptr inbounds nuw %Shape, ptr %self1, i32 0, i32 1
  %payload13 = load ptr, ptr %pay_slot12, align 8
  %h_slot_base = ptrtoint ptr %payload13 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h14, align 8
  %w15 = load i64, ptr %w11, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.2, i64 %w15)
  %widen16 = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str.1)
  %11 = call i64 @strlen(ptr %8)
  %concat_total17 = add i64 %10, %11
  %concat_size18 = add i64 %concat_total17, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size18)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.1, i64 %10)
  %cast19 = ptrtoint ptr %12 to i64
  %dst2_int20 = add i64 %cast19, %10
  %cast21 = inttoptr i64 %dst2_int20 to ptr
  %rhs_len_p122 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast21, ptr %8, i64 %rhs_len_p122)
  %15 = call i64 @strlen(ptr %12)
  %16 = call i64 @strlen(ptr @.str.3)
  %concat_total23 = add i64 %15, %16
  %concat_size24 = add i64 %concat_total23, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size24)
  %18 = call ptr @memcpy(ptr %17, ptr %12, i64 %15)
  %cast25 = ptrtoint ptr %17 to i64
  %dst2_int26 = add i64 %cast25, %15
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast27, ptr @.str.3, i64 %rhs_len_p128)
  %h29 = load i64, ptr %h14, align 8
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.4, i64 %h29)
  %widen30 = sext i32 %21 to i64
  %22 = call i64 @strlen(ptr %17)
  %23 = call i64 @strlen(ptr %20)
  %concat_total31 = add i64 %22, %23
  %concat_size32 = add i64 %concat_total31, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %25 = call ptr @memcpy(ptr %24, ptr %17, i64 %22)
  %cast33 = ptrtoint ptr %24 to i64
  %dst2_int34 = add i64 %cast33, %22
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast35, ptr %20, i64 %rhs_len_p136)
  %cast37 = ptrtoint ptr %24 to i64
  store i64 %cast37, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 16)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %0, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 8)
  store ptr %1, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @c, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Shape, ptr %2, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Shape, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr2, align 8
  %slot_base3 = ptrtoint ptr %3 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 4, ptr %slot5, align 8
  %slot_base6 = ptrtoint ptr %3 to i64
  %slot_addr7 = add i64 %slot_base6, 8
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store i64 6, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %2 to i64
  store i64 %cast9, ptr @r, align 8
  %c = load ptr, ptr @c, align 8
  %cast10 = ptrtoint ptr %c to i64
  %null_chk = icmp eq i64 %cast10, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 133, i64 26)
  %4 = call i64 @Shape__area(ptr %c)
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.7, i64 %4)
  %widen = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen11 = sext i32 %7 to i64
  %c12 = load ptr, ptr @c, align 8
  %cast13 = ptrtoint ptr %c12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.8, i64 8, ptr @sty_name.9, i64 5, i64 %null_ext15, ptr @src_file.10, i64 133, i64 27)
  %8 = call ptr @Shape__describe(ptr %c12)
  %9 = call i32 @puts(ptr %8)
  %widen16 = sext i32 %9 to i64
  %r = load ptr, ptr @r, align 8
  %cast17 = ptrtoint ptr %r to i64
  %null_chk18 = icmp eq i64 %cast17, 0
  %null_ext19 = zext i1 %null_chk18 to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 4, ptr @sty_name.12, i64 5, i64 %null_ext19, ptr @src_file.13, i64 133, i64 28)
  %10 = call i64 @Shape__area(ptr %r)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.14, i64 %10)
  %widen20 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen21 = sext i32 %13 to i64
  %r22 = load ptr, ptr @r, align 8
  %cast23 = ptrtoint ptr %r22 to i64
  %null_chk24 = icmp eq i64 %cast23, 0
  %null_ext25 = zext i1 %null_chk24 to i64
  call void @avra_null_deref_trap(ptr @fld_name.15, i64 8, ptr @sty_name.16, i64 5, i64 %null_ext25, ptr @src_file.17, i64 133, i64 29)
  %14 = call ptr @Shape__describe(ptr %r22)
  %15 = call i32 @puts(ptr %14)
  %widen26 = sext i32 %15 to i64
  %16 = call i32 @avra_test_summary()
  %widen27 = sext i32 %16 to i64
  call void @avra_rc_collect()
  ret i64 0
}
