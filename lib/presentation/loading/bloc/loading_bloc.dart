
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/secure_storage/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingBloc extends Cubit<LoadingState>{
  final SecureStorageService _storage;
  final AuthRepo _authRepo;

  LoadingBloc(this._authRepo, this._storage): super(LoadingInitialState());


  void checkInitialPage() async{
    final rfToken = await _storage.readValue('refresh_token');
    if(rfToken == null){
      emit(GoToWelcomePage());
      return;
    }
    final status = await _authRepo.getUserStatus(rfToken);
    if(status.item2 != null){
      emit(GoToWelcomePage());
      return;
    }
    switch(status.item1){
      case "there's no user associated":
        emit(GoToUserPageState());
        break;
      case "user has an user associated":
        emit(GoToConnectCouplePageState());
        break;
      case "user has a couple associated":
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