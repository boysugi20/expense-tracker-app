import 'package:expense_tracker/database/transaction_dao.dart';
import 'package:expense_tracker/models/expenseCategory.dart';
import 'package:expense_tracker/models/incomeCategory.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    List<Transaction> transactions = [];

    on<GetTransactions>((event, emit) async {
      transactions = await TransactionDAO.getTransactions();
      emit(TransactionLoaded(transaction: transactions, lastUpdated: DateTime.now()));
    });

    on<AddTransaction>((event, emit) async {
      final insertedId = await TransactionDAO.insertTransaction(event.transaction);
      final updatedTag = event.transaction.copyWith(id: insertedId);
      if (state is TransactionLoaded) {
        final currentState = state as TransactionLoaded;
        final updatedTransaction = List<Transaction>.from(currentState.transaction)..add(updatedTag);
        emit(TransactionUpdated(updatedTransaction: updatedTransaction, lastUpdated: DateTime.now()));
      }
    });

    on<UpdateTransaction>((event, emit) async {
      await TransactionDAO.updateTransaction(event.transaction, event.expenseCategory, event.incomeCategory);
      if (state is TransactionLoaded) {
        final currentState = state as TransactionLoaded;
        final updatedTransaction = currentState.transaction.map((transaction) {
          return transaction.id == event.transaction.id ? event.transaction : transaction;
        }).toList();
        emit(TransactionUpdated(updatedTransaction: updatedTransaction, lastUpdated: DateTime.now()));
      }
    });

    on<DeleteTransaction>((event, emit) async {
      await TransactionDAO.deleteTransaction(event.transaction);
      if (state is TransactionLoaded) {
        final currentState = state as TransactionLoaded;
        final updatedTransaction =
            currentState.transaction.where((transaction) => transaction.id != event.transaction.id).toList();
        emit(TransactionUpdated(updatedTransaction: updatedTransaction, lastUpdated: DateTime.now()));
      }
    });
  }
}
