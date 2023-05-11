import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

class FormTemplate extends StatelessWidget {
  
  final String header1, header2;
  final Widget formInputs;
  final GlobalKey<FormState> formKey;
  final String? buttonText;
  final Function? onSave;

  const FormTemplate({required this.header1, this.header2 = '', required this.formInputs, required this.formKey, this.buttonText, this.onSave, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.neutralLight,
      padding: EdgeInsets.only(left: 16, right: 16, top: MediaQuery.of(context).viewPadding.top + 24, bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.main,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Icon(Icons.arrow_back, color: AppColors.white,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormTitle(header1: header1, header2: header2,),
                formInputs,
                GestureDetector(
                  onTap: (){
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      onSave!();
                      Navigator.pop(context);
                    }
                  },
                  child: FormSubmitButton(buttonText: buttonText!),
                ),
              ],
            ),
          ),
        ],
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

class FormSubmitButton extends StatelessWidget {

  String buttonText;

  FormSubmitButton({this.buttonText = '', super.key,});

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
          text: TextSpan(text: buttonText.isNotEmpty ? buttonText : 'Save', style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}