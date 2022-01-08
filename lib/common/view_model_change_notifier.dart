import 'package:flutter/material.dart';

abstract class ViewModelChangeNotifier extends ChangeNotifier {
  bool disposed = false;

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }
}
