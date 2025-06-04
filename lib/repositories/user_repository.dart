import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nineti_gmbh_assignment/models/post_model.dart';
import 'package:nineti_gmbh_assignment/models/todo_model.dart';
import 'package:nineti_gmbh_assignment/models/user_model.dart';

class UserRepository {
  final baseUrl = 'https://dummyjson.com';

  Future<List<User>> fetchUsers({int limit = 10, int skip = 0, String? search}) async {
    final url = search != null && search.isNotEmpty
        ? Uri.parse('$baseUrl/users/search?q=$search&limit=$limit&skip=$skip')
        : Uri.parse('$baseUrl/users?limit=$limit&skip=$skip');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<User>.from(data['users'].map((u) => User.fromJson(u)));
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Post>> fetchPosts(int userId) async {
    final url = Uri.parse('$baseUrl/posts/user/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Post>.from(data['posts'].map((p) => Post.fromJson(p)));
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Todo>> fetchTodos(int userId) async {
    final url = Uri.parse('$baseUrl/todos/user/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Todo>.from(data['todos'].map((t) => Todo.fromJson(t)));
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
