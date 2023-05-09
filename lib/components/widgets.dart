import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SectionTitle extends StatelessWidget {
  
  final String text;
  final bool firstChild;

  const SectionTitle({required this.text, this.firstChild = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: firstChild?const EdgeInsets.only(bottom: 12):const EdgeInsets.only(bottom: 12, top: 16),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
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
          : () {
              print("Add$text");
            },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        child: Center(
          child: RichText(
            text: TextSpan(
              text: text,
              style: TextStyle(color: AppColors.accent)
            ),
          ),
        ),
      ),
    );
  }
}


class FormTitle extends StatelessWidget {
  
  final String header1;
  final String? header2;

  const FormTitle({required this.header1, this.header2, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(text: header1, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
          ),
          header2 != null ?
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(text: header2, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 14)),
            ),
          )
          :
          Container(),
        ],
      ),
    );
  }
}


class FormTextInput extends StatefulWidget {

  final String title;
  final String? helperText, labelText;
  final bool isKeypad, useThousandSeparator;
  void Function(String?)? onSave;

  FormTextInput({required this.title, this.helperText, this.labelText, this.isKeypad = false, this.useThousandSeparator = false, this.onSave, Key? key}) : super(key: key);

  @override
  State<FormTextInput> createState() => _FormTextInputState();
}

class _FormTextInputState extends State<FormTextInput> {

  final _textController = TextEditingController();

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
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(text: widget.title, style: const TextStyle(color: Colors.black, fontSize: 14)),
            ),
          ),
          Material(
            child: TextFormField(
              onSaved: widget.onSave,
              controller: _textController,
              keyboardType: widget.isKeypad ? TextInputType.number : TextInputType.text,
              inputFormatters: widget.useThousandSeparator ? [FilteringTextInputFormatter.digitsOnly, ThousandsSeparatorInputFormatter()] : [],
              decoration: InputDecoration(
                helperText: widget.helperText,
                hintText: widget.labelText,
                hintStyle: TextStyle(color: AppColors.grey, fontSize: 12),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.cardBorder),),  
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.accent),),
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
              ),
          )),
        ],
      ),
    );
  }
}


class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    int value = int.parse(newValue.text.replaceAll(',', ''));
    String newText = NumberFormat('#,###').format(value);
    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}


class FormSubmitButton extends StatelessWidget {
  const FormSubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      margin: const EdgeInsets.only(top: 52, bottom: 100),
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(8)
      ),
      width: double.infinity,
      child: Center(
        child: RichText(
          text: const TextSpan(text: 'Save', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}