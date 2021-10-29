class InnerPerson {
  String _sectet = '私有属性'; // 私有属性，只有放在单独的文件class中生效

  // 私有方法
  void _run() {
    print('private function _run');
  }

  // 对外暴露私有方法
  String executeRun() {
    this._run();
    return _sectet;
  }
}
