import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_dream2/app/models/user_model.dart';
import 'package:flash_chat_dream2/app/pages/chat/chat_page.dart';
import 'package:flash_chat_dream2/app/widgets/alerts/show_alert_dialog.dart';
import 'package:flash_chat_dream2/app/widgets/progress/progress_widget.dart';
import 'package:flash_chat_dream2/app/widgets/text_fields/text_field_register.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);
  static const String route = 'SignIn';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmControllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isVisible = false;

  Future<void> signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      final _response = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      final _userModel = UserModel.fromJson(_response.data()!);

      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            userModel: _userModel,
          ),
        ),
      );

      log('creadetitial ==> ${credential}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email. ');
        ShowAlertDialogs.showMyDialog('No user found for that email.', context);
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user. ');
        ShowAlertDialogs.showMyDialog(
            'Wrong password provided for that user.', context);
        log('password: ${e.code.length} ');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 20,
    );
    return Scaffold(
      body: _isLoading == true
          ? Center(
              child: circularProgress(),
            )
          : Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldRegisterWidget(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter your email';
                      } else if (value.isValidEmail() == false) {
                        return 'invalid email';
                      } else if (value.isValidEmail() == true) {
                        return null;
                      }
                      return null;
                    },
                    controller: emailController,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.name,
                  ),
                  sizedBox,
                  TextFieldRegisterWidget(
                    obscureText: !_isVisible,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Must be more than 6 charater';
                      }
                      if (value.isValidPassword() == false) {
                        return 'invalid password';
                      }
                      if (value.isValidPassword() == true) {
                        return null;
                      }
                      return null;
                    },
                    controller: passwordController,
                    hintText: 'Enter your password',
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isVisible == true
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                    ),
                  ),
                  sizedBox,
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signIn();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 130, vertical: 12),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\. ])([a-zA-Z]{2,3})$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(r'^([a-zA-Z]{1})([0-9]{5})').hasMatch(this);
  }
}
