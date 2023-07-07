import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_dream2/app/pages/register/register_page.dart';
import 'package:flutter/material.dart';

import 'app/pages/chat/chat_page.dart';
import 'app/pages/signin/sign_in_page.dart';
import 'app/pages/signup/sign_up_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RegisterPage.route,
      routes: {
        RegisterPage.route: (context) => const RegisterPage(),
        SignUpPage.route: (context) => const SignUpPage(),
        SignInPage.route: (context) => SignInPage(),
      },
    );
  }
}
