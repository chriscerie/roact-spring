# Changelog

## Unreleased

## 1.0.1 (May 26, 2022)
* Fixed documentation incorrectly using dot operator for controllers
* Fixed `from` prop during imperative updates ([@lopi-py](https://github.com/lopi-py) in [#22](https://github.com/chriscerie/roact-spring/pull/22))
* Added Additional Notes section to docs

## 1.0.0 (April 21, 2022)
* Bumped promise version to v4.0 ([@chriscerie](https://github.com/chriscerie) in [#20](https://github.com/chriscerie/roact-spring/pull/20))
* Bumped roact-hooks version to v0.4 ([@chriscerie](https://github.com/chriscerie) in [#20](https://github.com/chriscerie/roact-spring/pull/20))
* Fixed calculations not responding to fps differences ([@chriscerie](https://github.com/chriscerie) in [#20](https://github.com/chriscerie/roact-spring/pull/20))

## 0.3.1 (March 29, 2022)
* Fixed an issue where duration-based anims would always start from the same position

## 0.3.0 (March 29, 2022)

* Removed implementation detail from return table
* Added `getting started` page to documentation
* Added `reset` prop ([@chriscerie](https://github.com/chriscerie) in [#17](https://github.com/chriscerie/roact-spring/pull/17))
* Added `loop` and `default` props ([@chriscerie](https://github.com/chriscerie) in [#18](https://github.com/chriscerie/roact-spring/pull/18))

## 0.2.3 (Feburary 20, 2022)

* Updated npm metadata
* Fixed library requires from packages

## 0.2.2 (Feburary 19, 2022)

* Added `progress` config for easing animations ([@chriscerie](https://github.com/chriscerie) in [#13](https://github.com/chriscerie/roact-spring/pull/13))
* Hooks now cancel animations when they are unmounted
* Added staggered text story to demos
* Fixed useSprings not removing unused springs when length arg decreases
* Added tests for `useSpring` and `useSprings`
* Added rbxts typings

## 0.2.1 (Feburary 17, 2022)

* Fixed `useTrail` delaying the wrong amount for varying delay times
* Fixed typo in docs

## 0.2.0 (Feburary 11, 2022)

* Fixed color3 animating with wrong values
* Cleaned up all stories to use circle button component
* Added support for hex color strings ([@chriscerie](https://github.com/chriscerie) in [#6](https://github.com/chriscerie/roact-spring/pull/6))
* Added motivation in docs
* Added `delay` prop
* Added `useTrail`
* Added optional dependency array to hooks

## 0.1.1 (February 3, 2022)

* Added `useSpring`
* Added `useSprings`
* Added `Controller`
* Added `SpringValue`
* Added `config`
* Added `easings`