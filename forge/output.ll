; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }
%Type = type { i8, i64, i64, i64, i64 }

@0 = constant [3 x i8] c"int"
@1 = constant [5 x i8] c"float"
@2 = constant [4 x i8] c"bool"
@3 = constant [6 x i8] c"string"
@4 = constant [4 x i8] c"void"
@5 = constant [5 x i8] c"never"
@6 = constant [3 x i8] c"ptr"
@7 = constant [7 x i8] c"unknown"
@8 = constant [5 x i8] c"error"
@9 = constant [1 x i8] c"?"

declare void @forge_println_string(%ForgeString)

declare %ForgeString @forge_int_to_string(i64)

declare %ForgeString @forge_string_new(ptr, i64)

declare %ForgeString @forge_string_concat(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_char_at(%ForgeString, i64)

declare i64 @forge_string_length(%ForgeString)

declare i8 @forge_string_eq(%ForgeString, %ForgeString)

declare i64 @forge_string_compare(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_substring(%ForgeString, i64, i64)

declare i64 @forge_string_index_of(%ForgeString, %ForgeString)

declare ptr @forge_alloc(i64)

declare void @forge_memcpy(ptr, ptr, i64)

declare ptr @forge_map_new()

declare i8 @forge_map_has(ptr, %ForgeString)

declare i64 @forge_map_get(ptr, %ForgeString)

declare void @forge_map_set(ptr, %ForgeString, i64)

declare void @forge_set_args(i32, ptr)

declare %ForgeString @forge_selfhost_process_args()

declare %ForgeString @forge_selfhost_fs_read(%ForgeString)

declare void @forge_selfhost_process_exit(i64)

declare %ForgeString @forge_selfhost_process_run(%ForgeString, %ForgeString)

declare void @forge_eprintln_string(%ForgeString)

define i64 @type_is_numeric(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  %3 = load %Type, ptr %2, align 4
  %4 = extractvalue %Type %3, 0
  %5 = zext i8 %4 to i64
  %6 = icmp eq i64 %5, 0
  br i1 %6, label %8, label %9

7:                                                ; preds = %12, %11, %8
  ret i64 undef

8:                                                ; preds = %1
  br label %7

9:                                                ; preds = %1
  %10 = icmp eq i64 %5, 1
  br i1 %10, label %11, label %12

11:                                               ; preds = %9
  br label %7

12:                                               ; preds = %9
  br label %7
}

define i64 @type_is_nullable(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  %3 = load %Type, ptr %2, align 4
  %4 = extractvalue %Type %3, 0
  %5 = zext i8 %4 to i64
  %6 = icmp eq i64 %5, 7
  br i1 %6, label %8, label %9

7:                                                ; preds = %9, %8
  ret i64 undef

8:                                                ; preds = %1
  br label %7

9:                                                ; preds = %1
  br label %7
}

define i64 @type_is_primitive(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  %3 = load %Type, ptr %2, align 4
  %4 = extractvalue %Type %3, 0
  %5 = zext i8 %4 to i64
  %6 = icmp eq i64 %5, 0
  br i1 %6, label %8, label %9

7:                                                ; preds = %21, %20, %17, %14, %11, %8
  ret i64 undef

8:                                                ; preds = %1
  br label %7

9:                                                ; preds = %1
  %10 = icmp eq i64 %5, 1
  br i1 %10, label %11, label %12

11:                                               ; preds = %9
  br label %7

12:                                               ; preds = %9
  %13 = icmp eq i64 %5, 2
  br i1 %13, label %14, label %15

14:                                               ; preds = %12
  br label %7

15:                                               ; preds = %12
  %16 = icmp eq i64 %5, 3
  br i1 %16, label %17, label %18

17:                                               ; preds = %15
  br label %7

18:                                               ; preds = %15
  %19 = icmp eq i64 %5, 4
  br i1 %19, label %20, label %21

20:                                               ; preds = %18
  br label %7

21:                                               ; preds = %18
  br label %7
}

define i64 @type_is_container(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  %3 = load %Type, ptr %2, align 4
  %4 = extractvalue %Type %3, 0
  %5 = zext i8 %4 to i64
  %6 = icmp eq i64 %5, 8
  br i1 %6, label %8, label %9

7:                                                ; preds = %15, %14, %11, %8
  ret i64 undef

8:                                                ; preds = %1
  br label %7

9:                                                ; preds = %1
  %10 = icmp eq i64 %5, 9
  br i1 %10, label %11, label %12

11:                                               ; preds = %9
  br label %7

12:                                               ; preds = %9
  %13 = icmp eq i64 %5, 10
  br i1 %13, label %14, label %15

14:                                               ; preds = %12
  br label %7

15:                                               ; preds = %12
  br label %7
}

define i64 @type_is_callable(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  %3 = load %Type, ptr %2, align 4
  %4 = extractvalue %Type %3, 0
  %5 = zext i8 %4 to i64
  %6 = icmp eq i64 %5, 13
  br i1 %6, label %8, label %9

7:                                                ; preds = %9, %8
  ret i64 undef

8:                                                ; preds = %1
  br label %7

9:                                                ; preds = %1
  br label %7
}

define %Type @unwrap_nullable(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  %3 = load %Type, ptr %2, align 4
  ret %Type %3
}

define %Type @unwrap_list_element(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  ret %Type undef
}

define %Type @unwrap_result_ok(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  ret %Type undef
}

define %Type @unwrap_result_err(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  ret %Type undef
}

define %ForgeString @type_to_string(%Type %0) {
  %2 = alloca %Type, align 8
  store %Type %0, ptr %2, align 4
  br i1 false, label %3, label %4

3:                                                ; preds = %1
  ret %ForgeString undef

4:                                                ; preds = %1
  br label %5

5:                                                ; preds = %4
  br i1 false, label %6, label %7

6:                                                ; preds = %5
  ret %ForgeString undef

7:                                                ; preds = %5
  br label %8

8:                                                ; preds = %7
  br i1 false, label %9, label %10

9:                                                ; preds = %8
  ret %ForgeString undef

10:                                               ; preds = %8
  br label %11

11:                                               ; preds = %10
  br i1 false, label %12, label %13

12:                                               ; preds = %11
  ret %ForgeString undef

13:                                               ; preds = %11
  br label %14

14:                                               ; preds = %13
  br i1 false, label %15, label %16

15:                                               ; preds = %14
  ret %ForgeString undef

16:                                               ; preds = %14
  br label %17

17:                                               ; preds = %16
  br i1 false, label %18, label %19

18:                                               ; preds = %17
  ret %ForgeString undef

19:                                               ; preds = %17
  br label %20

20:                                               ; preds = %19
  br i1 false, label %21, label %22

21:                                               ; preds = %20
  ret %ForgeString undef

22:                                               ; preds = %20
  br label %23

23:                                               ; preds = %22
  br i1 false, label %24, label %25

24:                                               ; preds = %23
  ret %ForgeString undef

25:                                               ; preds = %23
  br label %26

26:                                               ; preds = %25
  br i1 false, label %27, label %28

27:                                               ; preds = %26
  ret %ForgeString undef

28:                                               ; preds = %26
  br label %29

29:                                               ; preds = %28
  ret %ForgeString undef
}
