; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Color = type { i64, ptr }

@.str = private unnamed_addr constant [9 x i8] c"pass_int\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"foo\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"pass_string\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"pass_enum\00", align 1
@.str.7 = private unnamed_addr constant [14 x i8] c"pass_negative\00", align 1
@.str.8 = private unnamed_addr constant [11 x i8] c"pass_empty\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"pass_single\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"pass_expr\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.12 = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.14 = private unnamed_addr constant [11 x i8] c"pass_in_if\00", align 1
@.str.15 = private unnamed_addr constant [5 x i8] c"tens\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.19 = private unnamed_addr constant [14 x i8] c"pass_in_match\00", align 1
@.str.20 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.22 = private unnamed_addr constant [11 x i8] c"pass_combo\00", align 1

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

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %sif_result = alloca i64, align 8
  %result = alloca ptr, align 8
  %when_result = alloca i64, align 8
  %label = alloca ptr, align 8
  %ife_result = alloca i64, align 8
  %a = alloca i64, align 8
  %y = alloca i64, align 8
  %g = alloca ptr, align 8
  %r = alloca ptr, align 8
  %c = alloca ptr, align 8
  %s = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 3, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %eq = icmp eq i64 %x1, 1
  %eq_ext = zext i1 %eq to i64
  %x2 = load i64, ptr %x, align 8
  %eq3 = icmp eq i64 %x2, 2
  %eq_ext4 = zext i1 %eq3 to i64
  %x5 = load i64, ptr %x, align 8
  %eq6 = icmp eq i64 %x5, 3
  %eq_ext7 = zext i1 %eq6 to i64
  %x8 = load i64, ptr %x, align 8
  %eq9 = icmp eq i64 %x8, 4
  %eq_ext10 = zext i1 %eq9 to i64
  %x11 = load i64, ptr %x, align 8
  %eq12 = icmp eq i64 %x11, 5
  %eq_ext13 = zext i1 %eq12 to i64
  %in_or = or i64 %eq_ext13, 0
  %in_or14 = or i64 %eq_ext10, %in_or
  %in_or15 = or i64 %eq_ext7, %in_or14
  %in_or16 = or i64 %eq_ext4, %in_or15
  %in_or17 = or i64 %eq_ext, %in_or16
  %if_cond = icmp ne i64 %in_or17, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  store ptr @.str.1, ptr %s, align 8
  %s18 = load ptr, ptr %s, align 8
  %1 = call i32 @strcmp(ptr %s18, ptr @.str.2)
  %widen19 = sext i32 %1 to i64
  %streq_cmp = icmp eq i64 %widen19, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %s20 = load ptr, ptr %s, align 8
  %2 = call i32 @strcmp(ptr %s20, ptr @.str.3)
  %widen21 = sext i32 %2 to i64
  %streq_cmp22 = icmp eq i64 %widen21, 0
  %streq_ext23 = zext i1 %streq_cmp22 to i64
  %s24 = load ptr, ptr %s, align 8
  %3 = call i32 @strcmp(ptr %s24, ptr @.str.4)
  %widen25 = sext i32 %3 to i64
  %streq_cmp26 = icmp eq i64 %widen25, 0
  %streq_ext27 = zext i1 %streq_cmp26 to i64
  %in_or28 = or i64 %streq_ext27, 0
  %in_or29 = or i64 %streq_ext23, %in_or28
  %in_or30 = or i64 %streq_ext, %in_or29
  %if_cond32 = icmp ne i64 %in_or30, 0
  br i1 %if_cond32, label %if_then33, label %if_else34

if_then:                                          ; preds = %entry
  %4 = call i32 @puts(ptr @.str)
  %widen = sext i32 %4 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont31:                                         ; preds = %if_else34, %if_then33
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %5, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  %cast36 = inttoptr i64 %cast to ptr
  store ptr %cast36, ptr %c, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr37 = getelementptr inbounds nuw %Color, ptr %6, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr37, align 8
  %pay_ptr38 = getelementptr inbounds nuw %Color, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr38, align 8
  %cast39 = ptrtoint ptr %6 to i64
  %cast40 = inttoptr i64 %cast39 to ptr
  store ptr %cast40, ptr %r, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr41 = getelementptr inbounds nuw %Color, ptr %7, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr41, align 8
  %pay_ptr42 = getelementptr inbounds nuw %Color, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr42, align 8
  %cast43 = ptrtoint ptr %7 to i64
  %cast44 = inttoptr i64 %cast43 to ptr
  store ptr %cast44, ptr %g, align 8
  %x45 = load i64, ptr %x, align 8
  %eq46 = icmp eq i64 %x45, 1
  %eq_ext47 = zext i1 %eq46 to i64
  %x48 = load i64, ptr %x, align 8
  %eq49 = icmp eq i64 %x48, 2
  %eq_ext50 = zext i1 %eq49 to i64
  %x51 = load i64, ptr %x, align 8
  %eq52 = icmp eq i64 %x51, 3
  %eq_ext53 = zext i1 %eq52 to i64
  %in_or54 = or i64 %eq_ext53, 0
  %in_or55 = or i64 %eq_ext50, %in_or54
  %in_or56 = or i64 %eq_ext47, %in_or55
  %if_cond58 = icmp ne i64 %in_or56, 0
  br i1 %if_cond58, label %if_then59, label %if_else60

if_then33:                                        ; preds = %ifcont
  %8 = call i32 @puts(ptr @.str.5)
  %widen35 = sext i32 %8 to i64
  br label %ifcont31

if_else34:                                        ; preds = %ifcont
  br label %ifcont31

ifcont57:                                         ; preds = %if_else60, %if_then59
  store i64 99, ptr %y, align 8
  %y62 = load i64, ptr %y, align 8
  %eq63 = icmp eq i64 %y62, 1
  %eq_ext64 = zext i1 %eq63 to i64
  %y65 = load i64, ptr %y, align 8
  %eq66 = icmp eq i64 %y65, 2
  %eq_ext67 = zext i1 %eq66 to i64
  %y68 = load i64, ptr %y, align 8
  %eq69 = icmp eq i64 %y68, 3
  %eq_ext70 = zext i1 %eq69 to i64
  %in_or71 = or i64 %eq_ext70, 0
  %in_or72 = or i64 %eq_ext67, %in_or71
  %in_or73 = or i64 %eq_ext64, %in_or72
  %not_cmp = icmp eq i64 %in_or73, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %if_cond75 = icmp ne i64 %not_cmp_ext, 0
  br i1 %if_cond75, label %if_then76, label %if_else77

if_then59:                                        ; preds = %ifcont31
  %9 = call i32 @puts(ptr @.str.6)
  %widen61 = sext i32 %9 to i64
  br label %ifcont57

if_else60:                                        ; preds = %ifcont31
  br label %ifcont57

ifcont74:                                         ; preds = %if_else77, %if_then76
  br i1 true, label %if_then80, label %if_else81

if_then76:                                        ; preds = %ifcont57
  %10 = call i32 @puts(ptr @.str.7)
  %widen78 = sext i32 %10 to i64
  br label %ifcont74

if_else77:                                        ; preds = %ifcont57
  br label %ifcont74

ifcont79:                                         ; preds = %if_else81, %if_then80
  %x83 = load i64, ptr %x, align 8
  %eq84 = icmp eq i64 %x83, 3
  %eq_ext85 = zext i1 %eq84 to i64
  %in_or86 = or i64 %eq_ext85, 0
  %if_cond88 = icmp ne i64 %in_or86, 0
  br i1 %if_cond88, label %if_then89, label %if_else90

if_then80:                                        ; preds = %ifcont74
  %11 = call i32 @puts(ptr @.str.8)
  %widen82 = sext i32 %11 to i64
  br label %ifcont79

if_else81:                                        ; preds = %ifcont74
  br label %ifcont79

ifcont87:                                         ; preds = %if_else90, %if_then89
  store i64 2, ptr %a, align 8
  %x92 = load i64, ptr %x, align 8
  %a93 = load i64, ptr %a, align 8
  %add = add i64 %a93, 1
  %eq94 = icmp eq i64 %x92, %add
  %eq_ext95 = zext i1 %eq94 to i64
  %x96 = load i64, ptr %x, align 8
  %a97 = load i64, ptr %a, align 8
  %mul = mul i64 %a97, 2
  %eq98 = icmp eq i64 %x96, %mul
  %eq_ext99 = zext i1 %eq98 to i64
  %x100 = load i64, ptr %x, align 8
  %eq101 = icmp eq i64 %x100, 10
  %eq_ext102 = zext i1 %eq101 to i64
  %in_or103 = or i64 %eq_ext102, 0
  %in_or104 = or i64 %eq_ext99, %in_or103
  %in_or105 = or i64 %eq_ext95, %in_or104
  %if_cond107 = icmp ne i64 %in_or105, 0
  br i1 %if_cond107, label %if_then108, label %if_else109

if_then89:                                        ; preds = %ifcont79
  %12 = call i32 @puts(ptr @.str.9)
  %widen91 = sext i32 %12 to i64
  br label %ifcont87

if_else90:                                        ; preds = %ifcont79
  br label %ifcont87

ifcont106:                                        ; preds = %if_else109, %if_then108
  %x111 = load i64, ptr %x, align 8
  %eq112 = icmp eq i64 %x111, 1
  %eq_ext113 = zext i1 %eq112 to i64
  %x114 = load i64, ptr %x, align 8
  %eq115 = icmp eq i64 %x114, 2
  %eq_ext116 = zext i1 %eq115 to i64
  %x117 = load i64, ptr %x, align 8
  %eq118 = icmp eq i64 %x117, 3
  %eq_ext119 = zext i1 %eq118 to i64
  %in_or120 = or i64 %eq_ext119, 0
  %in_or121 = or i64 %eq_ext116, %in_or120
  %in_or122 = or i64 %eq_ext113, %in_or121
  %ife_cond = icmp ne i64 %in_or122, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

if_then108:                                       ; preds = %ifcont87
  %13 = call i32 @puts(ptr @.str.10)
  %widen110 = sext i32 %13 to i64
  br label %ifcont106

if_else109:                                       ; preds = %ifcont87
  br label %ifcont106

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %cast123 = inttoptr i64 %ife_val to ptr
  store ptr %cast123, ptr %label, align 8
  %label124 = load ptr, ptr %label, align 8
  %14 = call i32 @strcmp(ptr %label124, ptr @.str.13)
  %widen125 = sext i32 %14 to i64
  %streq_cmp126 = icmp eq i64 %widen125, 0
  %streq_ext127 = zext i1 %streq_cmp126 to i64
  %if_cond129 = icmp ne i64 %streq_ext127, 0
  br i1 %if_cond129, label %if_then130, label %if_else131

ife_then:                                         ; preds = %ifcont106
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %ifcont106
  store i64 ptrtoint (ptr @.str.12 to i64), ptr %ife_result, align 8
  br label %ife_end

ifcont128:                                        ; preds = %if_else131, %if_then130
  store i64 0, ptr %when_result, align 8
  %x133 = load i64, ptr %x, align 8
  %eq134 = icmp eq i64 %x133, 10
  %eq_ext135 = zext i1 %eq134 to i64
  %x136 = load i64, ptr %x, align 8
  %eq137 = icmp eq i64 %x136, 20
  %eq_ext138 = zext i1 %eq137 to i64
  %x139 = load i64, ptr %x, align 8
  %eq140 = icmp eq i64 %x139, 30
  %eq_ext141 = zext i1 %eq140 to i64
  %in_or142 = or i64 %eq_ext141, 0
  %in_or143 = or i64 %eq_ext138, %in_or142
  %in_or144 = or i64 %eq_ext135, %in_or143
  %when_cond = icmp ne i64 %in_or144, 0
  br i1 %when_cond, label %when_arm, label %when_next

if_then130:                                       ; preds = %ife_end
  %15 = call i32 @puts(ptr @.str.14)
  %widen132 = sext i32 %15 to i64
  br label %ifcont128

if_else131:                                       ; preds = %ife_end
  br label %ifcont128

when_end:                                         ; preds = %when_next167, %when_arm166, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast168 = inttoptr i64 %when_val to ptr
  store ptr %cast168, ptr %result, align 8
  %result169 = load ptr, ptr %result, align 8
  %16 = call i32 @strcmp(ptr %result169, ptr @.str.18)
  %widen170 = sext i32 %16 to i64
  %streq_cmp171 = icmp eq i64 %widen170, 0
  %streq_ext172 = zext i1 %streq_cmp171 to i64
  %if_cond174 = icmp ne i64 %streq_ext172, 0
  br i1 %if_cond174, label %if_then175, label %if_else176

when_arm:                                         ; preds = %ifcont128
  store i64 ptrtoint (ptr @.str.15 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %ifcont128
  %x145 = load i64, ptr %x, align 8
  %eq146 = icmp eq i64 %x145, 1
  %eq_ext147 = zext i1 %eq146 to i64
  %x148 = load i64, ptr %x, align 8
  %eq149 = icmp eq i64 %x148, 2
  %eq_ext150 = zext i1 %eq149 to i64
  %x151 = load i64, ptr %x, align 8
  %eq152 = icmp eq i64 %x151, 3
  %eq_ext153 = zext i1 %eq152 to i64
  %x154 = load i64, ptr %x, align 8
  %eq155 = icmp eq i64 %x154, 4
  %eq_ext156 = zext i1 %eq155 to i64
  %x157 = load i64, ptr %x, align 8
  %eq158 = icmp eq i64 %x157, 5
  %eq_ext159 = zext i1 %eq158 to i64
  %in_or160 = or i64 %eq_ext159, 0
  %in_or161 = or i64 %eq_ext156, %in_or160
  %in_or162 = or i64 %eq_ext153, %in_or161
  %in_or163 = or i64 %eq_ext150, %in_or162
  %in_or164 = or i64 %eq_ext147, %in_or163
  %when_cond165 = icmp ne i64 %in_or164, 0
  br i1 %when_cond165, label %when_arm166, label %when_next167

when_arm166:                                      ; preds = %when_next
  store i64 ptrtoint (ptr @.str.16 to i64), ptr %when_result, align 8
  br label %when_end

when_next167:                                     ; preds = %when_next
  store i64 ptrtoint (ptr @.str.17 to i64), ptr %when_result, align 8
  br label %when_end

ifcont173:                                        ; preds = %if_else176, %if_then175
  %x178 = load i64, ptr %x, align 8
  %eq179 = icmp eq i64 %x178, 1
  %eq_ext180 = zext i1 %eq179 to i64
  %x181 = load i64, ptr %x, align 8
  %eq182 = icmp eq i64 %x181, 2
  %eq_ext183 = zext i1 %eq182 to i64
  %x184 = load i64, ptr %x, align 8
  %eq185 = icmp eq i64 %x184, 3
  %eq_ext186 = zext i1 %eq185 to i64
  %in_or187 = or i64 %eq_ext186, 0
  %in_or188 = or i64 %eq_ext183, %in_or187
  %in_or189 = or i64 %eq_ext180, %in_or188
  %l_bool = icmp ne i64 %in_or189, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

if_then175:                                       ; preds = %when_end
  %17 = call i32 @puts(ptr @.str.19)
  %widen177 = sext i32 %17 to i64
  br label %ifcont173

if_else176:                                       ; preds = %when_end
  br label %ifcont173

sc_rhs:                                           ; preds = %ifcont173
  %s190 = load ptr, ptr %s, align 8
  %18 = call i32 @strcmp(ptr %s190, ptr @.str.20)
  %widen191 = sext i32 %18 to i64
  %streq_cmp192 = icmp eq i64 %widen191, 0
  %streq_ext193 = zext i1 %streq_cmp192 to i64
  %s194 = load ptr, ptr %s, align 8
  %19 = call i32 @strcmp(ptr %s194, ptr @.str.21)
  %widen195 = sext i32 %19 to i64
  %streq_cmp196 = icmp eq i64 %widen195, 0
  %streq_ext197 = zext i1 %streq_cmp196 to i64
  %in_or198 = or i64 %streq_ext197, 0
  %in_or199 = or i64 %streq_ext193, %in_or198
  %r_bool = icmp ne i64 %in_or199, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %ifcont173
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
  %20 = call i32 @puts(ptr @.str.22)
  %widen200 = sext i32 %20 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %sc_merge
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
