--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = React.createElement

local function Button(_)
    local toggle, setToggle = React.useState(false)
    local styles = RoactSpring.useSpring({
        from = { position = if toggle then UDim2.fromScale(0.3, 0.2) else UDim2.fromScale(0.7, 0.2) },
        to = { position = if toggle then UDim2.fromScale(0.7, 0.5) else UDim2.fromScale(0.3, 0.5) },
    }, { toggle })

	return e(CircleButton, {
        Position = styles.position,
        [React.Event.Activated] = function()
            setToggle(function(prevState)
                return not prevState
            end)
        end,
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
