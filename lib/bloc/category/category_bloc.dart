
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/database/category_dao.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  CategoryBloc() : super(CategoryInitial()) {

    List<ExpenseCategory> categories = [];

    on<GetExpenseCategories>((event, emit) async {
      categories = await CategoryDAO.getExpenseCategories();
      emit(CategoryLoaded(category: categories, lastUpdated: DateTime.now()));
    });

    on<AddExpenseCategory>((event, emit) async {
      await CategoryDAO.insertExpenseCategory(event.category);
      if(state is CategoryLoaded){
        final state = this.state as CategoryLoaded;
        emit(CategoryLoaded(category: List.from(state.category)..add(event.category), lastUpdated: DateTime.now()));
      }
    });

    on<UpdateExpenseCategory>((event, emit) async {
      await CategoryDAO.updateExpenseCategory(event.category);
      if(state is CategoryLoaded){
        final state = this.state as CategoryLoaded;
        emit(CategoryLoaded(category: List.from(state.category), lastUpdated: DateTime.now()));
      }
    });

    on<DeleteExpenseCategory>((event, emit) async {
      await CategoryDAO.deleteExpenseCategory(event.category);
      if(state is CategoryLoaded){
        final state = this.state as CategoryLoaded;
        emit(CategoryLoaded(category: List.from(state.category)..remove(event.category), lastUpdated: DateTime.now()));
      }
    });
  }
}