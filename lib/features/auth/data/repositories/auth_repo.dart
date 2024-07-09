import 'package:tomboula/features/auth/data/models/user.dart';
import 'package:tomboula/features/auth/providers/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final AuthService _authService;
  AuthRepository(this._authService);

  Future<String> signInWithUsernamePassword(String username, String password) async {
    return await _authService.signInWithUsernamePassword(username, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<String> signUpWithCredentials(credentials) async {
    return await _authService.signUpWithCredentials(credentials);
  }

  Future<bool> editProfile(User user, String token) async {
    return await _authService.editProfile(user, token);
  }

  Future<String?> resetPassword(String oldPassword, String newPassword) async {
    return await _authService.resetPassword(oldPassword, newPassword);
  }
}

final authRepositoryProvider =
    Provider((ref) => AuthRepository(ref.read(authServiceProvider)));
