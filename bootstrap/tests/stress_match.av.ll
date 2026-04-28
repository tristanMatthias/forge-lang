; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Expr = type { i64, ptr }
%Expr__Add = type { ptr, ptr }
%Expr__Mul = type { ptr, ptr }

@expr = global i64 0
@deep = global i64 0
@label = global i64 0
@.match_fn = private unnamed_addr constant [5 x i8] c"eval\00", align 1
@mu_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_match.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"number\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"addition\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"multiplication\00", align 1
@.match_fn.4 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.5 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_match.av\00", align 1

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

define i64 @eval(ptr %0) {
entry:
  %r31 = alloca ptr, align 8
  %l24 = alloca ptr, align 8
  %r12 = alloca ptr, align 8
  %l9 = alloca ptr, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e = alloca ptr, align 8
  store ptr %0, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm15, %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %n3 = load i64, ptr %n2, align 8
  store i64 %n3, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %l_slot_base = ptrtoint ptr %payload8 to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @avra_rc_retain(ptr %l)
  store ptr %l, ptr %l9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %r_slot_base = ptrtoint ptr %payload11 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @avra_rc_retain(ptr %r)
  store ptr %r, ptr %r12, align 8
  %l13 = load ptr, ptr %l9, align 8
  %1 = call i64 @eval(ptr %l13)
  %r14 = load ptr, ptr %r12, align 8
  %2 = call i64 @eval(ptr %r14)
  %add = add i64 %1, %2
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  %tag_eq17 = icmp eq i64 %tag, 193464819
  br i1 %tag_eq17, label %march_arm15, label %march_next16

march_arm15:                                      ; preds = %march_next5
  %pay_slot18 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload19 = load ptr, ptr %pay_slot18, align 8
  %l_slot_base20 = ptrtoint ptr %payload19 to i64
  %l_slot_addr21 = add i64 %l_slot_base20, 0
  %l_slot22 = inttoptr i64 %l_slot_addr21 to ptr
  %l23 = load ptr, ptr %l_slot22, align 8
  call void @avra_rc_retain(ptr %l23)
  store ptr %l23, ptr %l24, align 8
  %pay_slot25 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload26 = load ptr, ptr %pay_slot25, align 8
  %r_slot_base27 = ptrtoint ptr %payload26 to i64
  %r_slot_addr28 = add i64 %r_slot_base27, 8
  %r_slot29 = inttoptr i64 %r_slot_addr28 to ptr
  %r30 = load ptr, ptr %r_slot29, align 8
  call void @avra_rc_retain(ptr %r30)
  store ptr %r30, ptr %r31, align 8
  %l32 = load ptr, ptr %l24, align 8
  %3 = call i64 @eval(ptr %l32)
  %r33 = load ptr, ptr %r31, align 8
  %4 = call i64 @eval(ptr %r33)
  %mul = mul i64 %3, %4
  store i64 %mul, ptr %match_result, align 8
  br label %match_end

march_next16:                                     ; preds = %march_next5
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define i64 @main() {
entry:
  %match_result = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 0
  store i64 193464819, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 16)
  store ptr %1, ptr %pay_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Expr, ptr %2, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Expr, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr2, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Expr, ptr %4, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Expr, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr4, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 2, ptr %slot, align 8
  %cast = ptrtoint ptr %4 to i64
  %slot_base5 = ptrtoint ptr %3 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  %cast8 = inttoptr i64 %cast to ptr
  store ptr %cast8, ptr %slot7, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr9 = getelementptr inbounds nuw %Expr, ptr %6, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr9, align 8
  %pay_ptr10 = getelementptr inbounds nuw %Expr, ptr %6, i32 0, i32 1
  %7 = call ptr @avra_rc_alloc(i64 8)
  store ptr %7, ptr %pay_ptr10, align 8
  %slot_base11 = ptrtoint ptr %7 to i64
  %slot_addr12 = add i64 %slot_base11, 0
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store i64 3, ptr %slot13, align 8
  %cast14 = ptrtoint ptr %6 to i64
  %slot_base15 = ptrtoint ptr %3 to i64
  %slot_addr16 = add i64 %slot_base15, 8
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  %cast18 = inttoptr i64 %cast14 to ptr
  store ptr %cast18, ptr %slot17, align 8
  %cast19 = ptrtoint ptr %2 to i64
  %slot_base20 = ptrtoint ptr %1 to i64
  %slot_addr21 = add i64 %slot_base20, 0
  %slot22 = inttoptr i64 %slot_addr21 to ptr
  %cast23 = inttoptr i64 %cast19 to ptr
  store ptr %cast23, ptr %slot22, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr24 = getelementptr inbounds nuw %Expr, ptr %8, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr24, align 8
  %pay_ptr25 = getelementptr inbounds nuw %Expr, ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 8)
  store ptr %9, ptr %pay_ptr25, align 8
  %slot_base26 = ptrtoint ptr %9 to i64
  %slot_addr27 = add i64 %slot_base26, 0
  %slot28 = inttoptr i64 %slot_addr27 to ptr
  store i64 4, ptr %slot28, align 8
  %cast29 = ptrtoint ptr %8 to i64
  %slot_base30 = ptrtoint ptr %1 to i64
  %slot_addr31 = add i64 %slot_base30, 8
  %slot32 = inttoptr i64 %slot_addr31 to ptr
  %cast33 = inttoptr i64 %cast29 to ptr
  store ptr %cast33, ptr %slot32, align 8
  %cast34 = ptrtoint ptr %0 to i64
  store i64 %cast34, ptr @expr, align 8
  %expr = load ptr, ptr @expr, align 8
  %10 = call i64 @eval(ptr %expr)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt, i64 %10)
  %widen = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen35 = sext i32 %13 to i64
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %Expr, ptr %14, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %Expr, ptr %14, i32 0, i32 1
  %15 = call ptr @avra_rc_alloc(i64 16)
  store ptr %15, ptr %pay_ptr37, align 8
  %16 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %Expr, ptr %16, i32 0, i32 0
  store i64 193464819, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %Expr, ptr %16, i32 0, i32 1
  %17 = call ptr @avra_rc_alloc(i64 16)
  store ptr %17, ptr %pay_ptr39, align 8
  %18 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr40 = getelementptr inbounds nuw %Expr, ptr %18, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr40, align 8
  %pay_ptr41 = getelementptr inbounds nuw %Expr, ptr %18, i32 0, i32 1
  %19 = call ptr @avra_rc_alloc(i64 8)
  store ptr %19, ptr %pay_ptr41, align 8
  %slot_base42 = ptrtoint ptr %19 to i64
  %slot_addr43 = add i64 %slot_base42, 0
  %slot44 = inttoptr i64 %slot_addr43 to ptr
  store i64 10, ptr %slot44, align 8
  %cast45 = ptrtoint ptr %18 to i64
  %slot_base46 = ptrtoint ptr %17 to i64
  %slot_addr47 = add i64 %slot_base46, 0
  %slot48 = inttoptr i64 %slot_addr47 to ptr
  %cast49 = inttoptr i64 %cast45 to ptr
  store ptr %cast49, ptr %slot48, align 8
  %20 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr50 = getelementptr inbounds nuw %Expr, ptr %20, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr50, align 8
  %pay_ptr51 = getelementptr inbounds nuw %Expr, ptr %20, i32 0, i32 1
  %21 = call ptr @avra_rc_alloc(i64 8)
  store ptr %21, ptr %pay_ptr51, align 8
  %slot_base52 = ptrtoint ptr %21 to i64
  %slot_addr53 = add i64 %slot_base52, 0
  %slot54 = inttoptr i64 %slot_addr53 to ptr
  store i64 20, ptr %slot54, align 8
  %cast55 = ptrtoint ptr %20 to i64
  %slot_base56 = ptrtoint ptr %17 to i64
  %slot_addr57 = add i64 %slot_base56, 8
  %slot58 = inttoptr i64 %slot_addr57 to ptr
  %cast59 = inttoptr i64 %cast55 to ptr
  store ptr %cast59, ptr %slot58, align 8
  %cast60 = ptrtoint ptr %16 to i64
  %slot_base61 = ptrtoint ptr %15 to i64
  %slot_addr62 = add i64 %slot_base61, 0
  %slot63 = inttoptr i64 %slot_addr62 to ptr
  %cast64 = inttoptr i64 %cast60 to ptr
  store ptr %cast64, ptr %slot63, align 8
  %22 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr65 = getelementptr inbounds nuw %Expr, ptr %22, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr65, align 8
  %pay_ptr66 = getelementptr inbounds nuw %Expr, ptr %22, i32 0, i32 1
  %23 = call ptr @avra_rc_alloc(i64 16)
  store ptr %23, ptr %pay_ptr66, align 8
  %24 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr67 = getelementptr inbounds nuw %Expr, ptr %24, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr67, align 8
  %pay_ptr68 = getelementptr inbounds nuw %Expr, ptr %24, i32 0, i32 1
  %25 = call ptr @avra_rc_alloc(i64 8)
  store ptr %25, ptr %pay_ptr68, align 8
  %slot_base69 = ptrtoint ptr %25 to i64
  %slot_addr70 = add i64 %slot_base69, 0
  %slot71 = inttoptr i64 %slot_addr70 to ptr
  store i64 3, ptr %slot71, align 8
  %cast72 = ptrtoint ptr %24 to i64
  %slot_base73 = ptrtoint ptr %23 to i64
  %slot_addr74 = add i64 %slot_base73, 0
  %slot75 = inttoptr i64 %slot_addr74 to ptr
  %cast76 = inttoptr i64 %cast72 to ptr
  store ptr %cast76, ptr %slot75, align 8
  %26 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr77 = getelementptr inbounds nuw %Expr, ptr %26, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr77, align 8
  %pay_ptr78 = getelementptr inbounds nuw %Expr, ptr %26, i32 0, i32 1
  %27 = call ptr @avra_rc_alloc(i64 8)
  store ptr %27, ptr %pay_ptr78, align 8
  %slot_base79 = ptrtoint ptr %27 to i64
  %slot_addr80 = add i64 %slot_base79, 0
  %slot81 = inttoptr i64 %slot_addr80 to ptr
  store i64 4, ptr %slot81, align 8
  %cast82 = ptrtoint ptr %26 to i64
  %slot_base83 = ptrtoint ptr %23 to i64
  %slot_addr84 = add i64 %slot_base83, 8
  %slot85 = inttoptr i64 %slot_addr84 to ptr
  %cast86 = inttoptr i64 %cast82 to ptr
  store ptr %cast86, ptr %slot85, align 8
  %cast87 = ptrtoint ptr %22 to i64
  %slot_base88 = ptrtoint ptr %15 to i64
  %slot_addr89 = add i64 %slot_base88, 8
  %slot90 = inttoptr i64 %slot_addr89 to ptr
  %cast91 = inttoptr i64 %cast87 to ptr
  store ptr %cast91, ptr %slot90, align 8
  %cast92 = ptrtoint ptr %14 to i64
  store i64 %cast92, ptr @deep, align 8
  %deep = load ptr, ptr @deep, align 8
  %28 = call i64 @eval(ptr %deep)
  %29 = call ptr @avra_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.1, i64 %28)
  %widen93 = sext i32 %30 to i64
  %31 = call i32 @puts(ptr %29)
  %widen94 = sext i32 %31 to i64
  %expr95 = load ptr, ptr @expr, align 8
  %tag_ptr96 = getelementptr inbounds nuw %Expr, ptr %expr95, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr96, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm100, %march_arm97, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  store i64 %match_val, ptr @label, align 8
  %label = load ptr, ptr @label, align 8
  %32 = call i32 @puts(ptr %label)
  %widen103 = sext i32 %32 to i64
  %33 = call i32 @avra_test_summary()
  %widen104 = sext i32 %33 to i64
  call void @avra_rc_collect()
  ret i64 0

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq99 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq99, label %march_arm97, label %march_next98

march_arm97:                                      ; preds = %march_next
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next98:                                     ; preds = %march_next
  %tag_eq102 = icmp eq i64 %tag, 193464819
  br i1 %tag_eq102, label %march_arm100, label %march_next101

march_arm100:                                     ; preds = %march_next98
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result, align 8
  br label %match_end

march_next101:                                    ; preds = %march_next98
  call void @avra_match_unreachable(ptr @.match_fn.4, i64 %tag, ptr @mu_file.5, i64 31)
  unreachable
}

define i64 @__release_Expr(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Add = icmp eq i64 %tag, 193451182
  br i1 %is_Add, label %rel_Add, label %try_next_Add

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Mul, %vrel_right_skip9, %vrel_right_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Add:                                          ; preds = %do_free
  %vrel_left_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 0
  %vrel_left = load ptr, ptr %vrel_left_ptr, align 8
  %vrel_null_left = icmp eq ptr %vrel_left, null
  br i1 %vrel_null_left, label %vrel_left_skip, label %vrel_left_do

try_next_Add:                                     ; preds = %do_free
  %is_Mul = icmp eq i64 %tag, 193464819
  br i1 %is_Mul, label %rel_Mul, label %try_next_Mul

vrel_left_skip:                                   ; preds = %vrel_left_do, %rel_Add
  %vrel_right_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 1
  %vrel_right = load ptr, ptr %vrel_right_ptr, align 8
  %vrel_null_right = icmp eq ptr %vrel_right, null
  br i1 %vrel_null_right, label %vrel_right_skip, label %vrel_right_do

vrel_left_do:                                     ; preds = %rel_Add
  %2 = call i64 @__release_Expr(ptr %vrel_left)
  br label %vrel_left_skip

vrel_right_skip:                                  ; preds = %vrel_right_do, %vrel_left_skip
  br label %fields_done

vrel_right_do:                                    ; preds = %vrel_left_skip
  %3 = call i64 @__release_Expr(ptr %vrel_right)
  br label %vrel_right_skip

rel_Mul:                                          ; preds = %try_next_Add
  %vrel_left_ptr1 = getelementptr inbounds nuw %Expr__Mul, ptr %payload, i32 0, i32 0
  %vrel_left2 = load ptr, ptr %vrel_left_ptr1, align 8
  %vrel_null_left3 = icmp eq ptr %vrel_left2, null
  br i1 %vrel_null_left3, label %vrel_left_skip4, label %vrel_left_do5

try_next_Mul:                                     ; preds = %try_next_Add
  br label %fields_done

vrel_left_skip4:                                  ; preds = %vrel_left_do5, %rel_Mul
  %vrel_right_ptr6 = getelementptr inbounds nuw %Expr__Mul, ptr %payload, i32 0, i32 1
  %vrel_right7 = load ptr, ptr %vrel_right_ptr6, align 8
  %vrel_null_right8 = icmp eq ptr %vrel_right7, null
  br i1 %vrel_null_right8, label %vrel_right_skip9, label %vrel_right_do10

vrel_left_do5:                                    ; preds = %rel_Mul
  %4 = call i64 @__release_Expr(ptr %vrel_left2)
  br label %vrel_left_skip4

vrel_right_skip9:                                 ; preds = %vrel_right_do10, %vrel_left_skip4
  br label %fields_done

vrel_right_do10:                                  ; preds = %vrel_left_skip4
  %5 = call i64 @__release_Expr(ptr %vrel_right7)
  br label %vrel_right_skip9
}
