import 'package:flutter_application_1/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> signup(String name, String email, String password);
  Future<bool> logout();
  Future<bool> isLoggedIn();
  Future<User?> getCurrentUser();
}