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

define i64 @total(%ForgeString %0) {
entry:
  %items = alloca %ForgeString, align 8
  store %ForgeString %0, ptr %items, align 8
  %s = alloca i64, align 8
  store i64 0, ptr %s, align 4
  %items1 = load %ForgeString, ptr %items, align 8
  %__fi = alloca i64, align 8
  store i64 0, ptr %__fi, align 4
  %ll = call i64 @forge_string_length(%ForgeString %items1)
  br label %fc

fc:                                               ; preds = %fx, %entry
  %fi = load i64, ptr %__fi, align 4
  %fc2 = icmp slt i64 %fi, %ll
  br i1 %fc2, label %fb, label %fe

fb:                                               ; preds = %fc
  %fib = load i64, ptr %__fi, align 4
  %dat = extractvalue %ForgeString %items1, 0
  %elp = getelementptr i64, ptr %dat, i64 %fib
  %elv = load i64, ptr %elp, align 4
  %itv = alloca i64, align 8
  store i64 %elv, ptr %itv, align 4
  %item = load i64, ptr %itv, align 4
  %s3 = load i64, ptr %s, align 4
  %add = add i64 %s3, 0
  %_b1 = alloca i64, align 8
  store i64 %add, ptr %_b1, align 4
  %_b14 = load i64, ptr %_b1, align 4
  store i64 %_b14, ptr %s, align 4
  %_b15 = load i64, ptr %_b1, align 4
  store i64 %_b15, ptr %s, align 4
  br label %fx

fx:                                               ; preds = %fb
  %fic = load i64, ptr %__fi, align 4
  %fin = add i64 %fic, 1
  store i64 %fin, ptr %__fi, align 4
  br label %fc

fe:                                               ; preds = %fc
  %s6 = load i64, ptr %s, align 4
  ret i64 %add
}

define i32 @main() {
entry:
  %ld = call ptr @forge_alloc(i64 0)
  %ls1 = insertvalue %ForgeString undef, ptr %ld, 0
  %ls2 = insertvalue %ForgeString %ls1, i64 0, 1
  %_l2 = alloca %ForgeString, align 8
  store %ForgeString %ls2, ptr %_l2, align 8
  %items = alloca %ForgeString, align 8
  store %ForgeString %ls2, ptr %items, align 8
  %items1 = load %ForgeString, ptr %items, align 8
  %call = call i64 @total(%ForgeString %items1)
  %i2s = call %ForgeString @forge_int_to_string(i64 %call)
  call void @forge_println_string(%ForgeString %i2s)
  ret i32 0
}
