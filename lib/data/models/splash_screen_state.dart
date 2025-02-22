import 'package:expense_manager/data/models/user.dart';

class SplashScreenState {
  final bool isLoading;

  SplashScreenState({this.isLoading = false});

  SplashScreenState copyWith({User? userInfo, bool? isLoading}) {
    return SplashScreenState(isLoading: isLoading ?? this.isLoading);
  }
}
