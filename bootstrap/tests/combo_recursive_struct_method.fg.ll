; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%IntList = type { i8, i64, i64 }

@list = global i64 0
@0 = private unnamed_addr constant [3 x i8] c"[]\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [5 x i8] c" :: \00", align 1
@3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @IntList__sum(i64 %0) {
bb1:
  %self = alloca i64, align 8
  store i64 %0, ptr %self, align 4
  %1 = load i64, ptr %self, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = getelementptr inbounds %IntList, ptr %2, i32 0, i32 0
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
  store i64 0, ptr %match_result, align 4
  br label %bb2

bb4:                                              ; preds = %bb1
  %8 = zext i8 %4 to i64
  %9 = icmp eq i64 %8, 1
  br i1 %9, label %bb5, label %bb6

bb5:                                              ; preds = %bb4
  %10 = getelementptr inbounds %IntList, ptr %2, i32 0, i32 1
  %11 = load i64, ptr %10, align 4
  %h = alloca i64, align 8
  store i64 %11, ptr %h, align 4
  %12 = getelementptr inbounds %IntList, ptr %2, i32 0, i32 2
  %13 = load i64, ptr %12, align 4
  %t = alloca i64, align 8
  store i64 %13, ptr %t, align 4
  %14 = load i64, ptr %h, align 4
  %15 = load i64, ptr %t, align 4
  %16 = call i64 @IntList__sum(i64 %15)
  %17 = add i64 %14, %16
  store i64 %17, ptr %match_result, align 4
  br label %bb2

bb6:                                              ; preds = %bb4
  br label %bb2
}

define i64 @IntList__to_string(i64 %0) {
bb7:
  %self = alloca i64, align 8
  store i64 %0, ptr %self, align 4
  %1 = load i64, ptr %self, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = getelementptr inbounds %IntList, ptr %2, i32 0, i32 0
  %4 = load i8, ptr %3, align 1
  %match_result = alloca i64, align 8
  store i64 0, ptr %match_result, align 4
  %5 = zext i8 %4 to i64
  %6 = icmp eq i64 %5, 0
  br i1 %6, label %bb9, label %bb10

bb8:                                              ; preds = %bb12, %bb11, %bb9
  %7 = load i64, ptr %match_result, align 4
  ret i64 %7

bb9:                                              ; preds = %bb7
  store i64 ptrtoint (ptr @0 to i64), ptr %match_result, align 4
  br label %bb8

bb10:                                             ; preds = %bb7
  %8 = zext i8 %4 to i64
  %9 = icmp eq i64 %8, 1
  br i1 %9, label %bb11, label %bb12

bb11:                                             ; preds = %bb10
  %10 = getelementptr inbounds %IntList, ptr %2, i32 0, i32 1
  %11 = load i64, ptr %10, align 4
  %h = alloca i64, align 8
  store i64 %11, ptr %h, align 4
  %12 = getelementptr inbounds %IntList, ptr %2, i32 0, i32 2
  %13 = load i64, ptr %12, align 4
  %t = alloca i64, align 8
  store i64 %13, ptr %t, align 4
  %14 = load i64, ptr %t, align 4
  %15 = call i64 @IntList__to_string(i64 %14)
  %rest = alloca i64, align 8
  store i64 %15, ptr %rest, align 4
  %16 = load i64, ptr %h, align 4
  %17 = call ptr @malloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @1, i64 %16)
  %19 = ptrtoint ptr %17 to i64
  %20 = inttoptr i64 %19 to ptr
  %21 = call i64 @strlen(ptr %20)
  %22 = call i64 @strlen(ptr @2)
  %23 = add i64 %21, %22
  %24 = add i64 %23, 1
  %25 = call ptr @malloc(i64 %24)
  %26 = call ptr @memcpy(ptr %25, ptr %20, i64 %21)
  %27 = ptrtoint ptr %25 to i64
  %28 = add i64 %27, %21
  %29 = inttoptr i64 %28 to ptr
  %30 = add i64 %22, 1
  %31 = call ptr @memcpy(ptr %29, ptr @2, i64 %30)
  %32 = ptrtoint ptr %25 to i64
  %33 = load i64, ptr %rest, align 4
  %34 = inttoptr i64 %32 to ptr
  %35 = inttoptr i64 %33 to ptr
  %36 = call i64 @strlen(ptr %34)
  %37 = call i64 @strlen(ptr %35)
  %38 = add i64 %36, %37
  %39 = add i64 %38, 1
  %40 = call ptr @malloc(i64 %39)
  %41 = call ptr @memcpy(ptr %40, ptr %34, i64 %36)
  %42 = ptrtoint ptr %40 to i64
  %43 = add i64 %42, %36
  %44 = inttoptr i64 %43 to ptr
  %45 = add i64 %37, 1
  %46 = call ptr @memcpy(ptr %44, ptr %35, i64 %45)
  %47 = ptrtoint ptr %40 to i64
  store i64 %47, ptr %match_result, align 4
  br label %bb8

bb12:                                             ; preds = %bb10
  br label %bb8
}

define i64 @main() {
bb0:
  %0 = call ptr @malloc(i64 24)
  %1 = getelementptr inbounds %IntList, ptr %0, i32 0, i32 0
  store i8 0, ptr %1, align 1
  %2 = ptrtoint ptr %0 to i64
  store i64 %2, ptr @list, align 4
  %i = alloca i64, align 8
  store i64 0, ptr %i, align 4
  %for_end = alloca i64, align 8
  store i64 5, ptr %for_end, align 4
  br label %bb13

bb13:                                             ; preds = %bb15, %bb0
  %3 = load i64, ptr %i, align 4
  %4 = load i64, ptr %for_end, align 4
  %5 = icmp slt i64 %3, %4
  br i1 %5, label %bb14, label %bb16

bb14:                                             ; preds = %bb13
  %6 = call ptr @malloc(i64 24)
  %7 = getelementptr inbounds %IntList, ptr %6, i32 0, i32 0
  store i8 1, ptr %7, align 1
  %8 = load i64, ptr %i, align 4
  %9 = getelementptr inbounds %IntList, ptr %6, i32 0, i32 1
  store i64 %8, ptr %9, align 4
  %10 = load i64, ptr @list, align 4
  %11 = getelementptr inbounds %IntList, ptr %6, i32 0, i32 2
  store i64 %10, ptr %11, align 4
  %12 = ptrtoint ptr %6 to i64
  store i64 %12, ptr @list, align 4
  br label %bb15

bb15:                                             ; preds = %bb14
  %13 = load i64, ptr %i, align 4
  %14 = add i64 %13, 1
  store i64 %14, ptr %i, align 4
  br label %bb13

bb16:                                             ; preds = %bb13
  %15 = load i64, ptr @list, align 4
  %16 = call i64 @IntList__to_string(i64 %15)
  %17 = inttoptr i64 %16 to ptr
  %18 = call i32 @puts(ptr %17)
  %19 = load i64, ptr @list, align 4
  %20 = call i64 @IntList__sum(i64 %19)
  %21 = call ptr @malloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @3, i64 %20)
  %23 = ptrtoint ptr %21 to i64
  %24 = inttoptr i64 %23 to ptr
  %25 = call i32 @puts(ptr %24)
  ret i64 0
}
