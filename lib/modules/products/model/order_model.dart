import 'order_item_model.dart';

class Order {
  final int? id;
  final String? status;
  final String? dataCriacao;
  final String? dataFechamento;
  final double? total;
  final String? formaPagamento; // valores: 'PIX', 'CARTAO', 'DINHEIRO'
  final int userId;
  final String userName;
  final List<OrderItem> itens;

  Order({
    this.id,
    this.status,
    this.dataCriacao,
    this.dataFechamento,
    this.total,
    this.formaPagamento,
    required this.userId,
    required this.userName,
    required this.itens,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
      dataCriacao: json['dataCriacao'],
      dataFechamento: json['dataFechamento'],
      total: (json['total'] as num?)?.toDouble(),
      formaPagamento: json['formaPagamento'],
      userId: json['usuario']['id'],
      userName: json['usuario']['nome'],
      itens: (json['itens'] as List).map((e) => OrderItem.fromJson(e)).toList(),
    );
  }

  // usado no POST /pedidos e POST /pedidos/venda-direta
  Map<String, dynamic> toJson() {
    return {
      'usuario': {'id': userId},
      'itens': itens.map((e) => e.toJson()).toList(),
    };
  }

  bool get isOrcamento => status == 'ORCAMENTO';
  bool get isFinalizado => status == 'FINALIZADO';
  bool get isCancelado => status == 'CANCELADO';
}
