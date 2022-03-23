class Reac {
  num height;
  num width;

// 在构造函数执行前可以初始化列表，=号右边不能使用this
  Reac()
      : this.height = 20,
        this.width = 30 {
    print('${this.height}---${this.width}');
  }

  set reacHeight(num val) {
    this.height = val;
  }

  get area {
    return this.height * this.width;
  }
}

void main() {
  Reac r = Reac();
}
