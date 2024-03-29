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
  final DateTime lastUpdated;

  const TransactionLoaded({required this.transaction, required this.lastUpdated});
  @override
  List<Object> get props => [transaction, lastUpdated];

  @override
  bool get stringify => true;
}

class TransactionUpdated extends TransactionState {
  final List<Transaction> updatedTransaction;
  final DateTime lastUpdated;

  const TransactionUpdated({required this.updatedTransaction, required this.lastUpdated});

  @override
  List<Object> get props => [updatedTransaction, lastUpdated];

  @override
  bool get stringify => true;
}
