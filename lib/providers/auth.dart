import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  //token getter
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  //userId getter
  String? get userId {
    return _userId;
  }

  //auth function
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCUK8FU-GU8RMhZKqT9eLV2nm9U6-TMpbM");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData["expiresIn"]),
        ),
      );
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final String userData = json.encode({
        ///data we want to store on the device
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  //sign up method
  Future<void> signupUser(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

//sign in method
  Future<void> signInUser(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  ///A method which allows us to retrieve data from the device storage
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData") as String)
        as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    ///re-initiallizing all the data
    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = extractedUserData["expiryDate"];
    notifyListeners();
    _autoLogout();
    return true;
  }

//loging out the user.
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

//automatic logout after token has expired
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final expiryTime = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryTime), logout);
  }
}
