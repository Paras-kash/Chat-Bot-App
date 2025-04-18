import 'package:flutter_application_1/domain/entities/chat_message.dart';
import 'package:flutter_application_1/domain/repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;
  
  SendMessageUseCase({required this.repository});
  
  Future<ChatMessage> call(String message) async {
    return await repository.sendMessage(message);
  }
}