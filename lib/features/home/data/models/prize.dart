import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prize.freezed.dart';
part 'prize.g.dart';

@freezed
class Prize with _$Prize {
  const factory Prize({
    required String id,
    required String name,
    required String image,
    required int coefficient,
  }) = _Prize;

  factory Prize.fromJson(Map<String, dynamic> json) => _$PrizeFromJson(json);
}