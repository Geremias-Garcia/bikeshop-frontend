class OrderItem {
  final int productId;
  final String productName;
  final int quantidade;
  final double? valorUnitario;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantidade,
    this.valorUnitario,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['produto']['id'],
      productName: json['produto']['nome'],
      quantidade: json['quantidade'],
      valorUnitario: (json['valorUnitario'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produto': {'id': productId},
      'quantidade': quantidade,
      if (valorUnitario != null) 'valorUnitario': valorUnitario,
    };
  }
}
