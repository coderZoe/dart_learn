import '../0_start/main.dart';

void main() {
  var person1 = Person("Tom", 12);
  var person2 = Person("Lee", null);
  print(person1);
  print(person2);

  var even1 = person1.age?.isEven;
  print(even1); //true
  var even2 = person2.age?.isEven;
  print(even2); //null

  var student = new Student();
  student.setName("Jerry");
  student.sayHello();
}

class Person {
  String name;
  int? age;

  Person(this.name, this.age);

  @override
  String toString() {
    return 'name:$name,age:$age';
  }
}

class Student {
  late String name;
  void setName(String name) {
    this.name = name;
  }

  void sayHello() {
    print("Hello $name");
  }
}
