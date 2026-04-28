; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%MaybeEntry = type { i64, ptr }
%Entry = type { ptr, i64 }
%MaybeEntry__Some = type { ptr }

@total = global i64 0
@fld_name = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Entry\00", align 1
@src_file = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_for_match_null.av\00", align 1
@.match_fn = private unnamed_addr constant [7 x i8] c"lookup\00", align 1
@mu_file = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_for_match_null.av\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"found\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @lookup(ptr %0) {
entry:
  %e5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %entries = alloca ptr, align 8
  store ptr %0, ptr %entries, align 8
  %entries1 = load ptr, ptr %entries, align 8
  %tag_ptr = getelementptr inbounds nuw %MaybeEntry, ptr %entries1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384368597
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  store i64 -1, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384548249
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %MaybeEntry, ptr %entries1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %e_slot_base = ptrtoint ptr %payload to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e)
  store ptr %e, ptr %e5, align 8
  %e6 = load ptr, ptr %e5, align 8
  %cast = ptrtoint ptr %e6 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 106, i64 10)
  %value_ptr = getelementptr inbounds nuw %Entry, ptr %e6, i32 0, i32 1
  %value = load i64, ptr %value_ptr, align 8
  store i64 %value, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 10)
  unreachable
}

define i64 @main() {
entry:
  %val = alloca i64, align 8
  %entry13 = alloca ptr, align 8
  %ife_result = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  store i64 0, ptr @total, align 8
  store i64 0, ptr %i, align 8
  store i64 5, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %i2 = load i64, ptr %i, align 8
  %eq = icmp eq i64 %i2, 2
  %eq_ext = zext i1 %eq to i64
  %l_bool = icmp ne i64 %eq_ext, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

for.incr:                                         ; preds = %ifcont
  %i19 = load i64, ptr %i, align 8
  %for_next = add i64 %i19, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %total20 = load i64, ptr @total, align 8
  %0 = call ptr @avra_rc_alloc(i64 32)
  %1 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %0, i64 32, ptr @.i2s_fmt, i64 %total20)
  %widen = sext i32 %1 to i64
  %2 = call i32 @puts(ptr %0)
  %widen21 = sext i32 %2 to i64
  %3 = call i32 @avra_test_summary()
  %widen22 = sext i32 %3 to i64
  call void @avra_rc_collect()
  ret i64 0

sc_rhs:                                           ; preds = %for.body
  %i3 = load i64, ptr %i, align 8
  %eq4 = icmp eq i64 %i3, 4
  %eq_ext5 = zext i1 %eq4 to i64
  %r_bool = icmp ne i64 %eq_ext5, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %for.body
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ true, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %ife_cond = icmp ne i64 %sc_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %cast14 = inttoptr i64 %ife_val to ptr
  store ptr %cast14, ptr %entry13, align 8
  %entry15 = load ptr, ptr %entry13, align 8
  %4 = call i64 @lookup(ptr %entry15)
  store i64 %4, ptr %val, align 8
  %val16 = load i64, ptr %val, align 8
  %sgt = icmp sgt i64 %val16, 0
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ife_then:                                         ; preds = %sc_merge
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %MaybeEntry, ptr %5, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %MaybeEntry, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Entry, ptr %7, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %i6 = load i64, ptr %i, align 8
  %add = add i64 %i6, 1
  %mul = mul i64 %add, 10
  %fld_ptr7 = getelementptr inbounds nuw %Entry, ptr %7, i32 0, i32 1
  store i64 %mul, ptr %fld_ptr7, align 8
  %cast = ptrtoint ptr %7 to i64
  %slot_base = ptrtoint ptr %6 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast8 = inttoptr i64 %cast to ptr
  store ptr %cast8, ptr %slot, align 8
  %cast9 = ptrtoint ptr %5 to i64
  store i64 %cast9, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %sc_merge
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %MaybeEntry, ptr %8, i32 0, i32 0
  store i64 6384368597, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %MaybeEntry, ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr11, align 8
  %cast12 = ptrtoint ptr %8 to i64
  store i64 %cast12, ptr %ife_result, align 8
  br label %ife_end

ifcont:                                           ; preds = %if_else, %if_then
  br label %for.incr

if_then:                                          ; preds = %ife_end
  %total = load i64, ptr @total, align 8
  %val17 = load i64, ptr %val, align 8
  %add18 = add i64 %total, %val17
  store i64 %add18, ptr @total, align 8
  br label %ifcont

if_else:                                          ; preds = %ife_end
  br label %ifcont
}

define i64 @__release_Entry(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_key_ptr = getelementptr inbounds nuw %Entry, ptr %0, i32 0, i32 0
  %rel_key = load ptr, ptr %rel_key_ptr, align 8
  %is_null_key = icmp eq ptr %rel_key, null
  br i1 %is_null_key, label %rel_key_skip, label %rel_key_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_key_skip
  ret i64 0

rel_key_skip:                                     ; preds = %rel_key_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_key_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_key)
  br label %rel_key_skip
}

define i64 @__release_MaybeEntry(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %MaybeEntry, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %MaybeEntry, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Some = icmp eq i64 %tag, 6384548249
  br i1 %is_Some, label %rel_Some, label %try_next_Some

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Some, %vrel_entry_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Some:                                         ; preds = %do_free
  %vrel_entry_ptr = getelementptr inbounds nuw %MaybeEntry__Some, ptr %payload, i32 0, i32 0
  %vrel_entry = load ptr, ptr %vrel_entry_ptr, align 8
  %vrel_null_entry = icmp eq ptr %vrel_entry, null
  br i1 %vrel_null_entry, label %vrel_entry_skip, label %vrel_entry_do

try_next_Some:                                    ; preds = %do_free
  br label %fields_done

vrel_entry_skip:                                  ; preds = %vrel_entry_do, %rel_Some
  br label %fields_done

vrel_entry_do:                                    ; preds = %rel_Some
  %2 = call i64 @__release_Entry(ptr %vrel_entry)
  br label %vrel_entry_skip
}
