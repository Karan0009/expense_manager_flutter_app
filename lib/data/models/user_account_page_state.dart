import 'package:expense_manager/data/models/user.dart';

class UserAccountPageState {
  final User? userInfo;
  final bool isLoading;

  UserAccountPageState({this.userInfo, this.isLoading = false});

  UserAccountPageState copyWith({User? userInfo, bool? isLoading}) {
    return UserAccountPageState(
        userInfo: userInfo ?? this.userInfo,
        isLoading: isLoading ?? this.isLoading);
  }
}
