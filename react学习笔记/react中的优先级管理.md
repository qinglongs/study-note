### react 的优先级管理

> 优先级类型

- LanePriority：fiber 优先级，位于 react-reconciler 包
- SchedulerPriority：位于 scheduler 包。
- ReactPriorityLevel： 位于 react-reconciler 包中的 SchedulerWithReactIntegration.js 负责以上 2 套优先级的体系的转换。
- react 的可中断渲染，事件切片(time slicing),异步渲染(suspense)等特性，在源码中得以实现都是依赖于优先级管理

> Lane(车道模型)

- Lane 类型被定义成二进制变量，利用了位掩码的特性，在频繁运算的时候占用内存少，计算速度快。
  - Lane 和 Lanes 就是单数和复数的关系，代表单个任务的定义为 Lane，代表多个任务的定义为 Lanes
- Lane 是对于 expirationTime 的重构，以前使用 expirationTime 表示的字段，都改为了 Lane
- 使用 Lanes 模型相比 expriationTime 模型的优势：

> 优先级区别和联系

- 在源码中，3 种优先级位于不同的 js 文件，是相互独立的，
  - LanePriority 和 SchedulerPriority 从命名上面看，它们代表的是优先级。
  - ReactPriortyLevel 从命名上看，它代表的是等级而不是优先级，它用于衡量 LanePriority 和 SchedulerPriority 的等级
