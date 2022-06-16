import { Binding } from '@rbxts/roact';
import { AnimationProps, AnimationStyle, SharedAnimationProps } from './types/common';

export type ControllerProps<T extends AnimationStyle> = (AnimationProps<T> | T) & SharedAnimationProps;

export interface ControllerApi {
  start(this: void, startProps?: ControllerProps<AnimationStyle>): Promise<void>;
  stop(this: void, keys?: [string]): Promise<void>;
  pause(this: void, keys?: [string]): Promise<void>;
}

declare interface Constructor {
  new <T extends AnimationStyle>(props: ControllerProps<T>): LuaTuple<
    [{ [key in keyof T]: Binding<T[key]> }, ControllerApi]
  >;
}

declare const Controller: Constructor;
export default Controller;
