import 'package:flutter_application_1/domain/entities/user.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;
  
  SignupUseCase({required this.repository});
  
  Future<User?> call(String name, String email, String password) async {
    return await repository.signup(name, email, password);
  }
}