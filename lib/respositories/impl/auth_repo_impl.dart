import 'dart:convert';
import 'package:couples_client_app/core/errors/errors.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class AuthRepoImpl implements AuthRepo{
  final String _url;

  AuthRepoImpl(String url): _url = '$url/auth';

  @override
  Future<Tuple2<String, CustomError?>> getUserStatus(String refreshToken) async{
    try{
      final url = Uri.parse('$_url/users/status');
      final response = await http.get(url,
        headers: {
          "token" : refreshToken
        }
      );
      final body = jsonDecode(response.body);
      if(response.statusCode >= 400){
        return Tuple2("", CustomError(body["error"]));
      }
      return Tuple2(body["status"], null);
    }catch(error){
      return Tuple2("", NetworkError());
    }
  }
  
  @override
  Future<Tuple2<String, CustomError?>> loginUser(String email, String password, String device, String os) async{
    try{
      final url = Uri.parse('$_url/login');
      final response = await http.post(url, 
        body: jsonEncode({
          "email" : email,
          "password" : password,
          "device" : device,
          "os" : os,
        })
      );
      final body = jsonDecode(response.body);
      if(response.statusCode >= 400){
        return Tuple2("", CustomError(body["error"]));
      }
      return Tuple2(body["refreshToken"], null);
    }catch(error){
      return Tuple2("", NetworkError());
    }
  }
  
  @override
  Future<Tuple2<String, CustomError?>> registerUser(String email, String password, String device, String os) async{
    try{
      final url = Uri.parse('$_url/register');
      final response = await http.post(url, 
        body: jsonEncode({
          "email" : email,
          "password" : password,
          "device" : device,
          "os" : os,
        })
      );
      final body = jsonDecode(response.body);
      if(response.statusCode >= 400){
        return Tuple2("", CustomError(body["error"]));
      }
      return Tuple2(body["refreshToken"], null);
    }catch(error){
      return Tuple2("", NetworkError());
    }
  }
  
}