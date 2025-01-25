
import 'package:couples_client_app/presentation/auth/bloc/cretae_user_bloc.dart';
import 'package:couples_client_app/presentation/auth/bloc/login_bloc.dart';
import 'package:couples_client_app/presentation/auth/bloc/register_bloc.dart';
import 'package:couples_client_app/presentation/loading/bloc/loading_bloc.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/respositories/impl/auth_repo_impl.dart';
import 'package:couples_client_app/services/localization_services/local_service.dart';
import 'package:couples_client_app/services/preferences/preferences_service.dart';
import 'package:couples_client_app/services/secure_storage/secure_storage_service.dart';
import 'package:couples_client_app/shared/global_variables/tokens_management.dart';
import 'package:get_it/get_it.dart';

final depIn = GetIt.instance; 
const mobileUrl = "http://10.0.2.2:8081/v1";
const webUrl = "http://localhost:8081/v1";
const url = webUrl;

Future<void> initDependencies() async{
  final tokens = TokensManagement();

  // services
  final prefServices = await PreferencesServiceImpl.getPreferences();
  depIn.registerSingleton<PreferencesService>(prefServices);
  depIn.registerSingleton<LocalizationService>(LocalizationServiceImpl(prefServices));
  final SecureStorageService secureStorage = SecureStorageMock();

  //repositories
  final AuthRepo authRepo = AuthRepoImpl(url);

  //providers
  depIn.registerFactory<LoadingBloc>(()=>LoadingBloc(authRepo, secureStorage, tokens)..checkInitialPage());
  depIn.registerFactory<LoginBloc>(()=>LoginBloc(authRepo, secureStorage, tokens));
  depIn.registerFactory<RegisterBloc>(()=>RegisterBloc(authRepo, secureStorage, tokens));
  depIn.registerFactory<CretaeUserBloc>(()=>CretaeUserBloc(authRepo, depIn.get(), tokens, secureStorage));
}