import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/data/datasources/chatbot_datasource.dart';
import 'package:flutter_application_1/data/repositories/chatbot_repository_impl.dart';
import 'package:flutter_application_1/domain/entities/chat_message.dart';
import 'package:flutter_application_1/domain/repositories/chatbot_repository.dart';
import 'package:flutter_application_1/domain/usecases/send_message_usecase.dart';

// Providers for dependencies
final chatbotDataSourceProvider = Provider<ChatbotDataSource>((ref) {
  return ChatbotDataSource();
});

final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) {
  return ChatbotRepositoryImpl(dataSource: ref.read(chatbotDataSourceProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(repository: ref.read(chatbotRepositoryProvider));
});

// Chatbot state
class ChatbotState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  ChatbotState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Chatbot notifier
class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final SendMessageUseCase _sendMessageUseCase;
  final ChatbotRepository _repository;

  ChatbotNotifier({
    required SendMessageUseCase sendMessageUseCase,
    required ChatbotRepository repository,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _repository = repository,
        super(ChatbotState());

  void initialize() {
    final messages = _repository.getMessages();
    state = state.copyWith(messages: messages);
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      state = state.copyWith(isLoading: true);
      
      await _sendMessageUseCase(message);
      
      final messages = _repository.getMessages();
      state = state.copyWith(
        messages: messages,
        isLoading: false,
        errorMessage: null,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final chatbotProvider = StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  return ChatbotNotifier(
    sendMessageUseCase: ref.read(sendMessageUseCaseProvider),
    repository: ref.read(chatbotRepositoryProvider),
  );
});