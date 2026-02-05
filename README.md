<center>
<img src="./logo.png" alt="NamedSignal Logo" style="width:50%; height:auto;">

---
### A Luau signal implementation that lets you name and define variadic parameters — conveniently.

TODO: Buttons and links
</center>

<details>
<summary>
	
# Features
</summary>

NamedSignal follows in the steps of GoodSignal and other signal libraries, for comprehensive documentation, please refer to the Documentation Website.

The primary focus of NamedSignal is allowing developers to name and define variadic parameters (hence the name, 'NamedSignal'), allowing for a much richer anonymous autofill when connecting a function to a signal. This is accomplished by using functiontypes (eg. `(foo: "bar") -> ()`) and User Defined Type Functions (UDTFs) exclusive to the New Luau Type Solver.

## API Overview
### Signal
| Member | Basic Type | Description |
| --- | --- | --- |
| :Connect() | `(self: Signal, func: (...any) -> ()) -> (Connection)` | Connects the given function to the signal. |
| :Once() | `(self: Signal, func: (...any) -> ()) -> (Connection)` | Connects the given function to the signal for a single invocation. |
| :Wait() | `(self: Signal) -> (...any)` | Yields the current thread until the signal fires and returns the arguments provided by the signal. |
| :Fire() | `(self: Signal, ...any) -> ()` | Calls all connected functions and resumes all waiting threads with the given arguments. |
| :DisconnectAll() | `(self: Signal) -> ()` | Disconnects all connections from the signal. |
| :Destroy() | `(self: Signal) -> ()` | Disconnects all connections from the signal, and removes its metatable. |
---

### Connection
| Member | Basic Type | Description |
| --- | --- | --- |
| :Disconnect() | `(self: Connection) -> ()` | Disconnects the connection from the signal. |
| :Destroy() | `(self: Connection) -> ()` | An alias for `:Disconnect()` for cleanup utils. |
| .Signal | `Signal` | A reference to the signal the connection is for. |
| .Connected | `boolean` | Describes whether the connection is active. |
| .Callback | `(...any) -> ()` | The connected function. |
---
</details>

<details>
<summary>

# Performance
</summary>

NamedSignal utilizes standard optimizations, such as thread recycling and linked lists for O(1) disconnects.

The performance of NamedSignal is comparable to others that use such optimizations, *with the exception of `Signal:Fire()`*, which is **3-5x faster** than other implementations according to benchmarks. How? Honestly, no clue — I was only aiming for named parameters with comparable performance.

TODO: Benchmarks
</details>

<details>
<summary>
	
# Type Limitations
</summary>

There are unfortunately *some* limitations, which can't be resolved without hacky or inconvenient tricks. This list documents them.

* The parameters of `Signal:Fire()` are unnamed, this is due to UDTF limitations.
* The first (`self`) parameters of `Signal:Fire()` and `Signal:Wait()` are `any`, as UDTFs cannot serialize the proper type.
	* This does not impact auto-complete suggestions — they will still show up as valid methods.
</details>

<details>
<summary>

# Compatibility
</summary>

- NamedSignal follows conventional standards, it is functionally identical to other libraries like [Signal+](https://github.com/AlexanderLindholt/SignalPlus).
- NamedSignal is built for the new Luau type solver, which has many differences from the old solver that make code typed with it largely incompatible.
	- This library's types are completely ***incompatible*** with the old solver, as it lacks the features necessary to make them work. It cannot be backported to the old solver.
- NamedSignal's types are incompatible with most other libraries, as it uses a functiontype instead of generic type pack parameters. If you require a type that uses generic type pack parameters, you can define a new type that proxies them in a functiontype, for example:
	```lua
	export type GenericSignal<Params...> = Signal<(Params...) -> ()>
	```
</details>
<br>
<center>

# Example Usage
NamedSignal aims to be familiar and simple to use, below is an example snippet that should get you started!
</center>

```lua
local Signal = require(path.to.module)

-- Soon you will able to use Signal.new<<()->()>>() syntax to instatiate the generic while writing the statement.
local exampleEvent = Signal.new() :: Signal.Signal<(say: "hello world!")->()>

-- Anonymous autofilled!
exampleEvent:Connect(function(say: "hello world!")
	print(say)
end)

exampleEvent:Fire("hello world!")
```