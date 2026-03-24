; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }
%Color = type { i8, i64 }

@str = private unnamed_addr constant [5 x i8] c"blue\00", align 1

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
  %c1 = load %Color, ptr %c, align 4
  %mc = icmp eq %Color %c1, i64 0
  br i1 %mc, label %ma, label %mn

me:                                               ; preds = %ma5, %mn3, %ma2, %ma
  %mv = phi i64 [ 0, %ma ], [ 0, %ma2 ], [ %str, %ma5 ]
  ret i64 %mv

ma:                                               ; preds = %entry
  br label %me

mn:                                               ; preds = %entry
  %mc4 = icmp eq %Color %c1, i64 -1
  br i1 %mc4, label %ma2, label %mn3

ma2:                                              ; preds = %mn
  br label %me

mn3:                                              ; preds = %mn
  %mc6 = icmp eq %Color %c1, i64 -1
  br i1 %mc6, label %ma5, label %me

ma5:                                              ; preds = %mn3
  %str = call %ForgeString @forge_string_new(ptr @str, i64 4)
  br label %me
}

define i32 @main() {
entry:
  %call = call %ForgeString @name(i64 1)
  call void @forge_println_string(%ForgeString %call)
  ret i32 0
}
