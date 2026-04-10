
// ─── Higher-order list operations ─────────────────────────────────
// These take a function pointer (i64 → i64) and apply it to each
// element. The function pointer is cast from i64 (the bootstrap's
// closure representation).

typedef int64_t (*ForgeMapFn)(int64_t);
typedef int64_t (*ForgeFilterFn)(int64_t);
typedef int64_t (*ForgeReduceFn)(int64_t, int64_t);

void* forge_array_map(void* arr, int64_t fn_ptr) {
    ForgeArray* src = (ForgeArray*)arr;
    ForgeMapFn f = (ForgeMapFn)(uintptr_t)fn_ptr;
    void* dst = forge_array_new();
    for (int64_t i = 0; i < src->len; i++) {
        forge_array_push(dst, f(src->data[i]));
    }
    return dst;
}

void* forge_array_filter(void* arr, int64_t fn_ptr) {
    ForgeArray* src = (ForgeArray*)arr;
    ForgeFilterFn f = (ForgeFilterFn)(uintptr_t)fn_ptr;
    void* dst = forge_array_new();
    for (int64_t i = 0; i < src->len; i++) {
        if (f(src->data[i])) {
            forge_array_push(dst, src->data[i]);
        }
    }
    return dst;
}

int64_t forge_array_reduce(void* arr, int64_t initial, int64_t fn_ptr) {
    ForgeArray* src = (ForgeArray*)arr;
    ForgeReduceFn f = (ForgeReduceFn)(uintptr_t)fn_ptr;
    int64_t acc = initial;
    for (int64_t i = 0; i < src->len; i++) {
        acc = f(acc, src->data[i]);
    }
    return acc;
}

void forge_array_foreach(void* arr, int64_t fn_ptr) {
    ForgeArray* src = (ForgeArray*)arr;
    ForgeMapFn f = (ForgeMapFn)(uintptr_t)fn_ptr;
    for (int64_t i = 0; i < src->len; i++) {
        f(src->data[i]);
    }
}
