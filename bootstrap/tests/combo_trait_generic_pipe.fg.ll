; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Circle = type { i64 }
%Square = type { i64 }

@c = global i64 0
@s = global i64 0
@0 = private unnamed_addr constant [8 x i8] c"circle(\00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [2 x i8] c")\00", align 1
@3 = private unnamed_addr constant [8 x i8] c"square(\00", align 1
@4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@5 = private unnamed_addr constant [2 x i8] c")\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @Circle__describe(i64 %0) {
bb1:
  %self = alloca i64, align 8
  store i64 %0, ptr %self, align 4
  %1 = load i64, ptr %self, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = getelementptr inbounds %Circle, ptr %2, i32 0, i32 0
  %4 = load i64, ptr %3, align 4
  %5 = call ptr @malloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @1, i64 %4)
  %7 = ptrtoint ptr %5 to i64
  %8 = inttoptr i64 %7 to ptr
  %9 = call i64 @strlen(ptr @0)
  %10 = call i64 @strlen(ptr %8)
  %11 = add i64 %9, %10
  %12 = add i64 %11, 1
  %13 = call ptr @malloc(i64 %12)
  %14 = call ptr @memcpy(ptr %13, ptr @0, i64 %9)
  %15 = ptrtoint ptr %13 to i64
  %16 = add i64 %15, %9
  %17 = inttoptr i64 %16 to ptr
  %18 = add i64 %10, 1
  %19 = call ptr @memcpy(ptr %17, ptr %8, i64 %18)
  %20 = ptrtoint ptr %13 to i64
  %21 = inttoptr i64 %20 to ptr
  %22 = call i64 @strlen(ptr %21)
  %23 = call i64 @strlen(ptr @2)
  %24 = add i64 %22, %23
  %25 = add i64 %24, 1
  %26 = call ptr @malloc(i64 %25)
  %27 = call ptr @memcpy(ptr %26, ptr %21, i64 %22)
  %28 = ptrtoint ptr %26 to i64
  %29 = add i64 %28, %22
  %30 = inttoptr i64 %29 to ptr
  %31 = add i64 %23, 1
  %32 = call ptr @memcpy(ptr %30, ptr @2, i64 %31)
  %33 = ptrtoint ptr %26 to i64
  ret i64 %33
}

define i64 @Square__describe(i64 %0) {
bb2:
  %self = alloca i64, align 8
  store i64 %0, ptr %self, align 4
  %1 = load i64, ptr %self, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = getelementptr inbounds %Square, ptr %2, i32 0, i32 0
  %4 = load i64, ptr %3, align 4
  %5 = call ptr @malloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @4, i64 %4)
  %7 = ptrtoint ptr %5 to i64
  %8 = inttoptr i64 %7 to ptr
  %9 = call i64 @strlen(ptr @3)
  %10 = call i64 @strlen(ptr %8)
  %11 = add i64 %9, %10
  %12 = add i64 %11, 1
  %13 = call ptr @malloc(i64 %12)
  %14 = call ptr @memcpy(ptr %13, ptr @3, i64 %9)
  %15 = ptrtoint ptr %13 to i64
  %16 = add i64 %15, %9
  %17 = inttoptr i64 %16 to ptr
  %18 = add i64 %10, 1
  %19 = call ptr @memcpy(ptr %17, ptr %8, i64 %18)
  %20 = ptrtoint ptr %13 to i64
  %21 = inttoptr i64 %20 to ptr
  %22 = call i64 @strlen(ptr %21)
  %23 = call i64 @strlen(ptr @5)
  %24 = add i64 %22, %23
  %25 = add i64 %24, 1
  %26 = call ptr @malloc(i64 %25)
  %27 = call ptr @memcpy(ptr %26, ptr %21, i64 %22)
  %28 = ptrtoint ptr %26 to i64
  %29 = add i64 %28, %22
  %30 = inttoptr i64 %29 to ptr
  %31 = add i64 %23, 1
  %32 = call ptr @memcpy(ptr %30, ptr @5, i64 %31)
  %33 = ptrtoint ptr %26 to i64
  ret i64 %33
}

define i64 @print_desc(i64 %0) {
bb3:
  %s = alloca i64, align 8
  store i64 %0, ptr %s, align 4
  %1 = load i64, ptr %s, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = call i32 @puts(ptr %2)
  %4 = load i64, ptr %s, align 4
  ret i64 %4
}

define i64 @main() {
bb0:
  %0 = call ptr @malloc(i64 8)
  %1 = getelementptr inbounds %Circle, ptr %0, i32 0, i32 0
  store i64 5, ptr %1, align 4
  %2 = ptrtoint ptr %0 to i64
  store i64 %2, ptr @c, align 4
  %3 = call ptr @malloc(i64 8)
  %4 = getelementptr inbounds %Square, ptr %3, i32 0, i32 0
  store i64 4, ptr %4, align 4
  %5 = ptrtoint ptr %3 to i64
  store i64 %5, ptr @s, align 4
  %6 = load i64, ptr @c, align 4
  %7 = call i64 @Circle__describe(i64 %6)
  %8 = call i64 @print_desc(i64 %7)
  %9 = load i64, ptr @s, align 4
  %10 = call i64 @Square__describe(i64 %9)
  %11 = call i64 @print_desc(i64 %10)
  ret i64 0
}
