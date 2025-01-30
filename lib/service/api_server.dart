import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Server {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refreshToken');

    final response = await http.post(
      Uri.parse('http://192.168.0.65:3000/api/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      await _storage.delete(key: 'refreshToken');
      await _storage.delete(key: 'accessToken');
    } else {
      throw Exception('Logout failed: ${response.body}');
    }
  }

  Future<void> checkAutoLogin(
      Function onLoginSuccess, Function onLoginFailure) async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    final accessToken = await _storage.read(key: 'accessToken');

    if (refreshToken == null || accessToken == null) {
      onLoginFailure();
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.0.65:3000/api/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final newAccessToken = jsonDecode(response.body)['accessToken'];
      await _storage.write(key: 'accessToken', value: newAccessToken);
      onLoginSuccess();
    } else {
      await _storage.deleteAll();
      onLoginFailure();
    }
  }

  Future<void> addExpense(Map<String, String> body) async {
    final url = Uri.parse('http://192.168.0.65:3000/api/expenses');
    final accessToken = await _storage.read(key: 'accessToken');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(body),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add expense: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error adding expense: $error');
    }
  }
}
