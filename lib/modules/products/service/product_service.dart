import 'package:bikeshop_front_end/core/config/api_config.dart';
import 'package:bikeshop_front_end/modules/products/service/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

class ProductService {
  final String baseUrl = '${ApiConfig.baseUrl}/produtos';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    final data = ApiService.handleResponse(response);

    return (data as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<void> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    ApiService.handleResponse(response);
  }
}
