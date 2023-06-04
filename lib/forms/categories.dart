
import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesForm extends StatefulWidget {
  
  final ExpenseCategory? initialValues;
  final String header1, header2;

  const CategoriesForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<CategoriesForm> createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {
  
  final _formKey = GlobalKey<FormState>();
  ExpenseCategory category = ExpenseCategory(id: 0, name: '');

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      category = widget.initialValues!;
    }
  }

  Future<void> insertExpenseCategory() async {
    if(category.name.isNotEmpty){
      context.read<CategoryBloc>().add(AddExpenseCategory(category: category));
    }
  }

  Future<void> updateExpenseCategory() async {
    context.read<CategoryBloc>().add(UpdateExpenseCategory(category: category));
  }

  Future<void> deleteExpenseCategory() async {
    context.read<CategoryBloc>().add(DeleteExpenseCategory(category: category));
  }
  
  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1, 
      header2: widget.header2,
      buttonText: widget.initialValues == null ? null : '',
      onSave: (){
        widget.initialValues == null ? insertExpenseCategory() : updateExpenseCategory();
      },
      onDelete: (){ deleteExpenseCategory(); },
      formInputs: Form(
        key: _formKey,
        child: Column(
          children: [
            FormTextInput(
              title: 'Name', 
              labelText: 'Category name', 
              isRequired: true,
              initalText: category.name, 
              onSave: (value) {
                category.name = value!; 
              },
              validateText: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some value';
                }
                return null;
              },
            ),
            FormIconInput(
              title: 'Icon',
              initialIcon: category.icon,
              onSave: (value) {
                category.icon = value!;
              },
            ),
          ],
        ),
      ),
    );
  }
}