import 'package:dartz/dartz.dart';
import 'package:diagnosify_app/core/errors/failuers.dart';
import 'package:diagnosify_app/features/auth/data/model/login_model.dart';
import 'package:diagnosify_app/features/auth/data/model/signup_model.dart';

abstract class AuthRepo {
  Future<Either<Map<String,dynamic>, SignUpModel>> signUp({
    required String FName,
    required String LName,
    required String nationalid,
    required String phoneNumber,
    required String email,
    required String password,
    required String password_confirmation,
  });
  Future<Either<Map<String,dynamic>, LoginSuccessModel>> logIn({
    required String email,
    required String password,
  });
}
