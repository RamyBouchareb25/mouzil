import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:tomboula/features/home/data/models/prize.dart';

part 'participants.freezed.dart';
part 'participants.g.dart';

@freezed
class Participant
    with _$Participant {
  const factory Participant({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime date,
    required Prize prize,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
}