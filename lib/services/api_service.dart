import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/todo_model.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/todos';

  // =========================
  // GET TODOS
  // =========================

  static Future<List<Todo>> getTodos() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse(baseUrl),

        headers: {
          'Authorization': 'Bearer $token',

          'Accept': 'application/json',

          'Content-Type': 'application/json',
        },
      );

      print('GET TODOS STATUS');
      print(response.statusCode);

      print('GET TODOS BODY');
      print(response.body);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        return data.map((e) => Todo.fromJson(e)).toList();
      }

      throw Exception('Failed to load todos');
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  // =========================
  // ADD TODO
  // =========================

  static Future<void> addTodo(String title) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse(baseUrl),

        headers: {
          'Authorization': 'Bearer $token',

          'Accept': 'application/json',

          'Content-Type': 'application/json',
        },

        body: jsonEncode({'title': title, 'completed': false}),
      );

      print('ADD TODO STATUS');
      print(response.statusCode);

      print('ADD TODO BODY');
      print(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add todo');
      }
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  // =========================
  // DELETE TODO
  // =========================

  static Future<void> deleteTodo(int id) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),

        headers: {
          'Authorization': 'Bearer $token',

          'Accept': 'application/json',

          'Content-Type': 'application/json',
        },
      );

      print('DELETE TODO STATUS');
      print(response.statusCode);

      print('DELETE TODO BODY');
      print(response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  // =========================
  // UPDATE TODO STATUS
  // =========================

  static Future<void> updateTodoStatus(int id, bool completed) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),

        headers: {
          'Authorization': 'Bearer $token',

          'Accept': 'application/json',

          'Content-Type': 'application/json',
        },

        body: jsonEncode({'completed': completed}),
      );

      print('UPDATE TODO STATUS');
      print(response.statusCode);

      print('UPDATE TODO BODY');
      print(response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to update todo');
      }
    } catch (e) {
      print(e);

      rethrow;
    }
  }
}
