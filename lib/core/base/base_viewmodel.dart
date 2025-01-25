import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _error;
  String? get error => _error;

  // Set loading state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error state
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
