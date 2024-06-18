import 'dart:ffi';
import 'dart:io';

void main() {
  print('Hello World');
}

var name = "Tom";
var year = 2024;
var temp = 31.3;
var languages = ["C", "C#", "Go", "Dart"];
var person = {
  'name': "Lee",
  'age': 18,
  'hobby': ['eat', 'sleep']
};

bool odd(int number) {
  if (number % 2 == 0) {
    return false;
  } else {
    return true;
  }
}

void loop(int count) {
  for (int i = 0; i < count; i++) {
    print("i");
  }

  var hobbies = ["eat", "sleep", "play"];
  for (var hobby in hobbies) {
    print(hobby);
  }
}

int fib(int n) {
  if (n == 0 || n == 1) {
    return n;
  }
  return fib(n - 1) + fib(n - 2);
}

var result = fib(10);

void func() {
  var hobbies = ["eat", "sleep", "play"];
  hobbies.where((hobby) => hobby.endsWith("t")).forEach(print);
}

class Spacecraft {
  String name;
  DateTime? time;

  //这是一个getter方法
  int? get timeYear => time?.year;

  //构造函数
  Spacecraft(this.name, this.time) {}

  //这也是构造函数
  Spacecraft.noTime(String name) : this(name, null);

  void describe() {
    //这是我见过最简单的模板字符串 既没有要求是特殊的引号封装，也没有要求${}写法
    print("Spacecraft:$name");
    var time = this.time;
    if (time != null) {
      int years = DateTime.now().difference(time).inDays ~/ 365;
      print('Launched: $time ($years years ago)');
    } else {
      print("no time");
    }
  }
}

var voyager = Spacecraft('Voyager', DateTime(2000, 1, 1));

var voyager2 = Spacecraft.noTime('Voyager2');

//枚举
enum Status { INIT, SUCCESS, FAIL, DEATH }

//增强枚举
enum Os {
  Win(name: "Windows", year: 1998),
  Mac(name: "Mac", year: 1997),
  Linux(name: "Linux", year: 2002);

  final String name;
  final int year;

  const Os({required this.name, required this.year});

  bool get isWin => this == Os.Win;
}

var win10 = Os.Win;

//扩展类
class Orbiter extends Spacecraft {
  double altitude;
  Orbiter(super.name, super.time, this.altitude);

  @override
  void describe() {
    print("this is Orbiter and altitude is $altitude");
    super.describe();
  }
}

mixin Piloted {
  int astronauts = 1;

  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}

//mixin-with 可以让一个类获得增强 但mixin中的成员不属于this
class PilotedCraft extends Spacecraft with Piloted {
  PilotedCraft(super.name, super.time);

  void say() {
    print(astronauts);
    describeCrew();
  }
}

//所有的类都隐式定义成了一个接口。因此，任意类都可以作为接口被实现
class MockSpaceship implements Spacecraft {
  @override
  String name;

  @override
  DateTime? time;

  @override
  void describe() {
    // TODO: implement describe
  }

  @override
  // TODO: implement timeYear
  int? get timeYear => throw UnimplementedError();

  MockSpaceship(this.name);
}

abstract class Person {
  void sayHello();
  void sayBye() {
    print("bye");
  }
}

//async await
const oneSecond = Duration(seconds: 1);

Future<void> printWithDelay(String message) {
  return Future.delayed(oneSecond).then((_) {
    print(message);
  });
}

Future<void> printWithDelayAwait(String message) async {
  await Future.delayed(oneSecond);
  print("message");
}

Future<void> createDescriptions(Iterable<String> fileNames) async {
  for (final fileName in fileNames) {
    try {
      var file = File(fileName);
      if (await file.exists()) {
        var modified = await file.lastModified();
        print(
            'File for $fileName already exists. It was modified on $modified');
      } else {
        await file.create();
        await file.writeAsString("create File $fileName");
      }
    } on IOException catch (e) {
      print("create file $fileName exception:$e");
    }
  }
}
