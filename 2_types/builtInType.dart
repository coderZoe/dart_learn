void main() {
  int a = -10;
  a = a.abs();
  print(a);

  double b = 123.5;
  var c = b.floor();
  print(c);
  //num类型是int和double的合集类型
  num d = 123.4;
  d = d.floor();
  print(d);

  //字符串转数字
  int number1 = int.parse('1');
  assert(number1 == 1);
  double number2 = double.parse("1.1");
  assert(number2 == 1.1);

  var number3 = num.parse('1.234');
  assert(number3 == 1.234);

  //数字转字符串
  int number4 = 10;
  var str1 = number4.toString();
  assert(str1 == '10');

  double pi = 3.1415926;
  var str2 = pi.toStringAsFixed(2);
  assert(str2 == '3.14');

  var name = "小明";
  Map xiaoming = {
    'name': '小明',
    'age': 12,
    'hobbies': ['play', 'eat', 'sleep']
  };
  String str3 = 'Hello$name your age is ${xiaoming['age']}';
  print(str3);

  //字符串拼接
  var str4 = str3 + str2;

  //多行字符串
  var str5 = '''
name: my_project
description: A new Dart project.
version: 1.0.0

environment:
  sdk: '>=2.10.0 <3.0.0'

dependencies:
  http: ^0.13.3
  ''';
  print(str5);

//原始字符串 不转义 使用r开头 加一段字符串
  var str6 = r'In a raw string, not even \n gets special treatment.';
  print(str6);
}
