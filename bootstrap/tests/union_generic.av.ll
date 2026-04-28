; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%__union = type { i64, ptr }

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_generic.av\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.2 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.3 = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_generic.av\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"first: \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [8 x i8] c"first: \00", align 1
@.match_fn.8 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.9 = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_generic.av\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"second: \00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [9 x i8] c"second: \00", align 1
@.match_fn.13 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.14 = private unnamed_addr constant [100 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/union_generic.av\00", align 1

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

define ptr @"identity__int|string"(ptr %0) {
entry:
  %x = alloca ptr, align 8
  store ptr %0, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  ret ptr %x1
}

define ptr @"pair__int|string__int|string"(ptr %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  ret ptr %a1
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %s149 = alloca ptr, align 8
  %n130 = alloca i64, align 8
  %union_match_result119 = alloca i64, align 8
  %r2 = alloca ptr, align 8
  %s104 = alloca ptr, align 8
  %n89 = alloca i64, align 8
  %union_match_result78 = alloca i64, align 8
  %r = alloca ptr, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %s55 = alloca ptr, align 8
  %n42 = alloca i64, align 8
  %union_match_result31 = alloca i64, align 8
  %v2 = alloca ptr, align 8
  %u225 = alloca ptr, align 8
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %v = alloca ptr, align 8
  %u = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %1, i32 0, i32 1
  store ptr %2, ptr %union_pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %u, align 8
  %u2 = load ptr, ptr %u, align 8
  %3 = call ptr @"identity__int|string"(ptr %u2)
  store ptr %3, ptr %v, align 8
  %v3 = load ptr, ptr %v, align 8
  %union_tag_ptr4 = getelementptr inbounds nuw %__union, ptr %v3, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr4, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm8, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr19 = getelementptr inbounds nuw %__union, ptr %4, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr19, align 8
  %5 = call ptr @avra_rc_alloc(i64 8)
  %slot_base20 = ptrtoint ptr %5 to i64
  %slot_addr21 = add i64 %slot_base20, 0
  %slot22 = inttoptr i64 %slot_addr21 to ptr
  store ptr @.str, ptr %slot22, align 8
  %union_pay_ptr23 = getelementptr inbounds nuw %__union, ptr %4, i32 0, i32 1
  store ptr %5, ptr %union_pay_ptr23, align 8
  %cast24 = ptrtoint ptr %4 to i64
  %cast26 = inttoptr i64 %cast24 to ptr
  store ptr %cast26, ptr %u225, align 8
  %u227 = load ptr, ptr %u225, align 8
  %6 = call ptr @"identity__int|string"(ptr %u227)
  store ptr %6, ptr %v2, align 8
  %v228 = load ptr, ptr %v2, align 8
  %union_tag_ptr29 = getelementptr inbounds nuw %__union, ptr %v228, i32 0, i32 0
  %union_tag30 = load i64, ptr %union_tag_ptr29, align 8
  store i64 0, ptr %union_match_result31, align 8
  %union_tag_eq35 = icmp eq i64 %union_tag30, 193495088
  br i1 %union_tag_eq35, label %union_arm33, label %union_next34

union_arm:                                        ; preds = %entry
  %union_pay_ptr5 = getelementptr inbounds nuw %__union, ptr %v3, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr5, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %n6 = load i64, ptr %n, align 8
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt, i64 %n6)
  %widen = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen7 = sext i32 %9 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq10 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq10, label %union_arm8, label %union_next9

union_arm8:                                       ; preds = %union_next
  %union_pay_ptr11 = getelementptr inbounds nuw %__union, ptr %v3, i32 0, i32 1
  %union_payload12 = load ptr, ptr %union_pay_ptr11, align 8
  %union_val_slot_base13 = ptrtoint ptr %union_payload12 to i64
  %union_val_slot_addr14 = add i64 %union_val_slot_base13, 0
  %union_val_slot15 = inttoptr i64 %union_val_slot_addr14 to ptr
  %union_val16 = load ptr, ptr %union_val_slot15, align 8
  store ptr %union_val16, ptr %s, align 8
  %s17 = load ptr, ptr %s, align 8
  %10 = call i32 @puts(ptr %s17)
  %widen18 = sext i32 %10 to i64
  store i64 0, ptr %union_match_result, align 8
  br label %union_match_end

union_next9:                                      ; preds = %union_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 17)
  unreachable

union_match_end32:                                ; preds = %union_arm46, %union_arm33
  %union_match_val58 = load i64, ptr %union_match_result31, align 8
  %11 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr59 = getelementptr inbounds nuw %__union, ptr %11, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr59, align 8
  %12 = call ptr @avra_rc_alloc(i64 8)
  %slot_base60 = ptrtoint ptr %12 to i64
  %slot_addr61 = add i64 %slot_base60, 0
  %slot62 = inttoptr i64 %slot_addr61 to ptr
  store i64 1, ptr %slot62, align 8
  %union_pay_ptr63 = getelementptr inbounds nuw %__union, ptr %11, i32 0, i32 1
  store ptr %12, ptr %union_pay_ptr63, align 8
  %cast64 = ptrtoint ptr %11 to i64
  %cast65 = inttoptr i64 %cast64 to ptr
  store ptr %cast65, ptr %a, align 8
  %13 = call ptr @avra_rc_alloc(i64 16)
  %union_tag_ptr66 = getelementptr inbounds nuw %__union, ptr %13, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr66, align 8
  %14 = call ptr @avra_rc_alloc(i64 8)
  %slot_base67 = ptrtoint ptr %14 to i64
  %slot_addr68 = add i64 %slot_base67, 0
  %slot69 = inttoptr i64 %slot_addr68 to ptr
  store ptr @.str.4, ptr %slot69, align 8
  %union_pay_ptr70 = getelementptr inbounds nuw %__union, ptr %13, i32 0, i32 1
  store ptr %14, ptr %union_pay_ptr70, align 8
  %cast71 = ptrtoint ptr %13 to i64
  %cast72 = inttoptr i64 %cast71 to ptr
  store ptr %cast72, ptr %b, align 8
  %a73 = load ptr, ptr %a, align 8
  %b74 = load ptr, ptr %b, align 8
  %15 = call ptr @"pair__int|string__int|string"(ptr %a73, ptr %b74)
  store ptr %15, ptr %r, align 8
  %r75 = load ptr, ptr %r, align 8
  %union_tag_ptr76 = getelementptr inbounds nuw %__union, ptr %r75, i32 0, i32 0
  %union_tag77 = load i64, ptr %union_tag_ptr76, align 8
  store i64 0, ptr %union_match_result78, align 8
  %union_tag_eq82 = icmp eq i64 %union_tag77, 193495088
  br i1 %union_tag_eq82, label %union_arm80, label %union_next81

union_arm33:                                      ; preds = %union_match_end
  %union_pay_ptr36 = getelementptr inbounds nuw %__union, ptr %v228, i32 0, i32 1
  %union_payload37 = load ptr, ptr %union_pay_ptr36, align 8
  %union_val_slot_base38 = ptrtoint ptr %union_payload37 to i64
  %union_val_slot_addr39 = add i64 %union_val_slot_base38, 0
  %union_val_slot40 = inttoptr i64 %union_val_slot_addr39 to ptr
  %union_val41 = load i64, ptr %union_val_slot40, align 8
  store i64 %union_val41, ptr %n42, align 8
  %n43 = load i64, ptr %n42, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.1, i64 %n43)
  %widen44 = sext i32 %17 to i64
  %18 = call i32 @puts(ptr %16)
  %widen45 = sext i32 %18 to i64
  store i64 0, ptr %union_match_result31, align 8
  br label %union_match_end32

union_next34:                                     ; preds = %union_match_end
  %union_tag_eq48 = icmp eq i64 %union_tag30, 6954031493116
  br i1 %union_tag_eq48, label %union_arm46, label %union_next47

union_arm46:                                      ; preds = %union_next34
  %union_pay_ptr49 = getelementptr inbounds nuw %__union, ptr %v228, i32 0, i32 1
  %union_payload50 = load ptr, ptr %union_pay_ptr49, align 8
  %union_val_slot_base51 = ptrtoint ptr %union_payload50 to i64
  %union_val_slot_addr52 = add i64 %union_val_slot_base51, 0
  %union_val_slot53 = inttoptr i64 %union_val_slot_addr52 to ptr
  %union_val54 = load ptr, ptr %union_val_slot53, align 8
  store ptr %union_val54, ptr %s55, align 8
  %s56 = load ptr, ptr %s55, align 8
  %19 = call i32 @puts(ptr %s56)
  %widen57 = sext i32 %19 to i64
  store i64 0, ptr %union_match_result31, align 8
  br label %union_match_end32

union_next47:                                     ; preds = %union_next34
  call void @avra_match_unreachable(ptr @.match_fn.2, i64 %union_tag30, ptr @mu_file.3, i64 24)
  unreachable

union_match_end79:                                ; preds = %union_arm95, %union_arm80
  %union_match_val113 = load i64, ptr %union_match_result78, align 8
  %b114 = load ptr, ptr %b, align 8
  %a115 = load ptr, ptr %a, align 8
  %20 = call ptr @"pair__int|string__int|string"(ptr %b114, ptr %a115)
  store ptr %20, ptr %r2, align 8
  %r2116 = load ptr, ptr %r2, align 8
  %union_tag_ptr117 = getelementptr inbounds nuw %__union, ptr %r2116, i32 0, i32 0
  %union_tag118 = load i64, ptr %union_tag_ptr117, align 8
  store i64 0, ptr %union_match_result119, align 8
  %union_tag_eq123 = icmp eq i64 %union_tag118, 193495088
  br i1 %union_tag_eq123, label %union_arm121, label %union_next122

union_arm80:                                      ; preds = %union_match_end32
  %union_pay_ptr83 = getelementptr inbounds nuw %__union, ptr %r75, i32 0, i32 1
  %union_payload84 = load ptr, ptr %union_pay_ptr83, align 8
  %union_val_slot_base85 = ptrtoint ptr %union_payload84 to i64
  %union_val_slot_addr86 = add i64 %union_val_slot_base85, 0
  %union_val_slot87 = inttoptr i64 %union_val_slot_addr86 to ptr
  %union_val88 = load i64, ptr %union_val_slot87, align 8
  store i64 %union_val88, ptr %n89, align 8
  %n90 = load i64, ptr %n89, align 8
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.6, i64 %n90)
  %widen91 = sext i32 %22 to i64
  %23 = call i64 @strlen(ptr @.str.5)
  %24 = call i64 @strlen(ptr %21)
  %concat_total = add i64 %23, %24
  %concat_size = add i64 %concat_total, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size)
  %26 = call ptr @memcpy(ptr %25, ptr @.str.5, i64 %23)
  %cast92 = ptrtoint ptr %25 to i64
  %dst2_int = add i64 %cast92, %23
  %cast93 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast93, ptr %21, i64 %rhs_len_p1)
  %28 = call i32 @puts(ptr %25)
  %widen94 = sext i32 %28 to i64
  store i64 0, ptr %union_match_result78, align 8
  br label %union_match_end79

union_next81:                                     ; preds = %union_match_end32
  %union_tag_eq97 = icmp eq i64 %union_tag77, 6954031493116
  br i1 %union_tag_eq97, label %union_arm95, label %union_next96

union_arm95:                                      ; preds = %union_next81
  %union_pay_ptr98 = getelementptr inbounds nuw %__union, ptr %r75, i32 0, i32 1
  %union_payload99 = load ptr, ptr %union_pay_ptr98, align 8
  %union_val_slot_base100 = ptrtoint ptr %union_payload99 to i64
  %union_val_slot_addr101 = add i64 %union_val_slot_base100, 0
  %union_val_slot102 = inttoptr i64 %union_val_slot_addr101 to ptr
  %union_val103 = load ptr, ptr %union_val_slot102, align 8
  store ptr %union_val103, ptr %s104, align 8
  %s105 = load ptr, ptr %s104, align 8
  %29 = call i64 @strlen(ptr @.str.7)
  %30 = call i64 @strlen(ptr %s105)
  %concat_total106 = add i64 %29, %30
  %concat_size107 = add i64 %concat_total106, 1
  %31 = call ptr @avra_rc_alloc(i64 %concat_size107)
  %32 = call ptr @memcpy(ptr %31, ptr @.str.7, i64 %29)
  %cast108 = ptrtoint ptr %31 to i64
  %dst2_int109 = add i64 %cast108, %29
  %cast110 = inttoptr i64 %dst2_int109 to ptr
  %rhs_len_p1111 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast110, ptr %s105, i64 %rhs_len_p1111)
  %34 = call i32 @puts(ptr %31)
  %widen112 = sext i32 %34 to i64
  store i64 0, ptr %union_match_result78, align 8
  br label %union_match_end79

union_next96:                                     ; preds = %union_next81
  call void @avra_match_unreachable(ptr @.match_fn.8, i64 %union_tag77, ptr @mu_file.9, i64 33)
  unreachable

union_match_end120:                               ; preds = %union_arm140, %union_arm121
  %union_match_val158 = load i64, ptr %union_match_result119, align 8
  ret i64 %union_match_val158

union_arm121:                                     ; preds = %union_match_end79
  %union_pay_ptr124 = getelementptr inbounds nuw %__union, ptr %r2116, i32 0, i32 1
  %union_payload125 = load ptr, ptr %union_pay_ptr124, align 8
  %union_val_slot_base126 = ptrtoint ptr %union_payload125 to i64
  %union_val_slot_addr127 = add i64 %union_val_slot_base126, 0
  %union_val_slot128 = inttoptr i64 %union_val_slot_addr127 to ptr
  %union_val129 = load i64, ptr %union_val_slot128, align 8
  store i64 %union_val129, ptr %n130, align 8
  %n131 = load i64, ptr %n130, align 8
  %35 = call ptr @avra_rc_alloc(i64 32)
  %36 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %35, i64 32, ptr @.i2s_fmt.11, i64 %n131)
  %widen132 = sext i32 %36 to i64
  %37 = call i64 @strlen(ptr @.str.10)
  %38 = call i64 @strlen(ptr %35)
  %concat_total133 = add i64 %37, %38
  %concat_size134 = add i64 %concat_total133, 1
  %39 = call ptr @avra_rc_alloc(i64 %concat_size134)
  %40 = call ptr @memcpy(ptr %39, ptr @.str.10, i64 %37)
  %cast135 = ptrtoint ptr %39 to i64
  %dst2_int136 = add i64 %cast135, %37
  %cast137 = inttoptr i64 %dst2_int136 to ptr
  %rhs_len_p1138 = add i64 %38, 1
  %41 = call ptr @memcpy(ptr %cast137, ptr %35, i64 %rhs_len_p1138)
  %42 = call i32 @puts(ptr %39)
  %widen139 = sext i32 %42 to i64
  store i64 0, ptr %union_match_result119, align 8
  br label %union_match_end120

union_next122:                                    ; preds = %union_match_end79
  %union_tag_eq142 = icmp eq i64 %union_tag118, 6954031493116
  br i1 %union_tag_eq142, label %union_arm140, label %union_next141

union_arm140:                                     ; preds = %union_next122
  %union_pay_ptr143 = getelementptr inbounds nuw %__union, ptr %r2116, i32 0, i32 1
  %union_payload144 = load ptr, ptr %union_pay_ptr143, align 8
  %union_val_slot_base145 = ptrtoint ptr %union_payload144 to i64
  %union_val_slot_addr146 = add i64 %union_val_slot_base145, 0
  %union_val_slot147 = inttoptr i64 %union_val_slot_addr146 to ptr
  %union_val148 = load ptr, ptr %union_val_slot147, align 8
  store ptr %union_val148, ptr %s149, align 8
  %s150 = load ptr, ptr %s149, align 8
  %43 = call i64 @strlen(ptr @.str.12)
  %44 = call i64 @strlen(ptr %s150)
  %concat_total151 = add i64 %43, %44
  %concat_size152 = add i64 %concat_total151, 1
  %45 = call ptr @avra_rc_alloc(i64 %concat_size152)
  %46 = call ptr @memcpy(ptr %45, ptr @.str.12, i64 %43)
  %cast153 = ptrtoint ptr %45 to i64
  %dst2_int154 = add i64 %cast153, %43
  %cast155 = inttoptr i64 %dst2_int154 to ptr
  %rhs_len_p1156 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast155, ptr %s150, i64 %rhs_len_p1156)
  %48 = call i32 @puts(ptr %45)
  %widen157 = sext i32 %48 to i64
  store i64 0, ptr %union_match_result119, align 8
  br label %union_match_end120

union_next141:                                    ; preds = %union_next122
  call void @avra_match_unreachable(ptr @.match_fn.13, i64 %union_tag118, ptr @mu_file.14, i64 38)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
