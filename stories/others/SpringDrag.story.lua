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

local Example = React.Component:extend("Example")

function Example:init()
    self.styles, self.api = RoactSpring.Controller.new({
        size = UDim2.fromOffset(150, 150),
        position = UDim2.fromScale(0.5, 0.5),
    })
end

function Example:render()
	return e(CircleButton, {
        Position = self.styles.position,
		Size = self.styles.size,

        [React.Event.InputBegan] = function(button, input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if not self.connection then
                    self.connection = RunService.Heartbeat:Connect(function()
                        local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)

                        self.api:start({
                            position = UDim2.fromOffset(mousePos.X, mousePos.Y),
                            size = UDim2.fromOffset(180, 180),
                            config = { tension = 100, friction = 10 },
                        })
                    end)
                end
            end
        end,
        [React.Event.InputEnded] = function(_,input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if self.connection then
                    self.api:start({
                        size = UDim2.fromOffset(150, 150),
                        config = { tension = 100, friction = 10 },
                    })
                    self.connection:Disconnect()
                    self.connection = nil
                end
            end
        end
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
    root:render(ReactRoblox.createPortal({
        App = e(Example)
    }, target))

	return function()
		root:unmount()
	end
end
