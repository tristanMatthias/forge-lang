; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Depth = type { i64, ptr }
%Wrapper = type { i64, ptr }
%Wrapper__Holds = type { ptr }
%Depth__Deep = type { ptr }

@.str = private unnamed_addr constant [17 x i8] c"empty list len: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"shallow\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"medium\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"deep-shallow\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"deep-medium\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"deep\00", align 1
@.match_fn = private unnamed_addr constant [11 x i8] c"depth_name\00", align 1
@mu_file = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_edge_cases.av\00", align 1
@.match_fn.6 = private unnamed_addr constant [11 x i8] c"depth_name\00", align 1
@mu_file.7 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_edge_cases.av\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"_world\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"got: \00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [9 x i8] c"fallback\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"empty\00", align 1
@.str.13 = private unnamed_addr constant [10 x i8] c"inner: 42\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn.15 = private unnamed_addr constant [13 x i8] c"unwrap_depth\00", align 1
@mu_file.16 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_edge_cases.av\00", align 1
@.str.17 = private unnamed_addr constant [9 x i8] c"not deep\00", align 1
@.match_fn.18 = private unnamed_addr constant [13 x i8] c"unwrap_depth\00", align 1
@mu_file.19 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_edge_cases.av\00", align 1
@.match_fn.20 = private unnamed_addr constant [13 x i8] c"unwrap_depth\00", align 1
@mu_file.21 = private unnamed_addr constant [103 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_edge_cases.av\00", align 1
@.str.22 = private unnamed_addr constant [15 x i8] c"nested match: \00", align 1
@.str.23 = private unnamed_addr constant [13 x i8] c"string ops: \00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.25 = private unnamed_addr constant [17 x i8] c"nullable chain: \00", align 1
@.str.26 = private unnamed_addr constant [12 x i8] c"recursive: \00", align 1
@.i2s_fmt.27 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.28 = private unnamed_addr constant [15 x i8] c"enum in enum: \00", align 1

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

define ptr @empty_test() {
entry:
  %empty = alloca ptr, align 8
  %0 = call ptr @avra_array_new()
  store ptr %0, ptr %empty, align 8
  %empty1 = load ptr, ptr %empty, align 8
  %1 = call i64 @avra_array_len(ptr %empty1)
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %1)
  %widen = sext i32 %3 to i64
  %4 = call i64 @strlen(ptr @.str)
  %5 = call i64 @strlen(ptr %2)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr @.str, i64 %4)
  %cast = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast, %4
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast2, ptr %2, i64 %rhs_len_p1)
  ret ptr %6
}

define ptr @depth_name(ptr %0) {
entry:
  %match_result12 = alloca i64, align 8
  %inner8 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %d = alloca ptr, align 8
  store ptr %0, ptr %d, align 8
  %d1 = load ptr, ptr %d, align 8
  %tag_ptr = getelementptr inbounds nuw %Depth, ptr %d1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 229441222618463
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %match_end13, %march_arm2, %march_arm
  %match_val23 = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val23 to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6952526056486
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq7 = icmp eq i64 %tag, 6383998051
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next3
  %pay_slot = getelementptr inbounds nuw %Depth, ptr %d1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %inner_slot_base = ptrtoint ptr %payload to i64
  %inner_slot_addr = add i64 %inner_slot_base, 0
  %inner_slot = inttoptr i64 %inner_slot_addr to ptr
  %inner = load ptr, ptr %inner_slot, align 8
  call void @avra_rc_retain(ptr %inner)
  store ptr %inner, ptr %inner8, align 8
  %inner9 = load ptr, ptr %inner8, align 8
  %tag_ptr10 = getelementptr inbounds nuw %Depth, ptr %inner9, i32 0, i32 0
  %tag11 = load i64, ptr %tag_ptr10, align 8
  store i64 0, ptr %match_result12, align 8
  %tag_eq16 = icmp eq i64 %tag11, 229441222618463
  br i1 %tag_eq16, label %march_arm14, label %march_next15

march_next6:                                      ; preds = %march_next3
  call void @avra_match_unreachable(ptr @.match_fn.6, i64 %tag, ptr @mu_file.7, i64 18)
  unreachable

match_end13:                                      ; preds = %march_arm20, %march_arm17, %march_arm14
  %match_val = load i64, ptr %match_result12, align 8
  store i64 %match_val, ptr %match_result, align 8
  br label %match_end

march_arm14:                                      ; preds = %march_arm5
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result12, align 8
  br label %match_end13

march_next15:                                     ; preds = %march_arm5
  %tag_eq19 = icmp eq i64 %tag11, 6952526056486
  br i1 %tag_eq19, label %march_arm17, label %march_next18

march_arm17:                                      ; preds = %march_next15
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %match_result12, align 8
  br label %match_end13

march_next18:                                     ; preds = %march_next15
  %tag_eq22 = icmp eq i64 %tag11, 6383998051
  br i1 %tag_eq22, label %march_arm20, label %march_next21

march_arm20:                                      ; preds = %march_next18
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %match_result12, align 8
  br label %match_end13

march_next21:                                     ; preds = %march_next18
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag11, ptr @mu_file, i64 18)
  unreachable
}

define ptr @transform(ptr %0) {
entry:
  %combined = alloca ptr, align 8
  %upper = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call ptr @avra_str_to_upper(ptr %s1)
  store ptr %1, ptr %upper, align 8
  %upper2 = load ptr, ptr %upper, align 8
  %2 = call i64 @strlen(ptr %upper2)
  %3 = call i64 @strlen(ptr @.str.8)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr %upper2, i64 %2)
  %cast = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast, %2
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast3, ptr @.str.8, i64 %rhs_len_p1)
  store ptr %4, ptr %combined, align 8
  %combined4 = load ptr, ptr %combined, align 8
  ret ptr %combined4
}

define i64 @maybe_val(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %sif_cond = icmp ne i64 %sgt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %x2 = load i64, ptr %x, align 8
  store i64 %x2, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define ptr @chain_nullable(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %a = alloca i64, align 8
  %nc_result6 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call i64 @maybe_val(i64 %x1)
  %nc_null = icmp eq i64 %1, 0
  store i64 %1, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

nc_rhs:                                           ; preds = %entry
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %x2, 10
  %2 = call i64 @maybe_val(i64 %add)
  store i64 %2, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %entry
  %nc_val = load i64, ptr %nc_result, align 8
  %nc_null3 = icmp eq i64 %nc_val, 0
  store i64 %nc_val, ptr %nc_result6, align 8
  br i1 %nc_null3, label %nc_rhs4, label %nc_end5

nc_rhs4:                                          ; preds = %nc_end
  store i64 -1, ptr %nc_result6, align 8
  br label %nc_end5

nc_end5:                                          ; preds = %nc_rhs4, %nc_end
  %nc_val7 = load i64, ptr %nc_result6, align 8
  store i64 %nc_val7, ptr %a, align 8
  %a8 = load i64, ptr %a, align 8
  %sgt = icmp sgt i64 %a8, 0
  %sgt_ext = zext i1 %sgt to i64
  %sif_cond = icmp ne i64 %sgt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %nc_end5
  %a9 = load i64, ptr %a, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.10, i64 %a9)
  %widen = sext i32 %4 to i64
  %5 = call i64 @strlen(ptr @.str.9)
  %6 = call i64 @strlen(ptr %3)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.9, i64 %5)
  %cast = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast, %5
  %cast10 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast10, ptr %3, i64 %rhs_len_p1)
  %cast11 = ptrtoint ptr %7 to i64
  store i64 %cast11, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %nc_end5
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast12 = inttoptr i64 %sif_val to ptr
  ret ptr %cast12
}

define i64 @factorial(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sle = icmp sle i64 %n1, 1
  %sle_ext = zext i1 %sle to i64
  %sif_cond = icmp ne i64 %sle_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  store i64 1, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  %n3 = load i64, ptr %n, align 8
  %sub = sub i64 %n3, 1
  %1 = call i64 @factorial(i64 %sub)
  %mul = mul i64 %n2, %1
  store i64 %mul, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define ptr @unwrap_depth(ptr %0) {
entry:
  %match_result20 = alloca i64, align 8
  %inner16 = alloca ptr, align 8
  %match_result9 = alloca i64, align 8
  %d5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %w = alloca ptr, align 8
  store ptr %0, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %tag_ptr = getelementptr inbounds nuw %Wrapper, ptr %w1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210673421332
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %match_end10, %march_arm
  %match_val30 = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val30 to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.12 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 210677046079
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %Wrapper, ptr %w1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %d_slot_base = ptrtoint ptr %payload to i64
  %d_slot_addr = add i64 %d_slot_base, 0
  %d_slot = inttoptr i64 %d_slot_addr to ptr
  %d = load ptr, ptr %d_slot, align 8
  call void @avra_rc_retain(ptr %d)
  store ptr %d, ptr %d5, align 8
  %d6 = load ptr, ptr %d5, align 8
  %tag_ptr7 = getelementptr inbounds nuw %Depth, ptr %d6, i32 0, i32 0
  %tag8 = load i64, ptr %tag_ptr7, align 8
  store i64 0, ptr %match_result9, align 8
  %tag_eq13 = icmp eq i64 %tag8, 6383998051
  br i1 %tag_eq13, label %march_arm11, label %march_next12

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.20, i64 %tag, ptr @mu_file.21, i64 55)
  unreachable

match_end10:                                      ; preds = %march_arm27, %match_end21
  %match_val29 = load i64, ptr %match_result9, align 8
  store i64 %match_val29, ptr %match_result, align 8
  br label %match_end

march_arm11:                                      ; preds = %march_arm2
  %pay_slot14 = getelementptr inbounds nuw %Depth, ptr %d6, i32 0, i32 1
  %payload15 = load ptr, ptr %pay_slot14, align 8
  %inner_slot_base = ptrtoint ptr %payload15 to i64
  %inner_slot_addr = add i64 %inner_slot_base, 0
  %inner_slot = inttoptr i64 %inner_slot_addr to ptr
  %inner = load ptr, ptr %inner_slot, align 8
  call void @avra_rc_retain(ptr %inner)
  store ptr %inner, ptr %inner16, align 8
  %inner17 = load ptr, ptr %inner16, align 8
  %tag_ptr18 = getelementptr inbounds nuw %Depth, ptr %inner17, i32 0, i32 0
  %tag19 = load i64, ptr %tag_ptr18, align 8
  store i64 0, ptr %match_result20, align 8
  %tag_eq24 = icmp eq i64 %tag19, 229441222618463
  br i1 %tag_eq24, label %march_arm22, label %march_next23

march_next12:                                     ; preds = %march_arm2
  br label %march_arm27

match_end21:                                      ; preds = %march_arm25, %march_arm22
  %match_val = load i64, ptr %match_result20, align 8
  store i64 %match_val, ptr %match_result9, align 8
  br label %match_end10

march_arm22:                                      ; preds = %march_arm11
  store i64 ptrtoint (ptr @.str.13 to i64), ptr %match_result20, align 8
  br label %match_end21

march_next23:                                     ; preds = %march_arm11
  br label %march_arm25

march_arm25:                                      ; preds = %march_next23
  store i64 ptrtoint (ptr @.str.14 to i64), ptr %match_result20, align 8
  br label %match_end21

march_next26:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.15, i64 %tag19, ptr @mu_file.16, i64 55)
  unreachable

march_arm27:                                      ; preds = %march_next12
  store i64 ptrtoint (ptr @.str.17 to i64), ptr %match_result9, align 8
  br label %match_end10

march_next28:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.18, i64 %tag8, ptr @mu_file.19, i64 55)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call ptr @empty_test()
  %2 = call i32 @puts(ptr %1)
  %widen = sext i32 %2 to i64
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Depth, ptr %3, i32 0, i32 0
  store i64 6383998051, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Depth, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Depth, ptr %5, i32 0, i32 0
  store i64 6383998051, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Depth, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr2, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Depth, ptr %7, i32 0, i32 0
  store i64 229441222618463, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Depth, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr4, align 8
  %cast = ptrtoint ptr %7 to i64
  %slot_base = ptrtoint ptr %6 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast5 = inttoptr i64 %cast to ptr
  store ptr %cast5, ptr %slot, align 8
  %cast6 = ptrtoint ptr %5 to i64
  %slot_base7 = ptrtoint ptr %4 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  %cast10 = inttoptr i64 %cast6 to ptr
  store ptr %cast10, ptr %slot9, align 8
  %cast11 = ptrtoint ptr %3 to i64
  %cast12 = inttoptr i64 %cast11 to ptr
  %8 = call ptr @depth_name(ptr %cast12)
  %9 = call i64 @strlen(ptr @.str.22)
  %10 = call i64 @strlen(ptr %8)
  %concat_total = add i64 %9, %10
  %concat_size = add i64 %concat_total, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size)
  %12 = call ptr @memcpy(ptr %11, ptr @.str.22, i64 %9)
  %cast13 = ptrtoint ptr %11 to i64
  %dst2_int = add i64 %cast13, %9
  %cast14 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast14, ptr %8, i64 %rhs_len_p1)
  %14 = call i32 @puts(ptr %11)
  %widen15 = sext i32 %14 to i64
  %15 = call ptr @transform(ptr @.str.24)
  %16 = call i64 @strlen(ptr @.str.23)
  %17 = call i64 @strlen(ptr %15)
  %concat_total16 = add i64 %16, %17
  %concat_size17 = add i64 %concat_total16, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %19 = call ptr @memcpy(ptr %18, ptr @.str.23, i64 %16)
  %cast18 = ptrtoint ptr %18 to i64
  %dst2_int19 = add i64 %cast18, %16
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast20, ptr %15, i64 %rhs_len_p121)
  %21 = call i32 @puts(ptr %18)
  %widen22 = sext i32 %21 to i64
  %22 = call ptr @chain_nullable(i64 -5)
  %23 = call i64 @strlen(ptr @.str.25)
  %24 = call i64 @strlen(ptr %22)
  %concat_total23 = add i64 %23, %24
  %concat_size24 = add i64 %concat_total23, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size24)
  %26 = call ptr @memcpy(ptr %25, ptr @.str.25, i64 %23)
  %cast25 = ptrtoint ptr %25 to i64
  %dst2_int26 = add i64 %cast25, %23
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast27, ptr %22, i64 %rhs_len_p128)
  %28 = call i32 @puts(ptr %25)
  %widen29 = sext i32 %28 to i64
  %29 = call i64 @factorial(i64 5)
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.27, i64 %29)
  %widen30 = sext i32 %31 to i64
  %32 = call i64 @strlen(ptr @.str.26)
  %33 = call i64 @strlen(ptr %30)
  %concat_total31 = add i64 %32, %33
  %concat_size32 = add i64 %concat_total31, 1
  %34 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %35 = call ptr @memcpy(ptr %34, ptr @.str.26, i64 %32)
  %cast33 = ptrtoint ptr %34 to i64
  %dst2_int34 = add i64 %cast33, %32
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast35, ptr %30, i64 %rhs_len_p136)
  %37 = call i32 @puts(ptr %34)
  %widen37 = sext i32 %37 to i64
  %38 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %Wrapper, ptr %38, i32 0, i32 0
  store i64 210677046079, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %Wrapper, ptr %38, i32 0, i32 1
  %39 = call ptr @avra_rc_alloc(i64 8)
  store ptr %39, ptr %pay_ptr39, align 8
  %40 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr40 = getelementptr inbounds nuw %Depth, ptr %40, i32 0, i32 0
  store i64 6383998051, ptr %tag_ptr40, align 8
  %pay_ptr41 = getelementptr inbounds nuw %Depth, ptr %40, i32 0, i32 1
  %41 = call ptr @avra_rc_alloc(i64 8)
  store ptr %41, ptr %pay_ptr41, align 8
  %42 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr42 = getelementptr inbounds nuw %Depth, ptr %42, i32 0, i32 0
  store i64 229441222618463, ptr %tag_ptr42, align 8
  %pay_ptr43 = getelementptr inbounds nuw %Depth, ptr %42, i32 0, i32 1
  store ptr null, ptr %pay_ptr43, align 8
  %cast44 = ptrtoint ptr %42 to i64
  %slot_base45 = ptrtoint ptr %41 to i64
  %slot_addr46 = add i64 %slot_base45, 0
  %slot47 = inttoptr i64 %slot_addr46 to ptr
  %cast48 = inttoptr i64 %cast44 to ptr
  store ptr %cast48, ptr %slot47, align 8
  %cast49 = ptrtoint ptr %40 to i64
  %slot_base50 = ptrtoint ptr %39 to i64
  %slot_addr51 = add i64 %slot_base50, 0
  %slot52 = inttoptr i64 %slot_addr51 to ptr
  %cast53 = inttoptr i64 %cast49 to ptr
  store ptr %cast53, ptr %slot52, align 8
  %cast54 = ptrtoint ptr %38 to i64
  %cast55 = inttoptr i64 %cast54 to ptr
  %43 = call ptr @unwrap_depth(ptr %cast55)
  %44 = call i64 @strlen(ptr @.str.28)
  %45 = call i64 @strlen(ptr %43)
  %concat_total56 = add i64 %44, %45
  %concat_size57 = add i64 %concat_total56, 1
  %46 = call ptr @avra_rc_alloc(i64 %concat_size57)
  %47 = call ptr @memcpy(ptr %46, ptr @.str.28, i64 %44)
  %cast58 = ptrtoint ptr %46 to i64
  %dst2_int59 = add i64 %cast58, %44
  %cast60 = inttoptr i64 %dst2_int59 to ptr
  %rhs_len_p161 = add i64 %45, 1
  %48 = call ptr @memcpy(ptr %cast60, ptr %43, i64 %rhs_len_p161)
  %49 = call i32 @puts(ptr %46)
  %widen62 = sext i32 %49 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Wrapper(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Wrapper, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Wrapper, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Holds = icmp eq i64 %tag, 210677046079
  br i1 %is_Holds, label %rel_Holds, label %try_next_Holds

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Holds, %vrel_value_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Holds:                                        ; preds = %do_free
  %vrel_value_ptr = getelementptr inbounds nuw %Wrapper__Holds, ptr %payload, i32 0, i32 0
  %vrel_value = load ptr, ptr %vrel_value_ptr, align 8
  %vrel_null_value = icmp eq ptr %vrel_value, null
  br i1 %vrel_null_value, label %vrel_value_skip, label %vrel_value_do

try_next_Holds:                                   ; preds = %do_free
  br label %fields_done

vrel_value_skip:                                  ; preds = %vrel_value_do, %rel_Holds
  br label %fields_done

vrel_value_do:                                    ; preds = %rel_Holds
  %2 = call i64 @__release_Depth(ptr %vrel_value)
  br label %vrel_value_skip
}

define i64 @__release_Depth(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Depth, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Depth, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Deep = icmp eq i64 %tag, 6383998051
  br i1 %is_Deep, label %rel_Deep, label %try_next_Deep

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Deep, %vrel_inner_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Deep:                                         ; preds = %do_free
  %vrel_inner_ptr = getelementptr inbounds nuw %Depth__Deep, ptr %payload, i32 0, i32 0
  %vrel_inner = load ptr, ptr %vrel_inner_ptr, align 8
  %vrel_null_inner = icmp eq ptr %vrel_inner, null
  br i1 %vrel_null_inner, label %vrel_inner_skip, label %vrel_inner_do

try_next_Deep:                                    ; preds = %do_free
  br label %fields_done

vrel_inner_skip:                                  ; preds = %vrel_inner_do, %rel_Deep
  br label %fields_done

vrel_inner_do:                                    ; preds = %rel_Deep
  %2 = call i64 @__release_Depth(ptr %vrel_inner)
  br label %vrel_inner_skip
}
