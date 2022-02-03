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
| immediate | boolean | Prevents animation if true. |
| [config](configs) | table | 	Spring config (contains mass, tension, friction, etc) |

## Default props

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

