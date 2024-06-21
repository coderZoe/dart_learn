import 'dart:math';

void main() {
  var tom = Person(name: 'Tom');
  var lee = Person(name: 'lee', age: 13);
  print(tom);
  print(lee);
  print(tom.birthYear);

  var pointA = Point(x: 12);
  var pointB = Point(y: 20);

  var res = Point.distance(pointA, pointB);
  print(res);
}

//dart中所有的实例变量都会隐式的生成getter 对于非late或final类型的变量也会隐式生成setter
//所以当我们调用person.age的时候是在调age的getter,调person.age = 13的时候是在调age的setter
//我们也可以手动写一个getter
class Person {
  String name;
  int? age;

  Person({required this.name, this.age = 12});

  @override
  String toString() {
    return 'name$name,age:$age';
  }

  //其实这个get 有些像vue里的compute计算属性
  int get birthYear => 2024 - (this.age ?? 0);
}

///dart中每个class都有一个隐式的接口，如上面的Person虽然是class，但也默认存在一个Person接口
///我们可以写一个User继承Person 但implements并不继承父类的任何实现!!! 需要自己写实现,相当于一旦implements了就需要将父类的所有方法自己实现
///比如下面这个User我们就需要实现  'getter Person.age', 'getter Person.birthYear', 'getter Person.name', 'setter Person.age' 'setter Person.name'
class User implements Person {
  int get age => 0;
  String get name => '';
  int get birthYear => 2024 - (this.age ?? 0);

  void set age(int? age) {}
  void set name(String name) {}
}

/// 静态方法
class Point {
  double x;
  double y;

  Point({this.x = 0, this.y = 0});

  static double distance(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }
}
