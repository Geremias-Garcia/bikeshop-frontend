import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../modules/products/model/order_model.dart';
import '../../modules/products/service/order_service.dart';
import '../../modules/products/model/order_response.dart';
import 'budget_form.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final service = OrderService();

  List<Order> orcamentos = [];
  bool isLoading = true;

  final DateFormat format = DateFormat('dd/MM/yyyy HH:mm');

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

  // 🔥 APROVAR COM ALERTA
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
      final response = await service.aprovar(order.id!, escolha);

      // 🔥 ALERTA FORTE (modal obrigatório)
      if (response.alertas.isNotEmpty) {
        await _mostrarAlertas(response.alertas);
      }

      await loadOrcamentos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  Future<void> _cancelar(Order order) async {
    try {
      await service.cancelar(order.id!);
      await loadOrcamentos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  // 🔥 ALERTA MODAL (OBRIGA USUÁRIO A LER)
  Future<void> _mostrarAlertas(List<String> alertas) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('⚠️ Atenção'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: alertas.map((a) => Text(a)).toList(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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

          final data = order.dataCriacao != null
              ? format.format(DateTime.parse(order.dataCriacao!))
              : '-';

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt, color: Colors.orange),
              ),
              title: Text(
                order.userName ?? 'Sem nome',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'R\$ ${order.total?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Data: $data', style: const TextStyle(fontSize: 12)),
                ],
              ),
              children: [
                const Divider(),

                // 🔥 ITENS
                ...order.itens.map((item) {
                  final unit = item.valorUnitario ?? 0;
                  final total = item.quantidade * unit;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qtd: ${item.quantidade}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Unit: R\$ ${unit.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Total: R\$ ${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                // 🔥 AÇÕES
                if (order.isOrcamento)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _cancelar(order),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _aprovar(order),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                69,
                                147,
                                72,
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Aprovar'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
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
        label: Text("Novo orçamento"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
