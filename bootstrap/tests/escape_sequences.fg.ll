; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@0 = private unnamed_addr constant [12 x i8] c"hello\0Aworld\00", align 1
@1 = private unnamed_addr constant [9 x i8] c"tab\09here\00", align 1
@2 = private unnamed_addr constant [13 x i8] c"quote\22inside\00", align 1
@3 = private unnamed_addr constant [11 x i8] c"back\\slash\00", align 1

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
  %0 = call i32 @puts(ptr @0)
  %1 = call i32 @puts(ptr @1)
  %2 = call i32 @puts(ptr @2)
  %3 = call i32 @puts(ptr @3)
  ret i64 0
}
