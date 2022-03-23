/**
 * dart所有的东西都是对象，所有的对象都继承自Object类
 *
 * dart 是一门使用类和单继承的面向对象语言，所有的对象都是类的实例
 * 并且所有类都是Object的子类
 */

// 声明一个class

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  // 命名构造函数
  Person.setInfo(String name, int age) {
    this.name = name;
    this.age = age;
  }

  // 方法
  Map<String, dynamic> getInfo() {
    return {'name': name, 'age': age};
  }

  void setInfo(age) {
    this.age = age;
  }
}

void main() {
  Person p = Person('张三', 10);

  // 改变age
  p.setInfo(12);

  print(p.getInfo());
}
