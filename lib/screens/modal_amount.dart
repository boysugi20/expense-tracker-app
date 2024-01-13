import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracker/database/tag_dao.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/models/expenseCategory.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:expense_tracker/models/incomeCategory.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

import '../models/tag.dart';

class BottomModalamount extends StatefulWidget {
  final Object category;
  final Function(int)? changeScreen;
  final Transaction? initialTransaction;

  const BottomModalamount({required this.category, this.changeScreen, this.initialTransaction, Key? key})
      : super(key: key);

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
  String? _icon = '';
  String _objectType = '';
  List<Tag> selectedTags = [];
  late Object category;

  ExpenseCategory expenseCategory = ExpenseCategory(id: 0, name: '');
  IncomeCategory incomeCategory = IncomeCategory(id: 0, name: '');
  Goal goal = Goal(id: 0, name: '', totalAmount: 0);

  @override
  void initState() {
    super.initState();
    // If edit transaction
    if (widget.initialTransaction != null) {
      expenseCategory = widget.initialTransaction!.expenseCategory!;
      incomeCategory = widget.initialTransaction!.incomeCategory!;
      _text = amountDoubleToString(widget.initialTransaction!.amount);
      _notesController.text = widget.initialTransaction!.note ?? '';
      selectedDate[0] = widget.initialTransaction!.date;
    }
    // Choose between expense or goal
    if (widget.category is ExpenseCategory) {
      expenseCategory = widget.category as ExpenseCategory;
      _title = expenseCategory.name;
      _icon = expenseCategory.icon;
      _objectType = 'ExpenseCategory';
      category = expenseCategory;
    } else if (widget.category is IncomeCategory) {
      incomeCategory = widget.category as IncomeCategory;
      _title = incomeCategory.name;
      _icon = incomeCategory.icon;
      _objectType = 'IncomeCategory';
      category = incomeCategory;
    } else if (widget.category is Goal) {
      goal = widget.category as Goal;
      _title = goal.name;
      _icon = null;
      _objectType = 'Goal';
    } else {
      throw Exception('Category must be either ExpenseCategory, IncomeCategory, or Goal');
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayTextStyle: TextStyle(color: AppColors.base100, fontWeight: FontWeight.w700),
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

  Future<void> _addTransactionDB(category, date, amount, note, tags) async {
    if (category is ExpenseCategory) {
      context.read<TransactionBloc>().add(AddTransaction(
          transaction:
              Transaction(id: 0, expenseCategory: category, date: date, amount: amount, note: note, tags: tags)));
    } else if (category is IncomeCategory) {
      context.read<TransactionBloc>().add(AddTransaction(
          transaction:
              Transaction(id: 0, incomeCategory: category, date: date, amount: amount, note: note, tags: tags)));
    }
  }

  Future<void> _updateGoalDB(goal) async {
    context.read<GoalBloc>().add(UpdateGoal(goal: goal));
  }

  void _addTransaction(
      {required Object category,
      required DateTime date,
      required double amount,
      required String note,
      List<Tag>? tags}) {
    if (_text != '') {
      _addTransactionDB(category, date, amount, note, tags);
      widget.changeScreen!(1);
    }
    Navigator.pop(context);
  }

  void _addGoal({
    required Goal goal,
    required double amount,
  }) {
    if (_text != '') {
      if (goal.progressAmount != null) {
        goal.progressAmount = (goal.progressAmount! + amount);
      } else {
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
        if (_text.isNotEmpty) {
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
      else if (value == "equals") {
        _operatorPressed = false;
        final result = Parser()
            .parse(_text.replaceAll("x", "*").replaceAll(",", ""))
            .evaluate(EvaluationType.REAL, ContextModel());

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
        if (_text.isNotEmpty) {
          _operatorPressed = true;
          if (_lastInputIsOperator) {
            _text = _text.substring(0, _text.length - 3);
            _text = '$_text $value ';
          } else {
            _text = '$_text $value ';
            _lastInputIsOperator = true;
          }
        }
      }

      // Append input to _text
      else {
        _text = _text.replaceAll(RegExp('^0+'), '');
        _text = '$_text$value';
        _text = addThousandSeperatorToString(_text);
        _lastInputIsOperator = false;
      }
    });
  }

  void showTagDialog(tagsTemp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Tags'),
          content: tagsTemp.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: MultiSelectContainer(
                    onChange: (allSelectedItems, selectedItem) {
                      setState(() {
                        selectedTags = allSelectedItems.cast<Tag>().toList();
                      });
                    },
                    items: tagsTemp,
                    itemsDecoration: MultiSelectDecorations(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.accent), borderRadius: BorderRadius.circular(5)),
                      selectedDecoration:
                          BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                )
              : const Text('No Tags'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(color: AppColors.accent),
              ),
            ),
          ],
        );
      },
    );
  }

  void openTagPopup(BuildContext context) async {
    final tags = await TagDAO.getTags();

    List<MultiSelectCard> tagsTemp = tags.map((tag) {
      String? tagName = tag.name;
      Color tagColor = hexToColor(tag.color);
      bool isTagSelected = selectedTags.any((selectedTag) => selectedTag.name == tagName);

      return MultiSelectCard(
        value: tag,
        label: tagName,
        selected: isTagSelected,
        decorations: MultiSelectItemDecorations(
          decoration: BoxDecoration(
              color: tagColor.withOpacity(0.1),
              border: Border.all(color: tagColor),
              borderRadius: BorderRadius.circular(5)),
          selectedDecoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(5)),
        ),
        highlightColor: hexToColor(tag.color),
        splashColor: hexToColor(tag.color),
      );
    }).toList();

    showTagDialog(tagsTemp);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: AppColors.neutral,
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tags
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                spacing: 4, // gap between adjacent chips
                runSpacing: 8, // gap between lines
                children: [
                  for (var tag in selectedTags)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: hexToColor(tag.color),
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(4))),
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tag.name, style: TextStyle(color: AppColors.base100, fontSize: 12)),
                            Container(
                              width: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      openTagPopup(context);
                    },
                    child: DottedBorder(
                      color: AppColors.base100,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Edit Tag', style: TextStyle(color: AppColors.base100, fontSize: 12)),
                              Container(
                                width: 4,
                              ),
                              Icon(Icons.edit, color: AppColors.base100, size: 12)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(
              color: AppColors.base100,
              indent: 20,
              endIndent: 20,
              height: 36,
            ),

            // Category
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
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
                      child: _icon != null
                          ? Icon(
                              deserializeIcon(jsonDecode(_icon!)),
                              color: AppColors.primary,
                            )
                          : Text(
                              _title.isNotEmpty ? _title.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : "",
                              style: TextStyle(color: AppColors.primary),
                            ),
                    ),
                  ),
                  RichText(text: TextSpan(text: _title, style: TextStyle(color: AppColors.base100))),
                ],
              ),
            ),

            // Divider
            Divider(
              color: AppColors.base100,
              indent: 20,
              endIndent: 20,
              height: 36,
            ),

            // Date
            Builder(builder: (BuildContext context) {
              if (_objectType == 'ExpenseCategory' || _objectType == 'IncomeCategory') {
                return GestureDetector(
                  onTap: () {
                    _showDatePicker(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: RichText(
                        text: TextSpan(
                            text: DateFormat('dd MMM yyyy').format(selectedDate[0]!),
                            style: TextStyle(color: AppColors.base100))),
                  ),
                );
              } else {
                return Container(
                  height: 18,
                );
              }
            }),

            // Ammount
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration:
                  BoxDecoration(color: AppColors.base100, borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: RichText(
                  text: TextSpan(style: TextStyle(color: AppColors.neutral), children: [
                TextSpan(text: 'Rp ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                TextSpan(text: _text.isNotEmpty ? _text : '0', style: TextStyle(color: AppColors.neutral)),
              ])),
            ),

            // Notes
            Builder(builder: (BuildContext context) {
              if (_objectType == 'ExpenseCategory' || _objectType == 'IncomeCategory') {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16, top: 12),
                  child: TextField(
                    controller: _notesController,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.base300),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: TextStyle(color: AppColors.base300, fontSize: 14),
                      hintText: "Notes...",
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 36,
                );
              }
            }),

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
                        if (_objectType == 'ExpenseCategory' || _objectType == 'IncomeCategory') {
                          return Table(
                            children: [
                              TableRow(children: [
                                buildIconButton(Icons.backspace_outlined,
                                    color: AppColors.error,
                                    iconcolor: AppColors.base100,
                                    onLongPressed: () => _updateText('clear'),
                                    onPressed: () => _updateText('backspace'))
                              ]),
                              TableRow(children: [
                                buildIconButton(Icons.calendar_month_outlined,
                                    color: AppColors.info,
                                    iconcolor: AppColors.base100,
                                    onPressed: () => _showDatePicker(context)),
                              ]),
                              TableRow(children: [
                                _operatorPressed
                                    ? buildIconButton(Icons.calculate,
                                        onPressed: () => _updateText('equals'),
                                        height: 2,
                                        color: AppColors.primary,
                                        iconcolor: AppColors.base100)
                                    : buildIconButton(Icons.check, onPressed: () {
                                        _addTransaction(
                                            category: category,
                                            date: selectedDate[0]!,
                                            amount: amountStringToDouble(_text),
                                            note: _notesController.text,
                                            tags: selectedTags);
                                      }, height: 2, color: AppColors.primary, iconcolor: AppColors.base100),
                              ]),
                            ],
                          );
                        } else {
                          return Table(
                            children: [
                              TableRow(children: [
                                buildIconButton(Icons.backspace_outlined,
                                    color: AppColors.error,
                                    iconcolor: AppColors.base100,
                                    onLongPressed: () => _updateText('clear'),
                                    onPressed: () => _updateText('backspace'))
                              ]),
                              TableRow(children: [
                                _operatorPressed
                                    ? buildIconButton(Icons.calculate,
                                        onPressed: () => _updateText('equals'),
                                        height: 3,
                                        color: AppColors.accent,
                                        iconcolor: AppColors.base100)
                                    : buildIconButton(Icons.check,
                                        onPressed: () => {_addGoal(goal: goal, amount: amountStringToDouble(_text))},
                                        height: 3,
                                        color: AppColors.primary,
                                        iconcolor: AppColors.base100),
                              ]),
                            ],
                          );
                        }
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

Widget buildTextButton(String text, {required VoidCallback onPressed}) {
  return Container(
    margin: const EdgeInsets.all(4),
    child: Material(
      color: AppColors.base100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          onPressed();
          HapticFeedback.lightImpact();
        },
        splashColor: AppColors.primary.withOpacity(0.3),
        highlightColor: AppColors.primary.withOpacity(0.3),
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

Widget buildIconButton(
  IconData icon, {
  double height = 1.0,
  Color color = Colors.white,
  Color iconcolor = Colors.black,
  required VoidCallback onPressed,
  VoidCallback? onLongPressed,
}) {
  return Container(
    margin: const EdgeInsets.all(4),
    child: Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onLongPress: onLongPressed,
        onTap: () {
          onPressed();
          HapticFeedback.mediumImpact();
        },
        splashColor: AppColors.primary.withOpacity(0.3),
        highlightColor: AppColors.primary.withOpacity(0.3),
        child: SizedBox(
          height: 64 * height + ((height - 1) * 8),
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
