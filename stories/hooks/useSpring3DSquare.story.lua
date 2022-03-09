local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local function Button(_, hooks)
    local styles, api = RoactSpring.useSpring(hooks, function()
        return {
            topRotate = 0,
            topOffset = 0,
            bottomRotate = 0,
            bottomOffset = 0,
            leftRotate = 0,
            leftOffset = 0,
            rightRotate = 0,
            rightOffset = 0,
        }
    end)
    local buttonRef = hooks.useValue(Roact.createRef())

    hooks.useEffect(function()
        local connection = RunService.Heartbeat:Connect(function()
            local button = buttonRef.value:getValue()
            if button then
                local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)
                local percentX = (mousePos.x - button.AbsolutePosition.X) / button.AbsoluteSize.X
                local percentY = (mousePos.y - button.AbsolutePosition.Y) / button.AbsoluteSize.Y

                if percentX >= 0 and percentY >= 0 then
                    api.start({
                        topRotate = percentX * 8 - 4,
                        topOffset = (if percentY < 0.5 then (0.5 - percentY) * 40 else 0) - 30,
                        bottomRotate = -(percentX * 8 - 4),
                        bottomOffset = (if percentY > 0.5 then (0.5 - percentY) * 40 else 0) + 30,
                        leftRotate = -(percentY * 8 - 4),
                        leftOffset = (if percentX < 0.5 then (0.5 - percentX) * 40 else 0) - 30,
                        rightRotate = percentY * 8 - 4,
                        rightOffset = (if percentX > 0.5 then (0.5 - percentX) * 40 else 0) + 30,
                    })
                else
                    api.start({
                        topRotate = 0,
                        topOffset = 0,
                        bottomRotate = 0,
                        bottomOffset = 0,
                        leftRotate = 0,
                        leftOffset = 0,
                        rightRotate = 0,
                        rightOffset = 0,
                    })
                end
            end
        end)

        return function()
            connection:Disconnect()
        end
    end)

	return Roact.createFragment({
        Top = e("Frame", {
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(230, 230, 230),
            BorderSizePixel = 0,
            Position = styles.topOffset:map(function(offset)
                return UDim2.new(0.5, 0, 0.5, -150 + offset)
            end),
            Size = UDim2.fromScale(1, 1),
            Rotation = styles.topRotate,
        }),
        Bottom = e("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(230, 230, 230),
            BorderSizePixel = 0,
            Position = styles.bottomOffset:map(function(offset)
                return UDim2.new(0.5, 0, 0.5, 150 + offset)
            end),
            Size = UDim2.fromScale(1, 1),
            Rotation = styles.bottomRotate,
        }),
        Left = e("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Color3.fromRGB(230, 230, 230),
            BorderSizePixel = 0,
            Position = styles.leftOffset:map(function(offset)
                return UDim2.new(0.5, -150 + offset, 0.5, 0)
            end),
            Size = UDim2.fromScale(1, 1),
            Rotation = styles.leftRotate,
        }),
        Right = e("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(230, 230, 230),
            BorderSizePixel = 0,
            Position = styles.rightOffset:map(function(offset)
                return UDim2.new(0.5, 150 + offset, 0.5, 0)
            end),
            Size = UDim2.fromScale(1, 1),
            Rotation = styles.rightRotate,
        }),
        Center = e("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 148, 247),
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 0,
        }, {
            Button = e("Frame", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(400, 400),
                [Roact.Ref] = buttonRef.value,
            })
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
