import 'dart:async';
import 'dart:isolate';

///dart的异步思想和golang有些像：通过通信来共享内存而非通过共享内存来通信
///对于dart，isolate其实就像Actor模型下的actor，不同的isolate想交换数据，需要借助通信
///要想实现两个isolate间发送消息需要借助SendPort和ReceivePort
///其中ReceivePort你可以理解为是一个服务端，每个isolate可以自己建一个ReceivePort。用于接收别人给自己发的消息
///创建ReceivePort的时候，会同时创建一个SendPort。SendPort可以理解为客户端，通过这个客户端能实现与服务端的通信
///因此我们往往需要在创建完ReceivePort后将ReceivePort内的SendPort发给别的isolate，让人家持有你的SendPort方便与你的ReceivePort通信
///
///一个正常的构建两个isolate双向通信的流程如下：
///1. 主isolate创建ReceivePort
///2. 主isolate通过Isolate.spawn()创建另一个isolate
///3. 将主isolate的ReceivePort内的SendPort交给新建的isolate，方便新建的isolate能发消息给主isolate
///4. 新建的isolate执行的时候，创建自己的ReceivePort
///5. 新建isolate将自己的ReceivePort内的SendPort传给主isolate 方便主isolate与新建的isolate通信
void main() {
  //Isolate.run 可以迅速启动一个isolate来执行一个方法 执行完成后这个isolate就关闭了
  //但很多时候我们可能需要频繁的异步执行一些相同的代码，如果每次执行都开一个isolate，又频繁的开，会带来性能损耗
  //一种合理的方案是：创建一个不销毁的isolate，然后通过receivePort和sendPort来和这个isolate通信
  //这就像java下的线程思想，如果只是运行一些临时的方法，可以new Thread一个线程来执行，跑完这个Thread就销毁了
  //但如果频繁需要异步运行这个方法，频繁的线程创建和销毁开销有些大，这时候就需要考虑使用线程池，创建一些不会销毁的线程，随时提交一些任务给这些线程
  Worker worker = MyJsonParseWorker();
  worker.spawn();
  worker.send('{name: tom}');
}

///通过work可以新建一个isolate并与新建的这个isolate通信
abstract class Worker {
  //创建新isolate
  Future<void> spawn();

  //与新isolate通信
  Future<void> send(String message);
}

///假设当前新建的isolate用于json解析，main发字符串给新isolate，新isolate返回解析后的Map给main
class MyJsonParseWorker implements Worker {
  ///对端的sendPort 用于给对端发消息
  late SendPort _sendPort;

  ///一个状态 类似于Java下的CountDownLatch 主要用于阻塞发送前 对端isolate已经将sendPort发过来
  final Completer<void> _isolateReady = Completer.sync();
  @override
  Future<void> spawn() async {
    //如上所属，先新建一个主的ReceivePort
    var receivePort = ReceivePort();
    //通过ReceivePort监听返回给他的消息
    receivePort.listen(_handleResponsesFromIsolate);

    //开启一个isolate 并将自己的sendPort给人家
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      //取消阻塞
      _isolateReady.complete();
    } else if (message is Map<String, dynamic>) {
      print(message);
    }
  }

  // 新isolate启动时候执行的代码
  //这里必须得是static 至于为啥 我现在也没理解
  static void _startRemoteIsolate(SendPort port) {
    //建立自己的ReceivePort
    final receivePort = ReceivePort();
    //将自己的sendPort发给main
    port.send(receivePort.sendPort);

    //监听别人给自己发的消息，我们这个isolate是负责解析json的
    receivePort.listen((dynamic message) async {
      if (message is String) {
        //假设解析完了json
        port.send(<String, String>{'hello': 'world'});
      }
    });
  }

  //给新建的isolate发消息
  @override
  Future<void> send(String message) async {
    await _isolateReady.future;
    _sendPort.send(message);
  }
}
