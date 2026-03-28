import 'package:flutter/material.dart';
import '../../modules/products/model/user_model.dart';
import '../../modules/products/service/user_service.dart';
import '../../shared/app_theme.dart';
import 'user_form.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final service = UserService();
  List<User> _all = [];
  List<User> _filtered = [];
  bool isLoading = true;
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    setState(() => isLoading = true);
    try {
      final data = await service.getUsers();
      setState(() {
        _all = data;
        _filtered = data;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _all
          : _all.where((u) =>
              u.name.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q) ||
              u.phone.contains(q)).toList();
    });
  }

  Future<void> _confirmDelete(User user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desativar cliente'),
        content: Text('Deseja desativar ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Desativar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await service.deleteUser(user.id!);
      if (mounted) ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cliente desativado')));
      loadUsers();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  void _openForm({User? user}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserForm(user: user)),
    );
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const AppLoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar por nome, e-mail ou telefone...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : const Text('Clientes'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filtered = _all;
                }
              });
            },
          ),
        ],
      ),
      body: _filtered.isEmpty
          ? AppEmptyState(
              message: _isSearching
                  ? 'Nenhum cliente encontrado'
                  : 'Nenhum cliente cadastrado',
              icon: Icons.person_outline,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final u = _filtered[index];
                return AppCard(
                  accentColor: AppColors.client,
                  icon: Icons.person,
                  onTap: () => _openForm(user: u),
                  children: [
                    Text(u.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(u.phone, style: const TextStyle(fontSize: 13)),
                    Text(u.email,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: AppColors.client, size: 20),
                      onPressed: () => _openForm(user: u),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 20),
                      onPressed: () => _confirmDelete(u),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.client,
        icon: const Icon(Icons.add),
        label: const Text('Novo cliente'),
      ),
    );
  }
}
