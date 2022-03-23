void main() {
  // 动态类型变量
  dynamic a = 'hello world';

  // 显示声明变量类型
  String b = 'hello world';

  // var 声明变量,会自动推断变量类型
  var c = 111;

  int cc = 111;

  // 默认值，未初始化的变量默认值都是null
  int d;

  // final 的值只能设置一次
  final e = c + cc;

  print(e); // 222;

  // const 在编译时就固定，所以这里会报错
  // const b = count + ccc;

  // const还可以声明常量值
  const f = const [];

  // 这里baz=[]等同于 baz = const [];
  const g = [];

  var foo = [1, 3, 4];

  // 常量变量重新赋值会报错
  // f = 111;
}
