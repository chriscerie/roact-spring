--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = React.createElement
local STOP_AFTER_SECONDS = 3

local function Button(_)
    local styles, api = RoactSpring.useSpring(function()
        return {
            position = UDim2.fromScale(0.5, 0.3),
        }
    end)

	return e(CircleButton, {
        Position = styles.position,
        [React.Event.Activated] = function()
            api.start({
                to = { position = UDim2.fromScale(0.5, 0.8) },
                config = { mass = 2.5, bounce = 1, tension = 180, friction = 0 },
            })
            task.wait(STOP_AFTER_SECONDS)
            api.stop()
        end
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
    root:render(ReactRoblox.createPortal({
        App = e(Button)
    }, target))

	return function()
		root:unmount()
	end
end
