; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%User = type { i64, i64 }
%Role = type { i8, i64 }

@u = global i64 0
@0 = private unnamed_addr constant [7 x i8] c" (age \00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [2 x i8] c")\00", align 1
@3 = private unnamed_addr constant [6 x i8] c"admin\00", align 1
@4 = private unnamed_addr constant [14 x i8] c"editor level \00", align 1
@5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@6 = private unnamed_addr constant [7 x i8] c"viewer\00", align 1
@7 = private unnamed_addr constant [5 x i8] c" is \00", align 1
@8 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @User__greet(i64 %0) {
bb1:
  %self = alloca i64, align 8
  store i64 %0, ptr %self, align 4
  %1 = load i64, ptr %self, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = getelementptr inbounds %User, ptr %2, i32 0, i32 0
  %4 = load i64, ptr %3, align 4
  %5 = inttoptr i64 %4 to ptr
  %6 = call i64 @strlen(ptr %5)
  %7 = call i64 @strlen(ptr @0)
  %8 = add i64 %6, %7
  %9 = add i64 %8, 1
  %10 = call ptr @malloc(i64 %9)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %6)
  %12 = ptrtoint ptr %10 to i64
  %13 = add i64 %12, %6
  %14 = inttoptr i64 %13 to ptr
  %15 = add i64 %7, 1
  %16 = call ptr @memcpy(ptr %14, ptr @0, i64 %15)
  %17 = ptrtoint ptr %10 to i64
  %18 = load i64, ptr %self, align 4
  %19 = inttoptr i64 %18 to ptr
  %20 = getelementptr inbounds %User, ptr %19, i32 0, i32 1
  %21 = load i64, ptr %20, align 4
  %22 = call ptr @malloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @1, i64 %21)
  %24 = ptrtoint ptr %22 to i64
  %25 = inttoptr i64 %17 to ptr
  %26 = inttoptr i64 %24 to ptr
  %27 = call i64 @strlen(ptr %25)
  %28 = call i64 @strlen(ptr %26)
  %29 = add i64 %27, %28
  %30 = add i64 %29, 1
  %31 = call ptr @malloc(i64 %30)
  %32 = call ptr @memcpy(ptr %31, ptr %25, i64 %27)
  %33 = ptrtoint ptr %31 to i64
  %34 = add i64 %33, %27
  %35 = inttoptr i64 %34 to ptr
  %36 = add i64 %28, 1
  %37 = call ptr @memcpy(ptr %35, ptr %26, i64 %36)
  %38 = ptrtoint ptr %31 to i64
  %39 = inttoptr i64 %38 to ptr
  %40 = call i64 @strlen(ptr %39)
  %41 = call i64 @strlen(ptr @2)
  %42 = add i64 %40, %41
  %43 = add i64 %42, 1
  %44 = call ptr @malloc(i64 %43)
  %45 = call ptr @memcpy(ptr %44, ptr %39, i64 %40)
  %46 = ptrtoint ptr %44 to i64
  %47 = add i64 %46, %40
  %48 = inttoptr i64 %47 to ptr
  %49 = add i64 %41, 1
  %50 = call ptr @memcpy(ptr %48, ptr @2, i64 %49)
  %51 = ptrtoint ptr %44 to i64
  ret i64 %51
}

define i64 @describe_role(i64 %0, i64 %1) {
bb2:
  %user = alloca i64, align 8
  store i64 %0, ptr %user, align 4
  %role = alloca i64, align 8
  store i64 %1, ptr %role, align 4
  %2 = load i64, ptr %user, align 4
  %3 = call i64 @User__greet(i64 %2)
  %base = alloca i64, align 8
  store i64 %3, ptr %base, align 4
  %4 = load i64, ptr %role, align 4
  %5 = inttoptr i64 %4 to ptr
  %6 = getelementptr inbounds %Role, ptr %5, i32 0, i32 0
  %7 = load i8, ptr %6, align 1
  %match_result = alloca i64, align 8
  store i64 0, ptr %match_result, align 4
  %8 = zext i8 %7 to i64
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %bb4, label %bb5

bb3:                                              ; preds = %bb9, %bb8, %bb6, %bb4
  %10 = load i64, ptr %match_result, align 4
  %role_str = alloca i64, align 8
  store i64 %10, ptr %role_str, align 4
  %11 = load i64, ptr %base, align 4
  %12 = inttoptr i64 %11 to ptr
  %13 = call i64 @strlen(ptr %12)
  %14 = call i64 @strlen(ptr @7)
  %15 = add i64 %13, %14
  %16 = add i64 %15, 1
  %17 = call ptr @malloc(i64 %16)
  %18 = call ptr @memcpy(ptr %17, ptr %12, i64 %13)
  %19 = ptrtoint ptr %17 to i64
  %20 = add i64 %19, %13
  %21 = inttoptr i64 %20 to ptr
  %22 = add i64 %14, 1
  %23 = call ptr @memcpy(ptr %21, ptr @7, i64 %22)
  %24 = ptrtoint ptr %17 to i64
  %25 = load i64, ptr %role_str, align 4
  %26 = inttoptr i64 %24 to ptr
  %27 = inttoptr i64 %25 to ptr
  %28 = call i64 @strlen(ptr %26)
  %29 = call i64 @strlen(ptr %27)
  %30 = add i64 %28, %29
  %31 = add i64 %30, 1
  %32 = call ptr @malloc(i64 %31)
  %33 = call ptr @memcpy(ptr %32, ptr %26, i64 %28)
  %34 = ptrtoint ptr %32 to i64
  %35 = add i64 %34, %28
  %36 = inttoptr i64 %35 to ptr
  %37 = add i64 %29, 1
  %38 = call ptr @memcpy(ptr %36, ptr %27, i64 %37)
  %39 = ptrtoint ptr %32 to i64
  ret i64 %39

bb4:                                              ; preds = %bb2
  store i64 ptrtoint (ptr @3 to i64), ptr %match_result, align 4
  br label %bb3

bb5:                                              ; preds = %bb2
  %40 = zext i8 %7 to i64
  %41 = icmp eq i64 %40, 1
  br i1 %41, label %bb6, label %bb7

bb6:                                              ; preds = %bb5
  %42 = getelementptr inbounds %Role, ptr %5, i32 0, i32 1
  %43 = load i64, ptr %42, align 4
  %lvl = alloca i64, align 8
  store i64 %43, ptr %lvl, align 4
  %44 = load i64, ptr %lvl, align 4
  %45 = call ptr @malloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @5, i64 %44)
  %47 = ptrtoint ptr %45 to i64
  %48 = inttoptr i64 %47 to ptr
  %49 = call i64 @strlen(ptr @4)
  %50 = call i64 @strlen(ptr %48)
  %51 = add i64 %49, %50
  %52 = add i64 %51, 1
  %53 = call ptr @malloc(i64 %52)
  %54 = call ptr @memcpy(ptr %53, ptr @4, i64 %49)
  %55 = ptrtoint ptr %53 to i64
  %56 = add i64 %55, %49
  %57 = inttoptr i64 %56 to ptr
  %58 = add i64 %50, 1
  %59 = call ptr @memcpy(ptr %57, ptr %48, i64 %58)
  %60 = ptrtoint ptr %53 to i64
  store i64 %60, ptr %match_result, align 4
  br label %bb3

bb7:                                              ; preds = %bb5
  %61 = zext i8 %7 to i64
  %62 = icmp eq i64 %61, 2
  br i1 %62, label %bb8, label %bb9

bb8:                                              ; preds = %bb7
  store i64 ptrtoint (ptr @6 to i64), ptr %match_result, align 4
  br label %bb3

bb9:                                              ; preds = %bb7
  br label %bb3
}

define i64 @main() {
bb0:
  %0 = call ptr @malloc(i64 16)
  %1 = getelementptr inbounds %User, ptr %0, i32 0, i32 0
  store i64 ptrtoint (ptr @8 to i64), ptr %1, align 4
  %2 = getelementptr inbounds %User, ptr %0, i32 0, i32 1
  store i64 30, ptr %2, align 4
  %3 = ptrtoint ptr %0 to i64
  store i64 %3, ptr @u, align 4
  %4 = load i64, ptr @u, align 4
  %5 = call ptr @malloc(i64 16)
  %6 = getelementptr inbounds %Role, ptr %5, i32 0, i32 0
  store i8 0, ptr %6, align 1
  %7 = ptrtoint ptr %5 to i64
  %8 = call i64 @describe_role(i64 %4, i64 %7)
  %9 = inttoptr i64 %8 to ptr
  %10 = call i32 @puts(ptr %9)
  %11 = load i64, ptr @u, align 4
  %12 = call ptr @malloc(i64 16)
  %13 = getelementptr inbounds %Role, ptr %12, i32 0, i32 0
  store i8 1, ptr %13, align 1
  %14 = getelementptr inbounds %Role, ptr %12, i32 0, i32 1
  store i64 3, ptr %14, align 4
  %15 = ptrtoint ptr %12 to i64
  %16 = call i64 @describe_role(i64 %11, i64 %15)
  %17 = inttoptr i64 %16 to ptr
  %18 = call i32 @puts(ptr %17)
  %19 = load i64, ptr @u, align 4
  %20 = call ptr @malloc(i64 16)
  %21 = getelementptr inbounds %Role, ptr %20, i32 0, i32 0
  store i8 2, ptr %21, align 1
  %22 = ptrtoint ptr %20 to i64
  %23 = call i64 @describe_role(i64 %19, i64 %22)
  %24 = inttoptr i64 %23 to ptr
  %25 = call i32 @puts(ptr %24)
  ret i64 0
}
