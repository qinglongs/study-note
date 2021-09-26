class Reac {
  num height;
  num width;

  Reac(this.height, this.width);

  // getter
  get area {
    return this.height * this.width;
  }

  // setter
  set setHeight(num val) {
    height = val;
  }
}

void main() {
  Reac r = Reac(200, 100);

  // 这里会调用setHeight setter方法
  r.setHeight = 50;

  print(r.height); // 20000
}
