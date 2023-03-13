--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = React.createElement

local Example = React.Component:extend("Example")

function Example:init()
    self.styles, self.api = RoactSpring.Controller.new({
        position = UDim2.fromScale(0.5, 0.5),
    })
end

function Example:render()
    return e(CircleButton, {
        Position = self.styles.position,

        [React.Event.Activated] = function()
            self.api:start({
                position = UDim2.fromScale(0.5, 0.8),
            })
        end,
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
    root:render(ReactRoblox.createPortal({
        App = e(Example)
    }, target))

	return function()
		root:unmount()
	end
end