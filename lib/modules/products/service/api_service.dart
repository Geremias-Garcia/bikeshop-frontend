import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static dynamic handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['erro'] ?? 'Erro na API');
    }
  }
}
