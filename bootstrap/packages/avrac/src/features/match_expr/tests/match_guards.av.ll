; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Shape = type { i64, ptr }
%Result = type { i64, ptr }

@.str = private unnamed_addr constant [11 x i8] c"big circle\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"medium circle\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"small circle\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"rectangle\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file = private unnamed_addr constant [138 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/match_guards.av\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"huge\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@.str.7 = private unnamed_addr constant [13 x i8] c"non-positive\00", align 1
@.match_fn.8 = private unnamed_addr constant [6 x i8] c"check\00", align 1
@mu_file.9 = private unnamed_addr constant [138 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/match_guards.av\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [21 x i8] c"ok: zero or negative\00", align 1
@.str.12 = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@.str.13 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.15 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file.16 = private unnamed_addr constant [138 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/match_guards.av\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.18 = private unnamed_addr constant [13 x i8] c"Hello Alice!\00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.20 = private unnamed_addr constant [5 x i8] c"Hey \00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.22 = private unnamed_addr constant [4 x i8] c"Hi \00", align 1
@.str.23 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.match_fn.24 = private unnamed_addr constant [6 x i8] c"greet\00", align 1
@mu_file.25 = private unnamed_addr constant [138 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/match_guards.av\00", align 1
@.str.26 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.27 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"Carol\00", align 1

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

define ptr @classify(ptr %0) {
entry:
  %h30 = alloca i64, align 8
  %w27 = alloca i64, align 8
  %r13 = alloca i64, align 8
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

match_end:                                        ; preds = %march_arm35, %guard_pass34, %march_arm19, %guard_pass18, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %r3 = load i64, ptr %r2, align 8
  %sgt = icmp sgt i64 %r3, 10
  %sgt_ext = zext i1 %sgt to i64
  %guard = icmp ne i64 %sgt_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq6 = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq6, label %march_arm4, label %march_next5

guard_pass:                                       ; preds = %march_arm
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %r_slot_base9 = ptrtoint ptr %payload8 to i64
  %r_slot_addr10 = add i64 %r_slot_base9, 0
  %r_slot11 = inttoptr i64 %r_slot_addr10 to ptr
  %r12 = load i64, ptr %r_slot11, align 8
  store i64 %r12, ptr %r13, align 8
  %r14 = load i64, ptr %r13, align 8
  %sgt15 = icmp sgt i64 %r14, 5
  %sgt_ext16 = zext i1 %sgt15 to i64
  %guard17 = icmp ne i64 %sgt_ext16, 0
  br i1 %guard17, label %guard_pass18, label %march_next5

march_next5:                                      ; preds = %march_arm4, %march_next
  %tag_eq21 = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq21, label %march_arm19, label %march_next20

guard_pass18:                                     ; preds = %march_arm4
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_arm19:                                      ; preds = %march_next5
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next20:                                     ; preds = %march_next5
  %tag_eq24 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq24, label %march_arm22, label %march_next23

march_arm22:                                      ; preds = %march_next20
  %pay_slot25 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload26 = load ptr, ptr %pay_slot25, align 8
  %w_slot_base = ptrtoint ptr %payload26 to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load i64, ptr %w_slot, align 8
  store i64 %w, ptr %w27, align 8
  %pay_slot28 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload29 = load ptr, ptr %pay_slot28, align 8
  %h_slot_base = ptrtoint ptr %payload29 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h30, align 8
  %w31 = load i64, ptr %w27, align 8
  %h32 = load i64, ptr %h30, align 8
  %eq = icmp eq i64 %w31, %h32
  %eq_ext = zext i1 %eq to i64
  %guard33 = icmp ne i64 %eq_ext, 0
  br i1 %guard33, label %guard_pass34, label %march_next23

march_next23:                                     ; preds = %march_arm22, %march_next20
  %tag_eq37 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq37, label %march_arm35, label %march_next36

guard_pass34:                                     ; preds = %march_arm22
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result, align 8
  br label %match_end

march_arm35:                                      ; preds = %march_next23
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %match_result, align 8
  br label %match_end

march_next36:                                     ; preds = %march_next23
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable
}

define ptr @check(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  store i64 0, ptr %pmatch_result, align 8
  %x2 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x2, 100
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body9, %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %x5 = load i64, ptr %x, align 8
  %sgt6 = icmp sgt i64 %x5, 0
  %sgt_ext7 = zext i1 %sgt6 to i64
  %pguard8 = icmp ne i64 %sgt_ext7, 0
  br i1 %pguard8, label %parm_body3, label %parm_next4

parm_body3:                                       ; preds = %parm_next
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; preds = %parm_next
  br label %parm_body9

parm_body9:                                       ; preds = %parm_next4
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next10:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.8, i64 -1, ptr @mu_file.9, i64 25)
  unreachable
}

define ptr @describe(ptr %0) {
entry:
  %c28 = alloca i64, align 8
  %c15 = alloca i64, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm19, %guard_pass18, %march_arm7, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast38 = inttoptr i64 %match_val to ptr
  ret ptr %cast38

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %v3 = load i64, ptr %v2, align 8
  %sgt = icmp sgt i64 %v3, 0
  %sgt_ext = zext i1 %sgt to i64
  %guard = icmp ne i64 %sgt_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq9 = icmp eq i64 %tag, 5862623
  br i1 %tag_eq9, label %march_arm7, label %march_next8

guard_pass:                                       ; preds = %march_arm
  %v4 = load i64, ptr %v2, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %v4)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.10)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.10, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast5, ptr %1, i64 %rhs_len_p1)
  %cast6 = ptrtoint ptr %5 to i64
  store i64 %cast6, ptr %match_result, align 8
  br label %match_end

march_arm7:                                       ; preds = %march_next
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %match_result, align 8
  br label %match_end

march_next8:                                      ; preds = %march_next
  %tag_eq12 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq12, label %march_arm10, label %march_next11

march_arm10:                                      ; preds = %march_next8
  %pay_slot13 = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload14 = load ptr, ptr %pay_slot13, align 8
  %c_slot_base = ptrtoint ptr %payload14 to i64
  %c_slot_addr = add i64 %c_slot_base, 0
  %c_slot = inttoptr i64 %c_slot_addr to ptr
  %c = load i64, ptr %c_slot, align 8
  store i64 %c, ptr %c15, align 8
  %c16 = load i64, ptr %c15, align 8
  %eq = icmp eq i64 %c16, 404
  %eq_ext = zext i1 %eq to i64
  %guard17 = icmp ne i64 %eq_ext, 0
  br i1 %guard17, label %guard_pass18, label %march_next11

march_next11:                                     ; preds = %march_arm10, %march_next8
  %tag_eq21 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq21, label %march_arm19, label %march_next20

guard_pass18:                                     ; preds = %march_arm10
  store i64 ptrtoint (ptr @.str.12 to i64), ptr %match_result, align 8
  br label %match_end

march_arm19:                                      ; preds = %march_next11
  %pay_slot22 = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload23 = load ptr, ptr %pay_slot22, align 8
  %c_slot_base24 = ptrtoint ptr %payload23 to i64
  %c_slot_addr25 = add i64 %c_slot_base24, 0
  %c_slot26 = inttoptr i64 %c_slot_addr25 to ptr
  %c27 = load i64, ptr %c_slot26, align 8
  store i64 %c27, ptr %c28, align 8
  %c29 = load i64, ptr %c28, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.14, i64 %c29)
  %widen30 = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str.13)
  %11 = call i64 @strlen(ptr %8)
  %concat_total31 = add i64 %10, %11
  %concat_size32 = add i64 %concat_total31, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.13, i64 %10)
  %cast33 = ptrtoint ptr %12 to i64
  %dst2_int34 = add i64 %cast33, %10
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast35, ptr %8, i64 %rhs_len_p136)
  %cast37 = ptrtoint ptr %12 to i64
  store i64 %cast37, ptr %match_result, align 8
  br label %match_end

march_next20:                                     ; preds = %march_next11
  call void @avra_match_unreachable(ptr @.match_fn.15, i64 %tag, ptr @mu_file.16, i64 42)
  unreachable
}

define ptr @greet(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  %name1 = load ptr, ptr %name, align 8
  store i64 0, ptr %pmatch_result, align 8
  %name2 = load ptr, ptr %name, align 8
  %1 = call i32 @strcmp(ptr %name2, ptr @.str.17)
  %widen = sext i32 %1 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %pguard = icmp ne i64 %streq_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body16, %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast32 = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast32

parm_body:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %name5 = load ptr, ptr %name, align 8
  %2 = call i64 @avra_str_starts_with(ptr %name5, ptr @.str.19)
  %pguard6 = icmp ne i64 %2, 0
  br i1 %pguard6, label %parm_body3, label %parm_next4

parm_body3:                                       ; preds = %parm_next
  %name7 = load ptr, ptr %name, align 8
  %3 = call i64 @strlen(ptr @.str.20)
  %4 = call i64 @strlen(ptr %name7)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.20, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast8, ptr %name7, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.21)
  %concat_total9 = add i64 %8, %9
  %concat_size10 = add i64 %concat_total9, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size10)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast11 = ptrtoint ptr %10 to i64
  %dst2_int12 = add i64 %cast11, %8
  %cast13 = inttoptr i64 %dst2_int12 to ptr
  %rhs_len_p114 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast13, ptr @.str.21, i64 %rhs_len_p114)
  %cast15 = ptrtoint ptr %10 to i64
  store i64 %cast15, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; preds = %parm_next
  br label %parm_body16

parm_body16:                                      ; preds = %parm_next4
  %name18 = load ptr, ptr %name, align 8
  %13 = call i64 @strlen(ptr @.str.22)
  %14 = call i64 @strlen(ptr %name18)
  %concat_total19 = add i64 %13, %14
  %concat_size20 = add i64 %concat_total19, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size20)
  %16 = call ptr @memcpy(ptr %15, ptr @.str.22, i64 %13)
  %cast21 = ptrtoint ptr %15 to i64
  %dst2_int22 = add i64 %cast21, %13
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast23, ptr %name18, i64 %rhs_len_p124)
  %18 = call i64 @strlen(ptr %15)
  %19 = call i64 @strlen(ptr @.str.23)
  %concat_total25 = add i64 %18, %19
  %concat_size26 = add i64 %concat_total25, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %21 = call ptr @memcpy(ptr %20, ptr %15, i64 %18)
  %cast27 = ptrtoint ptr %20 to i64
  %dst2_int28 = add i64 %cast27, %18
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast29, ptr @.str.23, i64 %rhs_len_p130)
  %cast31 = ptrtoint ptr %20 to i64
  store i64 %cast31, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next17:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.24, i64 -1, ptr @mu_file.25, i64 56)
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
  store i64 15, ptr %slot, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %2 = call ptr @classify(ptr %cast1)
  %3 = call i32 @puts(ptr %2)
  %widen = sext i32 %3 to i64
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Shape, ptr %4, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Shape, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr3, align 8
  %slot_base4 = ptrtoint ptr %5 to i64
  %slot_addr5 = add i64 %slot_base4, 0
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store i64 7, ptr %slot6, align 8
  %cast7 = ptrtoint ptr %4 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %6 = call ptr @classify(ptr %cast8)
  %7 = call i32 @puts(ptr %6)
  %widen9 = sext i32 %7 to i64
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Shape, ptr %8, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %Shape, ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 8)
  store ptr %9, ptr %pay_ptr11, align 8
  %slot_base12 = ptrtoint ptr %9 to i64
  %slot_addr13 = add i64 %slot_base12, 0
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  store i64 2, ptr %slot14, align 8
  %cast15 = ptrtoint ptr %8 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  %10 = call ptr @classify(ptr %cast16)
  %11 = call i32 @puts(ptr %10)
  %widen17 = sext i32 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %Shape, ptr %12, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %Shape, ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 16)
  store ptr %13, ptr %pay_ptr19, align 8
  %slot_base20 = ptrtoint ptr %13 to i64
  %slot_addr21 = add i64 %slot_base20, 0
  %slot22 = inttoptr i64 %slot_addr21 to ptr
  store i64 5, ptr %slot22, align 8
  %slot_base23 = ptrtoint ptr %13 to i64
  %slot_addr24 = add i64 %slot_base23, 8
  %slot25 = inttoptr i64 %slot_addr24 to ptr
  store i64 5, ptr %slot25, align 8
  %cast26 = ptrtoint ptr %12 to i64
  %cast27 = inttoptr i64 %cast26 to ptr
  %14 = call ptr @classify(ptr %cast27)
  %15 = call i32 @puts(ptr %14)
  %widen28 = sext i32 %15 to i64
  %16 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr29 = getelementptr inbounds nuw %Shape, ptr %16, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr29, align 8
  %pay_ptr30 = getelementptr inbounds nuw %Shape, ptr %16, i32 0, i32 1
  %17 = call ptr @avra_rc_alloc(i64 16)
  store ptr %17, ptr %pay_ptr30, align 8
  %slot_base31 = ptrtoint ptr %17 to i64
  %slot_addr32 = add i64 %slot_base31, 0
  %slot33 = inttoptr i64 %slot_addr32 to ptr
  store i64 3, ptr %slot33, align 8
  %slot_base34 = ptrtoint ptr %17 to i64
  %slot_addr35 = add i64 %slot_base34, 8
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  store i64 7, ptr %slot36, align 8
  %cast37 = ptrtoint ptr %16 to i64
  %cast38 = inttoptr i64 %cast37 to ptr
  %18 = call ptr @classify(ptr %cast38)
  %19 = call i32 @puts(ptr %18)
  %widen39 = sext i32 %19 to i64
  %20 = call ptr @check(i64 200)
  %21 = call i32 @puts(ptr %20)
  %widen40 = sext i32 %21 to i64
  %22 = call ptr @check(i64 50)
  %23 = call i32 @puts(ptr %22)
  %widen41 = sext i32 %23 to i64
  %24 = call ptr @check(i64 -5)
  %25 = call i32 @puts(ptr %24)
  %widen42 = sext i32 %25 to i64
  %26 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr43 = getelementptr inbounds nuw %Result, ptr %26, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr43, align 8
  %pay_ptr44 = getelementptr inbounds nuw %Result, ptr %26, i32 0, i32 1
  %27 = call ptr @avra_rc_alloc(i64 8)
  store ptr %27, ptr %pay_ptr44, align 8
  %slot_base45 = ptrtoint ptr %27 to i64
  %slot_addr46 = add i64 %slot_base45, 0
  %slot47 = inttoptr i64 %slot_addr46 to ptr
  store i64 42, ptr %slot47, align 8
  %cast48 = ptrtoint ptr %26 to i64
  %cast49 = inttoptr i64 %cast48 to ptr
  %28 = call ptr @describe(ptr %cast49)
  %29 = call i32 @puts(ptr %28)
  %widen50 = sext i32 %29 to i64
  %30 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr51 = getelementptr inbounds nuw %Result, ptr %30, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr51, align 8
  %pay_ptr52 = getelementptr inbounds nuw %Result, ptr %30, i32 0, i32 1
  %31 = call ptr @avra_rc_alloc(i64 8)
  store ptr %31, ptr %pay_ptr52, align 8
  %slot_base53 = ptrtoint ptr %31 to i64
  %slot_addr54 = add i64 %slot_base53, 0
  %slot55 = inttoptr i64 %slot_addr54 to ptr
  store i64 -1, ptr %slot55, align 8
  %cast56 = ptrtoint ptr %30 to i64
  %cast57 = inttoptr i64 %cast56 to ptr
  %32 = call ptr @describe(ptr %cast57)
  %33 = call i32 @puts(ptr %32)
  %widen58 = sext i32 %33 to i64
  %34 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr59 = getelementptr inbounds nuw %Result, ptr %34, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr59, align 8
  %pay_ptr60 = getelementptr inbounds nuw %Result, ptr %34, i32 0, i32 1
  %35 = call ptr @avra_rc_alloc(i64 8)
  store ptr %35, ptr %pay_ptr60, align 8
  %slot_base61 = ptrtoint ptr %35 to i64
  %slot_addr62 = add i64 %slot_base61, 0
  %slot63 = inttoptr i64 %slot_addr62 to ptr
  store i64 404, ptr %slot63, align 8
  %cast64 = ptrtoint ptr %34 to i64
  %cast65 = inttoptr i64 %cast64 to ptr
  %36 = call ptr @describe(ptr %cast65)
  %37 = call i32 @puts(ptr %36)
  %widen66 = sext i32 %37 to i64
  %38 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr67 = getelementptr inbounds nuw %Result, ptr %38, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr67, align 8
  %pay_ptr68 = getelementptr inbounds nuw %Result, ptr %38, i32 0, i32 1
  %39 = call ptr @avra_rc_alloc(i64 8)
  store ptr %39, ptr %pay_ptr68, align 8
  %slot_base69 = ptrtoint ptr %39 to i64
  %slot_addr70 = add i64 %slot_base69, 0
  %slot71 = inttoptr i64 %slot_addr70 to ptr
  store i64 500, ptr %slot71, align 8
  %cast72 = ptrtoint ptr %38 to i64
  %cast73 = inttoptr i64 %cast72 to ptr
  %40 = call ptr @describe(ptr %cast73)
  %41 = call i32 @puts(ptr %40)
  %widen74 = sext i32 %41 to i64
  %42 = call ptr @greet(ptr @.str.26)
  %43 = call i32 @puts(ptr %42)
  %widen75 = sext i32 %43 to i64
  %44 = call ptr @greet(ptr @.str.27)
  %45 = call i32 @puts(ptr %44)
  %widen76 = sext i32 %45 to i64
  %46 = call ptr @greet(ptr @.str.28)
  %47 = call i32 @puts(ptr %46)
  %widen77 = sext i32 %47 to i64
  %48 = call i32 @avra_test_summary()
  %widen78 = sext i32 %48 to i64
  call void @avra_rc_collect()
  ret i64 0
}
