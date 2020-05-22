import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/providers/products.dart';
import '../models/Products.dart';

class ProductOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<Product> loadedProducts = Provider.of<Products>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Minha loja"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, i) => ProductItem(loadedProducts[i]),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ), 
      ),
    );
  }
}