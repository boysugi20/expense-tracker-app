import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/database/incomeCategory_dao.dart';
import 'package:expense_tracker/models/incomeCategory.dart';
import 'package:equatable/equatable.dart';

part 'incomeCategory_event.dart';
part 'incomeCategory_state.dart';

class IncomeCategoryBloc extends Bloc<IncomeCategoryEvent, IncomeCategoryState> {
  IncomeCategoryBloc() : super(IncomeCategoryInitial()) {
    List<IncomeCategory> categories = [];

    on<GetIncomeCategories>((event, emit) async {
      categories = await IncomeCategoryDAO.getIncomeCategories();
      emit(IncomeCategoryLoaded(category: categories, lastUpdated: DateTime.now()));
    });

    on<AddIncomeCategory>((event, emit) async {
      final insertedId = await IncomeCategoryDAO.insertIncomeCategory(event.category);
      final updatedCategory = event.category.copyWith(id: insertedId);
      if (state is IncomeCategoryLoaded) {
        final state = this.state as IncomeCategoryLoaded;
        emit(IncomeCategoryLoaded(
            category: List.from(state.category)..add(updatedCategory), lastUpdated: DateTime.now()));
      }
    });

    on<UpdateIncomeCategory>((event, emit) async {
      await IncomeCategoryDAO.updateIncomeCategory(event.category);
      if (state is IncomeCategoryLoaded) {
        final currentState = state as IncomeCategoryLoaded;
        final updatedCategories = currentState.category.map((category) {
          return category.id == event.category.id ? event.category : category;
        }).toList();
        emit(IncomeCategoryUpdated(category: updatedCategories, lastUpdated: DateTime.now()));
      }
    });

    on<DeleteIncomeCategory>((event, emit) async {
      await IncomeCategoryDAO.deleteIncomeCategory(event.category);
      if (state is IncomeCategoryLoaded) {
        final currentState = state as IncomeCategoryLoaded;
        final updatedCategories = currentState.category.where((category) => category.id != event.category.id).toList();
        emit(IncomeCategoryUpdated(category: updatedCategories, lastUpdated: DateTime.now()));
      }
    });
  }
}
