part of 'chat_bot_cubit.dart';

@immutable
sealed class ChatBotState {}

final class ChatBotInitial extends ChatBotState {}

final class ChatBotLoading extends ChatBotState {}
final class ChatbotSucess extends ChatBotState {
  Map<String, dynamic> response;
  ChatbotSucess({required this.response});
}
final class ChatbotError extends ChatBotState {
  String error;
  ChatbotError({required this.error});
}

