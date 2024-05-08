import 'dart:convert';
import 'package:app/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DatabaseServices {
  String backendUrl = 'http://192.168.1.4:3000';

  Future<http.Response> postData(String url, String token, Map body) async {
    String jsonBody = jsonEncode(body);

    final response = await http.post(
      Uri.parse('$backendUrl/$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': token
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

  Future<http.Response> getData(String url) async {
    var token = await PreferencesService().getString('token');

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$token',
      },
    );

    print('getData called for URL: $url at ${DateTime.now()}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 404) {
      return http.Response('Resource not found', 404);
    } else if (response.statusCode == 401) {
      print('Received 401 Unauthorized response');
      return http.Response('Not authorized', 401);
    } else {
      print('Failed to get data. Status Code: ${response.statusCode}, '
          'Response Body: ${response.body}');
      throw Exception(
          'Failed to get data. Status Code: ${response.statusCode}, '
          'Response Body: ${response.body}');
    }
  }
}
