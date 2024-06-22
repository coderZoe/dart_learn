void main() {
  var a = 12;
  print(a.double());

  var listA = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];
  print(listA.sumAll());
  print(listA.sumAll2());
}

/// dart和c#语法很像，借鉴的内容也很多，其中扩展方法就是其一
/// 扩展方法的作用是向已经完成的库/第三方库/标准库中添加新的功能
extension BetterInt on int {
  int double() => this * this;
}

extension BetterIntList on List<int> {
  int sumAll() {
    int sum = 0;
    for (var item in this) {
      sum += item;
    }
    return sum;
  }

  int sumAll2() => this.reduce((sum, now) => sum + now);
}

/// 可以是未命名extension 但这时候这个extension就只能用在库内可见，
/// 且由于未命名，也不可以使用显示声明来解决冲突
extension on double {
  double plusOne() => this + 1;
}
