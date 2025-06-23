import 'package:bloc/bloc.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/features/chat_services/chat_service_repo_imp.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'chat_bot_state.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  ChatBotCubit() : super(ChatBotInitial());
  final ApiService apiService = ApiService(dio: Dio());
  Future<void> getChatResponse({required String message}) async {
    emit(ChatBotLoading());
    var response = await ChatServiceRepoImp(apiService: apiService)
        .getChatResponse(message: message);
    response.fold(
      (error) {
        emit(ChatbotError(error: error['error']));
      },
      (success) {
        emit(ChatbotSucess(response: success));
      },
    );
  }
}
