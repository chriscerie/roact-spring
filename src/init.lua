--!strict

local common = require(script.types.common)
local useSprings = require(script.hooks.useSprings)
local Controller = require(script.Controller)
local ParallaxTypes = require(script.Parallax.ParallaxTypes)

export type AnimatableType = common.AnimatableType
export type AnimationStyle = common.AnimationStyle

export type UseSpringsApi<T> = useSprings.UseSpringsApi<T>
export type UseSpringsStylesList = useSprings.UseSpringsStylesList

export type ControllerApi = Controller.ControllerApi

export type IParallax = ParallaxTypes.IParallax
export type IParallaxLayer = ParallaxTypes.IParallaxLayer

local RoactSpring = {
	useSpring = require(script.hooks.useSpring),
	useSprings = useSprings,
	useTrail = require(script.hooks.useTrail),
	Controller = Controller,
	config = require(script.constants).config,
	easings = require(script.constants).easings,
	Parallax = require(script.Parallax),
	ParallaxLayer = require(script.Parallax.ParallaxLayer),
}

return RoactSpring
