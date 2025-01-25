
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/secure_storage/secure_storage_service.dart';
import 'package:couples_client_app/shared/global_variables/tokens_management.dart';
import 'package:couples_client_app/shared/helpers/messages/status_messags.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingBloc extends Cubit<LoadingState>{
  final SecureStorageService _storage;
  final AuthRepo _authRepo;
  final TokensManagement _tokens;

  LoadingBloc(this._authRepo, this._storage, this._tokens): super(LoadingInitialState());


  void checkInitialPage() async{
    final rfToken = await _storage.readValue(refreshTokenKey);
    if(rfToken == null){
      emit(GoToWelcomePage());
      return;
    }
    _tokens.refreshToken = rfToken;
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