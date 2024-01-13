import 'dart:io';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:expense_tracker/bloc/expenseCategory/expenseCategory_bloc.dart';
import 'package:expense_tracker/bloc/incomeCategory/incomeCategory_bloc.dart';
import 'package:expense_tracker/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracker/database/expenseCategory_dao.dart';
import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/database/incomeCategory_dao.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/models/expenseCategory.dart';
import 'package:expense_tracker/models/incomeCategory.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreSettingPage extends StatefulWidget {
  const MoreSettingPage({Key? key}) : super(key: key);

  @override
  State<MoreSettingPage> createState() => _MoreSettingPageState();
}

class _MoreSettingPageState extends State<MoreSettingPage> {
  void _addTransactionDB(Object category, DateTime date, double amount, String note) {
    if (category is ExpenseCategory) {
      context.read<TransactionBloc>().add(AddTransaction(
          transaction:
              Transaction(id: 0, expenseCategory: category, date: date, amount: amount, note: note, tags: [])));
    } else if (category is IncomeCategory) {
      context.read<TransactionBloc>().add(AddTransaction(
          transaction: Transaction(id: 0, incomeCategory: category, date: date, amount: amount, note: note, tags: [])));
    }
  }

  Future<void> _insertExpenseCategory(ExpenseCategory expenseCategory, void Function(ExpenseCategory) callback) async {
    final categoryState = context.read<ExpenseCategoryBloc>().state;
    if (categoryState is ExpenseCategoryLoaded) {
      final List<ExpenseCategory> categories = categoryState.category;
      final existingCategory = categories.firstWhereOrNull((category) => category.name == expenseCategory.name);
      if (existingCategory == null) {
        final insertedId = await ExpenseCategoryDAO.insertExpenseCategory(expenseCategory);
        final updatedCategory = expenseCategory.copyWith(id: insertedId);
        if (context.mounted) {
          context.read<ExpenseCategoryBloc>().add(AddExpenseCategory(category: updatedCategory));
        }
        callback(updatedCategory);
      } else {
        callback(existingCategory);
      }
    }
  }

  Future<void> _insertIncomeCategory(IncomeCategory incomeCategory, void Function(IncomeCategory) callback) async {
    final categoryState = context.read<IncomeCategoryBloc>().state;
    if (categoryState is IncomeCategoryLoaded) {
      final List<IncomeCategory> categories = categoryState.category;
      final existingCategory = categories.firstWhereOrNull((category) => category.name == incomeCategory.name);
      if (existingCategory == null) {
        final insertedId = await IncomeCategoryDAO.insertIncomeCategory(incomeCategory);
        final updatedCategory = incomeCategory.copyWith(id: insertedId);
        if (context.mounted) {
          context.read<IncomeCategoryBloc>().add(AddIncomeCategory(category: updatedCategory));
        }
        callback(updatedCategory);
      } else {
        callback(existingCategory);
      }
    }
  }

  void _exportTransToCSV(BuildContext context) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    late final Map<Permission, PermissionStatus> statusess;

    if (androidInfo.version.sdkInt <= 32) {
      statusess = await [
        Permission.storage,
      ].request();
    } else {
      statusess = await [Permission.notification].request();
    }

    var allAccepted = true;
    statusess.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
    });

    if (allAccepted) {
      String? saveDirectory = await FilePicker.platform.getDirectoryPath();
      if (saveDirectory != null) {
        DatabaseHelper db = DatabaseHelper();
        var queryResult = await db.accessDatabase('''
              SELECT 
                A.amount, strftime("%Y-%m-%d %H:%M:%S", A.date) AS date, A.note, 
                COALESCE(B.name, C.name) AS category,
                CASE
                  WHEN B.name IS NOT NULL THEN 'Expense'
                  ELSE 'Income'
                END AS type
              FROM 
                Transactions AS A 
                LEFT JOIN ExpenseCategories AS B 
                  ON A.expenseCategoryID = B.id
                LEFT JOIN IncomeCategories AS C 
                  ON A.incomeCategoryID = C.id
            ''');

        List<String> csvData = [];
        // Add headers to the CSV data
        csvData.add(queryResult[0].keys.join(','));
        // Add rows to the CSV data
        for (var row in queryResult) {
          csvData.add(row.values.map((value) => value.toString()).join(','));
        }
        String csvString = csvData.join('\n');

        // final downloadPath = await getDownloadPath();
        String currentDate = DateFormat('yyyyMMdd').format(DateTime.now());
        String fileName = 'TransactionData_$currentDate.csv';

        final filepath = '$saveDirectory${Platform.pathSeparator}$fileName';

        try {
          // Save the CSV data to a file
          File file = File(filepath);
          await file.writeAsString(csvString, mode: FileMode.write);

          if (context.mounted) {
            _showPopup(context, 'Export Success', 'CSV file exported');
          }
          // NotificationService.showNotification(title: 'Success', body: 'CSV file exported', fln: flutterLocalNotificationsPlugin);
        } catch (e) {
          if (context.mounted) {
            _showPopup(context, 'Export Failed', 'CSV file failed to export');
          }
        }
      } else {
        if (context.mounted) {
          _showPopup(context, 'Export Failed', 'CSV file failed to export');
        }
      }
    }
  }

  void _importTransFromCSV(BuildContext context) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    late final Map<Permission, PermissionStatus> statusess;

    if (androidInfo.version.sdkInt <= 32) {
      statusess = await [
        Permission.storage,
      ].request();
    } else {
      statusess = await [Permission.notification].request();
    }

    var allAccepted = true;
    statusess.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
    });

    if (allAccepted) {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        final lines = await file.readAsLines();

        final header = lines[0].replaceAll(';', ',').split(',');

        List<Map> listOfMap = [];

        for (var i = 1; i < lines.length; i++) {
          final values = lines[i].replaceAll(';', ',').split(',');
          var map = {};
          for (var j = 0; j < header.length; j++) {
            map[header[j]] = values[j];
          }

          if (map['category'] != null && map['date'] != null && map['amount'] != null && map['note'] != null) {
            listOfMap.add(map);
          }
        }

        try {
          // Expense
          final List<ExpenseCategory> expenseCategories = await ExpenseCategoryDAO.getExpenseCategories();
          for (var i = 0; i < listOfMap.length; i++) {
            var map = listOfMap[i];

            ExpenseCategory? expenseCategory;
            for (ExpenseCategory temp in expenseCategories) {
              if (temp.name == map['category'] && map['type'] == 'Expense') {
                expenseCategory = temp;
                break;
              }
            }

            // If category exists
            if (expenseCategory != null) {
              _addTransactionDB(expenseCategory, DateTime.parse(map['date']), double.parse(map['amount']), map['note']);
            } else {
              ExpenseCategory newCategory = ExpenseCategory(id: 0, name: map['name']);
              _insertExpenseCategory(newCategory, (newCategory) {
                _addTransactionDB(newCategory, DateTime.parse(map['date']), double.parse(map['amount']), map['note']);
              });
            }
          }

          // Income
          final List<IncomeCategory> incomeCategories = await IncomeCategoryDAO.getIncomeCategories();
          for (var i = 0; i < listOfMap.length; i++) {
            var map = listOfMap[i];

            IncomeCategory? incomeCategory;
            for (IncomeCategory temp in incomeCategories) {
              if (temp.name == map['category'] && map['type'] == 'Income') {
                incomeCategory = temp;
                break;
              }
            }

            // If category exists
            if (incomeCategory != null) {
              _addTransactionDB(incomeCategory, DateTime.parse(map['date']), double.parse(map['amount']), map['note']);
            } else {
              IncomeCategory newCategory = IncomeCategory(id: 0, name: map['name']);

              _insertIncomeCategory(newCategory, (newCategory) {
                _addTransactionDB(newCategory, DateTime.parse(map['date']), double.parse(map['amount']), map['note']);
              });
            }
          }

          // Show notification
          if (context.mounted) {
            _showPopup(context, 'Import Success', 'Transaction data imported');
          }
        } catch (e) {
          if (context.mounted) {
            _showPopup(context, 'Import Failed', 'Transaction data import failed');
          }
        }
      }
    }
  }

  void _showPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final budgetTextController = TextEditingController();
  final userNameController = TextEditingController();

  bool budgetMode = true;
  double budgetAmount = 0;
  bool carryOver = true;

  List<String> weekList = <String>['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  String weekDropdown = 'Sunday';

  List<int> dayList = List<int>.generate(31, (index) => index + 1);
  int dayDropdown = 1;

  void initializeValues() async {
    bool? budgetModeValue = await getConfigurationBool('budget_mode');
    double? budgetAmountValue = await getConfigurationDouble('budget_amount');
    bool? carryOverValue = await getConfigurationBool('carry_over');

    String? weekDropdownValue = await getConfigurationString('first_day_week');
    int? dayDropdownValue = await getConfigurationInt('first_day_month');

    String? userName = await getConfigurationString('user_name');

    setState(() {
      budgetMode = budgetModeValue ?? true;
      budgetAmount = budgetAmountValue ?? 0;
      budgetTextController.text = budgetAmountValue != null ? amountDoubleToString(budgetAmount) : '0';
      userNameController.text = userName ?? '';
      carryOver = carryOverValue ?? true;
      weekDropdown = weekDropdownValue ?? 'Sunday';
      dayDropdown = dayDropdownValue ?? 1;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            text: 'Tools:',
            firstChild: true,
          ),
          GestureDetector(
            onTap: () {
              _exportTransToCSV(context);
            },
            child: const CardContainer(
              paddingBottom: 16,
              paddingTop: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Export transactions to CSV'), Icon(Icons.upload_rounded)],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _importTransFromCSV(context);
            },
            child: const CardContainer(
              paddingBottom: 16,
              paddingTop: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Import transactions from CSV'), Icon(Icons.download_rounded)],
              ),
            ),
          ),
          const SectionTitle(text: 'Settings:'),
          CardContainer(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Budget mode'),
                        Container(
                          width: 8,
                        ),
                        const Tooltip(
                            message: 'Enable this to calculate\nbalance from specified budget',
                            child: Icon(
                              Icons.info,
                              size: 16,
                            )),
                      ],
                    ),
                    Switch(
                      value: budgetMode,
                      activeColor: AppColors.primary,
                      onChanged: (bool value) {
                        saveConfiguration('budget_mode', !budgetMode);
                        setState(() {
                          budgetMode = !budgetMode;
                        });
                      },
                    ),
                  ],
                ),
                budgetMode
                    ? Column(
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Amount'),
                              Container(
                                width: 100,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: budgetTextController,
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (text) {
                                    saveConfiguration('budget_amount', amountStringToDouble(text));
                                  },
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: AppColors.primary),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    ThousandsSeparatorInputFormatter()
                                  ],
                                  decoration: InputDecoration(
                                    prefixText: 'Rp',
                                    isDense: true,
                                    hintStyle: TextStyle(color: AppColors.base300, fontSize: 12),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          CardContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('User name'),
                    Container(
                      width: 8,
                    ),
                  ],
                ),
                Container(
                  width: 80,
                ),
                Expanded(
                  child: TextFormField(
                    controller: userNameController,
                    onFieldSubmitted: (text) {
                      saveConfiguration('user_name', text);
                    },
                    textAlign: TextAlign.end,
                    style: TextStyle(color: AppColors.primary),
                    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // CardContainer(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           const Text('Carry over'),
          //           Container(
          //             width: 8,
          //           ),
          //           const Tooltip(
          //               message: 'Enable this to carryover\nremaining balance each month',
          //               child: Icon(
          //                 Icons.info,
          //                 size: 16,
          //               )),
          //         ],
          //       ),
          //       Switch(
          //         value: carryOver,
          //         activeColor: AppColors.primary,
          //         onChanged: (bool value) {
          //           saveConfiguration('carry_over', !carryOver);
          //           setState(() {
          //             carryOver = !carryOver;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          // CardContainer(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text('First day of the week'),
          //       DropdownButton<String>(
          //         value: weekDropdown,
          //         icon: const Icon(Icons.arrow_drop_down),
          //         elevation: 16,
          //         style: TextStyle(color: AppColors.primary),
          //         onChanged: (String? value) {
          //           saveConfiguration('first_day_week', value!);
          //           setState(() {
          //             weekDropdown = value;
          //           });
          //         },
          //         items: weekList.map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(value),
          //           );
          //         }).toList(),
          //       ),
          //     ],
          //   ),
          // ),
          // CardContainer(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text('First day of the month'),
          //       DropdownButton<int>(
          //         value: dayDropdown,
          //         icon: const Icon(Icons.arrow_drop_down),
          //         elevation: 16,
          //         style: TextStyle(color: AppColors.primary),
          //         onChanged: (int? value) {
          //           saveConfiguration('first_day_month', value!);
          //           setState(() {
          //             dayDropdown = value;
          //           });
          //         },
          //         items: dayList.map<DropdownMenuItem<int>>((int value) {
          //           return DropdownMenuItem<int>(
          //             value: value,
          //             child: Text(value.toString()),
          //           );
          //         }).toList(),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
