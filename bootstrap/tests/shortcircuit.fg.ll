; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@x = global i64 0
@0 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [3 x i8] c"ok\00", align 1
@3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@4 = private unnamed_addr constant [4 x i8] c"ok2\00", align 1
@5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @side_effect() {
bb1:
  %0 = load i64, ptr @x, align 4
  %1 = add i64 %0, 1
  store i64 %1, ptr @x, align 4
  ret i64 1
}

define i64 @main() {
bb0:
  store i64 0, ptr @x, align 4
  br i1 false, label %bb2, label %bb3

bb2:                                              ; preds = %bb0
  %0 = call i64 @side_effect()
  %1 = icmp eq i64 %0, 1
  %2 = zext i1 %1 to i64
  %3 = icmp ne i64 %2, 0
  br label %bb3

bb3:                                              ; preds = %bb2, %bb0
  %4 = phi i1 [ false, %bb0 ], [ %3, %bb2 ]
  %5 = zext i1 %4 to i64
  %6 = icmp ne i64 %5, 0
  br i1 %6, label %bb4, label %bb5

bb4:                                              ; preds = %bb3
  %7 = call i32 @puts(ptr @0)
  br label %bb6

bb5:                                              ; preds = %bb3
  br label %bb6

bb6:                                              ; preds = %bb5, %bb4
  %8 = load i64, ptr @x, align 4
  %9 = call ptr @malloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @1, i64 %8)
  %11 = ptrtoint ptr %9 to i64
  %12 = inttoptr i64 %11 to ptr
  %13 = call i32 @puts(ptr %12)
  br i1 true, label %bb8, label %bb7

bb7:                                              ; preds = %bb6
  %14 = call i64 @side_effect()
  %15 = icmp eq i64 %14, 1
  %16 = zext i1 %15 to i64
  %17 = icmp ne i64 %16, 0
  br label %bb8

bb8:                                              ; preds = %bb7, %bb6
  %18 = phi i1 [ true, %bb6 ], [ %17, %bb7 ]
  %19 = zext i1 %18 to i64
  %20 = icmp ne i64 %19, 0
  br i1 %20, label %bb9, label %bb10

bb9:                                              ; preds = %bb8
  %21 = call i32 @puts(ptr @2)
  br label %bb11

bb10:                                             ; preds = %bb8
  br label %bb11

bb11:                                             ; preds = %bb10, %bb9
  %22 = load i64, ptr @x, align 4
  %23 = call ptr @malloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @3, i64 %22)
  %25 = ptrtoint ptr %23 to i64
  %26 = inttoptr i64 %25 to ptr
  %27 = call i32 @puts(ptr %26)
  br i1 true, label %bb12, label %bb13

bb12:                                             ; preds = %bb11
  %28 = call i64 @side_effect()
  %29 = icmp eq i64 %28, 1
  %30 = zext i1 %29 to i64
  %31 = icmp ne i64 %30, 0
  br label %bb13

bb13:                                             ; preds = %bb12, %bb11
  %32 = phi i1 [ false, %bb11 ], [ %31, %bb12 ]
  %33 = zext i1 %32 to i64
  %34 = icmp ne i64 %33, 0
  br i1 %34, label %bb14, label %bb15

bb14:                                             ; preds = %bb13
  %35 = call i32 @puts(ptr @4)
  br label %bb16

bb15:                                             ; preds = %bb13
  br label %bb16

bb16:                                             ; preds = %bb15, %bb14
  %36 = load i64, ptr @x, align 4
  %37 = call ptr @malloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @5, i64 %36)
  %39 = ptrtoint ptr %37 to i64
  %40 = inttoptr i64 %39 to ptr
  %41 = call i32 @puts(ptr %40)
  ret i64 0
}
