local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local function Button(_)
    local toggle, setToggle = Roact.useState(false)
    local styles = RoactSpring.useSpring({
        color = if toggle then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(255, 255, 255),
    })

	return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(200, 200),
		BackgroundColor3 = styles.color,
        AutoButtonColor = false,
        Text = "",

        [Roact.Event.Activated] = function()
            setToggle(function(prevState)
                return not prevState
            end)
        end,
	}, {
        UICorner = e("UICorner"),
    })
end

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end
