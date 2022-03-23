> 模拟一个 react 树

```html
<div>
  <ul>
    <li>1</li>
    <li>2</li>
  </ul>
</div>
```

对应的 fiber 树

```js
const rootFiber = {
  type: "div",
  return: null,
  sibling: null,
  child: {
    type: "ul",
    return: null,
    subling: null,
    child: {
      type: "li",
      return: null,
      sibling: {
        type: "li",
        return: null,
        child: "1",
      },
      child: "1",
    },
  },
};

rootFiber.child.return = rootFiber;
rootFiber.child.chlid.return = rootFiber.child;
rootFiber.child.sibling.return = rootFiber.child;

// 遍历方法
function traverse(node) {
  const root = node;
  let current = node;

  while (true) {
    console.log("当前遍历的节点是：" + current.type);

    if (current.child) {
      current = current.child;
      continue;
    }

    if (current.sibling) {
      current = current.sibling;
      continue;
    }

    while (!current.sibling) {
      if (current.return === null || current.return === root) return;
      current = current.return;
    }

    current = current.sibling;
  }
}
```
