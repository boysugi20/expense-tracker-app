

import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  double amount = 0;

  final GoalBloc goalBloc = GoalBloc();
  Goal goal = Goal(name: '', totalAmount: 0);

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      name = widget.initialValues!['name'] ?? '';
      amount = widget.initialValues!['amount'] ?? '';
      amount = amountStringToDouble(amountDoubleToString(amount));
    }
  }

  Future<void> insertGoal() async {
    if(goal.name.isNotEmpty){
      context.read<GoalBloc>().add(AddGoal(goal: goal));
    }
  }

  Future<void> updateGoal() async {
    context.read<GoalBloc>().add(UpdateGoal(goal: goal));
  }

  Future<void> deleteGoal() async {
    context.read<GoalBloc>().add(DeleteGoal(goal: goal));
  }


  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1, 
      header2: widget.header2,
      onSave: (){
        widget.initialValues == null ? insertGoal() : updateGoal();
      },
      onDelete: (){ deleteGoal(); },
      formInputs: Form(
        key: _formKey,
        child: Column(
          children: [
            FormTextInput(
              title: 'Name', 
              labelText: 'Goal name', 
              initalText: name, 
              onSave: (value) {goal.name = value!;}
            ),
            FormTextInput(
              title: 'Price', 
              labelText: 'Goal amount', 
              isKeypad: true, 
              useThousandSeparator: true, 
              initalText: amount != 0 ? amountDoubleToString(amount) : '', 
              onSave: (value) {goal.totalAmount = amountStringToDouble(value!);}
            ),
          ],
        ),
      ),
    );
  }
}