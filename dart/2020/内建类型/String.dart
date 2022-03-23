void main() {
  // 允许单引号和双引号声明字符串
  var s1 = 'single quotes work well for string literals.';

  var s2 = "dobule quotes work just as well";

  // 字符串可以使用${xxx} 内嵌表达式，如果表达式是一个变量声明则可省略，这会自动在dart中调用toString方法得到对应的字符串值

  const a = '编译时常量';

  const s3 = 'string $a';

  // 如果一个编译时常量的字符串中的插值表达式内部不是一个编译时常量会报错；
  const s10 = 'string $s1';

  var s4 = 'string ${1111}';

  // 字符串拼接
  String s5 = '111' + '2222';

  String s6 = s3 + s4;

  // 连续使用三个单引号，或者三个双引号就可以实现多行字符串对象的创建
  String s7 = '''
    sasdadasdasdadasda
    asdasdasdasdasd
    adasd
   ''';

  String s8 = """
    asdasdasdasdaklaklsjdklasjd
   """;

  //  使用r前缀，可以创建原始"raw"字符串；
  final String s9 = r'xxxxxxx';
}
