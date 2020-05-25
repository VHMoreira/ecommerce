import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toogleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final String baseurl = 'https://vitorshop-e7b3d.firebaseio.com/products';
    try {
      final res = await http.patch(
        '$baseurl/$id.json',
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );

      if (res.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Ocorreu um erro ao defini-lo como favorito');
    }
  }
}
