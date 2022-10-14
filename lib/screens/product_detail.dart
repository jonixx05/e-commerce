import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({
    Key? key,
  }) : super(key: key);

  static const routeName = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    //listener
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text(
          loadedProduct.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              height: 400,
              width: double.infinity,
              child: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageAsset,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("\$ ${loadedProduct.price}"),
            const SizedBox(
              height: 20,
            ),
            Text(loadedProduct.description),
          ],
        ),
      ),
    );
  }
}
