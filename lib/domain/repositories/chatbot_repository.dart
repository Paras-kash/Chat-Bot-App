import 'package:flutter_application_1/domain/entities/chat_message.dart';

abstract class ChatbotRepository {
  Future<ChatMessage> sendMessage(String message);
  List<ChatMessage> getMessages();
}