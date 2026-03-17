; ModuleID = '/tmp/hello.fg'
source_filename = "/tmp/hello.fg"

declare void @forge_println(ptr, i64)

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)
