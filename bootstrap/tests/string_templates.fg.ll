; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@name = global i64 0
@greeting = global i64 0
@x = global i64 0
@msg = global i64 0
@a = global i64 0
@b = global i64 0
@sum = global i64 0
@empty = global i64 0
@plain = global i64 0
@p1 = global i64 0
@p2 = global i64 0
@0 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@1 = private unnamed_addr constant [7 x i8] c"hello \00", align 1
@2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@3 = private unnamed_addr constant [15 x i8] c"the answer is \00", align 1
@4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@7 = private unnamed_addr constant [4 x i8] c" + \00", align 1
@8 = private unnamed_addr constant [4 x i8] c" = \00", align 1
@9 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@10 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@11 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@12 = private unnamed_addr constant [10 x i8] c"just text\00", align 1
@13 = private unnamed_addr constant [3 x i8] c"ab\00", align 1
@14 = private unnamed_addr constant [3 x i8] c"cd\00", align 1

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
  store i64 ptrtoint (ptr @0 to i64), ptr @name, align 4
  %0 = load i64, ptr @name, align 4
  %1 = inttoptr i64 %0 to ptr
  %2 = call i64 @strlen(ptr @1)
  %3 = call i64 @strlen(ptr %1)
  %4 = add i64 %2, %3
  %5 = add i64 %4, 1
  %6 = call ptr @malloc(i64 %5)
  %7 = call ptr @memcpy(ptr %6, ptr @1, i64 %2)
  %8 = ptrtoint ptr %6 to i64
  %9 = add i64 %8, %2
  %10 = inttoptr i64 %9 to ptr
  %11 = add i64 %3, 1
  %12 = call ptr @memcpy(ptr %10, ptr %1, i64 %11)
  %13 = ptrtoint ptr %6 to i64
  store i64 %13, ptr @greeting, align 4
  %14 = load i64, ptr @greeting, align 4
  %15 = inttoptr i64 %14 to ptr
  %16 = call i32 @puts(ptr %15)
  %17 = call ptr @malloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @2, i64 42)
  %19 = ptrtoint ptr %17 to i64
  store i64 %19, ptr @x, align 4
  %20 = load i64, ptr @x, align 4
  %21 = inttoptr i64 %20 to ptr
  %22 = call i64 @strlen(ptr @3)
  %23 = call i64 @strlen(ptr %21)
  %24 = add i64 %22, %23
  %25 = add i64 %24, 1
  %26 = call ptr @malloc(i64 %25)
  %27 = call ptr @memcpy(ptr %26, ptr @3, i64 %22)
  %28 = ptrtoint ptr %26 to i64
  %29 = add i64 %28, %22
  %30 = inttoptr i64 %29 to ptr
  %31 = add i64 %23, 1
  %32 = call ptr @memcpy(ptr %30, ptr %21, i64 %31)
  %33 = ptrtoint ptr %26 to i64
  store i64 %33, ptr @msg, align 4
  %34 = load i64, ptr @msg, align 4
  %35 = inttoptr i64 %34 to ptr
  %36 = call i32 @puts(ptr %35)
  %37 = call ptr @malloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @4, i64 3)
  %39 = ptrtoint ptr %37 to i64
  store i64 %39, ptr @a, align 4
  %40 = call ptr @malloc(i64 32)
  %41 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %40, i64 32, ptr @5, i64 4)
  %42 = ptrtoint ptr %40 to i64
  store i64 %42, ptr @b, align 4
  %43 = call ptr @malloc(i64 32)
  %44 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %43, i64 32, ptr @6, i64 7)
  %45 = ptrtoint ptr %43 to i64
  store i64 %45, ptr @sum, align 4
  %46 = load i64, ptr @a, align 4
  %47 = inttoptr i64 %46 to ptr
  %48 = call i64 @strlen(ptr %47)
  %49 = call i64 @strlen(ptr @7)
  %50 = add i64 %48, %49
  %51 = add i64 %50, 1
  %52 = call ptr @malloc(i64 %51)
  %53 = call ptr @memcpy(ptr %52, ptr %47, i64 %48)
  %54 = ptrtoint ptr %52 to i64
  %55 = add i64 %54, %48
  %56 = inttoptr i64 %55 to ptr
  %57 = add i64 %49, 1
  %58 = call ptr @memcpy(ptr %56, ptr @7, i64 %57)
  %59 = ptrtoint ptr %52 to i64
  %60 = load i64, ptr @b, align 4
  %61 = inttoptr i64 %59 to ptr
  %62 = inttoptr i64 %60 to ptr
  %63 = call i64 @strlen(ptr %61)
  %64 = call i64 @strlen(ptr %62)
  %65 = add i64 %63, %64
  %66 = add i64 %65, 1
  %67 = call ptr @malloc(i64 %66)
  %68 = call ptr @memcpy(ptr %67, ptr %61, i64 %63)
  %69 = ptrtoint ptr %67 to i64
  %70 = add i64 %69, %63
  %71 = inttoptr i64 %70 to ptr
  %72 = add i64 %64, 1
  %73 = call ptr @memcpy(ptr %71, ptr %62, i64 %72)
  %74 = ptrtoint ptr %67 to i64
  %75 = inttoptr i64 %74 to ptr
  %76 = call i64 @strlen(ptr %75)
  %77 = call i64 @strlen(ptr @8)
  %78 = add i64 %76, %77
  %79 = add i64 %78, 1
  %80 = call ptr @malloc(i64 %79)
  %81 = call ptr @memcpy(ptr %80, ptr %75, i64 %76)
  %82 = ptrtoint ptr %80 to i64
  %83 = add i64 %82, %76
  %84 = inttoptr i64 %83 to ptr
  %85 = add i64 %77, 1
  %86 = call ptr @memcpy(ptr %84, ptr @8, i64 %85)
  %87 = ptrtoint ptr %80 to i64
  %88 = load i64, ptr @sum, align 4
  %89 = inttoptr i64 %87 to ptr
  %90 = inttoptr i64 %88 to ptr
  %91 = call i64 @strlen(ptr %89)
  %92 = call i64 @strlen(ptr %90)
  %93 = add i64 %91, %92
  %94 = add i64 %93, 1
  %95 = call ptr @malloc(i64 %94)
  %96 = call ptr @memcpy(ptr %95, ptr %89, i64 %91)
  %97 = ptrtoint ptr %95 to i64
  %98 = add i64 %97, %91
  %99 = inttoptr i64 %98 to ptr
  %100 = add i64 %92, 1
  %101 = call ptr @memcpy(ptr %99, ptr %90, i64 %100)
  %102 = ptrtoint ptr %95 to i64
  %103 = inttoptr i64 %102 to ptr
  %104 = call i32 @puts(ptr %103)
  store i64 ptrtoint (ptr @9 to i64), ptr @empty, align 4
  %105 = load i64, ptr @empty, align 4
  %106 = inttoptr i64 %105 to ptr
  %107 = call i64 @strlen(ptr @10)
  %108 = call i64 @strlen(ptr %106)
  %109 = add i64 %107, %108
  %110 = add i64 %109, 1
  %111 = call ptr @malloc(i64 %110)
  %112 = call ptr @memcpy(ptr %111, ptr @10, i64 %107)
  %113 = ptrtoint ptr %111 to i64
  %114 = add i64 %113, %107
  %115 = inttoptr i64 %114 to ptr
  %116 = add i64 %108, 1
  %117 = call ptr @memcpy(ptr %115, ptr %106, i64 %116)
  %118 = ptrtoint ptr %111 to i64
  %119 = inttoptr i64 %118 to ptr
  %120 = call i64 @strlen(ptr %119)
  %121 = call i64 @strlen(ptr @11)
  %122 = add i64 %120, %121
  %123 = add i64 %122, 1
  %124 = call ptr @malloc(i64 %123)
  %125 = call ptr @memcpy(ptr %124, ptr %119, i64 %120)
  %126 = ptrtoint ptr %124 to i64
  %127 = add i64 %126, %120
  %128 = inttoptr i64 %127 to ptr
  %129 = add i64 %121, 1
  %130 = call ptr @memcpy(ptr %128, ptr @11, i64 %129)
  %131 = ptrtoint ptr %124 to i64
  %132 = inttoptr i64 %131 to ptr
  %133 = call i32 @puts(ptr %132)
  store i64 ptrtoint (ptr @12 to i64), ptr @plain, align 4
  %134 = load i64, ptr @plain, align 4
  %135 = inttoptr i64 %134 to ptr
  %136 = call i32 @puts(ptr %135)
  store i64 ptrtoint (ptr @13 to i64), ptr @p1, align 4
  store i64 ptrtoint (ptr @14 to i64), ptr @p2, align 4
  %137 = load i64, ptr @p1, align 4
  %138 = load i64, ptr @p2, align 4
  %139 = inttoptr i64 %137 to ptr
  %140 = inttoptr i64 %138 to ptr
  %141 = call i64 @strlen(ptr %139)
  %142 = call i64 @strlen(ptr %140)
  %143 = add i64 %141, %142
  %144 = add i64 %143, 1
  %145 = call ptr @malloc(i64 %144)
  %146 = call ptr @memcpy(ptr %145, ptr %139, i64 %141)
  %147 = ptrtoint ptr %145 to i64
  %148 = add i64 %147, %141
  %149 = inttoptr i64 %148 to ptr
  %150 = add i64 %142, 1
  %151 = call ptr @memcpy(ptr %149, ptr %140, i64 %150)
  %152 = ptrtoint ptr %145 to i64
  %153 = inttoptr i64 %152 to ptr
  %154 = call i32 @puts(ptr %153)
  ret i64 0
}
