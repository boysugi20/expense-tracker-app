
import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:flutter/material.dart';

class GoalsForm extends StatefulWidget {
  
  final Map<String, dynamic>? initialValues;
  final String header1, header2;

  const GoalsForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {

  final _formKey = GlobalKey<FormState>();
  String name = '';
  String price = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      name = widget.initialValues!['name'] ?? '';
      price = widget.initialValues!['price'] ?? '';
      price = addThousandSeperatorToString(price);
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
            FormTextInput(title: 'Name', labelText: 'Goal name', initalText: name, onSave: (value) {print(value);}),
            FormTextInput(title: 'Price', labelText: 'Goal price', initalText: price, onSave: (value) {print(value);}),
          ],
        ),
      ),
    );
  }
}