
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:flutter/material.dart';

class CategoriesForm extends StatefulWidget {
  
  final Map<String, dynamic>? initialValues;
  final String header1, header2;

  const CategoriesForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<CategoriesForm> createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {

  final _formKey = GlobalKey<FormState>();
  String name = '';
  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      name = widget.initialValues!['name'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1, 
      header2: widget.header2,
      formInputs: Form(
        key: _formKey,
        child: Column(
          children: [
            FormTextInput(title: 'Name', labelText: 'Category name', initalText: name, onSave: (value) {print(value);}),
          ],
        ),
      ),
    );
  }
}