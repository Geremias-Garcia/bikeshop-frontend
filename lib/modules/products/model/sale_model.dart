import 'product_model.dart';

class Sale {
  final int? id;
  final Product produto;
  final int quantidade;
  final double valorVenda;
  final DateTime dataSaida;

  Sale({
    this.id,
    required this.produto,
    required this.quantidade,
    required this.valorVenda,
    required this.dataSaida,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      produto: json['produto'] != null
          ? Product.fromJson(json['produto'])
          : throw Exception('Produto veio null'),
      quantidade: json['quantidade'] ?? 0,
      valorVenda: (json['valorVenda'] ?? 0).toDouble(),
      dataSaida: DateTime.parse(json['dataSaida']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantidade': quantidade,
      'produto': {'id': produto.id},
    };
  }
}
