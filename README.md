<div align="center">
<img src="docs/logo.png" alt="NamedSignal Logo" style="width:50%; height:auto;">

---
### A Zero Compromises Luau Signal Implementation
A signal designed for Synchronous Functional Reactive Programming (FRP) with Atomic Propagation, that also lets you name and define variadic parameters (`a01: type` begone!)
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

---

<br>

> [!IMPORTANT]
> ### Requires New Luau Type Solver<br>
> NamedSignal is built for the New Luau Type Solver, it is not compatible with the old solver. See [Compatibility](https://Nowoshire.github.io/NamedSignal/compatibility) for more details.

<div align="center">

# Example Usage
NamedSignal aims to be familiar and simple to use to those experienced with typechecking, below is an example snippet that should get you started!
</div>

```lua
local Signal = require(path.to.namedsignal)

local exampleEvent = Signal.new() :: Signal.Signal<(say: string) -> ()>

-- Anonymous function auto-fill fully autocompletes parameter names!
exampleEvent:Connect(function(say: string)
	print(say)
end)

-- And everything else is fully typed too!
exampleEvent:Fire("Hello, world!")
```