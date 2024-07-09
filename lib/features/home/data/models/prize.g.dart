// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prize.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrizeImpl _$$PrizeImplFromJson(Map<String, dynamic> json) => _$PrizeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      coefficient: (json['coefficient'] as num).toInt(),
    );

Map<String, dynamic> _$$PrizeImplToJson(_$PrizeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'coefficient': instance.coefficient,
    };
