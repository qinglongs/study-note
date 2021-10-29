> BFC 原理
> 盒模型

- W3C 标准盒模型 宽高 = content
- IE 盒模型 宽高 = content+padding+border

> flex 布局

- 分为主轴跟交叉轴
- 容器属性
  - flex-direction 主轴的方向 row|columns|
  - flex-warp 是否换行 nowrap|warp|warp-reverse
  - flex-flow flex-direction 和 flex-wrap 的缩写 默认值为 row nowrap
  - justify-content 项目在主轴上的对其方式
  - align-items 项目在交叉轴上面的对其方式
  - align-content 定义多根轴线的交叉轴对其方式
- 项目属性
  - order 项目的顺序，数字越小越靠前
  - flex-grow 定义项目的放大比例，默认为 0，即存在多余空间也不放大。
  - flex-shrink 定义项目的缩小比例，默认为 1，即空间不足，自动缩小
  - flex-basis 在分配多余空间之前，项目占据主轴的空间，浏览器根据这个属性，计算主轴是否有多余空间，默认值 auto 即项目的本来大小，它也可以设置固定的值，让项目占据固定的空间
  - flex flex-grow flex-shrink flex-basis 的缩写
  - align-self 与 align-items 一样，但只能应用于单个项目

> 垂直水平居中

- 水平
  - 行内元素
    - text-align
  - 块级元素
    - inline-block + text-align
    - margin: 0 auto
    - table + margin
    - absuolute + transform
    - flex + justify-content
    - flex + margin
  - 多块级元素
    - flex +justify-content
    - inline-block + text-align
  - 块级元素通用
    - flex + justify-content

> 瀑布流布局

- columns 实现，不兼容 ie，元素按列排列，不利于遍历
- flex 实现，元素按列排列，不利于遍历
- 实际业务 js + 绝对定位 实现最好

> height:100%不生效原因

- 你让 div 的 height="100%"，执行网页时，css 先执行到，而整个网页中的内容还没有完全载入，是获取不到 div 外面的<body>等的高度的
