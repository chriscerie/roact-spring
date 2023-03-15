--!strict
local Collections = require(script.Parent.Parent.Parent.Parent.Packages.Collections)

export type IParallax = {
    config: any,
    horizontal: boolean,
    busy: boolean,
    space: number,
    offset: number,
    -- Canvas position
    current: number,
    layers: typeof(Collections.Set.new(nil)),
    container: any,
    content: any,
    scrollTo: (offset: number) -> nil,
    update: () -> nil,
    stop: () -> nil,

    _styles: any,
    _api: any
}

export type ParallaxProps = {
    pages: number,
    config: any?,
    horizontal: boolean?,
    children: any,
} & {
    [string]: any
}

export type StickyConfig = {
    start: number?,
    -- DEVIATION: `end` is a reserved keyword in Lua
    finish: number?,
}?

export type IParallaxLayer = {
    horizontal: boolean,
    sticky: StickyConfig,
    isSticky: boolean,
    setHeight: (height: number, immediate: boolean?) -> nil,
    setPosition: (height: number, scrollTop: number, immediate: boolean?) -> nil,
}

export type ParallaxLayerProps = {
    horizontal: boolean?,
    -- Size of a page, (1 = 100%, 1.5 = 3/2, ...)
    factor: number?,
    -- Determines where the layer will be at when scrolled to (0=start, 1=1st page, ...)
    offset: number?,
    -- Shifts the layer in accordance to its offset, values can be positive or negative
    speed: number?,
    -- Layer will be sticky between these two offsets, all other props are ignored
    sticky: StickyConfig?,

    children: any,
} & {
    [string]: any
}

return {}
