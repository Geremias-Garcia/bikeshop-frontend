import 'package:flutter/material.dart';
import '../modules/products/model/product_model.dart';
import '../modules/products/service/product_service.dart';
import '../modules/products/model/sale_model.dart';
import '../modules/products/service/sale_service.dart';

class SaleForm extends StatefulWidget {
  @override
  _SaleFormState createState() => _SaleFormState();
}

class _SaleFormState extends State<SaleForm> {
  final productService = ProductService();
  final saleService = SaleService();

  List<Product> products = [];
  Product? selectedProduct;

  final quantidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data = await productService.getProducts();
    setState(() => products = data);
  }

  void save() async {
    if (selectedProduct == null) return;

    final quantidade = int.tryParse(quantidadeController.text) ?? 0;

    if (quantidade <= 0) return;

    final sale = Sale(
      produto: selectedProduct!,
      quantidade: quantidade,
      valorVenda: 0, // backend calcula
      dataSaida: DateTime.now(),
    );

    try {
      await saleService.createSale(sale);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Venda')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Product>(
              hint: Text('Selecione o produto'),
              value: selectedProduct,
              items: products.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text('${p.nome} (Estoque: ${p.estoque})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedProduct = value);
              },
            ),
            TextField(
              controller: quantidadeController,
              decoration: InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
