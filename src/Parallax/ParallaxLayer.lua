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

    -- Parent controls height and position
    local parent: ParallaxTypes.IParallax = React.useContext(ParentContext)

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
            layer.sticky = { start, finish }
        end
    end, {})

    React.useImperativeHandle(ref, function()
        return layer
    end)

    local layerRef = React.useRef(nil :: any)

    setSticky = function(height: number, scrollTop: number)
        local start = layer.sticky and layer.sticky.start and layer.sticky.start * height
        local finish = layer.sticky and layer.sticky.finish and layer.sticky.finish * height
        if start and finish then
            local isSticky = scrollTop >= start and scrollTop <= finish

            if isSticky == layer.isSticky then
                return
            end
            layer.isSticky = isSticky

            local thisRef = layerRef.current
            -- FIXME
            --thisRef.style.position = if isSticky then "sticky" else "absolute"
            api:start({
               translate = if isSticky then 0 else if scrollTop < start then start else finish,
               immediate = true
            })
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
    layerProps.Position = styles.translate:map(function(value)
        return if layer.horizontal then UDim2.new(0, value, 0, 0) else UDim2.new(0, 0, 0, value)
    end)

    return e("Frame", layerProps, props.children)
end)

return Parallax
