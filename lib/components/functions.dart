import 'package:expense_tracker/screens/modal_category.dart';
import 'package:flutter/material.dart';

import '../screens/modal_amount.dart';

void openBottomModalCategory(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return BottomModalCategory();
    }
  );
}

void openBottomModalAmmount(BuildContext context, String categoryText) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return BottomModalAmmount(categoryText: categoryText,);
    }
  );
}