import 'package:shared_preferences/shared_preferences.dart';

// Get the authentication token from SharedPreferences
Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

// Get the email from SharedPreferences
Future<String?> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

// Set the user role in SharedPreferences
Future<void> setRole(String role) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('role', role);
}

Future<void> clearPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
