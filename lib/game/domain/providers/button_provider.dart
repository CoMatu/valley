import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonProvider extends ChangeNotifier {
  String _imagePath1 = 'assets/images/lazer-base.png';
  String _imagePath2 = 'assets/images/lazer-base.png';
  String _imagePath3 = 'assets/images/lazer-base.png';
  String _imagePath4 = 'assets/images/lazer-base.png';
  int _scope = 0;
  int _bestScore = 0;

  int get scope => _scope;
  int get bestScore => _bestScore ?? 0;

  void increment() {
    _scope++;
    notifyListeners();
  }

  void decrement() {
    _scope--;
    notifyListeners();
  }

  void clearScope() {
    _scope = 0;
    notifyListeners();
  }

  String image(String key) {
    switch (key) {
      case 'assets/images/Hero-1.png':
        return _imagePath1;
      case 'assets/images/Hero-2.png':
        return _imagePath2;
      case 'assets/images/Hero-3.png':
        return _imagePath3;
      case 'assets/images/Hero-4.png':
        return _imagePath4;
      default:
        return 'assets/images/lazer-base.png';
    }
  }

  void imageForTapDown(String key) {
    switch (key) {
      case 'assets/images/Hero-1.png':
        _imagePath1 = 'assets/images/lazer-base-light.png';
        notifyListeners();
        break;
      case 'assets/images/Hero-2.png':
        _imagePath2 = 'assets/images/lazer-base-light.png';
        notifyListeners();
        break;
      case 'assets/images/Hero-3.png':
        _imagePath3 = 'assets/images/lazer-base-light.png';
        notifyListeners();
        break;
      case 'assets/images/Hero-4.png':
        _imagePath4 = 'assets/images/lazer-base-light.png';
        notifyListeners();
        break;
      default:
        return null;
    }
  }

  void imageForTapUp(String key) {
    switch (key) {
      case 'assets/images/Hero-1.png':
        _imagePath1 = 'assets/images/lazer-base.png';
        notifyListeners();
        break;
      case 'assets/images/Hero-2.png':
        _imagePath2 = 'assets/images/lazer-base.png';
        notifyListeners();
        break;
      case 'assets/images/Hero-3.png':
        _imagePath3 = 'assets/images/lazer-base.png';
        notifyListeners();
        break;
      case 'assets/images/Hero-4.png':
        _imagePath4 = 'assets/images/lazer-base.png';
        notifyListeners();
        break;
      default:
        return null;
    }
  }

  Future<void> getBestResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _bestScore = prefs.getInt('bestScore');
    } on Exception catch (e) {
      print('ButtonProvider error $e');
    }
    notifyListeners();
  }

  Future<void> setBestResult(int result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bestScore', result);
    _bestScore = result;
    notifyListeners();
  }
}
