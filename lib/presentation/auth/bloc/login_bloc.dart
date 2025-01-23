import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/secure_storage/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Cubit<LoginState>{

  final AuthRepo _repo;
  final SecureStorageService _storage;

  LoginBloc(this._repo, this._storage): super(LoginInitialState());

  void login(String email, String password) async{
    emit(LoginCheckingState());
    if(email.isEmpty || password.isEmpty){
      emit(LoginFailedState(LoginMessage.emptyFields));
      return;
    }
    if(!email.contains('@')){
      emit(LoginFailedState(LoginMessage.nonExistingEmail));
      return;
    }
    await Future.delayed(Duration(seconds: 2));
    emit(LoginSuccessState());
  }


}


abstract class LoginState{}

class LoginInitialState extends LoginState{}

class LoginCheckingState extends LoginState{}

class LoginFailedState extends LoginState{
  final LoginMessage message;
  LoginFailedState(this.message);
}

class LoginSuccessState extends LoginState{}


enum LoginMessage{
  emptyFields, nonExistingEmail, incorrectPassword, networkError
}