import 'package:bikeshop_front_end/modules/products/service/purchase_service.dart';
import 'package:bikeshop_front_end/screens/purchase/purchase_form.dart';
import 'package:flutter/material.dart';
import '../../modules/products/model/purchase_model.dart';
import 'package:intl/intl.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final service = PurchaseService();
  List<Purchase> purchases = [];

  final DateFormat format = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    loadPurchases();
  }

  void loadPurchases() async {
    final data = await service.getPurchase();
    setState(() => purchases = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compras')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final p = purchases[index];

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.shopping_cart, color: Colors.blue),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.produto.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text('Qtd: ${p.quantidade}'),

                      Text(
                        'Data: ${format.format(p.dataEntrada)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${(p.valorCompra * p.quantidade).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ],
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
            MaterialPageRoute(builder: (_) => PurchaseForm()),
          );
          loadPurchases();
        },
        label: Text("Nova compra"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
