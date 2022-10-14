import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/editing_product_screen.dart';

class UserProductsItem extends StatelessWidget {
  final id;
  final String title;
  final String imageAsset;

  const UserProductsItem({
    Key? key,
    required this.title,
    required this.imageAsset,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: AssetImage(imageAsset),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                      arguments: id,
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(id);
                    } catch (error) {
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text("Deleting failed"),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey[200],
        ),
      ],
    );
  }
}
