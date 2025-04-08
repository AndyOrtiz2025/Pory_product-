import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el argumento pasado desde la lista
    final String productName =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text("Detalle del Producto")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Producto seleccionado: $productName',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Volver a la lista de productos
                Navigator.pop(context);
              },
              child: Text("Volver a la lista"),
            ),
          ],
        ),
      ),
    );
  }
}
