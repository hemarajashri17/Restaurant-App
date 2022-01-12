import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _count = 1;

  int get count => _count;

  void setCount(int c){
    this._count = c;
  }

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if(count > 1){
      _count--;
    }
    notifyListeners();
  }

  void reset() {
    _count = 0;

    notifyListeners();
  }
}