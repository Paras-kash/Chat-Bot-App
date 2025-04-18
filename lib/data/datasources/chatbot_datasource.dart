import 'package:flutter_application_1/domain/entities/chat_message.dart';

class ChatbotDataSource {
  final List<ChatMessage> _messages = [];

  Future<ChatMessage> sendMessage(String message) async {
    // Add user message
    final userMessage = ChatMessage(
      text: message,
      type: MessageType.user,
    );
    _messages.add(userMessage);
    
    // Simulate bot response after a short delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Create a simple bot response
    final botMessage = ChatMessage(
      text: _generateBotResponse(message),
      type: MessageType.bot,
    );
    _messages.add(botMessage);
    
    return botMessage;
  }

  List<ChatMessage> getMessages() {
    return List.from(_messages);
  }
  
  String _generateBotResponse(String message) {
    // Very simple response generation
    final messageLower = message.toLowerCase();
    
    if (messageLower.contains('hello') || messageLower.contains('hi')) {
      return 'Hello there! How can I help you today?';
    } else if (messageLower.contains('help')) {
      return 'I\'m here to help! What do you need assistance with?';
    } else if (messageLower.contains('bye') || messageLower.contains('goodbye')) {
      return 'Goodbye! Have a great day!';
    } else if (messageLower.contains('thank')) {
      return 'You\'re welcome!';
    } else {
      return 'I understand you said: "$message". How can I assist you further?';
    }
  }
}