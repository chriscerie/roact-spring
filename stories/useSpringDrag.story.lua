local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local function Button(props, hooks)
    local styles, api = RoactSpring.useSpring(hooks, {
        from = {
            size = UDim2.fromOffset(200, 200),
            position = UDim2.fromScale(0.5, 0.5),
        },
    })
    local connection = hooks.useValue()

	return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = styles.position.value,
		Size = styles.size.value,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Transparency = 0.2,
        Text = "",

        [Roact.Event.InputBegan] = function(button, input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if not connection.value then
                    connection.value = RunService.Heartbeat:Connect(function()
                        local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)

                        api.start({
                            position = UDim2.fromOffset(mousePos.X, mousePos.Y),
                            size = UDim2.fromOffset(250, 250),
                        }, { tension = 410, friction = 20 })
                    end)
                end
            end
        end,
        [Roact.Event.InputEnded] = function(_,input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if connection.value then
                    api.start({
                        size = UDim2.fromOffset(200, 200),
                    }, ({ tension = 410, friction = 20 }))
                    connection.value:Disconnect()
                    connection.value = nil
                end
            end
        end
	}, {
        UICorner = e("UICorner", {
            CornerRadius = UDim.new(1, 0),
        }),
        UIGradient = e("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(134, 255, 195)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 175, 254)),
            }),
            Rotation = 25,
        }),
        UIStroke = e("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(29, 237, 255),
            Thickness = 5.3,
            Transparency = 0.7,
        }, {
            UIGradient = e("UIGradient", {
                Rotation = -90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
            }),
        }),
    })
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end