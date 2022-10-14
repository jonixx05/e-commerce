import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      ///If totalAmount <= 0,ie there is no product on the cart screen then the
      ///buy now button should not be tappable and also when _isLoading is true
      onTap: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.item.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear(); //to clear the cart after making an order
            },
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Container(
              color: Colors.black,
              width: double.infinity,
              height: 70,
              child: const Center(
                child: Text(
                  "BUY NOW",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "BodoniModa",
                      fontStyle: FontStyle.normal,
                      color: Colors.white),
                ),
              ),
            ),
    );
  }
}
