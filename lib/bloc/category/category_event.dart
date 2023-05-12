part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class GetCategories extends CategoryEvent {
  const GetCategories();
  @override
  List<Object?> get props => [];
}

class AddCategory extends CategoryEvent {
  final TransactionCategory category;
  const AddCategory({required this.category,});

  @override
  List<Object?> get props => [category];
}

class UpdateCategory extends CategoryEvent {
  final TransactionCategory category;
  const UpdateCategory({required this.category});
  
  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final TransactionCategory category;
  const DeleteCategory({required this.category});
  
  @override
  List<Object?> get props => [category];
}