; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%__union = type { i64, ptr }
%Dog = type { ptr }
%Cat = type { ptr }

@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_ifexpr.av\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.float_str.2 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.match_fn.3 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.4 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_ifexpr.av\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"orange\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"name: \00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_ifexpr.av\00", align 1
@.str.8 = private unnamed_addr constant [8 x i8] c"color: \00", align 1
@fld_name.9 = private unnamed_addr constant [6 x i8] c"color\00", align 1
@sty_name.10 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.11 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_ifexpr.av\00", align 1
@.match_fn.12 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.13 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_ifexpr.av\00", align 1
@.str.14 = private unnamed_addr constant [5 x i8] c"nope\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.15 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.16 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_ifexpr.av\00", align 1

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
  %s210 = alloca ptr, align 8
  %v = alloca i1, align 1
  %union_match_result187 = alloca i64, align 8
  %b = alloca ptr, align 8
  %ife_branch_tag164 = alloca i64, align 8
  %ife_wrap162 = alloca i64, align 8
  %ife_result158 = alloca i64, align 8
  %c = alloca ptr, align 8
  %d = alloca ptr, align 8
  %union_match_result121 = alloca i64, align 8
  %pet = alloca ptr, align 8
  %ife_branch_tag98 = alloca i64, align 8
  %ife_wrap96 = alloca i64, align 8
  %ife_result89 = alloca i64, align 8
  %f83 = alloca double, align 8
  %s71 = alloca ptr, align 8
  %union_match_result60 = alloca i64, align 8
  %u2 = alloca ptr, align 8
  %ife_branch_tag37 = alloca i64, align 8
  %ife_wrap35 = alloca i64, align 8
  %ife_result29 = alloca i64, align 8
  %f = alloca double, align 8
  %s = alloca ptr, align 8
  %union_match_result = alloca i64, align 8
  %u = alloca ptr, align 8
  %ife_branch_tag = alloca i64, align 8
  %ife_wrap = alloca i64, align 8
  %ife_result = alloca i64, align 8
  br i1 true, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_raw = load i64, ptr %ife_result, align 8
  br i1 true, label %ife_wrap_then, label %ife_wrap_else

ife_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %1 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %1 to double
  %cast1 = bitcast double %cast to i64
  store i64 %cast1, ptr %ife_result, align 8
  br label %ife_end

ife_wrap_end:                                     ; preds = %ife_wrap_else, %ife_wrap_then
  %ife_union_val = load i64, ptr %ife_wrap, align 8
  %cast11 = inttoptr i64 %ife_union_val to ptr
  store ptr %cast11, ptr %u, align 8
  %u12 = load ptr, ptr %u, align 8
  %union_tag_ptr13 = getelementptr inbounds nuw %__union, ptr %u12, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr13, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq, label %union_arm, label %union_next

ife_wrap_then:                                    ; preds = %ife_end
  %2 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %2, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast2 = inttoptr i64 %ife_raw to ptr
  store ptr %cast2, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %2, i32 0, i32 1
  store ptr %3, ptr %union_pay_ptr, align 8
  %cast3 = ptrtoint ptr %2 to i64
  store i64 %cast3, ptr %ife_wrap, align 8
  br label %ife_wrap_end

ife_wrap_else:                                    ; preds = %ife_end
  %4 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr4 = getelementptr inbounds nuw %__union, ptr %4, i32 0, i32 0
  store i64 210712519067, ptr %union_tag_ptr4, align 8
  %5 = call ptr @avra_rc_alloc(i64 8)
  %slot_base5 = ptrtoint ptr %5 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  %cast8 = bitcast i64 %ife_raw to double
  store double %cast8, ptr %slot7, align 8
  %union_pay_ptr9 = getelementptr inbounds nuw %__union, ptr %4, i32 0, i32 1
  store ptr %5, ptr %union_pay_ptr9, align 8
  %cast10 = ptrtoint ptr %4 to i64
  store i64 %cast10, ptr %ife_wrap, align 8
  br label %ife_wrap_end

union_match_end:                                  ; preds = %union_arm16, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  br i1 false, label %ife_then31, label %ife_else32

union_arm:                                        ; preds = %ife_wrap_end
  %union_pay_ptr14 = getelementptr inbounds nuw %__union, ptr %u12, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr14, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load ptr, ptr %union_val_slot, align 8
  store ptr %union_val, ptr %s, align 8
  %s15 = load ptr, ptr %s, align 8
  %6 = call i32 @puts(ptr %s15)
  %widen = sext i32 %6 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %ife_wrap_end
  %union_tag_eq18 = icmp eq i64 %union_tag, 210712519067
  br i1 %union_tag_eq18, label %union_arm16, label %union_next17

union_arm16:                                      ; preds = %union_next
  %union_pay_ptr19 = getelementptr inbounds nuw %__union, ptr %u12, i32 0, i32 1
  %union_payload20 = load ptr, ptr %union_pay_ptr19, align 8
  %union_val_slot_base21 = ptrtoint ptr %union_payload20 to i64
  %union_val_slot_addr22 = add i64 %union_val_slot_base21, 0
  %union_val_slot23 = inttoptr i64 %union_val_slot_addr22 to ptr
  %union_val24 = load double, ptr %union_val_slot23, align 8
  store double %union_val24, ptr %f, align 8
  %f25 = load double, ptr %f, align 8
  %cast26 = bitcast double %f25 to i64
  %7 = call i64 @avra_float_to_string(i64 %cast26)
  %cast27 = inttoptr i64 %7 to ptr
  %8 = call i32 @puts(ptr %cast27)
  %widen28 = sext i32 %8 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next17:                                     ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 12)
  unreachable

ife_end30:                                        ; preds = %ife_else32, %ife_then31
  %ife_raw38 = load i64, ptr %ife_result29, align 8
  br i1 false, label %ife_wrap_then39, label %ife_wrap_else40

ife_then31:                                       ; preds = %union_match_end
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %ife_result29, align 8
  br label %ife_end30

ife_else32:                                       ; preds = %union_match_end
  %9 = call i64 @avra_float_parse(ptr @.float_str.2)
  %cast33 = bitcast i64 %9 to double
  %cast34 = bitcast double %cast33 to i64
  store i64 %cast34, ptr %ife_result29, align 8
  br label %ife_end30

ife_wrap_end36:                                   ; preds = %ife_wrap_else40, %ife_wrap_then39
  %ife_union_val55 = load i64, ptr %ife_wrap35, align 8
  %cast56 = inttoptr i64 %ife_union_val55 to ptr
  store ptr %cast56, ptr %u2, align 8
  %u257 = load ptr, ptr %u2, align 8
  %union_tag_ptr58 = getelementptr inbounds nuw %__union, ptr %u257, i32 0, i32 0
  %union_tag59 = load i64, ptr %union_tag_ptr58, align 8
  store i64 0, ptr %union_match_result60, align 8
  %union_tag_eq64 = icmp eq i64 %union_tag59, 6954031493116
  br i1 %union_tag_eq64, label %union_arm62, label %union_next63

ife_wrap_then39:                                  ; preds = %ife_end30
  %10 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr41 = getelementptr inbounds nuw %__union, ptr %10, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr41, align 8
  %11 = call ptr @avra_rc_alloc(i64 8)
  %slot_base42 = ptrtoint ptr %11 to i64
  %slot_addr43 = add i64 %slot_base42, 0
  %slot44 = inttoptr i64 %slot_addr43 to ptr
  %cast45 = inttoptr i64 %ife_raw38 to ptr
  store ptr %cast45, ptr %slot44, align 8
  %union_pay_ptr46 = getelementptr inbounds nuw %__union, ptr %10, i32 0, i32 1
  store ptr %11, ptr %union_pay_ptr46, align 8
  %cast47 = ptrtoint ptr %10 to i64
  store i64 %cast47, ptr %ife_wrap35, align 8
  br label %ife_wrap_end36

ife_wrap_else40:                                  ; preds = %ife_end30
  %12 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr48 = getelementptr inbounds nuw %__union, ptr %12, i32 0, i32 0
  store i64 210712519067, ptr %union_tag_ptr48, align 8
  %13 = call ptr @avra_rc_alloc(i64 8)
  %slot_base49 = ptrtoint ptr %13 to i64
  %slot_addr50 = add i64 %slot_base49, 0
  %slot51 = inttoptr i64 %slot_addr50 to ptr
  %cast52 = bitcast i64 %ife_raw38 to double
  store double %cast52, ptr %slot51, align 8
  %union_pay_ptr53 = getelementptr inbounds nuw %__union, ptr %12, i32 0, i32 1
  store ptr %13, ptr %union_pay_ptr53, align 8
  %cast54 = ptrtoint ptr %12 to i64
  store i64 %cast54, ptr %ife_wrap35, align 8
  br label %ife_wrap_end36

union_match_end61:                                ; preds = %union_arm74, %union_arm62
  %union_match_val88 = load i64, ptr %union_match_result60, align 8
  br i1 true, label %ife_then91, label %ife_else92

union_arm62:                                      ; preds = %ife_wrap_end36
  %union_pay_ptr65 = getelementptr inbounds nuw %__union, ptr %u257, i32 0, i32 1
  %union_payload66 = load ptr, ptr %union_pay_ptr65, align 8
  %union_val_slot_base67 = ptrtoint ptr %union_payload66 to i64
  %union_val_slot_addr68 = add i64 %union_val_slot_base67, 0
  %union_val_slot69 = inttoptr i64 %union_val_slot_addr68 to ptr
  %union_val70 = load ptr, ptr %union_val_slot69, align 8
  store ptr %union_val70, ptr %s71, align 8
  %s72 = load ptr, ptr %s71, align 8
  %14 = call i32 @puts(ptr %s72)
  %widen73 = sext i32 %14 to i64
  store i64 0, ptr %union_match_result60, align 8
  br label %union_match_end61

union_next63:                                     ; preds = %ife_wrap_end36
  %union_tag_eq76 = icmp eq i64 %union_tag59, 210712519067
  br i1 %union_tag_eq76, label %union_arm74, label %union_next75

union_arm74:                                      ; preds = %union_next63
  %union_pay_ptr77 = getelementptr inbounds nuw %__union, ptr %u257, i32 0, i32 1
  %union_payload78 = load ptr, ptr %union_pay_ptr77, align 8
  %union_val_slot_base79 = ptrtoint ptr %union_payload78 to i64
  %union_val_slot_addr80 = add i64 %union_val_slot_base79, 0
  %union_val_slot81 = inttoptr i64 %union_val_slot_addr80 to ptr
  %union_val82 = load double, ptr %union_val_slot81, align 8
  store double %union_val82, ptr %f83, align 8
  %f84 = load double, ptr %f83, align 8
  %cast85 = bitcast double %f84 to i64
  %15 = call i64 @avra_float_to_string(i64 %cast85)
  %cast86 = inttoptr i64 %15 to ptr
  %16 = call i32 @puts(ptr %cast86)
  %widen87 = sext i32 %16 to i64
  store i64 0, ptr %union_match_result60, align 8
  br label %union_match_end61

union_next75:                                     ; preds = %union_next63
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %union_tag59, ptr @mu_file.4, i64 18)
  unreachable

ife_end90:                                        ; preds = %ife_else92, %ife_then91
  %ife_raw99 = load i64, ptr %ife_result89, align 8
  br i1 true, label %ife_wrap_then100, label %ife_wrap_else101

ife_then91:                                       ; preds = %union_match_end61
  %17 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Dog, ptr %17, i32 0, i32 0
  store ptr @.str.5, ptr %fld_ptr, align 8
  %cast93 = ptrtoint ptr %17 to i64
  store i64 %cast93, ptr %ife_result89, align 8
  br label %ife_end90

ife_else92:                                       ; preds = %union_match_end61
  %18 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr94 = getelementptr inbounds nuw %Cat, ptr %18, i32 0, i32 0
  store ptr @.str.6, ptr %fld_ptr94, align 8
  %cast95 = ptrtoint ptr %18 to i64
  store i64 %cast95, ptr %ife_result89, align 8
  br label %ife_end90

ife_wrap_end97:                                   ; preds = %ife_wrap_else101, %ife_wrap_then100
  %ife_union_val116 = load i64, ptr %ife_wrap96, align 8
  %cast117 = inttoptr i64 %ife_union_val116 to ptr
  store ptr %cast117, ptr %pet, align 8
  %pet118 = load ptr, ptr %pet, align 8
  %union_tag_ptr119 = getelementptr inbounds nuw %__union, ptr %pet118, i32 0, i32 0
  %union_tag120 = load i64, ptr %union_tag_ptr119, align 8
  store i64 0, ptr %union_match_result121, align 8
  %union_tag_eq125 = icmp eq i64 %union_tag120, 193454815
  br i1 %union_tag_eq125, label %union_arm123, label %union_next124

ife_wrap_then100:                                 ; preds = %ife_end90
  %19 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr102 = getelementptr inbounds nuw %__union, ptr %19, i32 0, i32 0
  store i64 193454815, ptr %union_tag_ptr102, align 8
  %20 = call ptr @avra_rc_alloc(i64 8)
  %slot_base103 = ptrtoint ptr %20 to i64
  %slot_addr104 = add i64 %slot_base103, 0
  %slot105 = inttoptr i64 %slot_addr104 to ptr
  %cast106 = inttoptr i64 %ife_raw99 to ptr
  store ptr %cast106, ptr %slot105, align 8
  %union_pay_ptr107 = getelementptr inbounds nuw %__union, ptr %19, i32 0, i32 1
  store ptr %20, ptr %union_pay_ptr107, align 8
  %cast108 = ptrtoint ptr %19 to i64
  store i64 %cast108, ptr %ife_wrap96, align 8
  br label %ife_wrap_end97

ife_wrap_else101:                                 ; preds = %ife_end90
  %21 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr109 = getelementptr inbounds nuw %__union, ptr %21, i32 0, i32 0
  store i64 193453277, ptr %union_tag_ptr109, align 8
  %22 = call ptr @avra_rc_alloc(i64 8)
  %slot_base110 = ptrtoint ptr %22 to i64
  %slot_addr111 = add i64 %slot_base110, 0
  %slot112 = inttoptr i64 %slot_addr111 to ptr
  %cast113 = inttoptr i64 %ife_raw99 to ptr
  store ptr %cast113, ptr %slot112, align 8
  %union_pay_ptr114 = getelementptr inbounds nuw %__union, ptr %21, i32 0, i32 1
  store ptr %22, ptr %union_pay_ptr114, align 8
  %cast115 = ptrtoint ptr %21 to i64
  store i64 %cast115, ptr %ife_wrap96, align 8
  br label %ife_wrap_end97

union_match_end122:                               ; preds = %union_arm137, %union_arm123
  %union_match_val157 = load i64, ptr %union_match_result121, align 8
  br i1 true, label %ife_then160, label %ife_else161

union_arm123:                                     ; preds = %ife_wrap_end97
  %union_pay_ptr126 = getelementptr inbounds nuw %__union, ptr %pet118, i32 0, i32 1
  %union_payload127 = load ptr, ptr %union_pay_ptr126, align 8
  %union_val_slot_base128 = ptrtoint ptr %union_payload127 to i64
  %union_val_slot_addr129 = add i64 %union_val_slot_base128, 0
  %union_val_slot130 = inttoptr i64 %union_val_slot_addr129 to ptr
  %union_val131 = load ptr, ptr %union_val_slot130, align 8
  store ptr %union_val131, ptr %d, align 8
  %d132 = load ptr, ptr %d, align 8
  %cast133 = ptrtoint ptr %d132 to i64
  %null_chk = icmp eq i64 %cast133, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 98, i64 25)
  %name_ptr = getelementptr inbounds nuw %Dog, ptr %d132, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %23 = call i64 @strlen(ptr @.str.7)
  %24 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %23, %24
  %concat_size = add i64 %concat_total, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size)
  %26 = call ptr @memcpy(ptr %25, ptr @.str.7, i64 %23)
  %cast134 = ptrtoint ptr %25 to i64
  %dst2_int = add i64 %cast134, %23
  %cast135 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast135, ptr %name, i64 %rhs_len_p1)
  %28 = call i32 @puts(ptr %25)
  %widen136 = sext i32 %28 to i64
  store i64 0, ptr %union_match_result121, align 8
  br label %union_match_end122

union_next124:                                    ; preds = %ife_wrap_end97
  %union_tag_eq139 = icmp eq i64 %union_tag120, 193453277
  br i1 %union_tag_eq139, label %union_arm137, label %union_next138

union_arm137:                                     ; preds = %union_next124
  %union_pay_ptr140 = getelementptr inbounds nuw %__union, ptr %pet118, i32 0, i32 1
  %union_payload141 = load ptr, ptr %union_pay_ptr140, align 8
  %union_val_slot_base142 = ptrtoint ptr %union_payload141 to i64
  %union_val_slot_addr143 = add i64 %union_val_slot_base142, 0
  %union_val_slot144 = inttoptr i64 %union_val_slot_addr143 to ptr
  %union_val145 = load ptr, ptr %union_val_slot144, align 8
  store ptr %union_val145, ptr %c, align 8
  %c146 = load ptr, ptr %c, align 8
  %cast147 = ptrtoint ptr %c146 to i64
  %null_chk148 = icmp eq i64 %cast147, 0
  %null_ext149 = zext i1 %null_chk148 to i64
  call void @avra_null_deref_trap(ptr @fld_name.9, i64 5, ptr @sty_name.10, i64 3, i64 %null_ext149, ptr @src_file.11, i64 98, i64 25)
  %color_ptr = getelementptr inbounds nuw %Cat, ptr %c146, i32 0, i32 0
  %color = load ptr, ptr %color_ptr, align 8
  %29 = call i64 @strlen(ptr @.str.8)
  %30 = call i64 @strlen(ptr %color)
  %concat_total150 = add i64 %29, %30
  %concat_size151 = add i64 %concat_total150, 1
  %31 = call ptr @avra_rc_alloc(i64 %concat_size151)
  %32 = call ptr @memcpy(ptr %31, ptr @.str.8, i64 %29)
  %cast152 = ptrtoint ptr %31 to i64
  %dst2_int153 = add i64 %cast152, %29
  %cast154 = inttoptr i64 %dst2_int153 to ptr
  %rhs_len_p1155 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast154, ptr %color, i64 %rhs_len_p1155)
  %34 = call i32 @puts(ptr %31)
  %widen156 = sext i32 %34 to i64
  store i64 0, ptr %union_match_result121, align 8
  br label %union_match_end122

union_next138:                                    ; preds = %union_next124
  call void @avra_match_unreachable(ptr @.match_fn.12, i64 %union_tag120, ptr @mu_file.13, i64 25)
  unreachable

ife_end159:                                       ; preds = %ife_else161, %ife_then160
  %ife_raw165 = load i64, ptr %ife_result158, align 8
  br i1 true, label %ife_wrap_then166, label %ife_wrap_else167

ife_then160:                                      ; preds = %union_match_end122
  store i64 1, ptr %ife_result158, align 8
  br label %ife_end159

ife_else161:                                      ; preds = %union_match_end122
  store i64 ptrtoint (ptr @.str.14 to i64), ptr %ife_result158, align 8
  br label %ife_end159

ife_wrap_end163:                                  ; preds = %ife_wrap_else167, %ife_wrap_then166
  %ife_union_val182 = load i64, ptr %ife_wrap162, align 8
  %cast183 = inttoptr i64 %ife_union_val182 to ptr
  store ptr %cast183, ptr %b, align 8
  %b184 = load ptr, ptr %b, align 8
  %union_tag_ptr185 = getelementptr inbounds nuw %__union, ptr %b184, i32 0, i32 0
  %union_tag186 = load i64, ptr %union_tag_ptr185, align 8
  store i64 0, ptr %union_match_result187, align 8
  %union_tag_eq191 = icmp eq i64 %union_tag186, 6385087377
  br i1 %union_tag_eq191, label %union_arm189, label %union_next190

ife_wrap_then166:                                 ; preds = %ife_end159
  %35 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr168 = getelementptr inbounds nuw %__union, ptr %35, i32 0, i32 0
  store i64 6385087377, ptr %union_tag_ptr168, align 8
  %36 = call ptr @avra_rc_alloc(i64 8)
  %slot_base169 = ptrtoint ptr %36 to i64
  %slot_addr170 = add i64 %slot_base169, 0
  %slot171 = inttoptr i64 %slot_addr170 to ptr
  %cast172 = trunc i64 %ife_raw165 to i1
  store i1 %cast172, ptr %slot171, align 8
  %union_pay_ptr173 = getelementptr inbounds nuw %__union, ptr %35, i32 0, i32 1
  store ptr %36, ptr %union_pay_ptr173, align 8
  %cast174 = ptrtoint ptr %35 to i64
  store i64 %cast174, ptr %ife_wrap162, align 8
  br label %ife_wrap_end163

ife_wrap_else167:                                 ; preds = %ife_end159
  %37 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr175 = getelementptr inbounds nuw %__union, ptr %37, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr175, align 8
  %38 = call ptr @avra_rc_alloc(i64 8)
  %slot_base176 = ptrtoint ptr %38 to i64
  %slot_addr177 = add i64 %slot_base176, 0
  %slot178 = inttoptr i64 %slot_addr177 to ptr
  %cast179 = inttoptr i64 %ife_raw165 to ptr
  store ptr %cast179, ptr %slot178, align 8
  %union_pay_ptr180 = getelementptr inbounds nuw %__union, ptr %37, i32 0, i32 1
  store ptr %38, ptr %union_pay_ptr180, align 8
  %cast181 = ptrtoint ptr %37 to i64
  store i64 %cast181, ptr %ife_wrap162, align 8
  br label %ife_wrap_end163

union_match_end188:                               ; preds = %union_arm201, %union_arm189
  %union_match_val213 = load i64, ptr %union_match_result187, align 8
  ret i64 %union_match_val213

union_arm189:                                     ; preds = %ife_wrap_end163
  %union_pay_ptr192 = getelementptr inbounds nuw %__union, ptr %b184, i32 0, i32 1
  %union_payload193 = load ptr, ptr %union_pay_ptr192, align 8
  %union_val_slot_base194 = ptrtoint ptr %union_payload193 to i64
  %union_val_slot_addr195 = add i64 %union_val_slot_base194, 0
  %union_val_slot196 = inttoptr i64 %union_val_slot_addr195 to ptr
  %union_val197 = load i1, ptr %union_val_slot196, align 8
  store i1 %union_val197, ptr %v, align 8
  %v198 = load i1, ptr %v, align 8
  %39 = call ptr @avra_rc_alloc(i64 32)
  %40 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %39, i64 32, ptr @.i2s_fmt, i1 %v198)
  %widen199 = sext i32 %40 to i64
  %41 = call i32 @puts(ptr %39)
  %widen200 = sext i32 %41 to i64
  store i64 0, ptr %union_match_result187, align 8
  br label %union_match_end188

union_next190:                                    ; preds = %ife_wrap_end163
  %union_tag_eq203 = icmp eq i64 %union_tag186, 6954031493116
  br i1 %union_tag_eq203, label %union_arm201, label %union_next202

union_arm201:                                     ; preds = %union_next190
  %union_pay_ptr204 = getelementptr inbounds nuw %__union, ptr %b184, i32 0, i32 1
  %union_payload205 = load ptr, ptr %union_pay_ptr204, align 8
  %union_val_slot_base206 = ptrtoint ptr %union_payload205 to i64
  %union_val_slot_addr207 = add i64 %union_val_slot_base206, 0
  %union_val_slot208 = inttoptr i64 %union_val_slot_addr207 to ptr
  %union_val209 = load ptr, ptr %union_val_slot208, align 8
  store ptr %union_val209, ptr %s210, align 8
  %s211 = load ptr, ptr %s210, align 8
  %42 = call i32 @puts(ptr %s211)
  %widen212 = sext i32 %42 to i64
  store i64 0, ptr %union_match_result187, align 8
  br label %union_match_end188

union_next202:                                    ; preds = %union_next190
  call void @avra_match_unreachable(ptr @.match_fn.15, i64 %union_tag186, ptr @mu_file.16, i64 32)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Cat(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_color_ptr = getelementptr inbounds nuw %Cat, ptr %0, i32 0, i32 0
  %rel_color = load ptr, ptr %rel_color_ptr, align 8
  %is_null_color = icmp eq ptr %rel_color, null
  br i1 %is_null_color, label %rel_color_skip, label %rel_color_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_color_skip
  ret i64 0

rel_color_skip:                                   ; preds = %rel_color_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_color_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_color)
  br label %rel_color_skip
}

define i64 @__release_Dog(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Dog, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}
