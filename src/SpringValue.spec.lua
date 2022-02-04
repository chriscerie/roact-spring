local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

return function()

    describe("SpringValue", function()
        it("can animate a number", function()
            local spring = RoactSpring.SpringValue.new({ from =  0 })
            spring:start({ to = 100 }):await()
            expect(spring.animation:getValue()).to.equal(100)
        end)

        describe("when `immediate` prop is true", function()
            it("should stop animating", function()
                local spring = RoactSpring.SpringValue.new({ from =  0 })
                spring:start({ to = 100 })

                task.wait(0.1)
                
                local value = spring.animation:getValue()
                spring:start({ to = value, immediate = true })

                task.wait(0.1)

                expect(spring.animation:getValue()).to.equal(value)
            end)
        end)

        describe("the `config` prop", function()
            it("should reset velocity when `to` changes", function()
                local spring = RoactSpring.SpringValue.new({ from =  0 })
                spring:start({ to = 100, config = { velocity = 10 } })
                expect(spring.animation.config.velocity).to.equal(10)

                -- TODO: once implemented, test that velocity gets preserved if `to` is not changed

                spring:start({ to = 200 })
                expect(spring.animation.config.velocity).to.equal(0)
            end)
        end)
    end)

end
