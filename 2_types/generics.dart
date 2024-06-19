void main() {
  //dart的泛型是reified，不像Java会泛型擦除，如:
  var list1 = <String>['Tom', 'Jerry'];
  //在Java中 只能判断list1是不是List
  print(list1 is List<String>);
}
