import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

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
  final void Function()? onPressed;

  const AddButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {
        print("Add$text");
      },
      child: Center(
        child: RichText(
          text: TextSpan(
            text: text,
            style: TextStyle(color: AppColors.accent)
          ),
        ),
      ),
    );
  }
}