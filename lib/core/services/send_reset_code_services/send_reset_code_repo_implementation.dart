import 'package:dartz/dartz.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/core/API/backend_endpoint.dart';
import 'package:diagnosify_app/core/services/send_reset_code_services/send_reset_code_repo.dart';
import 'package:dio/dio.dart';

class SendResetCodeRepoImplementation  extends SendResetCodeRepo{
  final ApiService apiService;

  SendResetCodeRepoImplementation({required this.apiService});
  @override
  Future<Either<Map<String, dynamic>, Map<String, dynamic>>> sendResetCode({required String email})async {
    try{
      var response = await apiService.Post(endpoint: BackendEndpoint.sendResetPasswordEmail, data: {"email" : email},);
      return Right(response);
    }catch(e){
      if(e is DioException){
        return Left({
          'error': e.message ?? 'An error occurred while sending reset code',
          'statusCode': e.response?.statusCode ?? 500,
        });
      }else{
        return Left({
          'error': e.toString(),
          'statusCode': 500,
        });
      }
    }
  }
}