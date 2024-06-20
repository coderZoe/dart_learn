void main() {
  var student = Student("三年级");

  print(caseIt(student));

  //dart中的when关键字 主要是在if case和switch 后可以跟when，比如
  if (student case Person _ when student.grade.length > 1) {
    print('if case ');
  }
  checkTypeNew([1, 2]);

  //switch下的when
  switch (student) {
    case User(:var pwd) when pwd.length > 1:
      print('user and pwd.length >1');
    case Student(:var grade) when grade.length > 1:
      print('student and grade.length >1');
  }

  //可以看到 when的使用场景比较有限，基本就是switch或者if case的条件判断下做进一步的判断 与&&作用基本相似
}

//dart中的sealed关键字是用于密封类，密封类的主要作用是声明当前类只能在当前库文件被扩展，不能被外界扩展
//由于这个特性带来的好处是：
//switch判断子类型的时候可以知道所有的实现类，可以枚举全
sealed class Person {}

class User implements Person {
  String pwd;

  User(this.pwd);
}

class Student implements Person {
  String grade;
  Student(this.grade);
}

String caseIt(Person person) {
  return switch (person) { Student __ => 'student', User _ => 'user' };
}

void checkTypeNew(dynamic value) {
  if (value case [int x, int y] when x > 0 && y > 0) {
    print('checkNewType');
  }
}
