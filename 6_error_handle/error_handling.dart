import 'dart:io';

void main() {
  try {
    var a = 100;
    print(a);
    //dart的异常可以抛出任意内容，不一定必须是exception
    throw 'a';
  } on OutOfMemoryError {
    print('oom');
  } on StdinException catch (e, s) {
    //catch的s可选，代表栈信息
    print('exception $e,stack info $s');
  } on StackOverflowError {
    rethrow;
  } finally {
    print('finally');
  }
}
