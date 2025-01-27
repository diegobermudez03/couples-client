import 'dart:async';
import 'dart:convert';
import 'package:couples_client_app/core/errors/errors.dart';
import 'package:couples_client_app/models/user_model.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:eventflux/eventflux.dart';


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
        }),
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
  Future<Tuple2<String, CustomError?>> createUser(UserModel user, String? token) async{
    try{
      final url = Uri.parse('$_url/users');
      final Map<String, String> headers = {};
      if(token != null){
        headers["token"] = token;
      }
      final response = await http.post(
        url,
        body: jsonEncode(user.toJSON()),
        headers: headers
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
  Future<Tuple2<void, CustomError?>> logoutSession(String? token) async{
    try{
      if(token == null){
        return const Tuple2(null, null);
      }
      final url = Uri.parse('$_url/users/logout');
      final response = await http.delete(url, headers: {
        "token" : token
      });
      final body = jsonDecode(response.body);
      if(response.statusCode >= 400){
        return Tuple2(null, CustomError(body["error"]));
      }
      return const Tuple2(null, null);
    }catch(error){
      return Tuple2(null, NetworkError());
    }
  }
  
  @override
  Stream<Tuple2<String, CustomError?>> getTempCoupleFromUser(String token) async*{
    final StreamController<Tuple2<String, CustomError?>> controller = StreamController();
    try{
      bool first = true;
      EventFlux.instance.connect(
        EventFluxConnectionType.get,
        '$_url/couples/temporal', 
        header: {
          'Accept' : 'text/event-stream',
          "token" : token
        },
        onSuccessCallback: (response){
          response?.stream?.listen((data){
            controller.add(Tuple2(data.data, null));
            if (!first){
              EventFlux.instance.disconnect();
            }
            if (first) first = false;
          });
        },
        onError: (oops){
          return Tuple2(null, CustomError(oops.message!));
        },
        autoReconnect: false,
        /*reconnectConfig: ReconnectConfig(
          mode: ReconnectMode.linear,
          interval: const Duration(seconds: 5),
          maxAttempts: 5
        )*/
      );
    }catch(error){
      controller.add(Tuple2("", NetworkError()));
    }
    yield* controller.stream;
  }
  
  @override
  Future<Tuple2<Stream<String>, CustomError?>> postTempCouple(String token, DateTime startDate) {
    // TODO: implement postTempCouple
    throw UnimplementedError();
  }
  
  @override
  Future<Tuple2<String, CustomError?>> submitCoupleCode(String token, int code) {
    // TODO: implement submitCoupleCode
    throw UnimplementedError();
  }
  
}