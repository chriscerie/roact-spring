---
sidebar_position: 6
---

# useSprings

## Overview

Creates multiple springs, each with its own config. Use it for static lists, etc.

Pass in the length as well as a function that returns the props for each spring.

```lua
local springs, api = RoactSpring.useSprings(hooks, 4, function(index)
    return {
        from = { Position = UDim2.fromScale(0.5, index * 0.16) },
    }
end)
```

Apply styles to components.

```lua
local contents = {}
for i = 1, 4 do
    contents[i] = Roact.createElement("Frame", {
        Position = springs[i].Position,
        Size = UDim2.fromScale(0.3, 0.3),
    })
end
return contents
```

Start animations.

```lua
api.start(function(index)
    return { Position = UDim2.fromScale(0.5 * index, 0.16) }
end)
```

## Properties

All properties documented in the [common props](/docs/common/props) apply.

## Demos

### Draggable list

<a href="https://github.com/chriscerie/roact-spring/blob/main/stories/useSpringsList.story.lua">
  <img src="https://media.giphy.com/media/4qOEZ93YjhfKtSlx7b/giphy.gif" width="400" />
</a>