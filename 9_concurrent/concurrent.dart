import 'dart:io';
import 'dart:isolate';
import 'dart:math';

///这里需要特别解释下dart下的main，假设main的完整内容如下：
// void main(){
//   Future.delayed(Duration(seconds: 10),()=>print('hello world'));
// }
///如下main线程不会立即结束，而是会在10s后打印出hello world才结束
///这一根本原因是dart的eventLoop，在dart中，代码都需要运行在一个isolate中，而isolate可以认为是独立的线程/进程
///main函数就运行在main isolate中，当main isolate启动的时候，会先执行main代码，在main代码内我们可能会产生很多event，当main代码退出后
///isolate会处理那些可执行的event，一旦所有的event也完成，则main isolate会退出。
///上例中，我们的 Future.delayed(Duration(seconds: 10),()=>print('hello world'))其实就是产生了一个事件，这个事件会在10s后打印hello word
///因此main代码退出后，main isolate并不会退出，因为还有event没处理，等10s后，event loop发现事件可执行了，就处理事件
///事件处理完成，event loop下没可执行事件后，main isolate就会自动退出。
///因此整个isolate其实就是一个event loop线程，我们的main执行也可以认为是一个事件，只不过会是main isolate运行的最初事件，
///在main中我们处理的认为异步其实都是事件，包括future await stream等，这些我们可以理解为回调，既然是回调，就需要在某个未来时刻执行
///而这些执行的时间和真正的执行都由event loop决定。
///因此在真实的flutter开发中,main isolate往往会注册很多client事件，如监听用户点击某个按钮，监听重绘UI等，这种事件驱动其实都是异步和回调，自然也都是事件
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
  // await for (var str in File('D:/a.txt').openRead()) {
  //   print(String.fromCharCodes(str));
  // }

  //stream可以通过listen监听，通过listener监听，我们很容易看到Stream和Future的关系，都是存在：失败如何处理，成功如何处理，完成如何处理等
  var stream = StreamGenerator();
  var subscription = stream.listen((value) => print('stream $value'),
      //失败的响应处理
      onError: (err) => print(err),
      //整个stream消费完的处理
      onDone: () => print('done'),
      //失败后是否取消消费
      cancelOnError: false);
  //注：stream的listen只能注册一次，如果想多次注册需要将stream先转为broadcastStream
  // stream.asBroadcastStream().listen(print);

  //监听器的返回结果也有很多用处：
  subscription.pause();
  subscription.resume();
  subscription.cancel();

  //stream的api非常丰富，基本上iterator提供的api它都提供了：
  StreamGenerator()
      .where((p) => p % 2 == 0)
      .map((p) => 'String $p')
      .listen(print);

  ///future
  processAsync();

  ///async await
  var result = processSync();
  print('result: ${result.toString()}');

  ///生成器
  //同步
  for (var i in iterable()) {
    print('iterable $i');
  }
  for (var i in iterable2(start: 0, end: 10)) {
    print('iterable2 $i');
  }
  for (var i in iterable3(start: 0, end: 10)) {
    print('iterable3 $i');
  }

  //在一开始的注释中，我们已经讲了dart的isolate和event loop，虽然dart中的IO操作都是异步的，不会阻塞，但假设我们在main线程中存在一些耗时的cpu操作 比如解析一个大的json
  //假设我们在进行耗时cpu计算的时候，用户点击了屏幕，但我们只有一个线程，因此event loop无法响应这个点击事件
  //这时候整个event loop就会因为这个耗时操作而表现的像被阻塞了一样
  //因此并行计算(parallel)还是有必要的，我们可以单独创建一个isolate，比如叫work isolate来运行这个耗时cpu计算，这个isolate与main isolate不在一个cpu上
  //对于main isolate而言这个操作就像一个异步事件，当work isolate计算完成后，可以将结果返回给main isolate，在这期间不影响main isolate处理其他事件

  int fib(int n) => n <= 1 ? 1 : fib(n - 1) + fib(n - 2);

  var start = DateTime.now();
  print('stat $start');
  var fibResult1 = fib(50);
  var end = DateTime.now();
  print('end $end');
  print(
      'cost:${end.millisecondsSinceEpoch - start.millisecondsSinceEpoch},resule:$fibResult1');
  // var fibResult1 = await Isolate.run(() => );
  // var fibResult2 = await Isolate.run(() => fib(50));
  // var fibResult3 = await Isolate.run(() => fib(50));
  // print('fibResult1 $fibResult1');
  // print('fibResult2 $fibResult2');
  // print('fibResult3 $fibResult3');
}

Stream<int> StreamGenerator() async* {
  for (int i = 0; i < 10; i++) {
    yield i;
  }
}

class ProcessData {
  String content;
  ProcessData(this.content);
}

Future<int> getIdFromDisk() =>
    Future<int>.delayed(Duration(seconds: 2), () => 1);

Future<String> fetchFromNetwork(int id) =>
    Future.delayed(Duration(seconds: 2), () => 'someone');

Future<ProcessData> processAsync() {
  return getIdFromDisk()
      .then(fetchFromNetwork)
      .then((value) => ProcessData(value));
}

/// 上面我们使用future实现了异步编程，但异步编程的可读性很差，很多时候我们需要一种同步的写法，如：
/// var id = getIdFromDisk();
/// var str = fetchFromNetwork(id);
/// return ProcessData(str);
/// 我们更想要上面那种同步的写法，但很明显getIdFromDisk与fetchFromNetwork返回的都是future，而非future内的结果
/// 此时我们需要的是加上await关键字，当我们调用函数 返回一个future，并在future前使用await的时候，看起来就像是告诉编译器：
/// 调用返回了一个future 未开封的box，但你使用了await，那你需要在这里等一会，等这个box内的数据准备好的时候，我将把盒子内的数据返回给你，此后才可以继续执行后续代码
/// 而这里的await其实也是相当于告诉dart的eventLoop线程，我现在需要等待这个结果的返回，你去处理其他事件吧，等我的事件完成就绪后，你再继续执行
/// 相当于await的作用是告诉编译器：这里返回的是future，但我希望同步等待future返回再继续往下执行。如果不加await，那返回future代码就继续往下走了，不会同步等待。
/// 因此await翻译为等待，等待的就是future的完成，所以await正好添加到future前，非常的符合直觉。
/// 这里需要注意的是async和await只是一种语法糖，其本质还是future then这种形式
/// 虽然我们的代码写成了同步的风格，但函数的返回依然是future，不要错误的将其理解为同步返回
/// 要理解这个我们需要重新审视整个函数，函数做的内容其实是：1. 从磁盘加载id 2. 在加载完成后，使用id作为参数，从网络请求数据 3. 在网络请求返回后，使用返回数据构造ProcessData
/// 因此要返回的ProcessData其实是一个未来态，我们假设我们的函数是一个描述过程，那返回结果其实是一个对外来的描述
/// 比如：此时此刻，你说我想先考上A大学，再进入公司B，最后挣100w。那么相比此时此刻，你挣100w是未来的一个承诺。
/// 当外界函数调用你的时候，他站在此时此刻调用你，不会直接得到100w，得到的只是一个100w的承诺，对于这个承诺它怎么处理是他自己的事。
/// 看到了吗？函数的返回是一个承诺，未来时，我们的函数只是描述了这个承诺是通过怎样的一系列过程得到的。
/// 最后再解释下async，我们刚才已经解释了为什么函数的声明返回是Future<ProcessData>，而非ProcessData
/// 但我们又注意到函数体内的返回是 return ProcessData(content)，这就是async关键字起的作用，async关键字其实相当于编译器，我这个函数是异步函数
/// 因此返回的类型会自动包上Future，想象一下如果没有async，那我们函数声明是Future<ProcessData>，但函数体返回是 return ProcessData(content)，就会出现类型不匹配
///async还存在一个问题是传递性，当别的函数想调用当前函数的时候，他会得到一个Future，他也可以在future中await，假设如下：

// Future<ProcessData> func1() async{
//   var processData = await processSync();
//   return processData;
// }
///上述方法调用的时候，如果不加async也会出现函数返回和声明不一致问题，所以使用await的地方，必须告诉编译器，我这是个异步函数，因此async传递本身是异步传递
///
///既然future有then onError和whenComplete，await自然也有，对于同步代码块，他直接写成try catch finally就行了

Future<ProcessData> processSync() async {
  var id = await getIdFromDisk();
  print('getIdFromDisk finished');
  var content = await fetchFromNetwork(id);
  print('fetchFromNetwork finished');
  return ProcessData(content);
}

//简单的迭代器
Iterable<int> iterable() sync* {
  for (int i = 0; i < 10; i++) {
    yield i;
  }
}

//递归代器
Iterable<int> iterable2({required int start, required int end}) sync* {
  if (start < end) {
    yield start;
    for (final value in iterable2(start: start + 1, end: end)) {
      yield value;
    }
  }
}

//但其实上述写法，递归还可以写为：
Iterable<int> iterable3({required int start, required int end}) sync* {
  if (start < end) {
    yield start;
    //这里通过yield*返回一个迭代器
    yield* iterable3(start: start + 1, end: end);
  }
}
