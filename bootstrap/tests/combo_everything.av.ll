; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { i64, i64 }
%Shape = type { i64, ptr }
%Shape__Circle = type { ptr, i64 }
%Shape__Rect = type { ptr, i64, i64 }

@total = global i64 0
@result = global i64 0
@result2 = global i64 0
@val = global i64 0
@pair = global i64 0
@.str = private unnamed_addr constant [2 x i8] c"(\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_everything.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.2 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.3 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.4 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_everything.av\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"area\00", align 1
@mu_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_everything.av\00", align 1
@dz_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_everything.av\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @Point__describe(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 102, i64 10)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %self1, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast2 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast2, %3
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast3, ptr %1, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.1)
  %concat_total4 = add i64 %8, %9
  %concat_size5 = add i64 %concat_total4, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast6 = ptrtoint ptr %10 to i64
  %dst2_int7 = add i64 %cast6, %8
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast8, ptr @.str.1, i64 %rhs_len_p19)
  %self10 = load ptr, ptr %self, align 8
  %cast11 = ptrtoint ptr %self10 to i64
  %null_chk12 = icmp eq i64 %cast11, 0
  %null_ext13 = zext i1 %null_chk12 to i64
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 1, ptr @sty_name.3, i64 5, i64 %null_ext13, ptr @src_file.4, i64 102, i64 10)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %self10, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.5, i64 %y)
  %widen14 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr %10)
  %16 = call i64 @strlen(ptr %13)
  %concat_total15 = add i64 %15, %16
  %concat_size16 = add i64 %concat_total15, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size16)
  %18 = call ptr @memcpy(ptr %17, ptr %10, i64 %15)
  %cast17 = ptrtoint ptr %17 to i64
  %dst2_int18 = add i64 %cast17, %15
  %cast19 = inttoptr i64 %dst2_int18 to ptr
  %rhs_len_p120 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast19, ptr %13, i64 %rhs_len_p120)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.6)
  %concat_total21 = add i64 %20, %21
  %concat_size22 = add i64 %concat_total21, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size22)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast23 = ptrtoint ptr %22 to i64
  %dst2_int24 = add i64 %cast23, %20
  %cast25 = inttoptr i64 %dst2_int24 to ptr
  %rhs_len_p126 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast25, ptr @.str.6, i64 %rhs_len_p126)
  ret ptr %22
}

define i64 @area(ptr %0) {
entry:
  %h14 = alloca i64, align 8
  %w11 = alloca i64, align 8
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
  %r_slot_addr = add i64 %r_slot_base, 8
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
  %w_slot_base = ptrtoint ptr %payload10 to i64
  %w_slot_addr = add i64 %w_slot_base, 8
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load i64, ptr %w_slot, align 8
  store i64 %w, ptr %w11, align 8
  %pay_slot12 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload13 = load ptr, ptr %pay_slot12, align 8
  %h_slot_base = ptrtoint ptr %payload13 to i64
  %h_slot_addr = add i64 %h_slot_base, 16
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h14, align 8
  %w15 = load i64, ptr %w11, align 8
  %h16 = load i64, ptr %h14, align 8
  %mul17 = mul i64 %w15, %h16
  store i64 %mul17, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 20)
  unreachable
}

define i64 @make_shapes() {
entry:
  %a1 = alloca i64, align 8
  %a0 = alloca i64, align 8
  %total = alloca i64, align 8
  %shapes = alloca ptr, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 16)
  store ptr %2, ptr %pay_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %3, i32 0, i32 0
  store i64 0, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Point, ptr %3, i32 0, i32 1
  store i64 0, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %3 to i64
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %slot, align 8
  %slot_base3 = ptrtoint ptr %2 to i64
  %slot_addr4 = add i64 %slot_base3, 8
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 5, ptr %slot5, align 8
  %cast6 = ptrtoint ptr %1 to i64
  %slot_base7 = ptrtoint ptr %0 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %cast6, ptr %slot9, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Shape, ptr %4, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %Shape, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 24)
  store ptr %5, ptr %pay_ptr11, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr12 = getelementptr inbounds nuw %Point, ptr %6, i32 0, i32 0
  store i64 1, ptr %fld_ptr12, align 8
  %fld_ptr13 = getelementptr inbounds nuw %Point, ptr %6, i32 0, i32 1
  store i64 1, ptr %fld_ptr13, align 8
  %cast14 = ptrtoint ptr %6 to i64
  %slot_base15 = ptrtoint ptr %5 to i64
  %slot_addr16 = add i64 %slot_base15, 0
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  %cast18 = inttoptr i64 %cast14 to ptr
  store ptr %cast18, ptr %slot17, align 8
  %slot_base19 = ptrtoint ptr %5 to i64
  %slot_addr20 = add i64 %slot_base19, 8
  %slot21 = inttoptr i64 %slot_addr20 to ptr
  store i64 4, ptr %slot21, align 8
  %slot_base22 = ptrtoint ptr %5 to i64
  %slot_addr23 = add i64 %slot_base22, 16
  %slot24 = inttoptr i64 %slot_addr23 to ptr
  store i64 6, ptr %slot24, align 8
  %cast25 = ptrtoint ptr %4 to i64
  %slot_base26 = ptrtoint ptr %0 to i64
  %slot_addr27 = add i64 %slot_base26, 8
  %slot28 = inttoptr i64 %slot_addr27 to ptr
  store i64 %cast25, ptr %slot28, align 8
  %cast29 = ptrtoint ptr %0 to i64
  %cast30 = inttoptr i64 %cast29 to ptr
  store ptr %cast30, ptr %shapes, align 8
  store i64 0, ptr %total, align 8
  %shapes31 = load ptr, ptr %shapes, align 8
  %tup_val_slot_base = ptrtoint ptr %shapes31 to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  %cast32 = inttoptr i64 %tup_val to ptr
  %7 = call i64 @area(ptr %cast32)
  store i64 %7, ptr %a0, align 8
  %shapes33 = load ptr, ptr %shapes, align 8
  %tup_val_slot_base34 = ptrtoint ptr %shapes33 to i64
  %tup_val_slot_addr35 = add i64 %tup_val_slot_base34, 8
  %tup_val_slot36 = inttoptr i64 %tup_val_slot_addr35 to ptr
  %tup_val37 = load i64, ptr %tup_val_slot36, align 8
  %cast38 = inttoptr i64 %tup_val37 to ptr
  %8 = call i64 @area(ptr %cast38)
  store i64 %8, ptr %a1, align 8
  %a039 = load i64, ptr %a0, align 8
  %a140 = load i64, ptr %a1, align 8
  %add = add i64 %a039, %a140
  store i64 %add, ptr %total, align 8
  %total41 = load i64, ptr %total, align 8
  ret i64 %total41
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
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 102, i64 45)
  %div = sdiv i64 %a2, %b3
  ret i64 %div

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @double(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, 2
  ret i64 %mul
}

define i64 @main() {
entry:
  %nc_result7 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %0 = call i64 @make_shapes()
  store i64 %0, ptr @total, align 8
  %total = load i64, ptr @total, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.7, i64 %total)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen1 = sext i32 %3 to i64
  %4 = call i64 @safe_div(i64 100, i64 4)
  %nc_null = icmp eq i64 %4, 0
  store i64 %4, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

nc_rhs:                                           ; preds = %entry
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %entry
  %nc_val = load i64, ptr %nc_result, align 8
  store i64 %nc_val, ptr @result, align 8
  %result = load i64, ptr @result, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.8, i64 %result)
  %widen2 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen3 = sext i32 %7 to i64
  %8 = call i64 @safe_div(i64 100, i64 0)
  %nc_null4 = icmp eq i64 %8, 0
  store i64 %8, ptr %nc_result7, align 8
  br i1 %nc_null4, label %nc_rhs5, label %nc_end6

nc_rhs5:                                          ; preds = %nc_end
  store i64 -1, ptr %nc_result7, align 8
  br label %nc_end6

nc_end6:                                          ; preds = %nc_rhs5, %nc_end
  %nc_val8 = load i64, ptr %nc_result7, align 8
  store i64 %nc_val8, ptr @result2, align 8
  %result2 = load i64, ptr @result2, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.9, i64 %result2)
  %widen9 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen10 = sext i32 %11 to i64
  %12 = call i64 @double(i64 5)
  store i64 %12, ptr @val, align 8
  %13 = call ptr @avra_rc_alloc(i64 16)
  %val = load i64, ptr @val, align 8
  %slot_base = ptrtoint ptr %13 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %val, ptr %slot, align 8
  %val11 = load i64, ptr @val, align 8
  %add = add i64 %val11, 1
  %slot_base12 = ptrtoint ptr %13 to i64
  %slot_addr13 = add i64 %slot_base12, 8
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  store i64 %add, ptr %slot14, align 8
  %cast = ptrtoint ptr %13 to i64
  store i64 %cast, ptr @pair, align 8
  %pair = load ptr, ptr @pair, align 8
  %tup_val_slot_base = ptrtoint ptr %pair to i64
  %tup_val_slot_addr = add i64 %tup_val_slot_base, 0
  %tup_val_slot = inttoptr i64 %tup_val_slot_addr to ptr
  %tup_val = load i64, ptr %tup_val_slot, align 8
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.10, i64 %tup_val)
  %widen15 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen16 = sext i32 %16 to i64
  %pair17 = load ptr, ptr @pair, align 8
  %tup_val_slot_base18 = ptrtoint ptr %pair17 to i64
  %tup_val_slot_addr19 = add i64 %tup_val_slot_base18, 8
  %tup_val_slot20 = inttoptr i64 %tup_val_slot_addr19 to ptr
  %tup_val21 = load i64, ptr %tup_val_slot20, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.11, i64 %tup_val21)
  %widen22 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen23 = sext i32 %19 to i64
  %20 = call i32 @avra_test_summary()
  %widen24 = sext i32 %20 to i64
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
  %is_Circle = icmp eq i64 %tag, 6952139942519
  br i1 %is_Circle, label %rel_Circle, label %try_next_Circle

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Rect, %vrel_origin_skip, %vrel_center_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Circle:                                       ; preds = %do_free
  %vrel_center_ptr = getelementptr inbounds nuw %Shape__Circle, ptr %payload, i32 0, i32 0
  %vrel_center = load ptr, ptr %vrel_center_ptr, align 8
  %vrel_null_center = icmp eq ptr %vrel_center, null
  br i1 %vrel_null_center, label %vrel_center_skip, label %vrel_center_do

try_next_Circle:                                  ; preds = %do_free
  %is_Rect = icmp eq i64 %tag, 6384501107
  br i1 %is_Rect, label %rel_Rect, label %try_next_Rect

vrel_center_skip:                                 ; preds = %vrel_center_do, %rel_Circle
  br label %fields_done

vrel_center_do:                                   ; preds = %rel_Circle
  call void @avra_rc_release(ptr %vrel_center)
  br label %vrel_center_skip

rel_Rect:                                         ; preds = %try_next_Circle
  %vrel_origin_ptr = getelementptr inbounds nuw %Shape__Rect, ptr %payload, i32 0, i32 0
  %vrel_origin = load ptr, ptr %vrel_origin_ptr, align 8
  %vrel_null_origin = icmp eq ptr %vrel_origin, null
  br i1 %vrel_null_origin, label %vrel_origin_skip, label %vrel_origin_do

try_next_Rect:                                    ; preds = %try_next_Circle
  br label %fields_done

vrel_origin_skip:                                 ; preds = %vrel_origin_do, %rel_Rect
  br label %fields_done

vrel_origin_do:                                   ; preds = %rel_Rect
  call void @avra_rc_release(ptr %vrel_origin)
  br label %vrel_origin_skip
}
