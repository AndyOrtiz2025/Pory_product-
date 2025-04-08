import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Productos")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Camisa"),
            onTap: () {
              // Navegar a la pantalla de detalles pasando el nombre
              Navigator.pushNamed(
                context,
                '/productDetail',
                arguments: 'Camisa',
              );
            },
          ),
          ListTile(
            title: Text("Pantalon"),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/productDetail',
                arguments: 'Pantalon ',
              );
            },
          ),
          ListTile(
            title: Text("Gorra"),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/productDetail',
                arguments: 'Gorra',
              );
            },
          ),
        ],
      ),
    );
  }
}
