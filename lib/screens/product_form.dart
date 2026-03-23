import 'package:flutter/material.dart';
import '../modules/products/model/product_model.dart';
import '../modules/products/service/product_service.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final nameController = TextEditingController();
  final profitController = TextEditingController();

  final service = ProductService();

  void save() async {
    final nome = nameController.text;
    final lucro = double.tryParse(profitController.text) ?? 0;

    if (nome.isEmpty) return;

    await service.createProduct(
      Product(nome: nome, porcentagemLucro: lucro, valorVenda: 0, estoque: 0),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Produto')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: profitController,
              decoration: InputDecoration(labelText: '% Lucro'),
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
