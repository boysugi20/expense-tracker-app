

import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalsForm extends StatefulWidget {
  
  final Goal? initialValues;
  final String header1, header2;

  const GoalsForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {

  final _formKey = GlobalKey<FormState>();

  final GoalBloc categoryBloc = GoalBloc();
  Goal goal = Goal(name: '', totalAmount: 0);

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      goal = widget.initialValues!;
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
      buttonText: widget.initialValues == null ? null : '',
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
              initalText: goal.name, 
              onSave: (value) {goal.name = value!;}
            ),
            FormTextInput(
              title: 'Progress', 
              labelText: 'Current goal progress amount', 
              helperText: 'If there is no progress yet, fill with 0',
              isKeypad: true, 
              useThousandSeparator: true, 
              initalText: goal.progressAmount != null ? amountDoubleToString(goal.progressAmount!) : '', 
              onSave: (value) {goal.totalAmount = amountStringToDouble(value!);},
            ),
            FormTextInput(
              title: 'Target', 
              labelText: 'Goal target amount', 
              isKeypad: true, 
              useThousandSeparator: true, 
              initalText: goal.totalAmount != 0 ? amountDoubleToString(goal.totalAmount) : '', 
              onSave: (value) {goal.totalAmount = amountStringToDouble(value!);},
              validateText: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some value';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}