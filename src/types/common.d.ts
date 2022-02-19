import { EasingFunction } from '../constants';

export type AnimatableType = number | UDim | UDim2 | Vector2 | Vector3 | Color3;

export type AnimationProps = {
  from?: AnimatableType;
  to?: AnimatableType;
  delay?: number;
  immediate?: boolean;
};

export interface AnimationConfigs {
  tension?: number;
  friction?: number;
  frequency?: number;
  damping?: number;
  mass?: number;
  velocity?: number[];
  restVelocity?: number;
  precision?: number;
  progress?: number;
  duration?: number;
  easing?: EasingFunction;
  clamp?: boolean;
  bounce?: number;
}
