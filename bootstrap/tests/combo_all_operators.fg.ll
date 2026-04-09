; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@x = global i64 0
@clamped = global i64 0
@in_range = global i64 0
@result = global i64 0
@safe = global i64 0
@result2 = global i64 0
@0 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @clamp(i64 %0, i64 %1, i64 %2) {
bb1:
  %val = alloca i64, align 8
  store i64 %0, ptr %val, align 4
  %lo = alloca i64, align 8
  store i64 %1, ptr %lo, align 4
  %hi = alloca i64, align 8
  store i64 %2, ptr %hi, align 4
  %3 = load i64, ptr %val, align 4
  %4 = load i64, ptr %lo, align 4
  %5 = icmp slt i64 %3, %4
  %6 = zext i1 %5 to i64
  %7 = icmp ne i64 %6, 0
  br i1 %7, label %bb2, label %bb3

bb2:                                              ; preds = %bb1
  %8 = load i64, ptr %lo, align 4
  ret i64 %8

bb3:                                              ; preds = %bb1
  br label %bb4

bb4:                                              ; preds = %bb3
  %9 = load i64, ptr %val, align 4
  %10 = load i64, ptr %hi, align 4
  %11 = icmp sgt i64 %9, %10
  %12 = zext i1 %11 to i64
  %13 = icmp ne i64 %12, 0
  br i1 %13, label %bb5, label %bb6

bb5:                                              ; preds = %bb4
  %14 = load i64, ptr %hi, align 4
  ret i64 %14

bb6:                                              ; preds = %bb4
  br label %bb7

bb7:                                              ; preds = %bb6
  %15 = load i64, ptr %val, align 4
  ret i64 %15
}

define i64 @abs(i64 %0) {
bb8:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %1 = load i64, ptr %n, align 4
  %2 = icmp slt i64 %1, 0
  %3 = zext i1 %2 to i64
  %4 = icmp ne i64 %3, 0
  %sif_result = alloca i64, align 8
  store i64 0, ptr %sif_result, align 4
  br i1 %4, label %bb9, label %bb10

bb9:                                              ; preds = %bb8
  %5 = load i64, ptr %n, align 4
  %6 = sub i64 0, %5
  store i64 %6, ptr %sif_result, align 4
  br label %bb11

bb10:                                             ; preds = %bb8
  %7 = load i64, ptr %n, align 4
  store i64 %7, ptr %sif_result, align 4
  br label %bb11

bb11:                                             ; preds = %bb10, %bb9
  %8 = load i64, ptr %sif_result, align 4
  ret i64 %8
}

define i64 @maybe_double(i64 %0) {
bb12:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %1 = load i64, ptr %n, align 4
  %2 = icmp sgt i64 %1, 10
  %3 = zext i1 %2 to i64
  %4 = icmp ne i64 %3, 0
  %sif_result = alloca i64, align 8
  store i64 0, ptr %sif_result, align 4
  br i1 %4, label %bb13, label %bb14

bb13:                                             ; preds = %bb12
  %5 = load i64, ptr %n, align 4
  %6 = mul i64 %5, 2
  store i64 %6, ptr %sif_result, align 4
  br label %bb15

bb14:                                             ; preds = %bb12
  store i64 0, ptr %sif_result, align 4
  br label %bb15

bb15:                                             ; preds = %bb14, %bb13
  %7 = load i64, ptr %sif_result, align 4
  ret i64 %7
}

define i64 @main() {
bb0:
  store i64 15, ptr @x, align 4
  %0 = load i64, ptr @x, align 4
  %1 = mul i64 %0, 2
  %2 = sub i64 %1, 5
  %3 = call i64 @clamp(i64 %2, i64 0, i64 50)
  store i64 %3, ptr @clamped, align 4
  %4 = load i64, ptr @clamped, align 4
  %5 = call ptr @malloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @0, i64 %4)
  %7 = ptrtoint ptr %5 to i64
  %8 = inttoptr i64 %7 to ptr
  %9 = call i32 @puts(ptr %8)
  %10 = load i64, ptr @x, align 4
  %11 = icmp sge i64 %10, 10
  %12 = zext i1 %11 to i64
  %13 = icmp ne i64 %12, 0
  br i1 %13, label %bb16, label %bb17

bb16:                                             ; preds = %bb0
  %14 = load i64, ptr @x, align 4
  %15 = icmp sle i64 %14, 20
  %16 = zext i1 %15 to i64
  %17 = icmp ne i64 %16, 0
  br label %bb17

bb17:                                             ; preds = %bb16, %bb0
  %18 = phi i1 [ false, %bb0 ], [ %17, %bb16 ]
  %19 = zext i1 %18 to i64
  store i64 %19, ptr @in_range, align 4
  %20 = load i64, ptr @in_range, align 4
  %21 = call ptr @malloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @1, i64 %20)
  %23 = ptrtoint ptr %21 to i64
  %24 = inttoptr i64 %23 to ptr
  %25 = call i32 @puts(ptr %24)
  %26 = call i64 @maybe_double(i64 5)
  store i64 %26, ptr @result, align 4
  %27 = load i64, ptr @result, align 4
  %28 = icmp eq i64 %27, 0
  %nc_result = alloca i64, align 8
  store i64 %27, ptr %nc_result, align 4
  br i1 %28, label %bb18, label %bb19

bb18:                                             ; preds = %bb17
  store i64 99, ptr %nc_result, align 4
  br label %bb19

bb19:                                             ; preds = %bb18, %bb17
  %29 = load i64, ptr %nc_result, align 4
  store i64 %29, ptr @safe, align 4
  %30 = load i64, ptr @safe, align 4
  %31 = call ptr @malloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @2, i64 %30)
  %33 = ptrtoint ptr %31 to i64
  %34 = inttoptr i64 %33 to ptr
  %35 = call i32 @puts(ptr %34)
  %36 = call i64 @maybe_double(i64 15)
  store i64 %36, ptr @result2, align 4
  %37 = load i64, ptr @result2, align 4
  %38 = call ptr @malloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @3, i64 %37)
  %40 = ptrtoint ptr %38 to i64
  %41 = inttoptr i64 %40 to ptr
  %42 = call i32 @puts(ptr %41)
  ret i64 0
}
