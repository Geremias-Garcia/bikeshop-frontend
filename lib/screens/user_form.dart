import 'package:flutter/material.dart';
import '../modules/products/model/user_model.dart';
import '../modules/products/service/user_service.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final service = UserService();

  void save() async {
    final nome = nameController.text;
    final telefone = phoneController.text;
    final email = emailController.text;

    if (nome.isEmpty) return;

    await service.createUser(User(name: nome, phone: telefone, email: email));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Usuario')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
