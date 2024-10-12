import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_strore/components/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    retrieveUserData();
  }

  Future<void> retrieveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    String? email = prefs.getString('email');

    if (authToken != null && email != null) {
      await fetchUser(authToken, email);
    } else {
      showSnackBar('Auth token or email not found');
    }
  }

  Future<void> fetchUser(String authToken, String email) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        List users = json.decode(response.body)['data'];
        for (var u in users) {
          if (u['email'] == email) {
            setState(() {
              user = u;
            });
            break;
          }
        }
        if (user == null) {
          showSnackBar('User not found');
        }
      } else {
        showSnackBar('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      showSnackBar('Error loading users: $e');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: customAppBar(
        title: 'Orders Page',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Profile',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color:Colors.blueAccent[700],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileCard('Name', user!['name']),
                  _buildProfileCard('Email', user!['email']),
                  _buildProfileCard('Address', user!['address']),
                  _buildProfileCard('Role', user!['role']),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.blueAccent[50],
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent[800],
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent[800],
          ),
        ),
      ),
    );
  }
}
