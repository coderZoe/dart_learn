void main() {
  Future<int>.delayed(Duration(seconds: 3), () => 12).then(
    (value) => print('future arrive $value'),
  );
  print('waiting future');

  //future的then也可以返回一个future:
  Future<int>.delayed(Duration(seconds: 5), () => 13)
      .then((value) => Future<String>.delayed(
          Duration(seconds: 5), () => value.toString() + "aa"))
      .then((value) => print(value));
}
