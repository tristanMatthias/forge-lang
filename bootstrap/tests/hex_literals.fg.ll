; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@a = global i64 0
@b = global i64 0
@c = global i64 0
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

define i64 @main() {
bb0:
  store i64 255, ptr @a, align 4
  store i64 10, ptr @b, align 4
  store i64 15, ptr @c, align 4
  %0 = load i64, ptr @a, align 4
  %1 = call ptr @malloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @0, i64 %0)
  %3 = ptrtoint ptr %1 to i64
  %4 = inttoptr i64 %3 to ptr
  %5 = call i32 @puts(ptr %4)
  %6 = load i64, ptr @b, align 4
  %7 = call ptr @malloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @1, i64 %6)
  %9 = ptrtoint ptr %7 to i64
  %10 = inttoptr i64 %9 to ptr
  %11 = call i32 @puts(ptr %10)
  %12 = load i64, ptr @c, align 4
  %13 = call ptr @malloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @2, i64 %12)
  %15 = ptrtoint ptr %13 to i64
  %16 = inttoptr i64 %15 to ptr
  %17 = call i32 @puts(ptr %16)
  ret i64 0
}
