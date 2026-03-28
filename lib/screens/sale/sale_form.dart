import 'package:flutter/material.dart';
import '../../modules/products/model/product_model.dart';
import '../../modules/products/model/order_model.dart';
import '../../modules/products/model/order_item_model.dart';
import '../../modules/products/model/user_model.dart';
import '../../modules/products/service/product_service.dart';
import '../../modules/products/service/order_service.dart';
import '../../modules/products/service/user_service.dart';

class SaleForm extends StatefulWidget {
  const SaleForm({super.key});

  @override
  _SaleFormState createState() => _SaleFormState();
}

class _SaleFormState extends State<SaleForm> {
  final productService = ProductService();
  final orderService = OrderService();
  final userService = UserService();

  List<Product> products = [];
  List<User> users = [];

  Product? selectedProduct;
  User? selectedUser;

  final quantidadeController = TextEditingController();

  List<OrderItem> carrinho = [];

  bool isSaving = false;

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
    if (selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um produto')));
      return;
    }

    final quantidade = int.tryParse(quantidadeController.text) ?? 0;

    if (quantidade <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quantidade inválida')));
      return;
    }

    setState(() {
      carrinho.add(
        OrderItem(
          productId: selectedProduct!.id!,
          productName: selectedProduct!.nome,
          quantidade: quantidade,
        ),
      );
    });

    quantidadeController.clear();
  }

  // 🔥 SELECIONAR FORMA DE PAGAMENTO
  Future<FormaPagamento?> _selecionarFormaPagamento() {
    return showDialog<FormaPagamento>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Forma de pagamento'),
        children: FormaPagamento.values.map((f) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, f),
            child: Text(f.label),
          );
        }).toList(),
      ),
    );
  }

  // 🔥 ALERTA OBRIGATÓRIO
  Future<void> _mostrarAlertas(List<String> alertas) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Atenção'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: alertas.map((a) => Text('• $a')).toList(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  // 🔥 SALVAR VENDA
  void salvar() async {
    if (selectedUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um cliente')));
      return;
    }

    if (carrinho.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Carrinho vazio')));
      return;
    }

    final formaPagamento = await _selecionarFormaPagamento();
    if (formaPagamento == null) return;

    setState(() => isSaving = true);

    final order = Order(
      userId: selectedUser!.id!,
      userName: selectedUser!.name,
      itens: carrinho,
    );

    try {
      final response = await orderService.criarVendaDireta(
        order,
        formaPagamento,
      );

      // 🔥 MOSTRAR ALERTAS
      if (response.alertas.isNotEmpty) {
        await _mostrarAlertas(response.alertas);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Venda realizada!')));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }

    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Venda')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<User>(
              hint: const Text('Cliente'),
              items: users
                  .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
                  .toList(),
              onChanged: (v) => setState(() => selectedUser = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Product>(
              hint: const Text('Produto'),
              items: products
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.nome)))
                  .toList(),
              onChanged: (v) => setState(() => selectedProduct = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: quantidadeController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() => carrinho.remove(item));
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: isSaving ? null : salvar,
              child: isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Finalizar Venda'),
            ),
          ],
        ),
      ),
    );
  }
}
