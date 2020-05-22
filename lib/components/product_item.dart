import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/Products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context);

    return ClipRRect(
        child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL, 
              arguments: product
            );
          },
          child: Image.network(
              product.imageUrl, 
              fit: BoxFit.cover
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(product.isFavorite? Icons.favorite : Icons.favorite_border),
              onPressed: (){
                product.toogleFavorite();
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {

              },
            ),
          ),
      ),
    );
  }
}