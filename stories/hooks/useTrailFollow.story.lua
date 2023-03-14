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

local e = React.createElement

local buttonColors = {
    Color3.fromRGB(167, 229, 255),
    Color3.fromRGB(165, 255, 180),
    Color3.fromRGB(255, 203, 179),
    Color3.fromRGB(232, 221, 255),
}

local function Button(_)
    local styles, api = RoactSpring.useTrail(#buttonColors, function(i)
        return {
            position = UDim2.fromScale(0.5, 0.5),
            config = { damping = 1, frequency = 0.3 + i * 0.03 },
            zindex = -i,
        }
    end)
    
    React.useEffect(function()
        local conn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)
                api.start(function()
                    return { position = UDim2.fromOffset(mousePos.X, mousePos.Y) }
                end)
            end
        end)

        return function()
            conn:Disconnect()
        end
    end)

    local contents = {}

    for index, buttonColor in ipairs(buttonColors) do
        contents[index] = e("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = styles[index].position,
            Size = UDim2.fromOffset(70, 70),
            BackgroundColor3 = buttonColor,
            ZIndex = styles[index].zindex,
        }, {
            UICorner = e("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }),
        })
    end

	return e(React.Fragment, nil, contents)
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
