local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = React.createElement

local function createUpdater(initialProps, initialDeps)
	local test = {}

	local function Test(_)
		local springProps, update = React.useState({ initialProps, initialDeps })
		test.update = function(newProps, newDeps)
			update({ newProps, newDeps })
			task.wait(0.1)
		end
		test.styles, test.api = RoactSpring.useSpring(springProps[1], springProps[2])
		return nil
	end

	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal({
		App = e(Test),
	}, ReplicatedStorage))

	task.wait()
	while not root do
		task.wait()
	end

	return test
end

return function()
	describe("useSpring", function()
		describe("when only a prop object is passed", function()
			it("can animate supported data types", function()
				local test = createUpdater({
					number = 0,
					udim = UDim.new(0, 0),
					udim2 = UDim2.new(0, 0, 0, 0),
					vector2 = Vector2.new(0, 0),
					vector3 = Vector3.new(0, 0, 0),
					color3 = Color3.fromRGB(0, 0, 0),
				})

				expect(test.styles.number:getValue()).to.equal(0)
				expect(test.styles.udim:getValue()).to.equal(UDim.new(0, 0))
				expect(test.styles.udim2:getValue()).to.equal(UDim2.new(0, 0, 0, 0))
				expect(test.styles.vector2:getValue()).to.equal(Vector2.new(0, 0))
				expect(test.styles.vector3:getValue()).to.equal(Vector3.new(0, 0, 0))
				expect(test.styles.color3:getValue()).to.equal(Color3.fromRGB(0, 0, 0))

				test.update({
					number = 100,
					udim = UDim.new(100, 200),
					udim2 = UDim2.new(100, 200, 300, 400),
					vector2 = Vector2.new(100, 200),
					vector3 = Vector3.new(100, 200, 300),
					color3 = Color3.fromRGB(255, 255, 255),
				})
				task.wait(1)

				expect(test.styles.number:getValue()).to.be.near(100, 10)
				expect(test.styles.udim:getValue().Scale).to.near(100, 10)
				expect(test.styles.udim:getValue().Offset).to.near(200, 20)
				expect(test.styles.udim2:getValue().X.Scale).to.near(100, 10)
				expect(test.styles.udim2:getValue().X.Offset).to.near(200, 20)
				expect(test.styles.udim2:getValue().Y.Scale).to.near(300, 30)
				expect(test.styles.udim2:getValue().Y.Offset).to.near(400, 40)
				expect(test.styles.vector2:getValue().X).to.be.near(100, 10)
				expect(test.styles.vector2:getValue().Y).to.be.near(200, 20)
				expect(test.styles.vector3:getValue().X).to.be.near(100, 10)
				expect(test.styles.vector3:getValue().Y).to.be.near(200, 20)
				expect(test.styles.vector3:getValue().Z).to.be.near(300, 30)
				expect(test.styles.color3:getValue().R).to.be.near(1, 0.1)
				expect(test.styles.color3:getValue().G).to.be.near(1, 0.1)
				expect(test.styles.color3:getValue().B).to.be.near(1, 0.1)
			end)

			it("should set style instantly when immediate prop is passed", function()
				local test = createUpdater({
					x = 0,
					immediate = true,
				})

				expect(test.styles.x:getValue()).to.equal(0)

				test.update({ x = 1 })

				expect(test.styles.x:getValue()).to.equal(1)
			end)
		end)

		describe("when both a prop object and a deps array are passed", function()
			it("should only update when deps change", function()
				local test = createUpdater({
					x = 0,
					immediate = true,
				}, { 1 })

				expect(test.styles.x:getValue()).to.equal(0)

				test.update({ x = 1 }, { 1 })
				expect(test.styles.x:getValue()).to.equal(0)

				test.update({ x = 1 }, { 2 })
				expect(test.styles.x:getValue()).to.equal(1)
			end)
		end)

		describe("when only a function is passed", function()
			it("can animate supported data types", function()
				local test = createUpdater(function()
					return {
						number = 0,
						udim = UDim.new(0, 0),
						udim2 = UDim2.new(0, 0, 0, 0),
						vector2 = Vector2.new(0, 0),
						vector3 = Vector3.new(0, 0, 0),
						color3 = Color3.fromRGB(0, 0, 0),
					}
				end)

				expect(test.styles.number:getValue()).to.equal(0)
				expect(test.styles.udim:getValue()).to.equal(UDim.new(0, 0))
				expect(test.styles.udim2:getValue()).to.equal(UDim2.new(0, 0, 0, 0))
				expect(test.styles.vector2:getValue()).to.equal(Vector2.new(0, 0))
				expect(test.styles.vector3:getValue()).to.equal(Vector3.new(0, 0, 0))
				expect(test.styles.color3:getValue()).to.equal(Color3.fromRGB(0, 0, 0))

				test.api
					.start({
						number = 100,
						udim = UDim.new(100, 200),
						udim2 = UDim2.new(100, 200, 300, 400),
						vector2 = Vector2.new(100, 200),
						vector3 = Vector3.new(100, 200, 300),
						color3 = Color3.fromRGB(255, 255, 255),
						config = { tension = 500 },
					})
					:await()

				expect(test.styles.number:getValue()).to.equal(100)
				expect(test.styles.udim:getValue()).to.equal(UDim.new(100, 200))
				expect(test.styles.udim2:getValue()).to.equal(UDim2.new(100, 200, 300, 400))
				expect(test.styles.vector2:getValue()).to.equal(Vector2.new(100, 200))
				expect(test.styles.vector3:getValue()).to.equal(Vector3.new(100, 200, 300))
				expect(test.styles.color3:getValue()).to.equal(Color3.fromRGB(255, 255, 255))
			end)

			it("should set style instantly when immediate prop is passed", function()
				local test = createUpdater(function()
					return { x = 0, immediate = true }
				end)

				expect(test.styles.x:getValue()).to.equal(0)

				test.api.start({ x = 1 }):await()

				expect(test.styles.x:getValue()).to.equal(1)
			end)

			it("should never update on render", function()
				local test = createUpdater(function()
					return { x = 0, immediate = true }
				end)

				expect(test.styles.x:getValue()).to.equal(0)

				test.update(function()
					return { x = 1 }
				end)
				expect(test.styles.x:getValue()).to.equal(0)
			end)
		end)
	end)
end
