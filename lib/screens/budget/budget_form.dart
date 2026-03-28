import 'package:flutter/material.dart';
import '../../modules/products/model/product_model.dart';
import '../../modules/products/model/order_model.dart';
import '../../modules/products/model/order_item_model.dart';
import '../../modules/products/model/user_model.dart';
import '../../modules/products/service/product_service.dart';
import '../../modules/products/service/order_service.dart';
import '../../modules/products/service/user_service.dart';

class BudgetForm extends StatefulWidget {
  const BudgetForm({super.key});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final productService = ProductService();
  final orderService = OrderService();
  final userService = UserService();

  List<Product> products = [];
  List<User> users = [];

  Product? selectedProduct;
  User? selectedUser;

  final quantidadeController = TextEditingController();

  List<OrderItem> carrinho = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final p = await productService.getProducts();
    final u = await userService.getUsers();

    setState(() {
      products = p;
      users = u;
    });
  }

  void adicionarItem() {
    if (selectedProduct == null) return;

    final qtd = int.tryParse(quantidadeController.text) ?? 0;
    if (qtd <= 0) return;

    setState(() {
      carrinho.add(
        OrderItem(
          productId: selectedProduct!.id!,
          productName: selectedProduct!.nome,
          quantidade: qtd,
        ),
      );
    });

    quantidadeController.clear();
  }

  void salvar() async {
    if (selectedUser == null || carrinho.isEmpty) return;

    final order = Order(
      userId: selectedUser!.id!,
      userName: selectedUser!.name,
      itens: carrinho,
    );

    try {
      await orderService.criar(order); // ✅ CORRETO AGORA

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Orçamento criado!')));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Orçamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<User>(
              hint: const Text('Cliente'),
              items: users.map((u) {
                return DropdownMenuItem(value: u, child: Text(u.name));
              }).toList(),
              onChanged: (v) => setState(() => selectedUser = v),
            ),
            DropdownButtonFormField<Product>(
              hint: const Text('Produto'),
              items: products.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text('NOME: ${p.nome} - ESTOQUE: ${p.estoque}'),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedProduct = v),
            ),
            TextField(
              controller: quantidadeController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
            ElevatedButton(
              onPressed: adicionarItem,
              child: const Text('Adicionar'),
            ),
            Expanded(
              child: ListView(
                children: carrinho.map((item) {
                  return ListTile(
                    title: Text(item.productName),
                    subtitle: Text('Qtd: ${item.quantidade}'),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: salvar,
              child: const Text('Salvar Orçamento'),
            ),
          ],
        ),
      ),
    );
  }
}
