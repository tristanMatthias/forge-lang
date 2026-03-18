; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [2 x i8] c"(\00", align 1
@str.1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@str.2 = private unnamed_addr constant [2 x i8] c")\00", align 1
@str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@str.4 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@str.5 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@str.6 = private unnamed_addr constant [6 x i8] c"done!\00", align 1

declare void @forge_println_string({ ptr, i64 })

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)

declare { ptr, i64 } @forge_string_concat({ ptr, i64 }, { ptr, i64 })

declare { ptr, i64 } @forge_string_char_at({ ptr, i64 }, i64)

declare i64 @forge_string_length({ ptr, i64 })

declare i8 @forge_string_eq({ ptr, i64 }, { ptr, i64 })

declare { ptr, i64 } @forge_string_substring({ ptr, i64 }, i64, i64)

declare i64 @forge_string_index_of({ ptr, i64 }, { ptr, i64 })

declare ptr @forge_alloc(i64)

declare void @forge_memcpy(ptr, ptr, i64)

declare ptr @forge_map_new()

declare i8 @forge_map_has(ptr, { ptr, i64 })

declare i64 @forge_map_get(ptr, { ptr, i64 })

declare void @forge_map_set(ptr, { ptr, i64 }, i64)

define i64 @lex_char(i64 %0) {
entry:
  %ch = alloca i64, align 8
  store i64 %0, ptr %ch, align 4
  %ch1 = load i64, ptr %ch, align 4
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 1)
  %eq = icmp eq i64 %ch1, { ptr, i64 } %str
  %cmpext = zext i1 %eq to i64
  %__bt1 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt1, align 4
  %__bt12 = load i64, ptr %__bt1, align 4
  %ifcond = trunc i64 %__bt12 to i1
  br i1 %ifcond, label %then, label %ifcont

common.ret:                                       ; preds = %ifcont12, %then10, %then
  ret i64 0

then:                                             ; preds = %entry
  %str3 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 0)
  %sf = insertvalue { i64, { ptr, i64 } } { i64 0, { ptr, i64 } undef }, { ptr, i64 } %str3, 1
  %__struct2 = alloca { i64, { ptr, i64 } }, align 8
  store { i64, { ptr, i64 } } %sf, ptr %__struct2, align 8
  br label %common.ret

ifcont:                                           ; preds = %entry
  %ch4 = load i64, ptr %ch, align 4
  %str5 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 1)
  %eq6 = icmp eq i64 %ch4, { ptr, i64 } %str5
  %cmpext7 = zext i1 %eq6 to i64
  %__bt3 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %cmpext7, ptr %__bt3, align 4
  %__bt38 = load i64, ptr %__bt3, align 4
  %ifcond9 = trunc i64 %__bt38 to i1
  br i1 %ifcond9, label %then10, label %ifcont12

then10:                                           ; preds = %ifcont
  %str13 = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 0)
  %sf14 = insertvalue { i64, { ptr, i64 } } { i64 0, { ptr, i64 } undef }, { ptr, i64 } %str13, 1
  %__struct4 = alloca { i64, { ptr, i64 } }, align 8
  store { i64, { ptr, i64 } } %sf14, ptr %__struct4, align 8
  br label %common.ret

ifcont12:                                         ; preds = %ifcont
  %ch15 = load i64, ptr %ch, align 4
  %sf16 = insertvalue { i64, i64 } { i64 1, i64 undef }, i64 %ch15, 1
  %__struct5 = alloca { i64, i64 }, align 8
  store { i64, i64 } %sf16, ptr %__struct5, align 4
  br label %common.ret
}

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str.4, i64 1)
  %call = call i64 @lex_char({ ptr, i64 } %str)
  %tok = alloca { i64, i64 }, align 8
  store i64 %call, ptr %tok, align 4
  %tok1 = load { i64, i64 }, ptr %tok, align 4
  %kind_id = extractvalue { i64, i64 } %tok1, 0
  %__pt6 = alloca i64, align 8
  store i64 %kind_id, ptr %__pt6, align 4
  %__pt62 = load i64, ptr %__pt6, align 4
  %kid = alloca i64, align 8
  store i64 %__pt62, ptr %kid, align 4
  %tok3 = load { i64, i64 }, ptr %tok, align 4
  %text = extractvalue { i64, i64 } %tok3, 1
  %__pt7 = alloca i64, align 8
  store i64 %text, ptr %__pt7, align 4
  %__pt74 = load i64, ptr %__pt7, align 4
  %txt = alloca i64, align 8
  store i64 %__pt74, ptr %txt, align 4
  %kid5 = load i64, ptr %kid, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %kid5)
  call void @forge_println_string({ ptr, i64 } %ts)
  %txt6 = load i64, ptr %txt, align 4
  %ts7 = call { ptr, i64 } @forge_int_to_string(i64 %txt6)
  call void @forge_println_string({ ptr, i64 } %ts7)
  %str8 = call { ptr, i64 } @forge_string_new(ptr @str.5, i64 1)
  %call9 = call i64 @lex_char({ ptr, i64 } %str8)
  %tok2 = alloca { ptr, i64 }, align 8
  store i64 %call9, ptr %tok2, align 4
  %tok210 = load { ptr, i64 }, ptr %tok2, align 8
  %ts11 = call { ptr, i64 } @forge_int_to_string(i64 0)
  call void @forge_println_string({ ptr, i64 } %ts11)
  %str12 = call { ptr, i64 } @forge_string_new(ptr @str.6, i64 5)
  call void @forge_println_string({ ptr, i64 } %str12)
  ret i32 0
}
