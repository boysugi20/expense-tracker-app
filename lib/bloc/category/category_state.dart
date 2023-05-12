part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoaded extends CategoryState {
  final List<TransactionCategory> category;

  const CategoryLoaded({required this.category});
  @override
  List<Object> get props => [category];
}