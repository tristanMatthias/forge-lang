; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@a = global i64 0
@b = global i64 0
@0 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@9 = private unnamed_addr constant [4 x i8] c"abc\00", align 1
@10 = private unnamed_addr constant [4 x i8] c"abc\00", align 1
@11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@12 = private unnamed_addr constant [4 x i8] c"abc\00", align 1
@13 = private unnamed_addr constant [4 x i8] c"def\00", align 1
@14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@15 = private unnamed_addr constant [4 x i8] c"abc\00", align 1
@16 = private unnamed_addr constant [4 x i8] c"def\00", align 1
@17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  store i64 10, ptr @a, align 4
  store i64 20, ptr @b, align 4
  %0 = load i64, ptr @a, align 4
  %1 = load i64, ptr @b, align 4
  %2 = icmp eq i64 %0, %1
  %3 = zext i1 %2 to i64
  %4 = call ptr @malloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @0, i64 %3)
  %6 = ptrtoint ptr %4 to i64
  %7 = inttoptr i64 %6 to ptr
  %8 = call i32 @puts(ptr %7)
  %9 = load i64, ptr @a, align 4
  %10 = load i64, ptr @b, align 4
  %11 = icmp ne i64 %9, %10
  %12 = zext i1 %11 to i64
  %13 = call ptr @malloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @1, i64 %12)
  %15 = ptrtoint ptr %13 to i64
  %16 = inttoptr i64 %15 to ptr
  %17 = call i32 @puts(ptr %16)
  %18 = load i64, ptr @a, align 4
  %19 = icmp eq i64 %18, 10
  %20 = zext i1 %19 to i64
  %21 = call ptr @malloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @2, i64 %20)
  %23 = ptrtoint ptr %21 to i64
  %24 = inttoptr i64 %23 to ptr
  %25 = call i32 @puts(ptr %24)
  %26 = load i64, ptr @a, align 4
  %27 = load i64, ptr @b, align 4
  %28 = icmp slt i64 %26, %27
  %29 = zext i1 %28 to i64
  %30 = call ptr @malloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @3, i64 %29)
  %32 = ptrtoint ptr %30 to i64
  %33 = inttoptr i64 %32 to ptr
  %34 = call i32 @puts(ptr %33)
  %35 = load i64, ptr @a, align 4
  %36 = load i64, ptr @b, align 4
  %37 = icmp sle i64 %35, %36
  %38 = zext i1 %37 to i64
  %39 = call ptr @malloc(i64 32)
  %40 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %39, i64 32, ptr @4, i64 %38)
  %41 = ptrtoint ptr %39 to i64
  %42 = inttoptr i64 %41 to ptr
  %43 = call i32 @puts(ptr %42)
  %44 = load i64, ptr @a, align 4
  %45 = load i64, ptr @b, align 4
  %46 = icmp sgt i64 %44, %45
  %47 = zext i1 %46 to i64
  %48 = call ptr @malloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @5, i64 %47)
  %50 = ptrtoint ptr %48 to i64
  %51 = inttoptr i64 %50 to ptr
  %52 = call i32 @puts(ptr %51)
  %53 = load i64, ptr @a, align 4
  %54 = load i64, ptr @b, align 4
  %55 = icmp sge i64 %53, %54
  %56 = zext i1 %55 to i64
  %57 = call ptr @malloc(i64 32)
  %58 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %57, i64 32, ptr @6, i64 %56)
  %59 = ptrtoint ptr %57 to i64
  %60 = inttoptr i64 %59 to ptr
  %61 = call i32 @puts(ptr %60)
  %62 = load i64, ptr @a, align 4
  %63 = icmp sle i64 %62, 10
  %64 = zext i1 %63 to i64
  %65 = call ptr @malloc(i64 32)
  %66 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %65, i64 32, ptr @7, i64 %64)
  %67 = ptrtoint ptr %65 to i64
  %68 = inttoptr i64 %67 to ptr
  %69 = call i32 @puts(ptr %68)
  %70 = load i64, ptr @a, align 4
  %71 = icmp sge i64 %70, 10
  %72 = zext i1 %71 to i64
  %73 = call ptr @malloc(i64 32)
  %74 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %73, i64 32, ptr @8, i64 %72)
  %75 = ptrtoint ptr %73 to i64
  %76 = inttoptr i64 %75 to ptr
  %77 = call i32 @puts(ptr %76)
  %78 = call i32 @strcmp(ptr @9, ptr @10)
  %79 = zext i32 %78 to i64
  %80 = icmp eq i64 %79, 0
  %81 = zext i1 %80 to i64
  %82 = call ptr @malloc(i64 32)
  %83 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %82, i64 32, ptr @11, i64 %81)
  %84 = ptrtoint ptr %82 to i64
  %85 = inttoptr i64 %84 to ptr
  %86 = call i32 @puts(ptr %85)
  %87 = call i32 @strcmp(ptr @12, ptr @13)
  %88 = zext i32 %87 to i64
  %89 = icmp ne i64 %88, 0
  %90 = zext i1 %89 to i64
  %91 = call ptr @malloc(i64 32)
  %92 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %91, i64 32, ptr @14, i64 %90)
  %93 = ptrtoint ptr %91 to i64
  %94 = inttoptr i64 %93 to ptr
  %95 = call i32 @puts(ptr %94)
  %96 = call i32 @strcmp(ptr @15, ptr @16)
  %97 = sext i32 %96 to i64
  %98 = icmp slt i64 %97, 0
  %99 = zext i1 %98 to i64
  %100 = call ptr @malloc(i64 32)
  %101 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %100, i64 32, ptr @17, i64 %99)
  %102 = ptrtoint ptr %100 to i64
  %103 = inttoptr i64 %102 to ptr
  %104 = call i32 @puts(ptr %103)
  ret i64 0
}
