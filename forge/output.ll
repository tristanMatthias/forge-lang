; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }

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

define i64 @fib(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %le = icmp sle i64 %n1, 1
  br i1 %le, label %th, label %el

th:                                               ; preds = %entry
  %n2 = load i64, ptr %n, align 4
  ret i64 %n2

el:                                               ; preds = %entry
  br label %mg

mg:                                               ; preds = %el
  %n3 = load i64, ptr %n, align 4
  %sub = sub i64 %n3, 1
  %call = call i64 @fib(i64 %sub)
  %n4 = load i64, ptr %n, align 4
  %sub5 = sub i64 %n4, 2
  %call6 = call i64 @fib(i64 %sub5)
  %add = add i64 %call, %call6
  ret i64 %add
}

define i32 @main() {
entry:
  %call = call i64 @fib(i64 10)
  %i2s = call %ForgeString @forge_int_to_string(i64 %call)
  call void @forge_println_string(%ForgeString %i2s)
  ret i32 0
}
