
import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesForm extends StatefulWidget {
  
  final TransactionCategory? initialValues;
  final String header1, header2;

  const CategoriesForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<CategoriesForm> createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {
  
  final CategoryBloc categoryBloc = CategoryBloc();

  final _formKey = GlobalKey<FormState>();
  TransactionCategory category = TransactionCategory(name: '');

  Future<void> insertCategory() async {
    if(category.name.isNotEmpty){
      context.read<CategoryBloc>().add(AddCategory(category: category));
    }
  }

  Future<void> updateCategory() async {
    context.read<CategoryBloc>().add(UpdateCategory(category: category));
  }

  Future<void> deleteCategory() async {
    context.read<CategoryBloc>().add(DeleteCategory(category: category));
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      category = widget.initialValues!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1, 
      header2: widget.header2,
      buttonText: widget.initialValues == null ? null : '',
      onSave: (){
        widget.initialValues == null ? insertCategory() : updateCategory();
      },
      onDelete: (){ deleteCategory(); },
      formInputs: Form(
        key: _formKey,
        child: Column(
          children: [
            FormTextInput(
              title: 'Name', 
              labelText: 'Category name', 
              initalText: category.name, 
              onSave: (value) {
                category.name = value!; 
              }
            ),
          ],
        ),
      ),
    );
  }
}