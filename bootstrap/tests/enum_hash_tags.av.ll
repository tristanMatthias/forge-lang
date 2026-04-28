; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Color = type { i64, ptr }
%Shape = type { i64, ptr }
%Token = type { i64, ptr }
%Dir = type { i64, ptr }

@.str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"blue\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@.match_fn = private unnamed_addr constant [11 x i8] c"color_name\00", align 1
@mu_file = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_hash_tags.av\00", align 1
@dz_file = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_hash_tags.av\00", align 1
@.match_fn.3 = private unnamed_addr constant [5 x i8] c"area\00", align 1
@mu_file.4 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_hash_tags.av\00", align 1
@.match_fn.5 = private unnamed_addr constant [12 x i8] c"token_check\00", align 1
@mu_file.6 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_hash_tags.av\00", align 1
@.str.7 = private unnamed_addr constant [14 x i8] c"circle area: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [8 x i8] c"found: \00", align 1
@.match_fn.9 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.10 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_hash_tags.av\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [11 x i8] c"three true\00", align 1
@.str.13 = private unnamed_addr constant [12 x i8] c"three false\00", align 1
@.str.14 = private unnamed_addr constant [7 x i8] c"cmp ok\00", align 1
@.str.15 = private unnamed_addr constant [9 x i8] c"cmp fail\00", align 1

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

define ptr @color_name(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %c = alloca ptr, align 8
  store ptr %0, ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %c1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193469728
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm5, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6383934317
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq7 = icmp eq i64 %tag, 210675960374
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next3
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next3
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 13)
  unreachable
}

define i64 @area(ptr %0) {
entry:
  %s24 = alloca i64, align 8
  %h14 = alloca i64, align 8
  %b11 = alloca i64, align 8
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

match_end:                                        ; preds = %march_arm18, %march_arm6, %march_arm
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
  %tag_eq8 = icmp eq i64 %tag, 7571616179632859
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %b_slot_base = ptrtoint ptr %payload10 to i64
  %b_slot_addr = add i64 %b_slot_base, 0
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load i64, ptr %b_slot, align 8
  store i64 %b, ptr %b11, align 8
  %pay_slot12 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload13 = load ptr, ptr %pay_slot12, align 8
  %h_slot_base = ptrtoint ptr %payload13 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h14, align 8
  %b15 = load i64, ptr %b11, align 8
  %h16 = load i64, ptr %h14, align 8
  %mul17 = mul i64 %b15, %h16
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 100, i64 27)
  %div = sdiv i64 %mul17, 2
  store i64 %div, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  %tag_eq20 = icmp eq i64 %tag, 6952775702006
  br i1 %tag_eq20, label %march_arm18, label %march_next19

march_arm18:                                      ; preds = %march_next7
  %pay_slot21 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload22 = load ptr, ptr %pay_slot21, align 8
  %s_slot_base = ptrtoint ptr %payload22 to i64
  %s_slot_addr = add i64 %s_slot_base, 0
  %s_slot = inttoptr i64 %s_slot_addr to ptr
  %s23 = load i64, ptr %s_slot, align 8
  store i64 %s23, ptr %s24, align 8
  %s25 = load i64, ptr %s24, align 8
  %s26 = load i64, ptr %s24, align 8
  %mul27 = mul i64 %s25, %s26
  store i64 %mul27, ptr %match_result, align 8
  br label %match_end

march_next19:                                     ; preds = %march_next7
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %tag, ptr @mu_file.4, i64 27)
  unreachable
}

define i1 @token_check(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %t = alloca ptr, align 8
  store ptr %0, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %tag_ptr = getelementptr inbounds nuw %Token, ptr %t1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 177640
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = trunc i64 %match_val to i1
  ret i1 %cast

march_arm:                                        ; preds = %entry
  store i64 1, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  br label %march_arm2

march_arm2:                                       ; preds = %march_next
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 38)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %sif_result = alloca i64, align 8
  %match_result = alloca i64, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %2 = call ptr @color_name(ptr %cast1)
  %3 = call i32 @puts(ptr %2)
  %widen = sext i32 %3 to i64
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Shape, ptr %4, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Shape, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr3, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast4 = ptrtoint ptr %4 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  %6 = call i64 @area(ptr %cast5)
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt, i64 %6)
  %widen6 = sext i32 %8 to i64
  %9 = call i64 @strlen(ptr @.str.7)
  %10 = call i64 @strlen(ptr %7)
  %concat_total = add i64 %9, %10
  %concat_size = add i64 %concat_total, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size)
  %12 = call ptr @memcpy(ptr %11, ptr @.str.7, i64 %9)
  %cast7 = ptrtoint ptr %11 to i64
  %dst2_int = add i64 %cast7, %9
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast8, ptr %7, i64 %rhs_len_p1)
  %14 = call i32 @puts(ptr %11)
  %widen9 = sext i32 %14 to i64
  %15 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Color, ptr %15, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %Color, ptr %15, i32 0, i32 1
  store ptr null, ptr %pay_ptr11, align 8
  %cast12 = ptrtoint ptr %15 to i64
  %cast13 = inttoptr i64 %cast12 to ptr
  %cast14 = inttoptr i64 %cast12 to ptr
  %tag_ptr15 = getelementptr inbounds nuw %Color, ptr %cast14, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr15, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193469728
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm16, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.11, i64 %match_val)
  %widen18 = sext i32 %17 to i64
  %18 = call i64 @strlen(ptr @.str.8)
  %19 = call i64 @strlen(ptr %16)
  %concat_total19 = add i64 %18, %19
  %concat_size20 = add i64 %concat_total19, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size20)
  %21 = call ptr @memcpy(ptr %20, ptr @.str.8, i64 %18)
  %cast21 = ptrtoint ptr %20 to i64
  %dst2_int22 = add i64 %cast21, %18
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast23, ptr %16, i64 %rhs_len_p124)
  %23 = call i32 @puts(ptr %20)
  %widen25 = sext i32 %23 to i64
  %24 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %Token, ptr %24, i32 0, i32 0
  store i64 177640, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %Token, ptr %24, i32 0, i32 1
  store ptr null, ptr %pay_ptr27, align 8
  %cast28 = ptrtoint ptr %24 to i64
  %cast29 = inttoptr i64 %cast28 to ptr
  %25 = call i1 @token_check(ptr %cast29)
  %widen30 = zext i1 %25 to i64
  %if_cond = icmp ne i64 %widen30, 0
  br i1 %if_cond, label %if_then, label %if_else

march_arm:                                        ; preds = %entry
  store i64 42, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  br label %march_arm16

march_arm16:                                      ; preds = %march_next
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next17:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.9, i64 %tag, ptr @mu_file.10, i64 50)
  unreachable

ifcont:                                           ; preds = %if_else, %if_then
  %26 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr33 = getelementptr inbounds nuw %Dir, ptr %26, i32 0, i32 0
  store i64 5862826, ptr %tag_ptr33, align 8
  %pay_ptr34 = getelementptr inbounds nuw %Dir, ptr %26, i32 0, i32 1
  store ptr null, ptr %pay_ptr34, align 8
  %cast35 = ptrtoint ptr %26 to i64
  %27 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %Dir, ptr %27, i32 0, i32 0
  store i64 5862826, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %Dir, ptr %27, i32 0, i32 1
  store ptr null, ptr %pay_ptr37, align 8
  %cast38 = ptrtoint ptr %27 to i64
  %cast39 = inttoptr i64 %cast35 to ptr
  %cast40 = inttoptr i64 %cast38 to ptr
  %ltag_ptr = getelementptr inbounds nuw %Dir, ptr %cast39, i32 0, i32 0
  %rtag_ptr = getelementptr inbounds nuw %Dir, ptr %cast40, i32 0, i32 0
  %ltag = load i64, ptr %ltag_ptr, align 8
  %rtag = load i64, ptr %rtag_ptr, align 8
  %tag_cmp = icmp eq i64 %ltag, %rtag
  %tag_cmp_ext = zext i1 %tag_cmp to i64
  %l_bool = icmp ne i64 %tag_cmp_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

if_then:                                          ; preds = %match_end
  %28 = call i32 @puts(ptr @.str.12)
  %widen31 = sext i32 %28 to i64
  br label %ifcont

if_else:                                          ; preds = %match_end
  %29 = call i32 @puts(ptr @.str.13)
  %widen32 = sext i32 %29 to i64
  br label %ifcont

sc_rhs:                                           ; preds = %ifcont
  %30 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr41 = getelementptr inbounds nuw %Dir, ptr %30, i32 0, i32 0
  store i64 6384285584, ptr %tag_ptr41, align 8
  %pay_ptr42 = getelementptr inbounds nuw %Dir, ptr %30, i32 0, i32 1
  store ptr null, ptr %pay_ptr42, align 8
  %cast43 = ptrtoint ptr %30 to i64
  %31 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr44 = getelementptr inbounds nuw %Dir, ptr %31, i32 0, i32 0
  store i64 210688684355, ptr %tag_ptr44, align 8
  %pay_ptr45 = getelementptr inbounds nuw %Dir, ptr %31, i32 0, i32 1
  store ptr null, ptr %pay_ptr45, align 8
  %cast46 = ptrtoint ptr %31 to i64
  %cast47 = inttoptr i64 %cast43 to ptr
  %cast48 = inttoptr i64 %cast46 to ptr
  %ltag_ptr49 = getelementptr inbounds nuw %Dir, ptr %cast47, i32 0, i32 0
  %rtag_ptr50 = getelementptr inbounds nuw %Dir, ptr %cast48, i32 0, i32 0
  %ltag51 = load i64, ptr %ltag_ptr49, align 8
  %rtag52 = load i64, ptr %rtag_ptr50, align 8
  %tag_cmp53 = icmp ne i64 %ltag51, %rtag52
  %tag_cmp_ext54 = zext i1 %tag_cmp53 to i64
  %r_bool = icmp ne i64 %tag_cmp_ext54, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %ifcont
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
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
  %32 = call i32 @puts(ptr @.str.14)
  %widen55 = sext i32 %32 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %sc_merge
  %33 = call i32 @puts(ptr @.str.15)
  %widen56 = sext i32 %33 to i64
  store i64 0, ptr %sif_result, align 8
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
