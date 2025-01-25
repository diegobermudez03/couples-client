import 'package:couples_client_app/models/user_model.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/services/localization_services/local_service.dart';
import 'package:couples_client_app/services/secure_storage/secure_storage_service.dart';
import 'package:couples_client_app/shared/global_variables/tokens_management.dart';
import 'package:couples_client_app/shared/helpers/messages/error_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CretaeUserBloc extends Cubit<CreateUserState>{
  final AuthRepo _repo;
  final LocalizationService _localService;
  final TokensManagement _tokens;
  final SecureStorageService _storage;

  CretaeUserBloc(this._repo, this._localService, this._tokens, this._storage):super(CreateUserInitialState());

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
    final token = await _repo.createUser(
      UserModel(firstName, lastName, enumGender, codes[0], codes[1], birthDate),
      _tokens.refreshToken
    );
    if(token.item2 != null){
      switch(token.item2!.error){
        case errorUserForAccountAlreadyExists : emit(CreateUserFailedState(CreateUserErrorMessage.userAlreadyHasAccount)); break;
        case errorTooYoung : emit(CreateUserFailedState(CreateUserErrorMessage.tooYoung)); break;
        default : emit(CreateUserFailedState(CreateUserErrorMessage.generalError)); break;
      }
      return;
    }
    _tokens.refreshToken = token.item1;
    _storage.writeValue(refreshTokenKey, token.item1);
    emit(CreateUserSuccessState());
  }

  void logout() async{
    emit(CreateUserLogoutState());
    _repo.logoutSession(_tokens.refreshToken);
    _storage.deleteValue(refreshTokenKey);
    _tokens.refreshToken = null;
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