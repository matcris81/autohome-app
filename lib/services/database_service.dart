import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseServices {
  String backendUrl = 'http://localhost:3000';

  Future<http.Response> postData(String url, String token) async {
    String jsonBody = jsonEncode(token);

    final response = await http.post(
      Uri.parse('$backendUrl/$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception(
          'Failed to post data. Status Code: ${response.statusCode}, '
          'Response Body: ${response.body}');
    }
  }
}
