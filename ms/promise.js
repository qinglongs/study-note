class IPromise {
  callbacks = [];
  state = "pending"; //增加状态
  value = null; //保存结果
  constructor(fn) {
    fn(this._resolve.bind(this), this._reject.bind(this));
  }

  then(onFulfilled, onRejected) {
    // 实现链式调用的关键
    return new IPromise((resolve, reject) => {
      this._handle({
        onFulfilled: onFulfilled || null,
        onRejected: onRejected || null,
        resolve: resolve,
        reject: reject,
      });
    });
  }

  // 处理单个 then 的任务
  _handle(params) {
    if (this.state === "pending") {
      this.callbacks.push(params);
      return;
    }
    const isSuccess = this.state === "fulfilled";
    let cb = isSuccess ? params.onFulfilled : params.onRejected;
    // then方法没有注册成功或者失败的回调
    if (!cb) {
      cb = isSuccess ? params.resolve : params.reject;
      cb(this.value);
      return;
    }

    // then方法注册了成功或者失败的回调
    const ret = cb(this.value);
    // 将then方法的返回值赋值给新的promise对象的value，从而实现链式调用
    cb = isSuccess ? params.resolve : params.reject;
    cb(ret);
  }

  _resolve(value) {
    this.state = "fulfilled"; //改变状态
    this.value = value; //保存结果
    this.callbacks.forEach((params) => this._handle(params));
  }

  _reject(reson) {
    this.state = "rejected";
    this.value = reson;
    this.callbacks.forEach((params) => this._handle(params));
  }
}

const p = new IPromise((resolve, reject) => {
  setTimeout(() => {
    resolve("1111");
  }, 4000);
});

p.then((res) => {
  console.log("1", +new Date()); // ???
  return "111";
})
  .then(() => {
    console.log("2", +new Date());
  })
  .then()
  .then(
    (res) => {
      console.log("3", +new Date()); // ???
    },
    (reson) => {
      console.log("3", reson); // ???
    }
  );
