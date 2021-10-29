// dart 提供了typedef关键字来定义一种函数格式,比如:

typedef String Compare(Object a, Object b);

void main() {
  // 当你打算把一个函数赋值给Compare类型的变量时,它会严格检查函数的参数类型和返回值类型
  // 是否和Compare类型函数完全对应,如果不对应的话,编译会报错
  Compare test = (Object num1, Object num2) {
    return num1.toString() + ' ' + num2.toString();
  };

  print(test('hello', 'world'));
}
