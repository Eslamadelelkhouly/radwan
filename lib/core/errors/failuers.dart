import 'package:dio/dio.dart';

class Failures {
  final Map<String, dynamic> errorData;
  Failures({required this.errorData});
}

class ServerFailure extends Failures {
  ServerFailure(Map<String, dynamic> errorData) : super(errorData: errorData);

  factory ServerFailure.fromDioException(DioException dioexception) {
    switch (dioexception.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure({
          "message": "Connection timeout with ApiServer",
          "errors": {}
        });
      case DioExceptionType.sendTimeout:
        return ServerFailure({
          "message": "Send timeout with ApiServer",
          "errors": {}
        });
      case DioExceptionType.receiveTimeout:
        return ServerFailure({
          "message": "Receive timeout with ApiServer",
          "errors": {}
        });
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioexception.response!.statusCode!, dioexception.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure({
          "message": "Request to ApiServer was canceled",
          "errors": {}
        });
      default:
        if (dioexception.message?.contains('SocketException') ?? false) {
          return ServerFailure({
            "message": "No Internet Connection",
            "errors": {}
          });
        }
        return ServerFailure({
          "message": "Unexpected Error, please try Again",
          "errors": {}
        });
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure({
        "message": response['message'] ?? "Bad Request",
        "errors": response['errors'] ?? {}
      });
    } else if (statusCode == 404) {
      return ServerFailure({
        "message": "Your request was not found, please try again later",
        "errors": {}
      });
    } else if (statusCode == 422) {
      final errors = response['errors'] as Map<String, dynamic>? ?? {};
      return ServerFailure({
        "message": response['message'] ?? "Validation failed",
        "errors": errors
      });
    } else if (statusCode == 500) {
      return ServerFailure({
        "message": "Internal server error, please try again later",
        "errors": {}
      });
    } else {
      return ServerFailure({
        "message": "Oops, there was an error, please try again",
        "errors": {}
      });
    }
  }
}
