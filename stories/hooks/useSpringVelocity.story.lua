--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = React.createElement

local function Button(_)
    local styles, api = RoactSpring.useSpring(function()
        return {
            position = UDim2.fromScale(0.5, 0.6),
            config = {
                friction = 8,
                velocity = { 0, 0, 0, -5 }
            },
        }
    end)

	return e(CircleButton, {
        Position = styles.position,

        [React.Event.Activated] = function()
            api.start({ position = UDim2.fromScale(0.5, 0.6) })
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
