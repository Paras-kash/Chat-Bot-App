import 'package:flutter_application_1/data/datasources/chatbot_datasource.dart';
import 'package:flutter_application_1/domain/entities/chat_message.dart';
import 'package:flutter_application_1/domain/repositories/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotDataSource dataSource;
  
  ChatbotRepositoryImpl({required this.dataSource});
  
  @override
  Future<ChatMessage> sendMessage(String message) async {
    return await dataSource.sendMessage(message);
  }
  
  @override
  List<ChatMessage> getMessages() {
    return dataSource.getMessages();
  }
}