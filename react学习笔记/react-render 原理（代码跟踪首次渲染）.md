## react-render 代码跟踪首次渲染（主干逻辑）原理

### 调用 render

```javascript
function render(
  // reactElement
  element: React$Element<any>,
  // 根节点
  container: Container,
  // 回调
  callback: ?Function
) {
  return legacyRenderSubtreeIntoContainer(
    null,
    element,
    container,
    false,
    callback
  );
}
```

### 调用 legacyRenderSubtreeIntoContainer 生成 fiberRootNode 调用更新

```javascript
function legacyRenderSubtreeIntoContainer(
  // 父组件
  parentComponent: ?React$Component<any, any>,
  // reactElement
  children: ReactNodeList,
  // #root
  container: Container,
  // 是否服务端渲染
  forceHydrate: boolean,
  // 回调
  callback: ?Function
) {
  //
  let root: RootType = (container._reactRootContainer: any);
  let fiberRoot;
  if (!root) {
    // 第一次渲染
    // 创建ReactDOMBlockingRoot实例
    root = container._reactRootContainer = legacyCreateRootFromDOMContainer(
      container,
      forceHydrate
    );

    // FiberRootNode
    fiberRoot = root._internalRoot;

    // 第一次不需要批量渲染
    unbatchedUpdates(() => {
      // 调用更新
      updateContainer(children, fiberRoot, parentComponent, callback);
    });
  } else {
    // 后续渲染
    fiberRoot = root._internalRoot;
    // 调用更新
    updateContainer(children, fiberRoot, parentComponent, callback);
  }

  // 后续再来研究这儿
  return getPublicRootInstance(fiberRoot);
}

/** 不做批量更新*/
export function unbatchedUpdates<A, R>(fn: (a: A) => R, a: A): R {
  // executionContext 当前正在执行的上下文
  const prevExecutionContext = executionContext;

  // 在现有执行上下文上面，去掉批量执行上下文
  executionContext &= ~BatchedContext;
  // 取并集
  executionContext |= LegacyUnbatchedContext;
  try {
    // 执行回调
    return fn(a);
  } finally {
    executionContext = prevExecutionContext;
    if (executionContext === NoContext) {
      // Flush the immediate callbacks that were scheduled during this batch
      resetRenderTimer();
      flushSyncCallbackQueue();
    }
  }
}
```

### updateContainer 调用更新

```javascript
function updateContainer(
  // reactElement
  element: ReactNodeList,
  // FiberRootNode 节点
  container: OpaqueRoot,
  // 父节点 第一次渲染为空
  parentComponent: ?React$Component<any, any>,
  callback: ?Function
): Lane {
  // 获取fiberNode节点
  const current = container.current;
  // 获取事件触发时间
  const eventTime = requestEventTime();
  // 获取优先级
  const lane = requestUpdateLane(current);

  //
  if (enableSchedulingProfiler) {
    markRenderScheduled(lane);
  }

  // 获取子树的上下文
  const context = getContextForSubtree(parentComponent);

  // 更新上下文
  if (container.context === null) {
    container.context = context;
  } else {
    container.pendingContext = context;
  }

  // 创建update对象
  const update = createUpdate(eventTime, lane);
  // Caution: React DevTools currently depends on this property
  // being called "element".
  update.payload = { element };

  callback = callback === undefined ? null : callback;

  if (callback !== null) {
    update.callback = callback;
  }

  // 加入updateQueue
  enqueueUpdate(current, update);

  //
  scheduleUpdateOnFiber(current, lane, eventTime);

  return lane;
}
```

### scheduleUpdateOnFiber

```javascript
function scheduleUpdateOnFiber(
  // 当前fiber节点
  fiber: Fiber,
  // 优先级
  lane: Lane,
  // 事件触发事件
  eventTime: number
) {
  checkForNestedUpdates();

  const root = markUpdateLaneFromFiberToRoot(fiber, lane);

  if (root === null) {
    warnAboutUpdateOnUnmountedFiberInDEV(fiber);
    return null;
  }

  // Mark that the root has a pending update.
  markRootUpdated(root, lane, eventTime);

  // workInProgressRoot 当前root节点
  if (root === workInProgressRoot) {
    // Received an update to a tree that's in the middle of rendering. Mark
    // that there was an interleaved update work on this root. Unless the
    // `deferRenderPhaseUpdateToNextBatch` flag is off and this is a render
    // phase update. In that case, we don't treat render phase updates as if
    // they were interleaved, for backwards compat reasons.
    if (
      deferRenderPhaseUpdateToNextBatch ||
      (executionContext & RenderContext) === NoContext
    ) {
      workInProgressRootUpdatedLanes = mergeLanes(
        workInProgressRootUpdatedLanes,
        lane
      );
    }
    if (workInProgressRootExitStatus === RootSuspendedWithDelay) {
      // The root already suspended with a delay, which means this render
      // definitely won't finish. Since we have a new update, let's mark it as
      // suspended now, right before marking the incoming update. This has the
      // effect of interrupting the current render and switching to the update.
      // TODO: Make sure this doesn't override pings that happen while we've
      // already started rendering.
      markRootSuspended(root, workInProgressRootRenderLanes);
    }
  }

  // TODO: requestUpdateLanePriority also reads the priority. Pass the
  // priority as an argument to that function and this one.
  const priorityLevel = getCurrentPriorityLevel();

  if (lane === SyncLane) {
    if (
      // Check if we're inside unbatchedUpdates
      // 如果式legacy模式并且当前执行与RenderContext、CommitContext没有重合
      (executionContext & LegacyUnbatchedContext) !== NoContext &&
      // Check if we're not already rendering
      (executionContext & (RenderContext | CommitContext)) === NoContext
    ) {
      // Register pending interactions on the root to avoid losing traced interaction data.
      schedulePendingInteractions(root, lane);

      // This is a legacy edge case. The initial mount of a ReactDOM.render-ed
      // root inside of batchedUpdates should be synchronous, but layout updates
      // should be deferred until the end of the batch.
      performSyncWorkOnRoot(root);
    } else {
      ensureRootIsScheduled(root, eventTime);
      schedulePendingInteractions(root, lane);
      if (executionContext === NoContext) {
        // Flush the synchronous work now, unless we're already working or inside
        // a batch. This is intentionally inside scheduleUpdateOnFiber instead of
        // scheduleCallbackForFiber to preserve the ability to schedule a callback
        // without immediately flushing it. We only do this for user-initiated
        // updates, to preserve historical behavior of legacy mode.
        resetRenderTimer();
        flushSyncCallbackQueue();
      }
    }
  } else {
    // Schedule a discrete update but only if it's not Sync.
    if (
      (executionContext & DiscreteEventContext) !== NoContext &&
      // Only updates at user-blocking priority or greater are considered
      // discrete, even inside a discrete event.
      (priorityLevel === UserBlockingSchedulerPriority ||
        priorityLevel === ImmediateSchedulerPriority)
    ) {
      // This is the result of a discrete event. Track the lowest priority
      // discrete update per root so we can flush them early, if needed.
      if (rootsWithPendingDiscreteUpdates === null) {
        rootsWithPendingDiscreteUpdates = new Set([root]);
      } else {
        rootsWithPendingDiscreteUpdates.add(root);
      }
    }
    // Schedule other updates after in case the callback is sync.
    ensureRootIsScheduled(root, eventTime);
    schedulePendingInteractions(root, lane);
  }

  // We use this when assigning a lane for a transition inside
  // `requestUpdateLane`. We assume it's the same as the root being updated,
  // since in the common case of a single root app it probably is. If it's not
  // the same root, then it's not a huge deal, we just might batch more stuff
  // together more than necessary.
  mostRecentlyUpdatedRoot = root;
}
```
