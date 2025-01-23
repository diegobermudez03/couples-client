import 'package:couples_client_app/core/errors/errors.dart';
import 'package:tuple/tuple.dart';

abstract class AuthRepo{
  Future<Tuple2<String, CustomError?>> getUserStatus(String refreshToken);
  Future<Tuple2<String, CustomError?>> loginUser(String email, String password, String device, String os);
  Future<Tuple2<String, CustomError?>> registerUser(String email, String password, String device, String os);
}