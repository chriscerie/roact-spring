import { Binding } from '@rbxts/roact';
import { AnimatableType, AnimationProps } from './types/common';

export type ControllerProps = AnimationProps & {
  [key: string]: AnimatableType;
};

export interface ControllerApi {
  start(startProps?: ControllerProps): Promise<void>;
  stop(keys?: [string]): Promise<void>;
  pause(keys?: [string]): Promise<void>;
}

declare interface Constructor {
  new (props: ControllerProps): LuaTuple<[{ [key: string]: Binding<AnimatableType> }, ControllerApi]>;
}

declare const Controller: Constructor;
export default Controller;
