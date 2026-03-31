import 'package:flutter/material.dart';

class CounterLogic extends ChangeNotifier {
  int _counter = 0;
  
  int get counter => _counter;

  void decrease(){
    if (_counter > -17) {
      _counter--;
      notifyListeners();
    }
  }

  void increase(){
    if (_counter < 100) {
      _counter++;
      notifyListeners();
    }
  }
}