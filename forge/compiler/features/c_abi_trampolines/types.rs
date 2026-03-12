// C ABI trampolines types
//
// The `Type::Ptr` variant (defined in `compiler/core/typeck/types.rs`) represents
// raw C pointer values from extern function calls. This is the only type system
// addition related to C ABI trampolines.
//
// The coercion between Type::String (ForgeString) and Type::Ptr happens at
// the codegen level, not the type level.
