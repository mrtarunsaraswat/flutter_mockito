import 'dart:convert';

import 'package:flutter_mockito/product_model.dart';
import 'package:flutter_mockito/product_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito_example/product_model.dart';
import 'package:mockito_example/product_service.dart';

import 'unit_test_mockito_test.mocks.dart';

void main() {
  group('ProductService Tests', () {
    late ProductService productService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      productService = ProductService(client: mockClient);
    });

    test(
        'fetchProducts returns a list of products when the request is successful',
        () async {
      // Mock the HTTP response when fetchProducts is called.
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .thenAnswer((_) async => http.Response(
              jsonEncode([
                {"title": "Product 1", "price": 10.0},
                {"title": "Product 2", "price": 20.0}
              ]),
              200));

      final result = await productService.fetchProducts();

      // Verify that the HTTP get method was called with the correct URL.
      verify(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .called(1);

      // Expect the result to contain a list of products.
      expect(result, isA<List<Product>>());
      expect(result.length, 2);
      expect(result[0].title, "Product 1");
      expect(result[1].price, 20.0);
    });

    test('fetchProducts throws an exception when the request fails', () async {
      // Mock the HTTP response to simulate a failed request.
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Expect fetchProducts to throw an exception.
      expect(productService.fetchProducts(), throwsException);
    });
  });
}
