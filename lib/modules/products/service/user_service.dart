import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class UserService {
  final String baseUrl = 'http://192.168.1.5:8080/usuarios';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    final List data = jsonDecode(response.body);
    return data.map((e) => User.fromJson(e)).toList();
  }

  Future<void> createUser(User user) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
  }

  Future<void> updateUser(User user) async {
    await http.put(
      Uri.parse('$baseUrl/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
  }

  Future<void> deleteUser(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
