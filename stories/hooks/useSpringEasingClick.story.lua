--!strict
--[[
    Note: Since this story uses performs mouse position calculations, this
    must be viewed in the Roblox Studio window to work properly.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = React.createElement

local function Button(_)
    local styles, api = RoactSpring.useSpring(function()
        return {
            position = UDim2.fromScale(0.5, 0.5),
        }
    end)

    React.useEffect(function()
        local conn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)
                api.start({
                    position = UDim2.fromOffset(mousePos.X, mousePos.Y),
                    config = { duration = 3, easing = RoactSpring.easings.easeInElastic },
                })
            end
        end)

        return function()
            conn:Disconnect()
        end
    end)

	return e(CircleButton, {
        Position = styles.position,
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
