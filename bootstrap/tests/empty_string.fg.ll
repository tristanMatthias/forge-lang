; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@empty = global i64 0
@result = global i64 0
@0 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@4 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@7 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@8 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@9 = private unnamed_addr constant [7 x i8] c" world\00", align 1
@10 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  store i64 ptrtoint (ptr @0 to i64), ptr @empty, align 4
  %0 = load i64, ptr @empty, align 4
  %1 = inttoptr i64 %0 to ptr
  %2 = call i64 @strlen(ptr %1)
  %3 = call ptr @malloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @1, i64 %2)
  %5 = ptrtoint ptr %3 to i64
  %6 = inttoptr i64 %5 to ptr
  %7 = call i32 @puts(ptr %6)
  %8 = load i64, ptr @empty, align 4
  %9 = inttoptr i64 %8 to ptr
  %10 = call i32 @strcmp(ptr %9, ptr @2)
  %11 = zext i32 %10 to i64
  %12 = icmp eq i64 %11, 0
  %13 = zext i1 %12 to i64
  %14 = call ptr @malloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @3, i64 %13)
  %16 = ptrtoint ptr %14 to i64
  %17 = inttoptr i64 %16 to ptr
  %18 = call i32 @puts(ptr %17)
  %19 = load i64, ptr @empty, align 4
  %20 = inttoptr i64 %19 to ptr
  %21 = call i32 @strcmp(ptr %20, ptr @4)
  %22 = zext i32 %21 to i64
  %23 = icmp ne i64 %22, 0
  %24 = zext i1 %23 to i64
  %25 = call ptr @malloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @5, i64 %24)
  %27 = ptrtoint ptr %25 to i64
  %28 = inttoptr i64 %27 to ptr
  %29 = call i32 @puts(ptr %28)
  %30 = call i64 @strlen(ptr @6)
  %31 = call i64 @strlen(ptr @7)
  %32 = add i64 %30, %31
  %33 = add i64 %32, 1
  %34 = call ptr @malloc(i64 %33)
  %35 = call ptr @memcpy(ptr %34, ptr @6, i64 %30)
  %36 = ptrtoint ptr %34 to i64
  %37 = add i64 %36, %30
  %38 = inttoptr i64 %37 to ptr
  %39 = add i64 %31, 1
  %40 = call ptr @memcpy(ptr %38, ptr @7, i64 %39)
  %41 = ptrtoint ptr %34 to i64
  %42 = inttoptr i64 %41 to ptr
  %43 = call i64 @strlen(ptr %42)
  %44 = call i64 @strlen(ptr @8)
  %45 = add i64 %43, %44
  %46 = add i64 %45, 1
  %47 = call ptr @malloc(i64 %46)
  %48 = call ptr @memcpy(ptr %47, ptr %42, i64 %43)
  %49 = ptrtoint ptr %47 to i64
  %50 = add i64 %49, %43
  %51 = inttoptr i64 %50 to ptr
  %52 = add i64 %44, 1
  %53 = call ptr @memcpy(ptr %51, ptr @8, i64 %52)
  %54 = ptrtoint ptr %47 to i64
  %55 = inttoptr i64 %54 to ptr
  %56 = call i64 @strlen(ptr %55)
  %57 = call i64 @strlen(ptr @9)
  %58 = add i64 %56, %57
  %59 = add i64 %58, 1
  %60 = call ptr @malloc(i64 %59)
  %61 = call ptr @memcpy(ptr %60, ptr %55, i64 %56)
  %62 = ptrtoint ptr %60 to i64
  %63 = add i64 %62, %56
  %64 = inttoptr i64 %63 to ptr
  %65 = add i64 %57, 1
  %66 = call ptr @memcpy(ptr %64, ptr @9, i64 %65)
  %67 = ptrtoint ptr %60 to i64
  %68 = inttoptr i64 %67 to ptr
  %69 = call i64 @strlen(ptr %68)
  %70 = call i64 @strlen(ptr @10)
  %71 = add i64 %69, %70
  %72 = add i64 %71, 1
  %73 = call ptr @malloc(i64 %72)
  %74 = call ptr @memcpy(ptr %73, ptr %68, i64 %69)
  %75 = ptrtoint ptr %73 to i64
  %76 = add i64 %75, %69
  %77 = inttoptr i64 %76 to ptr
  %78 = add i64 %70, 1
  %79 = call ptr @memcpy(ptr %77, ptr @10, i64 %78)
  %80 = ptrtoint ptr %73 to i64
  store i64 %80, ptr @result, align 4
  %81 = load i64, ptr @result, align 4
  %82 = inttoptr i64 %81 to ptr
  %83 = call i32 @puts(ptr %82)
  %84 = load i64, ptr @result, align 4
  %85 = inttoptr i64 %84 to ptr
  %86 = call i64 @strlen(ptr %85)
  %87 = call ptr @malloc(i64 32)
  %88 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %87, i64 32, ptr @11, i64 %86)
  %89 = ptrtoint ptr %87 to i64
  %90 = inttoptr i64 %89 to ptr
  %91 = call i32 @puts(ptr %90)
  ret i64 0
}
