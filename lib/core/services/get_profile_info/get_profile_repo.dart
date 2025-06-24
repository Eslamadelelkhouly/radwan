import 'package:dartz/dartz.dart';

abstract class GetProfileRepo {
  Future<Either<Map<String, dynamic>, Map<String, dynamic>>> getinfoProfile();
}
