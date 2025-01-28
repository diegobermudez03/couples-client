import 'dart:async';
import 'dart:convert';
import 'package:couples_client_app/core/errors/errors.dart';
import 'package:couples_client_app/models/temp_couple.dart';
import 'package:couples_client_app/models/user_model.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/shared/messages/status_messags.dart';
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
  Future<Tuple2<TempCouple?, CustomError?>> getTempCoupleFromUser(String token) async{
    try{
      final url = Uri.parse("$_url/couples/temporal");
      final response = await http.get(
        url,
        headers: {
          "token" : token
        }
      );
      final body = jsonDecode(response.body);
      if(response.statusCode >= 400){
        return Tuple2(null, CustomError(body["error"]));
      }
      final tempCouple = TempCouple.fromJson(body);
      return Tuple2(tempCouple, null);

    }catch(error){
      return Tuple2(null, NetworkError());
    }
  }
  
  @override
  Future<Tuple2<int, CustomError?>> postTempCouple(String token, int startDate) async{
    try{
      final url = Uri.parse("$_url/couples/temporal");
      final response = await http.post(
        url,
        headers: {
          "token" : token
        },
        body: jsonEncode({
          "startDate" : startDate
        })
      );
      final body = jsonDecode(response.body);
      if(response.statusCode >= 400){
        return Tuple2(0, CustomError(body["error"]));
      }
      return Tuple2(body["code"], null);
    }catch(error){
      return Tuple2(0, NetworkError());
    }
  }
  
  @override
  Future<Tuple2<String, CustomError?>> submitCoupleCode(String token, int code) async{
    try{
      final url = Uri.parse("$_url/couples/connect");
      final response = await http.post(
        url,
        headers: {
          "token": token 
        },
        body: jsonEncode({
          "code" : code
        }),
      );
      final body = jsonDecode(response.body);
      if(response.statusCode >= 400){
        return Tuple2("", CustomError(body["error"]));
      }
      return Tuple2(body["accessToken"], null);
    }catch(error){
      return Tuple2("", NetworkError());
    }
  }

  @override
  Stream<Tuple2<String, CustomError?>> connectSSECodeChannel(String token) async*{
    //in case there was a previous opened connection
    final StreamController<Tuple2<String, CustomError?>> controller = StreamController();
    try{
      EventFlux.instance.connect(
        EventFluxConnectionType.get,
        '$_url/couples/temporal/notification', 
        header: {
          'Accept' : 'text/event-stream',
          "token" : token
        },
        onConnectionClose: (){
          /*print("closing streaming from onConnectioNClose");
          controller.close();*/
        },
        onSuccessCallback: (response){
          response?.stream?.listen((data){
            print("data received ${data.data} at ${DateTime.now()}");
            if(data.event.trim() == "close"){
               print("closing streaming from close message");
              EventFlux.instance.disconnect();
              controller.close();
            }
            if(data.data == connectedMessage){
            }
            else{
              controller.add(Tuple2(data.data, null));
            }
          });
        },
        onError: (oops){
          controller.add(Tuple2("", CustomError(oops.message!)));
           print("closing streaming from error");
          controller.close();
          EventFlux.instance.disconnect();
        },
        autoReconnect: true,
        reconnectConfig: ReconnectConfig(
          mode: ReconnectMode.linear,
          maxAttempts: 5,
        )
      );
    }catch(error){
      controller.add(Tuple2("", NetworkError()));
    }
    yield* controller.stream;
  }
  
  @override
  Future<void> disconnectSSE() async{
    await EventFlux.instance.disconnect();
    return;
  }
  
}