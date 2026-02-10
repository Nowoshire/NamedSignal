# Compatibility
NamedSignal is GohanDucis's Class 3 Signal certified, meaning it applies Synchronous Functional Reactive Programming (FRP) with
Atomic Propagation principles and standards, making it best suited for game development and programming!

Its API is otherwise compatible with most popular implementations.

A few notable differences from most other implementations:

- Built for the new solver, and fully strictly-typed.
- Supports naming and defining variadic parameters by using functiontypes (e.g. `(arg: string) -> ()`).
- Connection safety: Connections made during invocation wiil not be fired in that same invocation.
- Snapshot certified: Mutations made during invocation are deferred until the invocation completes, with optional an optional for `Connection:Disconnect()`.