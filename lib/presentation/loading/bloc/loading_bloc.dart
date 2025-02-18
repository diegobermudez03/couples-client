
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/tokens_management.dart';
import 'package:couples_client_app/core/messages/status_messags.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingBloc extends Cubit<LoadingState>{
  final AuthRepo _authRepo;
  final TokensManagement _tokens;

  LoadingBloc(this._authRepo, this._tokens): super(LoadingInitialState());


  void checkInitialPage() async{
    final rfToken = await _tokens.getRefreshToken();
    if(rfToken == null){
      emit(GoToWelcomePage());
      return;
    }
    _tokens.setRefreshToken(rfToken);
    final status = await _authRepo.getUserStatus(rfToken);
    if(status.item2 != null){
      emit(GoToWelcomePage());
      return;
    }
    switch(status.item1){
      case statusNoUserCreated:
        emit(GoToUserPageState());
        break;
      case statusUserCreated:
        emit(GoToConnectCouplePageState());
        break;
      case statusCoupleCreated:
        emit(GoToMainPageState());
        break;
      case statusPartnerWithoutNickname:
        emit(GoToMainPageState());
      default:
        emit(GoToWelcomePage());
        break;
    }
  }
}




abstract class LoadingState{}
class LoadingInitialState extends LoadingState{}

class GoToWelcomePage extends LoadingState{}

class GoToUserPageState extends LoadingState{}

class GoToConnectCouplePageState extends LoadingState{}

class GoToMainPageState extends LoadingState{}

