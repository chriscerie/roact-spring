--!strict
local RunService = game:GetService("RunService")

local React = require(script.Parent.Parent.Parent.Packages.React)
local Collections = require(script.Parent.Parent.Parent.Packages.Collections)
local Controller = require(script.Parent.Controller)
local constants = require(script.Parent.constants)
local ParentContext = require(script.ParentContext)
local ParallaxTypes = require(script.ParallaxTypes)

local e = React.createElement

local Parallax = React.forwardRef(function(props: ParallaxTypes.ParallaxProps, ref)
    local ready, setReady = React.useState(false)
    local containerRef = React.useRef(nil :: any)
    local contentRef = React.useRef(nil :: any)
    
    local containerCanvasSize, setContainerCanvasSize = React.useBinding(0)

    -- DEVIATION: Used to avoid mutating elements directly
    local scroll, setScroll = React.useBinding(0)

    -- DEVIATION: Since onChange prop is not implemented, we must sync scroll to `styles` manually when `scrollTo` is called
    local syncScrollConnection = React.useRef(nil :: RBXScriptConnection?)

    React.useEffect(function()
        return function()
            if syncScrollConnection.current then
                syncScrollConnection.current:Disconnect()
            end
        end
    end, {})

    local containerProps: any = table.clone(props)

    local pages = props.pages
    containerProps.pages = nil
    local config = props.config or constants.config.default
    containerProps.config = nil
    local horizontal = props.horizontal or false
    containerProps.horizontal = nil
    local children = props.children
    containerProps.children = nil

    local update = function() end
    local scrollTo = function(_: number) end

    local state: ParallaxTypes.IParallax = React.useMemo(function()
        local styles, api = Controller.new({
            scroll = 0,
        })

        return {
            config = props.config,
            horizontal = props.horizontal,
            busy = false,
            space = 0,
            current = 0,
            offset = 0,
            layers = Collections.Set.new(nil :: ParallaxTypes.IParallaxLayer?),
            container = containerRef,
            content = contentRef,
            _styles = styles,
            _api = api,
            update = function()
                update()
            end,
            scrollTo = function(offset: number)
                scrollTo(offset)
            end,
            stop = function()
                api:stop()
            end,
        }
    end, {})
    
    React.useImperativeHandle(ref, function()
        return state
    end)

    update = function()
        local container = containerRef.current
        if not container then
            return
        end

        state.space = if horizontal then container.AbsoluteSize.X else container.AbsoluteSize.Y
        state.current = if horizontal then container.CanvasPosition.X else container.CanvasPosition.Y

        setContainerCanvasSize(pages * state.space)

        local content = contentRef.current
        if content then
            content.Size =
                if horizontal then
                    UDim2.fromOffset(state.space * pages, content.AbsoluteSize.Y)
                else
                    UDim2.fromOffset(content.AbsoluteSize.X, state.space * pages)
        end

        state.layers:forEach(function(layer)
            layer.setHeight(state.space, true)
            layer.setPosition(state.space, state.current, true)
        end)
    end

    scrollTo = function(offset: number)
        state.offset = offset

        state._api:start({
            scroll = state.current,
            immediate = true,
        }):andThen(function()
            -- DEVIATION: Chained to `andThen` because immediate currently only takes effect on the next frame
            if syncScrollConnection.current then
                syncScrollConnection.current:Disconnect()
            end
            local connection = RunService.RenderStepped:Connect(function()
                setScroll(state._styles.scroll:getValue())
            end)
            syncScrollConnection.current = connection
    
            state._api:start({
                scroll = offset * state.space,
                config = config,
            }):andThen(function()
                if syncScrollConnection.current and connection == syncScrollConnection.current then
                    connection:Disconnect()
                    syncScrollConnection.current = nil
                end
            end)
        end)
    end

    local onScroll = function(frame: ScrollingFrame)
        local newScroll = if horizontal then frame.CanvasPosition.X else frame.CanvasPosition.Y

        -- DEVIATION: Track user manual scroll
        setScroll(newScroll)

        if not state.busy then
            state.busy = true
            state.current = newScroll

            state.layers:forEach(function(layer)
                layer.setPosition(state.space, state.current)
            end)
            state.busy = false
        end
    end

    React.useEffect(function()
        state.update()
    end)

    React.useEffect(function()
        setReady(true)
    end, {})

    containerProps.AutomaticCanvasSize = Enum.AutomaticSize.None
    containerProps.ScrollingDirection = if horizontal then Enum.ScrollingDirection.X else Enum.ScrollingDirection.Y
    containerProps.ref = containerRef
    containerProps[React.Change.CanvasPosition] = onScroll
    containerProps[React.Change.AbsoluteSize] = update
    containerProps.CanvasPosition = scroll:map(function(value)
        return if horizontal then Vector2.new(value, 0) else Vector2.new(0, value)
    end)
    containerProps.CanvasSize = containerCanvasSize:map(function(value)
        return if horizontal then UDim2.fromOffset(value, 0) else UDim2.fromOffset(0, value)
    end)

    return e("ScrollingFrame",
        containerProps,
        ready and e(React.Fragment, {}, {
            e(ParentContext.Provider, {
                value = state,
            }, children)
        })
    )
end)

return Parallax
