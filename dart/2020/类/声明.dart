class Person {
  // 类属性
  String name;
  int age;
  int sex;

// 普通构造函数
  Person(String name, int age, [int sex = 1]) {
    this.name = name;
    this.age = age;
    this.sex = sex;
  }

  // 方法
  Map<String, Object> getInfo() {
    return {'name': name, 'age': age, 'sex': sex};
  }

  //修改类属性
  void changeNames(String name) {
    if (name != null) {
      this.name = name;
    }
  }
}

void main() {
  Person p = Person('小明', 20);
  print(p.getInfo()); // {name: 小明, age: 20, sex: 1}

  p.changeNames('小红');
  print(p.getInfo()); // {name: 小红, age: 20, sex: 1}
}
