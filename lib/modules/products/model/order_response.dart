import 'order_model.dart';

class OrderResponse {
  final Order pedido;
  final List<String> alertas;

  OrderResponse({required this.pedido, required this.alertas});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      pedido: Order.fromJson(json['pedido']),
      alertas: List<String>.from(json['alertas'] ?? []),
    );
  }
}
