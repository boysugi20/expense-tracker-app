import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/database/expenseCategory_dao.dart';
import 'package:expense_tracker/models/expenseCategory.dart';
import 'package:equatable/equatable.dart';

part 'expenseCategory_event.dart';
part 'expenseCategory_state.dart';

class ExpenseCategoryBloc extends Bloc<ExpenseCategoryEvent, ExpenseCategoryState> {
  ExpenseCategoryBloc() : super(ExpenseCategoryInitial()) {
    List<ExpenseCategory> categories = [];

    on<GetExpenseCategories>((event, emit) async {
      categories = await ExpenseCategoryDAO.getExpenseCategories();
      emit(ExpenseCategoryLoaded(category: categories, lastUpdated: DateTime.now()));
    });

    on<AddExpenseCategory>((event, emit) async {
      final insertedId = await ExpenseCategoryDAO.insertExpenseCategory(event.category);
      final updatedCategory = event.category.copyWith(id: insertedId);
      if (state is ExpenseCategoryLoaded) {
        final state = this.state as ExpenseCategoryLoaded;
        emit(ExpenseCategoryLoaded(
            category: List.from(state.category)..add(updatedCategory), lastUpdated: DateTime.now()));
      }
    });

    on<UpdateExpenseCategory>((event, emit) async {
      await ExpenseCategoryDAO.updateExpenseCategory(event.category);
      if (state is ExpenseCategoryLoaded) {
        final currentState = state as ExpenseCategoryLoaded;
        final updatedCategories = currentState.category.map((category) {
          return category.id == event.category.id ? event.category : category;
        }).toList();
        emit(ExpenseCategoryUpdated(category: updatedCategories, lastUpdated: DateTime.now()));
      }
    });

    on<DeleteExpenseCategory>((event, emit) async {
      await ExpenseCategoryDAO.deleteExpenseCategory(event.category);
      if (state is ExpenseCategoryLoaded) {
        final currentState = state as ExpenseCategoryLoaded;
        final updatedCategories = currentState.category.where((category) => category.id != event.category.id).toList();
        emit(ExpenseCategoryUpdated(category: updatedCategories, lastUpdated: DateTime.now()));
      }
    });
  }
}
