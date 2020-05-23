import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({this.id, this.total, this.products, this.date});
}

class Orders with ChangeNotifier{
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  int get itemsCount => _orders.length;

  void addOrder(Cart cart){
    _orders.insert(0, Order(
      id: Random().nextDouble().toString(),
      total: cart.totalAmount,
      date: DateTime.now(),
      products: cart.items.values.toList(),
    ));

    notifyListeners();
  }
}