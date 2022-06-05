import Roact from '@rbxts/roact';
import Hooks from '@rbxts/roact-hooks';
import { useSprings } from '../../src';

const Component: Hooks.FC = (_props, hooks) => {
  const [styles1] = useSprings(hooks, 3, () => {
    return {
      Position: new UDim2(1, 1, 1, 1),
    };
  });

  const styles2 = useSprings(hooks, 3, [
    {
      to: {
        Transparency: 1,
      },
    },
    {
      to: {
        Transparency: 1,
      },
    },
    {
      to: {
        Transparency: 1,
      },
    },
  ]);

  return (
    <>
      <textbutton
        TextSize={18}
        Size={UDim2.fromOffset(200, 50)}
        Position={styles1[0].Position}
        Transparency={styles2[0].Transparency}
        Event={{}}
      />
      <textbutton
        TextSize={18}
        Size={UDim2.fromOffset(200, 50)}
        Position={styles1[1].Position}
        Transparency={styles2[1].Transparency}
        Event={{}}
      />
      <textbutton
        TextSize={18}
        Size={UDim2.fromOffset(200, 50)}
        Position={styles1[2].Position}
        Transparency={styles2[2].Transparency}
        Event={{}}
      />
    </>
  );
};

const Test = new Hooks(Roact)(Component);

export = (target: GuiObject) => {
  const tree = Roact.mount(<Test></Test>, target);

  return () => {
    Roact.unmount(tree);
  };
};
