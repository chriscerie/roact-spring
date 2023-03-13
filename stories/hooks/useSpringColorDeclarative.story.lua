--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = React.createElement

local function Button(_)
    local toggle, setToggle = React.useState(false)
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

        [React.Event.Activated] = function()
            setToggle(function(prevState)
                return not prevState
            end)
        end,
	}, {
        UICorner = e("UICorner"),
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
