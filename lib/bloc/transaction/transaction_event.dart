part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class GetTransactions extends TransactionEvent {
  const GetTransactions();
  @override
  List<Object?> get props => [];
}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;
  const AddTransaction({
    required this.transaction,
  });

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;

  final ExpenseCategory? expenseCategory;
  final IncomeCategory? incomeCategory;

  const UpdateTransaction({required this.transaction, this.expenseCategory, this.incomeCategory});

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final Transaction transaction;
  const DeleteTransaction({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}
