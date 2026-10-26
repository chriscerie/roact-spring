local constants = require(script.Parent.constants)

return function()
	describe("easings", function()
		local easings = constants.easings

		it("should compute easeInOutExpo", function()
			expect(easings.easeInOutExpo(0.5)).to.be.near(0.5)
			expect(easings.easeInOutExpo(0.75)).to.be.near(0.984375)
		end)

		it("should compute bounce easings", function()
			expect(easings.easeOutBounce(0.8)).to.be.near(0.94)
			expect(easings.easeOutBounce(0.95)).to.be.near(0.98453125)
			expect(easings.easeInBounce(0.2)).to.be.near(0.06)
		end)
	end)
end
