--[[
	-- NamedSignal --
	
	v1.0.0

	A Luau signal implementation that lets you name and define variadic parameters — conveniently.

	Comprehensive documentation is available at: https://Nowoshire.github.io/NamedSignal/

	IMPORTANT:
		This library does NOT support the old typesolver, as it completely lacks the features necessary for this to work!

	COMPATIBILITY:
		If you require this to be backwards compatible with other signal libraries (generic type pack parameters), then you can
		define a new type that proxies the parameters in a functiontype:
		```luau
		export type GenericSignal<Params...> = Signal<(Params...) -> ()>
		```

	This software is licensed under the MIT License:
		https://github.com/Nowoshire/NamedSignal/blob/main/LICENSE

		MIT License

		Copyright (c) 2026 Nowoshire

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
]]

--!strict
--!optimize 2

-- Determines whether callbacks are deferred or called immediately.
-- NOTE: Deferred invocation causes a massive performance degradation; this is true for all signal libraries.
local DEFERRED_MODE = false

-- Thread Recycling --
local threadPool = {} :: {thread}

--[[
	Calls the given callback with the given arguments, then adds the given thread to the threadPool after it finishes execution.
]]
local function callAndAddThreadToPool(thread: thread, callback: (...any) -> (), ...: any)
	callback(...)
	-- Callback finished running, this thread is free again, add it back to the pool
	table.insert(threadPool, thread)
end

--[[
	Indefinitely looping function body of event handler coroutines.
	Gets resumed with functions to run followed by arguments to run them with.
]]
local function eventHandlerRoutine()
	while true do
		callAndAddThreadToPool(coroutine.yield())
	end
end

local resumeThread = if DEFERRED_MODE then task.defer else coroutine.resume

--[[
	Forces all properties in the given tabletype to be writable non-recursively.
]]
type function writable(ty: type)
	for keyType, rwType in ty:properties() do
		if not rwType.write then
			ty:setwriteproperty(keyType, rwType.read)
		end
	end

	return ty
end

-- Connection Class --
local Connection = {}
Connection.__index = Connection

-- Avoid setting metatables in this type, typesolver doesn't handle them too well.
export type Connection<Signature = () -> ()> = {
	read Signal: Signal<Signature>,
	read Connected: boolean,
	read Callback: Signature,

	read Disconnect: typeof(
		--[[
			Disconnects the connection from the signal.
		]]
		function(self: Connection<Signature>): () end
	),
	read Destroy: typeof(
		--[[
			Alias for <code>Connection:Disconnect()</code>.
			Disconnects the connection from the signal.
		]]
		function(self: Connection<Signature>): () end
	),
}

-- Internal type used for accessing properties that shouldn't be used by end user
type InternalConnection = {
	_prev: InternalConnection?,
	_next: InternalConnection?,
	Signal: InternalSignal,
} & writable<Connection>

--[[
	Disconnects the connection from the signal.
]]
function Connection.Disconnect(self: InternalConnection): ()
	-- Check that the connection is actually connected
	if not self.Connected then return end

	local signal = self.Signal
	local prv, nxt = self._prev, self._next

	self.Connected = false

	-- Replace the `_next` property of previous connection with the next connection if one exists
	-- Otherwise, this was the first connection, set the head (first connection) to next connection.
	if prv then
		prv._next = nxt
	else
		signal._head = nxt
	end

	-- Replace the `_prev` property of next connection with previous connection if one exists
	-- Otherwise, this was the last connection, set the tail (last connection) to previous connection.
	if nxt then
		nxt._prev = prv
	else
		signal._tail = prv
	end
end

-- Alias Destroy to `Connection.Disconnect` for cleanup utilities.
Connection.Destroy = Connection.Disconnect

-- Signal Class --
local Signal = {}
Signal.__index = Signal

--[[
	Generates the function signature for `Signal:Fire()`.
]]
type function SignalFireSignature(signal: type, signature: type, fallback: type): (type)
	local signatureTag = signature.tag
	if signatureTag == "unknown" then
		return fallback
	end

	if signatureTag ~= "function" then
		print(`Signal<Signature> expects a 'function' type for \`Signature\`, got '{signatureTag}' type instead.`)
		return fallback
	end

	local params = signature:parameters()
	local head = params.head
	if not head then
		head = {} :: {type}
		params.head = head
	end

	head = head :: {type}
	table.insert(head, 1, signal)
	return types.newfunction(params)
end

--[[
	Generates the function signature for `Signal:Wait()`.
]]
type function SignalWaitSignature(signal: type, signature: type, fallback: type): (type)
	local signatureTag = signature.tag
	if signatureTag == "unknown" then
		return fallback
	end

	if signatureTag ~= "function" then
		print(`Signal<Signature> expects a 'function' type for \`Signature\`, got '{signatureTag}' type instead.`)
		return fallback
	end

	return types.newfunction(
		{head = {signal}}, -- parameters
		signature:parameters() -- returns
	)
end

-- Avoid setting metatables in this type, typesolver doesn't handle them too well.
export type Signal<Signature = () -> ()> = {
	read Connect: typeof(
		--[[
			Connects the given function to the signal and returns a <code>Connection</code> that represents it.
		]]
		function(self: Signal<Signature>, func: Signature): (Connection<Signature>) return nil :: any end
	),

	read Once: typeof(
		--[[
			Connects the given function to the signal for a single invocation and returns a <code>Connection</code> that represents it.
		]]
		function(self: Signal<Signature>, func: Signature): (Connection<Signature>) return nil :: any end
	),

	read DisconnectAll: typeof(
		--[[
			Disconnects all connections from the signal.
		]]
		function(self: Signal<Signature>): () end
	),

	read Destroy: typeof(
		--[[
			Disconnects all connections from the signal, and removes its metatable.
		]]
		function(self: Signal<Signature>): () end
	),

	-- UDTF handled signatures --
	-- NOTE: Can't have signal as parameters in these signatures, not serializable by type functions.
	-- Unfortunately we do lose the names for Signal:Fire(), there isn't much that can be done about it.
	read Fire: SignalFireSignature<any, Signature, (any) -> ()>,
	read Wait: SignalWaitSignature<any, Signature, (any) -> ()>,
}

-- Internal type used for accessing properties that shouldn't be used by end user
type InternalSignal = {
	_head: InternalConnection?,
	_tail: InternalConnection?,
} & Signal

-- NOTE: The proper function signatures are set by the `Signal` type, we use internal types here to simplify the process of writing
-- these without hacky typecasting.

--[[
	Connects the given function to the signal and returns a <code>Connection</code> that represents it.
]]
local function newConnection(signal: InternalSignal, func: (...any) -> ()): (InternalConnection)
	local tail = signal._tail
	local connection = setmetatable({
		Connected = true,
		Callback = func,
		Signal = signal,
		_prev = tail,
	}, Connection) :: InternalConnection

	-- If tail connection exists: update it to point `_next` to this connection.
	-- Otherwise, this connection is the first connection, set signal head to it.
	if tail then
		tail._next = connection
	else
		signal._head = connection
	end

	-- Update tail connection
	signal._tail = connection

	return connection
end

Signal.Connect = newConnection

--[[
	Connects the given function to the signal for a single invocation and returns a <code>Connection</code> that represents it.
]]
function Signal.Once(self: InternalSignal, func: (...any) -> ()): (InternalConnection)
	local connection: InternalConnection; connection = newConnection(self, function(...)
		connection:Disconnect()
		func(...)
	end)

	return connection
end

-- NOTE: This docstring is never visible to end user, as UDTFs do not support attaching docstrings to functiontypes.
--[[
	Yields the current thread until the signal fires and returns the arguments provided by the signal.
]]
function Signal.Wait(self: InternalSignal): (...any) -- NOTE: UDTF handles the proper return type
	local thisThread = coroutine.running()
	local connection: InternalConnection; connection = newConnection(self, function(...)
		connection:Disconnect()
		coroutine.resume(thisThread, ...)
	end)

	return coroutine.yield()
end

-- NOTE: This docstring is never visible to end user, as UDTFs do not support attaching docstrings to functiontypes.
--[[
	Calls all connected functions and resumes all waiting threads with the given arguments.
]]
function Signal.Fire(self: InternalSignal, ...: any): () -- NOTE: UDTF handles the proper parameters
	local connection = self._head
	while connection do
		-- Every connection in the list should be connected, so we'll skip checking if it's connected here.
		local numThreads = #threadPool
		local thread: thread

		if numThreads == 0 then
			-- No thread available in pool, create and init a new runner thread.
			thread = task.spawn(eventHandlerRoutine)
		else
			-- A runner thread is available, yay!
			thread = threadPool[numThreads]
			threadPool[numThreads] = nil -- remove from free threads
		end

		resumeThread(thread, thread, connection.Callback, ...) -- (thread, callback, ...) -> ()

		-- Update for next iteration
		connection = connection._next
	end
end

--[[
	Disconnects all connections from the signal.
]]
local function disconnectAll(signal: InternalSignal)
	local connection = signal._head
	while connection do
		local nxt = connection._next
		connection.Connected = false
		connection._prev = nil
		connection._next = nil

		connection = nxt -- Update for next iteration
	end

	signal._head = nil
	signal._tail = nil
end

Signal.DisconnectAll = disconnectAll

--[[
	Disconnects all connections from the signal, and removes its metatable.
]]
function Signal.Destroy(self: InternalSignal): ()
	disconnectAll(self)
	setmetatable(self, nil)
end

-- Module --
local NamedSignal = {}

--[[
	Returns a new Signal.
]]
function NamedSignal.new<Signature>(): (Signal<Signature>)
	return setmetatable({}, Signal) :: any
end

return NamedSignal