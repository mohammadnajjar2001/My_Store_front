// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_strore/components/buttonloginORsingup.dart';
import 'package:my_strore/components/custom_app_bar.dart';
import 'package:my_strore/components/logo.dart';
import 'package:my_strore/components/textformfiled.dart';
import 'package:my_strore/components/loginORsingup.dart';
import 'package:my_strore/components/textformfiledPasswrd.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _addressController =
      TextEditingController(); // حقل العنوان الجديد

  String _errorMessage = '';

  Future<void> _signUp() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'password_confirmation': _passwordConfirmationController.text,
        'address': _addressController.text, // إرسال العنوان
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
      setState(() {
        _errorMessage = 'Failed to sign up: ${response.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'sing up',
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            const Logo(),
            const Desc(
                heder: "Sign Up", desc: "Sign up to continue using the app"),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red), // تعديل اللون هنا
                ),
              ),
            Container(height: 12),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "User Name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple, // تعديل اللون هنا
                ),
              ),
            ),
            Container(height: 8),
            CustomTextFormField(
              hintText: "Username",
              controller: _usernameController,
            ),
            Container(height: 12),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple, // تعديل اللون هنا
                ),
              ),
            ),
            Container(height: 8),
            CustomTextFormField(
              hintText: "Email",
              controller: _emailController,
            ),
            Container(height: 12),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple, // تعديل اللون هنا
                ),
              ),
            ),
            Container(height: 8),
            CustomTextFormFieldPassword(
              hintText: "Password",
              controller: _passwordController,
            ),
            Container(height: 12),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Confirm Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple, // تعديل اللون هنا
                ),
              ),
            ),
            Container(height: 8),
            CustomTextFormFieldPassword(
              hintText: "Confirm Password",
              controller: _passwordConfirmationController,
            ),
            Container(height: 12),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Address",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple, // تعديل اللون هنا
                ),
              ),
            ),
            Container(height: 8),
            CustomTextFormField(
              hintText: "Address",
              controller: _addressController,
            ),
            Container(height: 35),
            ButtonLoginORSingup(
              text: "Sign Up",
              onPressed: _signUp,
              // Optional: you can pass color here if you want to customize the button color
            ),
            Container(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: "Have An Account? "),
                  TextSpan(
                      text: "Login",
                      style: TextStyle(color: Colors.red)), // تعديل اللون هنا
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
