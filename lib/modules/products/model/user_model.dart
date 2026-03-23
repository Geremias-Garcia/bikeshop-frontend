class User {
  final int? id;
  final String name;
  final String phone;
  final String email;

  User({this.id, required this.name, required this.phone, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['nome'],
      phone: json['telefone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nome': name, 'telefone': phone, 'email': email};
  }
}
