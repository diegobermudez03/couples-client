import 'package:tuple/tuple.dart';

abstract class AuthRepo{
  Future<Tuple2<String, Error?>> getUserStatus(String refreshToken);
  Future<Tuple2<String, Error?>> loginUser(String email, String password);
}