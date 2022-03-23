### React 调度原理(scheduler) SchedulerHostConfig.default.js

- 调度中心是 react 运行时的中枢，理解 scheduler 调度，就基本把握了 react 的命门。
- 核心逻辑在 8 个函数中：

```js
export let requestHostCallback; // 请求及时回调：prot.postMessage
export let cancelHostCallback; // 取消及时回调：scheduledHostCallback = null;
export let requestHostTimeout; // 请求延时回调: setTimeout
export let shouldYieldToHost; // 是否让出主线程(currentTime >= deadline&&needsPaint):让浏览器能够执行更高优先级的任务(如ui绘制，用户输入等)
export let requestPaint; // 请求绘制：设置 needsPaint = true;
export let getCurrentTime; // 获取当前时间
export let forceFrameRate; // 强制设置yieldInterval(让出主线程的周期)。这个函数虽然存在，但暂时没有用到
```

> 及时回调
