import 'package:flutter_application_1/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource dataSource;
  
  AuthRepositoryImpl({required this.dataSource});
  
  @override
  Future<User?> login(String email, String password) async {
    return await dataSource.login(email, password);
  }
  
  @override
  Future<User?> signup(String name, String email, String password) async {
    return await dataSource.signup(name, email, password);
  }
  
  @override
  Future<bool> logout() async {
    return await dataSource.logout();
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await dataSource.isLoggedIn();
  }
  
  @override
  Future<User?> getCurrentUser() async {
    return await dataSource.getCurrentUser();
  }
}