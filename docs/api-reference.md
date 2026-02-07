# API Reference
NamedSignal follows in the steps of GoodSignal and other signal libraries, its runtime API is functionally identical to most implementations.

## Library
| Member | Type | Description |
| --- | --- | --- |
| .new`<Signature>` | `() -> (Signal<Signature>)` | Returns a new Signal. |

## Objects
### Signal`<Signature = () -> ()>`
| Member | Type (Without UDTF) | Description |
| --- | --- | --- |
| :Connect() | `(self: Signal<Signature>, func: Signature) -> (Connection<Signature>)` | Connects the given function to the signal. |
| :Once() | `(self: Signal<Signature>, func: Signature) -> (Connection<Signature>)` | Connects the given function to the signal for a single invocation. |
| :Wait() | `(self: Signal<Signature>) -> (...any)` | Yields the current thread until the signal fires and returns the arguments provided by the signal. |
| :Fire() | `(self: Signal<Signature>, ...any) -> ()` | Calls all connected functions and resumes all waiting threads with the given arguments. |
| :DisconnectAll() | `(self: Signal<Signature>) -> ()` | Disconnects all connections from the signal. |
| :Destroy() | `(self: Signal<Signature>) -> ()` | Disconnects all connections from the signal, and removes its metatable. |

### Connection`<Signature = () -> ()>`
| Member | Type | Description |
| --- | --- | --- |
| :Disconnect() | `(self: Connection<Signature>) -> ()` | Disconnects the connection from the signal. |
| :Destroy() | `(self: Connection<Signature>) -> ()` | An alias for `:Disconnect()` for cleanup utils. |
| .Signal | `Signal<Signature>` | A reference to the signal the connection is for. |
| .Connected | `boolean` | Describes whether the connection is active. |
| .Callback | `(...any) -> ()` | The connected function. |