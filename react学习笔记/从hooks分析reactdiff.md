### diff

> 简介

- 什么阶段执行：
  - diff 发生的算法发生在 fiber 节点对比更新阶段。
- 比较对象：
  - 旧的 fiber 对象与 新的 ReactElement 对象比较
- 性能：
  - 时间复杂度为 O(n);
- 目的:
  - diff 的过程中给 fiber 节点打上标记(增、删改)，等待 commit 阶段的处理。

> 单节点比较

- 如果 key 和 type 相同(即：ReactElemnt.key===Fiber.key)且 ReactElment.type===Fiber.type 则复用，否则新增。

```js
// 只保留主干逻辑
function reconcileSingleElement(
  returnFiber: Fiber,
  currentFirstChild: Fiber | null,
  element: ReactElement,
  lanes: Lanes
): Fiber {
  const key = element.key;
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
      // Didn't match. 给当前节点点打上Deletion标记
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
function reconcileChildrenArray(
  returnFiber: Fiber,
  currentFirstChild: Fiber | null,
  newChildren: Array<*>,
  lanes: Lanes
): Fiber | null {
  let resultingFirstChild: Fiber | null = null;
  let previousNewFiber: Fiber | null = null;

  let oldFiber = currentFirstChild;
  let lastPlacedIndex = 0;
  let newIdx = 0;
  let nextOldFiber = null;
  // 1. 第一次循环: 遍历最长公共序列(key相同), 公共序列的节点都视为可复用
  for (; oldFiber !== null && newIdx < newChildren.length; newIdx++) {
    // 后文分析
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

- 属于 fiber 节点上面的一个属性，hook 对象是一个单向链表
- useState 的首次渲染和更新阶段代码执行过程

  - 首次渲染执行步骤

    - 构建 fiber -> 执行 hook 函数 -> 创建 hook 对象 -> 将初始状态赋值到 hook 对象 -> 将 hook 对象挂载到 fiber 节点下 -> 等待 commit 阶段的更新

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

// 触发事件
const EventContext = /*                 */ 0b0000010;
const DiscreteEventContext = /*         */ 0b0000100;

const LegacyUnbatchedContext = /*       */ 0b0001000;
// render 前会进入这个上下文
const RenderContext = /*                */ 0b0010000;
// commit之前
const CommitContext = /*                */ 0b0100000;
```

> hooks 相关小问题

- setState 是同步的还是异步的？
- 如果逻辑进入 flushSyncCallbackQueue(executionContext === NoContext), 则会主动取消调度, 立即进入 fiber 树构造过程. 当执行 setState 下一行代码时, fiber 树已经重新渲染了, 故 setState 体现为同步。
- 正常情况下, 不会取消 schedule 调度. 由于 schedule 调度是通过 MessageChannel 触发(宏任务), 故体现为异步？
- 同时执行多个 setState 会触发多次更新吗？
- 为什么 setState 相等的值不会触发页面重新渲染？
- hooks 是怎样实现状态复用的(双缓冲技术)

```js
function dispatchAction(fiber, queue, action) {

  // 创建update对象
  var eventTime = requestEventTime();
  var lane = requestUpdateLane(fiber);
  var update = {
    lane: lane,
    action: action,
    eagerReducer: null,
    eagerState: null,
    next: null
  };


  var pending = queue.pending;
  // 将update对象添加到队列的尾部
  if (pending === null) {
    // This is the first update. Create a circular list.
    update.next = update;
  } else {
    update.next = pending.next;
    pending.next = update;
  }
  queue.pending = update;
  var alternate = fiber.alternate;


  if (fiber === currentlyRenderingFiber$1 || alternate !== null && alternate === currentlyRenderingFiber$1) {
    // 这是一个渲染阶段更新。 将其隐藏在一个惰性创建的queue ->更新链表映射中。 在渲染结束后，我们将重新启动并在work-in-progress钩子上应用存储的更新。
    didScheduleRenderPhaseUpdateDuringThisPass = didScheduleRenderPhaseUpdate = true;
  } else {
    if (fiber.lanes === NoLanes && (alternate === null || alternate.lanes === NoLanes)) {
      // 队列目前是空的，这意味着我们可以在进入渲染阶段之前急切地计算下一个状态。 如果新状态与当前状态相同，我们或许能够完全摆脱困境。
      var lastRenderedReducer = queue.lastRenderedReducer;
      if (lastRenderedReducer !== null) {
        var prevDispatcher;
          // 上一次 state 的值
          var currentState = queue.lastRenderedState;
          // 得到最新的状态
          var eagerState = lastRenderedReducer(currentState, action); // Stash the eagerly computed state, and the reducer used to compute
          // it, on the update object. If the reducer hasn't changed by the
          // time we enter the render phase, then the eager state can be used
          // without calling the reducer again.
          update.eagerReducer = lastRenderedReducer;
          update.eagerState = eagerState;

          if (objectIs(eagerState, currentState)) {
            // Fast path. We can bail out without scheduling React to re-render.
            // It's still possible that we'll need to rebase this update later,
            // if the component re-renders for a different reason and by that
            // time the reducer has changed.
            return;
          }
    }
    scheduleUpdateOnFiber(fiber, lane, eventTime);
  }
}

```

#### useState 与 diff 之间的关系
