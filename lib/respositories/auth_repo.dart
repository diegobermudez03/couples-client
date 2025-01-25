import 'package:couples_client_app/core/errors/errors.dart';
import 'package:couples_client_app/models/user_model.dart';
import 'package:tuple/tuple.dart';

abstract class AuthRepo{
  Future<Tuple2<String, CustomError?>> getUserStatus(String refreshToken);
  Future<Tuple2<String, CustomError?>> loginUser(String email, String password, String device, String os);
  Future<Tuple2<String, CustomError?>> registerUser(String email, String password, String device, String os);
  Future<Tuple2<String, CustomError?>> createUser(UserModel user, String? token);
  Future<Tuple2<void, CustomError?>> logoutSession(String? token);
}