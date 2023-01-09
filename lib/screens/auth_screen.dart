import 'package:chat_app/widgets/auth_form.dart';
import 'package:flutter/material.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _submitAuthForm(String email,String username,String password,bool isLogin){
    print("object = $isLogin");
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: AuthForm(_submitAuthForm),
      ),
    );
  }
}