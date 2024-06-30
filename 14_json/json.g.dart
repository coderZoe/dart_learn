// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person2 _$Person2FromJson(Map<String, dynamic> json) => Person2(
      json['name'] as String,
      (json['age'] as num).toInt(),
    );

Map<String, dynamic> _$Person2ToJson(Person2 instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
    };
