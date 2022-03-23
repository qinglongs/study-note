// 命名可选参数
int func({int num0 = 1, int num1}) {
  return num0 + num1;
}

// 可选参数
int func1(int number, [String str]) {
  return number;
}

// 必传参数
double func2(double number) {
  return number;
}

// 命名必传参数
int func3({int number, int number2}) {
  return number + number2;
}

void main() {
  final num3 = func(num0: 1, num1: 1);

  print(num3);
  print(func1(111));

  // 这个函数有个必传参数不传会报错
  func2(1.0);
}
