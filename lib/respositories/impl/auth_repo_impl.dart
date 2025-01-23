import 'package:couples_client_app/core/errors/errors.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:tuple/tuple.dart';

class AuthRepoImpl implements AuthRepo{
  @override
  Future<Tuple2<String, CustomError?>> getUserStatus(String refreshToken) async{
    return Tuple2("user has a couple associated", null);
  }
  
  @override
  Future<Tuple2<String, CustomError?>> loginUser(String email, String password, String device, String os) async{
    return Tuple2("refresh token here", null);
  }
  
  @override
  Future<Tuple2<String, CustomError?>> registerUser(String email, String password, String device, String os) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
  
}