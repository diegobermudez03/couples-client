import 'dart:async';
import 'package:couples_client_app/core/utils/functions.dart';
import 'package:couples_client_app/models/temp_couple.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/tokens_management.dart';
import 'package:couples_client_app/core/messages/status_messags.dart';
import 'package:couples_client_app/core/messages/error_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCodeBloc extends Cubit<CreateCodeState>{
  final AuthRepo _repo;
  final TokensManagement _tokens;
  StreamSubscription? _streamSubscription;
  CreateCodeBloc(this._repo, this._tokens):super(CreateCodeCheckingState());

  void checkExistingCode()async{
    final refreshToken = await _tokens.getRefreshToken();
    final response = await _repo.getTempCoupleFromUser(refreshToken!);
    if(response.item2 != null){
      emit(CreateCodeNotExistsState());
      return;
    }
    emit(CreateCodeExistsState(response.item1!));
    _connectSSE(refreshToken);
  }

  void generateCode(DateTime startDate) async{
    final refreshToken = await _tokens.getRefreshToken();
    final response = await _repo.postTempCouple(refreshToken!, dateToUnix(startDate));
    if(response.item2 != null){
      switch(response.item2!.error){
        case errorNoActiveUser: emit(CreateCodeFailedState(CreateCodeErrorMessages.noActiveUser));break;
        case errorCantCreateNewCouple: emit(CreateCodeFailedState(CreateCodeErrorMessages.alreadyHasCouple)); break;
        default : emit(CreateCodeFailedState(CreateCodeErrorMessages.generalError)); break;
      }
      return;
    }
    emit(CreateCodeExistsState(TempCouple(response.item1.toString().trim(), startDate)));
    _connectSSE(refreshToken);
  }

  void _connectSSE(String token) async{
    _streamSubscription?.cancel();
    await _repo.disconnectSSE();
    final stream = _repo.connectSSECodeChannel(token);
    //in case there was a previous active connection we disconnect it
    _streamSubscription = stream.listen((data){
      if(data.item2 != null){
        _streamSubscription?.cancel();
        _streamSubscription = null;
        _repo.disconnectSSE();
      }else if(data.item1.trim() == partnerVinculatedMessage){
        emit(CreateCodeConnectedState());
        _streamSubscription?.cancel();
        _streamSubscription = null;
        _repo.disconnectSSE();
      }
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _repo.disconnectSSE();
    return super.close();
  }
}


abstract class CreateCodeState{}

class CreateCodeCheckingState extends CreateCodeState{}

class CreateCodeExistsState extends CreateCodeState{
  final TempCouple tempCouple;
  CreateCodeExistsState(this.tempCouple);
}

class CreateCodeFailedState extends CreateCodeState{
  final CreateCodeErrorMessages message;
  CreateCodeFailedState(this.message);
}

class CreateCodeNotExistsState extends CreateCodeState{}

class CreateCodeConnectedState extends CreateCodeState{}


enum CreateCodeErrorMessages{
  generalError, noActiveUser, alreadyHasCouple
}