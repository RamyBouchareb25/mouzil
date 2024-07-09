import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'credentials.freezed.dart';
part 'credentials.g.dart';

@freezed
class Credentials with _$Credentials {
  const factory Credentials({
    required String userName,
    required String password,
  }) = _Credentials;
  /// [Helper] A method that converts a json object to a [Credentials] instance.
  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);
}