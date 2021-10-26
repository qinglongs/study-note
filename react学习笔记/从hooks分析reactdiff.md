### diff

> 简介

- 什么阶段执行：
  - diff 发生的算法发生在 fiber 节点对比更新阶段。
- 比较对象：
  - 旧的 fiber 对象与 新的 ReactElement 对象比较
- 性能：
  - 时间复杂度为 O(n)

> 单节点比较

- 如果 key 和 type 相同(即：ReactElemnt.key===Fiber.key)且 ReactElment.type===Fiber.type 则复用。
- 不满足上面一点就是新增。

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

```js
// reconcileChildrenArray函数(针对数组类型)和reconcileChildrenIterator(针对可迭代类型)的核心逻辑几乎一致
function reconcileChildFibers(
  returnFiber: Fiber,
  currentFirstChild: Fiber | null,
  newChild: any,
  lanes: Lanes
): Fiber | null {
  if (isArray(newChild)) {
    return reconcileChildrenArray(
      returnFiber,
      currentFirstChild,
      newChild,
      lanes
    );
  }
  if (getIteratorFn(newChild)) {
    return reconcileChildrenIterator(
      returnFiber,
      currentFirstChild,
      newChild,
      lanes
    );
  }
}

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

- 在 fiber 节点构造阶段，会调用函数组件内部的 hook 函数，并根据 hook 调用顺序挂载在 fiber 节点上面。
-
