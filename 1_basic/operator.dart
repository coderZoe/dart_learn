void main() {
  const a = 10;
  const b = 3;
  // dart的/是除，但会保留小数，返回类型是double 这与大部分编程语言不同
  const c = a / b; //3.333333
  print(c);
  // ~/对应的是整除，只保留整数部分
  const d = a ~/ b; //3
  print(d);

  var point1 = Point(1, 3);
  var point2 = Point(1, 3);
  print(point1 == point2); //true

  // ??=运算符 a ??= b等价于 if(a == null){a == b} else{ do nothing}
  var a1 = 12;
  int? b1 = null;
  b1 ??= a1;
  var c1 = 13;
  c1 ??= a1;
  print(b1);
  print(c1);

  //??=运算符其实就是??加上赋值运算符=
  //下面的expr1 ?? expr2  如果 expr1 非空，则返回其值；否则，计算并返回 expr2 的值。
  //我们可以将dart的??理解为if null表达式
  var result1 = point1.x ?? point1.y;

  //级联运算符 这要用于函数式编程的写法，如:
  var point3 = Point(11, 12)
    ..x = 1
    ..printIt()
    ..y = 2
    ..printIt();

  //spread  展开运算符 主要用于集合，将一个几个展开插入到另一个集合中
}

//dart支持运算符重载 这个功能很棒
class Point {
  int? x;
  int y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) {
    //类型检测/转换 as 是将对象转为某一类型，is 和is!是类型判断
    return other is Point && this.x == other.x && this.y == other.y;
  }

  //重写 == 一定也要重写hash 避免用到hash的场景
  @override
  int get hashCode => Object.hash(this.x, this.y);

  void printIt() {
    print('x:$x,y:$y');
  }
}
