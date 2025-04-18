import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  
  LoginUseCase({required this.repository});
  
  Future<User?> call(String email, String password) async {
    return await repository.login(email, password);
  }
}