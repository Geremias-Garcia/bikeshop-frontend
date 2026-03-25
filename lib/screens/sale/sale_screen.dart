import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../modules/products/model/order_model.dart';
import '../../modules/products/service/order_service.dart';
import 'sale_form.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final service = OrderService();

  List<Order> vendas = [];
  bool isLoading = true;

  final DateFormat format = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    loadVendas();
  }

  Future<void> loadVendas() async {
    setState(() => isLoading = true);

    try {
      final data = await service.getVendas();
      setState(() => vendas = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vendas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vendas.length,
        itemBuilder: (context, index) {
          final order = vendas[index];

          final dataExibida = order.dataFechamento != null
              ? format.format(DateTime.parse(order.dataFechamento!))
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
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.attach_money, color: Colors.green),
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
                    'R\$ ${order.total?.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Data: $dataExibida',
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (order.formaPagamento != null)
                    Text(
                      'Pagamento: ${order.formaPagamento}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
              children: [
                const Divider(),
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

                        // 🔥 LINHA LADO A LADO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Qtd: ${item.quantidade}'),
                            Text('Unit: R\$ ${unit.toStringAsFixed(2)}'),
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
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SaleForm()),
          );
          loadVendas();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
