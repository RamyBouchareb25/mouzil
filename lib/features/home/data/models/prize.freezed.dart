// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prize.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Prize _$PrizeFromJson(Map<String, dynamic> json) {
  return _Prize.fromJson(json);
}

/// @nodoc
mixin _$Prize {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  int get coefficient => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrizeCopyWith<Prize> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrizeCopyWith<$Res> {
  factory $PrizeCopyWith(Prize value, $Res Function(Prize) then) =
      _$PrizeCopyWithImpl<$Res, Prize>;
  @useResult
  $Res call({String id, String name, String image, int coefficient});
}

/// @nodoc
class _$PrizeCopyWithImpl<$Res, $Val extends Prize>
    implements $PrizeCopyWith<$Res> {
  _$PrizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? image = null,
    Object? coefficient = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      coefficient: null == coefficient
          ? _value.coefficient
          : coefficient // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrizeImplCopyWith<$Res> implements $PrizeCopyWith<$Res> {
  factory _$$PrizeImplCopyWith(
          _$PrizeImpl value, $Res Function(_$PrizeImpl) then) =
      __$$PrizeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String image, int coefficient});
}

/// @nodoc
class __$$PrizeImplCopyWithImpl<$Res>
    extends _$PrizeCopyWithImpl<$Res, _$PrizeImpl>
    implements _$$PrizeImplCopyWith<$Res> {
  __$$PrizeImplCopyWithImpl(
      _$PrizeImpl _value, $Res Function(_$PrizeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? image = null,
    Object? coefficient = null,
  }) {
    return _then(_$PrizeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      coefficient: null == coefficient
          ? _value.coefficient
          : coefficient // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrizeImpl with DiagnosticableTreeMixin implements _Prize {
  const _$PrizeImpl(
      {required this.id,
      required this.name,
      required this.image,
      required this.coefficient});

  factory _$PrizeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrizeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String image;
  @override
  final int coefficient;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Prize(id: $id, name: $name, image: $image, coefficient: $coefficient)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Prize'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('image', image))
      ..add(DiagnosticsProperty('coefficient', coefficient));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrizeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.coefficient, coefficient) ||
                other.coefficient == coefficient));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, image, coefficient);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrizeImplCopyWith<_$PrizeImpl> get copyWith =>
      __$$PrizeImplCopyWithImpl<_$PrizeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrizeImplToJson(
      this,
    );
  }
}

abstract class _Prize implements Prize {
  const factory _Prize(
      {required final String id,
      required final String name,
      required final String image,
      required final int coefficient}) = _$PrizeImpl;

  factory _Prize.fromJson(Map<String, dynamic> json) = _$PrizeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get image;
  @override
  int get coefficient;
  @override
  @JsonKey(ignore: true)
  _$$PrizeImplCopyWith<_$PrizeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
