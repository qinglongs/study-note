> es6 新增特性

1. 默认参数
2. 模板文本
3. 多行字符串
4. 解构赋值
5. 增强的文本对象
6. 箭头函数
7. promise
8. 块级作用域
9. class
10. module
11. Map,Set

> Map 与 Set 的区别，Map 与 Object 的区别

- Map 和 Set

  - Map 和 Set 对象承载的数据元素可以按照插入时的顺序被迭代遍历。
  - Map 是一个键值对映射集合，Set 是一个值的集合，这些值是不重复的。

- Map 和 Object

  - Object 的键需要是字符串或者 Symbol,在 Map 里键可以是任意类型
  - Object 必须手动计算尺寸，Map 可以直接获取
  - Map 的遍历遵循元素的插入顺序，Object 是无序的，属性排列跟浏览器平台实现相关
  - Object 有原型，所以映射中有一些缺省的键

> 数组的 some、every、flat 有什么区别

- some 如果有一个元素满足条件就返回 true
- every 所有元素满足条件才返回 true
- flat 平铺数组，接收一个数字参数为平铺层级

> promise 实现原理
> promise race all 的区别

  <!-- https://zhuanlan.zhihu.com/p/58428287 -->

> 箭头函数和普通函数的区别

- 没有 arguments 对象，可以用 reset 参数解决
- 没有 this，可调用的 this 取决于声明位置。
- 不可以作为构造函数实例化对象
- 没有原型属性
- 不能当做 Generatot 函数，不能使用 yield 关键字
- call、apply、bind 不会改变箭头函数的 this 值。

> let、var、const 的区别

- 暂时性死区
- 在同一个作用域下不允许重复声明
- 不存在变量提升
- const 声明的变量一旦声明就不允许修改

> 堆和栈的区别

> 闭包的原理

- 内部函数在其作用域外部执行，会形成一个持续的对内部作用域的引用，会阻止垃圾回收器的执行

> instanceof 的实现原理

- 用于检测构造函数的 prototype 是否出现在某个实例的原型链上

> new 的实现原理

- 声明一个对象
- 将对象的原型指向构造函数的原型上
- 将构造函数的 this 绑定到这个对象上，并执行

> 数据类型，如何判断一个数据是否为数组

- Array.isArray
- [].constructor === Array
- arr instanceof Array

> JQuery 实现链式调用的原理

- 调用完毕后将 this 返回

> 原型，原型链，作用域，作用域链

> proxy 和 defineproperty 的区别

| 特性           | defineproperty       | proxy                                |
| -------------- | -------------------- | ------------------------------------ |
| 监听数组变化   | 否                   | 是                                   |
| 劫持整个对象   | 否                   | 是                                   |
| 兼容性         | 支持主流浏览器(IE8+) | 不支持 IE                            |
| 是否操作原对象 | 是                   | 否                                   |
| 可劫持的操作   | get、set             | get、set、defineproperty、has、apply |

> commonjs 与 es6 module 的区别

- commonjs 在运行时确定输入输出变量，es module 在编译时确定
- commonjs 输出的是值的拷贝，es module 输出的是值的引用
- commonjs 不允许导出多个变量

> event loop 原理，为什么要有 event loop
