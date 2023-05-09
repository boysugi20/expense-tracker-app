
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

class SubscriptionForm extends StatelessWidget {
  
  final _formKey = GlobalKey<FormState>();
  
  SubscriptionForm({Key? key}) : super(key: key);

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
                const FormTitle(header1: 'Add Subscription', header2: 'Add a new subscription',),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormTextInput(title: 'Name', labelText: 'Subscription name', onSave: (value) {print(value);}),
                      FormTextInput(title: 'Price', labelText: 'Subscription price', isKeypad: true, useThousandSeparator: true, onSave: (value) {print(value);}),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context);
                    }
                  },
                  child: const FormSubmitButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
