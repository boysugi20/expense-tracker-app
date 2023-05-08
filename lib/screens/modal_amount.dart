import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';


class BottomModalAmmount extends StatefulWidget {

  final String categoryText;

  const BottomModalAmmount({required this.categoryText, Key? key}) : super(key: key);

  @override
  State<BottomModalAmmount> createState() => _BottomModalAmmountState();
}

class _BottomModalAmmountState extends State<BottomModalAmmount> {

  String _text = '';
  String? lastOperation;
  String tempValueTarget = '';
  String tempValueOperator = '';
  int tempOperator = 0;
  bool _operatorPressed = false;
  bool _lastInputIsOperator = false;

  DateTime selectedDate = DateTime.now();

  final TextEditingController _notesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2500),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.main, // header background color
              onPrimary: AppColors.white, // header text color
              onSurface: AppColors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String addThousandSeperatorToString (String string) {

    String result;

    result = string.replaceAll(",", "").replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return result;
  }

  void _updateText(String value) {
    setState(() {
      // If input is backspace
      if (value == 'backspace') {
        if (_text.isNotEmpty){
          _text = addThousandSeperatorToString(_text.substring(0, _text.length - 1));
        }
        if (_text.endsWith('.')) {
          _text = _text.replaceAll('.', '');
        }
      }
      // If input is enter
      else if (value == 'enter') {
        // Save to database
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

  void handleCheckButtonPressed(String text, String notes, String category, DateTime date) {
    // Do something with the parameters
    print('Text: $text');
    print('Notes: $notes');
    print('Category: $category');
    print('Date: $date');
    Navigator.pop(context);
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
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.pop(context);
                  openBottomModalCategory(context);
              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 16,
                        child: Text(widget.categoryText.isNotEmpty ? widget.categoryText.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : ""),
                      ),
                    ),
                    RichText(text: TextSpan(text: widget.categoryText, style: TextStyle(color: AppColors.white))),
                  ],
                ),
              ),
              Divider(
                color: AppColors.white,
                indent: 20,
                endIndent: 20,
                height: 36,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: RichText(text: TextSpan(text: DateFormat('dd MMM yyyy').format(selectedDate), style: TextStyle(color: AppColors.white))),
              ),
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
                      TextSpan(text: 'Rp ', style: TextStyle(color: AppColors.main, fontWeight: FontWeight.bold)),
                      TextSpan(text: _text.isNotEmpty ? _text : '0', style: TextStyle(color: AppColors.black)),
                    ]
                  )
                ),
              ),
              Container(
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
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            _buildButton('+', onPressed: () => _updateText('+')),
                            _buildButton('7', onPressed: () => _updateText('7')),
                            _buildButton('8', onPressed: () => _updateText('8')),
                            _buildButton('9', onPressed: () => _updateText('9')),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildButton('-', onPressed: () => _updateText('-')),
                            _buildButton('4', onPressed: () => _updateText('4')),
                            _buildButton('5', onPressed: () => _updateText('5')),
                            _buildButton('6', onPressed: () => _updateText('6')),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildButton('x', onPressed: () => _updateText('x')),
                            _buildButton('1', onPressed: () => _updateText('1')),
                            _buildButton('2', onPressed: () => _updateText('2')),
                            _buildButton('3', onPressed: () => _updateText('3')),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildButton('/', onPressed: () => _updateText('/')),
                            _buildButton('.', onPressed: () => _updateText('.')),
                            _buildButton('0', onPressed: () => _updateText('0')),
                            _buildButton('000', onPressed: () => _updateText('000')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.18,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            _buildIconButton(Icons.backspace, onPressed: () => _updateText('backspace'))
                          ]
                        ),
                        TableRow(
                          children: [
                            _buildIconButton(Icons.calendar_today, onPressed: () => _selectDate(context)),
                          ]
                        ),
                        TableRow(
                          children: [
                            _operatorPressed ? 
                              _buildIconButton(
                                Icons.calculate, 
                                onPressed: () => _updateText('equals'), 
                                height: 2, color: AppColors.accent, iconcolor: AppColors.white
                              )
                              :
                              _buildIconButton(
                                Icons.check, 
                                onPressed: () => handleCheckButtonPressed(_text, _notesController.text, widget.categoryText, selectedDate),
                                height: 2, color: AppColors.accent, iconcolor: AppColors.white
                              ),
                          ]
                        ),
                      ],
                    ),
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

Widget _buildButton(String text, {required void Function() onPressed}) {
  return Container(
    height: 64,
    width: 64,
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
    child: InkWell(
      onTap: onPressed,
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
  );
}

Widget _buildIconButton(IconData icon, {double height = 1.0, Color color = Colors.white, Color iconcolor = Colors.black, void Function() onPressed = _defaultOnPressed}) {
  return Container(
    height: 64 * height + ((height-1) * 8),
    width: 64,
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
    child: InkWell(
      onTap: onPressed,
      child: Center(
        child: Icon(
          icon,
          size: 24,
          color: iconcolor,
        ),
      ),
    ),
  );
}

void _defaultOnPressed() {}