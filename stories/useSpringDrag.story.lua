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
            Rotation = 0,
            Position = UDim2.fromScale(0.5, 0.5),
        },
    })
    local connection = hooks.useValue()

	return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = styles.Position.value,
		Size = UDim2.fromScale(0.3, 0.3),
		BackgroundColor3 = Color3.fromRGB(99, 255, 130),
        Rotation = styles.Rotation.value,
        Text = "Click me",

        [Roact.Event.InputBegan] = function(button, input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if not connection.value then
                    connection.value = RunService.Heartbeat:Connect(function()
                        local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)

                        api.start({
                            Position = UDim2.fromOffset(mousePos.X, mousePos.Y),
                        })
                    end)
                end
            end
        end,
        [Roact.Event.InputEnded] = function(_,input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if connection.value then
                    connection.value:Disconnect()
                    connection.value = nil
                end
            end
        end
	}, {
        UICorner = e("UICorner"),
    })
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end