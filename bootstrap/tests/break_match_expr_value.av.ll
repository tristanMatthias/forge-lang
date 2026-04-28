; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@x = global i64 0
@items = global i64 0
@val = global i64 0
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_match_expr_value.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.match_fn.2 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.3 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_match_expr_value.av\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"huge\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"normal\00", align 1
@.match_fn.6 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.7 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_match_expr_value.av\00", align 1
@.str.8 = private unnamed_addr constant [9 x i8] c"result: \00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.match_fn.11 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.12 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_match_expr_value.av\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"huge\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.match_fn.15 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.16 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_match_expr_value.av\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.18 = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.match_fn.19 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.20 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_match_expr_value.av\00", align 1

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

define i64 @main() {
entry:
  %pmatch_result59 = alloca i64, align 8
  %pmatch_result50 = alloca i64, align 8
  %pmatch_result35 = alloca i64, align 8
  %pmatch_result19 = alloca i64, align 8
  %pmatch_result7 = alloca i64, align 8
  %pmatch_result = alloca i64, align 8
  store i64 5, ptr @x, align 8
  %x = load i64, ptr @x, align 8
  store i64 0, ptr %pmatch_result, align 8
  %x1 = load i64, ptr @x, align 8
  %sgt = icmp sgt i64 %x1, 3
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %0 = call i64 @double(i64 %pmatch_val)
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %0)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen5 = sext i32 %3 to i64
  %4 = call ptr @avra_array_new()
  %x6 = load i64, ptr @x, align 8
  store i64 0, ptr %pmatch_result7, align 8
  %x11 = load i64, ptr @x, align 8
  %sgt12 = icmp sgt i64 %x11, 3
  %sgt_ext13 = zext i1 %sgt12 to i64
  %pguard14 = icmp ne i64 %sgt_ext13, 0
  br i1 %pguard14, label %parm_body9, label %parm_next10

parm_body:                                        ; preds = %entry
  %x2 = load i64, ptr @x, align 8
  store i64 %x2, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  br label %parm_body3

parm_body3:                                       ; preds = %parm_next
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 6)
  unreachable

pmatch_end8:                                      ; preds = %parm_body15, %parm_body9
  %pmatch_val17 = load i64, ptr %pmatch_result7, align 8
  call void @avra_array_push(ptr %4, i64 %pmatch_val17)
  %x18 = load i64, ptr @x, align 8
  store i64 0, ptr %pmatch_result19, align 8
  %x23 = load i64, ptr @x, align 8
  %sgt24 = icmp sgt i64 %x23, 10
  %sgt_ext25 = zext i1 %sgt24 to i64
  %pguard26 = icmp ne i64 %sgt_ext25, 0
  br i1 %pguard26, label %parm_body21, label %parm_next22

parm_body9:                                       ; preds = %pmatch_end
  store i64 ptrtoint (ptr @.str to i64), ptr %pmatch_result7, align 8
  br label %pmatch_end8

parm_next10:                                      ; preds = %pmatch_end
  br label %parm_body15

parm_body15:                                      ; preds = %parm_next10
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %pmatch_result7, align 8
  br label %pmatch_end8

parm_next16:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.2, i64 -1, ptr @mu_file.3, i64 9)
  unreachable

pmatch_end20:                                     ; preds = %parm_body27, %parm_body21
  %pmatch_val29 = load i64, ptr %pmatch_result19, align 8
  call void @avra_array_push(ptr %4, i64 %pmatch_val29)
  store ptr %4, ptr @items, align 8
  %items = load ptr, ptr @items, align 8
  %5 = call i64 @avra_array_get(ptr %items, i64 0)
  %cast = inttoptr i64 %5 to ptr
  %6 = call i32 @puts(ptr %cast)
  %widen30 = sext i32 %6 to i64
  %items31 = load ptr, ptr @items, align 8
  %7 = call i64 @avra_array_get(ptr %items31, i64 1)
  %cast32 = inttoptr i64 %7 to ptr
  %8 = call i32 @puts(ptr %cast32)
  %widen33 = sext i32 %8 to i64
  %x34 = load i64, ptr @x, align 8
  store i64 0, ptr %pmatch_result35, align 8
  %x39 = load i64, ptr @x, align 8
  %sgt40 = icmp sgt i64 %x39, 0
  %sgt_ext41 = zext i1 %sgt40 to i64
  %pguard42 = icmp ne i64 %sgt_ext41, 0
  br i1 %pguard42, label %parm_body37, label %parm_next38

parm_body21:                                      ; preds = %pmatch_end8
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %pmatch_result19, align 8
  br label %pmatch_end20

parm_next22:                                      ; preds = %pmatch_end8
  br label %parm_body27

parm_body27:                                      ; preds = %parm_next22
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %pmatch_result19, align 8
  br label %pmatch_end20

parm_next28:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.6, i64 -1, ptr @mu_file.7, i64 9)
  unreachable

pmatch_end36:                                     ; preds = %parm_body43, %parm_body37
  %pmatch_val45 = load i64, ptr %pmatch_result35, align 8
  %rhs_ptr = inttoptr i64 %pmatch_val45 to ptr
  %9 = call i64 @strlen(ptr @.str.8)
  %10 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total = add i64 %9, %10
  %concat_size = add i64 %concat_total, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size)
  %12 = call ptr @memcpy(ptr %11, ptr @.str.8, i64 %9)
  %cast46 = ptrtoint ptr %11 to i64
  %dst2_int = add i64 %cast46, %9
  %cast47 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast47, ptr %rhs_ptr, i64 %rhs_len_p1)
  %14 = call i32 @puts(ptr %11)
  %widen48 = sext i32 %14 to i64
  %x49 = load i64, ptr @x, align 8
  store i64 0, ptr %pmatch_result50, align 8
  %x54 = load i64, ptr @x, align 8
  %sgt55 = icmp sgt i64 %x54, 10
  %sgt_ext56 = zext i1 %sgt55 to i64
  %pguard57 = icmp ne i64 %sgt_ext56, 0
  br i1 %pguard57, label %parm_body52, label %parm_next53

parm_body37:                                      ; preds = %pmatch_end20
  store i64 ptrtoint (ptr @.str.9 to i64), ptr %pmatch_result35, align 8
  br label %pmatch_end36

parm_next38:                                      ; preds = %pmatch_end20
  br label %parm_body43

parm_body43:                                      ; preds = %parm_next38
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %pmatch_result35, align 8
  br label %pmatch_end36

parm_next44:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.11, i64 -1, ptr @mu_file.12, i64 17)
  unreachable

pmatch_end51:                                     ; preds = %parm_body76, %parm_body70, %pmatch_end60
  %pmatch_val78 = load i64, ptr %pmatch_result50, align 8
  store i64 %pmatch_val78, ptr @val, align 8
  %val = load ptr, ptr @val, align 8
  %15 = call i32 @puts(ptr %val)
  %widen79 = sext i32 %15 to i64
  %16 = call i32 @avra_test_summary()
  %widen80 = sext i32 %16 to i64
  call void @avra_rc_collect()
  ret i64 0

parm_body52:                                      ; preds = %pmatch_end36
  %x58 = load i64, ptr @x, align 8
  store i64 0, ptr %pmatch_result59, align 8
  %x63 = load i64, ptr @x, align 8
  %sgt64 = icmp sgt i64 %x63, 100
  %sgt_ext65 = zext i1 %sgt64 to i64
  %pguard66 = icmp ne i64 %sgt_ext65, 0
  br i1 %pguard66, label %parm_body61, label %parm_next62

parm_next53:                                      ; preds = %pmatch_end36
  %x72 = load i64, ptr @x, align 8
  %sgt73 = icmp sgt i64 %x72, 0
  %sgt_ext74 = zext i1 %sgt73 to i64
  %pguard75 = icmp ne i64 %sgt_ext74, 0
  br i1 %pguard75, label %parm_body70, label %parm_next71

pmatch_end60:                                     ; preds = %parm_body67, %parm_body61
  %pmatch_val69 = load i64, ptr %pmatch_result59, align 8
  store i64 %pmatch_val69, ptr %pmatch_result50, align 8
  br label %pmatch_end51

parm_body61:                                      ; preds = %parm_body52
  store i64 ptrtoint (ptr @.str.13 to i64), ptr %pmatch_result59, align 8
  br label %pmatch_end60

parm_next62:                                      ; preds = %parm_body52
  br label %parm_body67

parm_body67:                                      ; preds = %parm_next62
  store i64 ptrtoint (ptr @.str.14 to i64), ptr %pmatch_result59, align 8
  br label %pmatch_end60

parm_next68:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.15, i64 -1, ptr @mu_file.16, i64 20)
  unreachable

parm_body70:                                      ; preds = %parm_next53
  store i64 ptrtoint (ptr @.str.17 to i64), ptr %pmatch_result50, align 8
  br label %pmatch_end51

parm_next71:                                      ; preds = %parm_next53
  br label %parm_body76

parm_body76:                                      ; preds = %parm_next71
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %pmatch_result50, align 8
  br label %pmatch_end51

parm_next77:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.19, i64 -1, ptr @mu_file.20, i64 20)
  unreachable
}
