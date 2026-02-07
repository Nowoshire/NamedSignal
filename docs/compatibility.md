# Compatibility

- NamedSignal follows conventional standards, it is functionally identical to other libraries like [Signal+](https://github.com/AlexanderLindholt/SignalPlus).
- NamedSignal is built for the new Luau type solver, which has many differences from the old solver that make code typed with it largely incompatible.
	- This library's types are completely ***incompatible*** with the old solver, as it lacks the features necessary to make them work. It cannot be backported to the old solver.
- NamedSignal's types are incompatible with most other libraries, as it uses a functiontype instead of generic type pack parameters. If you require a type that uses generic type pack parameters, you can define a new type that proxies them in a functiontype, for example:
	```lua
	export type GenericSignal<Params...> = Signal<(Params...) -> ()>
	```