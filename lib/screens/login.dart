import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/navbar.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        height: MediaQuery.of(context).size.height,
        color: AppColors.neutral,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: 'Hello there!',
                style: TextStyle(color: AppColors.base100, fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'What should I call you?',
                style: TextStyle(color: AppColors.base100, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const _LoginForm(),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 36),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: AppColors.base100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ]),
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some value';
              }
              return null;
            },
            maxLength: 20,
            controller: _emailController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: AppColors.base300, fontSize: 14),
              hintText: "Name",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.base300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent),
              ),
            ),
          ),
          // TextField(
          //   controller: _passwordController,
          //   enableSuggestions: false,
          //   obscureText: _obscureText,
          //   decoration: InputDecoration(
          //     hintStyle: TextStyle(color: AppColors.base300, fontSize: 14),
          //     hintText: "Password",
          //     enabledBorder: UnderlineInputBorder(
          //       borderSide: BorderSide(color: AppColors.base300),
          //     ),
          //     focusedBorder: UnderlineInputBorder(
          //       borderSide: BorderSide(color: AppColors.accent),
          //     ),
          //     suffixIcon: IconButton(
          //       onPressed: () {
          //         setState(() {
          //           _obscureText = !_obscureText;
          //         });
          //       },
          //       icon: Icon(
          //         _obscureText ? Icons.visibility_off : Icons.visibility,
          //         size: 16,
          //         color: Colors.grey,
          //       ),
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              final String name = _emailController.text;
              saveConfiguration('user_name', name);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyBottomNavigationBar()),
              );
            },
            child: Container(
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Enter',
                  style: TextStyle(color: AppColors.base100),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
