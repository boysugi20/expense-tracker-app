import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final bool firstChild;
  final bool useBottomMargin;
  final Widget? button;

  const SectionTitle({required this.text, this.firstChild = false, this.useBottomMargin = true, this.button, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: useBottomMargin ? 12 : 0,
        top: firstChild ? 0 : 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(text: text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          if (button != null) button!,
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final String text;
  final Function(BuildContext)? onPressed;

  const AddButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed != null
          ? () {
              onPressed!(context);
            }
          : () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.base200),
                color: AppColors.base100,
                borderRadius: BorderRadius.circular(2)),
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Center(
              child: RichText(
                text: TextSpan(text: text, style: TextStyle(color: AppColors.primary, fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormTextInput extends StatefulWidget {
  final String title, initalText;
  final String? helperText, labelText;
  final bool isKeypad, useThousandSeparator, isRequired;
  final void Function(String?)? onSave;
  final String? Function(String?)? validateText;
  final int? charLimit;

  const FormTextInput(
      {required this.title,
      this.helperText,
      this.labelText,
      this.isKeypad = false,
      this.useThousandSeparator = false,
      this.onSave,
      this.initalText = '',
      this.validateText,
      this.isRequired = false,
      this.charLimit,
      Key? key})
      : super(key: key);

  @override
  State<FormTextInput> createState() => _FormTextInputState();
}

class _FormTextInputState extends State<FormTextInput> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.initalText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.isRequired
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: const TextSpan(text: '*', style: TextStyle(color: Colors.red, fontSize: 14)),
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                  text: TextSpan(text: widget.title, style: const TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ],
          ),
          Material(
              color: Colors.transparent,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                maxLength: widget.charLimit,
                onSaved: widget.onSave,
                controller: _textController,
                keyboardType: widget.isKeypad ? TextInputType.number : TextInputType.text,
                inputFormatters: widget.useThousandSeparator
                    ? [FilteringTextInputFormatter.digitsOnly, ThousandsSeparatorInputFormatter()]
                    : [],
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.base100,
                    helperText: widget.helperText,
                    hintText: widget.labelText,
                    hintStyle: TextStyle(color: AppColors.base300, fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.base300.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.accent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)),
                validator: widget.validateText,
              )),
        ],
      ),
    );
  }
}

class FormDateInput extends StatefulWidget {
  final String title, initalText;
  final String? helperText, labelText;
  final bool isRequired;
  final void Function(String?)? onSave;
  final String? Function(String?)? validateText;

  const FormDateInput(
      {required this.title,
      this.helperText,
      this.labelText,
      this.onSave,
      this.initalText = '',
      this.validateText,
      this.isRequired = false,
      Key? key})
      : super(key: key);

  @override
  State<FormDateInput> createState() => _FormDateInputState();
}

class _FormDateInputState extends State<FormDateInput> {
  final _textController = TextEditingController();

  Future<void> _showDatePicker(BuildContext context) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayTextStyle: TextStyle(color: AppColors.base100, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: AppColors.accent,
      ),
      dialogSize: const Size(325, 400),
      value: [DateFormat('dd MMM yyyy').parse(_textController.text)],
      borderRadius: BorderRadius.circular(15),
    );

    if (results != null) {
      setState(() {
        _textController.text = DateFormat('dd MMM yyyy').format(results[0]!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _textController.text = widget.initalText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.isRequired
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: const TextSpan(text: '*', style: TextStyle(color: Colors.red, fontSize: 14)),
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                  text: TextSpan(text: widget.title, style: const TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ],
          ),
          Material(
              child: TextFormField(
            readOnly: true,
            onTap: () => {_showDatePicker(context)},
            onSaved: widget.onSave,
            controller: _textController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.base100,
              helperText: widget.helperText,
              hintText: widget.labelText,
              hintStyle: TextStyle(color: AppColors.base300, fontSize: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.base300.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              prefixIcon: Icon(
                Icons.calendar_month,
                color: AppColors.base300,
              ),
            ),
            validator: widget.validateText,
          )),
        ],
      ),
    );
  }
}

class FormDateRangeInput extends StatefulWidget {
  final String title, initalText;
  final String? helperText, labelText;
  final bool isRequired;
  final void Function(String?)? onSave;
  final String? Function(String?)? validateText;
  final List<DateTime?> dateTimeRange;

  const FormDateRangeInput(
      {required this.title,
      required this.dateTimeRange,
      this.helperText,
      this.labelText,
      this.onSave,
      this.initalText = '',
      this.validateText,
      this.isRequired = false,
      Key? key})
      : super(key: key);

  @override
  State<FormDateRangeInput> createState() => _FormDateRangeInput();
}

class _FormDateRangeInput extends State<FormDateRangeInput> {
  final _textController = TextEditingController();

  Future<void> _selectDateRange(BuildContext context) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayTextStyle: TextStyle(color: AppColors.base100, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: AppColors.accent,
      ),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value: widget.dateTimeRange,
    );

    if (results != null && results.length == 2) {
      setState(() {
        _textController.text = dateRangeToString(results);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _textController.text = widget.initalText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.isRequired
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: const TextSpan(text: '*', style: TextStyle(color: Colors.red, fontSize: 14)),
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                  text: TextSpan(text: widget.title, style: const TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ],
          ),
          Material(
              child: TextFormField(
            readOnly: true,
            onTap: () => {_selectDateRange(context)},
            onSaved: widget.onSave,
            controller: _textController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.base100,
              helperText: widget.helperText,
              hintText: widget.labelText,
              hintStyle: TextStyle(color: AppColors.base300, fontSize: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.base300.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              prefixIcon: Icon(
                Icons.calendar_month,
                color: AppColors.base300,
              ),
            ),
            validator: widget.validateText,
          )),
        ],
      ),
    );
  }
}

class FormIconInput extends StatefulWidget {
  final String title;
  final String? initialIcon;
  final String? helperText, labelText;
  final bool isRequired;
  final void Function(String?)? onSave;
  final String? Function(String?)? validateText;

  const FormIconInput(
      {required this.title,
      this.helperText,
      this.labelText,
      this.onSave,
      this.initialIcon,
      this.validateText,
      this.isRequired = false,
      Key? key})
      : super(key: key);

  @override
  State<FormIconInput> createState() => _FormIconInputState();
}

class _FormIconInputState extends State<FormIconInput> {
  Icon? _icon;
  String? iconText;

  String _formatString(IconData icon) {
    String formattedString = serializeIcon(icon).toString().replaceAllMapped(
          RegExp(r'(\w+):\s?(\w+)'),
          (match) => '"${match.group(1)}": "${match.group(2)}"',
        );

    return formattedString;
  }

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        showTooltips: true,
        closeChild: Text('Close', style: TextStyle(color: AppColors.accent)),
        searchIcon: Icon(
          Icons.search,
          color: AppColors.accent,
        ));
    _icon = Icon(
      icon,
      color: AppColors.primary,
      size: 32,
    );

    if (icon != null) {
      setState(() {
        _icon = _icon;
        iconText = _formatString(icon);
      });

      if (widget.onSave != null) {
        widget.onSave!(iconText);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialIcon != null) {
      setState(() {
        _icon = Icon(
          deserializeIcon(jsonDecode(widget.initialIcon!)),
          color: AppColors.primary,
        );
        iconText = widget.initialIcon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.isRequired
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: const TextSpan(text: '*', style: TextStyle(color: Colors.red, fontSize: 14)),
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                  text: TextSpan(text: widget.title, style: const TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.base200),
                    ),
                    child: CircleAvatar(backgroundColor: Colors.grey.shade200, radius: 24, child: _icon),
                  ),
                  RichText(
                    text: iconText != null
                        ? TextSpan(
                            text: jsonDecode(iconText!)['key'].toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 11))
                        : const TextSpan(text: '_', style: TextStyle(color: Colors.black, fontSize: 11)),
                  ),
                ],
              ),
              Container(
                width: 12,
              ),
              ElevatedButton(
                onPressed: _pickIcon,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                ),
                child: const Text(
                  'Choose Icon',
                  style: TextStyle(fontSize: 11),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    int value = int.parse(newValue.text.replaceAll(',', ''));
    String newText = NumberFormat('#,###').format(value);
    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}

class NoDataWidget extends StatelessWidget {
  final String text;

  const NoDataWidget({this.text = '', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: text == ''
            ? Text(
                'No Data',
                style: TextStyle(color: AppColors.base300),
              )
            : Text(
                text,
                style: TextStyle(color: AppColors.base300),
              ),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  final Widget child;
  final Color? color, borderColor;
  final bool useBorder;
  final double marginLeft, marginRight, marginTop, marginBottom;
  final double paddingLeft, paddingRight, paddingTop, paddingBottom;
  final double? height;

  const CardContainer({
    Key? key,
    required this.child,
    this.useBorder = true,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginTop = 0,
    this.marginBottom = 8,
    this.paddingLeft = 16,
    this.paddingRight = 16,
    this.paddingTop = 8,
    this.paddingBottom = 8,
    this.height,
    this.borderColor,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(left: marginLeft, right: marginRight, top: marginTop, bottom: marginBottom),
      padding: EdgeInsets.only(left: paddingLeft, right: paddingRight, top: paddingTop, bottom: paddingBottom),
      decoration: BoxDecoration(
          border: useBorder ? Border.all(color: borderColor ?? AppColors.base300.withOpacity(0.5)) : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: color ?? AppColors.base100),
      child: child,
    );
  }
}
