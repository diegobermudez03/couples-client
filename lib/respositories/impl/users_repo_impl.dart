

import 'dart:convert';

import 'package:couples_client_app/core/errors/errors.dart';
import 'package:couples_client_app/core/http_client.dart';
import 'package:couples_client_app/respositories/users_repo.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class UsersRepoImpl implements UsersRepo{
  final HttpClient client;
  final String _url;

  UsersRepoImpl(this.client, String url): _url = '$url/users';

  @override
  Future<Tuple2<void, CustomError?>> updatePartnerNickname(String nickname) async{
    return client.sendRequest<void>((headers)async{
      final url = Uri.parse('$_url/partners/nickname');
      final response = await http.patch(
        url, 
        headers: headers,
        body: jsonEncode({
          "nickname" : nickname
        })
      );
      final body = jsonDecode(response.body);
      if(response.statusCode >=400){
        return Tuple2(null, body["error"]);
      }
      return const Tuple2(null, null);
    }, null);
  }
}