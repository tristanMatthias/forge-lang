; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"9\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"digit\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"lower\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"Z\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"upper\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"5\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"G\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"in_range\00", align 1
@.str.15 = private unnamed_addr constant [13 x i8] c"not_in_range\00", align 1
@.str.16 = private unnamed_addr constant [13 x i8] c"boundary_low\00", align 1
@.str.17 = private unnamed_addr constant [14 x i8] c"boundary_high\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"F\00", align 1
@.str.22 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.23 = private unnamed_addr constant [12 x i8] c"match_range\00", align 1

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
  %when_result = alloca i64, align 8
  %ch = alloca ptr, align 8
  store ptr %0, ptr %ch, align 8
  store i64 0, ptr %when_result, align 8
  %ch1 = load ptr, ptr %ch, align 8
  %1 = call i32 @strcmp(ptr %ch1, ptr @.str)
  %widen = sext i32 %1 to i64
  %scmp_cmp = icmp sge i64 %widen, 0
  %scmp_ext = zext i1 %scmp_cmp to i64
  %l_bool = icmp ne i64 %scmp_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

when_end:                                         ; preds = %when_next47, %when_arm46, %when_arm25, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast = inttoptr i64 %when_val to ptr
  ret ptr %cast

sc_rhs:                                           ; preds = %entry
  %ch2 = load ptr, ptr %ch, align 8
  %2 = call i32 @strcmp(ptr %ch2, ptr @.str.1)
  %widen3 = sext i32 %2 to i64
  %scmp_cmp4 = icmp sle i64 %widen3, 0
  %scmp_ext5 = zext i1 %scmp_cmp4 to i64
  %r_bool = icmp ne i64 %scmp_ext5, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %when_cond = icmp ne i64 %sc_ext, 0
  br i1 %when_cond, label %when_arm, label %when_next

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

when_arm:                                         ; preds = %sc_merge
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %sc_merge
  %ch6 = load ptr, ptr %ch, align 8
  %3 = call i32 @strcmp(ptr %ch6, ptr @.str.3)
  %widen7 = sext i32 %3 to i64
  %scmp_cmp8 = icmp sge i64 %widen7, 0
  %scmp_ext9 = zext i1 %scmp_cmp8 to i64
  %l_bool10 = icmp ne i64 %scmp_ext9, 0
  br i1 %l_bool10, label %sc_rhs11, label %sc_short12

sc_rhs11:                                         ; preds = %when_next
  %ch14 = load ptr, ptr %ch, align 8
  %4 = call i32 @strcmp(ptr %ch14, ptr @.str.4)
  %widen15 = sext i32 %4 to i64
  %scmp_cmp16 = icmp sle i64 %widen15, 0
  %scmp_ext17 = zext i1 %scmp_cmp16 to i64
  %r_bool18 = icmp ne i64 %scmp_ext17, 0
  br i1 %r_bool18, label %sc_r_true19, label %sc_r_false20

sc_short12:                                       ; preds = %when_next
  br label %sc_merge13

sc_merge13:                                       ; preds = %sc_r_merge21, %sc_short12
  %sc_phi22 = phi i1 [ false, %sc_short12 ], [ %r_bool18, %sc_r_merge21 ]
  %sc_ext23 = zext i1 %sc_phi22 to i64
  %when_cond24 = icmp ne i64 %sc_ext23, 0
  br i1 %when_cond24, label %when_arm25, label %when_next26

sc_r_true19:                                      ; preds = %sc_rhs11
  br label %sc_r_merge21

sc_r_false20:                                     ; preds = %sc_rhs11
  br label %sc_r_merge21

sc_r_merge21:                                     ; preds = %sc_r_false20, %sc_r_true19
  br label %sc_merge13

when_arm25:                                       ; preds = %sc_merge13
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %when_result, align 8
  br label %when_end

when_next26:                                      ; preds = %sc_merge13
  %ch27 = load ptr, ptr %ch, align 8
  %5 = call i32 @strcmp(ptr %ch27, ptr @.str.6)
  %widen28 = sext i32 %5 to i64
  %scmp_cmp29 = icmp sge i64 %widen28, 0
  %scmp_ext30 = zext i1 %scmp_cmp29 to i64
  %l_bool31 = icmp ne i64 %scmp_ext30, 0
  br i1 %l_bool31, label %sc_rhs32, label %sc_short33

sc_rhs32:                                         ; preds = %when_next26
  %ch35 = load ptr, ptr %ch, align 8
  %6 = call i32 @strcmp(ptr %ch35, ptr @.str.7)
  %widen36 = sext i32 %6 to i64
  %scmp_cmp37 = icmp sle i64 %widen36, 0
  %scmp_ext38 = zext i1 %scmp_cmp37 to i64
  %r_bool39 = icmp ne i64 %scmp_ext38, 0
  br i1 %r_bool39, label %sc_r_true40, label %sc_r_false41

sc_short33:                                       ; preds = %when_next26
  br label %sc_merge34

sc_merge34:                                       ; preds = %sc_r_merge42, %sc_short33
  %sc_phi43 = phi i1 [ false, %sc_short33 ], [ %r_bool39, %sc_r_merge42 ]
  %sc_ext44 = zext i1 %sc_phi43 to i64
  %when_cond45 = icmp ne i64 %sc_ext44, 0
  br i1 %when_cond45, label %when_arm46, label %when_next47

sc_r_true40:                                      ; preds = %sc_rhs32
  br label %sc_r_merge42

sc_r_false41:                                     ; preds = %sc_rhs32
  br label %sc_r_merge42

sc_r_merge42:                                     ; preds = %sc_r_false41, %sc_r_true40
  br label %sc_merge34

when_arm46:                                       ; preds = %sc_merge34
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %when_result, align 8
  br label %when_end

when_next47:                                      ; preds = %sc_merge34
  store i64 ptrtoint (ptr @.str.9 to i64), ptr %when_result, align 8
  br label %when_end
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %sif_result = alloca i64, align 8
  %label = alloca ptr, align 8
  %when_result = alloca i64, align 8
  %grade = alloca i64, align 8
  %x = alloca i64, align 8
  %1 = call ptr @classify(ptr @.str.10)
  %2 = call i32 @puts(ptr %1)
  %widen = sext i32 %2 to i64
  %3 = call ptr @classify(ptr @.str.11)
  %4 = call i32 @puts(ptr %3)
  %widen1 = sext i32 %4 to i64
  %5 = call ptr @classify(ptr @.str.12)
  %6 = call i32 @puts(ptr %5)
  %widen2 = sext i32 %6 to i64
  %7 = call ptr @classify(ptr @.str.13)
  %8 = call i32 @puts(ptr %7)
  %widen3 = sext i32 %8 to i64
  store i64 42, ptr %x, align 8
  %x4 = load i64, ptr %x, align 8
  %sge = icmp sge i64 %x4, 1
  %sge_ext = zext i1 %sge to i64
  %l_bool = icmp ne i64 %sge_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

sc_rhs:                                           ; preds = %entry
  %x5 = load i64, ptr %x, align 8
  %sle = icmp sle i64 %x5, 100
  %sle_ext = zext i1 %sle to i64
  %r_bool = icmp ne i64 %sle_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond = icmp ne i64 %sc_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont:                                           ; preds = %if_else, %if_then
  %x7 = load i64, ptr %x, align 8
  %sge8 = icmp sge i64 %x7, 200
  %sge_ext9 = zext i1 %sge8 to i64
  %l_bool10 = icmp ne i64 %sge_ext9, 0
  br i1 %l_bool10, label %sc_rhs11, label %sc_short12

if_then:                                          ; preds = %sc_merge
  %9 = call i32 @puts(ptr @.str.14)
  %widen6 = sext i32 %9 to i64
  br label %ifcont

if_else:                                          ; preds = %sc_merge
  br label %ifcont

sc_rhs11:                                         ; preds = %ifcont
  %x14 = load i64, ptr %x, align 8
  %sle15 = icmp sle i64 %x14, 300
  %sle_ext16 = zext i1 %sle15 to i64
  %r_bool17 = icmp ne i64 %sle_ext16, 0
  br i1 %r_bool17, label %sc_r_true18, label %sc_r_false19

sc_short12:                                       ; preds = %ifcont
  br label %sc_merge13

sc_merge13:                                       ; preds = %sc_r_merge20, %sc_short12
  %sc_phi21 = phi i1 [ false, %sc_short12 ], [ %r_bool17, %sc_r_merge20 ]
  %sc_ext22 = zext i1 %sc_phi21 to i64
  %not_cmp = icmp eq i64 %sc_ext22, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %if_cond24 = icmp ne i64 %not_cmp_ext, 0
  br i1 %if_cond24, label %if_then25, label %if_else26

sc_r_true18:                                      ; preds = %sc_rhs11
  br label %sc_r_merge20

sc_r_false19:                                     ; preds = %sc_rhs11
  br label %sc_r_merge20

sc_r_merge20:                                     ; preds = %sc_r_false19, %sc_r_true18
  br label %sc_merge13

ifcont23:                                         ; preds = %if_else26, %if_then25
  br i1 true, label %sc_rhs28, label %sc_short29

if_then25:                                        ; preds = %sc_merge13
  %10 = call i32 @puts(ptr @.str.15)
  %widen27 = sext i32 %10 to i64
  br label %ifcont23

if_else26:                                        ; preds = %sc_merge13
  br label %ifcont23

sc_rhs28:                                         ; preds = %ifcont23
  br i1 true, label %sc_r_true31, label %sc_r_false32

sc_short29:                                       ; preds = %ifcont23
  br label %sc_merge30

sc_merge30:                                       ; preds = %sc_r_merge33, %sc_short29
  %sc_phi34 = phi i1 [ false, %sc_short29 ], [ true, %sc_r_merge33 ]
  %sc_ext35 = zext i1 %sc_phi34 to i64
  %if_cond37 = icmp ne i64 %sc_ext35, 0
  br i1 %if_cond37, label %if_then38, label %if_else39

sc_r_true31:                                      ; preds = %sc_rhs28
  br label %sc_r_merge33

sc_r_false32:                                     ; preds = %sc_rhs28
  br label %sc_r_merge33

sc_r_merge33:                                     ; preds = %sc_r_false32, %sc_r_true31
  br label %sc_merge30

ifcont36:                                         ; preds = %if_else39, %if_then38
  br i1 true, label %sc_rhs41, label %sc_short42

if_then38:                                        ; preds = %sc_merge30
  %11 = call i32 @puts(ptr @.str.16)
  %widen40 = sext i32 %11 to i64
  br label %ifcont36

if_else39:                                        ; preds = %sc_merge30
  br label %ifcont36

sc_rhs41:                                         ; preds = %ifcont36
  br i1 true, label %sc_r_true44, label %sc_r_false45

sc_short42:                                       ; preds = %ifcont36
  br label %sc_merge43

sc_merge43:                                       ; preds = %sc_r_merge46, %sc_short42
  %sc_phi47 = phi i1 [ false, %sc_short42 ], [ true, %sc_r_merge46 ]
  %sc_ext48 = zext i1 %sc_phi47 to i64
  %if_cond50 = icmp ne i64 %sc_ext48, 0
  br i1 %if_cond50, label %if_then51, label %if_else52

sc_r_true44:                                      ; preds = %sc_rhs41
  br label %sc_r_merge46

sc_r_false45:                                     ; preds = %sc_rhs41
  br label %sc_r_merge46

sc_r_merge46:                                     ; preds = %sc_r_false45, %sc_r_true44
  br label %sc_merge43

ifcont49:                                         ; preds = %if_else52, %if_then51
  store i64 85, ptr %grade, align 8
  store i64 0, ptr %when_result, align 8
  %grade54 = load i64, ptr %grade, align 8
  %sge55 = icmp sge i64 %grade54, 90
  %sge_ext56 = zext i1 %sge55 to i64
  %l_bool57 = icmp ne i64 %sge_ext56, 0
  br i1 %l_bool57, label %sc_rhs58, label %sc_short59

if_then51:                                        ; preds = %sc_merge43
  %12 = call i32 @puts(ptr @.str.17)
  %widen53 = sext i32 %12 to i64
  br label %ifcont49

if_else52:                                        ; preds = %sc_merge43
  br label %ifcont49

when_end:                                         ; preds = %when_next107, %when_arm106, %when_arm87, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast = inttoptr i64 %when_val to ptr
  store ptr %cast, ptr %label, align 8
  %label108 = load ptr, ptr %label, align 8
  %13 = call i32 @strcmp(ptr %label108, ptr @.str.22)
  %widen109 = sext i32 %13 to i64
  %streq_cmp = icmp eq i64 %widen109, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sc_rhs58:                                         ; preds = %ifcont49
  %grade61 = load i64, ptr %grade, align 8
  %sle62 = icmp sle i64 %grade61, 100
  %sle_ext63 = zext i1 %sle62 to i64
  %r_bool64 = icmp ne i64 %sle_ext63, 0
  br i1 %r_bool64, label %sc_r_true65, label %sc_r_false66

sc_short59:                                       ; preds = %ifcont49
  br label %sc_merge60

sc_merge60:                                       ; preds = %sc_r_merge67, %sc_short59
  %sc_phi68 = phi i1 [ false, %sc_short59 ], [ %r_bool64, %sc_r_merge67 ]
  %sc_ext69 = zext i1 %sc_phi68 to i64
  %when_cond = icmp ne i64 %sc_ext69, 0
  br i1 %when_cond, label %when_arm, label %when_next

sc_r_true65:                                      ; preds = %sc_rhs58
  br label %sc_r_merge67

sc_r_false66:                                     ; preds = %sc_rhs58
  br label %sc_r_merge67

sc_r_merge67:                                     ; preds = %sc_r_false66, %sc_r_true65
  br label %sc_merge60

when_arm:                                         ; preds = %sc_merge60
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %sc_merge60
  %grade70 = load i64, ptr %grade, align 8
  %sge71 = icmp sge i64 %grade70, 80
  %sge_ext72 = zext i1 %sge71 to i64
  %l_bool73 = icmp ne i64 %sge_ext72, 0
  br i1 %l_bool73, label %sc_rhs74, label %sc_short75

sc_rhs74:                                         ; preds = %when_next
  %grade77 = load i64, ptr %grade, align 8
  %sle78 = icmp sle i64 %grade77, 89
  %sle_ext79 = zext i1 %sle78 to i64
  %r_bool80 = icmp ne i64 %sle_ext79, 0
  br i1 %r_bool80, label %sc_r_true81, label %sc_r_false82

sc_short75:                                       ; preds = %when_next
  br label %sc_merge76

sc_merge76:                                       ; preds = %sc_r_merge83, %sc_short75
  %sc_phi84 = phi i1 [ false, %sc_short75 ], [ %r_bool80, %sc_r_merge83 ]
  %sc_ext85 = zext i1 %sc_phi84 to i64
  %when_cond86 = icmp ne i64 %sc_ext85, 0
  br i1 %when_cond86, label %when_arm87, label %when_next88

sc_r_true81:                                      ; preds = %sc_rhs74
  br label %sc_r_merge83

sc_r_false82:                                     ; preds = %sc_rhs74
  br label %sc_r_merge83

sc_r_merge83:                                     ; preds = %sc_r_false82, %sc_r_true81
  br label %sc_merge76

when_arm87:                                       ; preds = %sc_merge76
  store i64 ptrtoint (ptr @.str.19 to i64), ptr %when_result, align 8
  br label %when_end

when_next88:                                      ; preds = %sc_merge76
  %grade89 = load i64, ptr %grade, align 8
  %sge90 = icmp sge i64 %grade89, 70
  %sge_ext91 = zext i1 %sge90 to i64
  %l_bool92 = icmp ne i64 %sge_ext91, 0
  br i1 %l_bool92, label %sc_rhs93, label %sc_short94

sc_rhs93:                                         ; preds = %when_next88
  %grade96 = load i64, ptr %grade, align 8
  %sle97 = icmp sle i64 %grade96, 79
  %sle_ext98 = zext i1 %sle97 to i64
  %r_bool99 = icmp ne i64 %sle_ext98, 0
  br i1 %r_bool99, label %sc_r_true100, label %sc_r_false101

sc_short94:                                       ; preds = %when_next88
  br label %sc_merge95

sc_merge95:                                       ; preds = %sc_r_merge102, %sc_short94
  %sc_phi103 = phi i1 [ false, %sc_short94 ], [ %r_bool99, %sc_r_merge102 ]
  %sc_ext104 = zext i1 %sc_phi103 to i64
  %when_cond105 = icmp ne i64 %sc_ext104, 0
  br i1 %when_cond105, label %when_arm106, label %when_next107

sc_r_true100:                                     ; preds = %sc_rhs93
  br label %sc_r_merge102

sc_r_false101:                                    ; preds = %sc_rhs93
  br label %sc_r_merge102

sc_r_merge102:                                    ; preds = %sc_r_false101, %sc_r_true100
  br label %sc_merge95

when_arm106:                                      ; preds = %sc_merge95
  store i64 ptrtoint (ptr @.str.20 to i64), ptr %when_result, align 8
  br label %when_end

when_next107:                                     ; preds = %sc_merge95
  store i64 ptrtoint (ptr @.str.21 to i64), ptr %when_result, align 8
  br label %when_end

sif_then:                                         ; preds = %when_end
  %14 = call i32 @puts(ptr @.str.23)
  %widen110 = sext i32 %14 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %when_end
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
