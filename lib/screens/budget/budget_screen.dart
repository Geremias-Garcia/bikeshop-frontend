import 'package:flutter/material.dart';
import 'package:bikeshop_front_end/screens/sale/sale_form.dart';
import 'budget_form.dart';
import '../../modules/products/model/order_model.dart';
import '../../modules/products/service/order_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final service = OrderService();

  List<Order> orcamentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrcamentos();
  }

  Future<void> loadOrcamentos() async {
    setState(() => isLoading = true);

    try {
      final data = await service.getOrcamentos();
      setState(() => orcamentos = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }

    setState(() => isLoading = false);
  }

  Future<void> _aprovar(Order order) async {
    final escolha = await showDialog<FormaPagamento>(
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

    if (escolha == null) return;

    try {
      await service.aprovar(order.id!, escolha);
      await loadOrcamentos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  Future<void> _cancelar(Order order) async {
    await service.cancelar(order.id!);
    await loadOrcamentos();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Orçamentos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orcamentos.length,
        itemBuilder: (context, index) {
          final order = orcamentos[index];

          return ExpansionTile(
            title: Text(order.userName ?? 'Sem nome'),
            subtitle: Text('R\$ ${order.total?.toStringAsFixed(2) ?? '0.00'}'),
            children: [
              ...order.itens.map((item) {
                final unit = item.valorUnitario ?? 0;
                final total = item.quantidade * unit;

                return ListTile(
                  title: Text(item.productName),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Qtd: ${item.quantidade}'),
                      Text('Unit: R\$ ${unit.toStringAsFixed(2)}'),
                      Text('Total: R\$ ${total.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              }),
              if (order.isOrcamento)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _cancelar(order),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _aprovar(order),
                        child: const Text('Aprovar'),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BudgetForm()),
          );
          loadOrcamentos();
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Orçamento'),
      ),
    );
  }
}
