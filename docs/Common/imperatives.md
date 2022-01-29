---
sidebar_position: 4
---

# Imperatives

The api table in the second value returned from a spring has the following functions:

```lua
local api = {
    -- Start your animation optionally giving new props to merge 
    start: (props) => Promise,
    -- Cancel some or all animations depending on the keys passed, no keys will cancel all.
    stop: (keys) => void,
    -- Pause some or all animations depending on the keys passed, no keys will pause all.
    pause: (keys) => void,
}
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