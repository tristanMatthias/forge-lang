; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@0 = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @main() {
bb1:
  %s = alloca i64, align 8
  store i64 ptrtoint (ptr @0 to i64), ptr %s, align 4
  %0 = load i64, ptr %s, align 4
  %1 = inttoptr i64 %0 to ptr
  %2 = call ptr @malloc(i64 6)
  %3 = ptrtoint ptr %1 to i64
  %4 = add i64 %3, 0
  %5 = inttoptr i64 %4 to ptr
  %6 = call ptr @memcpy(ptr %2, ptr %5, i64 5)
  %7 = ptrtoint ptr %2 to i64
  %8 = add i64 %7, 5
  %9 = inttoptr i64 %8 to ptr
  store i8 0, ptr %9, align 1
  %10 = ptrtoint ptr %2 to i64
  %11 = inttoptr i64 %10 to ptr
  %12 = call i32 @puts(ptr %11)
  %13 = load i64, ptr %s, align 4
  %14 = inttoptr i64 %13 to ptr
  %15 = call ptr @malloc(i64 6)
  %16 = ptrtoint ptr %14 to i64
  %17 = add i64 %16, 6
  %18 = inttoptr i64 %17 to ptr
  %19 = call ptr @memcpy(ptr %15, ptr %18, i64 5)
  %20 = ptrtoint ptr %15 to i64
  %21 = add i64 %20, 5
  %22 = inttoptr i64 %21 to ptr
  store i8 0, ptr %22, align 1
  %23 = ptrtoint ptr %15 to i64
  %24 = inttoptr i64 %23 to ptr
  %25 = call i32 @puts(ptr %24)
  %26 = load i64, ptr %s, align 4
  %27 = load i64, ptr %s, align 4
  %28 = inttoptr i64 %27 to ptr
  %29 = call i64 @strlen(ptr %28)
  %30 = inttoptr i64 %26 to ptr
  %31 = sub i64 %29, 0
  %32 = add i64 %31, 1
  %33 = call ptr @malloc(i64 %32)
  %34 = ptrtoint ptr %30 to i64
  %35 = add i64 %34, 0
  %36 = inttoptr i64 %35 to ptr
  %37 = call ptr @memcpy(ptr %33, ptr %36, i64 %31)
  %38 = ptrtoint ptr %33 to i64
  %39 = add i64 %38, %31
  %40 = inttoptr i64 %39 to ptr
  store i8 0, ptr %40, align 1
  %41 = ptrtoint ptr %33 to i64
  %42 = inttoptr i64 %41 to ptr
  %43 = call i32 @puts(ptr %42)
  %44 = load i64, ptr %s, align 4
  %45 = inttoptr i64 %44 to ptr
  %46 = call i64 @strlen(ptr %45)
  %47 = call ptr @malloc(i64 32)
  %48 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %47, i64 32, ptr @1, i64 %46)
  %49 = ptrtoint ptr %47 to i64
  %50 = inttoptr i64 %49 to ptr
  %51 = call i32 @puts(ptr %50)
  ret i64 0
}

define i64 @__bs_top_level() {
bb0:
  ret i64 0
}
