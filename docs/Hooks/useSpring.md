---
sidebar_position: 5
---

# useSpring

## Overview

Defines values into animated values.

### Either: declaratively overwrite values to change the animation

If you pass a `to` table, roact-spring will animate to `to` on mount and on every re-render. If you don't want the animation to run on mount, ensure `to` = `from` on the first render.

```lua
local styles = RoactSpring.useSpring(hooks, {
    from = { transparency = 0 },
    to = { transparency = if toggle then 1 else 0 },
})
```

### Or: imperatively update using the api

If you don't pass a `to` table, you will get an api table back. It will not automatically animate on mount and re-render, but you can call `api.start` to start the animation. Handling updates like this is generally preferred as it's more powerful. Further documentation can be found in [Imperatives](/docs/common/imperatives).

```lua
local styles, api = RoactSpring.useSpring(hooks, {
    from = {
        position = UDim2.fromScale(0.3, 0.3),
        rotation = 0,
    },
    config = { mass = 10, tension = 100, friction = 50 }
})

-- Update spring with new props
api.start({
    position = UDim2.fromScale(0.5, 0.5),
    rotation = 0,
})
task.wait(1)
-- Stop animation after 1 second
api.stop()
```

### Finally: apply styles to components

```lua
return Roact.createElement("Frame", {
    Position = styles.position.value,
    Rotation = styles.rotation.value,
    Size = UDim2.fromScale(0.3, 0.3),
})
```

## Demos

### Draggable element

<a href="https://github.com/chriscerie/roact-spring/blob/main/stories/useSpringDrag.story.lua">
  <img src="https://media.giphy.com/media/R2bJ57MNTdP7vmP6Ez/giphy.gif" width="400" />
</a>