import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  void _submitAuthForm(String email, String username, String password,
      bool isLogin, BuildContext ctx) async {
    setState(() {
      _isLoading = true;
    });
    final _firebaseAuth = FirebaseAuth.instance;
    UserCredential userCredential;

    try {
      if (isLogin) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({'username': username, 'email': email});
        setState(() {
          _isLoading = false;
        });
      }
    } on PlatformException catch (error) {
      var message = 'An Error Occurred, Please Check Your Credentials';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: AuthForm(_submitAuthForm, _isLoading),
      ),
    );
  }
}
