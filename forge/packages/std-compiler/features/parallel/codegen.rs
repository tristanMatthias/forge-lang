// Parallel execution codegen shares the spawn infrastructure.
// SpawnBlock compilation (thread spawning, closure capture) is implemented
// in features/spawn/codegen.rs.
//
// Future parallel-specific codegen would add:
// - Work-stealing thread pool integration
// - Structured concurrency with join semantics
// - Parallel iterators (par_map, par_filter, etc.)
