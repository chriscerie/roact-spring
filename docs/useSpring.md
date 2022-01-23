---
sidebar_position: 3
---

# useSpring

Defines values into animated values. To get started, initialize the `useSpring` hook.

```lua
local styles, api = RoactSpring.useSpring(hooks, {
    position = UDim2.fromScale(0.3, 0.3),
    rotation = 0,
}, {
    mass = 10, tension = 100, friction = 50,
})
```

Apply styles to components.

```lua
    return Roact.createElement("Frame", {
        Position = styles.position.value,
        Rotation = styles.rotation.value,
        Size = UDim2.fromScale(0.3, 0.3),
	})
```

Start animations.

```lua
api.start({
    position = UDim2.fromScale(0.5, 0.5),
    rotation = 0,
})
```

You can also specify configs for each animation.

```lua
api.start({
    position = UDim2.fromScale(0.5, 0.5),
    rotation = 0,
}, {
    mass = 10, tension = 100, friction = 50,
})
```

To run tasks after an animation has finished, chain the returned promise with `andThen`.

```lua
api.start({
    position = UDim2.fromScale(0.5, 0.5),
    rotation = 0,
}):andThen(function()
    print("Animation finished!")
end)
```