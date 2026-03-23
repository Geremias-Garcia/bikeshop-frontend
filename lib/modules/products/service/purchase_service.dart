import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/purchase_model.dart';

class PurchaseService {
  final String baseUrl = 'http://192.168.1.5:8080/entradas';

  Future<List<Purchase>> getPurchase() async {
    final response = await http.get(Uri.parse(baseUrl));

    final List data = jsonDecode(response.body);
    return data.map((e) => Purchase.fromJson(e)).toList();
  }

  Future<void> createPurchase(Purchase purchase) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(purchase.toJson()),
    );
  }
}
