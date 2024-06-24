void main() {
  var personList = [Person('Tom', 12), Person('Lee', 13), Person('Jack', 10)];
  //比如要传入排序算法或元素实现Comparable接口
  personList.sort((a, b) => a.age - b.age);
  print(personList);

  //迭代器
  var iterator = Person3Iterable();
  for (var item in iterator) {
    print(item);
  }
}

///在dart中有一个比较奇怪的实现，dart本身是支持操作符重载的，
///但如果想实现元素排序，还是得实现Comparable接口，或者排序的时候传入一个compare方法
///即使你的元素实现了操作符 < 或者 >等都不行
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  bool operator <(Person other) {
    return this.age < other.age;
  }

  @override
  String toString() {
    return 'name:$name,age:$age';
  }
}

///实现Comparable接口
class Person2 implements Comparable<Person2> {
  String name;
  int age;
  Person2(this.name, this.age);

  @override
  int compareTo(Person2 other) {
    return this.age - other.age;
  }
}

///迭代器Iterator接口
class Person3 {
  String name;
  int age;
  Person3(this.name, this.age);

  @override
  String toString() {
    return 'name:$name,age:$age';
  }
}

class Person3Iterator implements Iterator<Person3> {
  //需要提供两个函数的实现 分别是current和moveNext，其中current是返回当前迭代处的元素，而moveNext是通知你移动到下一个要迭代的元素
  //一般一个迭代器内可以初始化一个集合用于迭代，我这里直接返回一个实例，通过累加器来限制迭代结束
  int _count = 0;
  Person3 _person = Person3('Tom', 12);

  @override
  Person3 get current => _person;

  @override
  bool moveNext() {
    _count++;
    if (_count > 10) {
      //到头了
      return false;
    }
    //还有
    return true;
  }
}

///实现iterable，iterable需要一个iterator
class Person3Iterable extends Iterable<Person3> {
  Person3Iterator _iterator = Person3Iterator();
  @override
  Iterator<Person3> get iterator => _iterator;
}
