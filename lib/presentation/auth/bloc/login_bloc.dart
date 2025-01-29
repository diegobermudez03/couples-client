import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/shared/global_variables/tokens_management.dart';
import 'package:couples_client_app/core/messages/error_messages.dart';
import 'package:couples_client_app/core/messages/status_messags.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Cubit<LoginState>{

  final AuthRepo _repo;
  final TokensManagement _tokens;

  LoginBloc(this._repo, this._tokens): super(LoginInitialState());

  void login(String email, String password, String device, String os) async{
    emit(LoginCheckingState());
    if(email.isEmpty || password.isEmpty){
      emit(LoginFailedState(LoginErrorMessage.emptyFields));
      return;
    }
    if(!email.contains('@')){
      emit(LoginFailedState(LoginErrorMessage.invalidEmail));
      return;
    }
    final token = await _repo.loginUser(email, password, device, os);
    if(token.item2 != null){
      switch(token.item2!.error){
        case errorNoUserFoundEmail: emit(LoginFailedState(LoginErrorMessage.noUserFoundEmail)); break;
        case errorIncorrectPassword: emit(LoginFailedState(LoginErrorMessage.incorrectPassword)); break;
        default : emit(LoginFailedState(LoginErrorMessage.generalError)); break;
      }
      return;
    }
    //store efresh token
    _tokens.setRefreshToken(token.item1);
    final status = await _repo.getUserStatus(token.item1);
    if(status.item2 !=null){
      emit(LoginFailedState(LoginErrorMessage.generalError));
      return;
    }
    //navigation depending on user state
    switch(status.item1){
      case statusNoUserCreated: emit(LoginSuccessState(LoginNavigateMessage.goToUserCreation)); break;
      case statusUserCreated: emit(LoginSuccessState(LoginNavigateMessage.goToCoupleConnection)); break;
      default: emit(LoginSuccessState(LoginNavigateMessage.goToMainPage)); break;
    }
  }
}


abstract class LoginState{}

class LoginInitialState extends LoginState{}

class LoginCheckingState extends LoginState{}

class LoginFailedState extends LoginState{
  final LoginErrorMessage message;
  LoginFailedState(this.message);
}

class LoginSuccessState extends LoginState{
  final LoginNavigateMessage message;
  LoginSuccessState(this.message);
}


enum LoginErrorMessage{
  emptyFields, invalidEmail, incorrectPassword, generalError, noUserFoundEmail
}

enum LoginNavigateMessage{
  goToUserCreation, goToCoupleConnection, goToMainPage
}