class ExpensesDashboardState {
  final bool isLoading;
  final List<dynamic> expenses;
  final int currentMonthExpense;

  ExpensesDashboardState({
    this.isLoading = false,
    this.expenses = const [],
    this.currentMonthExpense = 0,
  });

  ExpensesDashboardState copyWith(
      {bool? isLoading, List<dynamic>? expenses, int? currentMonthExpense}) {
    return ExpensesDashboardState(
      isLoading: isLoading ?? this.isLoading,
      expenses: expenses ?? this.expenses,
      currentMonthExpense: currentMonthExpense ?? this.currentMonthExpense,
    );
  }
}
