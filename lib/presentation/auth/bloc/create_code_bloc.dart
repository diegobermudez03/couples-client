import 'dart:convert';

import 'package:couples_client_app/models/temp_couple.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/shared/global_variables/tokens_management.dart';
import 'package:couples_client_app/shared/messages/status_messags.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCodeBloc extends Cubit<CreateCodeState>{
  final AuthRepo _repo;
  final TokensManagement _tokens;
  CreateCodeBloc(this._repo, this._tokens):super(CreateCodeCheckingState());

  void checkExistingCode()async{
    await Future.delayed(Duration(seconds: 1));
    final refreshToken = await _tokens.getRefreshToken();
    final stream = _repo.getTempCoupleFromUser(refreshToken!);
    stream.forEach((data){
      if(data.item2 != null){
        emit(CreateCodeNotExistsState());
      }
      if(data.item1.contains(vinculatedMessage)){
        print("CONNECTED");
        emit(CreateCodeConnectedState());
      }else{
        try{
          final tempCouple = TempCouple.fromJson(jsonDecode(data.item1));
          emit(CreateCodeExistsState(tempCouple));
        }catch(error){}
      }
      //jsonDecode(data);
    });
    emit(CreateCodeNotExistsState());
  }

  void generateCode(DateTime startDate) async{
    //emit(CreateCodeCreatingState());
    await Future.delayed(Duration(seconds: 1));
    emit(CreateCodeExistsState(TempCouple("8541", startDate)));
  }
}


abstract class CreateCodeState{}

class CreateCodeCheckingState extends CreateCodeState{}

class CreateCodeExistsState extends CreateCodeState{
  final TempCouple tempCouple;
  CreateCodeExistsState(this.tempCouple);
}

class CreateCodeNotExistsState extends CreateCodeState{}

class CreateCodeConnectedState extends CreateCodeState{}