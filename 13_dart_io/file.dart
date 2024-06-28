import 'dart:convert';
import 'dart:io';

void main() async {
  //文件操作
  var file = File('${Directory.current.path}\\13_dart_io\\a.txt');
  //将内容一次读取到内存 作为字符串
  var content = await file.readAsString();
  print(content);

  print('=======================');

  //返回的是List<String>也是一下全读到内存，但是是一行行的
  var contentList = await file.readAsLines();
  contentList.forEach(print);

  print('======================');
  //读取字节流
  var bytes = await file.readAsBytes();
  print('bytes length ${bytes.length}');

  //流式读取
  var bytesStream = file.openRead();

  //将字节流转为字符流
  var strStream =
      utf8.decoder.bind(bytesStream).transform(const LineSplitter());

  print('======================');
  //通过await for打印字符流
  await for (var line in strStream) {
    print(line);
  }

  //文件写入
  var writeFile = File('${Directory.current.path}\\13_dart_io\\a_write.txt');
  var sink = writeFile.openWrite();
  //write是写字符串
  sink.write('Hello here is a file write by dark\n');
  await sink.flush();
  await sink.close();

  //尾追加的形式写入
  sink = writeFile.openWrite(mode: FileMode.append);
  //add是写字节
  sink.add(utf8.encode('append some'));
  await sink.flush();
  await sink.close();

  //列出目录下的所有内容：
  // Directory('D:\\my-project\\dart\\dart_learn');
  var current = Directory.current;
  var subList = current.list();
  await for (var fileOrDir in subList) {
    if (fileOrDir is File) {
      print('file ${fileOrDir.path}');
    } else if (fileOrDir is Directory) {
      print('dir ${fileOrDir.path}');
    }
  }
}

/**
 * file and dir
 * 读取文件有两种方法：一次性全读到内存中或者流式读取
 */
