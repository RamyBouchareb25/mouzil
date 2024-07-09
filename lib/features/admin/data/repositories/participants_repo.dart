import 'dart:convert';

import 'package:http/http.dart';
import 'package:tomboula/features/admin/data/models/participants.dart';

class ParticipantsRepo {

  Future<List<Participant>> fetchParticipants({required String token}) async {
    final url = Uri.parse('https://tombola-app-delta.vercel.app/participants/all-participants');
    final response = await get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15), onTimeout: () {
      throw Exception('Connection timeout');
    });
    if (response.statusCode == 200) {
      final List<dynamic> participantsJson = jsonDecode(response.body);
      return participantsJson.map((e) => Participant.fromJson(e)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
