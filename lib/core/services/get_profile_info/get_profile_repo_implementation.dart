import 'package:dartz/dartz.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/core/API/backend_endpoint.dart';
import 'package:diagnosify_app/core/services/get_profile_info/get_profile_repo.dart';
import 'package:dio/dio.dart';

class GetProfileRepoImplementation  extends GetProfileRepo{
  final ApiService apiService;

  GetProfileRepoImplementation({required this.apiService});
  @override
  Future<Either<Map<String, dynamic>, Map<String, dynamic>>> getinfoProfile() async{
    try{
      var response = await apiService.GetNew(endpoint: BackendEndpoint.getProfile);
      return Right(response);
    }catch(e){
      if(e is DioException){
        return Left({
          'error': e.message ?? 'An error occurred while fetching profile info',
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