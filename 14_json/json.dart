import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'json.g.dart';

void main() {
  //在dart下，解析json有如下几种方案：
  ///1. 使用convert库下的jsonDecoder和jsonEncoder，其中jsonDecoder是将json字符串转为List或Map，
  ///   jsonEncoder是将List或Map转为json字符串
  ///   因此反序列化下想用jsonDecoder，得到map后，需自己写构造方法fromJson将map转为对象
  ///   序列化下想用jsonEncoder，需自己写toJson方法将对象转为map
  String json = '''
    {
      "name": "John",
      "age": 30
    }
    ''';
  var person = Person.fromJson(jsonDecode(json));
  print(person.name);

  print(jsonEncode(person));

  ///2. 使用json_serializable包
  ///
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(json["name"], json["age"]);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "age": age};
  }
}

@JsonSerializable()
class Person2 {
  String name;
  int age;

  Person2(this.name, this.age);

  factory Person2.fromJson(Map<String, dynamic> json) =>
      _$Person2FromJson(json);

  Map<String, dynamic> toJson() => _$Person2ToJson(this);
}
