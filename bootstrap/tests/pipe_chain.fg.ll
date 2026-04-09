; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@result = global i64 0
@r2 = global i64 0
@s = global i64 0
@0 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @add1(i64 %0) {
bb1:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %1 = load i64, ptr %n, align 4
  %2 = add i64 %1, 1
  ret i64 %2
}

define i64 @double(i64 %0) {
bb2:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %1 = load i64, ptr %n, align 4
  %2 = mul i64 %1, 2
  ret i64 %2
}

define i64 @square(i64 %0) {
bb3:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %1 = load i64, ptr %n, align 4
  %2 = load i64, ptr %n, align 4
  %3 = mul i64 %1, %2
  ret i64 %3
}

define i64 @add(i64 %0, i64 %1) {
bb4:
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 4
  %b = alloca i64, align 8
  store i64 %1, ptr %b, align 4
  %2 = load i64, ptr %a, align 4
  %3 = load i64, ptr %b, align 4
  %4 = add i64 %2, %3
  ret i64 %4
}

define i64 @to_str(i64 %0) {
bb5:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %1 = load i64, ptr %n, align 4
  %2 = call ptr @malloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @0, i64 %1)
  %4 = ptrtoint ptr %2 to i64
  ret i64 %4
}

define i64 @main() {
bb0:
  %0 = call i64 @add1(i64 5)
  %1 = call i64 @double(i64 %0)
  %2 = call i64 @square(i64 %1)
  store i64 %2, ptr @result, align 4
  %3 = load i64, ptr @result, align 4
  %4 = call ptr @malloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @1, i64 %3)
  %6 = ptrtoint ptr %4 to i64
  %7 = inttoptr i64 %6 to ptr
  %8 = call i32 @puts(ptr %7)
  %9 = call i64 @add(i64 10, i64 5)
  store i64 %9, ptr @r2, align 4
  %10 = load i64, ptr @r2, align 4
  %11 = call ptr @malloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @2, i64 %10)
  %13 = ptrtoint ptr %11 to i64
  %14 = inttoptr i64 %13 to ptr
  %15 = call i32 @puts(ptr %14)
  %16 = call i64 @to_str(i64 42)
  store i64 %16, ptr @s, align 4
  %17 = load i64, ptr @s, align 4
  %18 = inttoptr i64 %17 to ptr
  %19 = call i32 @puts(ptr %18)
  ret i64 0
}
