; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }

@0 = constant [29 x i8] c"hello from self-hosted Forge!"

declare void @forge_println_string(%ForgeString)

declare %ForgeString @forge_int_to_string(i64)

declare %ForgeString @forge_string_new(ptr, i64)

declare %ForgeString @forge_string_concat(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_char_at(%ForgeString, i64)

declare i64 @forge_string_length(%ForgeString)

declare i8 @forge_string_eq(%ForgeString, %ForgeString)

declare i64 @forge_string_compare(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_substring(%ForgeString, i64, i64)

declare i64 @forge_string_index_of(%ForgeString, %ForgeString)

declare ptr @forge_alloc(i64)

declare void @forge_memcpy(ptr, ptr, i64)

declare ptr @forge_map_new()

declare i8 @forge_map_has(ptr, %ForgeString)

declare i64 @forge_map_get(ptr, %ForgeString)

declare void @forge_map_set(ptr, %ForgeString, i64)

declare void @forge_set_args(i32, ptr)

declare %ForgeString @forge_selfhost_process_args()

declare %ForgeString @forge_selfhost_fs_read(%ForgeString)

declare void @forge_selfhost_process_exit(i64)

declare %ForgeString @forge_selfhost_process_run(%ForgeString, %ForgeString)

declare void @forge_eprintln_string(%ForgeString)

define i32 @main() {
  call void @forge_println_string({ ptr, i64 } { ptr @0, i64 29 })
  ret i32 0
}
