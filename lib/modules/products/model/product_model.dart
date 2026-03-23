class Product {
  final int? id;
  final String nome;
  final double porcentagemLucro;
  final double valorVenda;
  final int estoque;

  Product({
    this.id,
    required this.nome,
    required this.porcentagemLucro,
    required this.valorVenda,
    required this.estoque,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nome: json['nome'],
      porcentagemLucro: (json['porcentagemLucro'] ?? 0).toDouble(),
      valorVenda: (json['valorVenda'] ?? 0).toDouble(),
      estoque: json['estoque'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nome': nome, 'porcentagemLucro': porcentagemLucro};
  }
}
