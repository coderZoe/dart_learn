import 'dart:math';

void main() {
  var pointA = Point(x: 10, y: 10);
  var pointB = Point(x: 20, y: 20);
  print(pointA - pointB);
  print(pointA == pointB);
}

class Point {
  double x;
  double y;
  Point({required this.x, required this.y});

  double distance(Point other) {
    var dx = this.x - other.x;
    var dy = this.y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  double operator -(Point other) {
    return distance(other);
  }

  //这里== 入参只能是Object，不能是Point
  //这是父类Object定义的 external bool operator ==(Object other);
  @override
  bool operator ==(Object other) {
    return other is Point && this.x == other.x && this.y == other.y;
  }

  //注：重写==一定要重写hash
  int get hash => Object.hash(x, y);
}
