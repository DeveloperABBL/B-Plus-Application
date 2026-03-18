import 'package:flutter/foundation.dart';

class AppViewModel extends ChangeNotifier {
  String _language = 'th';

  String get language => _language;

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
  }
}

