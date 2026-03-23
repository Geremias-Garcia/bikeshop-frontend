import 'package:flutter/material.dart';
import '../modules/products/model/product_model.dart';
import '../modules/products/model/purchase_model.dart';
import '../modules/products/service/product_service.dart';
import '../modules/products/service/purchase_service.dart';

class PurchaseForm extends StatefulWidget {
  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  final productService = ProductService();
  final purchaseService = PurchaseService();

  List<Product> products = [];
  Product? selectedProduct;

  final valorController = TextEditingController();
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

    final valor = double.tryParse(valorController.text) ?? 0;
    final quantidade = int.tryParse(quantidadeController.text) ?? 0;

    final purchase = Purchase(
      valorCompra: valor,
      quantidade: quantidade,
      dataEntrada: DateTime.now(),
      produto: selectedProduct!,
    );

    await purchaseService.createPurchase(purchase);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Compra')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Product>(
              hint: Text('Selecione o produto'),
              value: selectedProduct,
              items: products.map((p) {
                return DropdownMenuItem(value: p, child: Text(p.nome));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedProduct = value);
              },
            ),
            TextField(
              controller: valorController,
              decoration: InputDecoration(labelText: 'Valor de compra'),
              keyboardType: TextInputType.number,
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
