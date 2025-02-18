import 'package:couples_client_app/core/errors/errors.dart';
import 'package:tuple/tuple.dart';

abstract class UsersRepo {
  Future<Tuple2<void, CustomError?>> updatePartnerNickname(String nickname);
}