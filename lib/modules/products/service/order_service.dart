import 'dart:convert';
import 'package:bikeshop_front_end/core/config/api_config.dart';
import 'package:bikeshop_front_end/modules/products/model/order_response.dart';
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
      final message = data is Map && data.containsKey('erro')
          ? data['erro']
          : 'Erro inesperado';

      throw Exception(message);
    }
  }

  // 🟡 ORÇAMENTO
  Future<Order> criar(Order order) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );

    return Order.fromJson(_handleResponse(response));
  }

  // 🟢 VENDA DIRETA
  Future<OrderResponse> criarVendaDireta(
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

    return OrderResponse.fromJson(_handleResponse(response));
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

  Future<OrderResponse> aprovar(int id, FormaPagamento formaPagamento) async {
    final uri = Uri.parse(
      '$baseUrl/$id/aprovar',
    ).replace(queryParameters: {'formaPagamento': formaPagamento.value});

    final response = await http.patch(uri);

    return OrderResponse.fromJson(_handleResponse(response));
  }

  Future<Order> cancelar(int id) async {
    final response = await http.patch(Uri.parse('$baseUrl/$id/cancelar'));
    return Order.fromJson(_handleResponse(response));
  }
}
