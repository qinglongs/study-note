> diff 相关小知识

1. 发生在fiber树构造阶段，目的是为了向下生成新的fiber节点。
2. 新的ReactElement节点和旧的fiber节点比较。
3. diff的主要作用就是给fiber节点打上新增、删除、修改的标记，等待commit阶段统一处理。
    - 新增节点会跳过diff过程，直接构造新的fiber对象。
    - 修改节点会给新的fiber节点打上修改的标记，并复用oldfiber节点的fiber.stateNode属性。
    - 被删除的节点除了自身会打上删除的标记，它也会脱离当前正在构造的fiber树。

> 单节点diff过程

1. 比较两个对象key是否相等。
2. 比较两个节点的type是否相等(fiber.elementType === element.type);
3. 根据上面的判断结果在新创建的fiber对象上加上对应的标记。
 
> 可迭代节点diff过程

- 第一次遍历：
    1. 遍历最长公共序列，公共序列节点都视为可复用。
    2. 如果新的 ReactElements 已经遍历完毕，oldfiber 中剩余节点都会被打上删除的标记。
    3. 如果 oldfiber节点被遍历完，没遍历到的 ReactElements 都会被打上新增的标记。
   
- 第二次遍历：
    1. 遍历剩余非公共序列, 优先复用oldFiber序列中的节点。
    2. 当新的节点已经遍历完，那么oldFiber序列中剩余节点都被打上删除标记。