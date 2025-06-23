import 'package:dartz/dartz.dart';

abstract class SendResetCodeRepo {

  Future<Either<Map<String, dynamic>, Map<String, dynamic>>> sendResetCode({
    required String email,
  });
}