import { CoreHooks } from '@rbxts/roact-hooks';
import { Binding } from '@rbxts/roact';
import { AnimatableType } from '../../src/types/common';
import { ControllerProps, ControllerApi } from '../Controller';

export type UseSpringsApi = {
  [K in keyof ControllerApi]: (fn: (i: number) => Parameters<ControllerApi[K]>[0]) => ReturnType<ControllerApi[K]>;
};

declare interface UseSprings {
  (hooks: CoreHooks, length: number, props: ControllerProps, dependencies?: Array<unknown>): Array<{
    [key: string]: Binding<AnimatableType>;
  }>;
  (hooks: CoreHooks, length: number, props: (i: number) => ControllerProps, dependencies?: Array<unknown>): LuaTuple<
    [Array<{ [key: string]: Binding<AnimatableType> }>, UseSpringsApi]
  >;
}

declare const useSprings: UseSprings;
export default useSprings;
