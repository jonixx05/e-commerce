import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/widgets/cart_item.dart' as ci;
import '../providers/cart.dart';
import '../widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: const Text(
              "C A R T",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "BodoniModa",
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: cart.item.length,
                itemBuilder: (context, index) => ci.CartItem(
                  id: cart.item.values.toList()[index].id,
                  productId: cart.item.keys.toList()[index],
                  title: cart.item.values.toList()[index].title,
                  price: cart.item.values.toList()[index].price,
                  quantity: cart.item.values.toList()[index].quantity,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            //color: Colors.blue,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "SUB TOTAL",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "BodoniModa",
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Text(
                  "\$ ${cart.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "BodoniModa",
                    color: Colors.red,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          OrderButton(cart: cart),
        ],
      ),
    );
  }
}
