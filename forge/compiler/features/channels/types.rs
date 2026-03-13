// Channel type: Type::Channel(Box<Type>)
//
// Channels carry a compile-time element type for type checking:
// - `channel<string>(10)` creates a `channel<string>` (buffered, capacity 10)
// - `channel(10)` creates a `channel<unknown>` (untyped, backwards compatible)
//
// At runtime, channels are always int IDs. The Channel type only exists
// at compile time for the type checker:
// - Send (`ch <- val`): checks that val matches the channel's element type
// - Receive (`<- ch`): returns the channel's element type instead of Unknown
// - For-loop iteration (`for msg in ch`): binds msg to the element type
//
// The Type::Channel variant is defined in core/typeck/types.rs since it's
// part of the core type system (like List, Map, etc.).
