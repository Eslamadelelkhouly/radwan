import 'package:dartz/dartz.dart';

abstract class ChatServiceRepo {
  Future<Either<Map<String, dynamic>, Map<String, dynamic>>> getChatResponse(
    {required String message}
  );
}
