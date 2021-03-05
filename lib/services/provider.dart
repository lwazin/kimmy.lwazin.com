import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Settings with ChangeNotifier, DiagnosticableTreeMixin {
  String _navigation = 'home';
  bool _showBox = false;

  String get navigation => _navigation;
  bool get showBox => _showBox;

  void newNav(String value) {
    _navigation = value;
    notifyListeners();
  }

  void changeShowBox() {
    _showBox = !_showBox;
    notifyListeners();
  }
}
