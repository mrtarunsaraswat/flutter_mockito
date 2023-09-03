import 'dart:convert';

import 'package:http/http.dart' as http;

import 'product_model.dart';

class ProductService {
  final String apiUrl = "https://fakestoreapi.com/products";
  final http.Client client;

  ProductService({required this.client});

  Future<List<Product>> fetchProducts() async {
    final response = await client.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
