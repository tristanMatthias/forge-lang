; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@a = global i64 0
@b = global i64 0
@0 = private unnamed_addr constant [14 x i8] c"and-not works\00", align 1
@1 = private unnamed_addr constant [9 x i8] c"or works\00", align 1
@2 = private unnamed_addr constant [10 x i8] c"not works\00", align 1

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
  store i64 1, ptr @a, align 4
  store i64 0, ptr @b, align 4
  %0 = load i64, ptr @a, align 4
  %1 = icmp ne i64 %0, 0
  br i1 %1, label %bb1, label %bb2

bb1:                                              ; preds = %bb0
  %2 = load i64, ptr @b, align 4
  %3 = icmp eq i64 %2, 0
  %4 = zext i1 %3 to i64
  %5 = icmp ne i64 %4, 0
  br label %bb2

bb2:                                              ; preds = %bb1, %bb0
  %6 = phi i1 [ false, %bb0 ], [ %5, %bb1 ]
  %7 = zext i1 %6 to i64
  %8 = icmp ne i64 %7, 0
  br i1 %8, label %bb3, label %bb4

bb3:                                              ; preds = %bb2
  %9 = call i32 @puts(ptr @0)
  br label %bb5

bb4:                                              ; preds = %bb2
  br label %bb5

bb5:                                              ; preds = %bb4, %bb3
  %10 = load i64, ptr @b, align 4
  %11 = icmp ne i64 %10, 0
  br i1 %11, label %bb7, label %bb6

bb6:                                              ; preds = %bb5
  %12 = load i64, ptr @a, align 4
  %13 = icmp ne i64 %12, 0
  br label %bb7

bb7:                                              ; preds = %bb6, %bb5
  %14 = phi i1 [ true, %bb5 ], [ %13, %bb6 ]
  %15 = zext i1 %14 to i64
  %16 = icmp ne i64 %15, 0
  br i1 %16, label %bb8, label %bb9

bb8:                                              ; preds = %bb7
  %17 = call i32 @puts(ptr @1)
  br label %bb10

bb9:                                              ; preds = %bb7
  br label %bb10

bb10:                                             ; preds = %bb9, %bb8
  br i1 true, label %bb11, label %bb12

bb11:                                             ; preds = %bb10
  %18 = call i32 @puts(ptr @2)
  br label %bb13

bb12:                                             ; preds = %bb10
  br label %bb13

bb13:                                             ; preds = %bb12, %bb11
  ret i64 0
}
