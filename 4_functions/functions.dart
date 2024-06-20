import '../3_patterns/switch.dart';

void main() {
  print(sum(a: 1));
  print(sum(a: 1, b: 2));
  print(sum2());
  print(sum2(a: 10));
  print(sum2(b: 20));

  print(sum3(1));
  print(sum3(1, 2));
  print(sum4(1));
  print(sum4(1, 2));

  //函数作为参数传递
  var plusOne = (int a) => a + 1;
  var list = <int>[1, 2, 3, 4, 5, 6, 7, 8];
  var list2 = list.map(plusOne);
  print(list2);

  //匿名函数 也可以用上面的箭头函数代替 但箭头函数一般都是单个表达式
  var list3 = list.map((item) {
    return item + 1;
  });
  print(list3);

  //闭包
  var add = adder();
  print(add());
  print(add());
  print(add());

  var appender = append();
  appender('hello');
  appender('\t');
  print(appender('world'));

  //生成器 与直接迭代集合的区别是生成器是懒加载的形式：消费一个才会生产下一个，这样做可以减少内存的消耗
  for (var item in syncGenerator(5)) {
    print(item);
  }
  for (var item in syncGenerator2()) {
    print(item);
  }
}

//命名参数 命名参数必须指定是可选还是必须 如果是可选就加？ 必须使用关键字required
//其实就是元组的使用，这里相当于将入参转为了元组，然后又顺势用了元组的解构，调用的时候，其实传参也是类似于元组传参
int sum({required int a, int? b}) {
  return a + (b ?? 0);
}

//参数默认值 有了参数默认值的参数 其实就相当于是可选参数了
int sum2({int a = 1, int b = 2}) {
  return a + b;
}

//可选参数 需要记住的是可选参数与命名参数只能二选一
//上面命名参数我们看到 如果命名参数为?则就代表可选了，但这种写法限制了命名，我们可以不限制命名，也允许可选参数
//可选被[]包裹，由于是可选，所以不提供的时候就是null，因此可选参数都是可空类型如int?
int sum3(int a, [int? b]) {
  return a + (b ?? 0);
}

//默认值参数 默认值参数也是可选的参数，如果不选就用默认值

int sum4(int a, [int b = 1]) {
  return a + b;
}

int Function() adder() {
  int sum = 1;
  return () => sum++;
}

String Function(String) append() {
  var init = '';
  return (str) {
    init += str;
    return init;
  };
}

//使用sync*和yield语法
//这种写法其实与js中的generator也很像 之所以用yield
//是为了生成数据后 可以暂停执行 然后消费者先消费
//消费者消费完数据后 会唤醒生成器的代码继续执行 以此来实现的懒加载
//在js中是通过generator.next()来实现消费和唤醒的 dart是通过for来消费生成器生成的数据，这里相当于for语法糖 带了唤醒的功能
Iterable<int> syncGenerator(int maxCount) sync* {
  int i = 0;
  while (i < maxCount) {
    yield i++;
  }
}

/// 与js一样 也是从上一个yield开始执行代码的
Iterable<int> syncGenerator2() sync* {
  yield 1;
  yield 2;
  yield 3;
}
