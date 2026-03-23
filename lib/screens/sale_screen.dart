import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modules/products/model/sale_model.dart';
import '../modules/products/service/sale_service.dart';
import 'sale_form.dart';

class SaleScreen extends StatefulWidget {
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final service = SaleService();
  List<Sale> sales = [];

  final DateFormat format = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    loadSales();
  }

  void loadSales() async {
    final data = await service.getSales();
    setState(() => sales = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendas')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: sales.length,
        itemBuilder: (context, index) {
          final s = sales[index];

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
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.attach_money, color: Colors.green),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.produto.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text('Qtd: ${s.quantidade}'),

                      Text(
                        'Data: ${format.format(s.dataSaida)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${s.valorVenda.toStringAsFixed(2)}',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SaleForm()),
          );
          loadSales();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
