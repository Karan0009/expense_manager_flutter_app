class BottomNavbarState {
  final int curIndex;

  BottomNavbarState({this.curIndex = 0});

  BottomNavbarState copyWith({
    int? curIndex,
  }) {
    return BottomNavbarState(
      curIndex: curIndex ?? this.curIndex,
    );
  }
}
