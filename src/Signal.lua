--[[
    @Quenty/NevermoreEngine
]]

local HttpService = game:GetService("HttpService")

local ENABLE_TRACEBACK = false

local Signal = {}
Signal.__index = Signal
Signal.ClassName = "Signal"

function Signal.isSignal(value)
	return type(value) == "table" and getmetatable(value) == Signal
end

function Signal.new()
	local self = setmetatable({}, Signal)

	self._bindableEvent = Instance.new("BindableEvent")
	self._argMap = {}
	self._source = ENABLE_TRACEBACK and debug.traceback() or ""

	-- Events in Roblox execute in reverse order as they are stored in a linked list and
	-- new connections are added at the head. This event will be at the tail of the list to
	-- clean up memory.
	self._bindableEvent.Event:Connect(function(key)
		self._argMap[key] = nil

		-- We've been destroyed here and there's nothing left in flight.
		-- Let's remove the argmap too.
		-- This code may be slower than leaving this table allocated.
		if not self._bindableEvent and (not next(self._argMap)) then
			self._argMap = nil
		end
	end)

	return self
end

function Signal:Fire(...)
	if not self._bindableEvent then
		warn(("Signal is already destroyed. %s"):format(self._source))
		return
	end

	local args = table.pack(...)

	-- TODO: Replace with a less memory/computationally expensive key generation scheme
	local key = HttpService:GenerateGUID(false)
	self._argMap[key] = args

	-- Queues each handler onto the queue.
	self._bindableEvent:Fire(key)
end

function Signal:Connect(handler)
	if not (type(handler) == "function") then
		error(("connect(%s)"):format(typeof(handler)), 2)
	end

	return self._bindableEvent.Event:Connect(function(key)
		-- note we could queue multiple events here, but we'll do this just as Roblox events expect
		-- to behave.

		local args = self._argMap[key]
		if args then
			handler(table.unpack(args, 1, args.n))
		else
			error("Missing arg data, probably due to reentrance.")
		end
	end)
end

function Signal:Wait()
	local key = self._bindableEvent.Event:Wait()
	local args = self._argMap[key]
	if args then
		return table.unpack(args, 1, args.n)
	else
		error("Missing arg data, probably due to reentrance.")
		return nil
	end
end

function Signal:Destroy()
	if self._bindableEvent then
		-- This should disconnect all events, but in-flight events should still be
		-- executed.

		self._bindableEvent:Destroy()
		self._bindableEvent = nil
	end

	-- Do not remove the argmap. It will be cleaned up by the cleanup connection.

	setmetatable(self, nil)
end

return Signal
