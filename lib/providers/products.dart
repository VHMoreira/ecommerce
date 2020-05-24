import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  final String _baseurl = 'https://vitorshop-e7b3d.firebaseio.com/products';
  List<Product> _items = [];

  // bool _showFavoritesOnly = false;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((i) => i.isFavorite).toList();
  }

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    final res = await http.get('$_baseurl.json');
    Map<String, dynamic> data = json.decode(res.body);
    if (data != null && _items.isEmpty) {
      data.forEach((productId, payload) {
        _items.add(
          Product(
              id: productId,
              title: payload['title'],
              description: payload['description'],
              price: payload['price'],
              imageUrl: payload['imageUrl'],
              isFavorite: payload['isFavorite']),
        );
        notifyListeners();
      });
    }
  }

  Future<void> addProduct(Product newProduct) async {
    final res = await http.post(
      '$_baseurl.json',
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite
      }),
    );

    _items.add(
      Product(
        id: json.decode(res.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        '$_baseurl/${product.id}.json',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((p) => p.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final res = await http.delete('$_baseurl/${product.id}.json');

      if (res.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro ${res.statusCode} na exclusão do produto');
      } 
    }
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
}
