; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@0 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @esc(i64 %0) {
bb1:
  %t = alloca i64, align 8
  store i64 %0, ptr %t, align 4
  %o = alloca i64, align 8
  store i64 ptrtoint (ptr @0 to i64), ptr %o, align 4
  %i = alloca i64, align 8
  store i64 0, ptr %i, align 4
  br label %bb2

bb2:                                              ; preds = %bb3, %bb1
  %1 = load i64, ptr %i, align 4
  %2 = load i64, ptr %t, align 4
  %3 = inttoptr i64 %2 to ptr
  %4 = call i64 @strlen(ptr %3)
  %5 = icmp slt i64 %1, %4
  %6 = zext i1 %5 to i64
  %7 = icmp ne i64 %6, 0
  br i1 %7, label %bb3, label %bb4

bb3:                                              ; preds = %bb2
  %8 = load i64, ptr %t, align 4
  %9 = load i64, ptr %i, align 4
  %10 = add i64 %8, %9
  %11 = inttoptr i64 %10 to ptr
  %12 = load i8, ptr %11, align 1
  %13 = call ptr @malloc(i64 2)
  store i8 %12, ptr %13, align 1
  %14 = ptrtoint ptr %13 to i64
  %15 = add i64 %14, 1
  %16 = inttoptr i64 %15 to ptr
  store i8 0, ptr %16, align 1
  %17 = ptrtoint ptr %13 to i64
  %ch = alloca i64, align 8
  store i64 %17, ptr %ch, align 4
  %18 = load i64, ptr %o, align 4
  %19 = load i64, ptr %ch, align 4
  %20 = inttoptr i64 %18 to ptr
  %21 = inttoptr i64 %19 to ptr
  %22 = call i64 @strlen(ptr %20)
  %23 = call i64 @strlen(ptr %21)
  %24 = add i64 %22, %23
  %25 = add i64 %24, 1
  %26 = call ptr @malloc(i64 %25)
  %27 = call ptr @memcpy(ptr %26, ptr %20, i64 %22)
  %28 = ptrtoint ptr %26 to i64
  %29 = add i64 %28, %22
  %30 = inttoptr i64 %29 to ptr
  %31 = add i64 %23, 1
  %32 = call ptr @memcpy(ptr %30, ptr %21, i64 %31)
  %33 = ptrtoint ptr %26 to i64
  store i64 %33, ptr %o, align 4
  %34 = load i64, ptr %i, align 4
  %35 = add i64 %34, 1
  store i64 %35, ptr %i, align 4
  br label %bb2

bb4:                                              ; preds = %bb2
  %36 = load i64, ptr %o, align 4
  ret i64 %36
}

define i64 @main() {
bb5:
  %0 = call i64 @esc(i64 ptrtoint (ptr @1 to i64))
  %1 = inttoptr i64 %0 to ptr
  %2 = call i32 @puts(ptr %1)
  ret i64 0
}

define i64 @__bs_top_level() {
bb0:
  ret i64 0
}
