import 'package:client/admin/admin.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/register.dart';
import 'package:client/screens/welcome.dart';
import 'package:client/screens/whyenglish.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        LoginScreen.id:(context)=>const LoginScreen(),
        RegisterScreen.id:(context)=>const RegisterScreen(),
        WhyEnglishScreen.id:(context)=>const WhyEnglishScreen(),
        HomeScreen.id:(context)=>const HomeScreen(),
        AdminScreen.id:(context) =>const AdminScreen(),
        
      },
    );
  }
}