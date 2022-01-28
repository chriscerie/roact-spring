---
sidebar_position: 4
---

# Imperatives

The api table in the second value returned from a spring has the following functions:

```lua
local api = {
    -- Start your animation optionally giving new props to merge 
    start: (props) => Promise,
    -- Cancel some or all animations depending on the keys passed, no keys will cancel all.
    stop: (keys) => void,
    -- Pause some or all animations depending on the keys passed, no keys will pause all.
    pause: (keys) => void,
}
```