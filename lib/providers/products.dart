import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  // bool _showFavoritesOnly = false;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems{
    return _items.where((i) => i.isFavorite).toList();
  }

  void addProduct(Product product){
    _items.add(product);
    notifyListeners();
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