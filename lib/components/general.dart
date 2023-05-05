import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  
  final String text;
  final bool firstChild;

  const SectionTitle({required this.text, this.firstChild = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: firstChild?const EdgeInsets.only(bottom: 12):const EdgeInsets.only(bottom: 12, top: 24),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}
