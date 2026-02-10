# Introduction
## Welcome to NamedSignal!
NamedSignal is a Luau signal implementation, which are essentially pure-Luau replacements (and successors) to the Roblox engine's BindableEvents.

Signals allow you to effectively and conveniently implement Synchronous [Functional Reactive Programming](https://en.wikipedia.org/wiki/Functional_reactive_programming) <small>*(FRP for short)*</small> in Roblox, which allows you to build modular systems that subscribe into "events" from other systems without directly depending on them.

## Why use this over others?
NamedSignal, as its name suggests, lets you name your parameters (and define variadic ones too), allowing for a much richer auto-fill experience when connecting anonymous functions to events. It's also fully strictly typed for the New Luau Type Solver!

Additionally, NamedSignal is a [GohanDucis's Class 3 certified signal](https://devforum.roblox.com/t/signal-certifications-classes-guide/4263792), meaning it implements standards and conventions best suited for effective game development.

If you're coming from BindableEvents, this will be a *major* upgrade for you!

And for those seeking maximum performance, [**NamedSignal's `Signal:Fire()` is up to 4x faster than others**](performance.md), with comparable performance elsewhere!