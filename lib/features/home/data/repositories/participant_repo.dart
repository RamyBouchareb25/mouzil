import 'dart:convert';

import 'package:tomboula/features/home/data/models/participant.dart';
import 'package:http/http.dart' show post, get, MultipartRequest;

class ParticipantRepo {

  Future<bool> isParticipantRegistered(
      {required String phone, required String token}) async {
    final response = await get(
      Uri.parse('https://tombola-app-delta.vercel.app/participants/check-participant/$phone'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception('Connection timeout');
    });
    return response.statusCode == 200
        ? true
        : response.statusCode == 404
            ? false
            : throw Exception(jsonDecode(response.body)['error']);
  }

  Future<bool> addParticipant(
      {required Participant participant, required String token,required coefficient}) async {
    final response = await post(
      Uri.parse('https://tombola-app-delta.vercel.app/participants/add-participant'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(participant.toJson()),
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception('Connection timeout');
    });
    if (response.statusCode == 201) {
        
    Map<String, String> requestBody = <String, String>{
      'coefficient': coefficient.toString(),
    };
    Map<String, String> headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    var uri = Uri.parse('https://tombola-app-delta.vercel.app/prizes/update-prize/${participant.prizeId}');
    var request = MultipartRequest('PUT', uri)
      ..headers.addAll(
          headers) //if u have headers, basic auth, token bearer... Else remove line
      ..fields.addAll(requestBody);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(respStr)['error']);
    }
  
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
