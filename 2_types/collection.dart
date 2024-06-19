void main() {
  //list
  var list = [1, 2, 3];
  var list2 = ['Car', 'Boat', 'Plane'];
  print(list2.length);

  //set
  var set = {'hello', 'world'};
  //或者
  var set2 = <String>{'hello', 'world'};
  set2.addAll(set);
  print(set2);

  //map
  var map = {'Lee': 12, 'Tom': 13};
  print(map['Lee']);
  //或者
  var map2 = Map<String, int>();
  map2['Jerry'] = 13;

  var map3 = <String, int>{'Lee': 12, 'Tom': 13};

  //扩展运算符在集合中的使用
  var list3 = ['b', 'c', 'd'];
  var list4 = ['a', ...list3];
  print(list4);

  //集合里面写逻辑： 支持if和for表达式 这个还是便捷的，但过于灵活
  var isLee = false;
  var list5 = ['Tom', if (isLee) 'Lee'];
  print(list5);

  //for
  var list6 = [for (var i = 0; i < 10; i++) '#$i'];
  print(list6);
}
