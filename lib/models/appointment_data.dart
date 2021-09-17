import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:spaceship_service/models/car.dart';
import 'package:spaceship_service/models/cart_item.dart';

class AppointmentData extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  DateTime date = DateTime.now();
  Car? car;

  UnmodifiableListView<CartItem> get cartItems =>
      UnmodifiableListView(_cartItems);

  void removeCartItem(int i) {
    _cartItems.remove(_cartItems[i]);
    notifyListeners();
  }

  void addCartItem(CartItem cartItem) {
    _cartItems.add(cartItem);
    notifyListeners();
  }

  void changeDate(DateTime newDate) {
    date = newDate;
    notifyListeners();
  }

  void changeCar(Car newCar) {
    car = newCar;
    notifyListeners();
  }
}
