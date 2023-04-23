--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = React.createElement

local function Component()
    return e(React.Fragment, {}, {
        e(RoactSpring.Parallax, {
            pages = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(800, 500),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            BorderSizePixel = 0,
        }, {
            e(RoactSpring.ParallaxLayer, {
                offset = 0,
                speed = 0.5,
            }, {
                e("TextLabel", {
                    Text = "Scroll Down",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.5, 0.5),
                    BackgroundTransparency = 1,
                    TextSize = 40,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                })
            }),
            e(RoactSpring.ParallaxLayer, {
                sticky = {
                    start = 1,
                    finish = 3,
                },
                speed = 0.5,
            }, {
                e("TextLabel", {
                    Text = "I'm a sticky layer",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.fromScale(0.06, 0.5),
                    Size = UDim2.fromScale(0.4, 0.4),
                    TextSize = 25,
                }, {
                    UICorner = e("UICorner", {
                        CornerRadius = UDim.new(0.1, 0),
                    }),
                })
            }),
            e(RoactSpring.ParallaxLayer, {
                offset = 1.5,
                speed = 1.5,
            }, {
                e("TextLabel", {
                    Text = "I'm not",
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.fromScale(0.94, 0.5),
                    Size = UDim2.fromScale(0.4, 0.4),
                    TextSize = 25,
                }, {
                    UICorner = e("UICorner", {
                        CornerRadius = UDim.new(0.1, 0),
                    }),
                })
            }),
            e(RoactSpring.ParallaxLayer, {
                offset = 2.5,
                speed = 1.5,
            }, {
                e("TextLabel", {
                    Text = "Neither am I",
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.fromScale(0.94, 0.5),
                    Size = UDim2.fromScale(0.4, 0.4),
                    TextSize = 25,
                }, {
                    UICorner = e("UICorner", {
                        CornerRadius = UDim.new(0.1, 0),
                    }),
                })
            }),
            e(RoactSpring.ParallaxLayer, {
                offset = 4,
                speed = 1.5,
            }, {
                e("TextLabel", {
                    Text = "Scroll Up",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.5, 0.5),
                    BackgroundTransparency = 1,
                    TextSize = 40,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                })
            }),
        }),
    })
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
    root:render(ReactRoblox.createPortal({
        App = e(Component)
    }, target))

	return function()
		root:unmount()
	end
end
