void main() {
  //  函数名前面表示返回值类型
  bool func() {
    return true;
  }

  // 可以省略
  func1() {
    return true;
  }

  func();

  func1();

  // 如果函数中只有一句表达式，可以使用简写语法
  bool func2() => true;

  func2();
}
