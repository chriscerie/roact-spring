import { CoreHooks } from '@rbxts/roact-hooks';
import { Binding } from '@rbxts/roact';
import { AnimatableType } from '../types/common';
import { ControllerProps, ControllerApi } from '../Controller';

declare interface UseSpring {
  (hooks: CoreHooks, props: ControllerProps, dependencies?: Array<unknown>): { [key: string]: Binding<AnimatableType> };
  (hooks: CoreHooks, props: () => ControllerProps, dependencies?: Array<unknown>): LuaTuple<
    [{ [key: string]: Binding<AnimatableType> }, ControllerApi]
  >;
}

declare const useSpring: UseSpring;
export default useSpring;
