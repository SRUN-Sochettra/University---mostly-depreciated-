import 'package:flutter/material.dart';

class CounterLogic extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increase() {
    _counter++;
    notifyListeners();
  }

  void decrease() {
    _counter--;
    notifyListeners();
  }
}