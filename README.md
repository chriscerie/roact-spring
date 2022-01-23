## Roact-Spring

<b>roact-spring</b> is a modern spring-physics based animation library for Roact inspired by react-spring. Instead of fixed durations, it uses physical properties like mass and tension to enable fluid and natural animations.

```lua
local styles, api = RoactSpring.useSpring(hooks, {
    position = UDim2.fromScale(0.3, 0.3),
    rotation = 0,
})

return Roact.createElement("TextButton", {
    Position = styles.position.value,
    Rotation = styles.rotation.value,
    Size = UDim2.fromScale(0.3, 0.3),
    [Roact.Event.Activated] = function()
        api.start({
            position = UDim2.fromScale(0.5, 0.5),
            rotation = 45,
        }, {
            bounce = 1,
            velocity = -0.05,
        }):andThen(function()
            print("Animation finished!")
        end)
    end,
})
```