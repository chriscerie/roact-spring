<a href="https://www.chrisc.dev/roact-spring/">
  <p align="center">
    <img src="https://i.imgur.com/1Ta6WRv.png" width="200" />
  </p>
</a>

<h1 align="center">roact-spring</h1>
<h3 align="center">A modern spring-physics based </br> animation library for Roact inspired by react-spring</h3>

<br>

<div align="center">
  <a href="https://github.com/chriscerie/roact-spring/actions/workflows/docs.yml"><img src="https://github.com/chriscerie/roact-spring/workflows/docs/badge.svg" alt="Deploy Docs Status"/></a>
</div>

<br>

## Installation

### Wally

* Add the latest version of roact-spring to your wally.toml (e.g., `RoactSpring = "chriscerie/roact-spring@^0.0"`)

## Getting Started

Getting started with roact-spring is as simple as:

```lua
local styles, api = RoactSpring.useSpring(hooks, {
    from = {
        position = UDim2.fromScale(0.3, 0.3),
        rotation = 0,
    }
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
            tension = 170, friction = 26,
        }):andThen(function()
            print("Animation finished!")
        end)
    end,
})
```

More information can be found in roact-spring's official [documentation](https://www.chrisc.dev/roact-spring/).

## Demos

These demos are publicly available. Click on each gif to go to their source.

### Draggable element

<a href="stories/useSpringDrag.story.lua">
  <img src="https://media.giphy.com/media/R2bJ57MNTdP7vmP6Ez/giphy.gif" width="400" />
</a>

### Draggable list

<a href="stories/useSpringsList.story.lua">
  <img src="https://media.giphy.com/media/4qOEZ93YjhfKtSlx7b/giphy.gif" width="400" />
</a>

## License

`roact-spring` is available under the MIT license. See [LICENSE](LICENSE) for details.