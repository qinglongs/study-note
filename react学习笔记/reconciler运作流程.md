### reconciler 运作流程 (reactFiberWorkLoop.js)

> 主要功能：

- 输入:暴露 api 函数(如：scheduleUpdateOnFiber)，供给其他包(如 react 包)调用。
- 注册调度任务：与调度中心(scheduler 包)交互，注册调度任务 task，等待任务回调。
- 执行任务回调：在内存中构造出 fiber 树，同时与渲染器(react-dom)交互，在内存中创建出与 fiber 对应的 dom 节点。
- 输出：与渲染器(react-dom)交互，渲染 dom 节点。

> 输入

- 承接输入的函数只有 scheduleUpdateOnFiber
  - 在 react-reconciler 对外暴露的 api 函数中，只要涉及到需要改变 fiber 的操作(无论是首次更新或后续操作)，都会间接调用 scheduleUpdateOnFiber，所以它是输入链路中的必经之路。
- 进入 scheduleUpdateOnFiber 之后，后面有两种可能：
  - 不经过调度，直接进行 fiber 构造。
  - 注册调度任务，经过 Scheduler 包的调度，间接进行 fiber 构造。

> 注册调度任务

- ensureRootIsScheduled
  - 前半部分：判断是否需要注册新的调度(如果无需新的调度，会退出函数)
  - 等待调度中心执行任务，任务运行其实就是执行 performSyncWorkOnRoot 或 performConcurrentWorkOnRoot

> 执行任务回调

- performSyncWorkOnRoot 或 performConcurrentWorkOnRoot

  - performSyncWorkOnRoot 逻辑可以分为 3 部分
    - fiber 树构造。
    - 异常处理：有可能 fiber 构造过程中出现异常。
    - 调用输出。
  - performConcurrentWorkOnRoot
    - 调用 performConcurrentWorkOnRoot 函数时，首先会检查是否处于 render 过程中，是否需要恢复上一次渲染。
    - 如果本次渲染被中断，最后返回一个新的 performConcurrentWorkOnRoot 函数，等待下一次调用。

> 输出

- 在输出阶段，commitRoot 的实现逻辑是在 commitRootImpl 函数中，其主要逻辑是处理副作用队列，将最新的 fiber 树结构反映到 dom 上。
- 核心逻辑分为 3 个步骤：
  - commitBeforeMutationEffects
    - dom 变更之前，主要处理副作用队列中带有 Snapshot,Passive 标记的 fiber 节点。
  - commitMutationEffects
    - dom 变更，界面得到更新，主要处理副作用队列中带有 Placement,Update,Deletion,Hydrating 标记的 fiber 节点。
  - commitLayoutEffects
    - dom 变更后，主要处理副作用队列中带有 Update|Callback 标记的 fiber 节点。
