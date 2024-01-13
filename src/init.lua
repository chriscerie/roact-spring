--!strict

local Controller = require(script.Controller)
local common = require(script.types.common)
local useSprings = require(script.hooks.useSprings)

export type AnimatableType = common.AnimatableType
export type AnimationStyle = common.AnimationStyle

export type UseSpringsApi<T> = useSprings.UseSpringsApi<T>
export type UseSpringsStylesList = useSprings.UseSpringsStylesList

export type ControllerApi = Controller.ControllerApi

local RoactSpring = {
	useSpring = require(script.hooks.useSpring),
	useSprings = useSprings,
	useTrail = require(script.hooks.useTrail),
	Controller = Controller,
	config = require(script.constants).config,
	easings = require(script.constants).easings,
}

return RoactSpring
