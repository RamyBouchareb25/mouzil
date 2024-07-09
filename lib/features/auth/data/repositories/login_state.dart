import 'package:tomboula/features/auth/data/models/user.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  final bool isNew;

  const LoginInitial({this.isNew = true});
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  const LoginLoading();

  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final User user;
  final String token;
  const LoginSuccess({required this.user, required this.token});

  @override
  List<Object?> get props => [];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
