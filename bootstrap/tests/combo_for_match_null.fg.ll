; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%MaybeEntry = type { i8, i64 }
%Entry = type { i64, i64 }

@total = global i64 0
@0 = private unnamed_addr constant [6 x i8] c"found\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @lookup(i64 %0) {
bb1:
  %entries = alloca i64, align 8
  store i64 %0, ptr %entries, align 4
  %1 = load i64, ptr %entries, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = getelementptr inbounds %MaybeEntry, ptr %2, i32 0, i32 0
  %4 = load i8, ptr %3, align 1
  %match_result = alloca i64, align 8
  store i64 0, ptr %match_result, align 4
  %5 = zext i8 %4 to i64
  %6 = icmp eq i64 %5, 0
  br i1 %6, label %bb3, label %bb4

bb2:                                              ; preds = %bb6, %bb5, %bb3
  %7 = load i64, ptr %match_result, align 4
  ret i64 %7

bb3:                                              ; preds = %bb1
  store i64 -1, ptr %match_result, align 4
  br label %bb2

bb4:                                              ; preds = %bb1
  %8 = zext i8 %4 to i64
  %9 = icmp eq i64 %8, 1
  br i1 %9, label %bb5, label %bb6

bb5:                                              ; preds = %bb4
  %10 = getelementptr inbounds %MaybeEntry, ptr %2, i32 0, i32 1
  %11 = load i64, ptr %10, align 4
  %e = alloca i64, align 8
  store i64 %11, ptr %e, align 4
  %12 = load i64, ptr %e, align 4
  %13 = inttoptr i64 %12 to ptr
  %14 = getelementptr inbounds %Entry, ptr %13, i32 0, i32 1
  %15 = load i64, ptr %14, align 4
  store i64 %15, ptr %match_result, align 4
  br label %bb2

bb6:                                              ; preds = %bb4
  br label %bb2
}

define i64 @main() {
bb0:
  store i64 0, ptr @total, align 4
  %i = alloca i64, align 8
  store i64 0, ptr %i, align 4
  %for_end = alloca i64, align 8
  store i64 5, ptr %for_end, align 4
  br label %bb7

bb7:                                              ; preds = %bb9, %bb0
  %0 = load i64, ptr %i, align 4
  %1 = load i64, ptr %for_end, align 4
  %2 = icmp slt i64 %0, %1
  br i1 %2, label %bb8, label %bb10

bb8:                                              ; preds = %bb7
  %3 = load i64, ptr %i, align 4
  %4 = icmp eq i64 %3, 2
  %5 = zext i1 %4 to i64
  %6 = icmp ne i64 %5, 0
  br i1 %6, label %bb12, label %bb11

bb9:                                              ; preds = %bb18
  %7 = load i64, ptr %i, align 4
  %8 = add i64 %7, 1
  store i64 %8, ptr %i, align 4
  br label %bb7

bb10:                                             ; preds = %bb7
  %9 = load i64, ptr @total, align 4
  %10 = call ptr @malloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @1, i64 %9)
  %12 = ptrtoint ptr %10 to i64
  %13 = inttoptr i64 %12 to ptr
  %14 = call i32 @puts(ptr %13)
  ret i64 0

bb11:                                             ; preds = %bb8
  %15 = load i64, ptr %i, align 4
  %16 = icmp eq i64 %15, 4
  %17 = zext i1 %16 to i64
  %18 = icmp ne i64 %17, 0
  br label %bb12

bb12:                                             ; preds = %bb11, %bb8
  %19 = phi i1 [ true, %bb8 ], [ %18, %bb11 ]
  %20 = zext i1 %19 to i64
  %21 = icmp ne i64 %20, 0
  %ife_result = alloca i64, align 8
  store i64 0, ptr %ife_result, align 4
  br i1 %21, label %bb13, label %bb14

bb13:                                             ; preds = %bb12
  %22 = call ptr @malloc(i64 16)
  %23 = getelementptr inbounds %MaybeEntry, ptr %22, i32 0, i32 0
  store i8 1, ptr %23, align 1
  %24 = call ptr @malloc(i64 16)
  %25 = getelementptr inbounds %Entry, ptr %24, i32 0, i32 0
  store i64 ptrtoint (ptr @0 to i64), ptr %25, align 4
  %26 = load i64, ptr %i, align 4
  %27 = add i64 %26, 1
  %28 = mul i64 %27, 10
  %29 = getelementptr inbounds %Entry, ptr %24, i32 0, i32 1
  store i64 %28, ptr %29, align 4
  %30 = ptrtoint ptr %24 to i64
  %31 = getelementptr inbounds %MaybeEntry, ptr %22, i32 0, i32 1
  store i64 %30, ptr %31, align 4
  %32 = ptrtoint ptr %22 to i64
  store i64 %32, ptr %ife_result, align 4
  br label %bb15

bb14:                                             ; preds = %bb12
  %33 = call ptr @malloc(i64 16)
  %34 = getelementptr inbounds %MaybeEntry, ptr %33, i32 0, i32 0
  store i8 0, ptr %34, align 1
  %35 = ptrtoint ptr %33 to i64
  store i64 %35, ptr %ife_result, align 4
  br label %bb15

bb15:                                             ; preds = %bb14, %bb13
  %36 = load i64, ptr %ife_result, align 4
  %entry = alloca i64, align 8
  store i64 %36, ptr %entry, align 4
  %37 = load i64, ptr %entry, align 4
  %38 = call i64 @lookup(i64 %37)
  %val = alloca i64, align 8
  store i64 %38, ptr %val, align 4
  %39 = load i64, ptr %val, align 4
  %40 = icmp sgt i64 %39, 0
  %41 = zext i1 %40 to i64
  %42 = icmp ne i64 %41, 0
  br i1 %42, label %bb16, label %bb17

bb16:                                             ; preds = %bb15
  %43 = load i64, ptr @total, align 4
  %44 = load i64, ptr %val, align 4
  %45 = add i64 %43, %44
  store i64 %45, ptr @total, align 4
  br label %bb18

bb17:                                             ; preds = %bb15
  br label %bb18

bb18:                                             ; preds = %bb17, %bb16
  br label %bb9
}
