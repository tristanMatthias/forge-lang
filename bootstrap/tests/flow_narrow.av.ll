; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Animal = type { i64, ptr }
%Animal__Dog = type { ptr, i64 }
%Animal__Cat = type { ptr }

@x = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"Dog: \00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c" age \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"Cat: \00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"Rex\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"Rex\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"Whiskers\00", align 1

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

define i64 @describe(ptr %0) {
entry:
  %sif_result29 = alloca i64, align 8
  %sif_result = alloca i64, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %Animal, ptr %a1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %is_eq = icmp eq i64 %tag, 193454815
  %is_eq_ext = zext i1 %is_eq to i64
  %sif_cond = icmp ne i64 %is_eq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %a2 = load ptr, ptr %a, align 8
  %narrow_pay_slot = getelementptr inbounds nuw %Animal, ptr %a2, i32 0, i32 1
  %narrow_payload = load ptr, ptr %narrow_pay_slot, align 8
  %narrow_name_slot_base = ptrtoint ptr %narrow_payload to i64
  %narrow_name_slot_addr = add i64 %narrow_name_slot_base, 0
  %narrow_name_slot = inttoptr i64 %narrow_name_slot_addr to ptr
  %narrow_name = load ptr, ptr %narrow_name_slot, align 8
  %1 = call i64 @strlen(ptr @.str)
  %2 = call i64 @strlen(ptr %narrow_name)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %narrow_name, i64 %rhs_len_p1)
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.1)
  %concat_total4 = add i64 %6, %7
  %concat_size5 = add i64 %concat_total4, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast6 = ptrtoint ptr %8 to i64
  %dst2_int7 = add i64 %cast6, %6
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast8, ptr @.str.1, i64 %rhs_len_p19)
  %a10 = load ptr, ptr %a, align 8
  %narrow_pay_slot11 = getelementptr inbounds nuw %Animal, ptr %a10, i32 0, i32 1
  %narrow_payload12 = load ptr, ptr %narrow_pay_slot11, align 8
  %narrow_age_slot_base = ptrtoint ptr %narrow_payload12 to i64
  %narrow_age_slot_addr = add i64 %narrow_age_slot_base, 8
  %narrow_age_slot = inttoptr i64 %narrow_age_slot_addr to ptr
  %narrow_age = load i64, ptr %narrow_age_slot, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt, i64 %narrow_age)
  %widen = sext i32 %12 to i64
  %13 = call i64 @strlen(ptr %8)
  %14 = call i64 @strlen(ptr %11)
  %concat_total13 = add i64 %13, %14
  %concat_size14 = add i64 %concat_total13, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %16 = call ptr @memcpy(ptr %15, ptr %8, i64 %13)
  %cast15 = ptrtoint ptr %15 to i64
  %dst2_int16 = add i64 %cast15, %13
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast17, ptr %11, i64 %rhs_len_p118)
  %18 = call i32 @puts(ptr %15)
  %widen19 = sext i32 %18 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %a20 = load ptr, ptr %a, align 8
  %tag_ptr21 = getelementptr inbounds nuw %Animal, ptr %a20, i32 0, i32 0
  %tag22 = load i64, ptr %tag_ptr21, align 8
  %is_eq23 = icmp eq i64 %tag22, 193453277
  %is_eq_ext24 = zext i1 %is_eq23 to i64
  %sif_cond25 = icmp ne i64 %is_eq_ext24, 0
  store i64 0, ptr %sif_result29, align 8
  br i1 %sif_cond25, label %sif_then26, label %sif_else27

sif_end:                                          ; preds = %sif_end28, %sif_then
  %sif_val45 = load i64, ptr %sif_result, align 8
  ret i64 %sif_val45

sif_then26:                                       ; preds = %sif_else
  %a30 = load ptr, ptr %a, align 8
  %narrow_pay_slot31 = getelementptr inbounds nuw %Animal, ptr %a30, i32 0, i32 1
  %narrow_payload32 = load ptr, ptr %narrow_pay_slot31, align 8
  %narrow_name_slot_base33 = ptrtoint ptr %narrow_payload32 to i64
  %narrow_name_slot_addr34 = add i64 %narrow_name_slot_base33, 0
  %narrow_name_slot35 = inttoptr i64 %narrow_name_slot_addr34 to ptr
  %narrow_name36 = load ptr, ptr %narrow_name_slot35, align 8
  %19 = call i64 @strlen(ptr @.str.2)
  %20 = call i64 @strlen(ptr %narrow_name36)
  %concat_total37 = add i64 %19, %20
  %concat_size38 = add i64 %concat_total37, 1
  %21 = call ptr @avra_rc_alloc(i64 %concat_size38)
  %22 = call ptr @memcpy(ptr %21, ptr @.str.2, i64 %19)
  %cast39 = ptrtoint ptr %21 to i64
  %dst2_int40 = add i64 %cast39, %19
  %cast41 = inttoptr i64 %dst2_int40 to ptr
  %rhs_len_p142 = add i64 %20, 1
  %23 = call ptr @memcpy(ptr %cast41, ptr %narrow_name36, i64 %rhs_len_p142)
  %24 = call i32 @puts(ptr %21)
  %widen43 = sext i32 %24 to i64
  store i64 0, ptr %sif_result29, align 8
  br label %sif_end28

sif_else27:                                       ; preds = %sif_else
  %25 = call i32 @puts(ptr @.str.3)
  %widen44 = sext i32 %25 to i64
  store i64 0, ptr %sif_result29, align 8
  br label %sif_end28

sif_end28:                                        ; preds = %sif_else27, %sif_then26
  %sif_val = load i64, ptr %sif_result29, align 8
  store i64 %sif_val, ptr %sif_result, align 8
  br label %sif_end
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Animal, ptr %0, i32 0, i32 0
  store i64 193454815, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Animal, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 16)
  store ptr %1, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str.4, ptr %slot, align 8
  %slot_base1 = ptrtoint ptr %1 to i64
  %slot_addr2 = add i64 %slot_base1, 8
  %slot3 = inttoptr i64 %slot_addr2 to ptr
  store i64 5, ptr %slot3, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @x, align 8
  %x = load ptr, ptr @x, align 8
  %tag_ptr4 = getelementptr inbounds nuw %Animal, ptr %x, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr4, align 8
  %is_eq = icmp eq i64 %tag, 193454815
  %is_eq_ext = zext i1 %is_eq to i64
  %if_cond = icmp ne i64 %is_eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %Animal, ptr %2, i32 0, i32 0
  store i64 193454815, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %Animal, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr7, align 8
  %slot_base8 = ptrtoint ptr %3 to i64
  %slot_addr9 = add i64 %slot_base8, 0
  %slot10 = inttoptr i64 %slot_addr9 to ptr
  store ptr @.str.5, ptr %slot10, align 8
  %slot_base11 = ptrtoint ptr %3 to i64
  %slot_addr12 = add i64 %slot_base11, 8
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store i64 3, ptr %slot13, align 8
  %cast14 = ptrtoint ptr %2 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  %4 = call i64 @describe(ptr %cast15)
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr16 = getelementptr inbounds nuw %Animal, ptr %5, i32 0, i32 0
  store i64 193453277, ptr %tag_ptr16, align 8
  %pay_ptr17 = getelementptr inbounds nuw %Animal, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr17, align 8
  %slot_base18 = ptrtoint ptr %6 to i64
  %slot_addr19 = add i64 %slot_base18, 0
  %slot20 = inttoptr i64 %slot_addr19 to ptr
  store ptr @.str.6, ptr %slot20, align 8
  %cast21 = ptrtoint ptr %5 to i64
  %cast22 = inttoptr i64 %cast21 to ptr
  %7 = call i64 @describe(ptr %cast22)
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr23 = getelementptr inbounds nuw %Animal, ptr %8, i32 0, i32 0
  store i64 6384074735, ptr %tag_ptr23, align 8
  %pay_ptr24 = getelementptr inbounds nuw %Animal, ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr24, align 8
  %cast25 = ptrtoint ptr %8 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  %9 = call i64 @describe(ptr %cast26)
  %10 = call i32 @avra_test_summary()
  %widen27 = sext i32 %10 to i64
  call void @avra_rc_collect()
  ret i64 0

if_then:                                          ; preds = %entry
  %x5 = load ptr, ptr @x, align 8
  %narrow_pay_slot = getelementptr inbounds nuw %Animal, ptr %x5, i32 0, i32 1
  %narrow_payload = load ptr, ptr %narrow_pay_slot, align 8
  %narrow_name_slot_base = ptrtoint ptr %narrow_payload to i64
  %narrow_name_slot_addr = add i64 %narrow_name_slot_base, 0
  %narrow_name_slot = inttoptr i64 %narrow_name_slot_addr to ptr
  %narrow_name = load ptr, ptr %narrow_name_slot, align 8
  %11 = call i32 @puts(ptr %narrow_name)
  %widen = sext i32 %11 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @__release_Animal(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Animal, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Animal, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Dog = icmp eq i64 %tag, 193454815
  br i1 %is_Dog, label %rel_Dog, label %try_next_Dog

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Cat, %vrel_name_skip4, %vrel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Dog:                                          ; preds = %do_free
  %vrel_name_ptr = getelementptr inbounds nuw %Animal__Dog, ptr %payload, i32 0, i32 0
  %vrel_name = load ptr, ptr %vrel_name_ptr, align 8
  %vrel_null_name = icmp eq ptr %vrel_name, null
  br i1 %vrel_null_name, label %vrel_name_skip, label %vrel_name_do

try_next_Dog:                                     ; preds = %do_free
  %is_Cat = icmp eq i64 %tag, 193453277
  br i1 %is_Cat, label %rel_Cat, label %try_next_Cat

vrel_name_skip:                                   ; preds = %vrel_name_do, %rel_Dog
  br label %fields_done

vrel_name_do:                                     ; preds = %rel_Dog
  call void @avra_rc_release(ptr %vrel_name)
  br label %vrel_name_skip

rel_Cat:                                          ; preds = %try_next_Dog
  %vrel_name_ptr1 = getelementptr inbounds nuw %Animal__Cat, ptr %payload, i32 0, i32 0
  %vrel_name2 = load ptr, ptr %vrel_name_ptr1, align 8
  %vrel_null_name3 = icmp eq ptr %vrel_name2, null
  br i1 %vrel_null_name3, label %vrel_name_skip4, label %vrel_name_do5

try_next_Cat:                                     ; preds = %try_next_Dog
  br label %fields_done

vrel_name_skip4:                                  ; preds = %vrel_name_do5, %rel_Cat
  br label %fields_done

vrel_name_do5:                                    ; preds = %rel_Cat
  call void @avra_rc_release(ptr %vrel_name2)
  br label %vrel_name_skip4
}
