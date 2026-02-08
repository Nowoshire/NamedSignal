# Getting Started

!!! info "New Solver Required"

	NamedSignal is built for the New Luau Type Solver, it is not compatible with the old solver. See [Compatibility](compatibility.md) for more details.

## Installation
=== "from GitHub"

	1. Download the latest release from https://github.com/Nowoshire/NamedSignal/releases/latest.
	2. Place the `.luau` file in your preferred location.

=== "from Wally"

	1. Add `Signal = "nowoshire/namedsignal@^1.0.0"` to your wally.toml dependencies.
	2. Run `wally install`.

## Usage
The library currently has one interface function, `.new()`, which returns a new signal when called:
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
You can then use its methods to connect/disconnect and fire connections. NamedSignal follows conventional standards, and is functionally compatible with other signal implementations like SignalPlus!