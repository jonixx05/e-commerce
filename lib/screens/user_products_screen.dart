import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/editing_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_products_item.dart';

import '../providers/products_provider.dart';

//Users can manage their products here. Like adding products to the app

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = "/UserProducts";

  //A method that allows us to fetch our data from the server whenever
  //we refresh the page.
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: const Color.fromARGB(169, 255, 255, 255),
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: "newProduct",
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Consumer<ProductsProvider>(
                        builder: (context, productsData, _) => ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (_, i) {
                              return UserProductsItem(
                                title: productsData.items[i].title,
                                imageAsset: productsData.items[i].imageAsset,
                                id: productsData.items[i].id,
                              );
                            }),
                      ),
                    ),
                  ),
      ),
    );
  }
}
