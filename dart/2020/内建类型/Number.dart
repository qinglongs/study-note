void main() {
  // int 整数不得大于64为，具体取决于平台
  var num = 1;
  var hex = 0xDEADBEEF;

  // double 如果一个数字包含小数点，那么就是double类型数据
  var y = 1.2345;
  var exponents = 1.42e5;

  // 从dart2.1开始，必要的时候int字面量会自动转换成double类型,在之前的版本是错误的
  double intCount = 1;

  // string-->int
  var one = int.parse('1111');

  print(one == 1111); // true

  // string-->dobule
  var doubleNum = double.parse('1.1111');

  print(doubleNum); // 1.1111

  // int-->string;
  var intStr = 1.toString();

  print(intStr);

  // dobule-->string  转字符串并保留两位小数
  var dobuleStr = 1.111.toStringAsFixed(2);

  print(dobuleStr);

  // 这是编译时常量，不能给它变量，或者算术表达式
  const constNum = y * exponents;

  // 这是运行时常量，这样就不会报错
  final finalNum = y * exponents;
}
