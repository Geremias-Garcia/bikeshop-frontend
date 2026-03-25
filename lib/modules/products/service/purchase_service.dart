import 'package:bikeshop_front_end/core/config/api_config.dart';
import 'package:bikeshop_front_end/modules/products/service/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/purchase_model.dart';

class PurchaseService {
  final String baseUrl = '${ApiConfig.baseUrl}/entradas';

  Future<List<Purchase>> getPurchase() async {
    final response = await http.get(Uri.parse(baseUrl));
    final data = ApiService.handleResponse(response);

    return (data as List).map((e) => Purchase.fromJson(e)).toList();
  }

  Future<void> createPurchase(Purchase purchase) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(purchase.toJson()),
    );

    ApiService.handleResponse(response);
  }
}
