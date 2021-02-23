import 'package:flutter/widgets.dart';

class SearchProvider with ChangeNotifier {
  bool _isSearching = false;

  get searching => _isSearching;

  set searching(bool status) {
    _isSearching = status;
    notifyListeners();
  }
}
