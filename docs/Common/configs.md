---
sidebar_position: 3
---

# Configs

Springs are configurable and can be tuned. If you want to adjust these settings, you can provide a default `config` table to `useSpring`:

```lua
local styles, api = RoactSpring.useSpring(hooks, function()
    return {
        from = {
            position = UDim2.fromScale(0.5, 0.5),
            rotation = 0,
        },
        config = { mass = 10, tension = 100, friction = 50 },
    }
})
```

Configs can also be adjusted when animating the spring. If there isn't any config provided, the default config will be used.

```lua
api.start({
    to = {
        position = UDim2.fromScale(0.5, 0.5),
        rotation = 0,
    },
    config = { mass = 10, tension = 100, friction = 50 },
})
```

The following configs are available:

| Property      | Default | Description  |
| ----------- | ----------- | ---- |
| mass | 1 | spring mass |
| tension | 170 | spring energetic load |
| friction | 26 | spring resistence |
| clamp | false | when true, stops the spring once it overshoots its boundaries |
| precision | 0.005 | how close to the end result the animated value gets before we consider it to be "there" |
| easing | t => t | linear by default, there is a multitude of easings available [here](/docs/common/configs#easings) |
| duration | nil | if > than 0, will switch to a duration-based animation instead of spring physics, value should be indicated in seconds (e.g. duration: 2 for a duration of 2s) |
| bounce | nil | When above zero, the spring will bounce instead of overshooting when exceeding its goal value. |
| restVelocity | nil | The smallest velocity before the animation is considered to be "not moving". When undefined, precision is used instead. |

<iframe src="https://codesandbox.io/embed/react-spring-config-x1vjb?fontsize=14&hidenavigation=1&theme=dark&view=preview"
    width="100%"
    height="500"
    title="react-spring-config"
    allow="accelerometer; ambient-light-sensor; camera; encrypted-media; geolocation; gyroscope; hid; microphone; midi; payment; usb; vr; xr-spatial-tracking"
    sandbox="allow-forms allow-modals allow-popups allow-presentation allow-same-origin allow-scripts"
></iframe>

## Presets

There are also a couple of generic presets that will cover some common ground.

```lua
RoactSpring.config = {
    default = { mass: 1, tension: 170, friction: 26 },
    gentle = { mass: 1, tension: 120, friction: 14 },
    wobbly = { mass: 1, tension: 180, friction: 12 },
    stiff = { mass: 1, tension: 210, friction: 20 },
    slow = { mass: 1, tension: 280, friction: 60 },
    molasses = { mass: 1, tension: 280, friction: 120 },
}
```

<iframe src="https://codesandbox.io/embed/react-spring-preset-configs-kdv7r?fontsize=14&hidenavigation=1&theme=dark&view=preview"
    width="100%"
    height="500"
    title="react-spring-config"
    allow="accelerometer; ambient-light-sensor; camera; encrypted-media; geolocation; gyroscope; hid; microphone; midi; payment; usb; vr; xr-spatial-tracking"
    sandbox="allow-forms allow-modals allow-popups allow-presentation allow-same-origin allow-scripts"
></iframe>

## Easings

While react-spring should generally be used to with springs, sometimes parameterizing animations with durations may be required (e.g., timers).

The following easing functions are supported when `duration` is set.

| In            | Out            | In Out           |
| ------------- | -------------- | ---------------- |
| easeInBack    | easeOutBack    | easeInOutBack    |
| easeInBounce  | easeOutBounce  | easeInOutBounce  |
| easeInCirc    | easeOutCirc    | easeInOutCirc    |
| easeInCubic   | easeOutCubic   | easeInOutCubic   |
| easeInElastic | easeOutElastic | easeInOutElastic |
| easeInExpo    | easeOutExpo    | easeInOutExpo    |
| easeInQuad    | easeOutQuad    | easeInOutQuad    |
| easeInQuart   | easeOutQuart   | easeInOutQuart   |
| easeInQuint   | easeOutQuint   | easeInOutQuint   |
| easeInSine    | easeOutSine    | easeInOutSine    |

```lua
api.start({
    to = {
        position = UDim2.fromScale(0.5, 0.5),
        rotation = 0,
    },
    config = { mass: 10, tension: 100, friction: 50 },
})
```

:::caution ONLY UPDATE IMPERATIVELY
Due to the way easings handle interuptions, it is recommended to only update the spring values imperatively. Setting the target value midway will cause the duration timer to reset.
:::caution