void main() {
  var tom = Person('Tom');
  tom.eatIt();
  print(tom is Eat); //true

  Plane().mixinFly();

  var adder = new Adder();
  print(adder.add());

  var phone = Phone();
  print(phone.add());
}

///dart的mixin很灵活，类似于组合，让一个已有的类具备某个mixin的功能
///mixin类似于一组函数功能，它可以具有属性，但不能有构造函数，也不能继承普通类
//但mixin中的属性往往是mixin自己用的，尽量不要将mixin的属性暴漏给继承者用
//mixin最初的设想就是一组具备已经实现/未实现功能的函数集合，有些类似于Java下的interface
//Java Interface 通过default也可以实现默认函数
mixin Eat {
  void eatIt() {
    print('I am $name and I am eating');
  }

  //mixin可以有构造方法 这个构造方法由子类实现
  String get name;
}

class Person with Eat {
  String name;
  Person(this.name);
}

///mixin可以implements一个接口，其实真的与Java interface差不多
class Bird {
  void fly() {
    print('bird flying');
  }
}

mixin FlyThing implements Bird {
  void mixinFly() {
    print('mixin fly');
    this.fly();
  }
}

class Plane with FlyThing {
  @override
  void fly() {
    print('plane flying ');
  }
}

///on与implements不同,implements用于让mixin可以获得更多功能
///on用于使mixin限制 能混入mixin的得是什么类似，比如：
///下面这个mixin就要求，想混入mixin比如这个类得是Bird类或其子类
mixin FlyThing2 on Bird {}

///必须j继承Bird才能mixin FlyThing2
class Plane2 extends Bird with FlyThing2 {}

///同样 mixin的on不仅可以用在class上 还可以用在mixin本身上
mixin Play on FlyThing {
  void play() {
    print('play it');
  }
}

/// mixin也可以扩展自mixin
mixin Play2 implements FlyThing {}

///我们不必特别强调mixin，其实就可以将其当作一个最好没有属性的抽象类，可以继承别的接口
///唯一比较特殊的是on，mixin限制了可以with的子类

///mixin class是mixin + class 既可以作为mixin 也可以作为class
///但对mixin的限制也会限制mixin class:1. 不能有构造方法 2. 不能extends或者with别的mixin 3. 不能使用on 因为class不能用on
/// 上面那么多限制，导致mixin class的使用场景比较窄，一般就是无状态类或不依赖于外界注入的类可以声明为mixin class

mixin class Adder {
  int _count = 0;

  int add() {
    return ++_count;
  }
}

class Phone with Adder {}
