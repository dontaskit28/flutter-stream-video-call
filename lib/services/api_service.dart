import 'dart:convert';

import 'package:flutter_stream_video_call/utils/constansts.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> getUserToken({
    required String userId,
    required String name,
    String role = 'admin',
  }) async {
    final url = Uri.parse('$apiUrl/createUser');
    Map<String, dynamic> body = {
      'userId': userId,
      'name': name,
      'role': role,
    };
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final response = await http.post(
      headers: headers,
      url,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to get user token');
    }
  }
}
