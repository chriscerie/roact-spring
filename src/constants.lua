local constants = {}

constants.config = table.freeze({
    default = table.freeze({ tension = 170, friction = 26 }),
    gentle = table.freeze({ tension = 120, friction = 14 }),
    wobbly = table.freeze({ tension = 180, friction = 12 }),
    stiff = table.freeze({ tension = 210, friction = 20 }),
    slow = table.freeze({ tension = 280, friction = 60 }),
    molasses = table.freeze({ tension = 280, friction = 120 }),
})

return constants
