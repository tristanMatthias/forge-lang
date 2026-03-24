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

define i32 @main() {
entry:
  %sum = alloca i64, align 8
  store i64 0, ptr %sum, align 4
  %i = alloca i64, align 8
  store i64 1, ptr %i, align 4
  br label %wc

wc:                                               ; preds = %wb, %entry
  %i1 = load i64, ptr %i, align 4
  %le = icmp sle i64 %i1, 10
  %cx = zext i1 %le to i64
  %_b1 = alloca i64, align 8
  store i64 %cx, ptr %_b1, align 4
  %_b12 = load i64, ptr %_b1, align 4
  %wcc = trunc i64 %_b12 to i1
  br i1 %wcc, label %wb, label %we

wb:                                               ; preds = %wc
  %sum3 = load i64, ptr %sum, align 4
  %i4 = load i64, ptr %i, align 4
  %add = add i64 %sum3, %i4
  %_b2 = alloca i64, align 8
  store i64 %add, ptr %_b2, align 4
  %_b25 = load i64, ptr %_b2, align 4
  store i64 %_b25, ptr %sum, align 4
  %i6 = load i64, ptr %i, align 4
  %add7 = add i64 %i6, 1
  %_b3 = alloca i64, align 8
  store i64 %add7, ptr %_b3, align 4
  %_b38 = load i64, ptr %_b3, align 4
  store i64 %_b38, ptr %i, align 4
  %_b29 = load i64, ptr %_b2, align 4
  store i64 %_b29, ptr %sum, align 4
  %_b310 = load i64, ptr %_b3, align 4
  store i64 %_b310, ptr %i, align 4
  br label %wc

we:                                               ; preds = %wc
  %ld = call ptr @forge_alloc(i64 24)
  %ep = getelementptr i64, ptr %ld, i64 0
  store i64 10, ptr %ep, align 4
  %ep11 = getelementptr i64, ptr %ld, i64 1
  store i64 20, ptr %ep11, align 4
  %ep12 = getelementptr i64, ptr %ld, i64 2
  store i64 30, ptr %ep12, align 4
  %ls1 = insertvalue %ForgeString undef, ptr %ld, 0
  %ls2 = insertvalue %ForgeString %ls1, i64 3, 1
  %_l4 = alloca %ForgeString, align 8
  store %ForgeString %ls2, ptr %_l4, align 8
  %nums = alloca %ForgeString, align 8
  store %ForgeString %ls2, ptr %nums, align 8
  %total = alloca i64, align 8
  store i64 0, ptr %total, align 4
  %nums13 = load %ForgeString, ptr %nums, align 8
  %__fi = alloca i64, align 8
  store i64 0, ptr %__fi, align 4
  %ll = call i64 @forge_string_length(%ForgeString %nums13)
  br label %fc

fc:                                               ; preds = %fx, %we
  %fi = load i64, ptr %__fi, align 4
  %fc14 = icmp slt i64 %fi, %ll
  br i1 %fc14, label %fb, label %fe

fb:                                               ; preds = %fc
  %fib = load i64, ptr %__fi, align 4
  %dat = extractvalue %ForgeString %nums13, 0
  %elp = getelementptr i64, ptr %dat, i64 %fib
  %elv = load i64, ptr %elp, align 4
  %itv = alloca i64, align 8
  store i64 %elv, ptr %itv, align 4
  %total15 = load i64, ptr %total, align 4
  %x = load i64, ptr %itv, align 4
  %add16 = add i64 %total15, %x
  %_b5 = alloca i64, align 8
  store i64 %add16, ptr %_b5, align 4
  %_b517 = load i64, ptr %_b5, align 4
  store i64 %_b517, ptr %total, align 4
  %_b518 = load i64, ptr %_b5, align 4
  store i64 %_b518, ptr %total, align 4
  br label %fx

fx:                                               ; preds = %fb
  %fic = load i64, ptr %__fi, align 4
  %fin = add i64 %fic, 1
  store i64 %fin, ptr %__fi, align 4
  br label %fc

fe:                                               ; preds = %fc
  %sum19 = load i64, ptr %sum, align 4
  %i2s = call %ForgeString @forge_int_to_string(i64 %sum19)
  call void @forge_println_string(%ForgeString %i2s)
  %total20 = load i64, ptr %total, align 4
  %i2s21 = call %ForgeString @forge_int_to_string(i64 %total20)
  call void @forge_println_string(%ForgeString %i2s21)
  ret i32 0
}
