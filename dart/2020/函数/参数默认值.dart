void main() {
  // 通过 {}可以指定函数参数的名称
  void func1({
    String val = '参数默认值',
  }) {
    print(val);
  }

  func1();
}
