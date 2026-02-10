# Getting Started
!!! info "New Solver Required"

	NamedSignal is built for the New Luau Type Solver, and its types are *not* compatible with the old solver.
	See [Compatibility](compatibility.md) for more details.

## Installation
=== "from GitHub"

	1. Download the latest release from https://github.com/Nowoshire/NamedSignal/releases/latest.
	2. Place the `.luau` or `.rbxm` file in your preferred location.

=== "from Wally"

	1. Add `Signal = "nowoshire/namedsignal@^1.0.0"` to your wally.toml dependencies.
	2. Run `wally install` in your terminal.

## Usage
The library currently returns a table with one interface function: `Signal.new()`, which you use to create signals:

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

See [API Reference](api-reference.md) for a list of all members.