import 'package:couples_client_app/models/user_model.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/localization_services/local_service.dart';
import 'package:couples_client_app/shared/global_variables/tokens_management.dart';
import 'package:couples_client_app/core/messages/error_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserBloc extends Cubit<CreateUserState>{
  final AuthRepo _repo;
  final LocalizationService _localService;
  final TokensManagement _tokens;

  CreateUserBloc(this._repo, this._localService, this._tokens):super(CreateUserInitialState());

  void createUser(String firstName, String lastName, DateTime? birthDate, bool? male) async{
    emit(CreateUserLoadingState());
    if(firstName.isEmpty || birthDate == null || male  == null){
      emit(CreateUserFailedState(CreateUserErrorMessage.emptyFields));
      return;
    }
    final Gender enumGender = male ? Gender.male : Gender.female;
    final codes = await Future.wait([
      _localService.getCountry(),
      _localService.getLanguage()
    ]);
    final refreshToken = await _tokens.getRefreshToken();
    final token = await _repo.createUser(
      UserModel(firstName, lastName, enumGender, codes[0], codes[1], birthDate),
      refreshToken
    );
    if(token.item2 != null){
      switch(token.item2!.error){
        case errorUserForAccountAlreadyExists : emit(CreateUserFailedState(CreateUserErrorMessage.userAlreadyHasAccount)); break;
        case errorTooYoung : emit(CreateUserFailedState(CreateUserErrorMessage.tooYoung)); break;
        default : emit(CreateUserFailedState(CreateUserErrorMessage.generalError)); break;
      }
      return;
    }
    _tokens.setRefreshToken(token.item1);
    emit(CreateUserSuccessState());
  }

  void logout() async{
    emit(CreateUserLogoutState());
    _repo.logoutSession(await _tokens.getRefreshToken());
    _tokens.deleteRefreshToken();
  }
}


abstract class CreateUserState{}

class CreateUserInitialState extends CreateUserState{}

class CreateUserLogoutState extends CreateUserState{}

class CreateUserLoadingState extends CreateUserState{}

class CreateUserSuccessState extends CreateUserState{}

class CreateUserFailedState extends CreateUserState{
  final CreateUserErrorMessage message;
  CreateUserFailedState(this.message);
}


enum CreateUserErrorMessage{
  emptyFields, userAlreadyHasAccount, tooYoung, generalError
}