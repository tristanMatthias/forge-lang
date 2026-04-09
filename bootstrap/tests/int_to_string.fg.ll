; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@0 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

define i64 @main() {
bb1:
  %x = alloca i64, align 8
  store i64 42, ptr %x, align 4
  %0 = load i64, ptr %x, align 4
  %1 = call ptr @malloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @0, i64 %0)
  %3 = ptrtoint ptr %1 to i64
  %4 = inttoptr i64 %3 to ptr
  %5 = call i32 @puts(ptr %4)
  ret i64 0
}

define i64 @__bs_top_level() {
bb0:
  ret i64 0
}
