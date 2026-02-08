<div align="center">
<img src="docs/logo.png" alt="NamedSignal Logo" style="width:50%; height:auto;">

---
### A Luau signal implementation that lets you name and define variadic parameters — conveniently.
`a01: type` begone!
<br><br>

[![Download Badge](https://img.shields.io/badge/Download-005CC0?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Nowoshire/NamedSignal/releases/latest)
&ensp;
[![Documentation Badge](https://img.shields.io/badge/Documentation-5C00C0?style=for-the-badge&logo=readme&logoColor=white)](https://Nowoshire.github.io/NamedSignal/)
<br>

[![DevForum Badge](https://img.shields.io/badge/DevForum-lightblue?style=social&logo=robloxstudio)](https://devforum.roblox.com/t/4341837)
&nbsp;
[![GitHub Badge](https://img.shields.io/badge/GitHub-gray?style=social&logo=github)](https://github.com/Nowoshire/NamedSignal)

```toml
Signal = "nowoshire/namedsignal@^1.0.0"
```

</div>

> [!IMPORTANT]
> ### Requires New Luau Type Solver<br>
> NamedSignal is built for the New Luau Type Solver, it is not compatible with the old solver. See [Compatibility](#compatibility) for more details.

<details>
<summary>

# Features
</summary>

NamedSignal follows in the steps of GoodSignal and other signal libraries, for comprehensive documentation, please refer to the [Documentation Website](https://Nowoshire.github.io/NamedSignal/).

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

NamedSignal utilizes standard optimizations, such as thread recycling and linked lists. As such, most features of NamedSignal have comparable performance to other implementations — with the exception of `Signal:Fire()`, which is roughly 4-5x faster than others according to benchmarks.

### NamedSignal (Immediate)
#### Signal.new()
375.99999996018596 µs (10000 call total)

#### Signal:Connect()
467.9000012401957 µs (5000 call total)

#### Signal:Once()
743.1000012729783 µs (5000 call total)

#### Signal:Wait()
1102.1999998774845 µs (5000 call total)

#### Signal:Fire()
| Connection Count | Time (200 call average) |
| --- | --- |
| 0 connections | 0.04200001058052294 µs |
| 1 connections | 0.1650000012887176 µs |
| 100 connections | 13.564500004576985 µs |
| 1000 connections | 115.78499999814085 µs |
| 5000 connections | 555.1089999971737 µs |

#### Signal:Disconnect()
| Connection Count | Time (5000 disconnects) |
| --- | --- |
| 5000 to 0 connections | 335.5000008014031 µs |
| 11000 to 6000 connections | 335.40000003995374 µs |
| 15000 to 10000 connections | 288.69999732705764 µs |

#### Signal:DisconnectAll()
| Connection Count | Time (500 call average) |
| --- | --- |
| 0 connections | 0.13480005145538598 µs |
| 100 connections | 1.0327999843866564 µs |
| 1000 connections | 9.549599977617618 µs |
| 5000 connections | 50.3668000237667 µs |

#### Signal:Destroy()
| Connection Count | Time (500 call average) |
| --- | --- |
| 0 connections | 0.15800003166077659 µs |
| 100 connections | 1.165799971204251 µs |
| 1000 connections | 9.813200049393345 µs |
| 5000 connections | 50.63779999181861 µs |

Comparisons are available at https://Nowoshire.github.io/NamedSignal/performance/#benchmarks
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
<div align="center">

# Example Usage
NamedSignal aims to be familiar and simple to use to those experienced with typechecking, below is an example snippet that should get you started!
</div>

```lua
local Signal = require(path.to.module)

-- Soon you will able to use Signal.new<<()->()>>() syntax to instatiate the generic while writing the statement.
local exampleSignal = Signal.new() :: Signal.Signal<(say: "hello world!")->()>

-- Anonymous autofilled!
exampleSignal:Connect(function(say: "hello world!")
	print(say)
end)

exampleSignal:Fire("hello world!")
```