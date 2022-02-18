local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local textList = { "Lorem", "Ipsum", "Dolor", "Sit" }

local function Button(_, hooks)
    local toggle, setToggle = hooks.useState(true)

    local springProps = {}
    for _ in ipairs(textList) do
        table.insert(springProps, {
            size = UDim2.fromScale(1, if toggle then 0.1 else 1),
            position = UDim2.fromOffset(if toggle then 0 else 20, 0),
            transparency = if toggle then 0 else 1,
            config = { damping = 1, frequency = 0.3 },
        })
    end
    local springs = RoactSpring.useTrail(hooks, #textList, springProps)

    local contents = {}

    for index, text in ipairs(textList) do
        contents[text] = e("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 77),
            LayoutOrder = index,
        }, {
            Text = e("TextLabel", {
                BackgroundTransparency = 1,
                Position = springs[index].position,
                Size = UDim2.fromScale(1, 1),
                Font = Enum.Font.GothamBlack,
                TextColor3 = Color3.fromRGB(0, 0, 0),
                TextTransparency = springs[index].transparency,
                TextSize = 100,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = text,
            }, {
                Cover = e("Frame", {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 7),
                    Size = springs[index].size,
                    BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                    BorderSizePixel = 0,
                }),
            })
            
        })
    end

    return e("TextButton", {
        BackgroundColor3 = Color3.fromRGB(240, 240, 240),
        Size = UDim2.fromScale(1, 1),
        AutoButtonColor = false,
        Text = "",

        [Roact.Event.Activated] = function()
            setToggle(function(prevState)
                return not prevState
            end)
        end,
    }, {
        Frame = e("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(300, 320),
            BackgroundTransparency = 1,
        }, {
            UIListLayout = e("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            Text = Roact.createFragment(contents),
        })
    })
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end
