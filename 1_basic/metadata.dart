void main() {
  var tom = Person("Tom", 12);
  tom.sayHello();
  tom.sayHi();
}

class Person {
  String name;
  int age;
  Person(this.name, this.age);

  @Deprecated("use sayHi")
  void sayHello() {
    print("hello $name");
  }

  @MyMeta("test", "test my meta date")
  void sayHi() {
    print("Hi $name");
  }
}

//dart的注解很简洁 一个class就可以作为注解
class MyMeta {
  final String who;
  final String what;

  const MyMeta(this.who, this.what);
}
