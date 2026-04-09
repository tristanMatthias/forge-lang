; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@0 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %0 = call ptr @malloc(i64 32)
  %1 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %0, i64 32, ptr @0, i64 33)
  %2 = ptrtoint ptr %0 to i64
  %3 = inttoptr i64 %2 to ptr
  %4 = call i32 @puts(ptr %3)
  %5 = call ptr @malloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @1, i64 5)
  %7 = ptrtoint ptr %5 to i64
  %8 = inttoptr i64 %7 to ptr
  %9 = call i32 @puts(ptr %8)
  %10 = call ptr @malloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @2, i64 -3)
  %12 = ptrtoint ptr %10 to i64
  %13 = inttoptr i64 %12 to ptr
  %14 = call i32 @puts(ptr %13)
  %15 = call ptr @malloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @3, i64 7)
  %17 = ptrtoint ptr %15 to i64
  %18 = inttoptr i64 %17 to ptr
  %19 = call i32 @puts(ptr %18)
  %20 = call ptr @malloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @4, i64 14)
  %22 = ptrtoint ptr %20 to i64
  %23 = inttoptr i64 %22 to ptr
  %24 = call i32 @puts(ptr %23)
  %25 = call ptr @malloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @5, i64 20)
  %27 = ptrtoint ptr %25 to i64
  %28 = inttoptr i64 %27 to ptr
  %29 = call i32 @puts(ptr %28)
  %30 = call ptr @malloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @6, i64 25)
  %32 = ptrtoint ptr %30 to i64
  %33 = inttoptr i64 %32 to ptr
  %34 = call i32 @puts(ptr %33)
  %35 = call ptr @malloc(i64 32)
  %36 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %35, i64 32, ptr @7, i64 75)
  %37 = ptrtoint ptr %35 to i64
  %38 = inttoptr i64 %37 to ptr
  %39 = call i32 @puts(ptr %38)
  ret i64 0
}
