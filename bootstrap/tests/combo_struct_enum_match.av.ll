; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%User = type { ptr, i64 }
%Role = type { i64, ptr }

@u = global i64 0
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_struct_enum_match.av\00", align 1
@.str = private unnamed_addr constant [7 x i8] c" (age \00", align 1
@fld_name.1 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.2 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.3 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_struct_enum_match.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c")\00", align 1
@fld_name.5 = private unnamed_addr constant [6 x i8] c"greet\00", align 1
@sty_name.6 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.7 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_struct_enum_match.av\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"admin\00", align 1
@.str.9 = private unnamed_addr constant [14 x i8] c"editor level \00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c"viewer\00", align 1
@.match_fn = private unnamed_addr constant [14 x i8] c"describe_role\00", align 1
@mu_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_struct_enum_match.av\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c" is \00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1

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

define ptr @User__greet(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 109, i64 12)
  %name_ptr = getelementptr inbounds nuw %User, ptr %self1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr %name)
  %2 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %name, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr @.str, i64 %rhs_len_p1)
  %self4 = load ptr, ptr %self, align 8
  %cast5 = ptrtoint ptr %self4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 3, ptr @sty_name.2, i64 4, i64 %null_ext7, ptr @src_file.3, i64 109, i64 12)
  %age_ptr = getelementptr inbounds nuw %User, ptr %self4, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %age)
  %widen = sext i32 %7 to i64
  %8 = call i64 @strlen(ptr %3)
  %9 = call i64 @strlen(ptr %6)
  %concat_total8 = add i64 %8, %9
  %concat_size9 = add i64 %concat_total8, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %11 = call ptr @memcpy(ptr %10, ptr %3, i64 %8)
  %cast10 = ptrtoint ptr %10 to i64
  %dst2_int11 = add i64 %cast10, %8
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast12, ptr %6, i64 %rhs_len_p113)
  %13 = call i64 @strlen(ptr %10)
  %14 = call i64 @strlen(ptr @.str.4)
  %concat_total14 = add i64 %13, %14
  %concat_size15 = add i64 %concat_total14, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %16 = call ptr @memcpy(ptr %15, ptr %10, i64 %13)
  %cast16 = ptrtoint ptr %15 to i64
  %dst2_int17 = add i64 %cast16, %13
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast18, ptr @.str.4, i64 %rhs_len_p119)
  ret ptr %15
}

define ptr @describe_role(ptr %0, ptr %1) {
entry:
  %role_str = alloca ptr, align 8
  %lvl6 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %base = alloca ptr, align 8
  %role = alloca ptr, align 8
  %user = alloca ptr, align 8
  store ptr %0, ptr %user, align 8
  store ptr %1, ptr %role, align 8
  %user1 = load ptr, ptr %user, align 8
  %cast = ptrtoint ptr %user1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 5, ptr @sty_name.6, i64 4, i64 %null_ext, ptr @src_file.7, i64 109, i64 17)
  %2 = call ptr @User__greet(ptr %user1)
  store ptr %2, ptr %base, align 8
  %role2 = load ptr, ptr %role, align 8
  %tag_ptr = getelementptr inbounds nuw %Role, ptr %role2, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210668350574
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm11, %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast14 = inttoptr i64 %match_val to ptr
  store ptr %cast14, ptr %role_str, align 8
  %base15 = load ptr, ptr %base, align 8
  %3 = call i64 @strlen(ptr %base15)
  %4 = call i64 @strlen(ptr @.str.12)
  %concat_total16 = add i64 %3, %4
  %concat_size17 = add i64 %concat_total16, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %6 = call ptr @memcpy(ptr %5, ptr %base15, i64 %3)
  %cast18 = ptrtoint ptr %5 to i64
  %dst2_int19 = add i64 %cast18, %3
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast20, ptr @.str.12, i64 %rhs_len_p121)
  %role_str22 = load ptr, ptr %role_str, align 8
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr %role_str22)
  %concat_total23 = add i64 %8, %9
  %concat_size24 = add i64 %concat_total23, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size24)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast25 = ptrtoint ptr %10 to i64
  %dst2_int26 = add i64 %cast25, %8
  %cast27 = inttoptr i64 %dst2_int26 to ptr
  %rhs_len_p128 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast27, ptr %role_str22, i64 %rhs_len_p128)
  ret ptr %10

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6952211978892
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %Role, ptr %role2, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %lvl_slot_base = ptrtoint ptr %payload to i64
  %lvl_slot_addr = add i64 %lvl_slot_base, 0
  %lvl_slot = inttoptr i64 %lvl_slot_addr to ptr
  %lvl = load i64, ptr %lvl_slot, align 8
  store i64 %lvl, ptr %lvl6, align 8
  %lvl7 = load i64, ptr %lvl6, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.10, i64 %lvl7)
  %widen = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.9)
  %16 = call i64 @strlen(ptr %13)
  %concat_total = add i64 %15, %16
  %concat_size = add i64 %concat_total, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.9, i64 %15)
  %cast8 = ptrtoint ptr %17 to i64
  %dst2_int = add i64 %cast8, %15
  %cast9 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast9, ptr %13, i64 %rhs_len_p1)
  %cast10 = ptrtoint ptr %17 to i64
  store i64 %cast10, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  %tag_eq13 = icmp eq i64 %tag, 6952883069367
  br i1 %tag_eq13, label %march_arm11, label %march_next12

march_arm11:                                      ; preds = %march_next4
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %match_result, align 8
  br label %match_end

march_next12:                                     ; preds = %march_next4
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 18)
  unreachable
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %User, ptr %0, i32 0, i32 0
  store ptr @.str.13, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %User, ptr %0, i32 0, i32 1
  store i64 30, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @u, align 8
  %u = load ptr, ptr @u, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Role, ptr %1, i32 0, i32 0
  store i64 210668350574, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Role, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast2 = ptrtoint ptr %1 to i64
  %cast3 = inttoptr i64 %cast2 to ptr
  %2 = call ptr @describe_role(ptr %u, ptr %cast3)
  %3 = call i32 @puts(ptr %2)
  %widen = sext i32 %3 to i64
  %u4 = load ptr, ptr @u, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr5 = getelementptr inbounds nuw %Role, ptr %4, i32 0, i32 0
  store i64 6952211978892, ptr %tag_ptr5, align 8
  %pay_ptr6 = getelementptr inbounds nuw %Role, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr6, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 3, ptr %slot, align 8
  %cast7 = ptrtoint ptr %4 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %6 = call ptr @describe_role(ptr %u4, ptr %cast8)
  %7 = call i32 @puts(ptr %6)
  %widen9 = sext i32 %7 to i64
  %u10 = load ptr, ptr @u, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %Role, ptr %8, i32 0, i32 0
  store i64 6952883069367, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %Role, ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr12, align 8
  %cast13 = ptrtoint ptr %8 to i64
  %cast14 = inttoptr i64 %cast13 to ptr
  %9 = call ptr @describe_role(ptr %u10, ptr %cast14)
  %10 = call i32 @puts(ptr %9)
  %widen15 = sext i32 %10 to i64
  %11 = call i32 @avra_test_summary()
  %widen16 = sext i32 %11 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_User(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %User, ptr %0, i32 0, i32 0
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
