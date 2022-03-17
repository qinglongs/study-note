class People {
  public name: string;
  public age: string;
  protected weight: number;

  constructor(name, age) {
    this.name = name;
    this.age = age;
    this.weight = 200;
  }

  eat() {
    console.log(`${this.name} eat something`);
  }

  speak() {
    console.log(`My name is ${this.name},I'm ${this.age} years old`);
  }
}

class Student extends People {
  public number: number;
  constructor(name, age, number) {
    super(name, age);
    this.number = number;
  }

  study() {
    console.log(`${this.name} study`);
  }
}

const xiaoMing = new Student("xiaoMing", 22, "A1");

xiaoMing.study();
xiaoMing.eat();
xiaoMing.speak();
