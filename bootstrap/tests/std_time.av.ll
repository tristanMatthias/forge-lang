; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [9 x i8] c"epoch ok\00", align 1
@.str.9 = private unnamed_addr constant [8 x i8] c"year ok\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"month ok\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c"day ok\00", align 1
@.str.12 = private unnamed_addr constant [8 x i8] c"hour ok\00", align 1
@.str.13 = private unnamed_addr constant [10 x i8] c"minute ok\00", align 1
@.str.14 = private unnamed_addr constant [10 x i8] c"second ok\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [10 x i8] c"uptime ok\00", align 1

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

declare i64 @avra_datetime_now.1()

declare ptr @avra_datetime_format.2(i64, ptr)

declare i64 @avra_datetime_year.3(i64)

declare i64 @avra_datetime_month.4(i64)

declare i64 @avra_datetime_day.5(i64)

declare i64 @avra_datetime_hour.6(i64)

declare i64 @avra_datetime_minute.7(i64)

declare i64 @avra_datetime_second.8(i64)

declare i64 @avra_uptime_ms()

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %sif_result = alloca i64, align 8
  %up = alloca i64, align 8
  %mid2000 = alloca i64, align 8
  %sc = alloca i64, align 8
  %mn = alloca i64, align 8
  %hr = alloca i64, align 8
  %dy = alloca i64, align 8
  %mo = alloca i64, align 8
  %yr = alloca i64, align 8
  %now = alloca i64, align 8
  %1 = call i64 @avra_datetime_now()
  store i64 %1, ptr %now, align 8
  %now1 = load i64, ptr %now, align 8
  %sgt = icmp sgt i64 %now1, 0
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %now2 = load i64, ptr %now, align 8
  %cast = inttoptr i64 %now2 to ptr
  %2 = call i64 @avra_datetime_year(ptr %cast)
  store i64 %2, ptr %yr, align 8
  %yr3 = load i64, ptr %yr, align 8
  %sge = icmp sge i64 %yr3, 2026
  %sge_ext = zext i1 %sge to i64
  %if_cond5 = icmp ne i64 %sge_ext, 0
  br i1 %if_cond5, label %if_then6, label %if_else7

if_then:                                          ; preds = %entry
  %3 = call i32 @puts(ptr @.str)
  %widen = sext i32 %3 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont4:                                          ; preds = %if_else7, %if_then6
  %now9 = load i64, ptr %now, align 8
  %cast10 = inttoptr i64 %now9 to ptr
  %4 = call i64 @avra_datetime_month(ptr %cast10)
  store i64 %4, ptr %mo, align 8
  %mo11 = load i64, ptr %mo, align 8
  %sge12 = icmp sge i64 %mo11, 1
  %sge_ext13 = zext i1 %sge12 to i64
  %l_bool = icmp ne i64 %sge_ext13, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

if_then6:                                         ; preds = %ifcont
  %5 = call i32 @puts(ptr @.str.9)
  %widen8 = sext i32 %5 to i64
  br label %ifcont4

if_else7:                                         ; preds = %ifcont
  br label %ifcont4

sc_rhs:                                           ; preds = %ifcont4
  %mo14 = load i64, ptr %mo, align 8
  %sle = icmp sle i64 %mo14, 12
  %sle_ext = zext i1 %sle to i64
  %r_bool = icmp ne i64 %sle_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %ifcont4
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond16 = icmp ne i64 %sc_ext, 0
  br i1 %if_cond16, label %if_then17, label %if_else18

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont15:                                         ; preds = %if_else18, %if_then17
  %now20 = load i64, ptr %now, align 8
  %cast21 = inttoptr i64 %now20 to ptr
  %6 = call i64 @avra_datetime_day(ptr %cast21)
  store i64 %6, ptr %dy, align 8
  %dy22 = load i64, ptr %dy, align 8
  %sge23 = icmp sge i64 %dy22, 1
  %sge_ext24 = zext i1 %sge23 to i64
  %l_bool25 = icmp ne i64 %sge_ext24, 0
  br i1 %l_bool25, label %sc_rhs26, label %sc_short27

if_then17:                                        ; preds = %sc_merge
  %7 = call i32 @puts(ptr @.str.10)
  %widen19 = sext i32 %7 to i64
  br label %ifcont15

if_else18:                                        ; preds = %sc_merge
  br label %ifcont15

sc_rhs26:                                         ; preds = %ifcont15
  %dy29 = load i64, ptr %dy, align 8
  %sle30 = icmp sle i64 %dy29, 31
  %sle_ext31 = zext i1 %sle30 to i64
  %r_bool32 = icmp ne i64 %sle_ext31, 0
  br i1 %r_bool32, label %sc_r_true33, label %sc_r_false34

sc_short27:                                       ; preds = %ifcont15
  br label %sc_merge28

sc_merge28:                                       ; preds = %sc_r_merge35, %sc_short27
  %sc_phi36 = phi i1 [ false, %sc_short27 ], [ %r_bool32, %sc_r_merge35 ]
  %sc_ext37 = zext i1 %sc_phi36 to i64
  %if_cond39 = icmp ne i64 %sc_ext37, 0
  br i1 %if_cond39, label %if_then40, label %if_else41

sc_r_true33:                                      ; preds = %sc_rhs26
  br label %sc_r_merge35

sc_r_false34:                                     ; preds = %sc_rhs26
  br label %sc_r_merge35

sc_r_merge35:                                     ; preds = %sc_r_false34, %sc_r_true33
  br label %sc_merge28

ifcont38:                                         ; preds = %if_else41, %if_then40
  %now43 = load i64, ptr %now, align 8
  %cast44 = inttoptr i64 %now43 to ptr
  %8 = call i64 @avra_datetime_hour(ptr %cast44)
  store i64 %8, ptr %hr, align 8
  %hr45 = load i64, ptr %hr, align 8
  %sge46 = icmp sge i64 %hr45, 0
  %sge_ext47 = zext i1 %sge46 to i64
  %l_bool48 = icmp ne i64 %sge_ext47, 0
  br i1 %l_bool48, label %sc_rhs49, label %sc_short50

if_then40:                                        ; preds = %sc_merge28
  %9 = call i32 @puts(ptr @.str.11)
  %widen42 = sext i32 %9 to i64
  br label %ifcont38

if_else41:                                        ; preds = %sc_merge28
  br label %ifcont38

sc_rhs49:                                         ; preds = %ifcont38
  %hr52 = load i64, ptr %hr, align 8
  %sle53 = icmp sle i64 %hr52, 23
  %sle_ext54 = zext i1 %sle53 to i64
  %r_bool55 = icmp ne i64 %sle_ext54, 0
  br i1 %r_bool55, label %sc_r_true56, label %sc_r_false57

sc_short50:                                       ; preds = %ifcont38
  br label %sc_merge51

sc_merge51:                                       ; preds = %sc_r_merge58, %sc_short50
  %sc_phi59 = phi i1 [ false, %sc_short50 ], [ %r_bool55, %sc_r_merge58 ]
  %sc_ext60 = zext i1 %sc_phi59 to i64
  %if_cond62 = icmp ne i64 %sc_ext60, 0
  br i1 %if_cond62, label %if_then63, label %if_else64

sc_r_true56:                                      ; preds = %sc_rhs49
  br label %sc_r_merge58

sc_r_false57:                                     ; preds = %sc_rhs49
  br label %sc_r_merge58

sc_r_merge58:                                     ; preds = %sc_r_false57, %sc_r_true56
  br label %sc_merge51

ifcont61:                                         ; preds = %if_else64, %if_then63
  %now66 = load i64, ptr %now, align 8
  %cast67 = inttoptr i64 %now66 to ptr
  %10 = call i64 @avra_datetime_minute(ptr %cast67)
  store i64 %10, ptr %mn, align 8
  %mn68 = load i64, ptr %mn, align 8
  %sge69 = icmp sge i64 %mn68, 0
  %sge_ext70 = zext i1 %sge69 to i64
  %l_bool71 = icmp ne i64 %sge_ext70, 0
  br i1 %l_bool71, label %sc_rhs72, label %sc_short73

if_then63:                                        ; preds = %sc_merge51
  %11 = call i32 @puts(ptr @.str.12)
  %widen65 = sext i32 %11 to i64
  br label %ifcont61

if_else64:                                        ; preds = %sc_merge51
  br label %ifcont61

sc_rhs72:                                         ; preds = %ifcont61
  %mn75 = load i64, ptr %mn, align 8
  %sle76 = icmp sle i64 %mn75, 59
  %sle_ext77 = zext i1 %sle76 to i64
  %r_bool78 = icmp ne i64 %sle_ext77, 0
  br i1 %r_bool78, label %sc_r_true79, label %sc_r_false80

sc_short73:                                       ; preds = %ifcont61
  br label %sc_merge74

sc_merge74:                                       ; preds = %sc_r_merge81, %sc_short73
  %sc_phi82 = phi i1 [ false, %sc_short73 ], [ %r_bool78, %sc_r_merge81 ]
  %sc_ext83 = zext i1 %sc_phi82 to i64
  %if_cond85 = icmp ne i64 %sc_ext83, 0
  br i1 %if_cond85, label %if_then86, label %if_else87

sc_r_true79:                                      ; preds = %sc_rhs72
  br label %sc_r_merge81

sc_r_false80:                                     ; preds = %sc_rhs72
  br label %sc_r_merge81

sc_r_merge81:                                     ; preds = %sc_r_false80, %sc_r_true79
  br label %sc_merge74

ifcont84:                                         ; preds = %if_else87, %if_then86
  %now89 = load i64, ptr %now, align 8
  %cast90 = inttoptr i64 %now89 to ptr
  %12 = call i64 @avra_datetime_second(ptr %cast90)
  store i64 %12, ptr %sc, align 8
  %sc91 = load i64, ptr %sc, align 8
  %sge92 = icmp sge i64 %sc91, 0
  %sge_ext93 = zext i1 %sge92 to i64
  %l_bool94 = icmp ne i64 %sge_ext93, 0
  br i1 %l_bool94, label %sc_rhs95, label %sc_short96

if_then86:                                        ; preds = %sc_merge74
  %13 = call i32 @puts(ptr @.str.13)
  %widen88 = sext i32 %13 to i64
  br label %ifcont84

if_else87:                                        ; preds = %sc_merge74
  br label %ifcont84

sc_rhs95:                                         ; preds = %ifcont84
  %sc98 = load i64, ptr %sc, align 8
  %sle99 = icmp sle i64 %sc98, 59
  %sle_ext100 = zext i1 %sle99 to i64
  %r_bool101 = icmp ne i64 %sle_ext100, 0
  br i1 %r_bool101, label %sc_r_true102, label %sc_r_false103

sc_short96:                                       ; preds = %ifcont84
  br label %sc_merge97

sc_merge97:                                       ; preds = %sc_r_merge104, %sc_short96
  %sc_phi105 = phi i1 [ false, %sc_short96 ], [ %r_bool101, %sc_r_merge104 ]
  %sc_ext106 = zext i1 %sc_phi105 to i64
  %if_cond108 = icmp ne i64 %sc_ext106, 0
  br i1 %if_cond108, label %if_then109, label %if_else110

sc_r_true102:                                     ; preds = %sc_rhs95
  br label %sc_r_merge104

sc_r_false103:                                    ; preds = %sc_rhs95
  br label %sc_r_merge104

sc_r_merge104:                                    ; preds = %sc_r_false103, %sc_r_true102
  br label %sc_merge97

ifcont107:                                        ; preds = %if_else110, %if_then109
  store i64 961070400, ptr %mid2000, align 8
  %mid2000112 = load i64, ptr %mid2000, align 8
  %cast113 = inttoptr i64 %mid2000112 to ptr
  %14 = call i64 @avra_datetime_year(ptr %cast113)
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt, i64 %14)
  %widen114 = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen115 = sext i32 %17 to i64
  %18 = call i64 @avra_uptime_ms()
  store i64 %18, ptr %up, align 8
  %up116 = load i64, ptr %up, align 8
  %sge117 = icmp sge i64 %up116, 0
  %sge_ext118 = zext i1 %sge117 to i64
  %l_bool119 = icmp ne i64 %sge_ext118, 0
  br i1 %l_bool119, label %sc_rhs120, label %sc_short121

if_then109:                                       ; preds = %sc_merge97
  %19 = call i32 @puts(ptr @.str.14)
  %widen111 = sext i32 %19 to i64
  br label %ifcont107

if_else110:                                       ; preds = %sc_merge97
  br label %ifcont107

sc_rhs120:                                        ; preds = %ifcont107
  %up123 = load i64, ptr %up, align 8
  %slt = icmp slt i64 %up123, 10000
  %slt_ext = zext i1 %slt to i64
  %r_bool124 = icmp ne i64 %slt_ext, 0
  br i1 %r_bool124, label %sc_r_true125, label %sc_r_false126

sc_short121:                                      ; preds = %ifcont107
  br label %sc_merge122

sc_merge122:                                      ; preds = %sc_r_merge127, %sc_short121
  %sc_phi128 = phi i1 [ false, %sc_short121 ], [ %r_bool124, %sc_r_merge127 ]
  %sc_ext129 = zext i1 %sc_phi128 to i64
  %sif_cond = icmp ne i64 %sc_ext129, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sc_r_true125:                                     ; preds = %sc_rhs120
  br label %sc_r_merge127

sc_r_false126:                                    ; preds = %sc_rhs120
  br label %sc_r_merge127

sc_r_merge127:                                    ; preds = %sc_r_false126, %sc_r_true125
  br label %sc_merge122

sif_then:                                         ; preds = %sc_merge122
  %20 = call i32 @puts(ptr @.str.15)
  %widen130 = sext i32 %20 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %sc_merge122
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
