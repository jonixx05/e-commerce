//where users can edit and add products
//since state managed in this class does not affect other classes,
//stateful widget is a better approach

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = "/edit-product";
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageAssetController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: "newProduct",
    title: "",
    description: "",
    price: 0,
    imageAsset: "",
  );

  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageAsset": "",
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      _updateImageUrl();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;

      if (productId != "newProduct") {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageAsset": "",
        };
        _imageAssetController.text = _editedProduct.imageAsset;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageAssetController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(() {
      _updateImageUrl();
    });
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageAssetController.text.startsWith("http") ||
          !_imageAssetController.text.startsWith("https")) {
        return;
      }
      setState(() {});
    }
  }

  ///This method saves the form
  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate(); //validates the user input
    if (!isValid) {
      return;
    }
    _form.currentState!.save(); //saves the form
    setState(() {
      _isLoading = true;
    });

    //checking if edited product id is "newProduct".
    if (_editedProduct.id != "newProduct") {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            //Showing the user the error encountered
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("An error occurred"),
                content: Text("Something went wrong"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay"),
                  ),
                ],
              );
            });
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: const Color.fromARGB(169, 255, 255, 255),
        title: const Text("Edit Products"),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key:
                  _form, //establishing a connection between the form and the save method
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues["title"],
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value!,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageAsset: _editedProduct.imageAsset,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please provide a value.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues["price"],
                        decoration: InputDecoration(
                          labelText: "Price",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a number.";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a number greater than zero.";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editedProduct = Product(
                            ///This saves the price and adds it to the list of product
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value!),
                            imageAsset: _editedProduct.imageAsset,
                          );
                        },
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues["description"],
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a description.";
                          }
                          if (value.length < 10) {
                            return "Characters entered should not be less than 10";
                          }
                          return null;
                        },
                        maxLines: 3,
                        onSaved: (value) {
                          _editedProduct = Product(
                            ///This saves the description and adds it to the list of product
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value!,
                            price: _editedProduct.price,
                            imageAsset: _editedProduct.imageAsset,
                          );
                        },
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageAssetController.text.isEmpty
                                ? Center(child: Text("Enter a URL"))
                                : FittedBox(
                                    child: Image.network(
                                      _imageAssetController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Image URL",
                              ),
                              keyboardType: TextInputType.url,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter an image URL.";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "Please enter a valid URL.";
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageAsset: value!,
                                );
                              },
                              controller: _imageAssetController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
