part of 'incomeCategory_bloc.dart';

abstract class IncomeCategoryState extends Equatable {
  const IncomeCategoryState();
}

class IncomeCategoryInitial extends IncomeCategoryState {
  @override
  List<Object> get props => [];
}

class IncomeCategoryLoaded extends IncomeCategoryState {
  final List<IncomeCategory> category;
  final DateTime lastUpdated;

  const IncomeCategoryLoaded({required this.category, required this.lastUpdated});
  @override
  List<Object> get props => [category, lastUpdated];

  @override
  bool get stringify => true;
}

class IncomeCategoryUpdated extends IncomeCategoryState {
  final List<IncomeCategory> category;
  final DateTime lastUpdated;

  const IncomeCategoryUpdated({required this.category, required this.lastUpdated});
  @override
  List<Object> get props => [category, lastUpdated];

  @override
  bool get stringify => true;
}
