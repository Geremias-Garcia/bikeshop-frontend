import 'package:bikeshop_front_end/core/config/api_config.dart';
import 'package:bikeshop_front_end/modules/products/service/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class UserService {
  final String baseUrl = '${ApiConfig.baseUrl}/usuarios';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    final data = ApiService.handleResponse(response);

    return (data as List).map((e) => User.fromJson(e)).toList();
  }

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    ApiService.handleResponse(response);
  }

  Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    ApiService.handleResponse(response);
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    ApiService.handleResponse(response);
  }
}
