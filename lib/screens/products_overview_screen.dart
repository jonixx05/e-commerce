//This is the screen that shows the grid of products on the app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import '../providers/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  All, //0
  Favorites, //1

}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.1,
        title: Center(child: Image.asset("assets/logos/Logo.png")),
        backgroundColor: const Color.fromARGB(169, 255, 255, 255),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              child: ch as Widget,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              //Filtering the options based on options selectedValue
              setState(() {
                if (selectedValue == FilterOptions.All) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
            color: Color.fromARGB(122, 255, 255, 255),
            icon: const Icon(Icons.more_vert_outlined),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FilterOptions.All,
                child: Text(
                  "All",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "BodoniModa",
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text(
                  "Favorites",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "BodoniModa",
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 570,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/image 10.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 250,
                  right: 20,
                  child: Container(
                    child: const Text(
                      "LUXURY \n  FASHION \n& ACCESSORIES",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: "BodoniModa",
                        color: Colors.black54,
                        height: 1,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 35,
                  left: 80,
                  child: Container(
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "EXPLORE COLLECTONS",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "BodoniModa",
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ProductsGrid(
                    showOnlyFavorites: _showOnlyFavorites,
                  ),
            Container(
              color: Colors.black54,
              height: 200,
              width: 400,
            )
          ],
        ),
      ),
    );
  }
}
