// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Ward _$$_WardFromJson(Map<String, dynamic> json) => _$_Ward(
      name: json['name'] as String,
      type: json['type'] as String,
      slug: json['slug'] as String,
      name_with_type: json['name_with_type'] as String,
      path: json['path'] as String,
      path_with_type: json['path_with_type'] as String,
      code: json['code'] as String,
      parent_code: json['parent_code'] as String,
    );

Map<String, dynamic> _$$_WardToJson(_$_Ward instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'slug': instance.slug,
      'name_with_type': instance.name_with_type,
      'path': instance.path,
      'path_with_type': instance.path_with_type,
      'code': instance.code,
      'parent_code': instance.parent_code,
    };
