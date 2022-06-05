import { Binding } from '@rbxts/roact';
import { CoreHooks } from '@rbxts/roact-hooks';
import { AnimationStyle } from '../../src/types/common';
import { ControllerApi, ControllerProps } from '../Controller';

export type UseSpringsApi = {
  [K in keyof ControllerApi]: (fn: (i: number) => Parameters<ControllerApi[K]>[0]) => ReturnType<ControllerApi[K]>;
};

declare interface UseSprings {
  <T extends AnimationStyle>(
    hooks: CoreHooks,
    length: number,
    props: Array<ControllerProps<T>>,
    dependencies?: Array<unknown>
  ): Array<{
    [key in keyof T]: Binding<T[key]>;
  }>;
  <T extends AnimationStyle>(
    hooks: CoreHooks,
    length: number,
    props: (i: number) => ControllerProps<T>,
    dependencies?: Array<unknown>
  ): LuaTuple<[Array<{ [key in keyof T]: Binding<T[key]> }>, UseSpringsApi]>;
}

declare const useSprings: UseSprings;
export default useSprings;
