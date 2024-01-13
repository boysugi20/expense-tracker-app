part of 'expenseCategory_bloc.dart';

abstract class ExpenseCategoryState extends Equatable {
  const ExpenseCategoryState();
}

class ExpenseCategoryInitial extends ExpenseCategoryState {
  @override
  List<Object> get props => [];
}

class ExpenseCategoryLoaded extends ExpenseCategoryState {
  final List<ExpenseCategory> category;
  final DateTime lastUpdated;

  const ExpenseCategoryLoaded({required this.category, required this.lastUpdated});
  @override
  List<Object> get props => [category, lastUpdated];

  @override
  bool get stringify => true;
}

class ExpenseCategoryUpdated extends ExpenseCategoryState {
  final List<ExpenseCategory> category;
  final DateTime lastUpdated;

  const ExpenseCategoryUpdated({required this.category, required this.lastUpdated});
  @override
  List<Object> get props => [category, lastUpdated];

  @override
  bool get stringify => true;
}
