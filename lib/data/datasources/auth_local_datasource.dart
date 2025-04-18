import 'dart:convert';
import 'package:flutter_application_1/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _credentialsKey = 'user_credentials';

  Future<UserModel?> login(String email, String password) async {
    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Get stored credentials
    final prefs = await SharedPreferences.getInstance();
    final credentialsString = prefs.getString(_credentialsKey);
    
    if (credentialsString != null) {
      final Map<String, dynamic> credentials = jsonDecode(credentialsString);
      
      // Check if the email exists and password matches
      if (credentials.containsKey(email) && credentials[email] == password) {
        // Get stored user data by email
        final usersString = prefs.getString(_userKey);
        if (usersString != null) {
          final Map<String, dynamic> users = jsonDecode(usersString);
          if (users.containsKey(email)) {
            final userData = users[email];
            final user = UserModel.fromJson(userData);
            
            // Update login status
            await prefs.setBool(_isLoggedInKey, true);
            
            // Save current user for getCurrentUser
            await prefs.setString('current_user', email);
            
            return user;
          }
        }
      }
    }
    
    return null;
  }

  Future<UserModel?> signup(String name, String email, String password) async {
    // Simulate registration delay
    await Future.delayed(const Duration(seconds: 1));
    
    final user = UserModel(
      name: name,
      email: email,
    );
    
    // Save user to local storage
    final prefs = await SharedPreferences.getInstance();
    
    // Store user data by email
    Map<String, dynamic> users = {};
    final usersString = prefs.getString(_userKey);
    
    if (usersString != null) {
      users = jsonDecode(usersString);
    }
    
    users[email] = user.toJson();
    await prefs.setString(_userKey, jsonEncode(users));
    
    // Save credentials for future login
    Map<String, dynamic> credentials = {};
    final credentialsString = prefs.getString(_credentialsKey);
    
    if (credentialsString != null) {
      credentials = jsonDecode(credentialsString);
    }
    
    credentials[email] = password;
    await prefs.setString(_credentialsKey, jsonEncode(credentials));
    
    // Set login status
    await prefs.setBool(_isLoggedInKey, true);
    
    // Save current user for getCurrentUser
    await prefs.setString('current_user', email);
    
    return user;
  }
  
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove('current_user');
    return true;
  }
  
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserEmail = prefs.getString('current_user');
    
    if (currentUserEmail != null) {
      final usersString = prefs.getString(_userKey);
      
      if (usersString != null) {
        final Map<String, dynamic> users = jsonDecode(usersString);
        if (users.containsKey(currentUserEmail)) {
          return UserModel.fromJson(users[currentUserEmail]);
        }
      }
    }
    
    return null;
  }
}