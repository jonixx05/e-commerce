import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/screens/product_detail.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    //setting listen to false disables the whole widget from rebuilding
    final authData = Provider.of<Auth>(context,
        listen:
            false); //passing the token from the auth class to the widget item
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: Consumer<Product>(
          //Consumer is used to notify only widgets that needs to be updated
          builder: (context, value, child) => IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_outline,
            ),
            onPressed: () {
              product.toogleFavouriteStatus(authData.token, authData.userId);
            },
          ),
          // child: null
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.shopping_cart_outlined,
          ),
          onPressed: () {
            cart.addItem(product.id, product.price, product.title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Added to cart!"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ),
            );
          },
        ),
        title: Text(
          product.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: "BodoniModa",
            color: Colors.white,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetail.routeName, arguments: product.id);
        },
        child: Hero(
          tag: product.id,
          child: Image.network(
            product.imageAsset,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
