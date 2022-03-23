void main() {
  Set<String> halogens = {'flutter', 'javascript', 'java', 'pythone'};

  // print(halogens);

  // 要创建一个空集，使用前面带有类型参数的{}或者将{}赋值给Set类型的变量，否则声明的是一个Map
  var names = <String>{};

  Set<String> setName = {};

  var xxx = {}; // 这是一个Map

  // 使用add或addAll为已有的Set添加元素

  setName.addAll(halogens);

  setName.add('set新增值'); // {flutter, javascript, java, pythone,set新增值}

  // length 获取Set对象中元素的个数
  print(setName.length); // 5;

  // 在Set字面量前面加一个const 就是一个编译时常量
  final Set<int> setNum = const {1, 3, 4, 5};

  setNum.add(6); //Cannot change unmodifiable set
}
