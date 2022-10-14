import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 300,
      ),
      height: _expanded ? min(widget.order.products.length * 20 + 50, 100) : 95,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("\$ ${widget.order.amount}"),
              subtitle: Text(
                DateFormat("dd/MM/yyyy hh:mm").format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            //if expanded, this container will show
            AnimatedContainer(
              height: _expanded
                  ? min(widget.order.products.length * 20 + 50,
                      100) //check section 12, lecture 289 for completion
                  : 0,
              duration: Duration(milliseconds: 300),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(prod.title),
                            Text(" ${prod.quantity}x \$ ${prod.price}"),
                          ],
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
