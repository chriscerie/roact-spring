--!strict
--[[
    Note: Since this story uses performs mouse position calculations, this
    must be viewed in the Roblox Studio window to work properly.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
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
            size = UDim2.fromOffset(150, 150),
            position = UDim2.fromScale(0.5, 0.5),
            config = { tension = 100, friction = 10 },
        }
    end)
    local connection = React.useRef(nil :: RBXScriptConnection?)

	return e(CircleButton, {
        Position = styles.position,
		Size = styles.size,

        [React.Event.InputBegan] = function(_, input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if not connection.current then
                    connection.current = RunService.Heartbeat:Connect(function()
                        local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)

                        api.start({
                            position = UDim2.fromOffset(mousePos.X, mousePos.Y),
                            size = UDim2.fromOffset(180, 180),
                        })
                    end)
                end
            end
        end,
        [React.Event.InputEnded] = function(_,input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if connection.current then
                    api.start({ size = UDim2.fromOffset(150, 150) })
                    connection.current:Disconnect()
                    connection.current = nil
                end
            end
        end
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
