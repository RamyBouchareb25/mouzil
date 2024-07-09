import 'dart:convert';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomboula/features/home/data/models/prize.dart';

class CadeauxRepo {
  Future<bool> addPrize(
      {required String name,
      required int coefficient,
      required XFile image,
      required String token}) async {
    final httpImage = await MultipartFile.fromPath('image', image.path);
    Map<String, String> requestBody = <String, String>{
      'name': name,
      'coefficient': coefficient.toString(),
    };
    Map<String, String> headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    var uri = Uri.parse('https://tombola-app-delta.vercel.app/prizes/add-prize');
    var request = MultipartRequest('POST', uri)
      ..files.add(httpImage)
      ..headers.addAll(
          headers) //if u have headers, basic auth, token bearer... Else remove line
      ..fields.addAll(requestBody);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(respStr);
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(jsonDecode(respStr)['error']);
    }
  }

  Future<bool> updateCadeau(
      {required String id,
      required String name,
      required int coefficient,
      required String token}) async {
    Map<String, String> requestBody = <String, String>{
      'name': name,
      'coefficient': coefficient.toString(),
    };
    Map<String, String> headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    var uri = Uri.parse('https://tombola-app-delta.vercel.app/prizes/update-prize/$id');
    var request = MultipartRequest('PUT', uri)
      ..headers.addAll(
          headers) //if u have headers, basic auth, token bearer... Else remove line
      ..fields.addAll(requestBody);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(respStr);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(respStr)['error']);
    }
  }

  Future<List<Prize>> fetchCadeaux({required String token}) async {
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
      final List<dynamic> participantsJson = jsonDecode(response.body);
      return participantsJson.map((e) => Prize.fromJson(e)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
