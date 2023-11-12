import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:client/admin/admin.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/register.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const String id = "loginscreen";
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> getUser() async {
    final response = await http.get(
      Uri.parse('http://192.168.47.79:3000/getUser'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body);
      bool foundUser = false;
      for (var user in users) {
        String email = user['email'];
        String password = user['password'];
        if (email == 'admin2727@gmail.com' && password == 'admin@2727') {
          foundUser = true;
          Navigator.pushNamed(context, AdminScreen.id);
          break;
        } else if (email == emailController.text &&
            password == passwordController.text) {
          foundUser = true;
          Navigator.pushNamed(context, HomeScreen.id);
          break;
        }
      }
      if (!foundUser) {
        showNoUserDialog();
      }
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  }

  void showNoUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No User Found"),
          content: Text("Please check your email and password."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  bool isEmailValid(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  bool isPasswordValid(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LoginScreen')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isEmailValid(emailController.text) &&
                    isPasswordValid(passwordController.text)) {
                  getUser();
                } else {
                  showNoUserDialog();
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RegisterScreen.id);
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
