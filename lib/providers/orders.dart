import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({this.id, this.total, this.products, this.date});
}

class Orders with ChangeNotifier {
  final String _baseurl = '${Constants.BASE_API_URL}/orders';

  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  int get itemsCount => _orders.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final res = await http.post(
      '$_baseurl.json',
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((ci) => {
                  'id': ci.id,
                  'productid': ci.productid,
                  'title': ci.title,
                  'quantity': ci.quantity,
                  'price': ci.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      Order(
        id: json.decode(res.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> loadedOrders = [];

    final res = await http.get('$_baseurl.json');

    Map<String, dynamic> data = json.decode(res.body);

    if (data != null) {
      data.forEach((orderId, payload) {
        loadedOrders.add(Order(
          id: orderId,
          total: payload['total'],
          date: DateTime.parse(payload['date']),
          products: (payload['products'] as List<dynamic>).map((e) {
            return CartItem(
              id: e['id'],
              price: e['price'],
              productid: e['productid'],
              quantity: e['quantity'],
              title: e['title'],
            );
          }).toList(),
        ));
        notifyListeners();
      });
    }

    _orders = loadedOrders.reversed.toList();
  }
}
