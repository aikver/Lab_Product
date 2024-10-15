import 'dart:convert';
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testlab/models/user_models.dart';
import 'package:testlab/providers/usar_providers.dart';
import 'package:testlab/varbles.dart';
import 'package:http/http.dart' as http;
class AuthService {
  // Login method
  Future<UserModel?> login(String username, String password) async {
    print(username);
    final response = await http.post(
      Uri.parse("$apiURL/api/auth/login"), // Adjust URL as needed
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'user_name': username,
        'password': password,
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Register method
Future<void> register(String username, String password, String name, String role) async {
    final response = await http.post(
      Uri.parse("$apiURL/api/auth/register"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'user_name': username,
        'password': password,
        'name': name,
        'role': role,
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context as BuildContext, '/login');
    } else {
      print('Registration failed');
    }
  }

  Future<void> refreshToken(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/refresh"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userProvider.refreshToken}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);

      final accessToken = data['accessToken'];
      userProvider.updateAccessToken(accessToken); // แก้ไขให้รับแค่ accessToken
    } else if (response.statusCode == 401) {
      final accessToken = "";
      userProvider.updateAccessToken(accessToken); // แก้ไขให้รับแค่ accessToken
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}