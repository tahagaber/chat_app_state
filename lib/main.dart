
import 'package:chat_app_state/view/email_verification_screen.dart';
import 'package:chat_app_state/view/home_screen.dart';
import 'package:chat_app_state/view/sign_in_screen.dart';
import 'package:chat_app_state/view/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.emailVerified ? HomeScreen() : SignInScreen() : SignUpScreen()
       //home: EmailVerificationScreen(),
    );
  }
}