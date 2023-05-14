
import 'package:expense_tracker/bloc/transaction/bloc/transaction_bloc.dart';
import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  
  final Transaction? initialValues;
  final String header1, header2;

  const TransactionForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {

  final _formKey = GlobalKey<FormState>();

  Future<void> updateTransaction() async {
    context.read<TransactionBloc>().add(UpdateTransaction(transaction: widget.initialValues!, category: widget.initialValues!.category));
  }

  Future<void> deleteTransaction() async {
    context.read<TransactionBloc>().add(DeleteTransaction(transaction: widget.initialValues!));
  }
  
  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1, 
      header2: widget.header2,
      buttonText: widget.initialValues == null ? null : '',
      onSave: (){
        updateTransaction();
      },
      onDelete: (){ deleteTransaction(); },
      formInputs: Form(
        key: _formKey,
        child: Column(
          children: [
            FormDateInput(
              title: 'Date', 
              labelText: 'Transaction date', 
              isRequired: true,
              initalText: DateFormat('dd MMM yyyy').format(widget.initialValues!.date), 
              onSave: (value) {
                widget.initialValues!.date = DateFormat('dd MMM yyyy').parse(value!); 
              },
              validateText: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some value';
                }
                return null;
              },
            ),
            FormTextInput(
              title: 'Amount', 
              labelText: 'Transaction amount', 
              isRequired: true,
              isKeypad: true,
              useThousandSeparator: true,
              initalText: amountDoubleToString(widget.initialValues!.amount), 
              onSave: (value) {
                widget.initialValues!.amount = amountStringToDouble(value!); 
              },
              validateText: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some value';
                }
                return null;
              },
            ),
            FormTextInput(
              title: 'Notes', 
              labelText: 'Transaction notes', 
              initalText: widget.initialValues!.note!, 
              onSave: (value) {
                widget.initialValues!.note = value!; 
              },
            ),
          ],
        ),
      ),
    );
  }
}