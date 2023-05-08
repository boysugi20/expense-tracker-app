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
              margin: const EdgeInsets.symmetric(vertical: 36),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: AppColors.white,
                boxShadow:  [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(2, 2), // changes position of shadow
                  ),
                ]
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                      hintText: "Email",
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey),),  
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent),),  
                    ),
                  ),
                  TextField(
                    enableSuggestions: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                      hintText: "Password",
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey),),  
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent),),  
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Login logic here
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyBottomNavigationBar()),
                      );
                    },
                    child:Container(
                      margin: const EdgeInsets.only(top: 32),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text('Login', style: TextStyle(color: AppColors.white),)
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Register',
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