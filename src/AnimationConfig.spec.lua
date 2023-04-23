local AnimationConfig = require(script.Parent.AnimationConfig)

local function expo(t: number)
	return t ^ 2
end

return function()
	describe("AnimationConfig", function()
		it("can merge configs", function()
			local config = AnimationConfig:mergeConfig({
				tension = 0,
				friction = 0,
			})
			expect(config.tension).to.equal(0)
			expect(config.friction).to.equal(0)

			config = AnimationConfig:mergeConfig({
				frequency = 2,
				damping = 0,
			})
			expect(config.frequency).to.equal(2)
			expect(config.damping).to.equal(0)

			config = AnimationConfig:mergeConfig({
				duration = 2000,
				easing = expo,
			})
			expect(config.duration).to.equal(2000)
			expect(config.easing).to.equal(expo)
		end)

		describe("frequency/damping props", function()
			it("should property convert to tension/friction", function()
				local config = AnimationConfig:mergeConfig({ frequency = 0.5, damping = 1 })
				expect(config.tension).to.equal(157.91367041742973)
				expect(config.friction).to.equal(25.132741228718345)
			end)

			it("should work with extreme but valid values", function()
				local config = AnimationConfig:mergeConfig({ frequency = 2.6, damping = 0.1 })
				expect(config.tension).to.equal(5.840002604194885)
				expect(config.friction).to.equal(0.483321946706122)
			end)

			it("should prevent a damping ratio less than 0", function()
				local validConfig = AnimationConfig:mergeConfig({ frequency = 0.5, damping = 0 })
				local invalidConfig = AnimationConfig:mergeConfig({ frequency = 0.5, damping = -1 })
				expect(invalidConfig.frequency).to.equal(validConfig.frequency)
				expect(invalidConfig.damping).to.equal(validConfig.damping)
			end)

			it("should prevent a frequency response less than 0.01", function()
				local validConfig = AnimationConfig:mergeConfig({ frequency = 0.01, damping = 1 })
				local invalidConfig = AnimationConfig:mergeConfig({ frequency = 0, damping = 1 })
				expect(invalidConfig.frequency).to.equal(validConfig.frequency)
				expect(invalidConfig.damping).to.equal(validConfig.damping)
			end)
		end)
	end)
end
