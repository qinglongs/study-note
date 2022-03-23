export default class List {
  // 列表元素个数
  listSize = 0;
  // 列表当前位置
  pos = 0;
  // 存储列表元素的变量
  dataSource = [];
  // 清空列表
  clear() {
    this.dataSource = [];
  }
  // 返回列表的字符串形式
  toString() {
    return this.dataSource.toString();
  }
  // 返回给定位置的元素
  getElement(index) {
    return this.dataSource[index];
  }
  // 在现有元素后插入新元素
  insert() {}
  // 在列表的末尾添加新元素
  append(element) {
    this.dataSource[this.listSize++] = element;
  }
  // 从列表中删除元素
  remove(element) {
    const len = this.dataSource.length;
    for (let i = 0; i < len; i++) {
      if (this.dataSource[i] === element) {
        this.dataSource.splice(i, 1);
      }
    }
  }
  // 将列表的当前位置移动到第一个元素
  front() {
    this.pos = 0;
  }
  // 将当前位置移动到最后一个位置
  end() {
    this.pos = this.listSize;
  }
  // 将当前位置后移一位
  prev() {
    --this.pos;
  }
  // 将当前位置前移一位
  next() {
    ++this.pos;
  }
  // 判断是否还有后一位
  hasNext() {
    return !!this.dataSource[this.pos + 1];
  }
  // 判断是否还有前一位
  hasPrev() {
    return !!this.dataSource[this.pos - 1];
  }
  // 返回列表当前位置
  currPos() {
    return this.dataSource[this.pos];
  }
  // 将当前位置移动到指定位置
  moveTo(index) {
    const position = this.dataSource[this.pos];
    const indexNode = this.dataSource[index];
    this.dataSource[this.pos] = indexNode;
    this.dataSource[index] = position;
  }
}
