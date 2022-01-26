<p align="center">
  <img src="https://i.imgur.com/1Ta6WRv.png" width="200" />
</p>

<h1 align="center">roact-spring</h1>
<h3 align="center">A modern spring-physics based </br> animation library for Roact inspired by react-spring</h3>

<br>

## Installation

### Wally

* Add the latest version of roact-spring to your wally.toml (e.g., `RoactSpring = "chriscerie/roact-spring@^0.0"`)

## A Simple Example

Getting started with roact-spring is as simple as:

```lua
local styles, api = RoactSpring.useSpring(hooks, {
    position = UDim2.fromScale(0.3, 0.3),
    rotation = 0,
})

return Roact.createElement("TextButton", {
    Position = styles.position,
    Rotation = styles.rotation,
    Size = UDim2.fromScale(0.3, 0.3),
    [Roact.Event.Activated] = function()
        api.start({
            position = UDim2.fromScale(0.5, 0.5),
            rotation = 45,
        }, {
            tension = 170,
            friction = 26,
        }):andThen(function()
            print("Animation finished!")
        end)
    end,
})
```

## Demos

[View source](./useSpringsList)
<img src="https://media.giphy.com/media/4qOEZ93YjhfKtSlx7b/giphy.gif" width="400" />

[View source](./useSpringDrag)
<img src="https://media.giphy.com/media/R2bJ57MNTdP7vmP6Ez/giphy.gif" width="400" />