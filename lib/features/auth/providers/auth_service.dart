import 'dart:convert';

import 'package:tomboula/features/auth/data/models/credentials.dart';
import 'package:tomboula/features/auth/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  Future<bool> editProfile(User user, String token) async {
    final response = await http
        .put(
      Uri.parse('https://tombola-app-delta.vercel.app/auth/edit-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(user.toJson()),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception('Connection timeout');
    });
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<String> signInWithUsernamePassword(
      String username, String password) async {
    final response = await http
        .post(
      Uri.parse('https://tombola-app-delta.vercel.app/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userName': username,
        'password': password,
      }),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception('Connection timeout');
    });
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      var token = jsonDecode(response.body)['token'];
      prefs.setString('token', token);
      return token;
    }
    if (response.statusCode == 400) {
      throw Exception(jsonDecode(response.body)['error']);
    }
    throw Exception('Unknown error');
  }

  Future<void> signOut() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return;
  }

  Future<String> signUpWithCredentials(Credentials credentials) async {
    final payload = credentials.toJson();
    final response = await http
        .post(
      Uri.parse('https://tombola-app-delta.vercel.app/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception('Connection timeout');
    });
    if (response.statusCode == 201) {
      var token = jsonDecode(response.body)['token'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      return token;
    }
    if (response.statusCode == 400) {
      throw Exception(jsonDecode(response.body)['error']);
    }
    throw Exception(jsonDecode(response.body)['error']);
  }

  Future<String?> resetPassword(String userName, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')!;
    final response = await http
        .put(
      Uri.parse('https://tombola-app-delta.vercel.app/auth/reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode({
        'userName': userName,
        'newPassword': newPassword,
      }),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception('Connection timeout');
    });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}

final authServiceProvider = Provider((ref) => AuthService());
