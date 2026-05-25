import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // =========================
  // LOGIN
  // =========================

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),

        headers: {
          'Content-Type': 'application/json',

          'Accept': 'application/json',
        },

        body: jsonEncode({'email': email, 'password': password}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['token']);

        return true;
      }

      return false;
    } catch (e) {
      print(e);

      return false;
    }
  }

  // =========================
  // GET TOKEN
  // =========================

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  // =========================
  // LOGOUT
  // =========================

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
  }
}
