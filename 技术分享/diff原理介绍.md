> diff 相关小知识

1. 发生在 fiber 树构造阶段，目的是为了向下生成新的 fiber 节点。
2. 新的 ReactElement 节点和旧的 fiber 节点比较。
3. diff 的主要作用就是给 fiber 节点打上新增、删除、修改的标记，等待 commit 阶段统一处理。
   - 新增节点会跳过 diff 过程，直接构造新的 fiber 对象。
   - 修改节点会给新的 fiber 节点打上修改的标记，并复用 oldFiber 节点的 fiber.stateNode 属性。
   - 被删除的节点除了自身会打上删除的标记，它也会脱离当前正在构造的 fiber 树。

> 单节点 diff 过程

1. 比较两个对象 key 是否相等。
2. 比较两个节点的 type 是否相等(fiber.elementType === element.type);
3. 根据上面的判断结果在新创建的 fiber 对象上加上对应的标记。

> 可迭代节点 diff 过程

- 第一次遍历：

  1. 遍历最长公共序列，公共序列节点都视为可复用。
  2. 如果新的 ReactElements 已经遍历完毕，oldFiber 中剩余节点都会被打上删除的标记。
  3. 如果 oldFiber 节点被遍历完，没遍历到的 ReactElements 都会被打上新增的标记。

- 第二次遍历：
  1. 遍历剩余非公共序列, 优先复用 oldFiber 序列中的节点。
  2. 当新的节点已经遍历完，那么 oldFiber 序列中剩余节点都被打上删除标记。

> diff 过程图示

- 假设有下面两个序列，那么在 fiber 树构造过程中就会执行上述两个步骤：

![](https://7kms.github.io/react-illustration-series/static/before-traverse.71633a39.png)

- 第一次循环，遍历最长公共序列，复用 fiber(A)和 fiber(b)。

![](https://7kms.github.io/react-illustration-series/static/traverse1.a0313cc2.png)

- 第二次循环

  1. 遍历剩余序列，可以发现 fiber(E)和 fiber(C)发生了位移，给他们打上修改标记。
  2. fiber(X), fiber(Y)是新增(打上 Placement 标记).
  3. fiber(D)节点确定被删除(打上 Deletion 标记).

![](https://7kms.github.io/react-illustration-series/static/traverse2.a5a39d1b.png)
