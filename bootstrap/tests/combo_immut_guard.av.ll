; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Task = type { ptr, ptr, i64 }
%Priority = type { i64, ptr }

@tasks = global i64 0
@urgent_count = global i64 0
@undone = global i64 0
@.str = private unnamed_addr constant [7 x i8] c"design\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"docs\00", align 1
@fld_name = private unnamed_addr constant [9 x i8] c"priority\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_guard.av\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_guard.av\00", align 1
@fld_name.4 = private unnamed_addr constant [5 x i8] c"done\00", align 1
@sty_name.5 = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file.6 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_guard.av\00", align 1
@fld_name.7 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.8 = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file.9 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_guard.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.10 = private unnamed_addr constant [5 x i8] c"done\00", align 1
@sty_name.11 = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file.12 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_immut_guard.av\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %is_urgent = alloca i64, align 8
  %lvl35 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %t = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr = getelementptr inbounds nuw %Task, ptr %1, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Priority, ptr %2, i32 0, i32 0
  store i64 6384146213, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Priority, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  %fld_ptr1 = getelementptr inbounds nuw %Task, ptr %1, i32 0, i32 1
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %fld_ptr1, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Task, ptr %1, i32 0, i32 2
  store i64 0, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast4)
  %4 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr5 = getelementptr inbounds nuw %Task, ptr %4, i32 0, i32 0
  store ptr @.str.1, ptr %fld_ptr5, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %Priority, ptr %5, i32 0, i32 0
  store i64 6384146213, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %Priority, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr7, align 8
  %slot_base8 = ptrtoint ptr %6 to i64
  %slot_addr9 = add i64 %slot_base8, 0
  %slot10 = inttoptr i64 %slot_addr9 to ptr
  store i64 3, ptr %slot10, align 8
  %cast11 = ptrtoint ptr %5 to i64
  %fld_ptr12 = getelementptr inbounds nuw %Task, ptr %4, i32 0, i32 1
  %cast13 = inttoptr i64 %cast11 to ptr
  store ptr %cast13, ptr %fld_ptr12, align 8
  %fld_ptr14 = getelementptr inbounds nuw %Task, ptr %4, i32 0, i32 2
  store i64 1, ptr %fld_ptr14, align 8
  %cast15 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %0, i64 %cast15)
  %7 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr16 = getelementptr inbounds nuw %Task, ptr %7, i32 0, i32 0
  store ptr @.str.2, ptr %fld_ptr16, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr17 = getelementptr inbounds nuw %Priority, ptr %8, i32 0, i32 0
  store i64 6952526056486, ptr %tag_ptr17, align 8
  %pay_ptr18 = getelementptr inbounds nuw %Priority, ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr18, align 8
  %cast19 = ptrtoint ptr %8 to i64
  %fld_ptr20 = getelementptr inbounds nuw %Task, ptr %7, i32 0, i32 1
  %cast21 = inttoptr i64 %cast19 to ptr
  store ptr %cast21, ptr %fld_ptr20, align 8
  %fld_ptr22 = getelementptr inbounds nuw %Task, ptr %7, i32 0, i32 2
  store i64 0, ptr %fld_ptr22, align 8
  %cast23 = ptrtoint ptr %7 to i64
  call void @avra_array_push(ptr %0, i64 %cast23)
  %9 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr24 = getelementptr inbounds nuw %Task, ptr %9, i32 0, i32 0
  store ptr @.str.3, ptr %fld_ptr24, align 8
  %10 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr25 = getelementptr inbounds nuw %Priority, ptr %10, i32 0, i32 0
  store i64 193463543, ptr %tag_ptr25, align 8
  %pay_ptr26 = getelementptr inbounds nuw %Priority, ptr %10, i32 0, i32 1
  store ptr null, ptr %pay_ptr26, align 8
  %cast27 = ptrtoint ptr %10 to i64
  %fld_ptr28 = getelementptr inbounds nuw %Task, ptr %9, i32 0, i32 1
  %cast29 = inttoptr i64 %cast27 to ptr
  store ptr %cast29, ptr %fld_ptr28, align 8
  %fld_ptr30 = getelementptr inbounds nuw %Task, ptr %9, i32 0, i32 2
  store i64 0, ptr %fld_ptr30, align 8
  %cast31 = ptrtoint ptr %9 to i64
  call void @avra_array_push(ptr %0, i64 %cast31)
  store ptr %0, ptr @tasks, align 8
  store i64 0, ptr @urgent_count, align 8
  %tasks = load ptr, ptr @tasks, align 8
  %11 = call i64 @avra_array_len(ptr %tasks)
  store i64 %11, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %12 = call i64 @avra_array_get(ptr %tasks, i64 %forin_i_val)
  store i64 %12, ptr %t, align 8
  %t32 = load ptr, ptr %t, align 8
  %cast33 = ptrtoint ptr %t32 to i64
  %null_chk = icmp eq i64 %cast33, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 8, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 103, i64 16)
  %priority_ptr = getelementptr inbounds nuw %Task, ptr %t32, i32 0, i32 1
  %priority = load ptr, ptr %priority_ptr, align 8
  %tag_ptr34 = getelementptr inbounds nuw %Priority, ptr %priority, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr34, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384146213
  br i1 %tag_eq, label %march_arm, label %march_next

forin.incr:                                       ; preds = %ifcont
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %urgent_count50 = load i64, ptr @urgent_count, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt, i64 %urgent_count50)
  %widen51 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen52 = sext i32 %15 to i64
  %tasks53 = load ptr, ptr @tasks, align 8
  %16 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %16, i64 -559038737)
  call void @avra_array_push(ptr %16, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast54 = ptrtoint ptr %16 to i64
  %17 = call ptr @avra_array_filter(ptr %tasks53, i64 %cast54)
  store ptr %17, ptr @undone, align 8
  %undone = load ptr, ptr @undone, align 8
  %18 = call i64 @avra_array_len(ptr %undone)
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.13, i64 %18)
  %widen55 = sext i32 %20 to i64
  %21 = call i32 @puts(ptr %19)
  %widen56 = sext i32 %21 to i64
  %22 = call i32 @avra_test_summary()
  %widen57 = sext i32 %22 to i64
  call void @avra_rc_collect()
  ret i64 0

match_end:                                        ; preds = %march_arm37, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  store i64 %match_val, ptr %is_urgent, align 8
  %is_urgent39 = load i64, ptr %is_urgent, align 8
  %eq = icmp eq i64 %is_urgent39, 1
  %eq_ext = zext i1 %eq to i64
  %l_bool = icmp ne i64 %eq_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

march_arm:                                        ; preds = %forin.body
  %pay_slot = getelementptr inbounds nuw %Priority, ptr %priority, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %lvl_slot_base = ptrtoint ptr %payload to i64
  %lvl_slot_addr = add i64 %lvl_slot_base, 0
  %lvl_slot = inttoptr i64 %lvl_slot_addr to ptr
  %lvl = load i64, ptr %lvl_slot, align 8
  store i64 %lvl, ptr %lvl35, align 8
  %lvl36 = load i64, ptr %lvl35, align 8
  %sge = icmp sge i64 %lvl36, 4
  %sge_ext = zext i1 %sge to i64
  %guard = icmp ne i64 %sge_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %forin.body
  br label %march_arm37

guard_pass:                                       ; preds = %march_arm
  store i64 1, ptr %match_result, align 8
  br label %match_end

march_arm37:                                      ; preds = %march_next
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next38:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 16)
  unreachable

sc_rhs:                                           ; preds = %match_end
  %t40 = load ptr, ptr %t, align 8
  %cast41 = ptrtoint ptr %t40 to i64
  %null_chk42 = icmp eq i64 %cast41, 0
  %null_ext43 = zext i1 %null_chk42 to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 4, ptr @sty_name.5, i64 4, i64 %null_ext43, ptr @src_file.6, i64 103, i64 20)
  %done_ptr = getelementptr inbounds nuw %Task, ptr %t40, i32 0, i32 2
  %done = load i64, ptr %done_ptr, align 8
  %eq44 = icmp eq i64 %done, 0
  %eq_ext45 = zext i1 %eq44 to i64
  %r_bool = icmp ne i64 %eq_ext45, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %match_end
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
  br label %forin.incr

if_then:                                          ; preds = %sc_merge
  %urgent_count = load i64, ptr @urgent_count, align 8
  %add = add i64 %urgent_count, 1
  store i64 %add, ptr @urgent_count, align 8
  %t46 = load ptr, ptr %t, align 8
  %cast47 = ptrtoint ptr %t46 to i64
  %null_chk48 = icmp eq i64 %cast47, 0
  %null_ext49 = zext i1 %null_chk48 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 4, ptr @sty_name.8, i64 4, i64 %null_ext49, ptr @src_file.9, i64 103, i64 22)
  %name_ptr = getelementptr inbounds nuw %Task, ptr %t46, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %23 = call i32 @puts(ptr %name)
  %widen = sext i32 %23 to i64
  br label %ifcont

if_else:                                          ; preds = %sc_merge
  br label %ifcont
}

define i64 @__release_Task(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Task, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_priority_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_priority_ptr = getelementptr inbounds nuw %Task, ptr %0, i32 0, i32 1
  %rel_priority = load ptr, ptr %rel_priority_ptr, align 8
  %is_null_priority = icmp eq ptr %rel_priority, null
  br i1 %is_null_priority, label %rel_priority_skip, label %rel_priority_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_priority_skip:                                ; preds = %rel_priority_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_priority_do:                                  ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_priority)
  br label %rel_priority_skip
}

define i64 @__lambda_0(ptr %0) {
entry:
  %t = alloca ptr, align 8
  store ptr %0, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %cast = ptrtoint ptr %t1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 4, ptr @sty_name.11, i64 4, i64 %null_ext, ptr @src_file.12, i64 103, i64 28)
  %done_ptr = getelementptr inbounds nuw %Task, ptr %t1, i32 0, i32 2
  %done = load i64, ptr %done_ptr, align 8
  %eq = icmp eq i64 %done, 0
  %eq_ext = zext i1 %eq to i64
  ret i64 %eq_ext
}
