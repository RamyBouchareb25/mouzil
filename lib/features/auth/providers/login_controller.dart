import 'package:tomboula/features/auth/data/models/credentials.dart';
import 'package:tomboula/features/auth/data/models/user.dart';
import 'package:tomboula/features/auth/data/repositories/auth_repo.dart';
import 'package:tomboula/features/auth/data/repositories/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends StateNotifier<LoginState> {
  final Ref _ref;
  LoginController(this._ref) : super(const LoginInitial()) {
    _checkToken();
  }

  void notNew() {
    state = const LoginInitial(isNew: false);
  }

  Future<void> signInWithUsernamePassword(
      {required String username, required String password}) async {
    state = const LoginLoading();
    try {
      await _ref
          .read(authRepositoryProvider)
          .signInWithUsernamePassword(username, password);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      state = LoginSuccess(user: User.fromJson(decodedToken), token: token);
    } catch (e) {
      state = LoginFailure(e.toString());
    }
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      state = LoginSuccess(user: User.fromJson(decodedToken), token: token);
    }
  }

  Future<void> signOut() async {
    state = const LoginLoading();
    await _ref.read(authRepositoryProvider).signOut();
    state = const LoginInitial();
  }

  Future<void> signUpWithCredentials({required Credentials credentials}) async {
    state = const LoginLoading();
    try {
      await _ref
          .read(authRepositoryProvider)
          .signUpWithCredentials(credentials);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      state = LoginSuccess(user: User.fromJson(decodedToken), token: token);
    } catch (e) {
      state = LoginFailure(e.toString());
    }
  }

  Future<bool> editProfile(User user) async {
    try {
      var success = await _ref
          .read(authRepositoryProvider)
          .editProfile(user, (state as LoginSuccess).token);
      if (success) {
        state = LoginSuccess(user: user, token: (state as LoginSuccess).token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool isAdmin() {
    return (state as LoginSuccess).user.role == 'ADMIN';
  }

  Future<Map<String, dynamic>> resetPassword(
      String oldPassword, String newPassword) async {
    try {
      var success = await _ref
          .read(authRepositoryProvider)
          .resetPassword(oldPassword, newPassword);
      return {
        'success': true,
        'message': success!,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
        (ref) => LoginController(ref));
