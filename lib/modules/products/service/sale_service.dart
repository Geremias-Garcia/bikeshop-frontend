import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/sale_model.dart';

class SaleService {
  final String baseUrl = 'http://192.168.1.5:8080/saidas';

  Future<List<Sale>> getSales() async {
    final response = await http.get(Uri.parse(baseUrl));

    final List data = jsonDecode(response.body);
    return data.map((e) => Sale.fromJson(e)).toList();
  }

  Future<void> createSale(Sale sale) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sale.toJson()),
    );
  }
}
