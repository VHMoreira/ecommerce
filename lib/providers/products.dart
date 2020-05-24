import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  final String _url = 'https://vitorshop-e7b3d.firebaseio.com/products.json';
  List<Product> _items = [];

  // bool _showFavoritesOnly = false;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((i) => i.isFavorite).toList();
  }

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    final res = await http.get(_url);
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
      _url,
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

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((p) => p.id == id);
    if (index >= 0) {
      _items.removeWhere((p) => p.id == id);
      notifyListeners();
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
