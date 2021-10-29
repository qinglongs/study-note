### diff

> 简介

- 什么阶段执行：
  - diff 发生的算法发生在 fiber 节点对比更新(beginWork)阶段。
- 比较对象：
  - 旧的 fiber 对象与 新的 ReactElement 对象比较
- 性能：
  - 时间复杂度为 O(n);
- 目的:
- 给新增,移动,和删除节点设置 fiber.flags(新增：Placement, 移动：PlacementAndUpdate , 删除: Deletion)。 如果是需要删除的 fiber, 除了自身打上 Deletion 之外, 还要将其添加到父节点的 effects 链表中(正常副作用队列的处理是在 completeWork 函数, 但是该节点(被删除)会脱离 fiber 树, 不会再进入 completeWork 阶段, 所以在 beginWork 阶段提前加入副作用队列).

- diff 小问题
  - 节点的 key 有什么作用？

> 单节点比较

- 如果 key 和 type 相同(即：ReactElement.key===Fiber.key)且 ReactElement.type===Fiber.type 则复用，否则新增。

```js
//  fiber.flags 标记记录在commit阶段可以用整个字段精确判断需要进行的副作用操作
// 新增
export const Placement = /*                    */ 0b0000000000000000000000010;
// 更新
export const Update = /*                       */ 0b0000000000000000000000100;
// 新增并且更新
export const PlacementAndUpdate = /*           */ Placement | Update;
// 删除
export const Deletion = /*                     */ 0b0000000000000000000001000;

// 只保留主干逻辑
function reconcileSingleElement(
  returnFiber: Fiber,
  currentFirstChild: Fiber | null,
  element: ReactElement,
  lanes: Lanes
): Fiber {
  // 新的ReactElement节点对应的key
  const key = element.key;
  // oldFiber
  let child = currentFirstChild;

  while (child !== null) {
    // currentFirstChild !== null, 表明是对比更新阶段
    if (child.key === key) {
      // 1. key相同, 进一步判断 child.elementType === element.type
      switch (child.tag) {
        // 只看核心逻辑
        default: {
          if (child.elementType === element.type) {
            // 1.1 已经匹配上了, 如果有兄弟节点, 需要给兄弟节点打上Deletion标记
            deleteRemainingChildren(returnFiber, child.sibling);
            // 1.2 构造fiber节点, 新的fiber对象会复用current.stateNode, 即可复用DOM对象
            const existing = useFiber(child, element.props);
            existing.ref = coerceRef(returnFiber, child, element);
            existing.return = returnFiber;
            return existing;
          }
          break;
        }
      }
      // Didn't match. 给当前节点打上Deletion标记
      deleteRemainingChildren(returnFiber, child);
      break;
    } else {
      // 2. key不相同, 匹配失败, 给当前节点打上Deletion标记
      deleteChild(returnFiber, child);
    }
    child = child.sibling;
  }

  {
    // ...省略部分代码, 只看核心逻辑
  }

  // 新建节点
  const created = createFiberFromElement(element, returnFiber.mode, lanes);
  created.ref = coerceRef(returnFiber, currentFirstChild, element);
  created.return = returnFiber;
  return created;
}
```

> 可迭代节点比较

- 多节点比较过程(会经历两次遍历)

  - 第一次遍历：遍历最长公共序列(key 相同), 公共序列的节点都视为可复用

    - 如果 newChildren 序列被遍历完, 那么 oldFiber 序列中剩余节点都视为删除(打上 Deletion 标记)
    - 如果 oldFiber 序列被遍历完, 那么 newChildren 序列中剩余节点都视为新增(打上 Placement 标记)

  - 第二次遍历：遍历剩余非公共序列, 优先复用 oldFiber 序列中的节点
    - 如果有节点发生了位移就打上新增标记。
    - 有新的节点出现也会打上新增标记。
    - oldFiber 序列中剩余的节点打上删除标记。

```js
// 下面的代码省略了与diff主流程无关的代码
function reconcileChildrenArray(
  // 夫节点对应的fiber对象
  returnFiber: Fiber,
  // 第一个子节点对应的fiber
  currentFirstChild: Fiber | null,
  // 调用组件生成的新的 ReactElement 数组
  newChildren: Array<*>,
  // 优先级
  lanes: Lanes
): Fiber | null {
  let oldFiber = currentFirstChild;
  let lastPlacedIndex = 0;
  let newIdx = 0;
  let nextOldFiber = null;
  // 1. 第一次循环: 遍历最长公共序列(key相同), 公共序列的节点都视为可复用
  for (; oldFiber !== null && newIdx < newChildren.length; newIdx++) {
    // 后面分析
  }

  if (newIdx === newChildren.length) {
    // 如果newChildren序列被遍历完, 那么oldFiber序列中剩余节点都视为删除(打上Deletion标记)
    deleteRemainingChildren(returnFiber, oldFiber);
    return resultingFirstChild;
  }

  if (oldFiber === null) {
    // 如果oldFiber序列被遍历完, 那么newChildren序列中剩余节点都视为新增(打上Placement标记)
    for (; newIdx < newChildren.length; newIdx++) {
      // 后文分析
    }
    return resultingFirstChild;
  }

  // ==================分割线==================
  const existingChildren = mapRemainingChildren(returnFiber, oldFiber);

  // 2. 第二次循环: 遍历剩余非公共序列, 优先复用oldFiber序列中的节点
  for (; newIdx < newChildren.length; newIdx++) {}

  if (shouldTrackSideEffects) {
    // newChildren已经遍历完, 那么oldFiber序列中剩余节点都视为删除(打上Deletion标记)
    existingChildren.forEach((child) => deleteChild(returnFiber, child));
  }

  return resultingFirstChild;
}
```

### Hooks 原理简介

> hook 与 fiber 节点的关系

- 属于 fiber 节点上面的一个属性(memoizedState)，hook 对象是一个单向链表.
- useState 的首次渲染和更新阶段代码执行过程

  - 首次渲染执行步骤
  - 构建 fiber -> 执行 hook 函数 -> 计算出最新状态并赋值到 hook 对象 -> 等待 commit 阶段执行

  - 更新阶段执行步骤
    - 执行 dispatch 函数-> 将新的状态添加到对应 hook 节点的 queue 队列中 -> 触发 react 调度 -> 注册调度任务 -> 调度任务的回调执行 -> 构造 fiber 树 -> 执行对应的 hook 函数 -> 计算出最新状态并赋值到 hook 对象 -> 等待 commit 阶段执行

> hook 对象

```javascript
export type Hook = {|
  memoizedState: any,
  baseState: any,
  baseQueue: Update<any, any> | null,
  queue: UpdateQueue<any, any> | null,
  next: Hook | null,
|};

type Update<S, A> = {|
  lane: Lane,
  action: A,
  eagerReducer: ((S, A) => S) | null,
  eagerState: S | null,
  next: Update<S, A>,
  priority?: ReactPriorityLevel,
|};

type UpdateQueue<S, A> = {|
  pending: Update<S, A> | null,
  dispatch: ((A) => mixed) | null,
  lastRenderedReducer: ((S, A) => S) | null,
  lastRenderedState: S | null,
|};

// 执行上下文
type ExecutionContext = number;
export const NoContext = /*             */ 0b0000000;
const BatchedContext = /*               */ 0b0000001;

// https://blog.csdn.net/weixin_43294413/article/details/103512328
// 触发事件
const EventContext = /*                 */ 0b0000010;
const DiscreteEventContext = /*         */ 0b0000100;

// const LegacyUnbatchedContext = /*       */ 0b0001000;
// render 前会进入这个上下文
const RenderContext = /*                */ 0b0010000;
// commit之前
const CommitContext = /*                */ 0b0100000;
```

> hooks 相关小问题

- setState 是同步的还是异步的？
- 为什么 hooks 不能写在条件判断里面？
- 同时执行多个 setState 会触发多次更新吗？
- setState 同一个引用/值，为什么不会引起更新？
- hooks 是怎样实现状态复用的？

#### useState 与 diff 之间的关系
