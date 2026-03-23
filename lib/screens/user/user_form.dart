import 'package:flutter/material.dart';
import '../../modules/products/model/user_model.dart';
import '../../modules/products/service/user_service.dart';

class UserForm extends StatefulWidget {
  final User? user;

  const UserForm({super.key, this.user});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final service = UserService();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user?.name ?? '');
    phoneController = TextEditingController(text: widget.user?.phone ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
  }

  void save() async {
    final user = User(
      id: widget.user?.id,
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      ativo: true,
    );

    if (widget.user == null) {
      await service.createUser(user);
    } else {
      await service.updateUser(user);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Novo Usuário' : 'Editar Usuário'),
      ),
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
