import 'package:expense_tracker/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:intl/intl.dart';

import '../database/tag_dao.dart';
import '../models/tag.dart';
import '../styles/color.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? initialValues;
  final String header1, header2;

  const TransactionForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late List<Tag> selectedTags;

  @override
  void initState() {
    super.initState();
    selectedTags = widget.initialValues?.tags ?? [];
  }

  Future<void> updateTransaction() async {
    context.read<TransactionBloc>().add(UpdateTransaction(
        transaction: widget.initialValues!,
        expenseCategory: widget.initialValues!.expenseCategory,
        incomeCategory: widget.initialValues!.incomeCategory));
  }

  Future<void> deleteTransaction() async {
    context.read<TransactionBloc>().add(DeleteTransaction(transaction: widget.initialValues!));
  }

  void showTagDialog(tagsTemp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Tags'),
          content: tagsTemp.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: MultiSelectContainer(
                    onChange: (allSelectedItems, selectedItem) {
                      setState(() {
                        selectedTags = allSelectedItems.cast<Tag>().toList();
                      });
                      widget.initialValues!.tags = selectedTags;
                    },
                    items: tagsTemp,
                    itemsDecoration: MultiSelectDecorations(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(5)),
                      selectedDecoration:
                          BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(5)),
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
                style: TextStyle(color: AppColors.primary),
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
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1,
      header2: widget.header2,
      buttonText: widget.initialValues == null ? null : '',
      onSave: () {
        updateTransaction();
      },
      onDelete: () {
        deleteTransaction();
      },
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
              charLimit: 50,
              initalText: widget.initialValues!.note!,
              onSave: (value) {
                widget.initialValues!.note = value!;
              },
            ),
            Container(
                margin: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var tag in selectedTags)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color: hexToColor(tag.color),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: Text(
                              tag.name,
                              style: TextStyle(color: getTextColorForBackground(hexToColor(tag.color))),
                            ),
                          ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        openTagPopup(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 14),
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Edit Tag', style: TextStyle(color: AppColors.primary)),
                              Container(
                                width: 4,
                              ),
                              Icon(Icons.edit, color: AppColors.primary, size: 14)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
