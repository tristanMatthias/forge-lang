; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%IntList = type { i64, ptr }
%IntList__Cons = type { i64, ptr }

@list = global i64 0
@fld_name = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"IntList\00", align 1
@src_file = private unnamed_addr constant [116 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_struct_method.av\00", align 1
@.match_fn = private unnamed_addr constant [13 x i8] c"IntList__sum\00", align 1
@mu_file = private unnamed_addr constant [116 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_struct_method.av\00", align 1
@.str = private unnamed_addr constant [3 x i8] c"[]\00", align 1
@fld_name.1 = private unnamed_addr constant [10 x i8] c"to_string\00", align 1
@sty_name.2 = private unnamed_addr constant [8 x i8] c"IntList\00", align 1
@src_file.3 = private unnamed_addr constant [116 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_struct_method.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c" :: \00", align 1
@.match_fn.5 = private unnamed_addr constant [19 x i8] c"IntList__to_string\00", align 1
@mu_file.6 = private unnamed_addr constant [116 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_struct_method.av\00", align 1
@fld_name.7 = private unnamed_addr constant [10 x i8] c"to_string\00", align 1
@sty_name.8 = private unnamed_addr constant [8 x i8] c"IntList\00", align 1
@src_file.9 = private unnamed_addr constant [116 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_struct_method.av\00", align 1
@fld_name.10 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@sty_name.11 = private unnamed_addr constant [8 x i8] c"IntList\00", align 1
@src_file.12 = private unnamed_addr constant [116 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_recursive_struct_method.av\00", align 1
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

define i64 @IntList__sum(ptr %0) {
entry:
  %t8 = alloca ptr, align 8
  %h5 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %self1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465512
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6383973304
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %IntList, ptr %self1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %h_slot_base = ptrtoint ptr %payload to i64
  %h_slot_addr = add i64 %h_slot_base, 0
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h5, align 8
  %pay_slot6 = getelementptr inbounds nuw %IntList, ptr %self1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %t_slot_base = ptrtoint ptr %payload7 to i64
  %t_slot_addr = add i64 %t_slot_base, 8
  %t_slot = inttoptr i64 %t_slot_addr to ptr
  %t = load ptr, ptr %t_slot, align 8
  call void @avra_rc_retain(ptr %t)
  store ptr %t, ptr %t8, align 8
  %h9 = load i64, ptr %h5, align 8
  %t10 = load ptr, ptr %t8, align 8
  %cast = ptrtoint ptr %t10 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 115, i64 9)
  %1 = call i64 @IntList__sum(ptr %t10)
  %add = add i64 %h9, %1
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define ptr @IntList__to_string(ptr %0) {
entry:
  %rest = alloca ptr, align 8
  %t8 = alloca ptr, align 8
  %h5 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %self1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465512
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast21 = inttoptr i64 %match_val to ptr
  ret ptr %cast21

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6383973304
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %IntList, ptr %self1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %h_slot_base = ptrtoint ptr %payload to i64
  %h_slot_addr = add i64 %h_slot_base, 0
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h5, align 8
  %pay_slot6 = getelementptr inbounds nuw %IntList, ptr %self1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %t_slot_base = ptrtoint ptr %payload7 to i64
  %t_slot_addr = add i64 %t_slot_base, 8
  %t_slot = inttoptr i64 %t_slot_addr to ptr
  %t = load ptr, ptr %t_slot, align 8
  call void @avra_rc_retain(ptr %t)
  store ptr %t, ptr %t8, align 8
  %t9 = load ptr, ptr %t8, align 8
  %cast = ptrtoint ptr %t9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 9, ptr @sty_name.2, i64 7, i64 %null_ext, ptr @src_file.3, i64 115, i64 20)
  %1 = call ptr @IntList__to_string(ptr %t9)
  store ptr %1, ptr %rest, align 8
  %h10 = load i64, ptr %h5, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %h10)
  %widen = sext i32 %3 to i64
  %4 = call i64 @strlen(ptr %2)
  %5 = call i64 @strlen(ptr @.str.4)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr %2, i64 %4)
  %cast11 = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast11, %4
  %cast12 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast12, ptr @.str.4, i64 %rhs_len_p1)
  %rest13 = load ptr, ptr %rest, align 8
  %9 = call i64 @strlen(ptr %6)
  %10 = call i64 @strlen(ptr %rest13)
  %concat_total14 = add i64 %9, %10
  %concat_size15 = add i64 %concat_total14, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %12 = call ptr @memcpy(ptr %11, ptr %6, i64 %9)
  %cast16 = ptrtoint ptr %11 to i64
  %dst2_int17 = add i64 %cast16, %9
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast18, ptr %rest13, i64 %rhs_len_p119)
  %cast20 = ptrtoint ptr %11 to i64
  store i64 %cast20, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 16)
  unreachable
}

define i64 @main() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 0
  store i64 193465512, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @list, align 8
  store i64 0, ptr %i, align 8
  store i64 5, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %IntList, ptr %1, i32 0, i32 0
  store i64 6383973304, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %IntList, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 16)
  store ptr %2, ptr %pay_ptr3, align 8
  %i4 = load i64, ptr %i, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %i4, ptr %slot, align 8
  %list = load ptr, ptr @list, align 8
  %slot_base5 = ptrtoint ptr %2 to i64
  %slot_addr6 = add i64 %slot_base5, 8
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  store ptr %list, ptr %slot7, align 8
  %cast8 = ptrtoint ptr %1 to i64
  store i64 %cast8, ptr @list, align 8
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i9 = load i64, ptr %i, align 8
  %for_next = add i64 %i9, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %list10 = load ptr, ptr @list, align 8
  %cast11 = ptrtoint ptr %list10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 9, ptr @sty_name.8, i64 7, i64 %null_ext, ptr @src_file.9, i64 115, i64 34)
  %3 = call ptr @IntList__to_string(ptr %list10)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %list12 = load ptr, ptr @list, align 8
  %cast13 = ptrtoint ptr %list12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 3, ptr @sty_name.11, i64 7, i64 %null_ext15, ptr @src_file.12, i64 115, i64 35)
  %5 = call i64 @IntList__sum(ptr %list12)
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.13, i64 %5)
  %widen16 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen17 = sext i32 %8 to i64
  %9 = call i32 @avra_test_summary()
  %widen18 = sext i32 %9 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_IntList(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Cons = icmp eq i64 %tag, 6383973304
  br i1 %is_Cons, label %rel_Cons, label %try_next_Cons

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Cons, %vrel_tail_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Cons:                                         ; preds = %do_free
  %vrel_tail_ptr = getelementptr inbounds nuw %IntList__Cons, ptr %payload, i32 0, i32 1
  %vrel_tail = load ptr, ptr %vrel_tail_ptr, align 8
  %vrel_null_tail = icmp eq ptr %vrel_tail, null
  br i1 %vrel_null_tail, label %vrel_tail_skip, label %vrel_tail_do

try_next_Cons:                                    ; preds = %do_free
  br label %fields_done

vrel_tail_skip:                                   ; preds = %vrel_tail_do, %rel_Cons
  br label %fields_done

vrel_tail_do:                                     ; preds = %rel_Cons
  %2 = call i64 @__release_IntList(ptr %vrel_tail)
  br label %vrel_tail_skip
}
