--[[
    Note: Since this story uses performs mouse position calculations, this
    must be viewed in the Roblox Studio window to work properly.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local buttonColors = {
    Color3.fromRGB(167, 229, 255),
    Color3.fromRGB(165, 255, 180),
    Color3.fromRGB(255, 203, 179),
    Color3.fromRGB(232, 221, 255),
}

local function Button(_, hooks)
    local styles, api = RoactSpring.useTrail(hooks, #buttonColors, function(i)
        return {
            position = UDim2.fromScale(0.5, 0.5),
            config = { damping = 1, frequency = 0.3 + i * 0.03 },
            zindex = -i,
        }
    end)
    
    hooks.useEffect(function()
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

	return Roact.createFragment(contents)
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end
