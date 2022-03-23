import 'dart:io';

const oneSecond = Duration(seconds: 3);

// async
Future<String> printWithDelay(String message) async {
  await Future.delayed(oneSecond);
  return message;
}

// Future 它有两个状态 未完成 已完成
Future<String> future() {
  return Future<String>(() {
    sleep(oneSecond);
    return 'Future函数';
  });
}

void main() async {
// 3
  printWithDelay('async函数').then((value) => print(value));
// 2
  future().then((value) => print(value));
// 1
  Future.value('Future.value').then((value) => print(value));
}
