const a = 'a';
const b = 'b';

void main() {
  //switch
  var num = 1;
  switch (num) {
    case 1:
      print('1');
    case 2:
      print('2');
  }
  //switch配合pattern (解构)
  var xiaoming = Person('小明', 12);

  //switch有返回值的时候 不加case
  var result = switch (xiaoming) {
    //不加case 直接解构判断
    Person(ageAdd: > 10) => '大于10',
    //这里相当于是default
    _ => "小于等于10"
  };
  print(result);

  //1. 常量switch
  var v1 = (12, 13);
  foo(v1);
  var v2 = (12, "hello");
  foo(v2);
  var v3 = ('hello', 'world');
  foo(v3);

  //2. 表达式匹配 具有返回值的switch
  var age1 = 13;
  var res = switch (age1) { > 12 => true, 10 || 9 => true, _ => false };
  print(res);

  var result2 =
      switch (xiaoming) { Person(:var age) when age > 10 => age + 1, _ => -1 };
  print(result2);
}

/// 这里是做模式匹配，匹配value值的模式
void foo(dynamic value) {
  switch (value) {
    case (int _, String _):
      print('int +String');
    case (int _, int _):
      print('int+int');
    default:
      print('default');
  }
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  int get ageAdd => this.age + 1;
}
