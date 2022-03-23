// 函数作为变量
final str = () {
  print('变量函数');
};

// 函数作为入参
void executer(var callback) {
  var str = '12345';
  callback(str);
}

void main() {
  str();

  executer((str) => {print(str)});
}
