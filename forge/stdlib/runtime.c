#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

// ---- Reference counting ----

typedef struct {
    int64_t rc;
    // payload follows
} ForgeHeapObj;

void forge_rc_retain(void* ptr) {
    if (ptr == NULL) return;
    ForgeHeapObj* obj = (ForgeHeapObj*)((char*)ptr - sizeof(int64_t));
    obj->rc++;
}

void forge_rc_release(void* ptr) {
    if (ptr == NULL) return;
    ForgeHeapObj* obj = (ForgeHeapObj*)((char*)ptr - sizeof(int64_t));
    obj->rc--;
    if (obj->rc <= 0) {
        free(obj);
    }
}

void* forge_alloc(int64_t size) {
    ForgeHeapObj* obj = (ForgeHeapObj*)malloc(sizeof(int64_t) + size);
    obj->rc = 1;
    return (void*)((char*)obj + sizeof(int64_t));
}

// ---- String operations ----

typedef struct {
    char* ptr;
    int64_t len;
} ForgeString;

ForgeString forge_string_new(const char* data, int64_t len) {
    char* buf = (char*)forge_alloc(len + 1);
    memcpy(buf, data, len);
    buf[len] = '\0';
    return (ForgeString){ .ptr = buf, .len = len };
}

ForgeString forge_string_concat(ForgeString a, ForgeString b) {
    int64_t new_len = a.len + b.len;
    char* buf = (char*)forge_alloc(new_len + 1);
    memcpy(buf, a.ptr, a.len);
    memcpy(buf + a.len, b.ptr, b.len);
    buf[new_len] = '\0';
    return (ForgeString){ .ptr = buf, .len = new_len };
}

// ---- Print functions ----

void forge_print_int(int64_t value) {
    printf("%lld", (long long)value);
}

void forge_print_float(double value) {
    printf("%g", value);
}

void forge_print_string(ForgeString s) {
    fwrite(s.ptr, 1, s.len, stdout);
}

void forge_print_bool(int8_t value) {
    printf("%s", value ? "true" : "false");
}

void forge_println_string(ForgeString s) {
    fwrite(s.ptr, 1, s.len, stdout);
    putchar('\n');
}

void forge_println_int(int64_t value) {
    printf("%lld\n", (long long)value);
}

void forge_println_float(double value) {
    printf("%g\n", value);
}

void forge_println_bool(int8_t value) {
    printf("%s\n", value ? "true" : "false");
}

// ---- Conversion ----

ForgeString forge_int_to_string(int64_t value) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%lld", (long long)value);
    return forge_string_new(buf, len);
}

ForgeString forge_float_to_string(double value) {
    char buf[64];
    int len = snprintf(buf, sizeof(buf), "%g", value);
    return forge_string_new(buf, len);
}

ForgeString forge_bool_to_string(int8_t value) {
    return value ? forge_string_new("true", 4) : forge_string_new("false", 5);
}

// ---- String methods ----

int64_t forge_string_length(ForgeString s) {
    return s.len;
}

ForgeString forge_string_upper(ForgeString s) {
    char* buf = (char*)forge_alloc(s.len + 1);
    for (int64_t i = 0; i < s.len; i++) {
        buf[i] = (s.ptr[i] >= 'a' && s.ptr[i] <= 'z') ? s.ptr[i] - 32 : s.ptr[i];
    }
    buf[s.len] = '\0';
    return (ForgeString){ .ptr = buf, .len = s.len };
}

ForgeString forge_string_lower(ForgeString s) {
    char* buf = (char*)forge_alloc(s.len + 1);
    for (int64_t i = 0; i < s.len; i++) {
        buf[i] = (s.ptr[i] >= 'A' && s.ptr[i] <= 'Z') ? s.ptr[i] + 32 : s.ptr[i];
    }
    buf[s.len] = '\0';
    return (ForgeString){ .ptr = buf, .len = s.len };
}

int8_t forge_string_contains(ForgeString haystack, ForgeString needle) {
    if (needle.len > haystack.len) return 0;
    if (needle.len == 0) return 1;
    for (int64_t i = 0; i <= haystack.len - needle.len; i++) {
        if (memcmp(haystack.ptr + i, needle.ptr, needle.len) == 0) {
            return 1;
        }
    }
    return 0;
}

// ---- String comparison ----

int8_t forge_string_eq(ForgeString a, ForgeString b) {
    if (a.len != b.len) return 0;
    return memcmp(a.ptr, b.ptr, a.len) == 0 ? 1 : 0;
}

// ---- Sleep ----

void forge_sleep(int64_t ms) {
    usleep((useconds_t)(ms * 1000));
}

// ---- Exit ----

void forge_exit(int64_t code) {
    exit((int)code);
}

// ---- Assert ----

void forge_assert(int8_t cond, const char* msg, int64_t msg_len) {
    if (!cond) {
        fprintf(stderr, "assertion failed: ");
        fwrite(msg, 1, msg_len, stderr);
        fputc('\n', stderr);
        exit(1);
    }
}

// ---- JSON parsing (for model query results) ----

// Skip whitespace
static const char* json_skip_ws(const char* p) {
    while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') p++;
    return p;
}

// Count objects in a JSON array
int64_t forge_json_array_count(const char* json) {
    if (!json) return 0;
    const char* p = json_skip_ws(json);
    if (*p != '[') return 0;
    p = json_skip_ws(p + 1);
    if (*p == ']') return 0;

    int64_t count = 0;
    int depth = 0;
    while (*p) {
        if (*p == '{') {
            if (depth == 0) count++;
            depth++;
        } else if (*p == '}') {
            depth--;
        } else if (*p == ']' && depth == 0) {
            break;
        }
        p++;
    }
    return count;
}

// Find the i-th object in a JSON array (or a single top-level object), return pointer to its '{'
static const char* json_find_object(const char* json, int64_t index) {
    if (!json) return NULL;
    const char* p = json_skip_ws(json);
    // Support single top-level object (not wrapped in array)
    if (*p == '{' && index == 0) return p;
    if (*p != '[') return NULL;
    p++;

    int64_t count = 0;
    int depth = 0;
    while (*p) {
        p = json_skip_ws(p);
        if (*p == ']') return NULL;
        if (*p == '{') {
            if (count == index) return p;
            // Skip this object
            depth = 1;
            p++;
            while (*p && depth > 0) {
                if (*p == '{') depth++;
                else if (*p == '}') depth--;
                else if (*p == '"') {
                    p++;
                    while (*p && *p != '"') { if (*p == '\\') p++; p++; }
                }
                p++;
            }
            count++;
            p = json_skip_ws(p);
            if (*p == ',') p++;
            continue;
        }
        p++;
    }
    return NULL;
}

// Find a field value in a JSON object (pointer to '{'), return pointer to value start
static const char* json_find_field(const char* obj, const char* field_name) {
    if (!obj || *obj != '{') return NULL;
    const char* p = obj + 1;
    int field_len = strlen(field_name);

    while (*p) {
        p = json_skip_ws(p);
        if (*p == '}') return NULL;
        if (*p == '"') {
            p++;
            const char* key_start = p;
            while (*p && *p != '"') { if (*p == '\\') p++; p++; }
            int key_len = (int)(p - key_start);
            p++; // skip closing "
            p = json_skip_ws(p);
            if (*p == ':') p++;
            p = json_skip_ws(p);

            if (key_len == field_len && memcmp(key_start, field_name, field_len) == 0) {
                return p; // pointer to value
            }

            // Skip value
            if (*p == '"') {
                p++;
                while (*p && *p != '"') { if (*p == '\\') p++; p++; }
                p++;
            } else if (*p == '{') {
                int d = 1; p++;
                while (*p && d > 0) {
                    if (*p == '{') d++;
                    else if (*p == '}') d--;
                    else if (*p == '"') { p++; while (*p && *p != '"') { if (*p == '\\') p++; p++; } }
                    p++;
                }
            } else if (*p == '[') {
                int d = 1; p++;
                while (*p && d > 0) {
                    if (*p == '[') d++;
                    else if (*p == ']') d--;
                    else if (*p == '"') { p++; while (*p && *p != '"') { if (*p == '\\') p++; p++; } }
                    p++;
                }
            } else {
                while (*p && *p != ',' && *p != '}') p++;
            }
            if (*p == ',') p++;
        } else {
            p++;
        }
    }
    return NULL;
}

// Get string field from i-th object
ForgeString forge_json_get_string(const char* json, int64_t index, const char* field) {
    const char* obj = json_find_object(json, index);
    const char* val = json_find_field(obj, field);
    if (!val) return forge_string_new("", 0);

    if (*val == '"') {
        val++;
        const char* start = val;
        // Calculate unescaped length
        const char* p = start;
        int64_t len = 0;
        while (*p && *p != '"') {
            if (*p == '\\') { p++; }
            len++;
            p++;
        }
        // Build unescaped string
        char* buf = (char*)forge_alloc(len + 1);
        int64_t j = 0;
        p = start;
        while (*p && *p != '"') {
            if (*p == '\\') {
                p++;
                if (*p == 'n') buf[j++] = '\n';
                else if (*p == 't') buf[j++] = '\t';
                else buf[j++] = *p;
            } else {
                buf[j++] = *p;
            }
            p++;
        }
        buf[j] = '\0';
        return (ForgeString){ .ptr = buf, .len = j };
    }
    return forge_string_new("", 0);
}

// Get int field from i-th object
int64_t forge_json_get_int(const char* json, int64_t index, const char* field) {
    const char* obj = json_find_object(json, index);
    const char* val = json_find_field(obj, field);
    if (!val) return 0;
    return strtoll(val, NULL, 10);
}

// Get bool field from i-th object (handles 0/1 and true/false)
int8_t forge_json_get_bool(const char* json, int64_t index, const char* field) {
    const char* obj = json_find_object(json, index);
    const char* val = json_find_field(obj, field);
    if (!val) return 0;
    if (*val == 't') return 1;  // "true"
    if (*val == '1') return 1;
    return 0;
}

// Serialize a struct to JSON - helper for HTTP responses
// Write a JSON key-value string field
void forge_json_write_string_field(char* buf, int64_t* pos, int64_t buf_len, const char* key, const char* val, int64_t val_len) {
    *pos += snprintf(buf + *pos, buf_len - *pos, "\"%s\":\"", key);
    // Copy with escaping
    for (int64_t i = 0; i < val_len && *pos < buf_len - 2; i++) {
        if (val[i] == '"' || val[i] == '\\') {
            buf[(*pos)++] = '\\';
        }
        buf[(*pos)++] = val[i];
    }
    buf[(*pos)++] = '"';
    buf[*pos] = '\0';
}

void forge_json_write_int_field(char* buf, int64_t* pos, int64_t buf_len, const char* key, int64_t val) {
    *pos += snprintf(buf + *pos, buf_len - *pos, "\"%s\":%lld", key, (long long)val);
}

void forge_json_write_bool_field(char* buf, int64_t* pos, int64_t buf_len, const char* key, int8_t val) {
    *pos += snprintf(buf + *pos, buf_len - *pos, "\"%s\":%s", key, val ? "true" : "false");
}

// Map get from JSON params - used by HTTP handlers
ForgeString forge_params_get(const char* params_json, const char* key) {
    // params_json is like {"name":"value",...}
    if (!params_json || *params_json != '{') return forge_string_new("", 0);
    const char* val = json_find_field(params_json, key);
    if (!val || *val != '"') return forge_string_new("", 0);
    val++;
    const char* start = val;
    while (*val && *val != '"') val++;
    int64_t len = val - start;
    return forge_string_new(start, len);
}

// snprintf into a C string for SQL building
void forge_write_cstring(char* buf, int64_t buf_len, const char* src, int64_t src_len) {
    int64_t copy_len = src_len < buf_len - 1 ? src_len : buf_len - 1;
    memcpy(buf, src, copy_len);
    buf[copy_len] = '\0';
}

// Extract a string field from a flat JSON object body, return malloc'd C string (caller must free with stdlib free)
// Returns empty string if not found
char* forge_body_get_string(const char* body, const char* field_name) {
    if (!body || *body != '{') {
        char* r = (char*)malloc(1); r[0] = '\0'; return r;
    }
    const char* val = json_find_field(body, field_name);
    if (!val || *val != '"') {
        char* r = (char*)malloc(1); r[0] = '\0'; return r;
    }
    val++; // skip opening quote
    const char* start = val;
    // Calculate unescaped length
    const char* p = start;
    int64_t len = 0;
    while (*p && *p != '"') {
        if (*p == '\\') p++;
        len++;
        p++;
    }
    char* buf = (char*)malloc(len + 1);
    int64_t j = 0;
    p = start;
    while (*p && *p != '"') {
        if (*p == '\\') {
            p++;
            if (*p == 'n') buf[j++] = '\n';
            else if (*p == 't') buf[j++] = '\t';
            else buf[j++] = *p;
        } else {
            buf[j++] = *p;
        }
        p++;
    }
    buf[j] = '\0';
    return buf;
}

// Extract an int field from a flat JSON object body, return as C string (caller must free)
char* forge_body_get_int_str(const char* body, const char* field_name) {
    if (!body || *body != '{') {
        char* r = (char*)malloc(2); r[0] = '0'; r[1] = '\0'; return r;
    }
    const char* val = json_find_field(body, field_name);
    if (!val) {
        char* r = (char*)malloc(2); r[0] = '0'; r[1] = '\0'; return r;
    }
    // val points to the number
    char buf[32];
    int64_t v = strtoll(val, NULL, 10);
    int len = snprintf(buf, sizeof(buf), "%lld", (long long)v);
    char* r = (char*)malloc(len + 1);
    memcpy(r, buf, len + 1);
    return r;
}

// Extract a bool field from a flat JSON object body, return "0" or "1" (caller must free)
char* forge_body_get_bool_str(const char* body, const char* field_name) {
    if (!body || *body != '{') {
        char* r = (char*)malloc(2); r[0] = '0'; r[1] = '\0'; return r;
    }
    const char* val = json_find_field(body, field_name);
    if (!val) {
        char* r = (char*)malloc(2); r[0] = '0'; r[1] = '\0'; return r;
    }
    char* r = (char*)malloc(2);
    r[1] = '\0';
    if (*val == 't' || *val == '1') {
        r[0] = '1';
    } else {
        r[0] = '0';
    }
    return r;
}

// Check if a field exists in a flat JSON object body
int8_t forge_body_has_field(const char* body, const char* field_name) {
    if (!body || *body != '{') return 0;
    const char* val = json_find_field(body, field_name);
    return val ? 1 : 0;
}

// Fix boolean fields in a JSON string: replace "field":0 with "field":false, "field":1 with "field":true
// bool_fields is a comma-separated list of field names, e.g. "done,active"
// Modifies the string in-place if possible, or writes to a new malloc'd buffer.
// Returns a malloc'd string (caller frees with free()).
char* forge_json_fix_bools(const char* json, const char* bool_fields) {
    if (!json || !bool_fields) {
        int64_t len = json ? strlen(json) : 0;
        char* r = (char*)malloc(len + 1);
        if (json) memcpy(r, json, len);
        r[len] = '\0';
        return r;
    }

    // Parse bool field names
    const char* bf = bool_fields;
    char field_names[16][64]; // max 16 bool fields, 64 chars each
    int num_fields = 0;
    while (*bf && num_fields < 16) {
        const char* start = bf;
        while (*bf && *bf != ',') bf++;
        int flen = (int)(bf - start);
        if (flen > 63) flen = 63;
        memcpy(field_names[num_fields], start, flen);
        field_names[num_fields][flen] = '\0';
        num_fields++;
        if (*bf == ',') bf++;
    }

    // Allocate output buffer (may be larger due to "false" being longer than "0")
    int64_t json_len = strlen(json);
    int64_t out_size = json_len * 2 + 1; // generous
    char* out = (char*)malloc(out_size);
    int64_t oi = 0;
    const char* p = json;

    while (*p) {
        // Check for "fieldname":0 or "fieldname":1
        if (*p == '"') {
            const char* key_start = p + 1;
            const char* q = key_start;
            while (*q && *q != '"') q++;
            int key_len = (int)(q - key_start);

            // Check if this key is a bool field
            int is_bool = 0;
            for (int fi = 0; fi < num_fields; fi++) {
                if ((int)strlen(field_names[fi]) == key_len && memcmp(key_start, field_names[fi], key_len) == 0) {
                    is_bool = 1;
                    break;
                }
            }

            if (is_bool && *q == '"') {
                // Copy "fieldname"
                int64_t kpart = q + 1 - p; // includes closing "
                memcpy(out + oi, p, kpart);
                oi += kpart;
                p = q + 1;

                // Skip whitespace and colon
                while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') {
                    out[oi++] = *p++;
                }
                if (*p == ':') {
                    out[oi++] = *p++;
                }
                while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') {
                    out[oi++] = *p++;
                }

                // Now replace 0->false, 1->true
                if (*p == '0' && (p[1] == ',' || p[1] == '}' || p[1] == ']' || p[1] == '\0' || p[1] == ' ' || p[1] == '\n')) {
                    memcpy(out + oi, "false", 5);
                    oi += 5;
                    p++; // skip '0'
                } else if (*p == '1' && (p[1] == ',' || p[1] == '}' || p[1] == ']' || p[1] == '\0' || p[1] == ' ' || p[1] == '\n')) {
                    memcpy(out + oi, "true", 4);
                    oi += 4;
                    p++; // skip '1'
                } else {
                    // Not 0 or 1, just copy as-is
                }
                continue;
            }
        }
        out[oi++] = *p++;
    }
    out[oi] = '\0';
    return out;
}

// Extract first object from a JSON array "[{...},{...}]" -> "{...}"
// Writes to output buffer. Returns length written (0 if empty array).
int64_t forge_json_unwrap_first(const char* json_array, char* out_buf, int64_t out_len) {
    if (!json_array) { out_buf[0] = '\0'; return 0; }
    const char* p = json_skip_ws(json_array);
    if (*p != '[') { out_buf[0] = '\0'; return 0; }
    p = json_skip_ws(p + 1);
    if (*p == ']') { out_buf[0] = '\0'; return 0; }
    if (*p != '{') { out_buf[0] = '\0'; return 0; }
    // Find the end of this object
    const char* start = p;
    int depth = 1;
    p++;
    while (*p && depth > 0) {
        if (*p == '{') depth++;
        else if (*p == '}') depth--;
        else if (*p == '"') {
            p++;
            while (*p && *p != '"') { if (*p == '\\') p++; p++; }
        }
        p++;
    }
    // p now points past the closing '}'
    int64_t obj_len = p - start;
    if (obj_len >= out_len) obj_len = out_len - 1;
    memcpy(out_buf, start, obj_len);
    out_buf[obj_len] = '\0';
    return obj_len;
}

// Check if a JSON string represents null (or is empty/missing)
int8_t forge_json_is_null(const char* json) {
    if (!json) return 1;
    const char* p = json;
    while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') p++;
    return (*p == 'n' || *p == '\0') ? 1 : 0;
}
