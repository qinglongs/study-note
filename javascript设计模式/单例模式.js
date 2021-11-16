//  保证只有一个实例

class SingleObject {
  constructor(ctor) {
    this.cotr = ctor;
  }

  login() {
    console.log("login...");
  }

  //  立即执行函数，保证只有只会生成一个实例
  static getInstance = (() => {
    let instance = null;
    return () => {
      if (!instance) {
        instance = new SingleObject();
      }
      return instance;
    };
  })();
}

const sing1 = SingleObject.getInstance();
const sing2 = SingleObject.getInstance();

console.log(sing1 === sing2); // true
