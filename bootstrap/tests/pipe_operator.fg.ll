; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@result = global i64 0
@result2 = global i64 0
@0 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @double(i64 %0) {
bb1:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 4
  %1 = load i64, ptr %x, align 4
  %2 = mul i64 %1, 2
  ret i64 %2
}

define i64 @add(i64 %0, i64 %1) {
bb2:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 4
  %y = alloca i64, align 8
  store i64 %1, ptr %y, align 4
  %2 = load i64, ptr %x, align 4
  %3 = load i64, ptr %y, align 4
  %4 = add i64 %2, %3
  ret i64 %4
}

define i64 @main() {
bb0:
  %0 = call i64 @double(i64 5)
  store i64 %0, ptr @result, align 4
  %1 = load i64, ptr @result, align 4
  %2 = call ptr @malloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @0, i64 %1)
  %4 = ptrtoint ptr %2 to i64
  %5 = inttoptr i64 %4 to ptr
  %6 = call i32 @puts(ptr %5)
  %7 = call i64 @add(i64 3, i64 7)
  store i64 %7, ptr @result2, align 4
  %8 = load i64, ptr @result2, align 4
  %9 = call ptr @malloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @1, i64 %8)
  %11 = ptrtoint ptr %9 to i64
  %12 = inttoptr i64 %11 to ptr
  %13 = call i32 @puts(ptr %12)
  ret i64 0
}
