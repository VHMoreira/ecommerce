import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: <Widget>[
          IconButton(
            color: Theme.of(context).primaryIconTheme.color,
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (ctx, i) => Column(
            children: <Widget>[
              ProductItem(products.items[i]),
              Divider()
            ],
          ),
        ),
      ),
      
    );
  }
}