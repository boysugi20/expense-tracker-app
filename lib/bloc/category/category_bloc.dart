
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/database/category_dao.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  CategoryBloc() : super(CategoryInitial()) {

    List<TransactionCategory> categories = [];

    on<GetCategories>((event, emit) async {
      categories = await CategoryDAO.getCategories();
      emit(CategoryLoaded(category: categories, lastUpdated: DateTime.now()));
    });

    on<AddCategory>((event, emit) async {
      await CategoryDAO.insertCategory(event.category);
      if(state is CategoryLoaded){
        final state = this.state as CategoryLoaded;
        emit(CategoryLoaded(category: List.from(state.category)..add(event.category), lastUpdated: DateTime.now()));
      }
    });

    on<UpdateCategory>((event, emit) async {
      await CategoryDAO.updateCategory(event.category);
      if(state is CategoryLoaded){
        final state = this.state as CategoryLoaded;
        emit(CategoryLoaded(category: List.from(state.category), lastUpdated: DateTime.now()));
      }
    });

    on<DeleteCategory>((event, emit) async {
      await CategoryDAO.deleteCategory(event.category);
      if(state is CategoryLoaded){
        final state = this.state as CategoryLoaded;
        emit(CategoryLoaded(category: List.from(state.category)..remove(event.category), lastUpdated: DateTime.now()));
      }
    });
  }
}