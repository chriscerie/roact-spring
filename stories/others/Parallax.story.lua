--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = React.createElement

local function Page(props: {
    offset: number,
    onActivated: () -> number,
    color: ColorSequence,
})
    return e(React.Fragment, {}, {
        e(RoactSpring.ParallaxLayer, {
            offset = props.offset,
            speed = 0.2,
        }, {
            -- Need to split into two smaller layers to avoid false positive optimizations
            e("TextButton", {
                Text = "",
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0, 0.8),
                BackgroundColor3 = Color3.fromRGB(32, 35, 47),
                Position = UDim2.fromScale(-0.1, 1.28),
                Rotation = 25,
                Size = UDim2.fromScale(0.88, 3),
                AutoButtonColor = false,
                [React.Event.Activated] = props.onActivated,
            }),
            e("TextButton", {
                Text = "",
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0, 0.8),
                BackgroundColor3 = Color3.fromRGB(32, 35, 47),
                Position = UDim2.fromScale(-0.31, 1.2),
                Rotation = 25,
                Size = UDim2.fromScale(0.88, 0.7),
                AutoButtonColor = false,
                [React.Event.Activated] = props.onActivated,
            }),
        }),
        e(RoactSpring.ParallaxLayer, {
            offset = props.offset,
            speed = 0.6,
        }, {
            e("TextButton", {
                Text = "",
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.fromScale(0.8, 0.5),
                Rotation = 25,
                Size = UDim2.fromScale(0.38, 2),
                AutoButtonColor = false,
                [React.Event.Activated] = props.onActivated,
            }, {
                UIGradient = e("UIGradient", {
                    Color = props.color,
                }),
            })
        }),
        e(RoactSpring.ParallaxLayer, {
            offset = props.offset,
            speed = 0.3,
        }, {
            e("TextLabel", {
                Text = `0{props.offset + 1}`,
                TextColor3 = Color3.fromRGB(84, 88, 100),
                TextSize = 100,
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(32, 35, 47),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(0.7, 2),
            })
        }),
    })
end

local function Component()
    local parallax = React.useRef(nil :: RoactSpring.IParallax?)

    return e(React.Fragment, {}, {
        e(RoactSpring.Parallax, {
            ref = parallax,
            pages = 3,
            horizontal = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromScale(0.8, 0.7),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ClipsDescendants = false,
            ScrollBarThickness = 0,
            BorderSizePixel = 0,
        }, {
            e(Page, {
                offset = 0,
                color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 94, 100)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 119, 85)),
                }),
                onActivated = function()
                    if parallax.current then
                        parallax.current.scrollTo(1)
                    end
                end,
            }),
            e(Page, {
                offset = 1,
                color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(33, 160, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 184, 252)),
                }),
                onActivated = function()
                    if parallax.current then
                        parallax.current.scrollTo(2)
                    end
                end,
            }),
            e(Page, {
                offset = 2,
                color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 170, 27)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 190, 15)),
                }),
                onActivated = function()
                    if parallax.current then
                        parallax.current.scrollTo(0)
                    end
                end,
            }),
        }),
        e("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.fromScale(1, 0.15),
            Position = UDim2.fromScale(0.5, 0),
            BorderSizePixel = 0,
        }),
        e("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.fromScale(0.1, 1),
            Position = UDim2.fromScale(1, 0.5),
            BorderSizePixel = 0,
        }),
        e("Frame", {
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.fromScale(1, 0.15),
            Position = UDim2.fromScale(0.5, 1),
            BorderSizePixel = 0,
        }),
        e("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.fromScale(0.1, 1),
            Position = UDim2.fromScale(0, 0.5),
            BorderSizePixel = 0,
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
