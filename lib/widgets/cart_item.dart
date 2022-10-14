import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  const CartItem({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      //this widget removes the widgets it encloses on swipping the widget
      key: ValueKey(id),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Are you sure?"),
                  content:
                      Text("Do you want to remove this item from your cart?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(false); //does not remove the item
                      },
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); //removes the item
                      },
                      child: Text("Yes"),
                    ),
                  ],
                ));
      },
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Text(
                  "\$ $price",
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "BodoniModa",
                    color: Colors.red,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "BodoniModa",
                    fontStyle: FontStyle.normal,
                  ),
                ),
                subtitle: Text(
                  "Total: \$ ${price * quantity}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "BodoniModa",
                    color: Colors.red,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                trailing: Text(
                  "$quantity X",
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "BodoniModa",
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
