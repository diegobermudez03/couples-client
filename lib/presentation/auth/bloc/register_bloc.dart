import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/secure_storage/secure_storage_service.dart';
import 'package:couples_client_app/shared/global_variables.dart';
import 'package:couples_client_app/shared/helpers/messages/error_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Cubit<RegisterState>{
  final AuthRepo _repo;
  final SecureStorageService _storage;
  RegisterBloc(this._repo, this._storage): super(RegisterInitialState());

  void register(String email, String password, String passwordVerification, String device, String os) async{
    emit(RegisterCheckingState());
    if(email.isEmpty || password.isEmpty || passwordVerification.isEmpty){
      emit(RegsiterFailedState(RegisterErrorMessage.emptyFields));
      return;
    }
    if(password.length < 6){
      emit(RegsiterFailedState(RegisterErrorMessage.insecurePassword));
    }
    if(password.compareTo(passwordVerification) != 0){
      emit(RegsiterFailedState(RegisterErrorMessage.notEqualsPassword));
      return;
    }
    if(!email.contains('@') || email.contains(' ')){
      emit(RegsiterFailedState(RegisterErrorMessage.invalidEmail));
      return;
    }
    final token = await _repo.registerUser(email, password, device, os);
    if(token.item2 != null){
      switch(token.item2!.error){
        case errorInsecurePassword : emit(RegsiterFailedState(RegisterErrorMessage.insecurePassword));break;
        case errorEmailAlreadyUsed : emit(RegsiterFailedState(RegisterErrorMessage.emailAlreadyUsed));break;
        default : emit(RegsiterFailedState(RegisterErrorMessage.genericError));
      }
      return;
    }
    _storage.writeValue(refreshTokenKey, token.item1);
    GlobalVariables.refreshToken = refreshTokenKey;
    emit(RegisterSuccessState());
  }
}


abstract class RegisterState{}

class RegisterInitialState extends RegisterState{}

class RegisterCheckingState extends RegisterState{}

class RegsiterFailedState extends RegisterState{
  final RegisterErrorMessage message;
  RegsiterFailedState(this.message);
}

class RegisterSuccessState extends RegisterState{}


enum RegisterErrorMessage{
  emptyFields, notEqualsPassword, invalidEmail, insecurePassword, emailAlreadyUsed, genericError
}