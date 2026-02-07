# Introduction
NamedSignal is a Signal library, which serve as a much better pure-Luau alternative to the Roblox engine's [BindableEvents](https://create.roblox.com/docs/reference/engine/classes/BindableEvent) and [RBXScriptSignals](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal).

---

*Like* most signal libraries, NamedSignal offers much greater performance, control, and the main purpose of this implementation — typechecking and ergonomics.

*Unlike* most signal libraries, NamedSignal allows you to **name and define variadic parameters**. This solves a long-standing pain point of most implementations, where you previously had to name every parameter every time you anonymous auto-filled a new connection — or work with unhelpful `a`-number parameters (e.g. `a01`).

This is accomplished by using functiontypes (eg. `(foo: "bar") -> ()`) and User Defined Type Functions (UDTFs) exclusive to the New Luau Type Solver. Refer to [Usage](getting-started.md#usage) to see how to use this.