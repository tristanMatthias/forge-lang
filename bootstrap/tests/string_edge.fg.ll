; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@ch = global i64 0
@s = global i64 0
@0 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  store i64 ptrtoint (ptr @0 to i64), ptr @ch, align 4
  %0 = load i64, ptr @ch, align 4
  %1 = inttoptr i64 %0 to ptr
  %2 = call i64 @strlen(ptr %1)
  %3 = call ptr @malloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @1, i64 %2)
  %5 = ptrtoint ptr %3 to i64
  %6 = inttoptr i64 %5 to ptr
  %7 = call i32 @puts(ptr %6)
  %8 = load i64, ptr @ch, align 4
  %9 = inttoptr i64 %8 to ptr
  %10 = call i32 @puts(ptr %9)
  store i64 ptrtoint (ptr @2 to i64), ptr @s, align 4
  %11 = load i64, ptr @s, align 4
  %12 = add i64 %11, 0
  %13 = inttoptr i64 %12 to ptr
  %14 = load i8, ptr %13, align 1
  %15 = call ptr @malloc(i64 2)
  store i8 %14, ptr %15, align 1
  %16 = ptrtoint ptr %15 to i64
  %17 = add i64 %16, 1
  %18 = inttoptr i64 %17 to ptr
  store i8 0, ptr %18, align 1
  %19 = ptrtoint ptr %15 to i64
  %20 = inttoptr i64 %19 to ptr
  %21 = call i32 @puts(ptr %20)
  %22 = load i64, ptr @s, align 4
  %23 = add i64 %22, 4
  %24 = inttoptr i64 %23 to ptr
  %25 = load i8, ptr %24, align 1
  %26 = call ptr @malloc(i64 2)
  store i8 %25, ptr %26, align 1
  %27 = ptrtoint ptr %26 to i64
  %28 = add i64 %27, 1
  %29 = inttoptr i64 %28 to ptr
  store i8 0, ptr %29, align 1
  %30 = ptrtoint ptr %26 to i64
  %31 = inttoptr i64 %30 to ptr
  %32 = call i32 @puts(ptr %31)
  %33 = load i64, ptr @s, align 4
  %34 = inttoptr i64 %33 to ptr
  %35 = call ptr @malloc(i64 1)
  %36 = ptrtoint ptr %34 to i64
  %37 = add i64 %36, 0
  %38 = inttoptr i64 %37 to ptr
  %39 = call ptr @memcpy(ptr %35, ptr %38, i64 0)
  %40 = ptrtoint ptr %35 to i64
  %41 = add i64 %40, 0
  %42 = inttoptr i64 %41 to ptr
  store i8 0, ptr %42, align 1
  %43 = ptrtoint ptr %35 to i64
  %44 = inttoptr i64 %43 to ptr
  %45 = call i32 @puts(ptr %44)
  %46 = load i64, ptr @s, align 4
  %47 = inttoptr i64 %46 to ptr
  %48 = call ptr @malloc(i64 6)
  %49 = ptrtoint ptr %47 to i64
  %50 = add i64 %49, 0
  %51 = inttoptr i64 %50 to ptr
  %52 = call ptr @memcpy(ptr %48, ptr %51, i64 5)
  %53 = ptrtoint ptr %48 to i64
  %54 = add i64 %53, 5
  %55 = inttoptr i64 %54 to ptr
  store i8 0, ptr %55, align 1
  %56 = ptrtoint ptr %48 to i64
  %57 = inttoptr i64 %56 to ptr
  %58 = call i32 @puts(ptr %57)
  %59 = load i64, ptr @s, align 4
  %60 = inttoptr i64 %59 to ptr
  %61 = call ptr @malloc(i64 1)
  %62 = ptrtoint ptr %60 to i64
  %63 = add i64 %62, 2
  %64 = inttoptr i64 %63 to ptr
  %65 = call ptr @memcpy(ptr %61, ptr %64, i64 0)
  %66 = ptrtoint ptr %61 to i64
  %67 = add i64 %66, 0
  %68 = inttoptr i64 %67 to ptr
  store i8 0, ptr %68, align 1
  %69 = ptrtoint ptr %61 to i64
  %70 = inttoptr i64 %69 to ptr
  %71 = call i32 @puts(ptr %70)
  %72 = load i64, ptr @s, align 4
  %73 = inttoptr i64 %72 to ptr
  %74 = call ptr @malloc(i64 6)
  %75 = ptrtoint ptr %73 to i64
  %76 = add i64 %75, 0
  %77 = inttoptr i64 %76 to ptr
  %78 = call ptr @memcpy(ptr %74, ptr %77, i64 5)
  %79 = ptrtoint ptr %74 to i64
  %80 = add i64 %79, 5
  %81 = inttoptr i64 %80 to ptr
  store i8 0, ptr %81, align 1
  %82 = ptrtoint ptr %74 to i64
  %83 = inttoptr i64 %82 to ptr
  %84 = call i64 @strlen(ptr %83)
  %85 = call ptr @malloc(i64 32)
  %86 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %85, i64 32, ptr @3, i64 %84)
  %87 = ptrtoint ptr %85 to i64
  %88 = inttoptr i64 %87 to ptr
  %89 = call i32 @puts(ptr %88)
  ret i64 0
}
