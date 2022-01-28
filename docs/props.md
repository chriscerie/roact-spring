---
sidebar_position: 2
---

# Props

```lua
RoactSpring.useSpring(hooks, {
    from = { ... }
})
```

All primitives inherit the following properties (though some of them may bring their own additionally):

| Property | Type | Description  |
| ----------- | ----------- | ---- |
| from | table | Starting values |
| [Configs](config) | table | 	Spring config (contains mass, tension, friction, etc) |
