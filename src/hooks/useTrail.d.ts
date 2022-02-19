import { CoreHooks } from '@rbxts/roact-hooks';
import { Binding } from '@rbxts/roact';
import { AnimatableType } from '../../src/types/common';
import { ControllerProps, ControllerApi } from '../Controller';
import { UseSpringsApi } from './useSprings';

declare interface UseTrail {
  (hooks: CoreHooks, length: number, props: ControllerProps, dependencies?: Array<unknown>): Array<{
    [key: string]: Binding<AnimatableType>;
  }>;
  (hooks: CoreHooks, length: number, props: (i: number) => ControllerProps, dependencies?: Array<unknown>): LuaTuple<
    [Array<{ [key: string]: Binding<AnimatableType> }>, UseSpringsApi]
  >;
}

declare const useTrail: UseTrail;
export default useTrail;
