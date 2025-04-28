import 'package:flutter/material.dart';
import '../../services/api_service_product.dart';
import '../widgets/product_list_tile.dart';
import '../pages/product_form_bottom_sheet.dart'; // Asegúrate de importar el formulario

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final data = await ApiServiceProduct.getProducts();
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar productos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductListTile(
                    product: product,
                    onEdit: () {
                      _openEditProduct(context, product);
                    },
                    onDelete: () {
                      _confirmDelete(context, product['id']);
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openCreateProduct(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openCreateProduct(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => ProductFormBottomSheet(
            onSuccess: fetchProducts, // Refrescar lista después de crear
          ),
    );
  }

  void _openEditProduct(BuildContext context, dynamic product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => ProductFormBottomSheet(
            product: product, // Enviamos el producto a editar
            onSuccess: fetchProducts, // Refrescar lista después de editar
          ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('¿Eliminar producto?'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar este producto?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Cancelar
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Cierra el diálogo
                  try {
                    await ApiServiceProduct.deleteProduct(id);
                    fetchProducts(); // Refrescar lista después de eliminar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto eliminado exitosamente'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al eliminar producto'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
