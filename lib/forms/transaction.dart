
import 'package:expense_tracker/bloc/transaction/bloc/transaction_bloc.dart';
import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  
  final Transaction? initialValues;
  final String header1, header2;

  const TransactionForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  
  final TransactionBloc transactionBloc = TransactionBloc();

  final _formKey = GlobalKey<FormState>();
  Transaction transaction = Transaction(category: TransactionCategory(name: ''), date: DateTime.now(), amount: 0);

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      transaction = widget.initialValues!;
    }
  }

  Future<void> insertTransaction() async {
  }

  Future<void> updateTransaction() async {
  }

  Future<void> deleteTransaction() async {
  }
  
  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1, 
      header2: widget.header2,
      buttonText: widget.initialValues == null ? null : '',
      onSave: (){
        widget.initialValues == null ? insertTransaction() : updateTransaction();
      },
      onDelete: (){ deleteTransaction(); },
      formInputs: Form(
        key: _formKey,
        child: Column(
          children: [
            FormTextInput(
              title: 'Date', 
              labelText: 'Transaction date', 
              initalText: DateFormat('dd MMM yyyy').format(transaction.date), 
              onSave: (value) {
                transaction.date = DateFormat('dd MMM yyyy').parse(value!); 
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
              initalText: amountDoubleToString(transaction.amount), 
              onSave: (value) {
                transaction.amount = amountStringToDouble(value!); 
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
              initalText: transaction.note!, 
              onSave: (value) {
                transaction.note = value!; 
              },
            ),
          ],
        ),
      ),
    );
  }
}