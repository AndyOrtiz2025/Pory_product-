import 'package:flutter/material.dart';
import '../../services/api_service_product.dart';

class ProductFormBottomSheet extends StatefulWidget {
  final Function onSuccess; // Para refrescar la lista después
  final Map<String, dynamic>?
  product; // Recibimos el producto si vamos a editar

  const ProductFormBottomSheet({
    super.key,
    required this.onSuccess,
    this.product,
  });

  @override
  State<ProductFormBottomSheet> createState() => _ProductFormBottomSheetState();
}

class _ProductFormBottomSheetState extends State<ProductFormBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name'] ?? '';
    }
  }

  Future<void> saveProduct() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      if (widget.product == null) {
        // Crear producto
        await ApiServiceProduct.createProduct(name);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto creado exitosamente')),
        );
      } else {
        // Editar producto
        final id = widget.product!['id'];
        await ApiServiceProduct.updateProduct(id, name);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado exitosamente')),
        );
      }
      widget.onSuccess(); // Refrescar lista
      Navigator.pop(context); // Cerrar modal
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.product != null;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEditing ? 'Editar Producto' : 'Nuevo Producto',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del producto',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          isSaving
              ? const CircularProgressIndicator()
              : ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Actualizar' : 'Guardar'),
                onPressed: saveProduct,
              ),
        ],
      ),
    );
  }
}
