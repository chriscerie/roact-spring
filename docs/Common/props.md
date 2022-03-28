---
sidebar_position: 2
---

# Props

## Overview

```lua
RoactSpring.useSpring(hooks, {
    from = { ... }
})
```

All primitives inherit the following properties (though some of them may bring their own additionally):

| Property | Type | Description  |
| ----------- | ----------- | ---- |
| from | table | Starting values |
| to | table | Animates to ... |
| delay | number | Delay in seconds before the animation starts |
| immediate | boolean | Prevents animation if true. |
| [config](configs) | table | Spring config (contains mass, tension, friction, etc) |
| reset | bool | The spring starts to animate from scratch (from -> to) if set true |

## Advanced Props

### Reset prop

Use the `reset` prop to start the animation from scratch. When undefined in imperative updates, the spring will assume `reset` is true if `from` is passed. 

```lua
local styles, api = RoactSpring.useSpring(hooks, function()
    return { transparency = 0.5 }
end)

-- The spring will start from 0
api.start({
    from = { transparency = 0 },
    to = { transparency = 1 },
})

-- The spring will ignore `from` and start from its current position
api.start({
    reset = false,
    from = { transparency = 0 },
    to = { transparency = 1 },
})
```

In declarative updates, the spring will assume reset is false if reset is not passed in.

```lua
-- The spring will start from 0.2 on mount and ignore `from` on future updates
local styles = RoactSpring.useSpring(hooks, {
    from = { transparency = 0.2 },
    to = { transparency = if toggle then 0 else 1 },
}, { toggle })

-- The spring will always start from scratch from 0.2
local styles = RoactSpring.useSpring(hooks, {
    reset = true,
    from = { transparency = 0.2 },
    to = { transparency = if toggle then 0 else 1 },
}, { togge })
```

## Default Props

### Imperative updates

Imperative updates inherit default props declared from passing props to `useSprings` or `useSpring`.

```lua
local styles, api = RoactSpring.useSpring(hooks, function()
    return {
        position = UDim2.fromScale(0.5, 0.5) ,
        config = { tension = 100 },
    }
end)

hooks.useEffect(function()
    -- The `config` prop is inherited by the animation
    -- Spring will animate with tension at 100
    api.start({ position = UDim2.fromScale(0.3, 0.3) })
end)
```

### Compatible props

The following props can have default values:

* `config`
* `immediate`
