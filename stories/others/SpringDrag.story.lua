--[[
    Note: Since this story uses performs mouse position calculations, this
    must be viewed in the Roblox Studio window to work properly.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = Roact.createElement

local Example = Roact.Component:extend("Example")

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

        [Roact.Event.InputBegan] = function(button, input)
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
        [Roact.Event.InputEnded] = function(_,input)
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
	local handle = Roact.mount(e(Example), target, "Example")

	return function()
		Roact.unmount(handle)
	end
end
