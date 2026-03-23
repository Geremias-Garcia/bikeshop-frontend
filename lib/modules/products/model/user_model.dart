class User {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final bool ativo;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.ativo = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['nome'],
      phone: json['telefone'],
      email: json['email'],
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nome': name, 'telefone': phone, 'email': email, 'ativo': ativo};
  }
}
