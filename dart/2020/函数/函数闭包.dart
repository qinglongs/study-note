func() {
  final innerFunc = (str) => str;

  return innerFunc;
}

void main() {
  final fun = func();

  final res = fun('函数闭包');

  print(res);
}
