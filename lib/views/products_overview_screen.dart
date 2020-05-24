import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false).loadProducts().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Products products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Kaká Store"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (int selectedValue) {
              setState(() {
                if (selectedValue == 0) {
                  // products.showFavoritesOnly();
                  _showFavoriteOnly = true;
                } else {
                  // products.showAll();
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente favoritos'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: 1,
              )
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemsCount.toString(),
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
