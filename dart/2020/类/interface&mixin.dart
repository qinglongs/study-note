class Person {
  String name;
  int age;
  int sex;

  Person(this.name, this.age, this.sex);
}

class Person1 {
  String enjoy;
}

// 接口
class Child implements Person {
  String name;
  int age;
  int sex;

  Child(this.name, this.age, this.sex);
}

// mixin
class Child1 extends Person with Person1 {
  String name;
  int age;
  int sex;
  String enjoy;

  Child1(this.name, this.age, this.sex, this.enjoy);
}
