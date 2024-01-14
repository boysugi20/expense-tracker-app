import 'package:expense_tracker/bloc/subscription/subscription_bloc.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/forms/template.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';

class SubscriptionForm extends StatefulWidget {
  final Subscription? initialValues;
  final String header1, header2;

  const SubscriptionForm({required this.header1, this.header2 = '', this.initialValues, Key? key}) : super(key: key);

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();

  Subscription subscription =
      Subscription(id: 0, name: '', amount: 0, startDate: DateTime.now(), endDate: DateTime.now(), paymentDay: 1);

  bool datePicked = false;
  List<DateTime?> dateTimeRange = [
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
  ];

  List<int> dayList = List<int>.generate(31, (index) => index + 1);
  int dayDropdown = 1;

  Future<void> insertSubscription() async {
    if (subscription.name.isNotEmpty) {
      context.read<SubscriptionBloc>().add(AddSubscription(subscription: subscription));
    }
  }

  Future<void> updateSubscription() async {
    context.read<SubscriptionBloc>().add(UpdateSubscription(subscription: subscription));
  }

  Future<void> deleteSubscription() async {
    context.read<SubscriptionBloc>().add(DeleteSubscription(subscription: subscription));
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      subscription = widget.initialValues!;
      dayDropdown = subscription.paymentDay;
      dateTimeRange = [subscription.startDate, subscription.endDate];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      formKey: _formKey,
      header1: widget.header1,
      header2: widget.header2,
      onSave: () {
        widget.initialValues == null ? insertSubscription() : updateSubscription();
      },
      onDelete: () {
        deleteSubscription();
      },
      formInputs: Form(
        key: _formKey,
        child: Column(
          children: [
            FormTextInput(
                title: 'Name',
                labelText: 'Subscription name',
                charLimit: 16,
                isRequired: true,
                initalText: subscription.name,
                validateText: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some value';
                  }
                  return null;
                },
                onSave: (value) {
                  subscription.name = value!;
                }),
            FormTextInput(
                title: 'Monthly Amount',
                labelText: 'Monthly transaction amount',
                isRequired: true,
                initalText: subscription.amount != 0 ? amountDoubleToString(subscription.amount) : '',
                isKeypad: true,
                useThousandSeparator: true,
                validateText: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some value';
                  }
                  return null;
                },
                onSave: (value) {
                  subscription.amount = amountStringToDouble(value!);
                }),
            FormDateRangeInput(
              title: 'Date Range',
              labelText: 'Transaction date',
              isRequired: true,
              initalText: dateRangeToString(dateTimeRange),
              dateTimeRange: dateTimeRange,
              onSave: (value) {
                DateTimeRange? dateRange = stringToDateRange(value!);
                subscription.startDate = dateRange!.start;
                subscription.endDate = dateRange.end;
              },
            ),
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: const TextSpan(text: 'Payment day', style: TextStyle(color: Colors.black, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
                CardContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Payment Day:'),
                      DropdownButton<int>(
                        value: dayDropdown,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: TextStyle(color: AppColors.primary),
                        onChanged: (int? value) {
                          subscription.paymentDay = value!;
                          setState(() {
                            dayDropdown = value;
                          });
                        },
                        items: dayList.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
