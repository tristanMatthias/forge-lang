; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Direction = type { i64, ptr }

@.match_fn = private unnamed_addr constant [14 x i8] c"is_horizontal\00", align 1
@mu_file = private unnamed_addr constant [136 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/or_pattern.av\00", align 1
@.str = private unnamed_addr constant [9 x i8] c"not west\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"west\00", align 1
@.match_fn.2 = private unnamed_addr constant [13 x i8] c"describe_dir\00", align 1
@mu_file.3 = private unnamed_addr constant [136 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/or_pattern.av\00", align 1
@.str.4 = private unnamed_addr constant [18 x i8] c"even single digit\00", align 1
@.str.5 = private unnamed_addr constant [17 x i8] c"odd single digit\00", align 1
@.str.6 = private unnamed_addr constant [24 x i8] c"multi-digit or negative\00", align 1
@.match_fn.7 = private unnamed_addr constant [7 x i8] c"parity\00", align 1
@mu_file.8 = private unnamed_addr constant [136 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/or_pattern.av\00", align 1
@.lit_str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.lit_str.9 = private unnamed_addr constant [2 x i8] c"e\00", align 1
@.lit_str.10 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.lit_str.11 = private unnamed_addr constant [2 x i8] c"o\00", align 1
@.lit_str.12 = private unnamed_addr constant [2 x i8] c"u\00", align 1
@.match_fn.13 = private unnamed_addr constant [14 x i8] c"is_vowel_word\00", align 1
@mu_file.14 = private unnamed_addr constant [136 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/or_pattern.av\00", align 1
@.str.15 = private unnamed_addr constant [15 x i8] c"small positive\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn.17 = private unnamed_addr constant [15 x i8] c"describe_small\00", align 1
@mu_file.18 = private unnamed_addr constant [136 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/or_pattern.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.i2s_fmt.22 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.23 = private unnamed_addr constant [2 x i8] c"e\00", align 1
@.i2s_fmt.24 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.25 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.i2s_fmt.26 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i1 @is_horizontal(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %d = alloca ptr, align 8
  store ptr %0, ptr %d, align 8
  %d1 = load ptr, ptr %d, align 8
  %tag_ptr = getelementptr inbounds nuw %Direction, ptr %d1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384030098
  br i1 %tag_eq, label %march_arm, label %or_mid

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = trunc i64 %match_val to i1
  ret i1 %cast

march_arm:                                        ; preds = %or_mid, %entry
  store i64 1, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %or_mid
  br label %march_arm3

or_mid:                                           ; preds = %entry
  %tag_eq2 = icmp eq i64 %tag, 6384681320
  br i1 %tag_eq2, label %march_arm, label %march_next

march_arm3:                                       ; preds = %march_next
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 7)
  unreachable
}

define ptr @describe_dir(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %d = alloca ptr, align 8
  store ptr %0, ptr %d, align 8
  %d1 = load ptr, ptr %d, align 8
  %tag_ptr = getelementptr inbounds nuw %Direction, ptr %d1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210684168656
  br i1 %tag_eq, label %march_arm, label %or_mid

match_end:                                        ; preds = %march_arm5, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %or_mid2, %or_mid, %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %or_mid2
  %tag_eq7 = icmp eq i64 %tag, 6384681320
  br i1 %tag_eq7, label %march_arm5, label %march_next6

or_mid:                                           ; preds = %entry
  %tag_eq3 = icmp eq i64 %tag, 210690101528
  br i1 %tag_eq3, label %march_arm, label %or_mid2

or_mid2:                                          ; preds = %or_mid
  %tag_eq4 = icmp eq i64 %tag, 6384030098
  br i1 %tag_eq4, label %march_arm, label %march_next

march_arm5:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.2, i64 %tag, ptr @mu_file.3, i64 19)
  unreachable
}

define ptr @parity(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  store i64 0, ptr %pmatch_result, align 8
  %lit_eq = icmp eq i64 %n1, 0
  %lit_eq2 = icmp eq i64 %n1, 2
  %lit_eq3 = icmp eq i64 %n1, 4
  %lit_eq4 = icmp eq i64 %n1, 6
  %lit_eq5 = icmp eq i64 %n1, 8
  %or_cmp = or i1 %lit_eq4, %lit_eq5
  %or_cmp6 = or i1 %lit_eq3, %or_cmp
  %or_cmp7 = or i1 %lit_eq2, %or_cmp6
  %or_cmp8 = or i1 %lit_eq, %or_cmp7
  br i1 %or_cmp8, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body20, %parm_body9, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %lit_eq11 = icmp eq i64 %n1, 1
  %lit_eq12 = icmp eq i64 %n1, 3
  %lit_eq13 = icmp eq i64 %n1, 5
  %lit_eq14 = icmp eq i64 %n1, 7
  %lit_eq15 = icmp eq i64 %n1, 9
  %or_cmp16 = or i1 %lit_eq14, %lit_eq15
  %or_cmp17 = or i1 %lit_eq13, %or_cmp16
  %or_cmp18 = or i1 %lit_eq12, %or_cmp17
  %or_cmp19 = or i1 %lit_eq11, %or_cmp18
  br i1 %or_cmp19, label %parm_body9, label %parm_next10

parm_body9:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next10:                                      ; preds = %parm_next
  br label %parm_body20

parm_body20:                                      ; preds = %parm_next10
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next21:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.7, i64 -1, ptr @mu_file.8, i64 32)
  unreachable
}

define i1 @is_vowel_word(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  store i64 0, ptr %pmatch_result, align 8
  %1 = call i32 @strcmp(ptr %s1, ptr @.lit_str)
  %widen = sext i32 %1 to i64
  %str_eq = icmp eq i64 %widen, 0
  %2 = call i32 @strcmp(ptr %s1, ptr @.lit_str.9)
  %widen2 = sext i32 %2 to i64
  %str_eq3 = icmp eq i64 %widen2, 0
  %3 = call i32 @strcmp(ptr %s1, ptr @.lit_str.10)
  %widen4 = sext i32 %3 to i64
  %str_eq5 = icmp eq i64 %widen4, 0
  %4 = call i32 @strcmp(ptr %s1, ptr @.lit_str.11)
  %widen6 = sext i32 %4 to i64
  %str_eq7 = icmp eq i64 %widen6, 0
  %5 = call i32 @strcmp(ptr %s1, ptr @.lit_str.12)
  %widen8 = sext i32 %5 to i64
  %str_eq9 = icmp eq i64 %widen8, 0
  %or_cmp = or i1 %str_eq7, %str_eq9
  %or_cmp10 = or i1 %str_eq5, %or_cmp
  %or_cmp11 = or i1 %str_eq3, %or_cmp10
  %or_cmp12 = or i1 %str_eq, %or_cmp11
  br i1 %or_cmp12, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body13, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = trunc i64 %pmatch_val to i1
  ret i1 %cast

parm_body:                                        ; preds = %entry
  store i64 1, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  br label %parm_body13

parm_body13:                                      ; preds = %parm_next
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next14:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.13, i64 -1, ptr @mu_file.14, i64 46)
  unreachable
}

define ptr @describe_small(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  store i64 0, ptr %pmatch_result, align 8
  %lit_eq = icmp eq i64 %n1, 1
  %lit_eq2 = icmp eq i64 %n1, 2
  %or_cmp = or i1 %lit_eq, %lit_eq2
  br i1 %or_cmp, label %lit_guard, label %parm_next

pmatch_end:                                       ; preds = %parm_body4, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %lit_guard
  store i64 ptrtoint (ptr @.str.15 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %lit_guard, %entry
  br label %parm_body4

lit_guard:                                        ; preds = %entry
  %n3 = load i64, ptr %n, align 8
  %sgt = icmp sgt i64 %n3, 0
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

parm_body4:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.16 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next5:                                       ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.17, i64 -1, ptr @mu_file.18, i64 58)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Direction, ptr %0, i32 0, i32 0
  store i64 6384030098, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Direction, ptr %0, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %1 = call i1 @is_horizontal(ptr %cast1)
  %widen = zext i1 %1 to i64
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %widen)
  %widen2 = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen3 = sext i32 %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %Direction, ptr %5, i32 0, i32 0
  store i64 6384681320, ptr %tag_ptr4, align 8
  %pay_ptr5 = getelementptr inbounds nuw %Direction, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr5, align 8
  %cast6 = ptrtoint ptr %5 to i64
  %cast7 = inttoptr i64 %cast6 to ptr
  %6 = call i1 @is_horizontal(ptr %cast7)
  %widen8 = zext i1 %6 to i64
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.19, i64 %widen8)
  %widen9 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen10 = sext i32 %9 to i64
  %10 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %Direction, ptr %10, i32 0, i32 0
  store i64 210684168656, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %Direction, ptr %10, i32 0, i32 1
  store ptr null, ptr %pay_ptr12, align 8
  %cast13 = ptrtoint ptr %10 to i64
  %cast14 = inttoptr i64 %cast13 to ptr
  %11 = call i1 @is_horizontal(ptr %cast14)
  %widen15 = zext i1 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.20, i64 %widen15)
  %widen16 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen17 = sext i32 %14 to i64
  %15 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %Direction, ptr %15, i32 0, i32 0
  store i64 210684168656, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %Direction, ptr %15, i32 0, i32 1
  store ptr null, ptr %pay_ptr19, align 8
  %cast20 = ptrtoint ptr %15 to i64
  %cast21 = inttoptr i64 %cast20 to ptr
  %16 = call ptr @describe_dir(ptr %cast21)
  %17 = call i32 @puts(ptr %16)
  %widen22 = sext i32 %17 to i64
  %18 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr23 = getelementptr inbounds nuw %Direction, ptr %18, i32 0, i32 0
  store i64 210690101528, ptr %tag_ptr23, align 8
  %pay_ptr24 = getelementptr inbounds nuw %Direction, ptr %18, i32 0, i32 1
  store ptr null, ptr %pay_ptr24, align 8
  %cast25 = ptrtoint ptr %18 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  %19 = call ptr @describe_dir(ptr %cast26)
  %20 = call i32 @puts(ptr %19)
  %widen27 = sext i32 %20 to i64
  %21 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr28 = getelementptr inbounds nuw %Direction, ptr %21, i32 0, i32 0
  store i64 6384030098, ptr %tag_ptr28, align 8
  %pay_ptr29 = getelementptr inbounds nuw %Direction, ptr %21, i32 0, i32 1
  store ptr null, ptr %pay_ptr29, align 8
  %cast30 = ptrtoint ptr %21 to i64
  %cast31 = inttoptr i64 %cast30 to ptr
  %22 = call ptr @describe_dir(ptr %cast31)
  %23 = call i32 @puts(ptr %22)
  %widen32 = sext i32 %23 to i64
  %24 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr33 = getelementptr inbounds nuw %Direction, ptr %24, i32 0, i32 0
  store i64 6384681320, ptr %tag_ptr33, align 8
  %pay_ptr34 = getelementptr inbounds nuw %Direction, ptr %24, i32 0, i32 1
  store ptr null, ptr %pay_ptr34, align 8
  %cast35 = ptrtoint ptr %24 to i64
  %cast36 = inttoptr i64 %cast35 to ptr
  %25 = call ptr @describe_dir(ptr %cast36)
  %26 = call i32 @puts(ptr %25)
  %widen37 = sext i32 %26 to i64
  %27 = call ptr @parity(i64 0)
  %28 = call i32 @puts(ptr %27)
  %widen38 = sext i32 %28 to i64
  %29 = call ptr @parity(i64 3)
  %30 = call i32 @puts(ptr %29)
  %widen39 = sext i32 %30 to i64
  %31 = call ptr @parity(i64 7)
  %32 = call i32 @puts(ptr %31)
  %widen40 = sext i32 %32 to i64
  %33 = call ptr @parity(i64 42)
  %34 = call i32 @puts(ptr %33)
  %widen41 = sext i32 %34 to i64
  %35 = call i1 @is_vowel_word(ptr @.str.21)
  %widen42 = zext i1 %35 to i64
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.22, i64 %widen42)
  %widen43 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen44 = sext i32 %38 to i64
  %39 = call i1 @is_vowel_word(ptr @.str.23)
  %widen45 = zext i1 %39 to i64
  %40 = call ptr @avra_rc_alloc(i64 32)
  %41 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %40, i64 32, ptr @.i2s_fmt.24, i64 %widen45)
  %widen46 = sext i32 %41 to i64
  %42 = call i32 @puts(ptr %40)
  %widen47 = sext i32 %42 to i64
  %43 = call i1 @is_vowel_word(ptr @.str.25)
  %widen48 = zext i1 %43 to i64
  %44 = call ptr @avra_rc_alloc(i64 32)
  %45 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %44, i64 32, ptr @.i2s_fmt.26, i64 %widen48)
  %widen49 = sext i32 %45 to i64
  %46 = call i32 @puts(ptr %44)
  %widen50 = sext i32 %46 to i64
  %47 = call ptr @describe_small(i64 1)
  %48 = call i32 @puts(ptr %47)
  %widen51 = sext i32 %48 to i64
  %49 = call ptr @describe_small(i64 2)
  %50 = call i32 @puts(ptr %49)
  %widen52 = sext i32 %50 to i64
  %51 = call ptr @describe_small(i64 5)
  %52 = call i32 @puts(ptr %51)
  %widen53 = sext i32 %52 to i64
  %53 = call i32 @avra_test_summary()
  %widen54 = sext i32 %53 to i64
  call void @avra_rc_collect()
  ret i64 0
}
