import 'package:flutter/material.dart';
import '../../modules/products/model/user_model.dart';
import '../../modules/products/service/user_service.dart';
import '../../shared/app_theme.dart';

class UserForm extends StatefulWidget {
  final User? user;
  const UserForm({super.key, this.user});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final service = UserService();
  late final _nameController = TextEditingController(text: widget.user?.name ?? '');
  late final _phoneController = TextEditingController(text: widget.user?.phone ?? '');
  late final _emailController = TextEditingController(text: widget.user?.email ?? '');
  bool _isSaving = false;

  Future<void> _save() async {
    final nome = _nameController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informe o nome do cliente')));
      return;
    }
    setState(() => _isSaving = true);
    try {
      final user = User(
        id: widget.user?.id,
        name: nome,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        ativo: true,
      );
      if (widget.user == null) {
        await service.createUser(user);
      } else {
        await service.updateUser(user);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar cliente' : 'Novo cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
              textCapitalization: TextCapitalization.words,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.client,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(isEdit ? 'Atualizar' : 'Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
