import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:tuple/tuple.dart';

class AuthRepoImpl implements AuthRepo{
  @override
  Future<Tuple2<String, Error?>> getUserStatus(String refreshToken) async{
    return Tuple2("user has a couple associated", null);
  }
  
}