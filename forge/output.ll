; ModuleID = 'packages/forgec/src/core/token.fg'
source_filename = "packages/forgec/src/core/token.fg"

%ForgeString = type { ptr, i64 }
%Span = type { i64, i64, i64, i64 }
%Token = type { %TokenKind, %Span, %ForgeString, i64 }
%TokenKind = type { i8, i64, i64, i64, i64, i64, i64 }
%name = type { i8, i64 }
%value = type { i8, i64 }

@str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@str.1 = private unnamed_addr constant [5 x i8] c"true\00", align 1
@str.2 = private unnamed_addr constant [6 x i8] c"false\00", align 1

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

define %Span @span_new(i64 %0, i64 %1, i64 %2, i64 %3) {
entry:
  %start = alloca i64, align 8
  store i64 %0, ptr %start, align 4
  %end = alloca i64, align 8
  store i64 %1, ptr %end, align 4
  %line = alloca i64, align 8
  store i64 %2, ptr %line, align 4
  %col = alloca i64, align 8
  store i64 %3, ptr %col, align 4
  %start1 = load i64, ptr %start, align 4
  %end2 = load i64, ptr %end, align 4
  %line3 = load i64, ptr %line, align 4
  %col4 = load i64, ptr %col, align 4
  %sf = insertvalue { i64, i64, i64, i64 } undef, i64 %start1, 0
  %sf5 = insertvalue { i64, i64, i64, i64 } %sf, i64 %end2, 1
  %sf6 = insertvalue { i64, i64, i64, i64 } %sf5, i64 %line3, 2
  %sf7 = insertvalue { i64, i64, i64, i64 } %sf6, i64 %col4, 3
  %__struct1 = alloca { i64, i64, i64, i64 }, align 8
  store { i64, i64, i64, i64 } %sf7, ptr %__struct1, align 4
  ret { i64, i64, i64, i64 } %sf7
}

define { i64, i64, i64, i64 } @span_dummy() {
entry:
  %__struct2 = alloca { i64, i64, i64, i64 }, align 8
  store { i64, i64, i64, i64 } zeroinitializer, ptr %__struct2, align 4
  ret { i64, i64, i64, i64 } zeroinitializer
}

define %Token @token_new(%TokenKind %0, { i64, i64, i64, i64 } %1) {
entry:
  %kind = alloca %TokenKind, align 8
  store %TokenKind %0, ptr %kind, align 4
  %span = alloca { i64, i64, i64, i64 }, align 8
  store { i64, i64, i64, i64 } %1, ptr %span, align 4
  %kind1 = load %TokenKind, ptr %kind, align 4
  %span2 = load { i64, i64, i64, i64 }, ptr %span, align 4
  %str = call %ForgeString @forge_string_new(ptr @str, i64 0)
  %sf = insertvalue { %TokenKind, { i64, i64, i64, i64 }, %ForgeString, i64 } undef, %TokenKind %kind1, 0
  %sf3 = insertvalue { %TokenKind, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf, { i64, i64, i64, i64 } %span2, 1
  %sf4 = insertvalue { %TokenKind, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf3, %ForgeString %str, 2
  %sf5 = insertvalue { %TokenKind, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf4, i64 0, 3
  %__struct3 = alloca { %TokenKind, { i64, i64, i64, i64 }, %ForgeString, i64 }, align 8
  store { %TokenKind, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf5, ptr %__struct3, align 8
  ret { %TokenKind, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf5
}

define { %TokenKind, { i64, i64, i64, i64 }, %ForgeString, i64 } @token_ident(%ForgeString %0, { i64, i64, i64, i64 } %1) {
entry:
  %name = alloca %ForgeString, align 8
  store %ForgeString %0, ptr %name, align 8
  %span = alloca { i64, i64, i64, i64 }, align 8
  store { i64, i64, i64, i64 } %1, ptr %span, align 4
  %enum_tmp = alloca %TokenKind, align 8
  store %TokenKind zeroinitializer, ptr %enum_tmp, align 4
  %tag_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 0
  store i8 8, ptr %tag_ptr, align 1
  %payload_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 1
  %name1 = load %ForgeString, ptr %name, align 8
  %fptr = getelementptr i64, ptr %payload_ptr, i64 0
  store %ForgeString %name1, ptr %fptr, align 8
  %enum_val = load %TokenKind, ptr %enum_tmp, align 4
  %__pt4 = alloca %name, align 8
  store %TokenKind %enum_val, ptr %__pt4, align 4
  %__pt42 = load %name, ptr %__pt4, align 4
  %span3 = load { i64, i64, i64, i64 }, ptr %span, align 4
  %name4 = load %ForgeString, ptr %name, align 8
  %sf = insertvalue { %name, { i64, i64, i64, i64 }, %ForgeString, i64 } undef, %name %__pt42, 0
  %sf5 = insertvalue { %name, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf, { i64, i64, i64, i64 } %span3, 1
  %sf6 = insertvalue { %name, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf5, %ForgeString %name4, 2
  %sf7 = insertvalue { %name, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf6, i64 1, 3
  %__struct5 = alloca { %name, { i64, i64, i64, i64 }, %ForgeString, i64 }, align 8
  store { %name, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf7, ptr %__struct5, align 8
  ret { %name, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf7
}

define { %name, { i64, i64, i64, i64 }, %ForgeString, i64 } @token_int(i64 %0, { i64, i64, i64, i64 } %1) {
entry:
  %value = alloca i64, align 8
  store i64 %0, ptr %value, align 4
  %span = alloca { i64, i64, i64, i64 }, align 8
  store { i64, i64, i64, i64 } %1, ptr %span, align 4
  %enum_tmp = alloca %TokenKind, align 8
  store %TokenKind zeroinitializer, ptr %enum_tmp, align 4
  %tag_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 0
  store i8 0, ptr %tag_ptr, align 1
  %payload_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 1
  %value1 = load i64, ptr %value, align 4
  %fptr = getelementptr i64, ptr %payload_ptr, i64 0
  store i64 %value1, ptr %fptr, align 4
  %enum_val = load %TokenKind, ptr %enum_tmp, align 4
  %__pt6 = alloca %value, align 8
  store %TokenKind %enum_val, ptr %__pt6, align 4
  %__pt62 = load %value, ptr %__pt6, align 4
  %span3 = load { i64, i64, i64, i64 }, ptr %span, align 4
  %value4 = load i64, ptr %value, align 4
  %tpl_i2s = call %ForgeString @forge_int_to_string(i64 %value4)
  %__tpl7 = alloca %ForgeString, align 8
  store %ForgeString %tpl_i2s, ptr %__tpl7, align 8
  %__tpl75 = load %ForgeString, ptr %__tpl7, align 8
  %sf = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } undef, %value %__pt62, 0
  %sf6 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf, { i64, i64, i64, i64 } %span3, 1
  %sf7 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf6, %ForgeString %__tpl75, 2
  %sf8 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf7, i64 2, 3
  %__struct8 = alloca { %value, { i64, i64, i64, i64 }, %ForgeString, i64 }, align 8
  store { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf8, ptr %__struct8, align 8
  ret { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf8
}

define { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } @token_float(i64 %0, { i64, i64, i64, i64 } %1) {
entry:
  %value = alloca i64, align 8
  store i64 %0, ptr %value, align 4
  %span = alloca { i64, i64, i64, i64 }, align 8
  store { i64, i64, i64, i64 } %1, ptr %span, align 4
  %enum_tmp = alloca %TokenKind, align 8
  store %TokenKind zeroinitializer, ptr %enum_tmp, align 4
  %tag_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 0
  store i8 1, ptr %tag_ptr, align 1
  %payload_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 1
  %value1 = load i64, ptr %value, align 4
  %fptr = getelementptr i64, ptr %payload_ptr, i64 0
  store i64 %value1, ptr %fptr, align 4
  %enum_val = load %TokenKind, ptr %enum_tmp, align 4
  %__pt9 = alloca %value, align 8
  store %TokenKind %enum_val, ptr %__pt9, align 4
  %__pt92 = load %value, ptr %__pt9, align 4
  %span3 = load { i64, i64, i64, i64 }, ptr %span, align 4
  %value4 = load i64, ptr %value, align 4
  %tpl_i2s = call %ForgeString @forge_int_to_string(i64 %value4)
  %__tpl10 = alloca %ForgeString, align 8
  store %ForgeString %tpl_i2s, ptr %__tpl10, align 8
  %__tpl105 = load %ForgeString, ptr %__tpl10, align 8
  %sf = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } undef, %value %__pt92, 0
  %sf6 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf, { i64, i64, i64, i64 } %span3, 1
  %sf7 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf6, %ForgeString %__tpl105, 2
  %sf8 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf7, i64 3, 3
  %__struct11 = alloca { %value, { i64, i64, i64, i64 }, %ForgeString, i64 }, align 8
  store { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf8, ptr %__struct11, align 8
  ret { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf8
}

define { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } @token_string(%ForgeString %0, { i64, i64, i64, i64 } %1) {
entry:
  %value = alloca %ForgeString, align 8
  store %ForgeString %0, ptr %value, align 8
  %span = alloca { i64, i64, i64, i64 }, align 8
  store { i64, i64, i64, i64 } %1, ptr %span, align 4
  %enum_tmp = alloca %TokenKind, align 8
  store %TokenKind zeroinitializer, ptr %enum_tmp, align 4
  %tag_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 0
  store i8 2, ptr %tag_ptr, align 1
  %payload_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 1
  %value1 = load %ForgeString, ptr %value, align 8
  %fptr = getelementptr i64, ptr %payload_ptr, i64 0
  store %ForgeString %value1, ptr %fptr, align 8
  %enum_val = load %TokenKind, ptr %enum_tmp, align 4
  %__pt12 = alloca %value, align 8
  store %TokenKind %enum_val, ptr %__pt12, align 4
  %__pt122 = load %value, ptr %__pt12, align 4
  %span3 = load { i64, i64, i64, i64 }, ptr %span, align 4
  %value4 = load %ForgeString, ptr %value, align 8
  %sf = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } undef, %value %__pt122, 0
  %sf5 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf, { i64, i64, i64, i64 } %span3, 1
  %sf6 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf5, %ForgeString %value4, 2
  %sf7 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf6, i64 4, 3
  %__struct13 = alloca { %value, { i64, i64, i64, i64 }, %ForgeString, i64 }, align 8
  store { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf7, ptr %__struct13, align 8
  ret { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf7
}

define { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } @token_bool(i64 %0, { i64, i64, i64, i64 } %1) {
entry:
  %value = alloca i64, align 8
  store i64 %0, ptr %value, align 4
  %span = alloca { i64, i64, i64, i64 }, align 8
  store { i64, i64, i64, i64 } %1, ptr %span, align 4
  %value1 = load %ForgeString, ptr %value, align 8
  %ifcond = trunc %ForgeString %value1 to i1
  br i1 %ifcond, label %then, label %else

then:                                             ; preds = %entry
  %str = call %ForgeString @forge_string_new(ptr @str.1, i64 4)
  br label %ifcont

else:                                             ; preds = %entry
  %str2 = call %ForgeString @forge_string_new(ptr @str.2, i64 5)
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %t = alloca %ForgeString, align 8
  store { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf7, ptr %t, align 8
  %enum_tmp = alloca %TokenKind, align 8
  store %TokenKind zeroinitializer, ptr %enum_tmp, align 4
  %tag_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 0
  store i8 6, ptr %tag_ptr, align 1
  %payload_ptr = getelementptr inbounds %TokenKind, ptr %enum_tmp, i32 0, i32 1
  %value3 = load %ForgeString, ptr %value, align 8
  %fptr = getelementptr i64, ptr %payload_ptr, i64 0
  store %ForgeString %value3, ptr %fptr, align 8
  %enum_val = load %TokenKind, ptr %enum_tmp, align 4
  %__pt14 = alloca %value, align 8
  store %TokenKind %enum_val, ptr %__pt14, align 4
  %__pt144 = load %value, ptr %__pt14, align 4
  %span5 = load { i64, i64, i64, i64 }, ptr %span, align 4
  %t6 = load %ForgeString, ptr %t, align 8
  %sf = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } undef, %value %__pt144, 0
  %sf7 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf, { i64, i64, i64, i64 } %span5, 1
  %sf8 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf7, %ForgeString %t6, 2
  %sf9 = insertvalue { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf8, i64 5, 3
  %__struct15 = alloca { %value, { i64, i64, i64, i64 }, %ForgeString, i64 }, align 8
  store { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf9, ptr %__struct15, align 8
  ret { %value, { i64, i64, i64, i64 }, %ForgeString, i64 } %sf9
}
