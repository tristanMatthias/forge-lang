; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }

@str = private unnamed_addr constant [4 x i8] c"red\00", align 1
@str.1 = private unnamed_addr constant [6 x i8] c"green\00", align 1
@str.2 = private unnamed_addr constant [5 x i8] c"blue\00", align 1

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

define %ForgeString @name(i64 %0) {
entry:
  %c = alloca i64, align 8
  store i64 %0, ptr %c, align 4
  %c1 = load i64, ptr %c, align 4
  %mc = icmp eq i64 %c1, 0
  br i1 %mc, label %ma, label %mn

me:                                               ; preds = %mn7, %ma6, %ma2, %ma
  %mv = phi %ForgeString [ %str, %ma ], [ %str5, %ma2 ], [ %str9, %ma6 ], [ zeroinitializer, %mn7 ]
  ret %ForgeString %mv

ma:                                               ; preds = %entry
  %str = call %ForgeString @forge_string_new(ptr @str, i64 3)
  br label %me

mn:                                               ; preds = %entry
  %mc4 = icmp eq i64 %c1, 1
  br i1 %mc4, label %ma2, label %mn3

ma2:                                              ; preds = %mn
  %str5 = call %ForgeString @forge_string_new(ptr @str.1, i64 5)
  br label %me

mn3:                                              ; preds = %mn
  %mc8 = icmp eq i64 %c1, 2
  br i1 %mc8, label %ma6, label %mn7

ma6:                                              ; preds = %mn3
  %str9 = call %ForgeString @forge_string_new(ptr @str.2, i64 4)
  br label %me

mn7:                                              ; preds = %mn3
  br label %me
}

define i32 @main() {
entry:
  %_p1 = alloca i64, align 8
  store i64 1, ptr %_p1, align 4
  %_p11 = load i64, ptr %_p1, align 4
  %call = call %ForgeString @name(i64 %_p11)
  call void @forge_println_string(%ForgeString %call)
  ret i32 0
}
