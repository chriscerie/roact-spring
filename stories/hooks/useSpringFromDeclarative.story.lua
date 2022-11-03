local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = Roact.createElement

local function Button(_)
    local toggle, setToggle = Roact.useState(false)
    local styles = RoactSpring.useSpring({
        from = { position = if toggle then UDim2.fromScale(0.3, 0.2) else UDim2.fromScale(0.7, 0.2) },
        to = { position = if toggle then UDim2.fromScale(0.7, 0.5) else UDim2.fromScale(0.3, 0.5) },
    }, { toggle })

	return e(CircleButton, {
        Position = styles.position,
        [Roact.Event.Activated] = function()
            setToggle(function(prevState)
                return not prevState
            end)
        end,
	})
end

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end
