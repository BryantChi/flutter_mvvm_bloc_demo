import 'dart:convert';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.github.com';

  Future<List<User>> fetchUsers({int since = 0, int perPage = 20}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users?since=$since&per_page=$perPage'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<User> users = body.map((dynamic item) => User.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> fetchUserDetail(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user detail');
    }
  }
}