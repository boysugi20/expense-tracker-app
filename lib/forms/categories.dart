
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategoriesForm extends StatefulWidget {
  
  final TransactionCategory? initialValues;
  final String header1, header2;

  const CategoriesForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<CategoriesForm> createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {

  final _formKey = GlobalKey<FormState>();
  TransactionCategory category = TransactionCategory(name: '');

  Future<void> addItem() async {
    await DatabaseHelper.createCategory(TransactionCategory(name: category.name));
  }

  Future<void> updateCategory() async {
    await DatabaseHelper.updateCategory(category);
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
      buttonText: widget.initialValues == null ? 'Save' : 'Update',
      onSave: (){
        widget.initialValues == null ? addItem() : updateCategory();
      },
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