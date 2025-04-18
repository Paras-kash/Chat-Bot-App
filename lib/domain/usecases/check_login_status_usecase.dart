import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

class CheckLoginStatusUseCase {
  final AuthRepository repository;
  
  CheckLoginStatusUseCase({required this.repository});
  
  Future<bool> call() async {
    return await repository.isLoggedIn();
  }
}