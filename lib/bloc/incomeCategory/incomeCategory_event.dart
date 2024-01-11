part of 'incomeCategory_bloc.dart';

abstract class IncomeCategoryEvent extends Equatable {
  const IncomeCategoryEvent();
}

class GetIncomeCategories extends IncomeCategoryEvent {
  const GetIncomeCategories();
  @override
  List<Object?> get props => [];
}

class AddIncomeCategory extends IncomeCategoryEvent {
  final IncomeCategory category;
  const AddIncomeCategory({
    required this.category,
  });

  @override
  List<Object?> get props => [category];
}

class UpdateIncomeCategory extends IncomeCategoryEvent {
  final IncomeCategory category;
  const UpdateIncomeCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class DeleteIncomeCategory extends IncomeCategoryEvent {
  final IncomeCategory category;
  const DeleteIncomeCategory({required this.category});

  @override
  List<Object?> get props => [category];
}
