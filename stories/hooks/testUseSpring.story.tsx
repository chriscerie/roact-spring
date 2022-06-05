import Roact from '@rbxts/roact';
import Hooks from '@rbxts/roact-hooks';
import { useSpring } from '../../src';

const Component: Hooks.FC = (_props, hooks) => {
  const [styles, api] = useSpring(hooks, () => {
    return { transparency: 1 };
  });

  const styles2 = useSpring(hooks, {
    from: { position: new UDim2(1, 0, 1, 0) },
  });

  return (
    <textbutton
      TextSize={18}
      Size={UDim2.fromOffset(200, 50)}
      Transparency={styles.transparency}
      Position={styles2.position}
      Event={{
        MouseButton1Click: () =>
          api.start({
            transparency: 0,
          }),
      }}
    />
  );
};

const Test = new Hooks(Roact)(Component);

export = (target: GuiObject) => {
  const tree = Roact.mount(<Test></Test>, target);

  return () => {
    Roact.unmount(tree);
  };
};
