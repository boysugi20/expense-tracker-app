part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transaction;

  const TransactionLoaded({required this.transaction});
  @override
  List<Object> get props => [transaction];
}