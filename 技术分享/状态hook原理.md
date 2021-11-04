> useState 原理

- 作用：
  - 使 function 组件也有能力管理自己的状态。
- 原理简介：
  - 调用 useState 创建 hook 对象，将 hook 对象挂载在 fiber 对象上，然后利用 fiber 的双缓冲技术实现状态复用。

```jsx
// hook链表
export type Hook = {|
  memoizedState: any,
  baseState: any,
  baseQueue: Update<any, any> | null,
  queue: any,
  next: Hook | null,
|};

function Func() {
  // 状态相关
  const [count, setCount] = useState(0);
  const ref = useRef(null);
  const memoValue = useMemo(() => count, []);
  const callback = useCallback(() => {
    /* todo */
  }, []);
  // 副作用相关
  useEffect(() => {
    /* useEffect */ return () => {
      /* useEffectDistory */
    };
  }, [count]);
  useLayoutEffect(() => {
    /* useEffect */
  }, []);

  return <div>{count}</div>;
}
```

上面这个 Func 组件内部的 hook 函数会依次调用，会在 Func 组件对应的 fiber 节点上构建一个 hooks 链表，如下：

```js

{
  // useState
  memoizedState: count,
  queue: null,
  next:{
    // useRef
    memoizedState: null,
    queue: null,
    next:{
      // useMemo
      memoizedState:[count,[]],
      queue: null,
      next:{
        //  useCallback
        memoizedState:[()=>{ /* todo */ },[]],
        queue: null,
        next:{
          // useEffect
          memoizedState:{
            tag,
            // ()=>{/* useEffect */ }
            create,
            //  ()=>{/* useEffectDistory */}
            destroy:undefined,
            //  [count]
            deps,
            // 循环链表指向下一个副作用hook
            next: (null: any),
          },
          queue: null,
          next:{
            tag,
            // ()=>{/* useLayoutEffect */ }
            create,
            destroy:undefined,
            // []
            deps,
            // 循环链表指向下一个副作用hook
            next: (null: any),
          }
        }
      }
    }
  },
}


```

> useState 小问题

1. 为什么 hooks 不能在 if 条件语句中使用？(上面的 hooks 单向链表就能够解释)。

2. 为什么多次调用 setState 只会触发一次更新？

- react 在注册调度任务时会有一个节流和防抖的操作。
  - 节流：新旧任务优先级相同，就不需要注册新的任务，直接沿用之前的任务。
  - 防抖：新旧任务优先级不同，取消旧的任务注册新的任务。

2. setState 是同步还是异步。

- 如果调用 setState 触发更新时当前执行上下文为空，就不会去注册调度任务 ，而是直接去构造 fiber 树，这时 setState 就表现为同步。
- 正常调用 setState 的表现都是异步的。

3. 为什么 setState 同一个引用值/相等的基础类型值不会触发更新？

- 在调用 setState(xxx) 时，react 会先去检查当前更新的值和上一次更新的结果是否相等，如果相等就不会触发更新调度。

4. hooks 是如何实现状态复用的？

- 利用双缓冲技术，从正在渲染的 fiber 节点上面依次 clone 对应的 hook 对象，他们的引用不会发生变化，从而实现状态复用。
