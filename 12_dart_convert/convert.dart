import 'dart:convert';

void main() {
  var json = '''
  [
    {"score": 40},
    {"score": 80}
  ]
''';

  var json2 = '''
{
  "Status": true,
  "Auth": true,
  "Code": "0",
  "Res": [
    {
      "instanceId": "slb-g6kvb140tzce",
      "ecsId": "ecs-j3rfcni6k4k893iu569q",
      "success": false,
      "failReason": "502 Bad Gateway: "
    },
    {
      "instanceId": "slb-kwl3dlnf20ls",
      "ecsId": "ecs-c74i26f9fp6rqh559p73",
      "success": true
    },
    {
      "instanceId": "hslb-lnc13vxf9551",
      "ecsId": "ecs-2l6is0m7j7ro6iq606a9",
      "success": false,
      "failReason": "I/O error on POST request for Read timed out; nested exception is java.net.SocketTimeoutException: Read timed out"
    },
    {
      "instanceId": "hslb-l86xqgokbho6",
      "ecsId": "ecs-zz8hbngt3c7j665fwqyw",
      "success": true
    }
  ]
}
''';

  var obj = jsonDecode(json);
  //json转成List
  print(obj.runtimeType);
  print(obj);

  //json2转成Map
  var obj2 = jsonDecode(json2);
  print(obj2.runtimeType);
  print(obj2);

  var person = Person('Tom', 12);
  var personJson = jsonEncode(person);
  print(personJson.runtimeType);
  print(personJson);
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  //对象需要实现toJSon，详情可以看jsonEncode的源码(会调对象的toJson方法，不实现会报错)
  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
      };
}
