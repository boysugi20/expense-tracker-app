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
  final DateTime lastUpdated;

  const CategoryLoaded({required this.category, required this.lastUpdated});
  @override
  List<Object> get props => [category, lastUpdated];

  @override
  bool get stringify => true;
}