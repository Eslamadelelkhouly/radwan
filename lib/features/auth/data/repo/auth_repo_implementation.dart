import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/core/API/backend_endpoint.dart';
import 'package:diagnosify_app/core/errors/failuers.dart';
import 'package:diagnosify_app/features/auth/data/model/login_model.dart';
import 'package:diagnosify_app/features/auth/data/model/signup_model.dart';
import 'package:diagnosify_app/features/auth/data/repo/auth_repo.dart';
import 'package:dio/dio.dart';

class AuthRepoImplementation implements AuthRepo {
  final ApiService apiService;

  AuthRepoImplementation({required this.apiService});
  @override
  @override
  @override
  Future<Either<Map<String, dynamic>, SignUpModel>> signUp({
    required String FName,
    required String LName,
    required String nationalid,
    required String phoneNumber,
    required String email,
    required String password,
    required String password_confirmation,
  }) async {
    try {
      var response = await apiService.Post(
        endpoint: BackendEndpoint.endpointregiseter,
        data: {
          "FName": FName,
          "LName": LName,
          "NationailNumber": nationalid,
          "PhoneNumber": phoneNumber,
          "email": email,
          "password": password,
          "password_confirmation": password_confirmation,
        },
      );

      log(response.toString());

      final signUpModel = SignUpModel.fromJson({
        'user': response['user'],
        'access_token': response['token']['access_token'],
        'token_type': response['token']['token_type'],
        'expires_in': response['token']['expires_in'],
      });

      return right(signUpModel);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data is Map<String, dynamic>) {
          log(e.response!.data.toString());
          return left(e.response!.data);
        } else {
          return left({
            "message": "Unknown error occurred",
            "errors": {},
          });
        }
      } else {
        return left({
          "message": "Connection error occurred",
          "errors": {},
        });
      }
    }
  }

  @override
  Future<Either<Map<String, dynamic>, LoginSuccessModel>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      var response = await apiService.Post(
        endpoint: BackendEndpoint.endpointlogin,
        data: {
          "email": email,
          "password": password,
        },
      );

      log(response.toString());

      final loginSuccessModel = LoginSuccessModel.fromJson({
        'user': response['user'],
        'access_token': response['token']['access_token'],
        'token_type': response['token']['token_type'],
        'expires_in': response['token']['expires_in'],
      });

      return right(loginSuccessModel);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data is Map<String, dynamic>) {
          log(e.response!.data.toString());
          return left(e.response!.data);
        } else {
          return left({
            "message": "Unknown error occurred",
            "errors": {},
          });
        }
      } else {
        return left({
          "message": "Connection error occurred",
          "errors": {},
        });
      }
    }
  }
}
