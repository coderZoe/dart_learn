import 'dart:io';

void main() async {
  Future<int>.delayed(Duration(seconds: 3), () => 12).then(
    (value) => print('future arrive $value'),
  );
  print('waiting future');

  //future的then也可以返回一个future:
  Future<int>.delayed(Duration(seconds: 5), () => 13)
      .then((value) => Future<String>.delayed(
          Duration(seconds: 5), () => value.toString() + "aa"))
      .then((value) => print(value));

  //future支持类似于try catch finally这种写法
  Future<int>.delayed(Duration(seconds: 2), () => 10)
      .then((value) => print('then $value'))
      .catchError((error) => print('error $error'))
      .whenComplete(() => print('complete'));

  //单一类型和迭代器和关系就是future和stream的关系，即int与Iterator<int>的关系就是future<int>与Stream<int>的关系
  //注：dart下没有byte，因此读取文件返回的不是byte[]，而是int[]
  await for (var str in File('D:/a.txt').openRead()) {
    print(String.fromCharCodes(str));
  }

  //stream可以通过listen监听，通过listener监听，我们很容易看到Stream和Future的关系，都是存在：失败如何处理，成功如何处理，完成如何处理等
  var stream = StreamGenerator();
  var subscription = stream.listen((value) => print('stream $value'),
      //失败的响应处理
      onError: (err) => print(err),
      //整个stream消费完的处理
      onDone: () => print('done'),
      //失败后是否取消消费
      cancelOnError: false);

  //监听器的返回结果也有很多用处：
  subscription.pause();
  subscription.resume();
  subscription.cancel();

  //stream的api非常丰富，基本上iterator提供的api它都提供了：
  StreamGenerator()
      .where((p) => p % 2 == 0)
      .map((p) => 'String $p')
      .listen(print);
}

Stream<int> StreamGenerator() async* {
  for (int i = 0; i < 10; i++) {
    yield i;
  }
}
