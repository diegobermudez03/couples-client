import 'dart:convert';

import 'package:couples_client_app/core/errors/errors.dart';
import 'package:couples_client_app/services/tokens_management.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class HttpClient {
  final TokensManagement _token;
  final String _url;

  HttpClient(this._url, this._token);

  Future<Tuple2<T, CustomError?>> sendRequest<T>(Future<Tuple2<T, CustomError?>>Function(Map<String, String>) request, T returnValue) async{
    try{
      if(_token.getAccessToken() == null){
        await _refreshAccessToken();
      }
      Map<String, String> headers = {
        "Bearer" : _token.getAccessToken()!
      };
      return request(headers);
    }catch(error){
      return Tuple2(returnValue,NetworkError());
    }
  }

  Future<bool> _refreshAccessToken()async{
    try{
      final url = Uri.parse('$_url/accessToken');
      final rToken = await _token.getRefreshToken();
      if(rToken == null) return false;

      final response = await http.post(url, body: jsonEncode({
        "refreshToken" : rToken
      }));

      if(response.statusCode >= 400){
        return false;
      }
      final body = jsonDecode(response.body);
      _token.setAccessToken(body["accessToken"]);
      if(body["refreshToken"] != null){
        _token.setRefreshToken(body["refreshToken"]);
      }
      return true;
    }catch(err){
      return false;
    }
  }

}