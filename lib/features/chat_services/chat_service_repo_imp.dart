import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart'; // مهم علشان نستخدم DioException
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/features/chat_services/chat_service_repo.dart';
import 'package:diagnosify_app/features/chat_services/end_point_chatbot.dart';

class ChatServiceRepoImp implements ChatServiceRepo {
  final ApiService apiService;

  ChatServiceRepoImp({required this.apiService});

  @override
  Future<Either<Map<String, dynamic>, Map<String, dynamic>>> getChatResponse({
    required String message,
  }) async {
    try {
      final response = await apiService.Post(
        endpoint: EndPointChatbot.baseUrl,
        data: {
          'message': message,
        },
      );
      log('Response: $response');
      return right(response);
    } catch (e) {
      if (e is DioException) {
        log('DioException: ${e.message}');
        print('Dio error type: ${e.type}');
        print('Dio error message: ${e.message}');
        print('Dio response: ${e.response}');
        print('Dio request options: ${e.requestOptions}');
        return left({
          'error': e.response?.data['error'] ??
              e.message ??
              'Request failed with no error message',
        });
      } else {
        log('Unknown error: $e');
        return left({
          'error': e.toString(),
        });
      }
    }
  }
}
