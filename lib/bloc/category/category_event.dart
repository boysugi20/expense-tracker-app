part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class GetExpenseCategories extends CategoryEvent {
  const GetExpenseCategories();
  @override
  List<Object?> get props => [];
}

class AddExpenseCategory extends CategoryEvent {
  final ExpenseCategory category;
  const AddExpenseCategory({required this.category,});

  @override
  List<Object?> get props => [category];
}

class UpdateExpenseCategory extends CategoryEvent {
  final ExpenseCategory category;
  const UpdateExpenseCategory({required this.category});
  
  @override
  List<Object?> get props => [category];
}

class DeleteExpenseCategory extends CategoryEvent {
  final ExpenseCategory category;
  const DeleteExpenseCategory({required this.category});
  
  @override
  List<Object?> get props => [category];
}