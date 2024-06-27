void main() {
  var person1 = Person1('Tom');
  var person2 = Person2();
  var person3 = Person3.init('Tom');
  const person4 = Person4('Tom');
  var person5 = Person5.init('Tom');
  var person6_1 = Person6.fromJson({'name': 'Tom', 'age': 12});
  var person6_2 = Person6.cache('Tom', 12);

  var map = <String, String>{};
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

///在dart中构造方法有如下几处不能使用this:
///1. 工厂构造方法内不能使用this 工厂构造函数也不能用初始化列表，
///我们将工厂构造函数理解一个工厂class内的一个单独的创建当前对象的普通的函数就好
///想象我们现在有一个Person class，那么这个PersonClass的factory我们理解有一个单独的PersonFactory class
///里面有一个create方法即可，想一下你可以在PersonFactory的create里使用this指向Person吗？显然不可以。

///官网对于使用工厂函数的场景是：
/// a. 构造函数并不总是创建其类的新实例。
/// b. 在构造实例之前，您需要执行一些重要的工作。这可能包括检查参数或执行初始化器列表中无法处理的任何其他处理

///2. 初始化列表的右侧(初始化列表表达式是 : this.x = x这种，初始化列表右侧不能用this是指
///不能出现 :this.x = this.y+1 这种)
///3. 父类构造函数的参数 解释下这里：
// class Person {
//   String name;
//   Person(this.name);
// }
// class Tom extends Person {
//   int age;
//   Tom(this.age, super.name);
// }

///如上，Tom的构造函数Tom(this.age, super.name)，这里只能用super.name不能用this.name;

class Person7 {
  String name;
  int age;
  Person7.init({required String name, required int age})
      : this.name = name,
        this.age = age {
    this.age = 12;
    print('hello person7');
  }
}

///dart中的初始化列表设计的挺割裂的，它的主要作用是实例赋值，我觉得这一主要原因是dart的空安全检查问题，比如：
// class Person {
//   String name;
//   int age;

//   Person(String name, int age) {
//     this.name = name;
//     this.age = age;
//   }
// }
/// 如上代码会编译不过，除非你将name和age设为late或者设为可空?。我觉得这是dart空安全检查偷懒导致的，dart似乎只检查了入参和初始化列表
/// 并不检查构造方法体 因此上述构造方法必须写成
// class Person {
//   String name;
//   int age;

//   Person(this.name, this.age);
// }
/// 如上那样
/// 但很明显，上面那种写法有些死板，不够灵活，因此就有了初始化列表
// class Person {
//   String name;
//   int age;

//   Person(String name, int age)
//       : this.name = name + 'Person',
//         this.age = age + 1;
// }

///在初始化列表中我们可以单独使用表达式来赋值属性

///我们也可以这样理解：dart的空安全检查不会检查构造函数体，
///而是使用了一个叫初始化列表的东西让你单独来对属性赋值，这样它只需要检查初始化列表的内容就可以了
///但初始化列表写起来有时繁琐，因此又加进了语法糖：Person(this.name, this.age)
///换言之，dart的实例初始化不是在构造方法内初始化的，而是通过初始化列表初始化的
///注：对于dart的空安全和和初始化列表可以参见文章：https://dart.dev/null-safety/understanding-null-safety#uninitialized-variables
///对于dart来说，非空字段必须在声明时初始化，或在构造函数的初始化列表中初始化，换句话说，只要字段在进入构造函数主体之前有一个值，就可以了

///在dart中 构造函数不会被继承，其他语言其实也是，如Java
class Person8 {
  String name;
  int age;
  Person8(this.name, this.age);
}

//必须也得构造方法来初始化name和age，因为不会继承父类的构造方法
class Tom extends Person8 {
  Tom(String name, int age) : super(name, age);
}
