; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Dog = type { i64 }
%Cat = type { i64 }

@d = global i64 0
@c = global i64 0
@0 = private unnamed_addr constant [11 x i8] c"meow from \00", align 1
@1 = private unnamed_addr constant [4 x i8] c"Rex\00", align 1
@2 = private unnamed_addr constant [9 x i8] c"Whiskers\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @Dog__display(i64 %0) {
bb1:
  %self = alloca i64, align 8
  store i64 %0, ptr %self, align 4
  %1 = load i64, ptr %self, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = getelementptr inbounds %Dog, ptr %2, i32 0, i32 0
  %4 = load i64, ptr %3, align 4
  ret i64 %4
}

define i64 @Cat__display(i64 %0) {
bb2:
  %self = alloca i64, align 8
  store i64 %0, ptr %self, align 4
  %1 = load i64, ptr %self, align 4
  %2 = inttoptr i64 %1 to ptr
  %3 = getelementptr inbounds %Cat, ptr %2, i32 0, i32 0
  %4 = load i64, ptr %3, align 4
  %5 = inttoptr i64 %4 to ptr
  %6 = call i64 @strlen(ptr @0)
  %7 = call i64 @strlen(ptr %5)
  %8 = add i64 %6, %7
  %9 = add i64 %8, 1
  %10 = call ptr @malloc(i64 %9)
  %11 = call ptr @memcpy(ptr %10, ptr @0, i64 %6)
  %12 = ptrtoint ptr %10 to i64
  %13 = add i64 %12, %6
  %14 = inttoptr i64 %13 to ptr
  %15 = add i64 %7, 1
  %16 = call ptr @memcpy(ptr %14, ptr %5, i64 %15)
  %17 = ptrtoint ptr %10 to i64
  ret i64 %17
}

define i64 @main() {
bb0:
  %0 = call ptr @malloc(i64 8)
  %1 = getelementptr inbounds %Dog, ptr %0, i32 0, i32 0
  store i64 ptrtoint (ptr @1 to i64), ptr %1, align 4
  %2 = ptrtoint ptr %0 to i64
  store i64 %2, ptr @d, align 4
  %3 = load i64, ptr @d, align 4
  %4 = call i64 @Dog__display(i64 %3)
  %5 = inttoptr i64 %4 to ptr
  %6 = call i32 @puts(ptr %5)
  %7 = call ptr @malloc(i64 8)
  %8 = getelementptr inbounds %Cat, ptr %7, i32 0, i32 0
  store i64 ptrtoint (ptr @2 to i64), ptr %8, align 4
  %9 = ptrtoint ptr %7 to i64
  store i64 %9, ptr @c, align 4
  %10 = load i64, ptr @c, align 4
  %11 = call i64 @Cat__display(i64 %10)
  %12 = inttoptr i64 %11 to ptr
  %13 = call i32 @puts(ptr %12)
  ret i64 0
}
