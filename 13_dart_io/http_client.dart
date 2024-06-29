import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

void main() async {
  var url = Uri.https('dart.dev', '/f/packages/http.json');
  //请求并返回响应体，这里read会直接将http 响应body读取出来
  var response = await http.read(url);
  print(response);
  //如果想获得完整的http响应，需要使用get
  var response2 = await http.get(url);
  if (response2.statusCode == 200) {
    print(response2.headers['content-type']);

    //get请求可以传入Header信息：
    var response3 = await http.get(url, headers: {'user-agent': 'my-app/1.0'});
    if (response3.statusCode == 200) {
      print(response3.body);
    }
  }

  //使用http client发送连续请求，长连接
  var client = http.Client();
  try {
    var response = client.read(url);
    print(response);
  } finally {
    client.close();
  }

  //包含重试的http client
  //RetryClient的构造函数包含一些重试策略 详情可以参考RetryClient的注释
  var retryClient = RetryClient(http.Client());
  try {
    var response = await retryClient.read(url);
    print(response);
  } finally {
    retryClient.close();
  }

  //对返回的结构进行json反序列化解析，在dart中json总是需要用map做中转
  //如json转对象需要先将json字符串转map，再将map转对象
  //对象转json需要先将对象转map，再将map转json字符串
  var response3 = await http.read(url);
  var map = json.decode(response3) as Map<String, dynamic>;
  print(map);
  var packageInfo = PackageInfo.fromJson(map);
  print(packageInfo.name);
}

class PackageInfo {
  final String name;
  final String latestVersion;
  final String description;
  final String publisher;
  final Uri? repository;

  PackageInfo({
    required this.name,
    required this.latestVersion,
    required this.description,
    required this.publisher,
    this.repository,
  });

  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    final repository = json['repository'] as String?;

    return PackageInfo(
      name: json['name'] as String,
      latestVersion: json['latestVersion'] as String,
      description: json['description'] as String,
      publisher: json['publisher'] as String,
      repository: repository != null ? Uri.tryParse(repository) : null,
    );
  }
}

class getPackageException implements Exception {
  final String package;
  final int statusCode;
  getPackageException(this.package, this.statusCode);
}

Future<PackageInfo> getPackage(String package) async {
  var url = Uri.https('dart.dev', '/f/packages/$package.json');
  var httpResponse = await http.get(url);
  if (httpResponse.statusCode == 200) {
    var response = httpResponse.body;
    var map = json.decode(response) as Map<String, dynamic>;
    return PackageInfo.fromJson(map);
  } else {
    throw getPackageException(package, httpResponse.statusCode);
  }
}
