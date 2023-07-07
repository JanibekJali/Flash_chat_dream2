import 'package:flash_chat_dream2/app/pages/signin/sign_in_page.dart';
import 'package:flash_chat_dream2/app/pages/signup/sign_up_page.dart';
import 'package:flash_chat_dream2/app/widgets/buttons/register_widget.dart';
import 'package:flash_chat_dream2/app/widgets/text_fields/text_field_register.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const String route = '';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 20,
    );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RegisterWidget(
            text: 'Sign In',
            onTap: () {
              Navigator.pushNamed(context, SignInPage.route);
            },
          ),
          sizedBox,
          RegisterWidget(
            text: 'Sign Up',
            onTap: () {
              Navigator.pushNamed(context, SignUpPage.route);
            },
          ),
        ],
      ),
    );
  }
}
