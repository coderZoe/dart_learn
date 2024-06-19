//dart解构 类似于js中的解构，用起来有些许区别

void main() {
  //1. record解构
  //无命名record
  var user1 = ('xiaoming', 12);
  var (name1, age1) = user1;
  print('name1:$name1, age1:$age1');

  //命名record
  var user2 = (name2: 'xiaoming', age2: 12);
  var (name2: name2_1, age2: age2_1) = user2;
  print('name2_1: $name2_1,age2_1:$age2_1');
  //或者
  var (:name2, :age2) = user2;
  print('name2: $name2,age2: $age2');

  //混合场景
  var user3 = (name3: '小明', age3: 12, '三年级');
  var (:name3, :age3, grade) = user3;
  print('name3:$name3, age3: $age3, grade: $grade');

  //2. List解构
  var names = ['小明', '李华', '王二'];
  var [nameA, nameB, nameC] = names;
  print('$nameA,$nameB,$nameC');

  //利用spread 解构部分List
  var [nameD, ...] = names;
  print(nameD);
  //忽略符
  var [nameE, _, nameF] = names;
  print('$nameE,$nameF');

  //3. Map解构
  var map1 = <String, dynamic>{
    'name': '小明',
    'age': 12,
    'grade': '三年级',
    'man': true
  };
  var {'name': map1Name, 'age': map1Age, 'grade': map1Grade} = map1;
  print('$map1Name,$map1Age,$map1Grade');

  //map也可以只解构部分属性
  //下面这段内容类似于 var map1Name2 = map1['name']
  var {'name': map1Name2} = map1;
  print(map1Name2);

  //4. 嵌套解构 List套Map
  var listMap = <Map<String, dynamic>>[
    {'name': '小明', 'age': 12, 'man': true},
    {'name': '小李', 'age': 13, 'man': false}
  ];
  var [
    {'name': listMapName1, 'age': listMapAge1},
    {'name': listMapName2, 'man': listMapMan2}
  ] = listMap;
  print('$listMapName1,$listMapAge1,$listMapName2,$listMapMan2');

  //dart对于对象的解构只能用在构造方法上
  var person = Person(name: '小明', age: 12);
  print('${person.name},${person.age}');
}

class Person {
  String name;
  int age;

  Person({required this.name, required this.age});
}
