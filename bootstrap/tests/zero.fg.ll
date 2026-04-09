; ModuleID = 'bootstrap'
source_filename = "bootstrap"

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
  ret i64 0
}

define i64 @__bs_top_level() {
bb0:
  ret i64 0
}
