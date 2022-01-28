---
sidebar_position: 10
---

# Spring

## Overview

Defines values into animated values. This should only be used with class components. If you are using hooks, use [useSpring](/docs/hooks/useSpring) instead.

```lua
self.styles, self.api = RoactSpring.Spring.new({
    position = UDim2.fromScale(0.3, 0.3),
    rotation = 0,
}, {
    mass = 10, tension = 100, friction = 50,
})
```

Apply styles to components.

```lua
return Roact.createElement("Frame", {
    Position = self.styles.position.value,
    Rotation = self.styles.rotation.value,
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

## Demos

### Draggable element

<a href="https://github.com/chriscerie/roact-spring/blob/main/stories/SpringDrag.story.lua">
  <img src="https://media.giphy.com/media/R2bJ57MNTdP7vmP6Ez/giphy.gif" width="400" />
</a>