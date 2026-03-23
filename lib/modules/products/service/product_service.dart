import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

class ProductService {
  final String baseUrl = 'http://192.168.1.5:8080/produtos';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    final List data = jsonDecode(response.body);
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<void> createProduct(Product product) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
  }
}
