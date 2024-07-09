import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

@freezed
class Participant
    with _$Participant {
  const factory Participant({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String? prizeId,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);


}