; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Config = type { i64, i64 }
%App = type { i64, i64 }

@app = global i64 0
@fallback = global i64 0
@keep = global i64 0
@port = global i64 0
@name = global i64 0
@0 = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@1 = private unnamed_addr constant [6 x i8] c"myapp\00", align 1
@2 = private unnamed_addr constant [8 x i8] c"default\00", align 1
@3 = private unnamed_addr constant [9 x i8] c"original\00", align 1
@4 = private unnamed_addr constant [9 x i8] c"fallback\00", align 1
@5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@6 = private unnamed_addr constant [10 x i8] c"anonymous\00", align 1
@7 = private unnamed_addr constant [7 x i8] c"user: \00", align 1

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
  %0 = call ptr @malloc(i64 16)
  %1 = call ptr @malloc(i64 16)
  %2 = getelementptr inbounds %Config, ptr %1, i32 0, i32 0
  store i64 ptrtoint (ptr @0 to i64), ptr %2, align 4
  %3 = getelementptr inbounds %Config, ptr %1, i32 0, i32 1
  store i64 8080, ptr %3, align 4
  %4 = ptrtoint ptr %1 to i64
  %5 = getelementptr inbounds %App, ptr %0, i32 0, i32 0
  store i64 %4, ptr %5, align 4
  %6 = getelementptr inbounds %App, ptr %0, i32 0, i32 1
  store i64 ptrtoint (ptr @1 to i64), ptr %6, align 4
  %7 = ptrtoint ptr %0 to i64
  store i64 %7, ptr @app, align 4
  %nc_result = alloca i64, align 8
  store i64 0, ptr %nc_result, align 4
  br i1 true, label %bb1, label %bb2

bb1:                                              ; preds = %bb0
  store i64 ptrtoint (ptr @2 to i64), ptr %nc_result, align 4
  br label %bb2

bb2:                                              ; preds = %bb1, %bb0
  %8 = load i64, ptr %nc_result, align 4
  store i64 %8, ptr @fallback, align 4
  %9 = load i64, ptr @fallback, align 4
  %10 = inttoptr i64 %9 to ptr
  %11 = call i32 @puts(ptr %10)
  %12 = icmp eq i64 ptrtoint (ptr @3 to i64), 0
  %nc_result1 = alloca i64, align 8
  store i64 ptrtoint (ptr @3 to i64), ptr %nc_result1, align 4
  br i1 %12, label %bb3, label %bb4

bb3:                                              ; preds = %bb2
  store i64 ptrtoint (ptr @4 to i64), ptr %nc_result1, align 4
  br label %bb4

bb4:                                              ; preds = %bb3, %bb2
  %13 = load i64, ptr %nc_result1, align 4
  store i64 %13, ptr @keep, align 4
  %14 = load i64, ptr @keep, align 4
  %15 = inttoptr i64 %14 to ptr
  %16 = call i32 @puts(ptr %15)
  %ife_result = alloca i64, align 8
  store i64 0, ptr %ife_result, align 4
  br i1 true, label %bb5, label %bb6

bb5:                                              ; preds = %bb4
  %17 = load i64, ptr @app, align 4
  %18 = inttoptr i64 %17 to ptr
  %19 = getelementptr inbounds %App, ptr %18, i32 0, i32 0
  %20 = load i64, ptr %19, align 4
  %21 = inttoptr i64 %20 to ptr
  %22 = getelementptr inbounds %Config, ptr %21, i32 0, i32 1
  %23 = load i64, ptr %22, align 4
  store i64 %23, ptr %ife_result, align 4
  br label %bb7

bb6:                                              ; preds = %bb4
  store i64 0, ptr %ife_result, align 4
  br label %bb7

bb7:                                              ; preds = %bb6, %bb5
  %24 = load i64, ptr %ife_result, align 4
  store i64 %24, ptr @port, align 4
  %25 = load i64, ptr @port, align 4
  %26 = call ptr @malloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @5, i64 %25)
  %28 = ptrtoint ptr %26 to i64
  %29 = inttoptr i64 %28 to ptr
  %30 = call i32 @puts(ptr %29)
  %nc_result2 = alloca i64, align 8
  store i64 0, ptr %nc_result2, align 4
  br i1 true, label %bb8, label %bb9

bb8:                                              ; preds = %bb7
  store i64 ptrtoint (ptr @6 to i64), ptr %nc_result2, align 4
  br label %bb9

bb9:                                              ; preds = %bb8, %bb7
  %31 = load i64, ptr %nc_result2, align 4
  store i64 %31, ptr @name, align 4
  %32 = load i64, ptr @name, align 4
  %33 = inttoptr i64 %32 to ptr
  %34 = call i64 @strlen(ptr @7)
  %35 = call i64 @strlen(ptr %33)
  %36 = add i64 %34, %35
  %37 = add i64 %36, 1
  %38 = call ptr @malloc(i64 %37)
  %39 = call ptr @memcpy(ptr %38, ptr @7, i64 %34)
  %40 = ptrtoint ptr %38 to i64
  %41 = add i64 %40, %34
  %42 = inttoptr i64 %41 to ptr
  %43 = add i64 %35, 1
  %44 = call ptr @memcpy(ptr %42, ptr %33, i64 %43)
  %45 = ptrtoint ptr %38 to i64
  %46 = inttoptr i64 %45 to ptr
  %47 = call i32 @puts(ptr %46)
  ret i64 0
}
