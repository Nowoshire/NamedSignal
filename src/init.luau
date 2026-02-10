--[[
	-- NamedSignal --
	
	v1.2.0

	A zero compromises Luau signal implementation, designed for Synchronous Functional Reactive Programming (FRP) with
	Atomic Propagation, that also lets you name and define variadic parameters!

	NamedSignal is GohanDucis's Class 3 Signal certified:
		https://devforum.roblox.com/t/signal-certifications-classes-guide/4263792

	Comprehensive documentation is available at:
		https://Nowoshire.github.io/NamedSignal

	NOTICE:
		This library's types are not compatible with the old solver!

	COMPATIBILITY:
		If you require this to be backwards compatible with other signal libraries that use generic type pack parameters
		then you can define a new type that proxies the parameters in a functiontype:
		```luau
		export type GenericSignal<Params...> = Signal<(Params...) -> ()>
		```

		Full compatibility details are available at:
			https://Nowoshire.github.io/NamedSignal/compatibility

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

-- Re-entrancy Helpers --

--[[
	Adds and yields the current running thread to the back of the last level reentrants list, or creating a new level if one does not exist.
]]
local function enqueueReentrant(reentrantsList: {{thread}})
	local levels = #reentrantsList
	if levels == 0 then
		reentrantsList[1] = {coroutine.running()}
	else
		table.insert(reentrantsList[levels], coroutine.running())
	end

	coroutine.yield() -- wait to be resumed
end

--[[
	Adds and yields the current running thread to a new reentrant level in the given reentrants list.
]]
local function enqueueReentrantLevel(reentrantsList: {{thread}})
	table.insert(reentrantsList, {coroutine.running()})
	coroutine.yield() -- wait to be resumed
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

			<code><strong>skipReentrancy</strong>: boolean?</code>
			Whether to skip re-entrancy and disconnect the connection immediately, disregarding snapshot rules.
		]]
		function(self: Connection<Signature>, skipReentrancy: boolean?): () end
	),
	read Destroy: typeof(
		--[[
			Alias for <code>Connection:Disconnect()</code>.
			Disconnects the connection from the signal.

			<code><strong>skipReentrancy</strong>: boolean?</code>
			Whether to skip re-entrancy and disconnect the connection immediately, disregarding snapshot rules.
		]]
		function(self: Connection<Signature>, skipReentrancy: boolean?): () end
	),
}

-- Internal type used for accessing members that shouldn't be used by end user
type InternalConnection = {
	_prev: InternalConnection?,
	_next: InternalConnection?,
	_mono: number, -- Used for preventing connections made during invocation from firing in the same invocation
	Signal: InternalSignal,
} & writable<Connection>

--[[
	Disconnects the connection from the signal.

	<code><strong>skipReentrancy</strong>: boolean?</code>
	Whether to skip re-entrancy and disconnect the connection immediately, disregarding snapshot rules.
]]
function Connection.Disconnect(self: InternalConnection, skipReentrancy: boolean?): ()
	-- Check that the connection is actually connected
	if not self.Connected then return end

	local signal = self.Signal
	if not skipReentrancy and signal._firing then
		enqueueReentrant(signal._reentrants)
	end

	self.Connected = false
	local prv, nxt = self._prev, self._next

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

-- Internal type used for accessing members that shouldn't be used by end user
type InternalSignal = {
	_head: InternalConnection?,
	_tail: InternalConnection?,
	_maxMono: number, -- for preventing new connections made during invocation from firing in the same invocation
	_firing: true?,
	_reentrants: {{thread}}, -- {[re-entrancy level]: {thread}}
} & Signal

-- NOTE: The proper function signatures are set by the `Signal` type, we use internal types here to simplify the process of writing
-- these without hacky typecasting.

--[[
	Connects the given function to the signal and returns a <code>Connection</code> that represents it.
]]
local function newConnection(signal: InternalSignal, func: (...any) -> ()): (InternalConnection)
	if signal._firing then
		enqueueReentrant(signal._reentrants)
	end

	signal._maxMono += 1

	local tail = signal._tail
	local connection = setmetatable({
		Connected = true,
		Callback = func,
		Signal = signal,
		_prev = tail,
		_mono = signal._maxMono,
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
		connection:Disconnect(true)
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
		connection:Disconnect(true)
		coroutine.resume(thisThread, ...)
	end)

	return coroutine.yield()
end

-- NOTE: This docstring is never visible to end user, as UDTFs do not support attaching docstrings to functiontypes.
--[[
	Calls all connected functions and resumes all waiting threads with the given arguments.
]]
function Signal.Fire(self: InternalSignal, ...: any): () -- NOTE: UDTF handles the proper parameters
	-- Defer re-entrant fires to respect deferred mutations
	local reentrants = self._reentrants
	if self._firing then
		-- Create new re-entrancy level and wait to be resumed
		enqueueReentrantLevel(reentrants)
	else
		self._firing = true
	end
	
	local maxMono = self._maxMono -- Keep track of the max monotonic counter to prevent invoking connections made during invocation
	local connection = self._head
	while connection do
		-- Prevent new connections made during invocation from firing in the same invocation
		if connection._mono > maxMono then
			break
		end

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

	-- Resume first level reentrants
	local reentrant = reentrants[1]
	if reentrant then
		-- We could use linked lists for O(1)
		-- but it wouldn't meaningfully improve performance outside of extreme cases.
		table.remove(reentrants, 1)
		
		-- Check if all fires have completed and reset _firing flag.
		-- Reset this flag before resuming threads
		if not reentrants[1] then
			self._firing = nil
		end

		for _, thread in reentrant do
			coroutine.resume(thread)
		end
	else
		self._firing = nil
	end
end

-- Currently, we do not allow bypassing re-entrancy for DisconnectAll/Destroy.
-- Doing so would require cancelling threads and never resuming them, creating a major risk of hidden
-- and hard to diagnose bugs, which we'd like to avoid.

local function baseDisconnectAll(signal: InternalSignal)
	if signal._firing then
		enqueueReentrant(signal._reentrants)
	end

	local connection = signal._head
	while connection do
		-- We don't need to remove _next and _prev
		connection.Connected = false
		connection = connection._next -- Update for next iteration
	end
end

--[[
	Disconnects all connections from the signal.
]]
function Signal.DisconnectAll(self: InternalSignal): ()
	baseDisconnectAll(self)
	self._head = nil
	self._tail = nil
	self._maxMono = 0 -- reset monotonic counter as it's now safe to do so.
end

--[[
	Disconnects all connections from the signal, and removes its metatable.
]]
function Signal.Destroy(self: InternalSignal): ()
	baseDisconnectAll(self)
	table.clear(self)
	setmetatable(self, nil)
end

-- Module --
local NamedSignal = {}

--[[
	Returns a new Signal.
]]
function NamedSignal.new<Signature>(): (Signal<Signature>)
	return setmetatable({
		_maxMono = 0,
		_reentrants = {},
	}, Signal) :: any
end

return NamedSignal