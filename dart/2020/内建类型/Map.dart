void main() {
  //  Map是用来关联key value的对象。key和value可以是任何类型的对象。在一个Map中key只能
  // 出现一次，但是value可以出现无数次

  final list = <int>[];

  var map = {'name': '111', 111: '222', list: '333', list: 444};

  // 后面重复的key会覆盖前面的key
  print(map);

  print(map['name']);
  print(map[list]);
  print(map[111]);

  // 使用构造函数创建map对象

  final conMap = Map();

  conMap[1] = 222;

  // 这里会报错，因为conMap是一个常量
  // conMap = 1111;
  print(conMap);

  // 如果Map中不包含这个key，返回null
  print(conMap[2]); // null

  // 使用length 获取Map的长度
  print(conMap.length); // 1
}
