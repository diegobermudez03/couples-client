
import 'package:couples_client_app/presentation/auth/bloc/login_bloc.dart';
import 'package:couples_client_app/presentation/auth/bloc/register_bloc.dart';
import 'package:couples_client_app/presentation/loading/bloc/loading_bloc.dart';
import 'package:couples_client_app/respositories/auth_repo.dart';
import 'package:couples_client_app/respositories/impl/auth_repo_impl.dart';
import 'package:couples_client_app/services/localization_services/local_service.dart';
import 'package:couples_client_app/services/preferences/preferences_service.dart';
import 'package:couples_client_app/services/secure_storage/secure_storage_service.dart';
import 'package:get_it/get_it.dart';

final depIn = GetIt.instance; 

const url = "http://localhost:8081";

Future<void> initDependencies() async{
  // services
  final prefServices = await PreferencesServiceImpl.getPreferences();
  depIn.registerSingleton<PreferencesService>(prefServices);
  depIn.registerSingleton<LocalizationService>(LocalizationServiceImpl(prefServices));
  final SecureStorageService secureStorage = SecureStorageMock();

  //repositories
  final AuthRepo authRepo = AuthRepoImpl();

  //providers
  depIn.registerFactory<LoadingBloc>(()=>LoadingBloc(authRepo, secureStorage)..checkInitialPage());
  depIn.registerFactory<LoginBloc>(()=>LoginBloc(authRepo, secureStorage));
  depIn.registerFactory<RegisterBloc>(()=>RegisterBloc(authRepo, secureStorage));
}