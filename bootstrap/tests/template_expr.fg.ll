; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { i64, i64 }

@x = global i64 0
@a = global i64 0
@b = global i64 0
@p = global i64 0
@name = global i64 0
@0 = private unnamed_addr constant [15 x i8] c"the answer is \00", align 1
@1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@3 = private unnamed_addr constant [4 x i8] c" + \00", align 1
@4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@5 = private unnamed_addr constant [4 x i8] c" = \00", align 1
@6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@7 = private unnamed_addr constant [8 x i8] c"point: \00", align 1
@8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@9 = private unnamed_addr constant [3 x i8] c", \00", align 1
@10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@11 = private unnamed_addr constant [12 x i8] c"double 5 = \00", align 1
@12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@13 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@14 = private unnamed_addr constant [7 x i8] c"hello \00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @double(i64 %0) {
bb1:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %1 = load i64, ptr %n, align 4
  %2 = mul i64 %1, 2
  ret i64 %2
}

define i64 @main() {
bb0:
  store i64 42, ptr @x, align 4
  %0 = load i64, ptr @x, align 4
  %1 = call ptr @malloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @1, i64 %0)
  %3 = ptrtoint ptr %1 to i64
  %4 = inttoptr i64 %3 to ptr
  %5 = call i64 @strlen(ptr @0)
  %6 = call i64 @strlen(ptr %4)
  %7 = add i64 %5, %6
  %8 = add i64 %7, 1
  %9 = call ptr @malloc(i64 %8)
  %10 = call ptr @memcpy(ptr %9, ptr @0, i64 %5)
  %11 = ptrtoint ptr %9 to i64
  %12 = add i64 %11, %5
  %13 = inttoptr i64 %12 to ptr
  %14 = add i64 %6, 1
  %15 = call ptr @memcpy(ptr %13, ptr %4, i64 %14)
  %16 = ptrtoint ptr %9 to i64
  %17 = inttoptr i64 %16 to ptr
  %18 = call i32 @puts(ptr %17)
  store i64 3, ptr @a, align 4
  store i64 4, ptr @b, align 4
  %19 = load i64, ptr @a, align 4
  %20 = call ptr @malloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @2, i64 %19)
  %22 = ptrtoint ptr %20 to i64
  %23 = inttoptr i64 %22 to ptr
  %24 = call i64 @strlen(ptr %23)
  %25 = call i64 @strlen(ptr @3)
  %26 = add i64 %24, %25
  %27 = add i64 %26, 1
  %28 = call ptr @malloc(i64 %27)
  %29 = call ptr @memcpy(ptr %28, ptr %23, i64 %24)
  %30 = ptrtoint ptr %28 to i64
  %31 = add i64 %30, %24
  %32 = inttoptr i64 %31 to ptr
  %33 = add i64 %25, 1
  %34 = call ptr @memcpy(ptr %32, ptr @3, i64 %33)
  %35 = ptrtoint ptr %28 to i64
  %36 = load i64, ptr @b, align 4
  %37 = call ptr @malloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @4, i64 %36)
  %39 = ptrtoint ptr %37 to i64
  %40 = inttoptr i64 %35 to ptr
  %41 = inttoptr i64 %39 to ptr
  %42 = call i64 @strlen(ptr %40)
  %43 = call i64 @strlen(ptr %41)
  %44 = add i64 %42, %43
  %45 = add i64 %44, 1
  %46 = call ptr @malloc(i64 %45)
  %47 = call ptr @memcpy(ptr %46, ptr %40, i64 %42)
  %48 = ptrtoint ptr %46 to i64
  %49 = add i64 %48, %42
  %50 = inttoptr i64 %49 to ptr
  %51 = add i64 %43, 1
  %52 = call ptr @memcpy(ptr %50, ptr %41, i64 %51)
  %53 = ptrtoint ptr %46 to i64
  %54 = inttoptr i64 %53 to ptr
  %55 = call i64 @strlen(ptr %54)
  %56 = call i64 @strlen(ptr @5)
  %57 = add i64 %55, %56
  %58 = add i64 %57, 1
  %59 = call ptr @malloc(i64 %58)
  %60 = call ptr @memcpy(ptr %59, ptr %54, i64 %55)
  %61 = ptrtoint ptr %59 to i64
  %62 = add i64 %61, %55
  %63 = inttoptr i64 %62 to ptr
  %64 = add i64 %56, 1
  %65 = call ptr @memcpy(ptr %63, ptr @5, i64 %64)
  %66 = ptrtoint ptr %59 to i64
  %67 = load i64, ptr @a, align 4
  %68 = load i64, ptr @b, align 4
  %69 = add i64 %67, %68
  %70 = call ptr @malloc(i64 32)
  %71 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %70, i64 32, ptr @6, i64 %69)
  %72 = ptrtoint ptr %70 to i64
  %73 = inttoptr i64 %66 to ptr
  %74 = inttoptr i64 %72 to ptr
  %75 = call i64 @strlen(ptr %73)
  %76 = call i64 @strlen(ptr %74)
  %77 = add i64 %75, %76
  %78 = add i64 %77, 1
  %79 = call ptr @malloc(i64 %78)
  %80 = call ptr @memcpy(ptr %79, ptr %73, i64 %75)
  %81 = ptrtoint ptr %79 to i64
  %82 = add i64 %81, %75
  %83 = inttoptr i64 %82 to ptr
  %84 = add i64 %76, 1
  %85 = call ptr @memcpy(ptr %83, ptr %74, i64 %84)
  %86 = ptrtoint ptr %79 to i64
  %87 = inttoptr i64 %86 to ptr
  %88 = call i32 @puts(ptr %87)
  %89 = call ptr @malloc(i64 16)
  %90 = getelementptr inbounds %Point, ptr %89, i32 0, i32 0
  store i64 10, ptr %90, align 4
  %91 = getelementptr inbounds %Point, ptr %89, i32 0, i32 1
  store i64 20, ptr %91, align 4
  %92 = ptrtoint ptr %89 to i64
  store i64 %92, ptr @p, align 4
  %93 = load i64, ptr @p, align 4
  %94 = inttoptr i64 %93 to ptr
  %95 = getelementptr inbounds %Point, ptr %94, i32 0, i32 0
  %96 = load i64, ptr %95, align 4
  %97 = call ptr @malloc(i64 32)
  %98 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %97, i64 32, ptr @8, i64 %96)
  %99 = ptrtoint ptr %97 to i64
  %100 = inttoptr i64 %99 to ptr
  %101 = call i64 @strlen(ptr @7)
  %102 = call i64 @strlen(ptr %100)
  %103 = add i64 %101, %102
  %104 = add i64 %103, 1
  %105 = call ptr @malloc(i64 %104)
  %106 = call ptr @memcpy(ptr %105, ptr @7, i64 %101)
  %107 = ptrtoint ptr %105 to i64
  %108 = add i64 %107, %101
  %109 = inttoptr i64 %108 to ptr
  %110 = add i64 %102, 1
  %111 = call ptr @memcpy(ptr %109, ptr %100, i64 %110)
  %112 = ptrtoint ptr %105 to i64
  %113 = inttoptr i64 %112 to ptr
  %114 = call i64 @strlen(ptr %113)
  %115 = call i64 @strlen(ptr @9)
  %116 = add i64 %114, %115
  %117 = add i64 %116, 1
  %118 = call ptr @malloc(i64 %117)
  %119 = call ptr @memcpy(ptr %118, ptr %113, i64 %114)
  %120 = ptrtoint ptr %118 to i64
  %121 = add i64 %120, %114
  %122 = inttoptr i64 %121 to ptr
  %123 = add i64 %115, 1
  %124 = call ptr @memcpy(ptr %122, ptr @9, i64 %123)
  %125 = ptrtoint ptr %118 to i64
  %126 = load i64, ptr @p, align 4
  %127 = inttoptr i64 %126 to ptr
  %128 = getelementptr inbounds %Point, ptr %127, i32 0, i32 1
  %129 = load i64, ptr %128, align 4
  %130 = call ptr @malloc(i64 32)
  %131 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %130, i64 32, ptr @10, i64 %129)
  %132 = ptrtoint ptr %130 to i64
  %133 = inttoptr i64 %125 to ptr
  %134 = inttoptr i64 %132 to ptr
  %135 = call i64 @strlen(ptr %133)
  %136 = call i64 @strlen(ptr %134)
  %137 = add i64 %135, %136
  %138 = add i64 %137, 1
  %139 = call ptr @malloc(i64 %138)
  %140 = call ptr @memcpy(ptr %139, ptr %133, i64 %135)
  %141 = ptrtoint ptr %139 to i64
  %142 = add i64 %141, %135
  %143 = inttoptr i64 %142 to ptr
  %144 = add i64 %136, 1
  %145 = call ptr @memcpy(ptr %143, ptr %134, i64 %144)
  %146 = ptrtoint ptr %139 to i64
  %147 = inttoptr i64 %146 to ptr
  %148 = call i32 @puts(ptr %147)
  %149 = call i64 @double(i64 5)
  %150 = call ptr @malloc(i64 32)
  %151 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %150, i64 32, ptr @12, i64 %149)
  %152 = ptrtoint ptr %150 to i64
  %153 = inttoptr i64 %152 to ptr
  %154 = call i64 @strlen(ptr @11)
  %155 = call i64 @strlen(ptr %153)
  %156 = add i64 %154, %155
  %157 = add i64 %156, 1
  %158 = call ptr @malloc(i64 %157)
  %159 = call ptr @memcpy(ptr %158, ptr @11, i64 %154)
  %160 = ptrtoint ptr %158 to i64
  %161 = add i64 %160, %154
  %162 = inttoptr i64 %161 to ptr
  %163 = add i64 %155, 1
  %164 = call ptr @memcpy(ptr %162, ptr %153, i64 %163)
  %165 = ptrtoint ptr %158 to i64
  %166 = inttoptr i64 %165 to ptr
  %167 = call i32 @puts(ptr %166)
  store i64 ptrtoint (ptr @13 to i64), ptr @name, align 4
  %168 = load i64, ptr @name, align 4
  %169 = inttoptr i64 %168 to ptr
  %170 = call i64 @strlen(ptr @14)
  %171 = call i64 @strlen(ptr %169)
  %172 = add i64 %170, %171
  %173 = add i64 %172, 1
  %174 = call ptr @malloc(i64 %173)
  %175 = call ptr @memcpy(ptr %174, ptr @14, i64 %170)
  %176 = ptrtoint ptr %174 to i64
  %177 = add i64 %176, %170
  %178 = inttoptr i64 %177 to ptr
  %179 = add i64 %171, 1
  %180 = call ptr @memcpy(ptr %178, ptr %169, i64 %179)
  %181 = ptrtoint ptr %174 to i64
  %182 = inttoptr i64 %181 to ptr
  %183 = call i32 @puts(ptr %182)
  ret i64 0
}
