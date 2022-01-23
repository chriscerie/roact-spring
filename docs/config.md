---
sidebar_position: 2
---

# Configs

Springs are configurable and can be tuned. If you want to adjust these settings, you can provide a default `config` table to `useSpring`:

```lua
    local styles, api = RoactSpring.useSpring(hooks, {
        position = UDim2.fromScale(0.5, 0.5),
        rotation = 0,
    }, { 
        mass = 10, tension = 100, friction = 50,
    })
```

Configs can also be adjusted when animating the spring. If there isn't any config provided, the default config will be used.

```lua
    api.start({
        position = UDim2.fromScale(0.5, 0.5),
        rotation = 0,
    }, { 
        mass = 10, tension = 100, friction = 50,
    })
```

The following configs are available:

| Property      | Default | Description  |
| ----------- | ----------- | ---- |
| mass | 1 | spring mass |
| tension | 170 | spring energetic load |
| friction | 26 | spring resistence |
| clamp | false | when true, stops the spring once it overshoots its boundaries |
| precision | 0.01 | how close to the end result the animated value gets before we consider it to be "there" |
| velocity | 0 | initial velocity |
| bounce | nil | When above zero, the spring will bounce instead of overshooting when exceeding its goal value. |
| restVelocity | nil | The smallest velocity before the animation is considered to be "not moving". When undefined, precision is used instead. |