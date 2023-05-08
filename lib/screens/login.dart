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
        color: AppColors.mainDark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: RichText(
                text: TextSpan(
                  text: 'Welcome Back!',
                  style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 36),
              child: RichText(
                text: TextSpan(
                  text: 'Login to continue',
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: AppColors.white, fontSize: 14),
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white),),  
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent),),  
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: AppColors.white, fontSize: 14),
                hintText: "Password",
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white),),  
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent),),  
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
              margin: const EdgeInsets.symmetric(vertical: 36),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text('Login', style: TextStyle(color: AppColors.white),)
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account?',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  children: [
                    TextSpan(
                      text: ' Register',
                      style: TextStyle(color: AppColors.accent, fontSize: 14, decoration: TextDecoration.underline),
                    )
                  ]
                ),
              ),
            ),
            RichText(
              text: const TextSpan(
                text: 'Forget password?',
                style: TextStyle(color: Colors.white, fontSize: 14, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}