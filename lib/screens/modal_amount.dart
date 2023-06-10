import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/services.dart'; 


class BottomModalamount extends StatefulWidget {

  final Object categoryOrGoal;
  final Function(int)? changeScreen;
  final Transaction? initialTransaction;

  const BottomModalamount({required this.categoryOrGoal, this.changeScreen, this.initialTransaction, Key? key}) : super(key: key);

  @override
  State<BottomModalamount> createState() => _BottomModalamountState();
}

class _BottomModalamountState extends State<BottomModalamount> {

  String _text = '';
  String? lastOperation;
  String tempValueTarget = '';
  String tempValueOperator = '';
  int tempOperator = 0;
  bool _operatorPressed = false;
  bool _lastInputIsOperator = false;

  List<DateTime?> selectedDate = [DateTime.now()];

  final TextEditingController _notesController = TextEditingController();

  String _title = '';
  String _objectType = '';
  ExpenseCategory category = ExpenseCategory(id: 0, name: '');
  Goal goal = Goal(id: 0, name: '', totalAmount: 0);

  @override
  void initState() {
    super.initState();
    // If edit transaction
    if (widget.initialTransaction != null) {
      category = widget.initialTransaction!.category;
      _text = amountDoubleToString(widget.initialTransaction!.amount);
      _notesController.text = widget.initialTransaction!.note ?? '';
      selectedDate[0] = widget.initialTransaction!.date;
    }
    // Choose between expense or goal
    if (widget.categoryOrGoal is ExpenseCategory) {
      category = widget.categoryOrGoal as ExpenseCategory;
      _title = category.name;
      _objectType = 'Category';
    } else if (widget.categoryOrGoal is Goal) {
      goal = widget.categoryOrGoal as Goal;
      _title = goal.name;
      _objectType = 'Goal';
    } else {
      throw Exception('categoryOrGoal must be either a ExpenseCategory or a Goal');
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {

    var results  = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayTextStyle: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: AppColors.accent,
      ),
      dialogSize: const Size(325, 400),
      value: selectedDate,
      borderRadius: BorderRadius.circular(15),
    );

    if (results != null && results != selectedDate) {
      setState(() {
        selectedDate = results;
      });
    }
  }

  Future<void> _addTransactionDB(category, date, amount, note) async {
    context.read<TransactionBloc>().add(AddTransaction(transaction: Transaction(id: 0, category: category, date: date, amount: amount, note: note)));
  }

  Future<void> _updateGoalDB(goal) async {
    context.read<GoalBloc>().add(UpdateGoal(goal: goal));
  }

  void _addTransaction({
    required ExpenseCategory category,
    required DateTime date,
    required double amount,
    required String note,
  }){
    if(_text != ''){
      _addTransactionDB(category, date, amount, note);
      widget.changeScreen!(1);
    }
    Navigator.pop(context);
  }

  void _addGoal({
    required Goal goal,
    required double amount,
  }){
    if(_text != ''){
      if(goal.progressAmount != null){
        goal.progressAmount = (goal.progressAmount! + amount);
      }
      else{
        goal.progressAmount = amount;
      }
      _updateGoalDB(goal);
      widget.changeScreen!(0);
    }
    Navigator.pop(context);
  }

  void _updateText(String value) {
    setState(() {
      // If input is clear
      if (value == 'clear') {
        _text = '';
      }

      // If input is backspace
      else if (value == 'backspace') {
        if (_text.isNotEmpty){
          _text = addThousandSeperatorToString(_text.substring(0, _text.length - 1));
        }
        if (_text.endsWith('.')) {
          _text = _text.replaceAll('.', '');
        }
      }
      // If input is enter
      else if (value == 'enter') {
        _text = ''; 
      }

      // If input is equals
      else if (value == "equals"){
        _operatorPressed = false;
        final result = Parser().parse(_text.replaceAll("x", "*").replaceAll(",", "")).evaluate(EvaluationType.REAL, ContextModel());

        if (result.isNaN) {
          _text = "0";
        } else if (result.isInfinite) {
          _text = "0";
        } else {
          _text = addThousandSeperatorToString(result.toStringAsFixed(2).replaceAll(".00", ""));
        }
      }

      // If input is operator
      else if (value == '+' || value == '-' || value == 'x' || value == '/') {
        if(_text.isNotEmpty){
          _operatorPressed = true;
          if(_lastInputIsOperator){
            _text = _text.substring(0, _text.length - 3);
            _text = '$_text $value ';
          }else{
            _text = '$_text $value ';
            _lastInputIsOperator = true;
          }
        }
      }

      // Append input to _text
      else {
        _text = _text.replaceAll(RegExp('^0+'), '');
        _text ='$_text$value';
        _text = addThousandSeperatorToString(_text);
        _lastInputIsOperator = false;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: AppColors.neutralDark,
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Category
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.pop(context);
                  openBottomModalCategory(context, widget.changeScreen!);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 16,
                        child: category.icon != null ? 
                          Icon(deserializeIcon(jsonDecode(category.icon!)), color: AppColors.main,) 
                          : 
                          Text(category.name.isNotEmpty ? category.name.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : "", style: TextStyle(color: AppColors.main),),
                        ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: _title, 
                        style: TextStyle(color: AppColors.white)
                      )
                    ),
                  ],
                ),
              ),
              
              // Divider
              Divider(
                color: AppColors.white,
                indent: 20,
                endIndent: 20,
                height: 36,
              ),
              
              // Date
              Builder(
                builder: (BuildContext context) {
                  if(_objectType == 'Category'){
                    return GestureDetector(
                      onTap: () {
                        _showDatePicker(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: RichText(text: TextSpan(text: DateFormat('dd MMM yyyy').format(selectedDate[0]!), style: TextStyle(color: AppColors.white))),
                      ),
                    );
                  }
                  else{
                    return Container(
                      height: 18,
                    );
                  }
                }
              ),

              // Ammount
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8))
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.black
                    ),
                    children: [
                      TextSpan(text: 'Rp ', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                      TextSpan(text: _text.isNotEmpty ? _text : '0', style: TextStyle(color: AppColors.black)),
                    ]
                  )
                ),
              ),

              // Notes
              Builder(
                builder: (BuildContext context) {
                  if(_objectType == 'Category'){
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16, top: 12),
                      child: TextField(
                        controller: _notesController,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                          hintText: "Notes...",
                        ),
                      ),
                    );
                  }
                  else{
                    return Container(
                      height: 36,
                    );
                  }
                }
              ),
              
              // Numpad
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            buildTextButton('+', onPressed: () => _updateText('+')),
                            buildTextButton('7', onPressed: () => _updateText('7')),
                            buildTextButton('8', onPressed: () => _updateText('8')),
                            buildTextButton('9', onPressed: () => _updateText('9')),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildTextButton('-', onPressed: () => _updateText('-')),
                            buildTextButton('4', onPressed: () => _updateText('4')),
                            buildTextButton('5', onPressed: () => _updateText('5')),
                            buildTextButton('6', onPressed: () => _updateText('6')),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildTextButton('x', onPressed: () => _updateText('x')),
                            buildTextButton('1', onPressed: () => _updateText('1')),
                            buildTextButton('2', onPressed: () => _updateText('2')),
                            buildTextButton('3', onPressed: () => _updateText('3')),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildTextButton('/', onPressed: () => _updateText('/')),
                            buildTextButton('.', onPressed: () => _updateText('.')),
                            buildTextButton('0', onPressed: () => _updateText('0')),
                            buildTextButton('000', onPressed: () => _updateText('000')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.18,
                    child: Builder(
                      builder: (BuildContext context) {
                        if(_objectType == 'Category'){
                          return Table(
                            children: [
                              TableRow(
                                children: [
                                  buildIconButton(
                                    Icons.backspace_outlined, 
                                    onLongPressed: () => _updateText('clear'),
                                    onPressed: () => _updateText('backspace')
                                  )
                                ]
                              ),
                              TableRow(
                                children: [
                                  buildIconButton(Icons.calendar_month_outlined, onPressed: () => _showDatePicker(context)),
                                ]
                              ),
                              TableRow(
                                children: [
                                  _operatorPressed ? 
                                    buildIconButton(
                                      Icons.calculate, 
                                      onPressed: () => _updateText('equals'), 
                                      height: 2, color: AppColors.accent, iconcolor: AppColors.white
                                    )
                                    :
                                    buildIconButton(
                                      Icons.check, 
                                      onPressed: () {
                                        _addTransaction(
                                          category: category, 
                                          date: selectedDate[0]!, 
                                          amount: amountStringToDouble(_text), 
                                          note: _notesController.text
                                        );
                                      },
                                      height: 2, color: AppColors.accent, iconcolor: AppColors.white
                                    ),
                                ]
                              ),
                            ],
                          );
                        }
                        else{
                          return Table(
                            children: [
                              TableRow(
                                children: [
                                  buildIconButton(
                                    Icons.backspace_outlined, 
                                    onLongPressed: () => _updateText('clear'),
                                    onPressed: () => _updateText('backspace')
                                  )
                                ]
                              ),
                              TableRow(
                                children: [
                                  _operatorPressed ? 
                                    buildIconButton(
                                      Icons.calculate, 
                                      onPressed: () => _updateText('equals'), 
                                      height: 3, color: AppColors.accent, iconcolor: AppColors.white
                                    )
                                    :
                                    buildIconButton(
                                      Icons.check, 
                                      onPressed: () => {
                                        _addGoal(goal: goal, amount: amountStringToDouble(_text))
                                      },
                                      height: 3, color: AppColors.accent, iconcolor: AppColors.white
                                    ),
                                ]
                              ),
                            ],
                          );
                        }
                      },
                    )
                  ),
                ],
              ),

            ],
          ),
        ),
      ]
    );
  }
}

Widget buildTextButton(String text, {required VoidCallback onPressed}) {
  return Container(
    margin: const EdgeInsets.all(4),
    child: Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: () {
          onPressed();
          HapticFeedback.lightImpact();
        },
        splashColor: AppColors.main.withOpacity(0.3),
        highlightColor: AppColors.main.withOpacity(0.3),
        child: SizedBox(
          height: 64,
          width: 64,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildIconButton(IconData icon, {double height = 1.0, Color color = Colors.white, Color iconcolor = Colors.black, required VoidCallback onPressed, VoidCallback? onLongPressed,}) {
  return Container(
    margin: const EdgeInsets.all(4),
    child: Material(
      color: color,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onLongPress: onLongPressed,
        onTap: () {
          onPressed();
          HapticFeedback.mediumImpact();
        },
        splashColor: AppColors.main.withOpacity(0.3),
        highlightColor: AppColors.main.withOpacity(0.3),
        child: SizedBox(
          height: 64 * height + ((height-1) * 8),
          width: 64,
          child: Center(
            child: Icon(
              icon,
              size: 24,
              color: iconcolor,
            ),
          ),
        ),
      ),
    ),
  );
}
