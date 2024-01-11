import 'package:expense_tracker/bloc/incomeCategory/incomeCategory_bloc.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/incomeCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeCategoriesForm extends StatefulWidget {
  final IncomeCategory? initialValues;
  final String header1, header2;

  const IncomeCategoriesForm({required this.header1, this.header2 = '', this.initialValues, Key? key})
      : super(key: key);

  @override
  State<IncomeCategoriesForm> createState() => _IncomeCategoriesFormState();
}

class _IncomeCategoriesFormState extends State<IncomeCategoriesForm> {
  final _formKey = GlobalKey<FormState>();
  late IncomeCategory category;

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  void _initializeCategories() {
    if (widget.initialValues != null) {
      category = widget.initialValues!;
    } else {
      category = IncomeCategory(id: 0, name: '');
    }
  }

  Future<void> insertIncomeCategory() async {
    if (category.name.isNotEmpty) {
      context.read<IncomeCategoryBloc>().add(AddIncomeCategory(category: category));
    }
  }

  Future<void> updateIncomeCategory() async {
    context.read<IncomeCategoryBloc>().add(UpdateIncomeCategory(category: category));
  }

  Future<void> deleteIncomeCategory() async {
    context.read<IncomeCategoryBloc>().add(DeleteIncomeCategory(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1,
      header2: widget.header2,
      buttonText: widget.initialValues == null ? null : '',
      onSave: () {
        widget.initialValues == null ? insertIncomeCategory() : updateIncomeCategory();
      },
      onDelete: () {
        deleteIncomeCategory();
      },
      formInputs: Form(
        key: _formKey,
        child: Column(
          children: [
            FormTextInput(
              title: 'Name',
              labelText: 'Expense Category name',
              charLimit: 16,
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
