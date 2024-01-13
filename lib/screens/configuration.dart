import 'dart:convert';

import 'package:expense_tracker/bloc/expenseCategory/expenseCategory_bloc.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/bloc/subscription/subscription_bloc.dart';
import 'package:expense_tracker/bloc/tag/tag_bloc.dart';
import 'package:expense_tracker/forms/subscription.dart';
import 'package:expense_tracker/forms/tag.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/forms/expenseCategory.dart';
import 'package:expense_tracker/forms/goals.dart';
import 'package:expense_tracker/models/expenseCategory.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';

import '../bloc/incomeCategory/incomeCategory_bloc.dart';
import '../forms/incomeCategory.dart';
import '../models/incomeCategory.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24, bottom: 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            text: 'Goals:',
            firstChild: true,
            button: AddButton(
              text: 'Add +',
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GoalsForm(
                            header1: 'Add Goal',
                            header2: 'Add a new goal',
                          )),
                );
              },
            ),
          ),
          BlocBuilder<GoalBloc, GoalState>(
            builder: (context, state) {
              if (state is GoalInitial || state is GoalUpdated) {
                context.read<GoalBloc>().add(const GetGoals());
              }
              if (state is GoalLoaded) {
                if (state.goal.isNotEmpty) {
                  return Column(
                    children: state.goal.map((goalItem) => GoalsCard(goal: goalItem)).toList(),
                  );
                }
              }
              return const NoDataWidget();
            },
          ),
          SectionTitle(
            text: 'Recurring Transaction:',
            button: AddButton(
              text: 'Add +',
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SubscriptionForm(
                            header1: 'Add Subcription',
                            header2: 'Add a new subscription',
                          )),
                );
              },
            ),
          ),
          BlocBuilder<SubscriptionBloc, SubscriptionState>(
            builder: (context, state) {
              if (state is SubscriptionInitial || state is SubscriptionUpdated) {
                context.read<SubscriptionBloc>().add(const GetSubscriptions());
              }
              if (state is SubscriptionLoaded) {
                if (state.subscription.isNotEmpty) {
                  return Column(
                    children: state.subscription
                        .map((subscriptionItem) => SubscriptionCard(subscription: subscriptionItem))
                        .toList(),
                  );
                }
              }
              return const NoDataWidget();
            },
          ),
          SectionTitle(
            text: 'Tags:',
            button: AddButton(
              text: 'Add +',
              onPressed: (context) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TagsForm(
                            header1: 'Add Tag',
                            header2: 'Add a new tag',
                          )),
                );
              },
            ),
          ),
          BlocBuilder<TagBloc, TagState>(
            builder: (context, state) {
              if (state is TagInitial || state is TagUpdated) {
                context.read<TagBloc>().add(const GetTags());
              }
              if (state is TagLoaded) {
                if (state.tag.isNotEmpty) {
                  return Column(
                    children: state.tag.map((tagItem) => TagCard(tag: tagItem)).toList(),
                  );
                }
              }
              return const NoDataWidget();
            },
          ),
          SectionTitle(
            text: 'Expense Categories:',
            button: AddButton(
              text: 'Add +',
              onPressed: (context) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExpenseCategoriesForm(
                            header1: 'Add Expense Category',
                            header2: 'Add a new expense category',
                          )),
                );
              },
            ),
          ),
          BlocBuilder<ExpenseCategoryBloc, ExpenseCategoryState>(
            builder: (context, state) {
              if (state is ExpenseCategoryInitial || state is ExpenseCategoryUpdated) {
                context.read<ExpenseCategoryBloc>().add(const GetExpenseCategories());
              }
              if (state is ExpenseCategoryLoaded) {
                if (state.category.isNotEmpty) {
                  return Column(
                    children:
                        state.category.map((categoryItem) => ExpenseCategoriesCard(category: categoryItem)).toList(),
                  );
                }
              }
              return const NoDataWidget();
            },
          ),
          SectionTitle(
            text: 'Income Categories:',
            button: AddButton(
              text: 'Add +',
              onPressed: (context) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IncomeCategoriesForm(
                            header1: 'Add Income Category',
                            header2: 'Add a new income category',
                          )),
                );
              },
            ),
          ),
          BlocBuilder<IncomeCategoryBloc, IncomeCategoryState>(
            builder: (context, state) {
              if (state is IncomeCategoryInitial || state is IncomeCategoryUpdated) {
                context.read<IncomeCategoryBloc>().add(const GetIncomeCategories());
              }
              if (state is IncomeCategoryLoaded) {
                if (state.category.isNotEmpty) {
                  return Column(
                    children:
                        state.category.map((categoryItem) => IncomeCategoriesCard(category: categoryItem)).toList(),
                  );
                }
              }
              return const NoDataWidget();
            },
          ),
        ],
      ),
    );
  }
}

class ExpenseCategoriesCard extends StatelessWidget {
  final ExpenseCategory category;

  const ExpenseCategoriesCard({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExpenseCategoriesForm(
                    header1: 'Edit Expense Category',
                    header2: 'Edit existing expense category',
                    initialValues: category.copyWith(),
                  )),
        );
      },
      child: CardContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: category.icon != null
                        ? Icon(
                            deserializeIcon(jsonDecode(category.icon!)),
                            color: AppColors.primary,
                          )
                        : Text(
                            category.name.isNotEmpty
                                ? category.name.split(" ").map((e) => e[0]).take(2).join().toUpperCase()
                                : "",
                            style: TextStyle(color: AppColors.primary),
                          ),
                  ),
                ),
                RichText(
                  text: TextSpan(text: category.name, style: const TextStyle(color: Colors.black)),
                ),
              ],
            ),
            // Icon(Icons.edit, color: AppColors.neutral, size: 16,)
          ],
        ),
      ),
    );
  }
}

class IncomeCategoriesCard extends StatelessWidget {
  final IncomeCategory category;

  const IncomeCategoriesCard({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IncomeCategoriesForm(
                    header1: 'Edit Income Category',
                    header2: 'Edit existing income category',
                    initialValues: category.copyWith(),
                  )),
        );
      },
      child: CardContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: category.icon != null
                        ? Icon(
                            deserializeIcon(jsonDecode(category.icon!)),
                            color: AppColors.primary,
                          )
                        : Text(
                            category.name.isNotEmpty
                                ? category.name.split(" ").map((e) => e[0]).take(2).join().toUpperCase()
                                : "",
                            style: TextStyle(color: AppColors.primary),
                          ),
                  ),
                ),
                RichText(
                  text: TextSpan(text: category.name, style: const TextStyle(color: Colors.black)),
                ),
              ],
            ),
            // Icon(Icons.edit, color: AppColors.neutral, size: 16,)
          ],
        ),
      ),
    );
  }
}

class TagCard extends StatelessWidget {
  final Tag tag;

  const TagCard({required this.tag, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TagsForm(
                    header1: 'Edit Tag',
                    header2: 'Edit existing tag',
                    initialValues: tag.copyWith(),
                  )),
        );
      },
      child: CardContainer(
        paddingBottom: 16,
        paddingTop: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(text: tag.name, style: const TextStyle(color: Colors.black)),
            ),
            Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hexToColor(tag.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalsCard extends StatelessWidget {
  final Goal goal;

  const GoalsCard({required this.goal, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GoalsForm(
                    header1: 'Edit Goal',
                    header2: 'Edit existing goal',
                    initialValues: goal.copyWith(),
                  )),
        );
      },
      child: CardContainer(
        color: AppColors.primary,
        paddingBottom: 16,
        paddingTop: 16,
        marginBottom: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.name,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 8,
                ),
                Text(
                  'Rp ${amountDoubleToString(goal.totalAmount)}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            // Icon(Icons.edit, color: AppColors.base100, size: 16,)
          ],
        ),
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final double amount;

  const BudgetCard({required this.amount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        color: AppColors.primary,
        paddingBottom: 16,
        paddingTop: 16,
        marginBottom: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp ${amountDoubleToString(amount)}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            // Icon(Icons.edit, color: AppColors.base100, size: 16,)
          ],
        ));
  }
}

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionCard({required this.subscription, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubscriptionForm(
                  header1: 'Edit Subsciprtion', header2: 'Edit existing subscription', initialValues: subscription)),
        );
      },
      child: CardContainer(
        color: AppColors.primary,
        paddingBottom: 18,
        paddingTop: 18,
        paddingLeft: 16,
        paddingRight: 16,
        marginBottom: 6,
        useBorder: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 8,
                ),
                Text(
                  '${dateToString(subscription.startDate)} - ${dateToString(subscription.endDate)}',
                  style: TextStyle(color: AppColors.base100, fontSize: 11),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rp ${amountDoubleToString(subscription.amount)}',
                  style: TextStyle(color: AppColors.base100),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
