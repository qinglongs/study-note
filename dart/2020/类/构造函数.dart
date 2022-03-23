import './私有属性和私有方法.dart';

class Person {
  String name;
  int age;
  int sex;

// 普通构造函数
  Person(String name, int age, int sex) {
    this.name = name;
    this.age = age;
    this.sex = sex;
  }

  // 命名构造函数
  Person.origin({String name, int age, int sex}) {
    this.name = name;
    this.age = age;
    this.sex = sex;
  }

  // 命名构造函数
  Person.fromJson(Map data) {
    print('in Person');
  }
}

// 子类
class ChildPerson extends Person {
  ChildPerson.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
}

void main() {
  Person p = Person.origin(name: '小红', age: 11, sex: 0);

  InnerPerson p1 = InnerPerson();

  print(p1.executeRun());
}
