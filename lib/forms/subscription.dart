
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:flutter/material.dart';

class SubscriptionForm extends StatefulWidget {
  
  final Map<String, dynamic>? initialValues;
  final String header1, header2;

  const SubscriptionForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {

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
            FormTextInput(title: 'Name', labelText: 'Subscription name', initalText: name, onSave: (value) {print(value);}),
            FormTextInput(title: 'Price', labelText: 'Subscription price', initalText: price, isKeypad: true, useThousandSeparator: true, onSave: (value) {print(value);}),
          ],
        ),
      ),
    );
  }
}