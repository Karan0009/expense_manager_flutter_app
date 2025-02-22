class ExpensesDashboardState {
  final bool isLoading;
  final List<dynamic> expenses;

  ExpensesDashboardState({
    this.isLoading = false,
    this.expenses = const [],
  });

  ExpensesDashboardState copyWith({
    bool? isLoading,
    List<dynamic>? expenses,
  }) {
    return ExpensesDashboardState(
      isLoading: isLoading ?? this.isLoading,
      expenses: expenses ?? this.expenses,
    );
  }
}
