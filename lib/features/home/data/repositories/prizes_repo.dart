import 'dart:convert';

import 'package:http/http.dart';
import 'package:tomboula/features/home/data/models/prize.dart';

class PrizesRepo {

  Future<List<Prize>> fetchPrizes({required String token}) async {
    final url = Uri.parse('https://tombola-app-delta.vercel.app/prizes/all-prizes');
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
      final List<dynamic> prizesJson = jsonDecode(response.body);
      return prizesJson.map((e) => Prize.fromJson(e)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  // Future<bool> addParticipant(
  //     {required Participant participant, required String token}) async {
  //   final response = await post(
  //     Uri.parse('$https://tombola-app-delta.vercel.app/participants/add-participant'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(participant.toJson()),
  //   ).timeout(const Duration(seconds: 5), onTimeout: () {
  //     throw Exception('Connection timeout');
  //   });
  //   if (response.statusCode == 201) {
  //     return true;
  //   } else {
  //     throw Exception(jsonDecode(response.body)['error']);
  //   }
  // }
}
