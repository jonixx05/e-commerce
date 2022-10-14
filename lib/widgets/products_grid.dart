import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products_provider.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;
  const ProductsGrid({Key? key, required this.showOnlyFavorites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        showOnlyFavorites ? productsData.favoriteItems : productsData.items;
    return Container(
      height: 700,
      width: 500,
      child: GridView.builder(
        physics:
            NeverScrollableScrollPhysics(), //allows the listview to be scrollable with the entire page
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: const ProductItem(),
        ),
      ),
    );
  }
}
