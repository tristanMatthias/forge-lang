; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Shape = type { i64, ptr }
%Point = type { i64, i64 }
%Shape__Circle = type { ptr, i64 }
%Shape__Line = type { ptr, ptr }

@c = global i64 0
@.str = private unnamed_addr constant [10 x i8] c"circle r=\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"line\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_struct_in_enum.av\00", align 1

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
  %e24 = alloca ptr, align 8
  %s21 = alloca ptr, align 8
  %r11 = alloca i64, align 8
  %center8 = alloca ptr, align 8
  %match_stmt_discard = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %0, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 16)
  store ptr %1, ptr %pay_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 0
  store i64 10, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 1
  store i64 20, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %2 to i64
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %slot, align 8
  %slot_base3 = ptrtoint ptr %1 to i64
  %slot_addr4 = add i64 %slot_base3, 8
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 5, ptr %slot5, align 8
  %cast6 = ptrtoint ptr %0 to i64
  store i64 %cast6, ptr @c, align 8
  %c = load ptr, ptr @c, align 8
  %tag_ptr7 = getelementptr inbounds nuw %Shape, ptr %c, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr7, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm16, %march_arm
  %3 = call i32 @avra_test_summary()
  %widen26 = sext i32 %3 to i64
  call void @avra_rc_collect()
  ret i64 0

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %c, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %center_slot_base = ptrtoint ptr %payload to i64
  %center_slot_addr = add i64 %center_slot_base, 0
  %center_slot = inttoptr i64 %center_slot_addr to ptr
  %center = load ptr, ptr %center_slot, align 8
  call void @avra_rc_retain(ptr %center)
  store ptr %center, ptr %center8, align 8
  %pay_slot9 = getelementptr inbounds nuw %Shape, ptr %c, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %r_slot_base = ptrtoint ptr %payload10 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r11, align 8
  %r12 = load i64, ptr %r11, align 8
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %r12)
  %widen = sext i32 %5 to i64
  %6 = call i64 @strlen(ptr @.str)
  %7 = call i64 @strlen(ptr %4)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr @.str, i64 %6)
  %cast13 = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast13, %6
  %cast14 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast14, ptr %4, i64 %rhs_len_p1)
  %11 = call i32 @puts(ptr %8)
  %widen15 = sext i32 %11 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq18 = icmp eq i64 %tag, 6384290189
  br i1 %tag_eq18, label %march_arm16, label %march_next17

march_arm16:                                      ; preds = %march_next
  %pay_slot19 = getelementptr inbounds nuw %Shape, ptr %c, i32 0, i32 1
  %payload20 = load ptr, ptr %pay_slot19, align 8
  %s_slot_base = ptrtoint ptr %payload20 to i64
  %s_slot_addr = add i64 %s_slot_base, 0
  %s_slot = inttoptr i64 %s_slot_addr to ptr
  %s = load ptr, ptr %s_slot, align 8
  call void @avra_rc_retain(ptr %s)
  store ptr %s, ptr %s21, align 8
  %pay_slot22 = getelementptr inbounds nuw %Shape, ptr %c, i32 0, i32 1
  %payload23 = load ptr, ptr %pay_slot22, align 8
  %e_slot_base = ptrtoint ptr %payload23 to i64
  %e_slot_addr = add i64 %e_slot_base, 8
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e)
  store ptr %e, ptr %e24, align 8
  %12 = call i32 @puts(ptr @.str.1)
  %widen25 = sext i32 %12 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next17:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable
}

define i64 @__release_Shape(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Circle = icmp eq i64 %tag, 6952139942519
  br i1 %is_Circle, label %rel_Circle, label %try_next_Circle

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Line, %vrel_end_skip, %vrel_center_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Circle:                                       ; preds = %do_free
  %vrel_center_ptr = getelementptr inbounds nuw %Shape__Circle, ptr %payload, i32 0, i32 0
  %vrel_center = load ptr, ptr %vrel_center_ptr, align 8
  %vrel_null_center = icmp eq ptr %vrel_center, null
  br i1 %vrel_null_center, label %vrel_center_skip, label %vrel_center_do

try_next_Circle:                                  ; preds = %do_free
  %is_Line = icmp eq i64 %tag, 6384290189
  br i1 %is_Line, label %rel_Line, label %try_next_Line

vrel_center_skip:                                 ; preds = %vrel_center_do, %rel_Circle
  br label %fields_done

vrel_center_do:                                   ; preds = %rel_Circle
  call void @avra_rc_release(ptr %vrel_center)
  br label %vrel_center_skip

rel_Line:                                         ; preds = %try_next_Circle
  %vrel_start_ptr = getelementptr inbounds nuw %Shape__Line, ptr %payload, i32 0, i32 0
  %vrel_start = load ptr, ptr %vrel_start_ptr, align 8
  %vrel_null_start = icmp eq ptr %vrel_start, null
  br i1 %vrel_null_start, label %vrel_start_skip, label %vrel_start_do

try_next_Line:                                    ; preds = %try_next_Circle
  br label %fields_done

vrel_start_skip:                                  ; preds = %vrel_start_do, %rel_Line
  %vrel_end_ptr = getelementptr inbounds nuw %Shape__Line, ptr %payload, i32 0, i32 1
  %vrel_end = load ptr, ptr %vrel_end_ptr, align 8
  %vrel_null_end = icmp eq ptr %vrel_end, null
  br i1 %vrel_null_end, label %vrel_end_skip, label %vrel_end_do

vrel_start_do:                                    ; preds = %rel_Line
  call void @avra_rc_release(ptr %vrel_start)
  br label %vrel_start_skip

vrel_end_skip:                                    ; preds = %vrel_end_do, %vrel_start_skip
  br label %fields_done

vrel_end_do:                                      ; preds = %vrel_start_skip
  call void @avra_rc_release(ptr %vrel_end)
  br label %vrel_end_skip
}
