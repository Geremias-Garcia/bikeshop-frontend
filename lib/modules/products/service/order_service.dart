import 'dart:convert';
import 'package:bikeshop_front_end/core/config/api_config.dart';
import 'package:http/http.dart' as http;
import '../model/order_model.dart';

// Enum igual backend
enum FormaPagamento { PIX, CARTAO, DINHEIRO }

extension FormaPagamentoExt on FormaPagamento {
  String get value => name;

  String get label {
    switch (this) {
      case FormaPagamento.PIX:
        return 'Pix';
      case FormaPagamento.CARTAO:
        return 'Cartão';
      case FormaPagamento.DINHEIRO:
        return 'Dinheiro';
    }
  }
}

class OrderService {
  final String baseUrl = '${ApiConfig.baseUrl}/pedidos';

  dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['erro'] ?? 'Erro na API');
    }
  }

  Future<List<Order>> getOrcamentos() async {
    final response = await http.get(Uri.parse('$baseUrl/orcamentos'));
    final data = _handleResponse(response);
    return (data as List).map((e) => Order.fromJson(e)).toList();
  }

  Future<List<Order>> getVendas() async {
    final response = await http.get(Uri.parse('$baseUrl/vendas'));
    final data = _handleResponse(response);
    return (data as List).map((e) => Order.fromJson(e)).toList();
  }

  Future<List<Order>> getTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    final data = _handleResponse(response);
    return (data as List).map((e) => Order.fromJson(e)).toList();
  }

  Future<Order> criar(Order order) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );

    return Order.fromJson(_handleResponse(response));
  }

  Future<Order> criarVendaDireta(
    Order order,
    FormaPagamento formaPagamento,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/venda-direta',
    ).replace(queryParameters: {'formaPagamento': formaPagamento.value});

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );

    return Order.fromJson(_handleResponse(response));
  }

  Future<Order> aprovar(int id, FormaPagamento formaPagamento) async {
    final uri = Uri.parse(
      '$baseUrl/$id/aprovar',
    ).replace(queryParameters: {'formaPagamento': formaPagamento.value});

    final response = await http.patch(uri);

    return Order.fromJson(_handleResponse(response));
  }

  Future<Order> cancelar(int id) async {
    final response = await http.patch(Uri.parse('$baseUrl/$id/cancelar'));
    return Order.fromJson(_handleResponse(response));
  }
}
