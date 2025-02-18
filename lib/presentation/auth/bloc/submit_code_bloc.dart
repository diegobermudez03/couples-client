import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/tokens_management.dart';
import 'package:couples_client_app/core/messages/error_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitCodeBloc extends Cubit<SubmitCodeState>{
  final AuthRepo _repo;
  final TokensManagement _tokens;
  SubmitCodeBloc(this._repo, this._tokens): super(SubmitCodeInitialState());

  void submitCode(String code) async{
    emit(SubmitCodeLoading());
    final refreshToken = await _tokens.getRefreshToken();
    int codeParsed;
    try{
      codeParsed = int.parse(code);
    }catch(error){
      emit(SubmitCodeFailed(SubmitCodeErrorMessage.onlyDigits));
      return;
    }
    final response = await _repo.submitCoupleCode(refreshToken!, codeParsed);
    if(response.item2 != null){
      switch(response.item2!.error){
        case errCantConnectWithYourself: emit(SubmitCodeFailed(SubmitCodeErrorMessage.cantVinculateWithYourself)); break;
        case errorCantCreateNewCouple: emit(SubmitCodeFailed(SubmitCodeErrorMessage.alreadyHasCouple)); break;
        case errNonExistingCode: emit(SubmitCodeFailed(SubmitCodeErrorMessage.nonExistingCode)); break;
        default :  emit(SubmitCodeFailed(SubmitCodeErrorMessage.generalError)); break;
      }
      return;
    }
    _tokens.setAccessToken(response.item1);
    emit(SubmitCodeSuccess());
  }
}


abstract class SubmitCodeState{}

class SubmitCodeInitialState extends SubmitCodeState{}

class SubmitCodeSuccess extends SubmitCodeState{}

class SubmitCodeLoading extends SubmitCodeState{}

class SubmitCodeFailed extends SubmitCodeState{
  final SubmitCodeErrorMessage message;
  SubmitCodeFailed(this.message); 
}

enum SubmitCodeErrorMessage{
  generalError, onlyDigits, alreadyHasCouple, nonExistingCode, cantVinculateWithYourself
}