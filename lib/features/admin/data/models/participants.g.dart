// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantImpl _$$ParticipantImplFromJson(Map<String, dynamic> json) =>
    _$ParticipantImpl(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      date: DateTime.parse(json['date'] as String),
      prize: Prize.fromJson(json['prize'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ParticipantImplToJson(_$ParticipantImpl instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'date': instance.date.toIso8601String(),
      'prize': instance.prize,
    };
