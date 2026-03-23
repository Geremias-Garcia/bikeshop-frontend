import 'product_model.dart';

class Purchase {
  final int? id;
  final Product produto;
  final double valorCompra;
  final int quantidade;
  final DateTime dataEntrada;

  Purchase({
    this.id,
    required this.valorCompra,
    required this.quantidade,
    required this.dataEntrada,
    required this.produto,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      valorCompra: (json['valorCompra'] ?? 0).toDouble(),
      quantidade: json['quantidade'] ?? 0,
      dataEntrada: DateTime.parse(json['dataEntrada']),
      produto: Product.fromJson(json['produto']), // 👈 objeto aninhado
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valorCompra': valorCompra,
      'quantidade': quantidade,
      'dataEntrada': dataEntrada.toIso8601String(),
      'produto': {'id': produto.id},
    };
  }
}
