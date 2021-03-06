import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String productid;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.productid,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem)=>{
      total += cartItem.price * cartItem.quantity
    });

    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productid: product.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productid: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
      );
    }

    notifyListeners();
  }

  void removeSingleItem(String productid){
    if(!_items.containsKey(productid)){
      return ;
    }

    if(_items[productid].quantity == 1){
      _items.remove(productid);
    }else{
       _items.update(
        productid,
        (existingItem) => CartItem(
          id: existingItem.id,
          productid: existingItem.productid,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productid){
    _items.remove(productid);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
