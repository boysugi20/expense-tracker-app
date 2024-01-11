part of 'expenseCategory_bloc.dart';

abstract class ExpenseCategoryEvent extends Equatable {
  const ExpenseCategoryEvent();
}

class GetExpenseCategories extends ExpenseCategoryEvent {
  const GetExpenseCategories();
  @override
  List<Object?> get props => [];
}

class AddExpenseCategory extends ExpenseCategoryEvent {
  final ExpenseCategory category;
  const AddExpenseCategory({
    required this.category,
  });

  @override
  List<Object?> get props => [category];
}

class UpdateExpenseCategory extends ExpenseCategoryEvent {
  final ExpenseCategory category;
  const UpdateExpenseCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class DeleteExpenseCategory extends ExpenseCategoryEvent {
  final ExpenseCategory category;
  const DeleteExpenseCategory({required this.category});

  @override
  List<Object?> get props => [category];
}
