void main() {
  var person1 = Person1('Tom');
  var person2 = Person2();
  var person3 = Person3.init('Tom');
  const person4 = Person4('Tom');
  var person5 = Person5.init('Tom');
  var person6_1 = Person6.fromJson({'name': 'Tom', 'age': 12});
  var person6_2 = Person6.cache('Tom', 12);
}

///dart下的构造函数还是挺复杂的
///1. 生成构造函数
class Person1 {
  String name;
  Person1(this.name);
}

///2. 默认构造函数 在不指定构造函数的时候 dart会自动生成构造函数 无参数 无命名
class Person2 {
  String? name;
}

///3. 命名构造函数
class Person3 {
  String name;

  //需要构造函数初始化列表，这里看dart设计还是挺乱的，可能主要是由于空安全保证，所以加了这个东西
  Person3.init(String name) : name = name;
}

///4. 常量构造函数  用于生成不变对象 需要所有实例都是final
class Person4 {
  final String name;
  const Person4(this.name);
}

///5. 重定向构造函数  用于构造函数调构造函数
class Person5 {
  String name;
  int age;
  Person5(this.name, this.age);

  Person5.init(String name) : this(name, 0);
}

///6. 工厂构造函数  前面的构造函数是直接返回实例，这是由dart支持的，工厂构造函数其实就是个普通函数。需要自己返回构造好的对象
///工厂方法中不能使用this
class Person6 {
  String name;
  int age;

  Person6(this.name, this.age);

  factory Person6.fromJson(Map<String, dynamic> map) {
    return Person6(map['name'], map['age']);
  }

  //dart是单线程的，不考虑线程安全问题
  static final Map<String, Person6> _cache = <String, Person6>{};

  factory Person6.cache(String name, int age) {
    return _cache.putIfAbsent(name, () => Person6(name, age));
  }
}
