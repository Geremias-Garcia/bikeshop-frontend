import 'package:flutter/material.dart';
import 'product_screen.dart';
import 'purchase_screen.dart';
import 'sale_screen.dart';
import 'user_screen.dart';

class HomeScreen extends StatelessWidget {
  Widget buildButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BikeShop'), elevation: 0),
      body: Container(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            buildButton(
              context: context,
              title: 'Produtos',
              icon: Icons.inventory,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductScreen()),
                );
              },
            ),
            buildButton(
              context: context,
              title: 'Compras',
              icon: Icons.add_shopping_cart,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PurchaseScreen()),
                );
              },
            ),
            buildButton(
              context: context,
              title: 'Vendas',
              icon: Icons.attach_money,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SaleScreen()),
                );
              },
            ),
            buildButton(
              context: context,
              title: 'Orçamento',
              icon: Icons.description,
              color: Colors.purple,
              onTap: () {},
            ),
            buildButton(
              context: context,
              title: 'Clientes',
              icon: Icons.person,
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
