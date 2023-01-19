import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitForm, this.isLoading, {super.key});
  final bool isLoading;
  final void Function(String email, String username, String password,
      File? image, bool isLogin, BuildContext ctx) submitForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _inLoginMode = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _pickedImage;

  void _capturedImage(File? image) {
    _pickedImage = image;
  }

  void _onLoginBtnClick() {
    final _validate = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null && !_inLoginMode) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: const Text(
            'Please Pick an Image',
            style: TextStyle(fontSize: 16),
          )));
      return;
    }

    if (_validate) {
      _formKey.currentState?.save();
      widget.submitForm(_userEmail.trim(), _userName.trim(), _userPassword,
          _pickedImage, _inLoginMode, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_inLoginMode) UserImagePicker(_capturedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value != null) {
                        if (value.trim().isEmpty) {
                          return 'Please Enter Email Address';
                        } else if (!value.contains('@')) {
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                  ),
                  if (!_inLoginMode)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value != null) {
                          if (value.trim().isEmpty) {
                            return 'Please Enter UserName';
                          } else if (value.length < 4) {
                            return 'Please Enter Atleast 4 Characters';
                          }
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value != null) {
                        if (value.trim().isEmpty) {
                          return 'Please Enter password';
                        } else if (value.length < 7) {
                          return 'Please Enter Atleast 7 characters';
                        }
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _onLoginBtnClick,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_inLoginMode ? 'Login' : 'SignUp'),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _formKey.currentState!.reset;
                          setState(() {
                            _inLoginMode = !_inLoginMode;
                          });
                        },
                        child: Text(
                          _inLoginMode
                              ? 'Create New Account'
                              : 'I Already Have An Account',
                        ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
