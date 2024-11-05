// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_strore/components/custom_app_bar.dart';
import 'package:my_strore/components/textformfiledPasswrd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_strore/components/buttonloginORsingup.dart';
import 'package:my_strore/components/logo.dart';
import 'package:my_strore/components/textformfiled.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    ScaffoldMessenger.of(context).clearSnackBars();

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final String token = jsonResponse['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      await prefs.setString('email', _emailController.text);

      Navigator.of(context).pushReplacementNamed("/home");
    } else {
      String errorMessage;
      switch (response.statusCode) {
        case 400:
          errorMessage = 'Bad request. Please check your input.';
          break;
        case 401:
          errorMessage = 'Unauthorized. Please check your email and password.';
          break;
        case 500:
          errorMessage = 'Server error. Please try again later.';
          break;
        default:
          errorMessage = 'Email and password are incorrect.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Login',
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Logo(),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back\nLogin To Your Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  hintText: "Email",
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                CustomTextFormFieldPassword(
                  hintText: "Password",
                  controller: _passwordController,
                ),
                const SizedBox(height: 40),
                ButtonLoginORSingup(
                  text: "Login",
                  onPressed: _login,
                  buttonColor: Colors.deepPurpleAccent, // تخصيص لون الزر
                  textColor: Colors.white, // تخصيص لون النص
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("/signup");
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't Have An Account? ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: Color.fromARGB(255, 222, 177, 41),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
