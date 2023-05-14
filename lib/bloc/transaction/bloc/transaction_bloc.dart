import 'package:expense_tracker/database/transaction_dao.dart';
import 'package:expense_tracker/models/category.dart';
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
      await TransactionDAO.insertTransaction(event.transaction);
      if(state is TransactionLoaded){
        final state = this.state as TransactionLoaded;
        emit(TransactionLoaded(transaction: List.from(state.transaction)..add(event.transaction), lastUpdated: DateTime.now()));
      }
    });

    on<UpdateTransaction>((event, emit) async {
      await TransactionDAO.updateTransaction(event.transaction, event.category);
      if(state is TransactionLoaded){
        final state = this.state as TransactionLoaded;
        emit(TransactionLoaded(transaction: List.from(state.transaction), lastUpdated: DateTime.now()));
      }
    });

    on<DeleteTransaction>((event, emit) async {
      await TransactionDAO.deleteTransaction(event.transaction);
      if(state is TransactionLoaded){
        final state = this.state as TransactionLoaded;
        emit(TransactionLoaded(transaction: List.from(state.transaction)..remove(event.transaction), lastUpdated: DateTime.now()));
      }
    });
  }
}