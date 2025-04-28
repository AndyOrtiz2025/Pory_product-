import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServiceProduct {
  static const String baseUrl = 'https://api.restful-api.dev';

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/objects'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  static Future<void> createProduct(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/objects'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear producto');
    }
  }

  static Future<void> updateProduct(String id, String name) async {
    final response = await http.put(
      Uri.parse('$baseUrl/objects/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto');
    }
  }

  static Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/objects/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto');
    }
  }
}
