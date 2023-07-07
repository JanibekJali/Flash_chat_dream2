import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_dream2/app/models/user_model.dart';
import 'package:flash_chat_dream2/app/pages/chat/chat_page.dart';
import 'package:flash_chat_dream2/app/widgets/alerts/show_alert_dialog.dart';
import 'package:flash_chat_dream2/app/widgets/animations/card_list_item_widget.dart';
import 'package:flash_chat_dream2/app/widgets/animations/circle_list_item_widget.dart';
import 'package:flash_chat_dream2/app/widgets/animations/shimmer_animation_widget.dart';
import 'package:flash_chat_dream2/app/widgets/buttons/register_widget.dart';
import 'package:flash_chat_dream2/app/widgets/text_fields/text_field_register.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    Key? key,
  }) : super(key: key);
  static const String route = 'SignUp';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isVisible = false;
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  TextEditingController confirmControllerPassword = TextEditingController();
  String id = '12345436475dfdgd';
  final _formKey = GlobalKey<FormState>();

  final users = FirebaseFirestore.instance.collection('users');
  final _uid = Uuid().v4();
  Future<void> addUser() {
    final userModel = UserModel(
      email: emailController.text,
      name: nameController.text,
      id: _uid,
    );
    return users
        .add(
          userModel.toJson(),
        )
        .then((value) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    userModel: userModel,
                  ),
                ),
              ),
            })
        .catchError((error) => log("Failed to add user: $error"));
  }

  Future<void> signUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((value) => {
                addUser(),
                FocusScope.of(context).requestFocus(FocusNode()),
                nameController.clear(),
                emailController.clear(),
                passwordController.clear(),
                confirmControllerPassword.clear(),
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        ShowAlertDialogs.showMyDialog(
            'The password provided is too weak.', context);
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        ShowAlertDialogs.showMyDialog(
            'The account already exists for that email.', context);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log('e ==> $e');
    }
  }

  Widget _buildTopRowItem() {
    return ShimmerLoading(
      isLoading: _isLoading,
      child: const CircleListItem(),
    );
  }

  Widget _buildListItem() {
    return ShimmerLoading(
      isLoading: _isLoading,
      child: CardListItem(
        isLoading: _isLoading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 20,
    );
    return Scaffold(
      body: SafeArea(
        child: _isLoading == true
            ? Center(child: _buildListItem())
            : Center(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFieldRegisterWidget(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                            return null;
                          },
                          controller: nameController,
                          hintText: 'Enter your name',
                          onChanged: (value) {},
                          keyboardType: TextInputType.name,
                        ),
                        sizedBox,
                        TextFieldRegisterWidget(
                          validator: (_value) {
                            if (_value!.isEmpty) {
                              return 'please enter your email';
                            } else if (_value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (_value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          controller: emailController,
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        sizedBox,
                        TextFieldRegisterWidget(
                          obscureText: !_isVisible,
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
                          keyboardType: TextInputType.number,
                        ),
                        sizedBox,
                        TextFieldRegisterWidget(
                          obscureText: !_isVisible,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'password does not match correctly!';
                            }
                            return null;
                          },
                          controller: confirmControllerPassword,
                          hintText: 'Confirm your password',
                          onChanged: (value) {},
                          keyboardType: TextInputType.number,
                        ),
                        sizedBox,
                        sizedBox,
                        RegisterWidget(
                            text: 'Sign Up',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                signUp();
                              }
                            }),
                      ],
                    ),
                  ),
                ),
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

// CRUD
// C- create
// Read
// Update
// Delete