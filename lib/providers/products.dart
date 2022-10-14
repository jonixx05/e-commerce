import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//defines how a product should look like
class Product with ChangeNotifier {
  final id;
  final String title;
  final String description;
  final double price;
  final String imageAsset;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageAsset,
    this.isFavorite = false,
  });

  //creating a function to avoid code duplication
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  //Updating the Favorite status optimistically
  Future<void> toogleFavouriteStatus(String? token, String? userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        "https://jonix-shop-app-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$token");
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
