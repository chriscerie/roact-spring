local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

return function()

    describe("Controller", function()
        it("can animate a number", function()
            local styles, api = RoactSpring.Controller.new({ x = 0 })
            api:start({ x = 100 }):await()
            expect(styles.x:getValue()).to.equal(100)
        end)

        it("can animate a number defined in `to`", function()
            local styles, api = RoactSpring.Controller.new({ to = { x = 0 } })
            api:start({ to = { x = 100 } }):await()
            expect(styles.x:getValue()).to.equal(100)
        end)

        it("can animate a number defined in `from`", function()
            local styles, api = RoactSpring.Controller.new({ from = { x = 0 } })
            api:start({ x = 100 }):await()
            expect(styles.x:getValue()).to.equal(100)
        end)

        it("can animate a number when passed configs", function()
            local styles, api = RoactSpring.Controller.new({ x = 0, config = { mass = 0.3 } })
            api:start({
                x = 100,
                config = { tension = 500 },
            }):await()
            expect(styles.x:getValue()).to.equal(100)
        end)

        it("should set the initial value of `from` if one is passed to constructor", function()
            local styles, api = RoactSpring.Controller.new({ from = { x = 0 } })
            expect(styles.x:getValue()).to.equal(0)
        end)

        it("should set the initial value of `to` if one is passed to constructor", function()
            local styles, api = RoactSpring.Controller.new({ to = { x = 100 } })
            expect(styles.x:getValue()).to.equal(100)
        end)

        it("should set the initial value of `from` if both `from` and `to` are passed to constructor", function()
            local styles, api = RoactSpring.Controller.new({ from = { x = 0 }, to = { x = 100 } })
            expect(styles.x:getValue()).to.equal(0)
        end)

        describe("the `stop` method", function()
            it("should stop the animation", function()
                local styles, api = RoactSpring.Controller.new({ x = 0 })
                api:start({ x = 100 })
                task.wait(0.2)
                api:stop()
                local value = styles.x:getValue()
                task.wait(2)
                expect(value).to.equal(styles.x:getValue())
                expect(value).never.to.equal(0)
            end)
        end)

        describe("the `pause` method", function()
            it("should pause the animation", function()
                local styles, api = RoactSpring.Controller.new({ x = 0 })
                api:start({ x = 100 })
                task.wait(0.2)
                api:pause()
                local value = styles.x:getValue()
                task.wait(2)
                expect(value).to.equal(styles.x:getValue())
                expect(value).never.to.equal(0)
            end)
        end)
    end)

end
