import 'package:flutter/cupertino.dart';
import 'package:flutter_cart_app/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_modal.dart';

class CartProvider with ChangeNotifier {

  DBHelper db = DBHelper();

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;


  late Future<List<CartModel>> _cart;
  Future<List<CartModel>> get cart => _cart;

  Future<List<CartModel>> getData() async{
    _cart = db.getCartData();
    return _cart;
  }

  void _setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addCounter() {
    _counter++;
    _setPref();
    notifyListeners();
  }

  void minusCounter() {
    _counter--;
    _setPref();
    notifyListeners();
  }

  int getCounterValue() {
    _getPref();
    return _counter;
  }


  void addTotalPrice(double productPrice) {
    _totalPrice +=  productPrice;
    _setPref();
    notifyListeners();
  }

  void minusTotalPrice(double productPrice) {
    _totalPrice -=  productPrice;
    _setPref();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPref();
    return _totalPrice;
  }
}
