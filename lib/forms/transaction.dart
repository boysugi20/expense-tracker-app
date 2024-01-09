import 'package:dotted_border/dotted_border.dart';
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

  const TransactionForm(
      {required this.header1, this.header2 = '', this.initialValues, Key? key})
      : super(key: key);

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
        category: widget.initialValues!.category));
  }

  Future<void> deleteTransaction() async {
    context
        .read<TransactionBloc>()
        .add(DeleteTransaction(transaction: widget.initialValues!));
  }

  void showTagDialog(temp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Tags'),
          content: temp.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: MultiSelectContainer(
                    onChange: (allSelectedItems, selectedItem) {
                      setState(() {
                        selectedTags = allSelectedItems.cast<Tag>().toList();
                      });
                      widget.initialValues!.tags = selectedTags;
                    },
                    items: temp,
                    itemsDecoration: MultiSelectDecorations(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.accent),
                          borderRadius: BorderRadius.circular(5)),
                      selectedDecoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(5)),
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

    List<MultiSelectCard> temp = tags.map((tag) {
      String? tagName = tag.name;
      bool isTagSelected =
          selectedTags.any((selectedTag) => selectedTag.name == tagName);

      return MultiSelectCard(
        value: tag,
        label: tagName,
        selected: isTagSelected,
      );
    }).toList();

    showTagDialog(temp);
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
              initalText:
                  DateFormat('dd MMM yyyy').format(widget.initialValues!.date),
              onSave: (value) {
                widget.initialValues!.date =
                    DateFormat('dd MMM yyyy').parse(value!);
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
                              style: TextStyle(
                                  color: getTextColorForBackground(
                                      hexToColor(tag.color))),
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 6,
                        ),
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Edit Tag',
                                  style: TextStyle(
                                      color: AppColors.black, fontSize: 12)),
                              Container(
                                width: 4,
                              ),
                              Icon(Icons.edit, color: AppColors.black, size: 12)
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
