--!strict
local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local Controller = require(script.Parent.Parent.Controller)
local ParentContext = require(script.Parent.ParentContext)
local ParallaxTypes = require(script.Parent.ParallaxTypes)

local e = React.createElement

local isReactFragment = function(node: any)
    if node.type then
        return node.type == React.Fragment
    end
    return node == React.Fragment
end

local function mapChildrenRecursive(children, callback: (any) -> any)
    return React.Children.map(children, function(child: any)
        return if isReactFragment(child) then 
            mapChildrenRecursive(child.props.children, callback) 
        else
            callback(child)
    end)
end

local Parallax = React.forwardRef(function(props: ParallaxTypes.IParallaxLayer, ref)
    local layerProps: any = table.clone(props)

    local horizontal = layerProps.horizontal
    layerProps.horizontal = nil
    local factor = layerProps.factor or 1
    layerProps.factor = nil
    local offset = layerProps.offset or 0
    layerProps.offset = nil
    local speed = layerProps.speed or 0
    layerProps.speed = nil
    local sticky = layerProps.sticky
    layerProps.sticky = nil
    local children = layerProps.children
    layerProps.children = nil

    -- Parent controls height and position
    local parent: ParallaxTypes.IParallax = React.useContext(ParentContext)

    -- DEVIATION: Since api:start with `immediate` only takes effect in the next frame, using controller when sticky will cause flickering when
    -- user scrolls with middle mouse wheel. Using a binding instead also causes minor flickering (possibly due to offset whole number
    -- imprecision which gets worse as resolution gets smaller), but it's much less noticeable.
    local stickyTranslate, setStickyTranslate = React.useBinding(0)

    local styles, api = React.useMemo(function()
        local translate
        if sticky then
            local start = sticky.start or 0
            translate = start * parent.space
        else
            local targetScroll = math.floor(offset) * parent.space
            local distance = parent.space * offset + targetScroll * speed
            translate = -(parent.current * speed) + distance
        end

        return Controller.new({
            space = if sticky then parent.space else parent.space * factor,
            translate = translate,
        })
    end, {})

    local setSticky = function(_: number, _: number) end

    local layer: ParallaxTypes.IParallaxLayer = React.useMemo(function()
        return {
            horizontal = if horizontal == nil or sticky then parent.horizontal else horizontal,
            sticky = nil,
            isSticky = false,
            setPosition = function(height: number, scrollTop: number, immediate: boolean?)
                if sticky then
                    setSticky(height, scrollTop)
                else
                    local targetScroll = math.floor(offset) * height
                    local distance = height * offset + targetScroll * speed
                    api:start({
                        translate = -(scrollTop * speed) + distance,
                        config = parent.config,
                        immediate = immediate,
                    })
                end
            end,
            setHeight = function(height: number, immediate: boolean?)
                api:start{
                    space = if sticky then height else height * factor,
                    config = parent.config,
                    immediate = immediate,
                }
            end
        }
    end, {})

    -- TODO: Change to useOnce
    React.useEffect(function()
        if sticky then
            local start = sticky.start or 0
            local finish = sticky.finish or start + 1
            layer.sticky = {
                start = start,
                finish = finish
            }
        end
    end, {})

    React.useImperativeHandle(ref, function()
        return layer
    end)

    setSticky = function(height: number, scrollTop: number)
        local start = layer.sticky and layer.sticky.start and layer.sticky.start * height
        local finish = layer.sticky and layer.sticky.finish and layer.sticky.finish * height
        if start and finish then
            layer.isSticky = scrollTop >= start and scrollTop <= finish

            -- DEVIATION: Since `sticky` is not natively supported, we must manually set the position of the sticky layer every time
            -- the scroll position changes
            if scrollTop > start and scrollTop < finish then
                setStickyTranslate(scrollTop)
            else
                setStickyTranslate(if scrollTop < start then start else finish)
            end
        end
    end

    React.useEffect(function()
        if parent then
            parent.layers:add(layer)
            parent.update()
            return function()
                parent.layers:delete(layer)
                parent.update()
            end
        end
        return nil :: any
    end, {})

    api:start({
        translate = 0
    })

    layerProps.ref = ref
    layerProps.BackgroundTransparency = 1
    layerProps.Size = styles.space:map(function(value)
        return if layer.horizontal then UDim2.new(0, value, 1, 0) else UDim2.new(1, 0, 0, value)
    end)
    layerProps.Position = (if sticky then stickyTranslate else styles.translate):map(function(value)
        return if layer.horizontal then UDim2.new(0, value, 0, 0) else UDim2.new(0, 0, 0, value)
    end)

    return e("Frame", layerProps, children)
end)

return Parallax
